import SwiftUI

/// Basil, drawn in SwiftUI until there is exported art. Swap the body of `BasilFigure` for an
/// image and keep `BasilView`, which animates it by mood.
struct BasilView: View {
    let mood: BasilMood
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { context in
            let t = reduceMotion ? 0 : context.date.timeIntervalSinceReferenceDate
            BasilFigure(mood: mood, mouthOpen: mood == .talking && !reduceMotion && sin(t * 11) > 0)
                .modifier(BasilMotion(mood: mood, t: t, reduceMotion: reduceMotion))
        }
        .frame(width: 136, height: 153)
        .accessibilityElement()
        .accessibilityLabel("Basil, \(label)")
    }

    private var label: String {
        switch mood {
        case .idle: "waiting"
        case .listening: "listening"
        case .cooking: "cooking"
        case .talking: "talking"
        case .confused: "confused"
        }
    }
}

/// Each mood's movement: breathing, a bounce, a head tilt.
private struct BasilMotion: ViewModifier {
    let mood: BasilMood
    let t: Double
    let reduceMotion: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(x: 1 + breathe * 0.4, y: 1 - breathe * 0.4, anchor: .bottom)
            .rotationEffect(.degrees(tilt), anchor: .bottom)
            .offset(y: -bounce)
    }

    private var breathe: Double {
        reduceMotion ? 0 : sin(t * 2) * 0.03
    }

    private var bounce: Double {
        guard !reduceMotion else { return 0 }
        switch mood {
        case .cooking: return abs(sin(t * 6)) * 6
        case .talking: return abs(sin(t * 5)) * 3
        default: return 0
        }
    }

    private var tilt: Double {
        switch mood {
        case .confused: reduceMotion ? 6 : 6 + sin(t * 3) * 3
        case .listening: reduceMotion ? -4 : -4 + sin(t * 2.5) * 2
        default: 0
        }
    }
}

private struct BasilFigure: View {
    let mood: BasilMood
    let mouthOpen: Bool

    private let skin = Color(hex: 0xF3C9A0)
    private let outline = Color(hex: 0x263B2E)

    var body: some View {
        ZStack {
            // Shoes
            HStack(spacing: 18) {
                Capsule().fill(outline).frame(width: 30, height: 12)
                Capsule().fill(outline).frame(width: 30, height: 12)
            }
            .offset(y: 70)

            // Jacket, arms and apron
            RoundedRectangle(cornerRadius: 28).fill(.white)
                .overlay(RoundedRectangle(cornerRadius: 28).stroke(outline, lineWidth: 2))
                .frame(width: 84, height: 74)
                .offset(y: 38)
            Circle().fill(skin).overlay(Circle().stroke(outline, lineWidth: 2))
                .frame(width: 22, height: 22).offset(x: -52, y: 22)
            Circle().fill(skin).overlay(Circle().stroke(outline, lineWidth: 2))
                .frame(width: 22, height: 22).offset(x: 52, y: mood == .cooking ? 8 : 22)
            if mood == .cooking {
                Capsule().fill(Theme.counter).frame(width: 6, height: 34)
                    .rotationEffect(.degrees(12)).offset(x: 58, y: -10)
            }
            RoundedRectangle(cornerRadius: 14).fill(Theme.green)
                .overlay(RoundedRectangle(cornerRadius: 14).stroke(outline, lineWidth: 2))
                .frame(width: 54, height: 58)
                .offset(y: 46)
            RoundedRectangle(cornerRadius: 6).stroke(Color.white.opacity(0.5), lineWidth: 1.5)
                .frame(width: 26, height: 14).offset(y: 56)

            // Neckerchief and head
            Capsule().fill(Theme.tomato).frame(width: 30, height: 12).offset(y: 12)
            head.offset(y: -22)
            hat.offset(y: -62)
        }
        .frame(width: 136, height: 153)
    }

    private var head: some View {
        ZStack {
            Circle().fill(skin).overlay(Circle().stroke(outline, lineWidth: 2))
                .frame(width: 66, height: 66)
            Circle().fill(Color(hex: 0xE9967A).opacity(0.6)).frame(width: 12, height: 12).offset(x: -21, y: 8)
            Circle().fill(Color(hex: 0xE9967A).opacity(0.6)).frame(width: 12, height: 12).offset(x: 21, y: 8)
            HStack(spacing: 20) {
                eye
                eye
            }
            .offset(y: -2)
            if mood == .confused {
                Capsule().fill(outline).frame(width: 12, height: 2.5)
                    .rotationEffect(.degrees(-12)).offset(x: 12, y: -14)
            }
            mouth.offset(y: 16)
            if mood == .confused {
                Text("?").font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.tomato).offset(x: 46, y: -38)
            }
        }
    }

    private var eye: some View {
        Circle().fill(outline)
            .frame(width: mood == .listening ? 10 : 7, height: mood == .listening ? 10 : 7)
    }

    @ViewBuilder private var mouth: some View {
        switch mood {
        case .talking where mouthOpen:
            Ellipse().fill(outline).frame(width: 14, height: 10)
        case .listening:
            Circle().fill(outline).frame(width: 8, height: 8)
        case .confused:
            Capsule().fill(outline).frame(width: 12, height: 3).rotationEffect(.degrees(-6))
        default:
            Smile().stroke(outline, style: StrokeStyle(lineWidth: 2.5, lineCap: .round))
                .frame(width: 18, height: 8)
        }
    }

    private var hat: some View {
        ZStack {
            HStack(spacing: -6) {
                Circle().frame(width: 30, height: 30)
                Circle().frame(width: 36, height: 36).offset(y: -6)
                Circle().frame(width: 30, height: 30)
            }
            .foregroundStyle(.white)
            .offset(y: -8)
            RoundedRectangle(cornerRadius: 6).fill(.white)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(outline, lineWidth: 2))
                .frame(width: 70, height: 18).offset(y: 14)
        }
    }
}

private nonisolated struct Smile: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: CGPoint(x: rect.minX, y: rect.minY))
            p.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY), control: CGPoint(x: rect.midX, y: rect.maxY * 1.8))
        }
    }
}

#Preview {
    VStack {
        ForEach([BasilMood.idle, .listening, .cooking, .talking, .confused], id: \.self) { BasilView(mood: $0) }
    }
    .padding()
    .background(Theme.stage)
}
