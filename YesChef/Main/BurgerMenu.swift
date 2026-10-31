import SwiftUI

enum MenuDestination: String, CaseIterable, Identifiable {
    case thisWeek = "This week"
    case recipes = "Recipes"
    case shopping = "Shopping list"
    case household = "Household"
    case settings = "Settings"

    var id: String { rawValue }

    /// The burger layer each option is drawn as.
    var layer: (name: String, color: Color) {
        switch self {
        case .thisWeek: ("top bun", Theme.bun)
        case .recipes: ("lettuce", Theme.lettuce)
        case .shopping: ("tomato", Theme.tomato)
        case .household: ("cheese", Theme.cheese)
        case .settings: ("bottom bun", Theme.bun)
        }
    }
}

/// The button in the top left: a tiny burger that fans out into the menu.
struct BurgerButton: View {
    @Binding var isOpen: Bool

    var body: some View {
        Button { isOpen.toggle() } label: {
            VStack(spacing: 1) {
                UnevenRoundedRectangle(topLeadingRadius: 8, topTrailingRadius: 8).fill(Theme.bun).frame(width: 26, height: 8)
                Capsule().fill(Theme.lettuce).frame(width: 30, height: 3)
                Capsule().fill(Theme.tomato).frame(width: 24, height: 3)
                Capsule().fill(Theme.cheese).frame(width: 27, height: 3)
                Capsule().fill(Theme.patty).frame(width: 26, height: 5)
                UnevenRoundedRectangle(bottomLeadingRadius: 3, bottomTrailingRadius: 3).fill(Theme.bun).frame(width: 26, height: 5)
            }
            .frame(width: 48, height: 48)
            .background(Theme.card, in: .circle)
        }
        .accessibilityLabel("Menu")
        .accessibilityHint(isOpen ? "Closes the menu" : "Opens the menu")
    }
}

/// The open menu: a dimmed screen with each layer as one option. Tapping outside closes it.
struct BurgerMenu: View {
    let onSelect: (MenuDestination) -> Void
    let onClose: () -> Void
    @State private var fanned = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack(alignment: .topLeading) {
            Theme.ink.opacity(0.55)
                .ignoresSafeArea()
                .onTapGesture(perform: onClose)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(MenuDestination.allCases.enumerated()), id: \.element) { index, item in
                    Button { onSelect(item) } label: {
                        HStack(alignment: .firstTextBaseline, spacing: 8) {
                            Text(item.rawValue).font(.headline)
                            Text(item.layer.name).font(.caption).opacity(0.7)
                        }
                        .foregroundStyle(item.layer.color == Theme.tomato || item.layer.color == Theme.patty ? Theme.card : Theme.ink)
                        .padding(.horizontal, 20)
                        .frame(minHeight: 46)
                        .frame(width: 270, alignment: .leading)
                        .background(item.layer.color, in: .rect(cornerRadius: 22))
                    }
                    .offset(y: fanned ? 0 : -CGFloat(index) * 40)
                    .opacity(fanned ? 1 : 0)
                }
                Text("Tap a layer to open it. Tap outside the burger to close it.")
                    .font(.caption).foregroundStyle(.white)
                    .padding(.top, 4)
            }
            .padding(.leading, 16)
            .padding(.top, 8)
        }
        .onAppear {
            withAnimation(reduceMotion ? .none : .spring(duration: 0.4, bounce: 0.25)) { fanned = true }
        }
        .accessibilityAddTraits(.isModal)
    }
}
