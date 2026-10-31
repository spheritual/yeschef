# yeschef! under the hood

This page collects the technical details behind yeschef! for software engineers. Each section
links the code that does the work and the diagram that draws it. The diagrams are the exports in
[design/export](design/export), one per tab of [yeschef.drawio](design/yeschef.drawio), and
[design/README.md](design/README.md) says what each tab answers. Some tabs are behind the code,
and the last section lists where.

## How the code is split

The iPhone app has two parts. The `YesChef` app target holds the SwiftUI screens and anything that
needs an Apple-only framework. The `YesChefCore` Swift package holds everything else, which is the
Gemma client, the prompts, the cookbook search, the learning and the plan logic. `YesChefCore` has
no UI and no third-party dependencies, which means it builds and tests on Linux with `swift test`
(Swift 6.3.2 on the team's laptop) as well as on the Mac.

One `@Observable` class, [AppModel](../YesChef/AppModel.swift), holds the app's state. Screens
read it from the environment and call its methods, and no screen calls Gemma itself. The app
target uses Swift 6 with the main actor as its default isolation and Approachable Concurrency on,
which puts all UI state on the main actor by default.

The planner talks to Gemma through a one-method protocol,
[LanguageModel](../YesChefCore/Sources/YesChefCore/Gemma/LanguageModel.swift). The real
`GemmaClient` implements it, and so do the test fakes, which replay scripted replies with no
network.

The Xcode project uses synchronized folder groups. A file added under `YesChef/` joins the target
without a `project.pbxproj` edit, which kept several people and agents pushing to `main` at once
from colliding in the project file.

Drawn in [tab 2, components](design/export/02-components.png),
[tab 4, YesChefCore classes](design/export/04-classes-yeschefcore.png),
[tab 5, app classes](design/export/05-classes-app.png) and
[tab 13, file structure](design/export/13-file-structure.png).

## Gemma 4 on the Gemini API

[GemmaClient](../YesChefCore/Sources/YesChefCore/Gemma/GemmaClient.swift) calls
`gemma-4-26b-a4b-it` through the Gemini API's `generateContent` REST endpoint with `URLSession`,
and there's no Google SDK.

- The API key goes in the `x-goog-api-key` header, which keeps it out of any URL that ends up in
  a log.
- The model name is checked against letters, digits, `-` and `.` before it goes into the URL
  path.
- Thinking is set to `minimal`. With thinking on, a short reply took about 3 s, and with it off
  it took about 0.5 s.
- The temperature is 0.7 and the request timeout is 90 s.
- Every call carries a system instruction that makes Gemma speak as Basil.
- Photos go to Gemma as base64 `inlineData` next to the text, which is how it reads a recipe
  screenshot.
- Gemma can return reasoning parts marked `"thought": true`, and the client keeps only the answer
  parts.

[MealPlanner](../YesChefCore/Sources/YesChefCore/Gemma/MealPlanner.swift) makes five kinds of
call. `planWeek` plans the dinners, `recipe(for:)` writes a recipe with technique notes and a
nutrition estimate, and `recipeFromImage` reads a recipe photo. `askChef` answers a question about
a step, and `reply` runs the chat and can carry a change to the plan.

Drawn in [tab 1, system context](design/export/01-system-context.png),
[tab 2](design/export/02-components.png), [tab 4](design/export/04-classes-yeschefcore.png),
[tab 7, cook, ask and rate](design/export/07-sequence-cook-ask-rate.png) and
[tab 10, deployment](design/export/10-deployment.png).

## Getting reliable JSON out of a chat model

Each prompt that wants JSON ends with the exact shape to reply in, with a filled-in example. Gemma
still wraps JSON in code fences or a sentence often enough that
[JSONReply](../YesChefCore/Sources/YesChefCore/Gemma/JSONReply.swift) cuts out the outermost
`{...}` before decoding.

The decoding is lenient on purpose. Numbers arrive as `25`, `25.0` or `"25"`, and prices as
`"3.50"`, and all of them decode. Enum values are matched without case, and a flavour outside the
four known ones, like `"umami"`, is dropped. A missing value gets a safe default, which is
vegetarian, medium difficulty, 30 minutes or $4 a serving
([DinnerIdea.swift](../YesChefCore/Sources/YesChefCore/Gemma/DinnerIdea.swift)).

A reply that still doesn't parse gets one retry, with a short correction added to the prompt. If
the chat reply fails twice, Basil answers in plain text with no plan change.

Drawn in [tab 6, planning the week](design/export/06-sequence-plan-my-week.png) as the "retry once
if not JSON" frame.

## Grounding in public-domain cookbooks (RAG)

Gemma's prompts carry passages from six cookbooks on Project Gutenberg. This is retrieval-augmented
generation, or RAG. The phone finds the passages that fit a request and pastes them into the
prompt, and Gemma is never trained on them.

[build_cookbooks.py](../YesChefCore/Scripts/build_cookbooks.py), a standard-library Python script,
built the corpus once before the app was built. It works like this:

1. It strips Gutenberg's license header and footer from each book.
2. It splits the text into blocks and treats a block as a recipe heading when it's a single line
   of 3 to 60 characters, in upper or title case, with no closing punctuation.
3. It starts a new passage at each heading, or once a passage passes 1,100 characters.
4. It keeps a passage only when it's at least 150 characters long and has at least two cooking
   words, such as cups, simmer or bake. That filter drops prefaces and indexes.
5. It caps each passage at 1,200 characters.

That gave 3,268 passages in `cookbooks.json`, which is 2.6 MB in the app and 0.7 MB compressed.

On the phone, [Cookbook.swift](../YesChefCore/Sources/YesChefCore/Cookbooks/Cookbook.swift) ranks
passages with BM25, the standard keyword ranking, using k1 = 1.2 and b = 0.75.

- A passage's heading is counted twice, which favours a passage named after the dish.
- The tokenizer lowercases the text, splits on anything that isn't a letter and folds simple
  plurals, which lets "tomatoes" find "tomato".
- It drops words of two letters or fewer and stopwords, including "dinner", "recipe", "easy" and
  "quick", since those appear in almost every query.
- The IDF term is `log(1 + (N - df + 0.5) / (df + 0.5))`, which never goes negative.
- Ties keep corpus order, which keeps the search repeatable.

Each call builds its own query. A plan searches on the household's likes and diets, a recipe on
the dinner's title, and a question on what was asked. Passages that mention an ingredient someone
must never eat are dropped before Gemma sees them.

Each passage goes into the prompt as at most 500 characters, labelled with its book, author and
heading. A plan is told to base at least one idea a day on a classic and name the book in
`source`, which the day cards then show. A recipe is told to follow a matching classic with modern
measurements, equipment and safe cooking temperatures.

Building the BM25 index took about 4 s in a debug build. The index builds once, on first use, off
the main actor, and the app starts it at launch with `MealPlanner.warmUp()`.

Nothing checks yet that the book Gemma names was one of the passages it was shown.

Drawn in [tab 1](design/export/01-system-context.png) as the cookbooks box,
[tab 2](design/export/02-components.png) as `Cookbook`, the note on
[tab 6](design/export/06-sequence-plan-my-week.png), and the first step of
[tab 9, how Basil learns](design/export/09-activity-how-basil-learns.png).

## Allergy safety in four layers

Safety never depends on the learned model, and an allergen has to get past four checks to reach a
plate:

1. Cookbook passages naming a banned ingredient are dropped before the prompt is built.
2. The prompt lists what each person must never eat.
3. [HardRules](../YesChefCore/Sources/YesChefCore/Learning/HardRules.swift) drops any idea with a
   banned ingredient after Gemma replies and before ranking. Matching is a case-insensitive
   substring. Phrases that say an item is free of the term, like "peanut-free" or "no peanuts",
   are cut first. A live run caught the check rejecting "cornbread mix (ensure peanut-free)",
   fixed in a002457.
4. A finished recipe with a banned ingredient throws `unsafeRecipe`, and a plan change from the
   chat that names one is ignored.

Drawn in [tab 4](design/export/04-classes-yeschefcore.png) as `HardRules`, as the `HardRules`
lifeline in [tab 6](design/export/06-sequence-plan-my-week.png), and as the "Any safe idea left?"
decision in [tab 9](design/export/09-activity-how-basil-learns.png).

## Learning tastes with Thompson sampling

Basil learns each person's taste with Linear Thompson Sampling, a contextual bandit (Agrawal and
Goyal, ICML 2013). It runs entirely on the phone. The spec is
[.plans/feedback-learning-spec.md](../.plans/feedback-learning-spec.md).

