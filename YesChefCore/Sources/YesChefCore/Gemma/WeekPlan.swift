public struct WeekPlan: Codable, Sendable, Hashable {
    public var days: [Day]

    public struct Day: Codable, Sendable, Hashable, Identifiable {
        public var day: String
        public var isBusy: Bool
        public var pick: DinnerIdea
        // The other safe ideas in ranked order, offered as swaps.
        public var alternatives: [DinnerIdea]

        public var id: String { day }

        public init(day: String, isBusy: Bool, pick: DinnerIdea, alternatives: [DinnerIdea]) {
            self.day = day
            self.isBusy = isBusy
            self.pick = pick
            self.alternatives = alternatives
        }
    }

    public init(days: [Day]) {
        self.days = days
    }

    // Ingredient names across the week's picks, deduplicated ignoring case, in first-seen order.
    public var shoppingList: [String] {
        var seen = Set<String>()
        return days.flatMap(\.pick.ingredients).filter { seen.insert($0.lowercased()).inserted }
    }
}

struct WeekReply: Decodable {
    struct Day: Decodable {
        let day: String
        let ideas: [DinnerIdeaReply]
    }
    let days: [Day]
}
