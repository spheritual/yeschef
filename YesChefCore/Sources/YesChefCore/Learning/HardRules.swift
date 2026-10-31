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
            let names = ingredients(item).map { $0.lowercased() }
            return !names.contains { name in terms.contains { name.contains($0) } }
        }
    }
}