[FeatureEncoder](../YesChefCore/Sources/YesChefCore/Learning/FeatureEncoder.swift) turns each
dinner into 15 numbers:

- a bias term of 1
- one-hot protein: chicken, beef, pork, fish or vegetarian
- multi-hot flavour: spicy, sweet, savory, fresh
- cook time as minutes / 60, capped at 1.5
- difficulty as 0, 0.5 or 1
- cost as dollars per serving / 10, capped at 1.5
- busy day times cook time, and busy day times difficulty

The two busy-day terms are interactions, and they let the model learn "quick and easy on busy
days" separately from a general taste for quick dinners.

[PreferenceModel](../YesChefCore/Sources/YesChefCore/Learning/PreferenceModel.swift) is Bayesian
linear regression. It keeps a 15 by 15 precision matrix A, which starts as the identity (prior 1),
and a target vector b. Each piece of feedback with features x and reward r adds x x^T to A and
r x to b. The mean weights are A^-1 b, solved through a Cholesky factorization A = L L^T
([Cholesky.swift](../YesChefCore/Sources/YesChefCore/Learning/Cholesky.swift)) without ever
inverting A.

Old feedback fades by a factor of 0.97 on every update. The factor applies only to the learned
part of A, and the prior stays at full strength, which keeps the Cholesky factorization valid
however long the history gets.

