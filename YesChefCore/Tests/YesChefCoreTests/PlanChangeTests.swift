import Foundation
import XCTest
@testable import YesChefCore

final class PlanChangeTests: XCTestCase {
    func testReplacingMovesTheOldPickToTheFirstSwap() {
        let plan = SampleData.weekPlan
        let changed = plan.replacing(day: "tuesday", with: SampleData.pasta)
        let tuesday = changed.days[1]
        XCTAssertEqual(tuesday.pick, SampleData.pasta)
        XCTAssertEqual(tuesday.alternatives.first, SampleData.salmon)
        XCTAssertFalse(tuesday.alternatives.contains(SampleData.pasta))
        XCTAssertEqual(changed.days[0], plan.days[0])
        XCTAssertEqual(plan.replacing(day: "Sunday", with: SampleData.pasta), plan)
        XCTAssertEqual(plan.replacing(day: "Monday", with: SampleData.pasta), plan)
    }

    func testReplyCarriesASafeChange() async throws {
        let json = #"{"answer":"Tacos it is!","change":{"day":"Tuesday","title":"Beef tacos","protein":"beef","minutes":"25","ingredients":["ground beef","tortillas"]}}"#
        let reply = try await MealPlanner(model: ScriptedModel([json]), cookbook: nil)
            .reply(to: "Can we have tacos on Tuesday?", plan: SampleData.weekPlan, household: SampleData.household)
        XCTAssertEqual(reply.answer, "Tacos it is!")
        XCTAssertEqual(reply.change?.day, "Tuesday")
        XCTAssertEqual(reply.change?.idea.title, "Beef tacos")
        XCTAssertEqual(reply.change?.idea.features.minutes, 25)
    }

    func testReplyDropsUnsafeOrUnknownChanges() async throws {
        let peanuts = #"{"answer":"Satay!","change":{"day":"Tuesday","title":"Satay","ingredients":["peanut sauce"]}}"#
        let unsafe = try await MealPlanner(model: ScriptedModel([peanuts]), cookbook: nil)
            .reply(to: "Satay on Tuesday", plan: SampleData.weekPlan, household: SampleData.household)
        XCTAssertNil(unsafe.change)
        let sunday = #"{"answer":"Sure","change":{"day":"Sunday","title":"Roast","ingredients":["chicken"]}}"#
        let unknown = try await MealPlanner(model: ScriptedModel([sunday]), cookbook: nil)
            .reply(to: "Roast on Sunday", plan: SampleData.weekPlan, household: SampleData.household)
        XCTAssertNil(unknown.change)
        let none = #"{"answer":"Simmer means gentle bubbles.","change":null}"#
        let plain = try await MealPlanner(model: ScriptedModel([none]), cookbook: nil)
            .reply(to: "What's simmering?", plan: SampleData.weekPlan, household: SampleData.household)
        XCTAssertNil(plain.change)
        XCTAssertEqual(plain.answer, "Simmer means gentle bubbles.")
    }

    func testReplyFallsBackToAPlainAnswerWhenJSONFails() async throws {
        let model = ScriptedModel(["Just talking", "Still just talking", "Simmer means gentle bubbles."])
        let reply = try await MealPlanner(model: model, cookbook: nil)
            .reply(to: "What's simmering?", plan: SampleData.weekPlan, household: SampleData.household)
        XCTAssertEqual(reply.answer, "Simmer means gentle bubbles.")
        XCTAssertNil(reply.change)
    }
}

final class PlanChangeLiveTests: XCTestCase {
    func testLiveTacosOnTuesday() async throws {
        guard let key = ProcessInfo.processInfo.environment["GEMINI_API_KEY"], !key.isEmpty else { throw XCTSkip("GEMINI_API_KEY isn't set") }
        let reply = try await MealPlanner(model: GemmaClient(apiKey: key))
            .reply(to: "Actually, let's have chicken tacos on Tuesday instead.", plan: SampleData.weekPlan, household: SampleData.household)
        print("LIVE reply:", reply.answer, "| change:", reply.change.map { "\($0.day): \($0.idea.title)" } ?? "none")
        XCTAssertEqual(reply.change?.day.lowercased(), "tuesday")
    }
}
