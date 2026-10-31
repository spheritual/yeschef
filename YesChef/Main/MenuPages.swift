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
                    VStack(alignment: .leading, spacing: 2) {
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
    @State private var bought: Set<String> = []

    var body: some View {
        let items = model.plan.shoppingList
        Page(title: "Shopping list") {
            List {
                Section {
                    ForEach(items, id: \.self) { item in
                        Button {
                            if !bought.insert(item).inserted { bought.remove(item) }
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: bought.contains(item) ? "checkmark.circle.fill" : "circle")
                                    .foregroundStyle(Theme.green)
                                Text(item.capitalized)
                                    .strikethrough(bought.contains(item))
                                    .foregroundStyle(bought.contains(item) ? Theme.muted : Theme.ink)
                            }
                        }
                        .accessibilityValue(bought.contains(item) ? "Got it" : "Still needed")
                        .listRowBackground(Theme.card)
                    }
                } header: {
                    Text("\(items.count - bought.count) of \(items.count) left to get")
                }
            }
        }
    }
}

struct HouseholdPage: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        Page(title: "Household") {
            List {
                ForEach(model.household.members) { member in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(member.name).font(.heading(.headline)).foregroundStyle(Theme.ink)
                        Text(member.cookingSkill.capitalized).font(.footnote).foregroundStyle(Theme.muted)
                        if !member.likes.isEmpty { Text("Likes \(member.likes.formatted())").font(.footnote) }
                        if !member.avoid.isEmpty { Text("Avoids \(member.avoid.formatted())").font(.footnote) }
                        if let diet = member.diet { Text(diet.capitalized).font(.footnote) }
                    }
                    .foregroundStyle(Theme.ink)
                    .listRowBackground(Theme.card)
                }
                if let budget = model.household.weeklyBudget {
                    Text("Weekly budget: \(budget.formatted(.currency(code: "USD").precision(.fractionLength(0))))")
                        .listRowBackground(Theme.card)
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
                LabeledContent("Basil's brain", value: model.isOffline ? "Offline sample data" : "Gemma 4")
                    .listRowBackground(Theme.card)
                LabeledContent("Busy days", value: model.busyDays.sorted().formatted())
                    .listRowBackground(Theme.card)
            }
        }
    }
}
