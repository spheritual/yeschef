import Foundation

public struct MealPlanner: Sendable {
    public static let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]

    private let model: any LanguageModel
    private let library: Library

    // Retrieval over the Gutenberg cookbooks. The bundled corpus is indexed on first use inside an
    // async call, never on the caller's thread, because the index takes seconds in a debug build.
    private enum Library: Sendable {
        case bundled
        case given(Cookbook?)
    }

    /// Uses the bundled cookbooks.
    public init(model: any LanguageModel) {
        self.model = model
        self.library = .bundled
    }

    /// Uses the given cookbooks, or Gemma alone when `cookbook` is nil.
    public init(model: any LanguageModel, cookbook: Cookbook?) {
        self.model = model
        self.library = .given(cookbook)
    }

    /// Builds the bundled cookbook index ahead of the first plan. Being async and nonisolated, it
    /// runs off the caller's actor, which keeps app launch from freezing while it indexes.
    public static func warmUp() async {
        _ = Cookbook.bundled
    }

    var cookbook: Cookbook? {
        switch library {
        case .bundled: Cookbook.bundled
        case .given(let cookbook): cookbook
        }
    }

    func references(for query: String, limit: Int) -> [Cookbook.Passage] {
        cookbook?.search(query, limit: limit) ?? []
    }

    // Gemma proposes ideas, the hard rules drop anything a member must avoid, and the household's
    // preference models rank what's left, as in .plans/feedback-learning-spec.md.
    // Each day is its own Gemma call and all of them run at once, because Gemma's time grows with
    // how much it writes. On 2026-10-31 three days took 30 s in one call and 11.8 s in parallel.
    public func planWeek(
        for household: Household,
        days: [String] = MealPlanner.weekdays,
        busyDays: Set<String> = [],
        learning: [PreferenceModel] = [],
        ideasPerDay: Int = 3
    ) async throws -> WeekPlan {
        let tastes = household.members.flatMap { $0.likes + [$0.diet ?? ""] }.joined(separator: " ")
        let shelf = references(for: tastes.isEmpty ? "chicken soup vegetables" : tastes, limit: 6 * days.count)
            .filter { passage in household.bannedTerms.allSatisfy { !HardRules.mentions(passage.text, $0.lowercased()) } }
        let replies = await withTaskGroup(of: (Int, Result<[DinnerIdea], any Error>).self) { group in
            for (index, day) in days.enumerated() {
                // Every nth classic goes to day n, which keeps the calls from all adapting the same book.
                let passages = shelf.indices.filter { $0 % days.count == index }.prefix(6).map { shelf[$0] }
                let prompt = Prompts.week(household, days: [day], busyDays: busyDays, ideasPerDay: ideasPerDay, references: passages)
                group.addTask {
                    do {
                        // The ideas belong to the day that was asked for, whatever day Gemma wrote on them.
                        let reply = try await self.askJSON(WeekReply.self, prompt: prompt)
                        return (index, .success(reply.days.flatMap { $0.ideas.map(\.idea) }))
                    } catch {
                        return (index, .failure(error))
                    }
                }
            }
            var replies = [Result<[DinnerIdea], any Error>?](repeating: nil, count: days.count)
            for await (index, result) in group { replies[index] = result }
            return replies
        }

        var rng = SystemRandomNumberGenerator()
        var picked: Set<String> = []
        var planned: [WeekPlan.Day] = []
        for (day, result) in zip(days, replies) {
            guard case .success(let ideas)? = result else { continue }
            let safe = HardRules.excluding(ideas, ingredients: \.ingredients, banned: household.bannedTerms)
            let context = DayContext(isBusy: busyDays.contains(day))
            let ranked = Recommender.rank(safe, features: { FeatureEncoder.encode($0.features, on: context) }, models: learning, using: &rng).map(\.item)
            // The calls can't see each other, which is why a dinner an earlier day already got goes last.
            let order = ranked.filter { !picked.contains($0.title.lowercased()) } + ranked.filter { picked.contains($0.title.lowercased()) }
            guard let first = order.first else { continue }
            picked.insert(first.title.lowercased())
            planned.append(WeekPlan.Day(day: day, isBusy: context.isBusy, pick: first, alternatives: Array(order.dropFirst())))
        }
        // A day whose call failed is left out. When every day failed, the first day's error says why.
        guard !planned.isEmpty else {
            for case .failure(let error)? in replies { throw error }
            throw GemmaError.noSafeIdeas
        }
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
