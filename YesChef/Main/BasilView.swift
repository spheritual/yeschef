import SwiftUI

/// Basil, animated by mood: breathing at rest, a bounce while cooking or talking, a tilt when
/// listening or confused. Reduce Motion freezes it.
struct BasilView: View {
    let mood: BasilMood
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { context in
            let t = reduceMotion ? 0 : context.date.timeIntervalSinceReferenceDate
            ZStack {
                if mood == .listening {
                    let pulse = reduceMotion ? 0 : (t * 1.5).truncatingRemainder(dividingBy: 1)
                    Circle().stroke(Theme.green.opacity(0.5 * (1 - pulse)), lineWidth: 3)
                        .frame(width: 90, height: 90)
                        .scaleEffect(1 + pulse * 0.6)
                        .offset(y: -20)
                }
                BasilFigure(mood: mood)
                    .modifier(BasilMotion(mood: mood, t: t, reduceMotion: reduceMotion))
            }
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

/// Basil's art, exported from the Figma proposal (node 9:22). Confusion shows as a tilt and a "?".
private struct BasilFigure: View {
    let mood: BasilMood

    var body: some View {
        Image("Basil")
            .resizable()
            .scaledToFit()
            .overlay(alignment: .topTrailing) {
                if mood == .confused {
                    Text("?").font(.system(size: 26, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.tomato)
                }
            }
            .frame(width: 136, height: 153)
    }
}

#Preview {
    VStack {
        ForEach([BasilMood.idle, .listening, .cooking, .talking, .confused], id: \.self) { BasilView(mood: $0) }
    }
    .padding()
    .background(Theme.stage)
}
