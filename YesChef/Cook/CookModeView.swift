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
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

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
            .background(Theme.cream.ignoresSafeArea())
            .navigationTitle(model.recipe?.title ?? "Cooking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(model.recipe?.title ?? "Cooking").font(.heading(.headline)).foregroundStyle(Theme.ink)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") { close() }
                }
            }
        }
        .tint(Theme.green)
        .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
        .onDisappear {
            UIApplication.shared.isIdleTimerDisabled = false
            cancelNotifications()
        }
        .sheet(isPresented: $showRating, onDismiss: { dismiss() }) {
            RatingSheet(idea: model.recipeIdea, onBusyDay: model.recipeIdea.map(isBusyDay) ?? false)
        }
    }

    private func content(_ recipe: RecipeDetail) -> some View {
        let step = recipe.steps[index]
        let total = recipe.steps.count
        return ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("STEP \(index + 1) OF \(total)").eyebrow()
                    ProgressView(value: Double(index + 1), total: Double(total))
                        .tint(Theme.green)
                        .accessibilityLabel("Progress")
                        .accessibilityValue("Step \(index + 1) of \(total)")
                }
                Text(step.instruction)
                    .font(.heading(.title2))
                    .foregroundStyle(Theme.ink)
                    .fixedSize(horizontal: false, vertical: true)
                if !step.technique.isEmpty {
                    technique(step.technique)
                }
                if let seconds = step.timerSeconds {
                    timer(seconds: seconds)
                }
                askBasil(step)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .id(index)
            .transition(.opacity)
        }
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) { navigation(total: total) }
        .animation(reduceMotion ? nil : .easeOut(duration: 0.2), value: index)
    }

    /// The technique note: a quiet tinted block, 12pt radius inside 16pt padding.
    private func technique(_ text: String) -> some View {
        Label(text, systemImage: "lightbulb")
            .font(.callout)
            .foregroundStyle(Theme.muted)
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func navigation(total: Int) -> some View {
        HStack {
            Button("Back") { index -= 1 }
                .buttonStyle(QuietButtonStyle())
                .disabled(index == 0)
            Spacer()
            if index == total - 1 {
                Button("Done") { finish() }.buttonStyle(PillButtonStyle())
            } else {
                Button("Next") { index += 1 }.buttonStyle(PillButtonStyle())
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(.bar)
    }

    // MARK: Timer

    @ViewBuilder
    private func timer(seconds: Int) -> some View {
        HStack(spacing: 16) {
            if let end = timerEnds[index] {
                // Basil watches the clock on the wall while the timer runs.
                BasilView(mood: .timer)
                    .scaleEffect(0.45)
                    .frame(width: 62, height: 70)
                TimelineView(.periodic(from: .now, by: 1)) { context in
                    let done = context.date >= end
                    VStack(alignment: .leading, spacing: 2) {
                        Text(timerInterval: Date.now...max(end, .now), countsDown: true)
                            .font(.largeTitle.weight(.semibold).monospacedDigit())
                            .contentTransition(.numericText(countsDown: true))
                            .foregroundStyle(done ? Theme.green : Theme.ink)
                        if done {
                            Text("Time's up").font(.footnote.weight(.semibold)).foregroundStyle(Theme.green)
                        }
                    }
                }
                Spacer(minLength: 0)
                Button("Cancel", systemImage: "xmark") {
                    timerEnds[index] = nil
                    UNUserNotificationCenter.current()
                        .removePendingNotificationRequests(withIdentifiers: [notificationID(index)])
                }
                .labelStyle(.iconOnly)
                .buttonStyle(QuietButtonStyle())
                .accessibilityLabel("Cancel timer")
            } else {
                Button("Start \(Duration.seconds(seconds).formatted(.time(pattern: .minuteSecond))) timer", systemImage: "timer") {
                    startTimer(seconds: seconds)
                }
                .buttonStyle(PillButtonStyle())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.card, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
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
        let empty = question.trimmingCharacters(in: .whitespaces).isEmpty
        let busy = model.mood == .cooking
        return VStack(alignment: .leading, spacing: 12) {
            Text("ASK BASIL").eyebrow()
            HStack(spacing: 8) {
                TextField("Is it done?", text: $question)
                    .padding(.horizontal, 16)
                    .frame(minHeight: 44)
                    .background(Theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    .submitLabel(.send)
                    .onSubmit { send(step) }
                Button("Ask", systemImage: "paperplane.fill") { send(step) }
                    .labelStyle(.iconOnly)
                    .buttonStyle(PillButtonStyle())
                    .frame(minWidth: 44, minHeight: 44)
                    .disabled(empty || busy)
                    .opacity(empty || busy ? 0.4 : 1)
            }
            HStack(alignment: .top, spacing: 8) {
                if busy { ProgressView() }
                Text(model.subtitle)
                    .font(.callout)
                    .foregroundStyle(Theme.muted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if model.mood == .confused {
                Button("Try again") { Task { await model.retry() } }
                    .buttonStyle(PillButtonStyle())
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
            model.record(.cooked, for: idea, onBusyDay: isBusyDay(idea))
        }
        showRating = true
    }

    /// Whether the dinner being cooked is planned for a busy day.
    private func isBusyDay(_ idea: DinnerIdea) -> Bool {
        guard let day = model.plan.days.first(where: { $0.pick == idea }) else { return false }
        return model.busyDays.contains(day.day)
    }

    private func close() {
        cancelNotifications()
        dismiss()
    }
}

/// A quiet text button: 44pt tall, dims on press.
private struct QuietButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.medium))
            .foregroundStyle(Theme.green)
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(.rect)
            .opacity(!isEnabled ? 0.3 : configuration.isPressed ? 0.5 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

/// Asks each household member for 1 to 5 stars.
private struct RatingSheet: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    let idea: DinnerIdea?
    let onBusyDay: Bool
    @State private var stars: [String: Int] = [:]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(model.household.members) { member in
                        HStack {
                            Text(member.name).foregroundStyle(Theme.ink)
                            Spacer()
                            HStack(spacing: 0) {
                                ForEach(1...5, id: \.self) { n in
                                    Button {
                                        stars[member.name] = n
                                    } label: {
                                        Image(systemName: n <= (stars[member.name] ?? 0) ? "star.fill" : "star")
                                            .foregroundStyle(Theme.cheese)
                                            .frame(minWidth: 32, minHeight: 44)
                                            .contentShape(.rect)
                                    }
                                    .buttonStyle(.plain)
                                    .accessibilityLabel("\(n) star\(n == 1 ? "" : "s") for \(member.name)")
                                }
                            }
                        }
                        .listRowBackground(Theme.card)
                    }
                } header: {
                    Text("How was \(model.recipe?.title ?? "dinner")?")
                        .font(.heading(.headline)).foregroundStyle(Theme.ink).textCase(nil)
                        .padding(.bottom, 4)
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cream)
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
        .tint(Theme.green)
        .presentationDetents([.medium])
    }

    private func save() {
        if let idea {
            for n in stars.values { model.record(.rated(stars: n), for: idea, onBusyDay: onBusyDay) }
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
