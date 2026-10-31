import SwiftUI

/// Basil's jelly body drawn in a 136 x 153 box: a green gummi bear with a chef's hat. Pass the pose
/// for the current frame; nothing here animates by itself.
struct JellyBasil: View {
    let pose: BasilPose
    @Environment(\.colorScheme) private var scheme

    private var dark: Bool { scheme == .dark }
    private let core = Color(red: 0.62, green: 0.97, blue: 0.70)
    private var edge: Color { dark ? Color(red: 0.20, green: 0.68, blue: 0.40) : Color(red: 0.14, green: 0.55, blue: 0.31) }

    var body: some View {
        ZStack {
            if pose.sadEyes {
                // Melting: a puddle of jelly spreading under him.
                Ellipse().fill(edge.opacity(0.55)).frame(width: 112, height: 12).blur(radius: 1.5)
                    .position(x: 68, y: 147)
            }
            jelly
            apron
            hat
            BasilFace(pose: pose)
                .position(x: 68, y: 78)
        }
        .frame(width: 136, height: 153)
    }

    // MARK: Jelly

    /// The union of every jelly part, used as a mask so overlaps never double up the translucency.
    private var silhouette: some View {
        ZStack {
            Circle().frame(width: 22, height: 22).position(x: 40, y: 54)
            Circle().frame(width: 22, height: 22).position(x: 96, y: 54)
            Circle().frame(width: 66, height: 66).position(x: 68, y: 76)
            Ellipse().frame(width: 78, height: 60).position(x: 68, y: 122)
            arm(angle: pose.leftArm, x: 34, mirror: 1)
            arm(angle: pose.rightArm, x: 102, mirror: -1)
        }
        .frame(width: 136, height: 153)
    }

    private func arm(angle: Double, x: CGFloat, mirror: Double) -> some View {
        Capsule().frame(width: 16, height: 34)
            .rotationEffect(.degrees(angle * mirror), anchor: .top)
            .position(x: x, y: 108 + 17)
    }

    private var jelly: some View {
        ZStack {
            // Translucent body: mint core fading to a deeper green edge.
            RadialGradient(colors: [core, edge], center: UnitPoint(x: 0.42, y: 0.5), startRadius: 6, endRadius: 85)
                .opacity(0.86)
                .mask(silhouette)
            // Light caught inside the jelly, low in the belly.
            Ellipse().fill(Color.white.opacity(dark ? 0.16 : 0.28))
                .frame(width: 44, height: 16).blur(radius: 6)
                .position(x: 74, y: 140)
                .mask(silhouette)
            // Rim light along the lower edge: the body minus itself nudged up leaves a crescent.
            LinearGradient(colors: [.clear, Color.white.opacity(dark ? 0.55 : 0.7)], startPoint: .center, endPoint: .bottom)
                .mask {
                    ZStack {
                        silhouette
                        silhouette.offset(y: -3.5).blendMode(.destinationOut)
                    }
                    .compositingGroup()
                }
            // Big soft specular blob and a sharp glint on the head, a streak on the belly.
            Ellipse().fill(Color.white.opacity(0.75))
                .frame(width: 24, height: 13).blur(radius: 3.5)
                .rotationEffect(.degrees(-28))
                .position(x: 52, y: 60)
            Circle().fill(.white).frame(width: 5, height: 5)
                .position(x: 43, y: 66)
            Ellipse().fill(Color.white.opacity(0.4))
                .frame(width: 8, height: 24).blur(radius: 2.5)
                .rotationEffect(.degrees(12))
                .position(x: 41, y: 120)
            // Soft pink cheeks.
            Ellipse().fill(Color(red: 1, green: 0.55, blue: 0.55).opacity(0.55)).frame(width: 11, height: 7).blur(radius: 2)
                .position(x: 46, y: 88)
            Ellipse().fill(Color(red: 1, green: 0.55, blue: 0.55).opacity(0.55)).frame(width: 11, height: 7).blur(radius: 2)
                .position(x: 90, y: 88)
        }
        .compositingGroup()
    }

    // MARK: Apron and hat

