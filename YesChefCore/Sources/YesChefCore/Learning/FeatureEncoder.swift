// The layout is fixed by .plans/feedback-learning-spec.md; a stored PreferenceModel is only
// valid for the layout it was trained on, which is why changing it means a spec change first.
public enum FeatureEncoder {
    public static let labels = [
        "Bias",
        "Chicken", "Beef", "Pork", "Fish", "Vegetarian",
        "Spicy", "Sweet", "Savory", "Fresh",
        "Longer cook time", "Harder recipes", "Pricier meals",
        "Long cooks on busy days", "Hard recipes on busy days",
    ]

    public static var dimension: Int { labels.count }

    public static func encode(_ recipe: RecipeFeatures, on day: DayContext) -> [Double] {
        let cookTime = min(Double(max(recipe.minutes, 0)) / 60, 1.5)
        let difficulty = recipe.difficulty.level
        let cost = min(max(recipe.costPerServing, 0) / 10, 1.5)
        let busy: Double = day.isBusy ? 1 : 0

        var vector = [1.0]
        vector += Protein.allCases.map { $0 == recipe.protein ? 1 : 0 }
        vector += Flavour.allCases.map { recipe.flavours.contains($0) ? 1 : 0 }
        vector += [cookTime, difficulty, cost, busy * cookTime, busy * difficulty]
        return vector
    }
}
