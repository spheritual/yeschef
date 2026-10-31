import Foundation

public enum HardRules {
    // Runs before ranking, which keeps allergies out of the model's reach. Matching is a
    // case-insensitive substring, and blank terms are dropped because an empty term would match
    // every ingredient.
    public static func excluding<Item>(_ items: [Item], ingredients: (Item) -> [String], banned: Set<String>) -> [Item] {
        let terms = banned
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
            .filter { !$0.isEmpty }
        guard !terms.isEmpty else { return items }
        return items.filter { item in
            !ingredients(item).contains { name in terms.contains { mentions(name, $0) } }
        }
    }

    // Gemma writes notes like "cornbread mix (ensure peanut-free)". Phrases saying the item is
    // free of the term are cut before matching, and anything else naming the term still counts,
    // which keeps "(contains peanuts)" a match.
    static func mentions(_ ingredient: String, _ term: String) -> Bool {
        var text = ingredient.lowercased()
        for phrase in ["\(term)-free", "\(term) free", "free of \(term)", "free from \(term)", "no \(term)", "without \(term)", "non-\(term)"] {
            text = text.replacingOccurrences(of: phrase, with: " ")
        }
        return text.contains(term)
    }
}