    private var apron: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 9, style: .continuous)
                .fill(LinearGradient(colors: [.white, Color(white: 0.9)], startPoint: .top, endPoint: .bottom))
                .frame(width: 38, height: 30)
            RoundedRectangle(cornerRadius: 3, style: .continuous)
                .stroke(Color(white: 0.78), lineWidth: 1)
                .frame(width: 16, height: 9).offset(y: 5)
        }
        .position(x: 68, y: 128)
    }

    private var hat: some View {
        let fill = LinearGradient(colors: [.white, Color(red: 0.94, green: 0.97, blue: 0.95)], startPoint: .top, endPoint: .bottom)
        return ZStack {
            Circle().fill(fill).frame(width: 24, height: 24).position(x: 54, y: 33)
            Circle().fill(fill).frame(width: 24, height: 24).position(x: 82, y: 33)
            Circle().fill(fill).frame(width: 30, height: 30).position(x: 68, y: 26)
            RoundedRectangle(cornerRadius: 5, style: .continuous).fill(fill)
                .frame(width: 48, height: 15).position(x: 68, y: 46)
            // Fold lines and the shadow where the band meets the puffs.
            Capsule().fill(Color.black.opacity(0.07)).frame(width: 44, height: 3).position(x: 68, y: 40)
            Capsule().fill(Color.black.opacity(0.07)).frame(width: 1.5, height: 10).position(x: 61, y: 46)
            Capsule().fill(Color.black.opacity(0.07)).frame(width: 1.5, height: 10).position(x: 75, y: 46)
            Ellipse().fill(Color.white.opacity(0.9)).frame(width: 8, height: 5).blur(radius: 1.5)
                .position(x: 60, y: 22)
        }
        .shadow(color: .black.opacity(0.12), radius: 2, y: 1)
    }
}

/// Eyes and mouth. Dark glossy beads, a small smile; moods bend them happy, sad or lopsided.
struct BasilFace: View {
    let pose: BasilPose
    private let ink = Color(red: 0.08, green: 0.13, blue: 0.10)

    var body: some View {
        ZStack {
            eye(x: -12, size: CGSize(width: 9, height: 11.5))
            eye(x: 12, size: CGSize(width: 9, height: 11.5))
            MouthShape(curve: pose.mouthCurve, open: pose.mouthOpen)
                .stroke(ink, style: StrokeStyle(lineWidth: 2.2, lineCap: .round, lineJoin: .round))
                .overlay {
                    MouthShape(curve: pose.mouthCurve, open: pose.mouthOpen).fill(ink)
                }
                .frame(width: 18, height: 16)
                .offset(y: 11)
            if pose.sadEyes {
                // Worried brows slanting up toward the middle.
                brow(x: -12, angle: -18)
                brow(x: 12, angle: 18)
            }
        }
        .offset(pose.look)
    }

    private func brow(x: CGFloat, angle: Double) -> some View {
        Capsule().fill(ink).frame(width: 9, height: 2)
            .rotationEffect(.degrees(angle)).offset(x: x, y: -11)
    }

    @ViewBuilder
    private func eye(x: CGFloat, size: CGSize) -> some View {
        if pose.happyEyes {
            // Closed, smiling arcs.
            ArcShape().stroke(ink, style: StrokeStyle(lineWidth: 2.6, lineCap: .round))
                .frame(width: 10, height: 6).offset(x: x, y: 0)
        } else {
            ZStack {
                Ellipse().fill(ink)
                Circle().fill(.white).frame(width: 3.4, height: 3.4).offset(x: -1.6, y: -2.6)
                Circle().fill(.white.opacity(0.7)).frame(width: 1.6, height: 1.6).offset(x: 1.6, y: 2.4)
            }
            .frame(width: size.width, height: size.height * (pose.sadEyes ? 0.8 : 1))
            .scaleEffect(y: max(pose.eyeOpen, 0.08))
            .offset(x: x, y: pose.sadEyes ? 2 : 0)
        }
    }
}

/// The smile. `curve` runs from -1 (frown) to 1 (grin); `open` drops the lower lip for a mouth.
nonisolated struct MouthShape: Shape {
    var curve: Double
    var open: Double

    var animatableData: AnimatablePair<Double, Double> {
        get { AnimatablePair(curve, open) }
        set { curve = newValue.first; open = newValue.second }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let left = CGPoint(x: rect.midX - 7, y: rect.midY)
        let right = CGPoint(x: rect.midX + 7, y: rect.midY)
        path.move(to: left)
        path.addQuadCurve(to: right, control: CGPoint(x: rect.midX, y: rect.midY + 7 * curve))
        if open > 0.05 {
            path.addQuadCurve(to: left, control: CGPoint(x: rect.midX, y: rect.midY + 7 * curve + 14 * open))
        }
        return path
    }
}

private nonisolated struct ArcShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.6))
        return path
    }
}
