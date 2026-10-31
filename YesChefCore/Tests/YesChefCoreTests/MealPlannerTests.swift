import Foundation
import XCTest
@testable import YesChefCore

actor ScriptedModel: LanguageModel {
    private var replies: [String]
    private(set) var prompts: [String] = []

    init(_ replies: [String]) {
        self.replies = replies
    }

    func generate(prompt: String, system: String?, image: Data?, imageMIMEType: String) async throws -> String {
        prompts.append(prompt)
        guard !replies.isEmpty else { throw GemmaError.emptyReply }
        return replies.removeFirst()
    }
}

final class MealPlannerTests: XCTestCase {
    let week = """
        Sure, here's the plan:
        ```json
        {"days":[
          {"day":"Monday","ideas":[
            {"title":"Peanut noodles","summary":"x","protein":"vegetarian","flavours":["savory"],"minutes":"20","difficulty":"easy","costPerServing":2,"ingredients":["noodles","Peanut butter"]},
            {"title":"Chicken tacos","summary":"x","protein":"Chicken","flavours":["spicy","umami"],"minutes":25,"difficulty":"easy","costPerServing":"3.50","ingredients":["chicken","tortillas"]}]},
          {"day":"Tuesday","ideas":[
            {"title":"Satay skewers","summary":"x","protein":"chicken","flavours":["savory"],"minutes":30,"difficulty":"medium","costPerServing":4,"ingredients":["chicken","peanut sauce"]}]}
        ]}
        ```
        """

    func testPlanDropsAllergensAndDaysWithNothingSafe() async throws {
        let planner = MealPlanner(model: ScriptedModel([week]))
        let plan = try await planner.planWeek(for: SampleData.household, days: ["Monday", "Tuesday"], busyDays: ["Monday"])
        XCTAssertEqual(plan.days.map(\.day), ["Monday"])
        XCTAssertEqual(plan.days[0].pick.title, "Chicken tacos")
        XCTAssertTrue(plan.days[0].alternatives.isEmpty)
        XCTAssertTrue(plan.days[0].isBusy)
    }

    func testLenientFieldsDecode() async throws {
        let planner = MealPlanner(model: ScriptedModel([week]))
        let plan = try await planner.planWeek(for: Household(members: [.init(name: "Kai")]), days: ["Monday"])
        let noodles = try XCTUnwrap(([plan.days[0].pick] + plan.days[0].alternatives).first { $0.title == "Peanut noodles" })
        XCTAssertEqual(noodles.features.minutes, 20)
        let tacos = try XCTUnwrap(([plan.days[0].pick] + plan.days[0].alternatives).first { $0.title == "Chicken tacos" })
        XCTAssertEqual(tacos.features.protein, .chicken)
        XCTAssertEqual(tacos.features.flavours, [.spicy])
        XCTAssertEqual(tacos.features.costPerServing, 3.5)
    }

    func testRetriesOnceAfterNonJSON() async throws {
        let model = ScriptedModel(["Here are some ideas for you!", week])
        let plan = try await MealPlanner(model: model).planWeek(for: SampleData.household, days: ["Monday"])
        XCTAssertEqual(plan.days.count, 1)
        let prompts = await model.prompts
        XCTAssertEqual(prompts.count, 2)
        XCTAssertTrue(prompts[1].hasSuffix(Prompts.retry))
    }

    func testGivesUpAfterTwoBadReplies() async {
        let planner = MealPlanner(model: ScriptedModel(["nope", "still nope"]))
        do {
            _ = try await planner.planWeek(for: SampleData.household)
            XCTFail("expected a failure")
        } catch GemmaError.notJSON {
        } catch {
            XCTFail("unexpected error \(error)")
        }
    }

    func testNoSafeIdeasIsAnError() async {
        let onlyPeanuts = #"{"days":[{"day":"Monday","ideas":[{"title":"Satay","ingredients":["peanut sauce"]}]}]}"#
        do {
            _ = try await MealPlanner(model: ScriptedModel([onlyPeanuts])).planWeek(for: SampleData.household, days: ["Monday"])
            XCTFail("expected a failure")
        } catch {
            XCTAssertEqual(error as? GemmaError, .noSafeIdeas)
        }
    }

