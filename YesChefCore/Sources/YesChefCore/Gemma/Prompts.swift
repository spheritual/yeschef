enum Prompts {
    static let chef = """
        You are Basil, the friendly chef in the yeschef! app. You teach beginner home cooks, so you \
        use plain everyday words, explain why each technique matters, and keep people encouraged. \
        When asked for JSON, reply with only the JSON object and nothing else.
        """

    static func household(_ household: Household) -> String {
        var lines = household.members.map { member in
            var line = "- \(member.name): \(member.cookingSkill) cook"
            if !member.likes.isEmpty { line += "; likes \(member.likes.joined(separator: ", "))" }
            if !member.avoid.isEmpty { line += "; must never eat \(member.avoid.joined(separator: ", "))" }
            if let diet = member.diet, !diet.isEmpty { line += "; diet: \(diet)" }
            return line
        }
        if let budget = household.weeklyBudget {
            lines.append("Weekly grocery budget for the whole household: $\(Int(budget)).")
        }
        return lines.joined(separator: "\n")
    }

    static func week(_ household: Household, days: [String], busyDays: Set<String>, ideasPerDay: Int) -> String {
        let busy = days.filter(busyDays.contains)
        return """
            Plan dinners for these days: \(days.joined(separator: ", ")).
            Household:
            \(Self.household(household))
            Busy days, which need dinners under 30 minutes that are easy: \(busy.isEmpty ? "none" : busy.joined(separator: ", ")).
            Give \(ideasPerDay) different dinner ideas for each day. Vary proteins and cuisines across the week.
            Never include anything a household member must never eat.
            Reply with JSON in exactly this shape:
            {"days":[{"day":"Monday","ideas":[{"title":"Sheet-pan chicken fajitas","summary":"One sentence on why it fits.","protein":"chicken","flavours":["spicy","savory"],"minutes":25,"difficulty":"easy","costPerServing":3.5,"ingredients":["chicken thighs","bell peppers","tortillas"]}]}]}
            protein is one of chicken, beef, pork, fish, vegetarian. flavours uses only spicy, sweet, savory, fresh. difficulty is easy, medium or hard. costPerServing is in US dollars.
            """
    }

    static func recipe(_ idea: DinnerIdea, household: Household, servings: Int) -> String {
        """
        Write the recipe for "\(idea.title)" for \(servings) people, for a beginner cook.
        Household:
        \(Self.household(household))
        Never use anything a household member must never eat.
        Every step gets a technique note: one or two plain sentences on how to do it well or why it matters.
        Reply with JSON in exactly this shape:
        {"title":"\(idea.title)","servings":\(servings),"minutes":30,"ingredients":[{"name":"chicken thighs","amount":"1","unit":"lb"}],"steps":[{"instruction":"Slice the peppers into thin strips.","technique":"Thin, even strips cook at the same speed, so nothing burns while the rest softens.","timerSeconds":null}]}
        timerSeconds is a whole number of seconds for steps that need waiting, otherwise null.
        """
    }

    static let fromImage = """
        This image shows a recipe. Read it and rewrite it for a beginner cook.
        Every step gets a technique note: one or two plain sentences on how to do it well or why it matters.
        Reply with JSON in exactly this shape:
        {"title":"Recipe name","servings":4,"minutes":30,"ingredients":[{"name":"flour","amount":"2","unit":"cups"}],"steps":[{"instruction":"Whisk the dry ingredients.","technique":"Whisking first spreads the baking powder evenly.","timerSeconds":null}]}
        """

    static func question(_ question: String, step: RecipeDetail.Step?, recipe: RecipeDetail?) -> String {
        var context = ""
        if let recipe { context += "We're cooking \(recipe.title).\n" }
        if let step { context += "The current step is: \(step.instruction)\n" }
        return context + "The cook asks: \(question)\nAnswer in at most three short sentences, in plain words, as Basil."
    }

    static let retry = "Your last reply wasn't valid JSON in the requested shape. Reply again with only the JSON object."
}
