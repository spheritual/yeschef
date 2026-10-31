import SwiftUI
import UserNotifications
import YesChefCore

/// Step-by-step cooking for `model.recipe`: one step at a time, a timer when the step has one,
/// "Ask Basil" about the step, and a rating sheet at the end.
struct CookModeView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    @State private var index = 0
    @State private var timerEnds: [Int: Date] = [:]
    @State private var question = ""
    @State private var showRating = false

    var body: some View {
        NavigationStack {
            Group {
                if let recipe = model.recipe, recipe.steps.indices.contains(index) {
                    content(recipe)
                } else {
                    ContentUnavailableView("No recipe open", systemImage: "fork.knife",
                                           description: Text("Pick a dinner first."))
                }
            }
            .navigationTitle(model.recipe?.title ?? "Cooking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") { close() }
                }
            }
        }
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            cancelNotifications()
        }
        .sheet(isPresented: $showRating, onDismiss: { dismiss() }) {
            RatingSheet(idea: model.recipeIdea)
        }
    }

    private func content(_ recipe: RecipeDetail) -> some View {
        let step = recipe.steps[index]
        let isLast = index == recipe.steps.count - 1
        return ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ProgressView(value: Double(index + 1), total: Double(recipe.steps.count))
                    .accessibilityLabel("Progress")
                    .accessibilityValue("Step \(index + 1) of \(recipe.steps.count)")
                Text("Step \(index + 1) of \(recipe.steps.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(step.instruction)
                    .font(.title2.weight(.semibold))
                Label(step.technique, systemImage: "lightbulb")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                if let seconds = step.timerSeconds {
                    timer(seconds: seconds)
                }
                Divider()
                askBasil(step)
                HStack {
                    Button("Back") { index -= 1 }
                        .disabled(index == 0)
                    Spacer()
                    if isLast {
                        Button("Done") { finish() }
                            .buttonStyle(.borderedProminent)
                    } else {
                        Button("Next") { index += 1 }
                            .buttonStyle(.borderedProminent)
                    }
                }
                .controlSize(.large)
            }
            .padding()
        }
    }

    // MARK: Timer

    @ViewBuilder
    private func timer(seconds: Int) -> some View {
        HStack {
            if let end = timerEnds[index] {
                Text(timerInterval: Date.now...max(end, .now), countsDown: true)
                    .font(.largeTitle.monospacedDigit())
                Spacer()
                Button("Cancel timer") {
                    timerEnds[index] = nil
                    UNUserNotificationCenter.current()
                        .removePendingNotificationRequests(withIdentifiers: [notificationID(index)])
                }
            } else {
                Button("Start \(Duration.seconds(seconds).formatted(.time(pattern: .minuteSecond))) timer", systemImage: "timer") {
                    startTimer(seconds: seconds)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func startTimer(seconds: Int) {
        let step = index
        timerEnds[step] = .now.addingTimeInterval(TimeInterval(seconds))
        let body = model.recipe?.steps[step].instruction ?? "Your timer is up."
        let id = notificationID(step)
        Task {
            // Permission is asked only now, when the cook starts a timer.
            let center = UNUserNotificationCenter.current()
            guard (try? await center.requestAuthorization(options: [.alert, .sound])) == true else { return }
            let content = UNMutableNotificationContent()
            content.title = "Timer done"
            content.body = body
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(seconds), repeats: false)
            try? await center.add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
        }
    }

    private func notificationID(_ step: Int) -> String { "yeschef.cook.step.\(step)" }

    private func cancelNotifications() {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: timerEnds.keys.map(notificationID))
    }

    // MARK: Ask Basil

    private func askBasil(_ step: RecipeDetail.Step) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Ask Basil").font(.headline)
            HStack {
                TextField("Is it done?", text: $question)
                    .textFieldStyle(.roundedBorder)
                    .submitLabel(.send)
                    .onSubmit { send(step) }
                Button("Ask", systemImage: "paperplane.fill") { send(step) }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.borderedProminent)
                    .disabled(question.trimmingCharacters(in: .whitespaces).isEmpty || model.mood == .cooking)
            }
            HStack(alignment: .top) {
                if model.mood == .cooking {
                    ProgressView()
                }
                Text(model.subtitle)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            if model.mood == .confused {
                Button("Try again") { Task { await model.retry() } }
                    .buttonStyle(.bordered)
            }
        }
    }

    private func send(_ step: RecipeDetail.Step) {
        let text = question.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty, model.mood != .cooking else { return }
        question = ""
        Task { await model.ask(text, step: step) }
    }

    // MARK: Finishing

    private func finish() {
        // Recipes imported from a photo have no idea to learn from, so only the learning is skipped.
        if let idea = model.recipeIdea {
            model.record(.cooked, for: idea)
        }
        showRating = true
    }

    private func close() {
        cancelNotifications()
        dismiss()
    }
}

/// Asks each household member for 1 to 5 stars.
private struct RatingSheet: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    let idea: DinnerIdea?
    @State private var stars: [String: Int] = [:]

    var body: some View {
        NavigationStack {
            List {
                Section("How was \(model.recipe?.title ?? "dinner")?") {
                    ForEach(model.household.members) { member in
                        HStack {
                            Text(member.name)
                            Spacer()
                            HStack(spacing: 4) {
                                ForEach(1...5, id: \.self) { n in
                                    Button {
                                        stars[member.name] = n
                                    } label: {
                                        Image(systemName: n <= (stars[member.name] ?? 0) ? "star.fill" : "star")
                                            .foregroundStyle(.yellow)
                                            .frame(minWidth: 28, minHeight: 44)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel("\(n) star\(n == 1 ? "" : "s") for \(member.name)")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Rate dinner")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Skip") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .disabled(stars.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }

    private func save() {
        if let idea {
            for n in stars.values { model.record(.rated(stars: n), for: idea) }
        }
        dismiss()
    }
}

#Preview {
    let model = AppModel(apiKey: nil)
    return CookModeView()
        .task { await model.open(SampleData.fajitas) }
        .environment(model)
}
