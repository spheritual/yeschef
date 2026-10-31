public struct Ranked<Item> {
    public let item: Item
    public let score: Double
    public let expected: Double
    public let uncertainty: Double
}

extension Ranked: Sendable where Item: Sendable {}
