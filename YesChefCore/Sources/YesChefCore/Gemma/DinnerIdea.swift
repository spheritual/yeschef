public struct DinnerIdea: Codable, Sendable, Hashable, Identifiable {
    public var title: String
    public var summary: String
    public var features: RecipeFeatures
    public var ingredients: [String]
    // The public-domain cookbook an idea was based on, when Gemma used one of the passages.
    public var source: String?

    public var id: String { title }

    public init(title: String, summary: String, features: RecipeFeatures, ingredients: [String], source: String? = nil) {
        self.title = title
        self.summary = summary
        self.features = features
        self.ingredients = ingredients
        self.source = source
    }
}

// The shape Gemma is asked for. Unknown labels fall back to neutral values, which only affects
// ranking; allergy filtering reads the ingredient names.
struct DinnerIdeaReply: Decodable {
    let idea: DinnerIdea

    private enum Keys: String, CodingKey {
        case title, summary, protein, flavours, minutes, difficulty, costPerServing, ingredients, source
    }

    init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: Keys.self)
        let protein = (try? c.decode(String.self, forKey: .protein))?.lowercased() ?? ""
        let flavours = (try? c.decode([String].self, forKey: .flavours)) ?? []
        let difficulty = (try? c.decode(String.self, forKey: .difficulty))?.lowercased() ?? ""
        idea = DinnerIdea(
            title: try c.decode(String.self, forKey: .title),
            summary: (try? c.decode(String.self, forKey: .summary)) ?? "",
            features: RecipeFeatures(
                protein: Protein(rawValue: protein) ?? .vegetarian,
                flavours: Set(flavours.compactMap { Flavour(rawValue: $0.lowercased()) }),
                minutes: Int(c.lenientNumber(forKey: .minutes) ?? 30),
                difficulty: Difficulty(rawValue: difficulty) ?? .medium,
                costPerServing: c.lenientNumber(forKey: .costPerServing) ?? 4),
            ingredients: (try? c.decode([String].self, forKey: .ingredients)) ?? [],
            source: (try? c.decode(String.self, forKey: .source)).flatMap { $0.isEmpty ? nil : $0 })
    }
}
