public struct RecipeDetail: Codable, Sendable, Hashable {
    public var title: String
    public var servings: Int
    public var minutes: Int
    public var ingredients: [Ingredient]
    public var steps: [Step]

    public struct Ingredient: Codable, Sendable, Hashable {
        public var name: String
        public var amount: String
        public var unit: String

        public init(name: String, amount: String, unit: String) {
            self.name = name
            self.amount = amount
            self.unit = unit
        }
    }

    public struct Step: Codable, Sendable, Hashable {
        public var instruction: String
        // A plain-words explanation of the technique, which is the teaching part.
        public var technique: String
        public var timerSeconds: Int?

        public init(instruction: String, technique: String, timerSeconds: Int?) {
            self.instruction = instruction
            self.technique = technique
            self.timerSeconds = timerSeconds
        }

        private enum Keys: String, CodingKey { case instruction, technique, timerSeconds }

        public init(from decoder: any Decoder) throws {
            let c = try decoder.container(keyedBy: Keys.self)
            instruction = try c.decode(String.self, forKey: .instruction)
            technique = (try? c.decode(String.self, forKey: .technique)) ?? ""
            timerSeconds = c.lenientNumber(forKey: .timerSeconds).map { Int($0) }.flatMap { $0 > 0 ? $0 : nil }
        }

        public func encode(to encoder: any Encoder) throws {
            var c = encoder.container(keyedBy: Keys.self)
            try c.encode(instruction, forKey: .instruction)
            try c.encode(technique, forKey: .technique)
            try c.encodeIfPresent(timerSeconds, forKey: .timerSeconds)
        }
    }

    public init(title: String, servings: Int, minutes: Int, ingredients: [Ingredient], steps: [Step]) {
        self.title = title
        self.servings = servings
        self.minutes = minutes
        self.ingredients = ingredients
        self.steps = steps
    }

    private enum Keys: String, CodingKey { case title, servings, minutes, ingredients, steps }

    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: Keys.self)
        title = try c.decode(String.self, forKey: .title)
        servings = Int(c.lenientNumber(forKey: .servings) ?? 4)
        minutes = Int(c.lenientNumber(forKey: .minutes) ?? 30)
        ingredients = try c.decode([IngredientReply].self, forKey: .ingredients).map(\.ingredient)
        steps = try c.decode([Step].self, forKey: .steps)
    }

    public func encode(to encoder: any Encoder) throws {
        var c = encoder.container(keyedBy: Keys.self)
        try c.encode(title, forKey: .title)
        try c.encode(servings, forKey: .servings)
        try c.encode(minutes, forKey: .minutes)
        try c.encode(ingredients, forKey: .ingredients)
        try c.encode(steps, forKey: .steps)
    }
}

// Amounts arrive as numbers or strings like "1/2", which is why they're kept as text.
private struct IngredientReply: Decodable {
    let ingredient: RecipeDetail.Ingredient

    private enum Keys: String, CodingKey { case name, amount, unit }

    init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: Keys.self)
        var amount = ""
        if let text = try? c.decode(String.self, forKey: .amount) {
            amount = text
        } else if let number = try? c.decode(Double.self, forKey: .amount) {
            amount = number.rounded() == number ? String(Int(number)) : String(number)
        }
        ingredient = .init(
            name: try c.decode(String.self, forKey: .name),
            amount: amount,
            unit: (try? c.decode(String.self, forKey: .unit)) ?? "")
    }
}
