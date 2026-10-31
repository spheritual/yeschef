import Foundation
import XCTest
@testable import YesChefCore

final class ShoppingListTests: XCTestCase {
    func testStartsFromThePlan() {
        let list = ShoppingList(plan: SampleData.weekPlan)
        XCTAssertEqual(list.items.map(\.text), SampleData.weekPlan.shoppingList)
        XCTAssertTrue(list.items.allSatisfy { $0.fromPlan && !$0.done })
        XCTAssertEqual(list.remaining, list.items.count)
    }

    func testCheckedItemsSurviveSavingAndLoading() throws {
        var list = ShoppingList(plan: SampleData.weekPlan)
        list.items[0].done = true
        list.add("  paper towels ")
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("shopping-\(UUID()).json")
        defer { try? FileManager.default.removeItem(at: url) }
        try list.save(to: url)
        let loaded = try XCTUnwrap(ShoppingList.load(from: url))
        XCTAssertEqual(loaded, list)
        XCTAssertTrue(loaded.items[0].done)
        XCTAssertEqual(loaded.items.last?.text, "paper towels")
        XCTAssertEqual(loaded.remaining, list.items.count - 1)
    }

    func testMissingOrBrokenFileLoadsNothing() throws {
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("shopping-\(UUID()).json")
        XCTAssertNil(ShoppingList.load(from: url))
        try Data("not json".utf8).write(to: url)
        defer { try? FileManager.default.removeItem(at: url) }
        XCTAssertNil(ShoppingList.load(from: url))
    }

    func testNewPlanKeepsOwnItemsAndChecksStillNeeded() {
        var list = ShoppingList(plan: SampleData.weekPlan)
        let tortillas = list.items.firstIndex { $0.text == "tortillas" }!
        let penne = list.items.firstIndex { $0.text == "penne" }!
        list.items[tortillas].done = true
        list.items[penne].done = true
        list.add("coffee")
        list.add("Lime")

        let next = WeekPlan(days: [.init(day: "Monday", isBusy: false, pick: SampleData.fajitas, alternatives: [])])
        list.sync(with: next)

        let texts = list.items.map(\.text)
        XCTAssertTrue(texts.contains("coffee"), "the cook's own item was dropped")
        XCTAssertFalse(texts.contains("penne"), "an item the new plan doesn't need stayed")
        XCTAssertEqual(list.items.first { $0.text == "tortillas" }?.done, true, "a bought item lost its check")
        XCTAssertEqual(list.items.filter { $0.text.lowercased() == "lime" }.count, 1, "an own item was doubled by the plan")
        XCTAssertFalse(list.items.first { $0.text == "chicken thighs" }?.done ?? true)
    }

    func testAddIgnoresBlankLinesAndClearDoneRemovesChecked() {
        var list = ShoppingList()
        list.add("   ")
        list.add("")
        XCTAssertTrue(list.items.isEmpty)
        list.add("eggs")
        list.add("milk")
        list.items[0].done = true
        list.clearDone()
        XCTAssertEqual(list.items.map(\.text), ["milk"])
    }
}
