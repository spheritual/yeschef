import SwiftUI

/// The pose's hand position in the 136 x 153 box. The arms hang from the shoulders at y = 108.
private func handPoint(angle: Double, x: CGFloat, mirror: Double) -> CGPoint {
    let a = angle * mirror * .pi / 180
    return CGPoint(x: x - 30 * sin(a), y: 108 + 30 * cos(a))
}

/// Whatever Basil holds, drawn over his body: a whisk, a wooden spoon, or his cookbook.
struct BasilHeldItem: View {
    let pose: BasilPose
    let t: Double

    var body: some View {
        switch pose.held {
        case .none:
            EmptyView()
        case .whisk:
            let hand = handPoint(angle: pose.rightArm, x: 102, mirror: -1)
            Whisk()
                .rotationEffect(.degrees(-pose.rightArm * 0.6 + 10), anchor: .bottom)
                .frame(width: 18, height: 40)
                .position(x: hand.x + 2, y: hand.y - 14)
        case .spoon:
            let hand = handPoint(angle: pose.rightArm, x: 102, mirror: -1)
            WoodenSpoon()
                .rotationEffect(.degrees(35 - pose.rightArm * 0.5), anchor: .bottom)
                .frame(width: 14, height: 44)
                .position(x: hand.x + 4, y: hand.y - 14)
        case .book:
            OpenBook()
                .frame(width: 58, height: 34)
                .rotationEffect(.degrees(sin(t * 3) * 1.5))
                .position(x: 68, y: 124)
        }
    }
}

private struct Whisk: View {
    var body: some View {
        ZStack {
            Capsule().fill(Color(red: 0.62, green: 0.42, blue: 0.26)).frame(width: 5, height: 18).offset(y: 12)
            ZStack {
                ForEach([1.0, 0.62, 0.26], id: \.self) { w in
                    Ellipse().stroke(Color(white: 0.88), lineWidth: 1.4).frame(width: 14 * w, height: 22)
                }
            }
            .offset(y: -8)
        }
    }
}

private struct WoodenSpoon: View {
    var body: some View {
        let wood = Color(red: 0.74, green: 0.52, blue: 0.32)
        return ZStack {
            Capsule().fill(wood).frame(width: 4.5, height: 30).offset(y: 6)
            Ellipse().fill(wood).frame(width: 13, height: 16).offset(y: -14)
            Ellipse().fill(Color.black.opacity(0.12)).frame(width: 8, height: 10).offset(y: -14)
        }
    }
}

private struct OpenBook: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous).fill(Theme.tomato)
                .frame(width: 58, height: 34).offset(y: 2)
            HStack(spacing: 1) {
                page.rotation3DEffect(.degrees(8), axis: (x: 0, y: 1, z: 0))
                page.rotation3DEffect(.degrees(-8), axis: (x: 0, y: 1, z: 0))
            }
            .frame(width: 54, height: 30)
        }
        .shadow(color: .black.opacity(0.18), radius: 2, y: 1)
    }

    private var page: some View {
        VStack(alignment: .leading, spacing: 3) {
            ForEach(0..<4, id: \.self) { i in
                Capsule().fill(Color(white: 0.7)).frame(width: i == 3 ? 12 : 20, height: 1.5)
            }
        }
        .padding(4)
        .frame(width: 26, height: 30, alignment: .topLeading)
        .background(Color(red: 1, green: 0.98, blue: 0.93), in: RoundedRectangle(cornerRadius: 3, style: .continuous))
    }
}

/// Floating extras for a few moods: hearts and sparkles for a great rating, a falling tear for a
/// bad one, a question mark when he is lost.
struct BasilExtras: View {
    let mood: BasilMood
    let t: Double

    var body: some View {
        switch mood {
        case .yum:
            ZStack {
                ForEach(0..<6, id: \.self) { i in
                    let phase = (t * 0.7 + Double(i) / 6).truncatingRemainder(dividingBy: 1)
                    Image(systemName: i.isMultiple(of: 2) ? "heart.fill" : "sparkle")
                        .font(.system(size: i.isMultiple(of: 2) ? 14 : 16))
                        .foregroundStyle(i.isMultiple(of: 2) ? Color.pink : Color.yellow)
                        .opacity(sin(phase * .pi))
                        .scaleEffect(0.6 + phase * 0.6)
                        .position(x: [20, 112, 12, 124, 36, 100][i] + sin(t * 2 + Double(i)) * 4, y: 80 - phase * 70)
                }
            }
        case .yuck:
            let phase = (t * 0.8).truncatingRemainder(dividingBy: 1)
            Image(systemName: "drop.fill")
                .font(.system(size: 9))
                .foregroundStyle(Color.cyan.opacity(0.85 * (1 - phase * phase)))
                .position(x: 82, y: 86 + phase * 40)
        case .confused:
            Text("?")
                .font(.system(size: 28, weight: .heavy, design: .rounded))
                .foregroundStyle(Theme.tomato)
                .rotationEffect(.degrees(sin(t * 3) * 8))
                .position(x: 112, y: 30 + sin(t * 2.5) * 3)
        default:
            EmptyView()
        }
    }
}

/// The clock on the wall Basil watches while a timer runs.
struct WallClock: View {
    let t: Double

    var body: some View {
        ZStack {
            // A fixed dark ink: Theme.ink turns light in dark mode and would vanish on the white face.
            Circle().fill(.white)
            Circle().stroke(Color(hex: 0x263B2E), lineWidth: 2)
            Rectangle().fill(Color(hex: 0x263B2E))
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

/// The frying pan Basil stirs while Gemma thinks, with steam curling up from it.
struct SteamingPan: View {
    let t: Double
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                let phase = (t * 0.6 + Double(i) / 3).truncatingRemainder(dividingBy: 1)
                Capsule()
                    .fill(scheme == .dark ? Color.white : Color.gray)
                    .frame(width: 4, height: 14)
                    .blur(radius: 1.5)
                    .opacity(0.5 * sin(phase * .pi))
                    .offset(x: Double(i - 1) * 11 + sin(t * 2 + Double(i) * 2) * 3, y: -12 - phase * 24)
            }
            // Handle, then the pan itself with a light rim so it reads on a dark stage.
            Capsule().fill(Color(white: 0.3)).frame(width: 26, height: 5).offset(x: 31, y: -1)
            Capsule().fill(Color(white: 0.2)).frame(width: 44, height: 12)
                .overlay(Capsule().stroke(Color(white: scheme == .dark ? 0.6 : 0.4), lineWidth: 1.2))
        }
    }
}
