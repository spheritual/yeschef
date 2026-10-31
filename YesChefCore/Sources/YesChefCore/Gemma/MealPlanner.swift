import Foundation

public struct MealPlanner: Sendable {
    public static let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    private let model: any LanguageModel
    // Retrieval over the bundled Gutenberg cookbooks; nil runs the planner on Gemma alone.
    public let cookbook: Cookbook?

    public init(model: any LanguageModel, cookbook: Cookbook? = Cookbook.bundled) {
        self.model = model
        self.cookbook = cookbook
    }

    func references(for query: String, limit: Int) -> [Cookbook.Passage] {
        cookbook?.search(query, limit: limit) ?? []
    }

    // Gemma proposes ideas, the hard rules drop anything a member must avoid, and the household's
    // preference models rank what's left, as in .plans/feedback-learning-spec.md.
    public func planWeek(
        for household: Household,
        days: [String] = MealPlanner.weekdays,
        busyDays: Set<String> = [],
        learning: [PreferenceModel] = [],
        ideasPerDay: Int = 3
    ) async throws -> WeekPlan {
        let tastes = household.members.flatMap { $0.likes + [$0.diet ?? ""] }.joined(separator: " ")
        let passages = references(for: tastes.isEmpty ? "chicken soup vegetables" : tastes, limit: 6)
            .filter { passage in household.bannedTerms.allSatisfy { !HardRules.mentions(passage.text, $0.lowercased()) } }
        let reply = try await askJSON(WeekReply.self, prompt: Prompts.week(household, days: days, busyDays: busyDays, ideasPerDay: ideasPerDay, references: passages))
        var rng = SystemRandomNumberGenerator()
        let planned: [WeekPlan.Day] = reply.days.compactMap { day in
            let safe = HardRules.excluding(day.ideas.map(\.idea), ingredients: \.ingredients, banned: household.bannedTerms)
            let context = DayContext(isBusy: busyDays.contains(day.day))
            let ranked = Recommender.rank(safe, features: { FeatureEncoder.encode($0.features, on: context) }, models: learning, using: &rng)
            guard let first = ranked.first else { return nil }
            return WeekPlan.Day(day: day.day, isBusy: context.isBusy, pick: first.item, alternatives: ranked.dropFirst().map(\.item))
        }
        guard !planned.isEmpty else { throw GemmaError.noSafeIdeas }
        return WeekPlan(days: planned)
    }

    public func recipe(for idea: DinnerIdea, household: Household, servings: Int = 4) async throws -> RecipeDetail {
        let passages = references(for: idea.title + " " + (idea.source ?? ""), limit: 2)
        let recipe = try await askJSON(RecipeDetail.self, prompt: Prompts.recipe(idea, household: household, servings: servings, references: passages))
        try Self.checkSafe(recipe, household: household)
        return recipe
    }

    public func recipeFromImage(_ image: Data, mimeType: String = "image/jpeg", household: Household) async throws -> RecipeDetail {
        let recipe = try await askJSON(RecipeDetail.self, prompt: Prompts.fromImage, image: image, mimeType: mimeType)
        try Self.checkSafe(recipe, household: household)
        return recipe
    }

    public func askChef(_ question: String, step: RecipeDetail.Step? = nil, recipe: RecipeDetail? = nil) async throws -> String {
        let passages = references(for: question + " " + (recipe?.title ?? ""), limit: 2)
        return try await model.generate(prompt: Prompts.question(question, step: step, recipe: recipe, references: passages), system: Prompts.chef, image: nil, imageMIMEType: "image/jpeg")
    }

    // Answers the cook and picks up a plan change when they decide on something else. A change
    // for a day that isn't planned, or one naming a banned ingredient, is dropped. If Gemma can't
    // manage the JSON, the cook still gets a plain answer.
    public func reply(to message: String, plan: WeekPlan, household: Household, step: RecipeDetail.Step? = nil, recipe: RecipeDetail? = nil) async throws -> ChefReply {
        let passages = references(for: message + " " + (recipe?.title ?? ""), limit: 2)
        let decoded: ChefReplyJSON
        do {
            decoded = try await askJSON(ChefReplyJSON.self, prompt: Prompts.reply(message, plan: plan, household: household, step: step, recipe: recipe, references: passages))
        } catch GemmaError.notJSON {
            return ChefReply(answer: try await askChef(message, step: step, recipe: recipe), change: nil)
        } catch is DecodingError {
            return ChefReply(answer: try await askChef(message, step: step, recipe: recipe), change: nil)
        }
        let change = decoded.change.flatMap { proposed -> PlanChange? in
            guard plan.days.contains(where: { $0.day.lowercased() == proposed.day.lowercased() }),
                  !HardRules.excluding([proposed.idea], ingredients: \.ingredients, banned: household.bannedTerms).isEmpty
            else { return nil }
            return PlanChange(day: proposed.day, idea: proposed.idea)
        }
        return ChefReply(answer: decoded.answer, change: change)
    }

    // One retry covers the common case of a reply that's almost JSON.
    private func askJSON<T: Decodable>(_ type: T.Type, prompt: String, image: Data? = nil, mimeType: String = "image/jpeg") async throws -> T {
        let first = try await model.generate(prompt: prompt, system: Prompts.chef, image: image, imageMIMEType: mimeType)
        if let value = try? JSONReply.decode(T.self, from: first) { return value }
        let second = try await model.generate(prompt: prompt + "\n\n" + Prompts.retry, system: Prompts.chef, image: image, imageMIMEType: mimeType)
        return try JSONReply.decode(T.self, from: second)
    }

    // The prompt asks Gemma to avoid these, and this check refuses a recipe that slipped through.
    static func checkSafe(_ recipe: RecipeDetail, household: Household) throws {
        let terms = household.bannedTerms.map { $0.lowercased().trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
        if let hit = recipe.ingredients.map(\.name).first(where: { name in terms.contains { HardRules.mentions(name, $0) } }) {
            throw GemmaError.unsafeRecipe(ingredient: hit)
        }
    }
}
