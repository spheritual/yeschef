import Foundation
import XCTest
@testable import YesChefCore

final class PointsAndHealthTests: XCTestCase {
    let calendar = Calendar(identifier: .gregorian)

    func day(_ n: Int, hour: Int = 12) -> Date {
        calendar.date(from: DateComponents(year: 2026, month: 10, day: n, hour: hour))!
    }

    func testLeavesAddUpAndOutfitsSpendThem() {
        var log = PointsLog()
        XCTAssertEqual(log.balance, 0)
        log.record(.planned, on: day(29))
        log.record(.cooked, on: day(30))
        log.record(.rated, on: day(30))
        XCTAssertEqual(log.earned, 45)
        let baker = PointsLog.outfits[1]
        XCTAssertTrue(log.buy(baker) == false, "bought a 60-leaf outfit with 45 leaves")
        log.record(.imported, on: day(31))
        XCTAssertTrue(log.buy(baker))
        XCTAssertEqual(log.balance, 0)
        XCTAssertEqual(log.wearing, baker.id)
        XCTAssertFalse(log.buy(baker), "bought the same outfit twice")
        log.wear(PointsLog.outfits[3])
        XCTAssertEqual(log.wearing, baker.id, "wore an outfit that isn't owned")
        log.wear(PointsLog.outfits[0])
        XCTAssertEqual(log.wearing, "Basil")
    }

    func testStreakCountsDaysInARow() {
        var log = PointsLog()
        XCTAssertEqual(log.streak(asOf: day(31), calendar: calendar), 0)
        for d in [27, 29, 30] { log.record(.asked, on: day(d)) }
        XCTAssertEqual(log.streak(asOf: day(30, hour: 20), calendar: calendar), 2)
        XCTAssertEqual(log.streak(asOf: day(31, hour: 9), calendar: calendar), 2, "the streak ended before today was over")
        XCTAssertEqual(log.streak(asOf: day(32), calendar: calendar), 0)
        log.record(.asked, on: day(28))
        XCTAssertEqual(log.streak(asOf: day(30), calendar: calendar), 4)
    }

    func testPointsSurviveSavingAndLoading() throws {
        var log = PointsLog()
        for action in PointsLog.Action.allCases { log.record(action, on: day(30)) }
        log.buy(PointsLog.outfits[1])
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("points-\(UUID()).json")
        defer { try? FileManager.default.removeItem(at: url) }
        try log.save(to: url)
        XCTAssertEqual(PointsLog.load(from: url), log)
    }

    func testNutritionDecodesLenientlyAndSummarizes() async throws {
        let json = #"{"title":"Tacos","servings":4,"minutes":25,"ingredients":[{"name":"beef","amount":"1","unit":"lb"}],"steps":[{"instruction":"Cook"}],"nutrition":{"calories":"520 kcal","protein":35.4,"fiber":8,"sugar":"6g"}}"#
        let recipe = try await MealPlanner(model: ScriptedModel([json]), cookbook: nil).recipe(for: SampleData.fajitas, household: SampleData.household)
        XCTAssertEqual(recipe.nutrition?.calories, 520)
        XCTAssertEqual(recipe.nutrition?.summary, "About 520 kcal, 35 g protein, 8 g fiber, 6 g sugar")
        let none = #"{"title":"Tacos","servings":4,"minutes":25,"ingredients":[],"steps":[{"instruction":"Cook"}]}"#
        let plain = try await MealPlanner(model: ScriptedModel([none]), cookbook: nil).recipe(for: SampleData.fajitas, household: SampleData.household)
        XCTAssertNil(plain.nutrition)
    }

    func testHealthGoalsReachThePrompts() async throws {
        let model = ScriptedModel([#"{"days":[{"day":"Monday","ideas":[{"title":"Tacos","ingredients":["beef"]}]}]}"#])
        _ = try await MealPlanner(model: model, cookbook: nil).planWeek(for: SampleData.household, days: ["Monday"])
        let prompts = await model.prompts
        let prompt = try XCTUnwrap(prompts.first)
        XCTAssertTrue(prompt.contains("health goals: under 650 calories a dinner, less sugar"))
        XCTAssertTrue(prompt.contains("health goals: high protein"))
        XCTAssertTrue(Prompts.recipe(SampleData.fajitas, household: SampleData.household, servings: 4).contains("\"nutrition\""))
    }
}
