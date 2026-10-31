import SwiftUI

/// What Basil holds in his hand.
enum BasilHeld { case none, whisk, spoon, book }

/// One frame of Basil's body language, worked out from the mood and the clock. Arm angles are in
/// degrees, positive = swung outward from his side. Everything else is a plain scale or offset.
struct BasilPose {
    var sx = 1.0
    var sy = 1.0
    var lift = 0.0
    var tilt = 0.0
    var leftArm = 10.0
    var rightArm = 10.0
    var mouthCurve = 0.7
    var mouthOpen = 0.0
    var happyEyes = false
    var sadEyes = false
    var look = CGSize.zero
    var eyeOpen = 1.0
    var held = BasilHeld.none

    /// Breathing: a 2.4 s loop that squashes and stretches against his bottom edge.
    private static func breathe(_ t: Double) -> Double { sin(t * 2 * .pi / 2.4) * 0.03 }

    /// A hop: squash before the jump, stretch in the air, squash on landing, then a beat of rest.
    private static func hop(_ t: Double, period: Double, height: Double) -> (lift: Double, sy: Double) {
        let p = (t / period).truncatingRemainder(dividingBy: 1)
        switch p {
        case ..<0.18:
            return (0, 1 - 0.14 * sin(p / 0.18 * .pi / 2))
        case ..<0.68:
            let q = (p - 0.18) / 0.5
            return (height * sin(.pi * q), 1 + 0.1 * sin(.pi * q) - 0.14 * max(0, 1 - q * 4))
        case ..<0.82:
            return (0, 1 - 0.16 * sin((p - 0.68) / 0.14 * .pi))
        default:
            return (0, 1)
        }
    }

    init(mood: BasilMood, t: Double) {
        let b = Self.breathe(t)
        sy = 1 + b
        sx = 1 - b * 0.8
        // A blink every 3.7 s.
        let blinkClock = t.truncatingRemainder(dividingBy: 3.7)
        if blinkClock > 3.55 { eyeOpen = 1 - sin((blinkClock - 3.55) / 0.15 * .pi) }

        switch mood {
        case .idle:
            held = .whisk
            rightArm = 14 + sin(t * 1.3) * 3
        case .listening:
            held = .whisk
            let h = Self.hop(t, period: 1.1, height: 14)
            lift = h.lift
            sy = h.sy
            sx = 1 + (1 - h.sy) * 0.7
            leftArm = 10 + h.lift * 2
            rightArm = 10 + h.lift * 2
            mouthOpen = 0.3
            mouthCurve = 0.5
        case .cooking:
            held = .spoon
            lift = abs(sin(t * 5)) * 3
            rightArm = 58 + sin(t * 5) * 14
            leftArm = 12
            mouthCurve = 0.8
        case .talking:
            held = .whisk
            lift = abs(sin(t * 4)) * 2
            leftArm = 14 + sin(t * 3) * 8
            mouthOpen = abs(sin(t * 9)) * 0.8 * (0.55 + 0.45 * sin(t * 2.3))
        case .teaching:
            held = .book
            tilt = sin(t * 1.6) * 2
            leftArm = 28
            rightArm = 28
            mouthOpen = abs(sin(t * 7)) * 0.4 * (0.5 + 0.5 * sin(t * 1.9))
        case .timer:
            held = .whisk
            tilt = 6
            look = CGSize(width: 2.5, height: -2.5)
            mouthCurve = 0.1
        case .yum:
            let h = Self.hop(t, period: 0.9, height: 18)
            lift = h.lift
            sy = h.sy
            sx = 1 + (1 - h.sy) * 0.7
            leftArm = 140 + sin(t * 8) * 8
            rightArm = 140 - sin(t * 8) * 8
            happyEyes = true
            mouthCurve = 1
            mouthOpen = 0.5
        case .yuck:
            let sag = 0.84 + sin(t * 1.5) * 0.015
            sy = sag
            sx = 1 + (1 - sag) * 0.75
            tilt = sin(t * 14) * 1.2
            leftArm = 3
            rightArm = 3
            sadEyes = true
            mouthCurve = -0.9
        case .confused:
            tilt = 7 + sin(t * 3) * 4
            rightArm = 125 + sin(t * 5) * 10
            leftArm = 12
            look = CGSize(width: sin(t * 1.5) * 2, height: -1)
            mouthCurve = -0.2 + sin(t * 3) * 0.25
        }
    }
}
