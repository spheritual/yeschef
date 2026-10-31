import Foundation
import XCTest
@testable import YesChefCore

final class CookbookTests: XCTestCase {
    func testBundledCookbooksLoadFromAllSixBooks() throws {
        let cookbook = try XCTUnwrap(Cookbook.bundled, "cookbooks.json didn't load from the package")
        XCTAssertGreaterThan(cookbook.passages.count, 1000)
        XCTAssertEqual(Set(cookbook.passages.map(\.source.id)), [6912, 34822, 6745, 24407, 13887, 12350])
    }

    func testSearchFindsTheDishAndRanksHeadingsFirst() throws {
        let cookbook = try XCTUnwrap(Cookbook.bundled)
        let hits = cookbook.search("tomato soup", limit: 3)
        XCTAssertEqual(hits.count, 3)
        XCTAssertTrue(hits[0].heading.lowercased().contains("tomato"), hits[0].heading)
        XCTAssertTrue(cookbook.search("risotto", limit: 2).allSatisfy { ($0.heading + $0.text).lowercased().contains("risotto") })
        XCTAssertTrue(cookbook.search("the and of", limit: 3).isEmpty)
    }

    func testSearchOnASmallCorpus() {
        let source = Cookbook.Source(id: 1, title: "Test Book", author: "A. Cook", url: "")
        let cookbook = Cookbook(passages: [
            .init(source: source, heading: "Bread", text: "Flour, water and salt, baked in a hot oven."),
            .init(source: source, heading: "Tomato Sauce", text: "Tomatoes stewed slowly with onion and butter."),
        ])
        XCTAssertEqual(cookbook.search("tomatoes").map(\.heading), ["Tomato Sauce"])
        XCTAssertEqual(cookbook.search("oven bread").first?.heading, "Bread")
        XCTAssertTrue(cookbook.search("chocolate").isEmpty)
    }

    func testWeekPromptCarriesCitedPassagesWithoutAllergens() async throws {
        let source = Cookbook.Source(id: 1, title: "Test Book", author: "A. Cook", url: "")
        let cookbook = Cookbook(passages: [
            .init(source: source, heading: "Peanut Soup", text: "Peanuts ground fine and simmered with stock."),
            .init(source: source, heading: "Taco Filling", text: "Beef browned with onion, simmered with tomatoes."),
        ])
        let reply = #"{"days":[{"day":"Monday","ideas":[{"title":"Beef tacos","ingredients":["beef"],"source":"Test Book"}]}]}"#
        let model = ScriptedModel([reply])
        let plan = try await MealPlanner(model: model, cookbook: cookbook).planWeek(for: SampleData.household, days: ["Monday"])
        let prompts = await model.prompts
        let prompt = try XCTUnwrap(prompts.first)
        XCTAssertTrue(prompt.contains("Project Gutenberg"))
        XCTAssertTrue(prompt.contains("Taco Filling"))
        XCTAssertFalse(prompt.contains("Peanut Soup"), "a passage naming a banned ingredient reached the prompt")
        XCTAssertEqual(plan.days[0].pick.source, "Test Book")
    }

    func testPlannerWithoutCookbookLeavesThePromptAlone() async throws {
        let reply = #"{"days":[{"day":"Monday","ideas":[{"title":"Beef tacos","ingredients":["beef"]}]}]}"#
        let model = ScriptedModel([reply])
        _ = try await MealPlanner(model: model, cookbook: nil).planWeek(for: SampleData.household, days: ["Monday"])
        let prompts = await model.prompts
        let prompt = try XCTUnwrap(prompts.first)
        XCTAssertFalse(prompt.contains("Project Gutenberg"))
    }
}