To rank, each model draws one weight vector from its posterior N(A^-1 b, 0.5^2 A^-1). The draw is
the mean plus 0.5 L^-T z, where z is standard normal noise from a Box-Muller transform. Uncertain
dinners get wider draws, which means Basil sometimes tries something new and learns from it. That
exploration is what separates Thompson sampling from always picking the current favourite.

[Recommender](../YesChefCore/Sources/YesChefCore/Learning/Recommender.swift) gives each household
member their own model. Each one draws once, and a dinner's score is the average over the
household. Ties keep input order.

[FeedbackSignal](../YesChefCore/Sources/YesChefCore/Learning/FeedbackSignal.swift) turns what the
cook does into a reward from 0 to 1. A rating of s stars gives `(s - 1) / 4`, cooking it gives 0.8,
skipping gives 0.3 and swapping it out gives 0.1.

A model decodes from JSON only when its shape and settings are valid, which turns a corrupt saved
model into a load error before the solver ever sees it. Tests seed a SplitMix64 generator
([SeededGenerator.swift](../YesChefCore/Sources/YesChefCore/Learning/SeededGenerator.swift)),
which makes a ranking repeatable. The "Basil is learning you" card charts the household's mean
weights, and the models live in memory only for the demo.

Drawn in [tab 2](design/export/02-components.png) as `Recommender` and `PreferenceModel`, in
[tab 4](design/export/04-classes-yeschefcore.png) with the 15 by 15 precision matrix, as the
rating step in [tab 7](design/export/07-sequence-cook-ask-rate.png), and as the whole loop with the
rewards and the 0.97 decay in [tab 9](design/export/09-activity-how-basil-learns.png).

## Planning days in parallel, and other latency work

Gemma's reply time grows with how much it writes. Every call we timed ran at about 160 characters
a second whatever the prompt size, and a three-day plan in one call took 30 s.

`planWeek` now asks for each day in its own call, and all the calls run at once in a Swift task
group. Results go back into day order by index, whatever order they finish in. The calls can't see
each other, which is why each day gets every nth cookbook passage. A dinner an earlier day already
picked also moves to the back of a later day's list. A day whose call fails is left out, and the
first error is thrown only when every day failed. The same three-day plan took 11.8 s.

Once a plan arrives, `AppModel` starts fetching each planned dinner's recipe in the background,
keyed by title. Opening a dinner uses that fetch, or waits for it if it's still running, and a
recipe takes about 20 s from Gemma.

The tests use a fake model that answers each day by name and counts how many calls are in flight.
Planting three bugs confirmed that the tests catch a lost day order, a repeated dinner and calls
that run one at a time.

Not drawn yet. [Tab 6](design/export/06-sequence-plan-my-week.png) still shows one planning call,
and [tab 7](design/export/07-sequence-cook-ask-rate.png) shows no prefetch.

## Voice in and out

[MicButton](../YesChef/Voice/MicButton.swift) streams audio from an `AVAudioEngine` input tap into
`SFSpeechRecognizer` and shows the partial transcript as Basil's subtitle while you talk.

- Listening stops 2 s after the last word, or after 8 s if you never start talking.
- Recognition is allowed to use Apple's server, which avoids an instant failure when the
  on-device speech model isn't downloaded.
- A late callback from an earlier session is ignored by comparing request identity, and the
  recognizer is held for the whole session.
- The audio session switches to record while listening and back to playback after, since a
  record-only session would leave Basil's spoken answer silent.
- A failure says why in Basil's subtitle, which tells a permission problem from a missing mic.

