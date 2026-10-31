import Foundation

// The shopping list as an editable notepad: items come from the week's plan, the cook can add,
// rename, check off and delete them, and the whole list is saved to a file after each change.
public struct ShoppingList: Codable, Sendable, Hashable {
    public struct Item: Codable, Sendable, Hashable, Identifiable {
        public var id: UUID
        public var text: String
        public var done: Bool
        // Plan items are replaced when a new plan arrives; the cook's own items never are.
        public var fromPlan: Bool

        public init(text: String, done: Bool = false, fromPlan: Bool = false) {
            id = UUID()
            self.text = text
            self.done = done
            self.fromPlan = fromPlan
        }
    }

    public var items: [Item]

    public init(items: [Item] = []) {
        self.items = items
    }

    public init(plan: WeekPlan) {
        items = plan.shoppingList.map { Item(text: $0, fromPlan: true) }
    }

    public var remaining: Int {
        items.count { !$0.done }
    }

    // A new plan replaces the old plan's items, keeps the cook's own items, and keeps the check
    // on anything already bought that the new plan still needs.
    public mutating func sync(with plan: WeekPlan) {
        let bought = Set(items.filter(\.done).map { $0.text.lowercased() })
        let own = items.filter { !$0.fromPlan }
        let ownTexts = Set(own.map { $0.text.lowercased() })
        items = plan.shoppingList
            .filter { !ownTexts.contains($0.lowercased()) }
            .map { Item(text: $0, done: bought.contains($0.lowercased()), fromPlan: true) } + own
    }

    public mutating func add(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        items.append(Item(text: trimmed))
    }

    public mutating func clearDone() {
        items.removeAll(where: \.done)
    }

    public static func load(from url: URL) -> ShoppingList? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(ShoppingList.self, from: data)
    }

    public func save(to url: URL) throws {
        try JSONEncoder().encode(self).write(to: url, options: .atomic)
    }
}
