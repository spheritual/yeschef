// A change to one day of the plan, from a swap the cook picked or from what they told Basil.
public struct PlanChange: Sendable, Hashable {
    public let day: String
    public let idea: DinnerIdea

    public init(day: String, idea: DinnerIdea) {
        self.day = day
        self.idea = idea
    }
}

// Basil's answer to the cook, with the plan change they asked for when there was one.
public struct ChefReply: Sendable, Hashable {
    public let answer: String
    public let change: PlanChange?
}

extension WeekPlan {
    // The new idea becomes the day's pick, and the old pick becomes the first swap.
    public func replacing(day: String, with idea: DinnerIdea) -> WeekPlan {
        guard let index = days.firstIndex(where: { $0.day.lowercased() == day.lowercased() }),
              days[index].pick.title != idea.title else { return self }
        var copy = self
        let old = copy.days[index].pick
        copy.days[index].alternatives = [old] + copy.days[index].alternatives.filter { $0.title != idea.title }
        copy.days[index].pick = idea
        return copy
    }
}

struct ChefReplyJSON: Decodable {
    struct Change: Decodable {
        let day: String
        let idea: DinnerIdea

        private enum Keys: String, CodingKey { case day }

        init(from decoder: any Decoder) throws {
            day = try decoder.container(keyedBy: Keys.self).decode(String.self, forKey: .day)
            idea = try DinnerIdeaReply(from: decoder).idea
        }
    }

    let answer: String
    let change: Change?
}
