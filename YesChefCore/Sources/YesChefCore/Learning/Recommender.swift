public enum Recommender {
    // Each model draws one set of weights per call, and an item's score is the average over the
    // household's models. With no models yet, everyone starts from a fresh prior.
    public static func rank<Item>(
        _ items: [Item],
        features: (Item) -> [Double],
        models: [PreferenceModel],
        using rng: inout some RandomNumberGenerator
    ) -> [Ranked<Item>] {
        let household = models.isEmpty ? [PreferenceModel()] : models
        let draws = household.map { $0.sampleWeights(using: &rng) }
        let count = Double(household.count)

        let ranked = items.enumerated().map { index, item in
            let x = features(item)
            let score = draws.reduce(0) { $0 + dot(x, $1) } / count
            let expected = household.reduce(0) { $0 + $1.expectedScore(x) } / count
            let uncertainty = household.reduce(0) { $0 + $1.uncertainty(x) } / count
            return (index, Ranked(item: item, score: score, expected: expected, uncertainty: uncertainty))
        }
        // Ties keep input order, which keeps a seeded ranking repeatable.
        return ranked
            .sorted { $0.1.score != $1.1.score ? $0.1.score > $1.1.score : $0.0 < $1.0 }
            .map(\.1)
    }
}
