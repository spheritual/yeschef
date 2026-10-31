import SwiftUI
import YesChefCore

/// The app's one main screen (Figma 9:2): Basil and his subtitle bar on top, the week and the open
/// recipe below, a chat bubble bottom right and the burger menu top left.
struct MainScreen: View {
    @Environment(AppModel.self) private var model
    @State private var menuOpen = false
    @State private var page: MenuDestination?
    @State private var showChat = false
    @State private var showCook = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                BasilStage(menuOpen: $menuOpen)
                ScrollViewReader { proxy in
                    ScrollView {
                        output
                            .padding(.horizontal, 20)
                            .padding(.top, 18)
                            .padding(.bottom, 100)
                    }
                    .onChange(of: page) { _, destination in
                        guard destination == .thisWeek else { return }
                        page = nil
                        withAnimation(reduceMotion ? nil : .default) { proxy.scrollTo("week", anchor: .top) }
                    }
                }
            }
            .background(Theme.cream.ignoresSafeArea())

            chatButton

            if menuOpen {
                BurgerMenu(onSelect: select, onClose: { menuOpen = false })
                    .transition(.opacity)
            }
        }
        .animation(reduceMotion ? nil : .default, value: menuOpen)
        .sheet(isPresented: $showChat) { ChatView() }
        .fullScreenCover(isPresented: $showCook) { CookModeView() }
        .sheet(item: sheetPage) { destination in
            switch destination {
            case .recipes: RecipesPage()
            case .shopping: ShoppingListPage()
            case .household: HouseholdPage()
            case .importRecipe: ImportView()
            case .settings: SettingsPage()
            case .thisWeek: EmptyView()
            }
        }
        .basilVoice()
    }

    /// `thisWeek` scrolls instead of opening a sheet.
    private var sheetPage: Binding<MenuDestination?> {
        Binding(get: { page == .thisWeek ? nil : page }, set: { page = $0 })
    }

    private func select(_ destination: MenuDestination) {
        menuOpen = false
        page = destination
    }

    private var chatButton: some View {
        Button { showChat = true } label: {
            Image(systemName: "bubble.left.fill")
                .font(.title2)
                .foregroundStyle(Theme.card)
                .frame(width: 60, height: 60)
                .background(Theme.green, in: .circle)
                .shadow(color: Theme.ink.opacity(0.25), radius: 6, y: 4)
        }
        .padding(.trailing, 20)
        .padding(.bottom, 12)
        .accessibilityLabel("Chat with Basil")
    }

    // MARK: Bottom two thirds

    private var output: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let recipe = model.recipe {
                Text("Up next").font(.heading(.title2)).foregroundStyle(Theme.ink)
                RecipeCard(recipe: recipe, eyebrow: eyebrow, source: model.recipeIdea?.source) { showCook = true }
            }
            HStack {
                Text("This week").font(.heading(.title3)).foregroundStyle(Theme.ink)
                    .id("week")
                Spacer()
                Button("Plan my week") { Task { await model.planWeek() } }
                    .buttonStyle(PillButtonStyle())
            }
            .padding(.top, 6)
            ForEach(model.plan.days) { day in
                DayCard(day: day, isOpen: day.pick == model.recipeIdea) {
                    Task { await model.open(day.pick) }
                }
                // Long-press a day to swap its dinner for one of the other ideas.
                .contextMenu {
                    ForEach(day.alternatives) { idea in
                        Button("Swap for \(idea.title)", systemImage: "arrow.triangle.2.circlepath") {
                            model.swap(day.day, to: idea)
                        }
                    }
                }
            }
            LearningCard()
        }
        .opacity(model.mood == .cooking ? 0.4 : 1)
        .disabled(model.mood == .cooking)
        .animation(reduceMotion ? nil : .default, value: model.mood == .cooking)
    }

    private var eyebrow: String {
        guard let idea = model.recipeIdea, let day = model.plan.days.first(where: { $0.pick == idea }) else { return "RECIPE" }
        return "\(day.day) dinner".uppercased()
    }
}

// MARK: - Top third

