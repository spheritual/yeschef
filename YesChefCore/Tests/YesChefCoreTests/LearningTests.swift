import Foundation
import XCTest
@testable import YesChefCore

final class LearningTests: XCTestCase {
    let quickSpicyChicken = FeatureEncoder.encode(
        RecipeFeatures(protein: .chicken, flavours: [.spicy, .savory], minutes: 20, difficulty: .easy, costPerServing: 3),
        on: DayContext(isBusy: true))
    let slowSweetFish = FeatureEncoder.encode(
        RecipeFeatures(protein: .fish, flavours: [.sweet], minutes: 75, difficulty: .hard, costPerServing: 9),
        on: DayContext(isBusy: true))
    let freshPork = FeatureEncoder.encode(
        RecipeFeatures(protein: .pork, flavours: [.fresh], minutes: 40, difficulty: .medium, costPerServing: 5),
        on: DayContext(isBusy: false))

    func trained(decay: Double = 0.97) -> PreferenceModel {
        var model = PreferenceModel(decay: decay)
        for _ in 0..<20 {
            model.record(.rated(stars: 5), for: quickSpicyChicken)
            model.record(.rated(stars: 1), for: slowSweetFish)
        }
        return model
    }

    func randomSymmetricPositiveDefinite(size: Int, rng: inout SeededGenerator) -> [Double] {
        let m = (0..<(size * size)).map { _ in Double.random(in: -1...1, using: &rng) }
        return (0..<(size * size)).map { index in
            let i = index / size, j = index % size
            let product = (0..<size).reduce(0.0) { $0 + m[i * size + $1] * m[j * size + $1] }
            return product + (i == j ? 1 : 0)
        }
    }

    func testCholeskyFactorRebuildsTheMatrix() {
        var rng = SeededGenerator(seed: 7)
        for size in [1, 3, 6, 15] {
            let a = randomSymmetricPositiveDefinite(size: size, rng: &rng)
            let l = Cholesky(a, size: size).lower
            for i in 0..<size {
                for j in 0..<size {
                    let rebuilt = (0..<size).reduce(0.0) { $0 + l[i * size + $1] * l[j * size + $1] }
                    XCTAssertEqual(rebuilt, a[i * size + j], accuracy: 1e-9)
                }
            }
        }
    }

    func testSolveInvertsTheMatrix() {
        var rng = SeededGenerator(seed: 11)
        let size = 15
        let a = randomSymmetricPositiveDefinite(size: size, rng: &rng)
        let x = (0..<size).map { _ in Double.random(in: -2...2, using: &rng) }
        let b = (0..<size).map { i in (0..<size).reduce(0.0) { $0 + a[i * size + $1] * x[$1] } }
        let solved = Cholesky(a, size: size).solve(b)
        for (got, want) in zip(solved, x) { XCTAssertEqual(got, want, accuracy: 1e-8) }
    }

    func testLikedFeaturesScoreAboveDislikedOnes() {
        let model = trained()
        XCTAssertGreaterThan(model.expectedScore(quickSpicyChicken), 0.7)
        XCTAssertLessThan(model.expectedScore(slowSweetFish), 0.2)
    }

    func testRankingMostlyPicksTheLikedRecipe() {
        let model = trained()
        let wins = (0..<200).count { seed in
            var rng = SeededGenerator(seed: UInt64(seed))
            let ranked = Recommender.rank(["fish", "chicken"], features: { $0 == "chicken" ? quickSpicyChicken : slowSweetFish }, models: [model], using: &rng)
            return ranked.first?.item == "chicken"
        }
        XCTAssertGreaterThan(wins, 190)
    }

    func testFeedbackShrinksUncertainty() {
        var model = PreferenceModel()
        let before = model.uncertainty(quickSpicyChicken)
        model.record(.cooked, for: quickSpicyChicken)
        XCTAssertLessThan(model.uncertainty(quickSpicyChicken), before)
    }

    func testUnseenFeaturesAreMoreUncertain() {
        let model = trained()
        XCTAssertGreaterThan(model.uncertainty(freshPork), model.uncertainty(quickSpicyChicken) * 2)
    }

    func testPriorHoldsForNeverSeenFeatures() {
        // Pork alone shares no feature with the trained vectors, which leaves its variance at
        // exactly 1 / prior however much feedback came in elsewhere.
        var porkOnly = [Double](repeating: 0, count: FeatureEncoder.dimension)
        porkOnly[3] = 1
        XCTAssertEqual(trained().uncertainty(porkOnly), 1, accuracy: 1e-9)
    }

