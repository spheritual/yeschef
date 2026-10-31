# yeschef! and the MLH challenges

We're entering two challenges, Best Use of Gemma 4 and Best Open-Source AI Project. This page
gives the case for each one with the file that proves it, then the rubric, then what doesn't work
yet.

## Best Use of Gemma 4: yes

Gemma 4 runs every part of Basil that thinks. The app calls `gemma-4-26b-a4b-it` through the Gemini
API's `generateContent` endpoint over plain REST
([GemmaClient.swift](../YesChefCore/Sources/YesChefCore/Gemma/GemmaClient.swift)). It uses five
calls, and each one is a feature you can see in the demo
([MealPlanner.swift](../YesChefCore/Sources/YesChefCore/Gemma/MealPlanner.swift)):

- `planWeek` plans the dinners, with three ideas per day.
- `recipe(for:)` writes the steps, a plain-words tip for each technique and a nutrition estimate.
- `recipeFromImage` reads a recipe from a photo or screenshot, using Gemma 4's image input.
- `askChef` answers a question about the step you're on.
- `reply` is the chat, and it can change a meal in the plan when you ask for something else.

We used the model's own features where they helped. Each call has a system instruction that makes
Gemma Basil. We turned thinking down to minimal (d721e35), which took a short reply from about 3
seconds to about half a second.

It isn't a wrapper around a chat box, because Gemma proposes and the phone decides. Every idea goes
through the allergy rules in code first
([HardRules.swift](../YesChefCore/Sources/YesChefCore/Learning/HardRules.swift)), and then a
learning model ranks what's left for each person in the household. That model is Thompson
sampling, a small Bayesian method that learns from each star rating and runs on the phone
([PreferenceModel.swift](../YesChefCore/Sources/YesChefCore/Learning/PreferenceModel.swift),
[Recommender.swift](../YesChefCore/Sources/YesChefCore/Learning/Recommender.swift)). Gemma's prompts
are also grounded in 3,268 recipe passages from six public-domain cookbooks on Project Gutenberg.
The phone searches them with BM25 keyword ranking
([Cookbook.swift](../YesChefCore/Sources/YesChefCore/Cookbooks/Cookbook.swift)), and each dinner
names the book it came from. Gemma's replies come back as JSON that the code checks, and a reply
that doesn't parse gets one retry.

## Best Open-Source AI Project: yes

The repo is public at <https://github.com/spheritual/yeschef> under the Apache 2.0
[LICENSE](../LICENSE), and GitHub reports both. Gemma 4 is open-weight and released under Apache
2.0. The [README](../README.md) names the model in "The model" and links its license and the Gemma
terms of use. It lists the key dependencies in "Key dependencies" and the AI tools we used in "AI
tools we used", which is what the challenge page asks judges to be able to verify. The cookbooks
are public domain.

The app is built with SwiftUI, which is Apple's and not open source. The Open-Source AI page sets
no rule on frameworks or APIs. It asks that open-weight AI be an important part of how the project
works, and here the plan, the recipes, the photo import and every answer Basil gives come from
Gemma. All the non-UI code
lives in the `YesChefCore` Swift package, which has no third-party dependencies and builds and
tests on Linux with `swift test`.

## The rubric

Impact and value come from who it's for. It's built for a beginner cooking for a household, and
that cook has to plan around allergies and picky eaters before they've learned to cook at all.
Basil plans the week, writes the shopping list, and then teaches each recipe one step at a time.

Innovation and creativity come from three things together. Basil is a character with moods, a
voice and outfits you buy with the leaves you earn by cooking. He learns each person's taste on the phone, with no
account or server, and he cites real cookbooks for his ideas.

Feasibility and scalability are good because there's no backend to run. The learning and the
cookbook search happen on the phone and cost nothing per user. The only cloud cost is the Gemma
call. A release needs a small server to hold the API key, and saved data moves to one local SQLite
database ([requirements.md](requirements.md), TR-04 and TR-05).

Technical execution shows in the tests and the live runs. `YesChefCore` has unit tests for the
learning math, the allergy rules, the planner, the cookbook search and the shopping list, plus live
tests against the real Gemini API. A live run caught the allergy check rejecting "peanut-free" in a
note, and we fixed it (a002457). The full design set (UML, sequence and state
diagrams, wireframes and a feature sheet) is in [docs/design](design/README.md).

## What doesn't work yet

The demo plans three days, because we never timed a full seven-day plan. The
household, its health goals and its budget come from sample data and can't be edited in the app
yet, and nothing checks the plan against the budget. The shopping list and the points are saved on
the phone, and everything else lasts only while the app is open. We hadn't confirmed voice input in
the iOS Simulator before demos, though typed chat goes through the same code path. The API key is
built into the demo app, which is fine for a demo and wrong for a release.

Next come a weekly check-in on shopping day, meals where you pick who's eating and add guests,
short technique videos, the full-screen spit when you rate a dinner one star, and calendar-aware
days. The [feature sheet](design/feature-sheet.md) tracks every one of them.
