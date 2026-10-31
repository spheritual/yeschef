import Foundation

// Points ("leaves", as the Figma wardrobe calls them) and streaks, kept as a dated log of actions
// and recomputed from it (TR-23). Outfits cost leaves only, never money.
public struct PointsLog: Codable, Sendable, Hashable {
    public enum Action: String, Codable, Sendable, CaseIterable {
        case planned, cooked, rated, asked, imported

        public var leaves: Int {
            switch self {
            case .planned: 10
            case .cooked: 25
            case .rated: 10
            case .asked: 5
            case .imported: 15
            }
        }
    }

    public struct Entry: Codable, Sendable, Hashable {
        public let action: Action
        public let date: Date
    }

    public struct Outfit: Sendable, Hashable, Identifiable {
        // The asset name of Basil wearing it.
        public let id: String
        public let name: String
        public let cost: Int
    }

    // The four outfits from the Figma wardrobe screen, with its prices.
    public static let outfits = [
        Outfit(id: "Basil", name: "Everyday apron", cost: 0),
        Outfit(id: "BasilSundayBaker", name: "Sunday baker", cost: 60),
        Outfit(id: "BasilTomatoClub", name: "Tomato club", cost: 120),
        Outfit(id: "BasilGoldenHour", name: "Golden hour", cost: 300),
    ]

    public private(set) var entries: [Entry] = []
    public private(set) var owned: Set<String> = ["Basil"]
    public private(set) var wearing = "Basil"

    public init() {}

    public mutating func record(_ action: Action, on date: Date = .now) {
        entries.append(Entry(action: action, date: date))
    }

    public var earned: Int {
        entries.reduce(0) { $0 + $1.action.leaves }
    }

    public var balance: Int {
        earned - Self.outfits.filter { owned.contains($0.id) }.reduce(0) { $0 + $1.cost }
    }

    // Days in a row with at least one action, counting back from today, or from yesterday while
    // nothing has happened yet today, which keeps a streak alive until the day is over.
    public func streak(asOf now: Date = .now, calendar: Calendar = .current) -> Int {
        let active = Set(entries.map { calendar.startOfDay(for: $0.date) })
        var day = calendar.startOfDay(for: now)
        if !active.contains(day), let yesterday = calendar.date(byAdding: .day, value: -1, to: day) {
            day = yesterday
        }
        var count = 0
        while active.contains(day) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return count
    }

    // Buys an outfit and puts it on, if there are enough leaves. Returns false otherwise.
    @discardableResult
    public mutating func buy(_ outfit: Outfit) -> Bool {
        guard !owned.contains(outfit.id), balance >= outfit.cost else { return false }
        owned.insert(outfit.id)
        wearing = outfit.id
        return true
    }

    public mutating func wear(_ outfit: Outfit) {
        if owned.contains(outfit.id) { wearing = outfit.id }
    }

    public static func load(from url: URL) -> PointsLog? {
        guard let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(PointsLog.self, from: data)
    }

    public func save(to url: URL) throws {
        try JSONEncoder().encode(self).write(to: url, options: .atomic)
    }
}