    func testRecipeDecodesAndRefusesAllergens() async throws {
        let good = #"{"title":"Tacos","servings":"4","minutes":25,"ingredients":[{"name":"chicken","amount":1.5,"unit":"lb"},{"name":"lime","amount":"1/2","unit":""}],"steps":[{"instruction":"Roast","technique":"Space it out.","timerSeconds":"1200"},{"instruction":"Serve","technique":"","timerSeconds":null}]}"#
        let recipe = try await MealPlanner(model: ScriptedModel([good])).recipe(for: SampleData.fajitas, household: SampleData.household)
        XCTAssertEqual(recipe.servings, 4)
        XCTAssertEqual(recipe.ingredients.map(\.amount), ["1.5", "1/2"])
        XCTAssertEqual(recipe.steps.map(\.timerSeconds), [1200, nil])

        let bad = #"{"title":"Satay","servings":4,"minutes":25,"ingredients":[{"name":"Peanut butter","amount":"2","unit":"tbsp"}],"steps":[{"instruction":"Mix"}]}"#
        do {
            _ = try await MealPlanner(model: ScriptedModel([bad])).recipe(for: SampleData.fajitas, household: SampleData.household)
            XCTFail("expected a failure")
        } catch {
            XCTAssertEqual(error as? GemmaError, .unsafeRecipe(ingredient: "Peanut butter"))
        }
    }

    func testShoppingListDeduplicates() {
        XCTAssertEqual(SampleData.weekPlan.shoppingList.count, Set(SampleData.weekPlan.shoppingList.map { $0.lowercased() }).count)
        XCTAssertTrue(SampleData.weekPlan.shoppingList.contains("tortillas"))
    }

    func testWeekPlanRoundTripsThroughJSON() throws {
        let data = try JSONEncoder().encode(SampleData.weekPlan)
        XCTAssertEqual(try JSONDecoder().decode(WeekPlan.self, from: data), SampleData.weekPlan)
        let recipe = try JSONDecoder().decode(RecipeDetail.self, from: JSONEncoder().encode(SampleData.recipe))
        XCTAssertEqual(recipe, SampleData.recipe)
    }
}

// Runs against the real Gemini API only when GEMINI_API_KEY is set.
final class GemmaLiveTests: XCTestCase {
    func planner() throws -> MealPlanner {
        guard let key = ProcessInfo.processInfo.environment["GEMINI_API_KEY"], !key.isEmpty else {
            throw XCTSkip("GEMINI_API_KEY isn't set")
        }
        return MealPlanner(model: GemmaClient(apiKey: key))
    }

    func testLivePlanRecipeAndQuestion() async throws {
        let planner = try planner()
        let plan = try await planner.planWeek(for: SampleData.household, days: ["Monday", "Wednesday"], busyDays: ["Wednesday"])
        XCTAssertFalse(plan.days.isEmpty)
        for idea in plan.days.flatMap({ [$0.pick] + $0.alternatives }) {
            XCTAssertFalse(idea.ingredients.contains { $0.lowercased().contains("peanut") }, idea.title)
        }
        print("LIVE plan:", plan.days.map { "\($0.day): \($0.pick.title) (\($0.pick.features.minutes) min)" })

        let recipe = try await planner.recipe(for: plan.days[0].pick, household: SampleData.household)
        XCTAssertFalse(recipe.steps.isEmpty)
        print("LIVE recipe:", recipe.title, "steps:", recipe.steps.count, "first technique:", recipe.steps[0].technique)

        let answer = try await planner.askChef("What does it mean to let it simmer?", step: recipe.steps.first, recipe: recipe)
        XCTAssertFalse(answer.isEmpty)
        print("LIVE answer:", answer)
    }

    func testLiveRecipeFromScreenshot() async throws {
        let planner = try planner()
        // The team's salmon recipe screen from Figma doubles as a recipe screenshot.
        let image = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent().deletingLastPathComponent()
            .appendingPathComponent("design/screens/06-salmon-recipe.png")
        guard let data = try? Data(contentsOf: image) else { throw XCTSkip("no screenshot at \(image.path)") }
        let recipe = try await planner.recipeFromImage(data, mimeType: "image/png", household: SampleData.household)
        XCTAssertTrue(recipe.title.lowercased().contains("salmon"), recipe.title)
        XCTAssertFalse(recipe.steps.isEmpty)
        print("LIVE image recipe:", recipe.title, "ingredients:", recipe.ingredients.count, "steps:", recipe.steps.count)
    }
}
