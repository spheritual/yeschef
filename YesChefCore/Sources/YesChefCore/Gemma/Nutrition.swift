// Gemma's estimate of one serving's nutrition, shown as an estimate (TR-22).
public struct Nutrition: Codable, Sendable, Hashable {
    public var calories: Double?
    public var protein: Double?
    public var carbs: Double?
    public var fat: Double?
    public var fiber: Double?
    public var sugar: Double?

    public init(calories: Double? = nil, protein: Double? = nil, carbs: Double? = nil, fat: Double? = nil, fiber: Double? = nil, sugar: Double? = nil) {
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fat = fat
        self.fiber = fiber
        self.sugar = sugar
    }

    private enum Keys: String, CodingKey { case calories, protein, carbs, fat, fiber, sugar }

    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: Keys.self)
        calories = c.lenientNumber(forKey: .calories)
        protein = c.lenientNumber(forKey: .protein)
        carbs = c.lenientNumber(forKey: .carbs)
        fat = c.lenientNumber(forKey: .fat)
        fiber = c.lenientNumber(forKey: .fiber)
        sugar = c.lenientNumber(forKey: .sugar)
    }

    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: Keys.self)
        try c.encodeIfPresent(calories, forKey: .calories)
        try c.encodeIfPresent(protein, forKey: .protein)
        try c.encodeIfPresent(carbs, forKey: .carbs)
        try c.encodeIfPresent(fat, forKey: .fat)
        try c.encodeIfPresent(fiber, forKey: .fiber)
        try c.encodeIfPresent(sugar, forKey: .sugar)
    }

    // One line for the recipe card, such as "About 520 kcal, 35 g protein, 8 g fiber, 6 g sugar".
    public var summary: String? {
        var parts: [String] = []
        if let calories { parts.append("\(Int(calories.rounded())) kcal") }
        for (value, name) in [(protein, "protein"), (carbs, "carbs"), (fat, "fat"), (fiber, "fiber"), (sugar, "sugar")] {
            if let value { parts.append("\(Int(value.rounded())) g \(name)") }
        }
        return parts.isEmpty ? nil : "About " + parts.joined(separator: ", ")
    }
}
