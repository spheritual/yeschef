public struct Household: Codable, Sendable, Hashable {
    public var members: [Member]
    public var weeklyBudget: Double?

    public struct Member: Codable, Sendable, Hashable, Identifiable {
        public var name: String
        public var cookingSkill: String
        public var likes: [String]
        // Allergies, restrictions and dislikes; every entry is a hard rule.
        public var avoid: [String]
        public var diet: String?
        // Health goals in plain words, such as "high protein" or "under 650 calories a dinner".
        public var goals: [String]

        public var id: String { name }

        public init(name: String, cookingSkill: String = "beginner", likes: [String] = [], avoid: [String] = [], diet: String? = nil, goals: [String] = []) {
            self.name = name
            self.cookingSkill = cookingSkill
            self.likes = likes
            self.avoid = avoid
            self.diet = diet
            self.goals = goals
        }
    }

    public init(members: [Member], weeklyBudget: Double? = nil) {
        self.members = members
        self.weeklyBudget = weeklyBudget
    }

    public var bannedTerms: Set<String> {
        Set(members.flatMap(\.avoid))
    }
}
