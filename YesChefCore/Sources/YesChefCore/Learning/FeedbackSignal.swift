public enum FeedbackSignal: Codable, Sendable, Hashable {
    case rated(stars: Int)
    case cooked
    case swapped
    case skipped

    // Rewards run 0 to 1; the values for the unrated signals are set in the spec.
    public var reward: Double {
        switch self {
        case .rated(let stars): Double(min(max(stars, 1), 5) - 1) / 4
        case .cooked: 0.8
        case .swapped: 0.1
        case .skipped: 0.3
        }
    }
}
