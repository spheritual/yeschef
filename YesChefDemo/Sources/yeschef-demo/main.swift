import Foundation
import YesChefCore

// Terminal demo of the planner and the learning loop, for when the iPhone app isn't on screen.
// With GEMINI_API_KEY set it plans with Gemma; without it, it uses SampleData.

func heading(_ text: String) {
    print("\n== \(text) ==")
}

func chart(_ model: PreferenceModel) {
    let rows = zip(FeatureEncoder.labels, model.weights).dropFirst()
        .filter { abs($0.1) >= 0.03 }
        .sorted { abs($0.1) > abs($1.1) }
    for (label, weight) in rows {
        let bar = String(repeating: weight > 0 ? "+" : "-", count: min(Int(abs(weight) * 40), 30))
        let padded = label.padding(toLength: 26, withPad: " ", startingAt: 0)
        print("  \(padded) \(String(format: "%+.2f", weight)) \(bar)")
    }
}

let household = SampleData.household
let key = ProcessInfo.processInfo.environment["GEMINI_API_KEY"] ?? ""

heading("Basil plans with Gemma 4")
if key.isEmpty {
    print("(no GEMINI_API_KEY, showing the saved sample plan)")
    for day in SampleData.weekPlan.days {
        print("  \(day.day)\(day.isBusy ? " (busy)" : ""): \(day.pick.title), \(day.pick.features.minutes) min")
    }
} else {
    let planner = MealPlanner(model: GemmaClient(apiKey: key))
    do {
        let plan = try await planner.planWeek(for: household, days: ["Monday", "Wednesday", "Friday"], busyDays: ["Wednesday"])
        for day in plan.days {
            let swaps = day.alternatives.map(\.title).joined(separator: ", ")
            print("  \(day.day)\(day.isBusy ? " (busy)" : ""): \(day.pick.title), \(day.pick.features.minutes) min. Swaps: \(swaps)")
        }
        heading("Basil teaches: \(plan.days[0].pick.title)")
        let recipe = try await planner.recipe(for: plan.days[0].pick, household: household)
        for (number, step) in recipe.steps.enumerated() {
            print("  \(number + 1). \(step.instruction)")
            if !step.technique.isEmpty { print("     Why: \(step.technique)") }
        }
        heading("You ask Basil")
        let question = "How do I know when it's done?"
        print("  You: \(question)")
        print("  Basil: \(try await planner.askChef(question, recipe: recipe))")
    } catch {
        print("  Gemma call failed (\(error)); the app falls back to the saved plan here.")
    }
}

// A made-up cook who loves spicy chicken, doesn't like fish and has no patience for long
// recipes on busy nights. Basil never sees this function, only the star ratings it produces.
let pool: [(DinnerIdea, Bool)] = [
    (SampleData.fajitas, true), (SampleData.salmon, false), (SampleData.pasta, false),
    (DinnerIdea(title: "Slow beef chili", summary: "", features: RecipeFeatures(protein: .beef, flavours: [.spicy, .savory], minutes: 90, difficulty: .medium, costPerServing: 4), ingredients: []), true),
    (DinnerIdea(title: "Tofu and veg stir fry", summary: "", features: RecipeFeatures(protein: .vegetarian, flavours: [.fresh, .savory], minutes: 20, difficulty: .easy, costPerServing: 3), ingredients: []), true),
    (DinnerIdea(title: "Miso glazed cod", summary: "", features: RecipeFeatures(protein: .fish, flavours: [.sweet, .savory], minutes: 25, difficulty: .medium, costPerServing: 7), ingredients: []), false),
    (DinnerIdea(title: "Buffalo chicken wraps", summary: "", features: RecipeFeatures(protein: .chicken, flavours: [.spicy], minutes: 20, difficulty: .easy, costPerServing: 3), ingredients: []), true),
    (DinnerIdea(title: "Pork ramen", summary: "", features: RecipeFeatures(protein: .pork, flavours: [.savory], minutes: 60, difficulty: .hard, costPerServing: 5), ingredients: []), false),
]

func stars(for idea: DinnerIdea, busy: Bool) -> Int {
    var taste = 0.5
    if idea.features.flavours.contains(.spicy) { taste += 0.3 }
    if idea.features.protein == .chicken { taste += 0.2 }
    if idea.features.protein == .fish { taste -= 0.35 }
    if busy && idea.features.minutes > 45 { taste -= 0.4 }
    return min(max(Int((1 + 4 * taste).rounded()), 1), 5)
}

heading("Three weeks of feedback")
var model = PreferenceModel()
var rng = SeededGenerator(seed: 2026)
for week in 1...3 {
    var line: [String] = []
    for night in 0..<5 {
        let busy = night % 2 == 1
        let context = DayContext(isBusy: busy)
        let ranked = Recommender.rank(pool.map(\.0), features: { FeatureEncoder.encode($0.features, on: context) }, models: [model], using: &rng)
        let pick = ranked[0].item
        let rating = stars(for: pick, busy: busy)
        model.record(.rated(stars: rating), for: FeatureEncoder.encode(pick.features, on: context))
        line.append("\(pick.title) \(rating)*")
    }
    print("  Week \(week): \(line.joined(separator: ", "))")
}

heading("What Basil learned about you")
chart(model)

heading("A busy Wednesday now")
let busyNight = DayContext(isBusy: true)
let tonight = Recommender.rank(pool.map(\.0), features: { FeatureEncoder.encode($0.features, on: busyNight) }, models: [model], using: &rng)
for entry in tonight.sorted(by: { $0.expected > $1.expected }).prefix(4) {
    print("  \(entry.item.title): expected \(String(format: "%.2f", entry.expected)), unsure by \(String(format: "%.2f", entry.uncertainty))")
}
print("  Tonight's draw picks \(tonight[0].item.title). A dish Basil is unsure about can still win a draw, which is how he keeps trying new things.")