/// Basil on his kitchen counter with the subtitle bar under him.
private struct BasilStage: View {
    @Environment(AppModel.self) private var model
    @Binding var menuOpen: Bool

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                BasilView(mood: model.mood)
                if model.mood == .cooking {
                    // Mirrored, which points the handle back toward Basil's hand.
                    Image("PanWithSteam")
                        .scaleEffect(x: -1, y: 1)
                        .offset(x: 97, y: 42)
                        .accessibilityHidden(true)
                }
                BurgerButton(isOpen: $menuOpen)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 16)
                    .padding(.top, 6)
                if model.isOffline {
                    Text("Offline")
                        .font(.caption2.weight(.semibold)).foregroundStyle(Theme.green)
                        .padding(.horizontal, 12).padding(.vertical, 8)
                        .background(Theme.card, in: .capsule)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .padding(.trailing, 16)
                        .padding(.top, 16)
                }
            }
            .frame(height: 163)
            Capsule().fill(Theme.counter).frame(height: 14)
                .padding(.horizontal, 16)
            SubtitleBar()
                .padding(.horizontal, 16)
                .padding(.top, 11)
                .padding(.bottom, 24)
        }
        .background {
            UnevenRoundedRectangle(bottomLeadingRadius: 32, bottomTrailingRadius: 32)
                .fill(Theme.stage)
                .ignoresSafeArea(edges: .top)
        }
    }
}

/// What Basil says, the retry when something failed, and the mic.
private struct SubtitleBar: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text("BASIL").eyebrow()
                Text(model.subtitle)
                    .font(.footnote)
                    .foregroundStyle(Theme.ink)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if model.mood == .confused {
                    Button("Try again") { Task { await model.retry() } }
                        .buttonStyle(PillButtonStyle())
                        .padding(.top, 4)
                }
            }
            MicButton()
                .tint(Theme.green)
                .frame(width: 40, height: 40)
                .background(Theme.stage, in: .circle)
        }
        .padding(.leading, 16)
        .padding(.trailing, 8)
        .padding(.vertical, 10)
        .frame(minHeight: 60)
        .background(Theme.card, in: .rect(cornerRadius: 22))
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Theme.green, lineWidth: 1.5))
        .accessibilityElement(children: .contain)
    }
}

// MARK: - Cards

private struct RecipeCard: View {
    let recipe: RecipeDetail
    let eyebrow: String
    let source: String?
    let start: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(eyebrow).eyebrow()
            Text(recipe.title).font(.heading(.title3)).foregroundStyle(Theme.ink)
            Text("\(recipe.minutes) min, serves \(recipe.servings)")
                .font(.caption).foregroundStyle(Theme.muted)
            SourceLine(source: source)
            VStack(alignment: .leading, spacing: 4) {
                Text("Ingredients").font(.subheadline.weight(.semibold)).foregroundStyle(Theme.ink)
                ForEach(recipe.ingredients, id: \.name) { item in
                    HStack(alignment: .firstTextBaseline) {
                        Text(item.name.capitalized)
                        Spacer()
                        Text("\(item.amount) \(item.unit)".trimmingCharacters(in: .whitespaces))
                            .foregroundStyle(Theme.muted)
                    }
                    .font(.footnote)
                    .foregroundStyle(Theme.ink)
                    .accessibilityElement(children: .combine)
                }
            }
            .padding(.top, 10)
            Button("Start cooking with Basil", action: start)
                .buttonStyle(PillButtonStyle())
                .padding(.top, 12)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cardBackground()
    }
}

private struct DayCard: View {
    let day: WeekPlan.Day
    let isOpen: Bool
    let open: () -> Void

    var body: some View {
        Button(action: open) {
            VStack(alignment: .leading, spacing: 3) {
                HStack {
                    Text(day.day.uppercased()).eyebrow()
                    if day.isBusy {
                        Text("BUSY").font(.caption2.bold()).foregroundStyle(Theme.tomato)
                    }
                    Spacer()
                    Text("\(day.pick.features.minutes) min").font(.caption).foregroundStyle(Theme.muted)
                }
                Text(day.pick.title).font(.heading(.headline)).foregroundStyle(Theme.ink)
                Text(day.pick.summary).font(.footnote).foregroundStyle(Theme.muted)
                    .multilineTextAlignment(.leading)
                SourceLine(source: day.pick.source)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .cardBackground(radius: 16)
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Theme.green, lineWidth: isOpen ? 1.5 : 0))
        }
        .buttonStyle(.plain)
        .accessibilityHint("Opens the recipe")
    }
}

/// "Adapted from …" when Gemma based an idea on a public-domain cookbook; nothing otherwise.
private struct SourceLine: View {
    let source: String?

    var body: some View {
        if let source {
            Text("Adapted from \(source) (Project Gutenberg)")
                .font(.caption2).foregroundStyle(Theme.muted)
                .multilineTextAlignment(.leading)
        }
    }
}

#Preview {
    MainScreen()
        .environment(AppModel(apiKey: nil))
}
