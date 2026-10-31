import SwiftUI
import YesChefCore

/// Placeholder that exercises AppModel until the main screen from Figma frame 9:2 replaces it.
struct ContentView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text(model.subtitle)
                    Button("Plan my week") { Task { await model.planWeek() } }
                    if model.mood == .confused {
                        Button("Try again") { Task { await model.retry() } }
                    }
                }
                Section("This week") {
                    ForEach(model.plan.days) { day in
                        Button("\(day.day): \(day.pick.title)") { Task { await model.open(day.pick) } }
                    }
                }
                if let recipe = model.recipe {
                    Section(recipe.title) {
                        ForEach(Array(recipe.steps.enumerated()), id: \.offset) { _, step in
                            Text(step.instruction)
                        }
                    }
                }
            }
            .navigationTitle(model.isOffline ? "yeschef! (offline)" : "yeschef!")
        }
    }
}

#Preview {
    ContentView()
        .environment(AppModel(apiKey: nil))
}
