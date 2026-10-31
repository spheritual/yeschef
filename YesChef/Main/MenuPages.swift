import SwiftUI
import YesChefCore

/// A sheet wrapper with a title and a Done button.
private struct Page<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            content
                .scrollContentBackground(.hidden)
                .background(Theme.cream)
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar { Button("Done") { dismiss() } }
        }
        .tint(Theme.green)
    }
}

/// Every dinner picked for the week; tapping one opens its recipe on the main screen.
struct RecipesPage: View {
    @Environment(AppModel.self) private var model
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Page(title: "Recipes") {
            List(model.plan.days) { day in
                Button {
                    dismiss()
                    Task { await model.open(day.pick) }
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(day.pick.title).font(.heading(.headline)).foregroundStyle(Theme.ink)
                        Text(day.pick.summary).font(.footnote).foregroundStyle(Theme.muted)
                    }
                }
                .listRowBackground(Theme.card)
            }
        }
    }
}

/// The week's ingredients, deduplicated, with a tick-off checkbox for each.
struct ShoppingListPage: View {
    @Environment(AppModel.self) private var model
    @State private var newItem = ""
    @FocusState private var adding: Bool

    // A notepad: check items off, edit or add lines, swipe to delete. AppModel saves the list after
    // every change, which keeps the checks when the page closes and when the app restarts.
    var body: some View {
        @Bindable var model = model
        Page(title: "Shopping list") {
            List {
                Section {
                    ForEach($model.shopping.items) { $item in
                        HStack(spacing: 12) {
                            Button {
                                item.done.toggle()
                            } label: {
                                Image(systemName: item.done ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundStyle(Theme.green)
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel(item.done ? "Got it" : "Still needed")
                            TextField("Item", text: $item.text)
                                .strikethrough(item.done)
                                .foregroundStyle(item.done ? Theme.muted : Theme.ink)
                        }
                        .listRowBackground(Theme.card)
                    }
                    .onDelete { model.shopping.items.remove(atOffsets: $0) }
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle")
                            .font(.title3)
                            .foregroundStyle(Theme.green)
                        TextField("Add an item", text: $newItem)
                            .focused($adding)
                            .submitLabel(.done)
                            .onSubmit {
                                model.shopping.add(newItem)
                                newItem = ""
                                adding = true
                            }
                    }
                    .listRowBackground(Theme.card)
                } header: {
                    Text("\(model.shopping.remaining) of \(model.shopping.items.count) left to get")
                } footer: {
                    Text("Tap a circle to check an item off, tap a name to edit it, and swipe left to delete it.")
                }
                if model.shopping.items.contains(where: \.done) {
                    Section {
                        Button("Clear checked items", role: .destructive) { model.shopping.clearDone() }
                            .listRowBackground(Theme.card)
                    }
                }
            }
        }
        .onChange(of: model.shopping) { model.saveShopping() }
    }
}

struct HouseholdPage: View {
    private func detail(_ label: String, _ value: String) -> some View {
        (Text(label + " ").foregroundStyle(Theme.muted) + Text(value).foregroundStyle(Theme.ink))
            .font(.footnote)
    }

    @Environment(AppModel.self) private var model

    var body: some View {
        Page(title: "Household") {
            List {
                ForEach(model.household.members) { member in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(alignment: .firstTextBaseline) {
                            Text(member.name).font(.heading(.headline)).foregroundStyle(Theme.ink)
                            Spacer()
                            Text(member.cookingSkill.capitalized).font(.footnote).foregroundStyle(Theme.muted)
                        }
                        if !member.likes.isEmpty { detail("Likes", member.likes.formatted()) }
                        if !member.avoid.isEmpty { detail("Avoids", member.avoid.formatted()) }
                        if let diet = member.diet { detail("Diet", diet.capitalized) }
                        if !member.goals.isEmpty { detail("Goals", member.goals.formatted()) }
                    }
                    .padding(.vertical, 4)
                    .accessibilityElement(children: .combine)
                    .listRowBackground(Theme.card)
                }
                if let budget = model.household.weeklyBudget {
                    LabeledContent("Weekly budget", value: budget.formatted(.currency(code: "USD").precision(.fractionLength(0))))
                        .foregroundStyle(Theme.ink)
                        .listRowBackground(Theme.card)
                }
                Section {} footer: {
                    Text("Basil plans around these. Editing comes later.")
                }
            }
        }
    }
}

struct SettingsPage: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        Page(title: "Settings") {
            List {
                LabeledContent("App", value: "yeschef!")
                    .listRowBackground(Theme.card)
                LabeledContent("Basil's brain", value: model.isOffline ? "Offline sample data" : "Gemma 4")
                    .listRowBackground(Theme.card)
                LabeledContent("Busy days", value: model.busyDays.isEmpty ? "None" : model.busyDays.sorted().formatted())
                    .listRowBackground(Theme.card)
            }
        }
    }
}