    func testDecayLetsRecentFeedbackWin() {
        func run(decay: Double) -> Double {
            var model = PreferenceModel(decay: decay)
            for _ in 0..<15 { model.record(.rated(stars: 5), for: quickSpicyChicken) }
            for _ in 0..<15 { model.record(.rated(stars: 1), for: quickSpicyChicken) }
            return model.expectedScore(quickSpicyChicken)
        }
        let remembersEverything = run(decay: 1)
        let fades = run(decay: 0.9)
        XCTAssertEqual(remembersEverything, 0.5, accuracy: 0.05)
        XCTAssertLessThan(fades, 0.25)
    }

    func testSameSeedGivesSameRanking() {
        let model = trained()
        let items = Array(0..<6)
        let vectors = [quickSpicyChicken, slowSweetFish, freshPork, quickSpicyChicken, freshPork, slowSweetFish]
        func ranking(seed: UInt64) -> [Int] {
            var rng = SeededGenerator(seed: seed)
            return Recommender.rank(items, features: { vectors[$0] }, models: [model], using: &rng).map(\.item)
        }
        XCTAssertEqual(ranking(seed: 42), ranking(seed: 42))
    }

    func testSamplesCenterOnTheExpectedScore() {
        let model = trained()
        var rng = SeededGenerator(seed: 3)
        let draws = 4000
        let total = (0..<draws).reduce(0.0) { sum, _ in
            sum + dot(freshPork, model.sampleWeights(using: &rng))
        }
        XCTAssertEqual(total / Double(draws), model.expectedScore(freshPork), accuracy: 0.03)
    }

    func testModelSurvivesJSONRoundTrip() throws {
        let model = trained()
        let copy = try JSONDecoder().decode(PreferenceModel.self, from: JSONEncoder().encode(model))
        XCTAssertEqual(copy.expectedScore(freshPork), model.expectedScore(freshPork), accuracy: 1e-12)
        XCTAssertEqual(copy.uncertainty(freshPork), model.uncertainty(freshPork), accuracy: 1e-12)
    }

    func testCorruptStoredModelIsRejected() throws {
        var json = try JSONSerialization.jsonObject(with: JSONEncoder().encode(PreferenceModel())) as! [String: Any]
        json["target"] = [0.0, 1.0]
        let data = try JSONSerialization.data(withJSONObject: json)
        XCTAssertThrowsError(try JSONDecoder().decode(PreferenceModel.self, from: data))
    }

    func testStarRewardsMapAndClamp() {
        XCTAssertEqual(FeedbackSignal.rated(stars: 1).reward, 0)
        XCTAssertEqual(FeedbackSignal.rated(stars: 3).reward, 0.5)
        XCTAssertEqual(FeedbackSignal.rated(stars: 5).reward, 1)
        XCTAssertEqual(FeedbackSignal.rated(stars: 0).reward, 0)
        XCTAssertEqual(FeedbackSignal.rated(stars: 9).reward, 1)
    }

    func testEncoderLayout() {
        XCTAssertEqual(FeatureEncoder.dimension, 15)
        XCTAssertEqual(quickSpicyChicken.count, 15)
        let slow = RecipeFeatures(protein: .beef, flavours: [], minutes: 600, difficulty: .hard, costPerServing: 100)
        let calm = FeatureEncoder.encode(slow, on: DayContext(isBusy: false))
        let busy = FeatureEncoder.encode(slow, on: DayContext(isBusy: true))
        XCTAssertEqual(calm[10], 1.5)
        XCTAssertEqual(calm[12], 1.5)
        XCTAssertEqual(Array(calm[13...14]), [0, 0])
        XCTAssertEqual(Array(busy[13...14]), [1.5, 1])
        XCTAssertEqual(Array(calm[1...5]), [0, 1, 0, 0, 0])
    }

    func testHardRulesRemoveAllergensTheModelLoves() {
        let model = trained()
        let menu = ["Peanut butter noodles", "Lemon chicken"]
        let ingredients = ["Peanut butter noodles": ["Peanut Butter", "noodles"], "Lemon chicken": ["chicken", "lemon"]]
        let allowed = HardRules.excluding(menu, ingredients: { ingredients[$0] ?? [] }, banned: [" peanut ", ""])
        XCTAssertEqual(allowed, ["Lemon chicken"])
        var rng = SeededGenerator(seed: 1)
        let ranked = Recommender.rank(allowed, features: { _ in quickSpicyChicken }, models: [model], using: &rng)
        XCTAssertEqual(ranked.map(\.item), ["Lemon chicken"])
        XCTAssertEqual(HardRules.excluding(menu, ingredients: { ingredients[$0] ?? [] }, banned: ["", "  "]), menu)
    }
}
