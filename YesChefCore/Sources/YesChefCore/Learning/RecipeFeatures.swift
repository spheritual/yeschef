public struct RecipeFeatures: Codable, Sendable, Hashable {
    public var protein: Protein
    public var flavours: Set<Flavour>
    public var minutes: Int
    public var difficulty: Difficulty
    public var costPerServing: Double

    public init(protein: Protein, flavours: Set<Flavour>, minutes: Int, difficulty: Difficulty, costPerServing: Double) {
        self.protein = protein
        self.flavours = flavours
        self.minutes = minutes
        self.difficulty = difficulty
        self.costPerServing = costPerServing
    }
}