Basil's answers are spoken on the phone by `AVSpeechSynthesizer`, with no cloud voice, and he can
be muted.

Drawn in [tab 1](design/export/01-system-context.png) as the iOS frameworks box,
[tab 2](design/export/02-components.png) as the Voice box,
[tab 7](design/export/07-sequence-cook-ask-rate.png) as the voice question, and
[tab 8, Basil's moods](design/export/08-state-basil-s-moods.png) as the Listening state.

## Basil's moods

`BasilMood` has nine cases: idle, listening, cooking, talking, teaching, timer, yum, yuck and
confused. Every Gemma call the cook waits on runs through one wrapper, `run`, which shows the
cooking mood for the wait. On success it switches to talking, or to teaching for a recipe or an answer. On failure it
switches to confused and stores a retry closure for the "Try again" button. After Basil speaks,
he drifts back to idle after text length / 15 seconds, held between 3 and 12 s.

Drawn in [tab 8](design/export/08-state-basil-s-moods.png), which shows five of the nine moods.

## Points and streaks

[PointsLog](../YesChefCore/Sources/YesChefCore/Learning/PointsLog.swift) is a dated log of actions,
and the balance and the streak are recomputed from it, never counted up. Planning earns 10 leaves,
cooking 25, rating 10, asking 5 and importing 15. The balance is what was earned minus the cost of
owned outfits, which cost 0, 60, 120 and 300 leaves. A streak counts days in a row with any action,
and it counts back from yesterday until something happens today, which keeps it alive until the
day is over.

Drawn in [tab 3, use cases](design/export/03-use-cases.png) and
[tab 12, wireframes](design/export/12-wireframes.png).

## Storage

There's no database in the demo, which the team decided at 13:22. The shopping list and the points
log are written as JSON to the app's Documents folder after every change. A new plan replaces the
plan's items on the shopping list, keeps the cook's own items and keeps the check on anything
already bought that the new plan still needs. A swap moves the old dinner into the day's
alternatives and records it as swapped feedback. Everything else lives in memory, and the planned
SQLite schema for after the hackathon is in [architecture.md](architecture.md).

Not drawn as current. [Tab 1](design/export/01-system-context.png) still says the demo keeps its
data in memory only.

## Keys and secrets

The Gemini key lives in a gitignored `Config/Secrets.xcconfig` on the Mac. The build passes it
through `Info.plist` to `AppSecrets`, which treats an unexpanded `$(...)` as no key, and the
laptop keeps its copy in the system keyring. The key never enters the repo. Anything inside an
app binary can be pulled out, which is why a release needs a small server to hold the key
([requirements.md](requirements.md), TR-04).

Drawn in [tab 10](design/export/10-deployment.png).

## Testing

`YesChefCore` has unit tests for the learning math, the allergy rules, the planner, the cookbook
search, the shopping list, plan changes and points, and they run on Linux. Live tests against the
real API run only when a key is set. To check that the tests catch real bugs, we planted bugs and
confirmed a named test failed for each. There were four in the learning code and three in the
parallel planner. `AppModel.swift` was also type-checked on Linux with the app target's Swift 6 and
main-actor settings, although only Xcode builds the app itself.

Drawn in [tab 10](design/export/10-deployment.png) as `swift test` on the Linux laptop.

## The design set is code too

[build_diagrams.py](design/build_diagrams.py) generates all 13 tabs as draw.io XML with the Python
standard library, and the draw.io desktop app exports them to PNG, SVG and one PDF. The set maps
onto the viewpoints of IEEE 1016, the standard for software design descriptions, in
[design/README.md](design/README.md). The finished screens came out of Figma through Figma's MCP
server, with the color and type tokens in [design/tokens.json](../design/tokens.json).

## Where the diagrams are behind the code

- [Tab 1](design/export/01-system-context.png) says the demo keeps its data in memory only, and the
  shopping list and points are saved now.
- [Tab 4](design/export/04-classes-yeschefcore.png) has no `reply`, `PlanChange`, `ShoppingList`,
  `PointsLog`, `Nutrition` or `DinnerIdea.source`.
- [Tab 6](design/export/06-sequence-plan-my-week.png) shows one planning call, and the planner now
  makes one call per day in parallel.
- [Tab 7](design/export/07-sequence-cook-ask-rate.png) doesn't show the recipe prefetch.
- [Tab 8](design/export/08-state-basil-s-moods.png) shows five moods out of nine, and it's missing
  teaching, timer, yum and yuck.
