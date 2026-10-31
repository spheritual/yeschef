import SwiftUI

/// Basil, animated by mood. He cooks with the pan while Gemma thinks (the pan is drawn by the
/// stage), hops while you talk to him, reads from a cookbook when he teaches, watches the wall
/// clock while a timer runs, and reacts to ratings: sparkles and a belly rub for a great one, a spit
/// at the screen for a bad one. Reduce Motion freezes the movement but keeps the props.
struct BasilView: View {
    let mood: BasilMood
    /// The asset name of the outfit he's wearing, from the wardrobe.
    var outfit = "Basil"
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
                if mood == .timer {
                    WallClock(t: t)
                        .offset(x: 50, y: -55)
                }
                BasilFigure(mood: mood, outfit: outfit)
                    .modifier(BasilMotion(mood: mood, t: t, reduceMotion: reduceMotion))
                BasilProps(mood: mood, t: t)
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
        case .teaching: "reading from his cookbook"
        case .timer: "watching the clock"
        case .yum: "delighted"
        case .yuck: "disgusted"
        case .confused: "confused"
        }
    }
}

/// Each mood's movement: breathing, a bounce or hop, a tilt or a head shake.
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
        case .listening: return abs(sin(t * 7)) * 12
        case .talking, .teaching: return abs(sin(t * 4)) * 2
        case .yum: return abs(sin(t * 4)) * 4
        default: return 0
        }
    }

    private var tilt: Double {
        switch mood {
        case .confused: reduceMotion ? 6 : 6 + sin(t * 3) * 3
        case .timer: 8
        case .yuck: reduceMotion ? 0 : sin(t * 25) * 7
        case .yum: reduceMotion ? 0 : sin(t * 4) * 4
        default: 0
        }
    }
}

/// What Basil holds or what flies around him for each mood.
private struct BasilProps: View {
    let mood: BasilMood
    let t: Double

    var body: some View {
        switch mood {
        case .teaching:
            Image(systemName: "book.fill")
                .font(.system(size: 30))
                .foregroundStyle(Theme.tomato)
                .rotationEffect(.degrees(-12 + sin(t * 3) * 4))
                .offset(x: -44, y: 28)
        case .yum:
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    Image(systemName: "sparkle")
                        .font(.system(size: index.isMultiple(of: 2) ? 18 : 12))
                        .foregroundStyle(.yellow)
                        .opacity(0.4 + 0.6 * abs(sin(t * 3 + Double(index))))
                        .offset(x: [-56, 52, -40, 60, 0][index], y: [-50, -30, 10, 30, -72][index])
                }
                // A hand rubbing his belly in small circles.
                Image(systemName: "hand.raised.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color(red: 0.94, green: 0.77, blue: 0.62))
                    .offset(x: cos(t * 7) * 6, y: 40 + sin(t * 7) * 4)
            }
        case .yuck:
            // Drops that grow and fade as they fly at the screen.
            ZStack {
                ForEach(0..<4, id: \.self) { index in
                    let phase = (t * 1.2 + Double(index) * 0.25).truncatingRemainder(dividingBy: 1)
                    Image(systemName: "drop.fill")
                        .font(.system(size: 10 + phase * 40))
                        .foregroundStyle(Color.cyan.opacity(0.8 * (1 - phase)))
                        .offset(x: Double(index - 2) * 36 * phase, y: -10 + phase * 60)
                }
            }
        default:
            EmptyView()
        }
    }
}

/// The clock on the wall Basil watches while a timer runs.
private struct WallClock: View {
    let t: Double

    var body: some View {
        ZStack {
            Circle().fill(.white)
            Circle().stroke(Theme.ink, lineWidth: 2)
            Rectangle().fill(Theme.ink)
                .frame(width: 2, height: 9)
                .offset(y: -4.5)
                .rotationEffect(.degrees(120))
            Rectangle().fill(Theme.tomato)
                .frame(width: 1.5, height: 12)
                .offset(y: -6)
                .rotationEffect(.degrees(t * 36))
        }
        .frame(width: 32, height: 32)
    }
}

/// Basil's art, exported from the Figma proposal (node 9:22). Confusion shows as a tilt and a "?".
private struct BasilFigure: View {
    let mood: BasilMood
    let outfit: String

    var body: some View {
        Image(outfit)
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
    ScrollView {
        VStack {
            ForEach([BasilMood.idle, .listening, .cooking, .talking, .teaching, .timer, .yum, .yuck, .confused], id: \.self) {
                BasilView(mood: $0)
            }
        }
        .padding()
    }
    .background(Theme.stage)
}
