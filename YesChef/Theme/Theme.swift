import SwiftUI

/// The app's colors and type, from the Figma proposal. Fraunces and Inter aren't bundled, so
/// headings use the system serif and body text the system default.
enum Theme {
    static let cream = Color(hex: 0xF8F5EC)
    static let stage = Color(hex: 0xE7ECCD)
    static let card = Color(hex: 0xFFFEF8)
    static let ink = Color(hex: 0x263B2E)
    static let green = Color(hex: 0x386347)
    static let muted = Color(hex: 0x73796B)

    // The burger's layers, which double as the menu's colors.
    static let bun = Color(hex: 0xDE9F79)
    static let lettuce = Color(hex: 0x8FAE5F)
    static let tomato = Color(hex: 0xBC5039)
    static let cheese = Color(hex: 0xF1C95A)
    static let patty = Color(hex: 0x7A4A2A)
    static let counter = Color(hex: 0xC29465)
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255)
    }
}

extension Font {
    /// Fraunces stand-in for headings; scales with Dynamic Type.
    static func heading(_ style: Font.TextStyle) -> Font {
        .system(style, design: .serif, weight: .semibold)
    }
}

extension View {
    /// Small green all-caps label, like "BASIL" or "MONDAY DINNER".
    func eyebrow() -> some View {
        font(.caption2.bold()).tracking(0.8).foregroundStyle(Theme.green)
    }

    func cardBackground(radius: CGFloat = 20) -> some View {
        background(Theme.card, in: .rect(cornerRadius: radius))
    }
}

/// A filled green pill button, like "Start cooking".
struct PillButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Theme.card)
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(Theme.green, in: .capsule)
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
