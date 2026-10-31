import SwiftUI

/// The app's colors and type, from the Figma proposal. Fraunces and Inter aren't bundled, so
/// headings use the system serif and body text the system default.
enum Theme {
    // Every token adapts to the system appearance. Light values are the Figma proposal's.
    static let cream = Color(light: 0xF8F5EC, dark: 0x141A16)
    static let stage = Color(light: 0xE7ECCD, dark: 0x232C25)
    static let card = Color(light: 0xFFFEF8, dark: 0x1E2621)
    static let ink = Color(light: 0x263B2E, dark: 0xECE8DC)
    static let green = Color(light: 0x386347, dark: 0x7FB08E)
    static let muted = Color(light: 0x73796B, dark: 0x9BA392)

    /// Text and icons placed on a `green` fill.
    static let onGreen = Color(light: 0xFFFEF8, dark: 0x0F1511)
    /// Separator and card outline: ink at low opacity, so it works on any surface.
    static let hairline = Color(light: 0x263B2E, dark: 0xECE8DC, lightAlpha: 0.08, darkAlpha: 0.10)

    // The burger's layers, which double as the menu's colors. Slightly dimmed in dark mode.
    static let bun = Color(light: 0xDE9F79, dark: 0xD09169)
    static let lettuce = Color(light: 0x8FAE5F, dark: 0x82A055)
    static let tomato = Color(light: 0xBC5039, dark: 0xB04A35)
    static let cheese = Color(light: 0xF1C95A, dark: 0xE0BA52)
    static let patty = Color(light: 0x7A4A2A, dark: 0x8C5933)
    static let counter = Color(light: 0xC29465, dark: 0xA9804F)
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255)
    }

    /// A color that resolves to `light` or `dark` hex depending on the current appearance.
    init(light: UInt32, dark: UInt32, lightAlpha: Double = 1, darkAlpha: Double = 1) {
        self.init(uiColor: UIColor { traits in
            let isDark = traits.userInterfaceStyle == .dark
            let hex = isDark ? dark : light
            return UIColor(
                red: CGFloat((hex >> 16) & 0xFF) / 255,
                green: CGFloat((hex >> 8) & 0xFF) / 255,
                blue: CGFloat(hex & 0xFF) / 255,
                alpha: isDark ? darkAlpha : lightAlpha)
        })
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

    /// A card surface. Light mode lifts it with a soft shadow; dark mode uses a hairline instead.
    /// For nested surfaces, set the inner radius to this radius minus the padding between them.
    func cardBackground(radius: CGFloat = 20) -> some View {
        modifier(CardBackground(radius: radius))
    }
}

private struct CardBackground: ViewModifier {
    let radius: CGFloat
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        let shape = RoundedRectangle(cornerRadius: radius, style: .continuous)
        content
            .background(Theme.card, in: shape)
            .overlay {
                if colorScheme == .dark {
                    shape.strokeBorder(Theme.hairline, lineWidth: 1)
                }
            }
            .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.06), radius: 8, y: 2)
    }
}

/// A filled green pill button, like "Start cooking".
struct PillButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        let pressed = configuration.isPressed && isEnabled
        configuration.label
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Theme.onGreen)
            .padding(.horizontal, 16)
            .padding(.vertical, 9)
            .background(Theme.green, in: .capsule)
            .scaleEffect(pressed && !reduceMotion ? 0.96 : 1)
            .opacity(pressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.15), value: pressed)
    }
}
