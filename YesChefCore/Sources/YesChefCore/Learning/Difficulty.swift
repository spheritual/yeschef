public enum Difficulty: String, Codable, Sendable, CaseIterable {
    case easy, medium, hard

    var level: Double {
        switch self {
        case .easy: 0
        case .medium: 0.5
        case .hard: 1
        }
    }
}
