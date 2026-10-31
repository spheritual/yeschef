import SwiftUI

/// Basil the jelly chef, animated by mood. He breathes while he waits, hops while you talk to him,
/// reads from a cookbook when he teaches, watches the wall clock while a timer runs, cooks with a
/// spoon while Gemma thinks (the stage draws the pan), and reacts to ratings. The art lives in
/// `YesChef/Basil/`. Reduce Motion freezes him in a still pose but keeps the props.
struct BasilView: View {
    let mood: BasilMood
    /// The outfit he wears, from the wardrobe: the asset name of an outfit, or "Basil" for none.
    var outfit = "Basil"
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.colorScheme) private var scheme
    @State private var changedAt = Date.distantPast

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { context in
            let now = context.date.timeIntervalSinceReferenceDate
            let t = reduceMotion ? 0 : now
            let pose = BasilPose(mood: mood, t: t)
            let kick = reduceMotion ? 0 : springKick(since: context.date.timeIntervalSince(changedAt))
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
                // Contact shadow: shrinks and fades while he is in the air.
                Ellipse()
                    .fill(.black.opacity((scheme == .dark ? 0.5 : 0.18) * (1 - min(pose.lift / 40, 0.5))))
                    .frame(width: 78 - pose.lift, height: 9)
                    .blur(radius: 3)
                    .offset(y: 72)
                ZStack {
                    JellyBasil(pose: pose, outfit: outfit)
                    BasilHeldItem(pose: pose, t: t)
                }
                .scaleEffect(x: pose.sx * (1 - kick), y: pose.sy * (1 + kick), anchor: .bottom)
                .rotationEffect(.degrees(pose.tilt), anchor: .bottom)
                .offset(y: -pose.lift)
                if mood == .cooking {
                    SteamingPan(t: t)
                        .position(x: 112, y: 146)
                }
                BasilExtras(mood: mood, t: t)
                    .frame(width: 136, height: 153)
                    .offset(y: -pose.lift * 0.5)
            }
        }
        .frame(width: 136, height: 153)
        .onChange(of: mood) { changedAt = .now }
        .accessibilityElement()
        .accessibilityLabel("Basil, \(label)")
    }

    /// A damped spring for the moment the mood changes: a quick stretch that settles with a wobble.
    private func springKick(since seconds: TimeInterval) -> Double {
        guard seconds >= 0, seconds < 1.2 else { return 0 }
        return exp(-seconds * 6) * sin(seconds * 20) * 0.1
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

#Preview {
    ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 140))]) {
            ForEach([BasilMood.idle, .listening, .cooking, .talking, .teaching, .timer, .yum, .yuck, .confused], id: \.self) {
                BasilView(mood: $0)
            }
        }
        .padding()
    }
    .background(Theme.stage)
}
