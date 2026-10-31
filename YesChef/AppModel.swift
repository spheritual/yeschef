import Foundation
import Observation
import YesChefCore

/// Basil's moods, which drive his animation (docs/architecture.md, "Screens").
nonisolated enum BasilMood: Sendable {
    case idle, listening, cooking, talking, confused
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

    var isOffline: Bool { planner == nil }

    init(apiKey: String? = AppSecrets.geminiAPIKey) {
        planner = apiKey.map { MealPlanner(model: GemmaClient(apiKey: $0)) }
    }

    func planWeek() async {
        guard let planner else { return say("I'm offline, so here's my sample week.") }
        await run("Planning your week…", retry: { [weak self] in await self?.planWeek() }) {
            self.plan = try await planner.planWeek(
                for: self.household, busyDays: self.busyDays, learning: Array(self.learning.values))
            return "Here's your week. Tap a dinner to see the recipe."
        }
    }

    func open(_ idea: DinnerIdea) async {
        recipeIdea = idea
        guard let planner else {
            recipe = SampleData.recipe
            return say("I'm offline, so here's my sample recipe.")
        }
        await run("Getting the recipe for \(idea.title)…", retry: { [weak self] in await self?.open(idea) }) {
            self.recipe = try await planner.recipe(for: idea, household: self.household)
            return "Here's \(idea.title). Tap Start cooking when you're ready."
        }
    }

    /// Answers a question from the mic or the chat, about one cooking step when `step` is set.
    func ask(_ question: String, step: RecipeDetail.Step? = nil) async {
        messages.append(ChatMessage(speaker: .user, text: question))
        guard let planner else { return say("I can't reach Gemma right now, so I can't answer that one.") }
        await run("Thinking…", retry: { [weak self] in await self?.ask(question, step: step) }) {
            try await planner.askChef(question, step: step, recipe: self.recipe)
        }
    }

    /// Updates every member's preference model with one piece of feedback.
    func record(_ signal: FeedbackSignal, for idea: DinnerIdea, onBusyDay: Bool = false) {
        let features = FeatureEncoder.encode(idea.features, on: DayContext(isBusy: onBusyDay))
        for member in household.members {
            learning[member.name, default: PreferenceModel()].record(signal, for: features)
        }
    }

    /// Repeats the call that last failed, for the retry button on Basil's confused mood.
    func retry() async {
        guard let job = retryJob else { return }
        retryJob = nil
        await job()
    }

    private func say(_ text: String) {
        subtitle = text
        messages.append(ChatMessage(speaker: .basil, text: text))
        mood = .talking
    }

    private func run(_ status: String, retry: @escaping () async -> Void, _ job: () async throws -> String) async {
        mood = .cooking
        subtitle = status
        do {
            say(try await job())
        } catch {
            retryJob = retry
            mood = .confused
            subtitle = "Hmm, that didn't work. Tap to try again."
        }
    }
}
