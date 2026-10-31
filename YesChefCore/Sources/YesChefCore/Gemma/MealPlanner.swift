import Foundation

public struct MealPlanner: Sendable {
    public static let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    private let model: any LanguageModel

    public init(model: any LanguageModel) {
        self.model = model
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
        let reply = try await askJSON(WeekReply.self, prompt: Prompts.week(household, days: days, busyDays: busyDays, ideasPerDay: ideasPerDay))
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
        let recipe = try await askJSON(RecipeDetail.self, prompt: Prompts.recipe(idea, household: household, servings: servings))
        try Self.checkSafe(recipe, household: household)
        return recipe
    }

    public func recipeFromImage(_ image: Data, mimeType: String = "image/jpeg", household: Household) async throws -> RecipeDetail {
        let recipe = try await askJSON(RecipeDetail.self, prompt: Prompts.fromImage, image: image, mimeType: mimeType)
        try Self.checkSafe(recipe, household: household)
        return recipe
    }

    public func askChef(_ question: String, step: RecipeDetail.Step? = nil, recipe: RecipeDetail? = nil) async throws -> String {
        try await model.generate(prompt: Prompts.question(question, step: step, recipe: recipe), system: Prompts.chef, image: nil, imageMIMEType: "image/jpeg")
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
        let names = recipe.ingredients.map(\.name)
        if HardRules.excluding([names], ingredients: { $0 }, banned: household.bannedTerms).isEmpty {
            let terms = household.bannedTerms.map { $0.lowercased().trimmingCharacters(in: .whitespaces) }.filter { !$0.isEmpty }
            let hit = names.first { name in terms.contains { name.lowercased().contains($0) } } ?? "a banned ingredient"
            throw GemmaError.unsafeRecipe(ingredient: hit)
        }
    }
}
