import Foundation
import Observation
import YesChefCore

/// Basil's moods, which drive his animation (docs/design, tab 8). Cooking is thinking with the pan,
/// listening hops, teaching reads from a cookbook, timer watches the wall clock, and yum and yuck
/// are his reactions to a rating.
nonisolated enum BasilMood: Sendable {
    case idle, listening, cooking, talking, teaching, timer, yum, yuck, confused
}

nonisolated struct ChatMessage: Identifiable, Hashable, Sendable {
    enum Speaker: Hashable, Sendable { case user, basil }

    let id = UUID()
    let speaker: Speaker
    let text: String
}

/// The app's shared state. Screens read it from the environment and call its methods; they never
/// call Gemma themselves. Without a Gemini key it runs on `SampleData`, which doubles as the
/// offline demo.
@Observable
final class AppModel {
    var household = SampleData.household
    var busyDays: Set<String> = ["Wednesday"]
    var plan = SampleData.weekPlan
    /// The shopping list, written to a file after every change, which keeps checked items through
    /// closing the page and restarting the app. It's the one thing the demo saves.
    var shopping = ShoppingList.load(from: AppModel.shoppingFile) ?? ShoppingList(plan: SampleData.weekPlan)
    private static let shoppingFile = URL.documentsDirectory.appending(path: "shopping-list.json")
    private(set) var recipe: RecipeDetail?
    /// The idea the open recipe came from, which carries the features feedback learns from.
    private(set) var recipeIdea: DinnerIdea?
    var mood = BasilMood.idle
    var subtitle = "Hi, I'm Basil. Ask me to plan your week and I'll start cooking."
    private(set) var messages: [ChatMessage] = []
    /// One preference model per household member, keyed by name (.plans/feedback-learning-spec.md).
    var learning: [String: PreferenceModel] = [:]

    private let planner: MealPlanner?
    private var retryJob: (() async -> Void)?
    private var quietDown: Task<Void, Never>?

    var isOffline: Bool { planner == nil }

    init(apiKey: String? = AppSecrets.geminiAPIKey) {
        planner = apiKey.map { MealPlanner(model: GemmaClient(apiKey: $0)) }
    }

    func planWeek() async {
        guard let planner else { return say("I'm offline, so here's my sample week.") }
        await run("Planning your week…", retry: { [weak self] in await self?.planWeek() }) {
            // Three days keeps the demo's wait short; the planner takes any list of days.
            self.plan = try await planner.planWeek(
                for: self.household, days: Array(MealPlanner.weekdays.prefix(3)),
                busyDays: self.busyDays, learning: Array(self.learning.values))
            self.shopping.sync(with: self.plan)
            self.saveShopping()
            return "Here's your week. Tap a dinner to see the recipe."
        }
    }

    func open(_ idea: DinnerIdea) async {
        recipeIdea = idea
        guard let planner else {
            recipe = SampleData.recipe
            return say("I'm offline, so here's my sample recipe.")
        }
        await run("Getting the recipe for \(idea.title)…", teaching: true, retry: { [weak self] in await self?.open(idea) }) {
            self.recipe = try await planner.recipe(for: idea, household: self.household)
            return "Here's \(idea.title). Tap Start cooking when you're ready."
        }
    }

    /// Reads a recipe from a photo or screenshot, which shows Gemma reading images. An imported
    /// recipe has no `recipeIdea`, so cooking it doesn't feed the learning models.
    func importRecipe(from image: Data, mimeType: String = "image/jpeg") async {
        recipeIdea = nil
        guard let planner else { return say("I'm offline, so I can't read photos right now.") }
        await run("Reading your recipe…", teaching: true, retry: { [weak self] in await self?.importRecipe(from: image, mimeType: mimeType) }) {
            let recipe = try await planner.recipeFromImage(image, mimeType: mimeType, household: self.household)
            self.recipe = recipe
            return "Got it: \(recipe.title). Tap Start cooking when you're ready."
        }
    }

    /// Answers a question from the mic or the chat, about one cooking step when `step` is set.
    func ask(_ question: String, step: RecipeDetail.Step? = nil) async {
        messages.append(ChatMessage(speaker: .user, text: question))
        guard let planner else { return say("I can't reach Gemma right now, so I can't answer that one.") }
        await run("Thinking…", teaching: true, retry: { [weak self] in await self?.ask(question, step: step) }) {
            try await planner.askChef(question, step: step, recipe: self.recipe)
        }
    }

    /// Updates every member's preference model with one piece of feedback.
    func record(_ signal: FeedbackSignal, for idea: DinnerIdea, onBusyDay: Bool = false) {
        let features = FeatureEncoder.encode(idea.features, on: DayContext(isBusy: onBusyDay))
        for member in household.members {
            learning[member.name, default: PreferenceModel()].record(signal, for: features)
        }
        // Basil reacts to a rating: a spit at the screen for a bad one, sparkles for a great one.
        if case .rated(let stars) = signal {
            if stars <= 2 {
                say("Blegh! I won't make that one again.", mood: .yuck)
            } else if stars >= 4 {
                say("Mmm, that hit the spot! I'll remember it.", mood: .yum)
            }
        }
    }

    /// Writes the shopping list to its file. A failed write only loses the checks since the last
    /// save, which is why it doesn't interrupt the cook.
    func saveShopping() {
        try? shopping.save(to: Self.shoppingFile)
    }

    /// Repeats the call that last failed, for the retry button on Basil's confused mood.
    func retry() async {
        guard let job = retryJob else { return }
        retryJob = nil
        await job()
    }

    private func say(_ text: String, mood spoken: BasilMood = .talking) {
        subtitle = text
        messages.append(ChatMessage(speaker: .basil, text: text))
        mood = spoken
        // Back to idle after about as long as it takes to say it, whether or not he's muted.
        quietDown?.cancel()
        quietDown = Task { [weak self] in
            try? await Task.sleep(for: .seconds(min(max(Double(text.count) / 15, 3), 12)))
            guard !Task.isCancelled, let self, self.mood == spoken else { return }
            self.mood = .idle
        }
    }

    /// Basil cooks with the pan while Gemma thinks, then talks, or teaches from his cookbook when
    /// the reply is a recipe or an answer.
    private func run(_ status: String, teaching: Bool = false, retry: @escaping () async -> Void, _ job: () async throws -> String) async {
        mood = .cooking
        subtitle = status
        do {
            say(try await job(), mood: teaching ? .teaching : .talking)
        } catch {
            retryJob = retry
            mood = .confused
            subtitle = "Hmm, that didn't work. Tap to try again."
        }
    }
}
