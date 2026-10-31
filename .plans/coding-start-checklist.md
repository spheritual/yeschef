# Checklist before we start coding

Written at 11:50 on hack day. The humans own design and architecture, and Claude writes the Swift.
The decisions in the first section come before any code, since each one changes what gets built.
Items marked "unverified" are things nobody has checked yet.

## Suggested timeline

- 12:15: decisions made, Xcode project pushed to the repo.
- 1:30: the core flow runs in the simulator.
- 2:00: no new features. README, license and the public repo get finished.
- 2:15 to 2:45: submit. Demos run 2:45 to 3:45.

## Decisions for the team

- [ ] Pick the demo cut. Two and a half hours fits one flow from start to finish: preferences in, a
      Gemma meal plan out, one recipe opened in a step-by-step cooking mode, then saved and rated.
      My suggested stretch order is recipe import from a screenshot first, because it shows Gemma
      reading images, then calendar, then health apps, then restaurant detection.
- [ ] Pick hosted or on-device Gemma. The opening slides give the Gemma prize for models "via the
      Gemini API", which points to gemma-4-26b-a4b-it or gemma-4-31b-it over REST. On-device would
      add Google's AI Edge runtime as a dependency, and it probably wouldn't count for that prize.
- [ ] Pick where the Gemini key lives. Anyone holding the app can pull out a key compiled into it.
      For the demo, a gitignored `Secrets.xcconfig` on the Mac works. A real release would need a
      small server that holds the key.
- [x] Pick the database layer. Decided at 13:22: the demo saves nothing and keeps everything in
      memory, and this choice waits until after the hackathon. SwiftData is Apple's own and stores its data in SQLite, but it only
      builds on the Mac. The sqlite3 C library builds on the Mac and on the Linux laptop, which
      lets Claude test storage code before it reaches the Mac, at the cost of hand-written SQL.
- [ ] Pick the lowest iOS version. SwiftData and `@Observable` need iOS 17 or later. If we demo on
      someone's iPhone, its iOS version sets the floor.
- [ ] Pick what onboarding asks: dietary restrictions, allergies, dislikes, cooking skill, kitchen
      equipment, time per meal, people to feed and budget.
- [ ] Pick what "teaching" looks like on screen. One option is that every step carries a plain
      explanation of its technique, a timer when the step has one, and an "ask the chef" button
      that sends that step to Gemma.
- [ ] Name the screens and the order between them in Figma. That list becomes the SwiftUI views.
- [ ] Settle the mascot's art. Designers export the character from Figma as images, and Claude uses
      a placeholder until then.

## Accounts and access

- [ ] Create a Gemini API key at <https://aistudio.google.com/apikey> and check Gemma 4's limits
      on AI Studio's rate-limit page (unverified, since the docs don't list them).
- [ ] Give each coder push access to spheritual/yeschef.
- [x] Install Xcode on the Mac with an iOS simulator downloaded. An Apple ID in Xcode is only
      needed to run on a real iPhone.
- [ ] Check whether HealthKit works on a free Apple ID (unverified). This only matters if health
      integration makes the cut.
- [ ] Check whether MyFitnessPal, Fitbit and Google Fit still let new apps use their APIs
      (unverified). HealthKit is the iOS-native path.

## Project setup on the Mac, first

- [x] Create the Xcode project as an iOS App with SwiftUI and Swift, product name `YesChef`, saved
      at the repo root. Untick "Create Git repository" because the repo already exists. Push it.
- [x] Add `Secrets.xcconfig` to `.gitignore` before anyone creates the file.
- [x] Add the local Swift package `YesChefCore` (Claude writes it) to the app target. It holds the
      non-UI code: models, the Gemini client, prompts and recipe parsing.
- [ ] Add an Info.plist privacy string for each permission we use (calendar, location, microphone,
      speech recognition, photo library, health). iOS ends the app when it asks for a permission
      whose string is missing.

## Laptop setup

- [ ] Install Swift with `sudo dnf install swift-lang` (6.3.2). It builds and tests `YesChefCore`
      on Linux. Xcode may ship a newer Swift, and the core package sticks to what both support.
- [ ] Store the Gemini key with secret-tool for the laptop tests.

## Gemma integration

- [x] Confirm our key answers for the chosen model ID.
- [x] Check whether Gemma on the Gemini API accepts a JSON response schema. It does: JSON mode with
      a `responseSchema` returned valid JSON at 13:05. The app still validates the reply and
      retries once.
- [ ] Write the prompts for a meal plan from preferences, a recipe in a fixed format with steps a
      beginner can follow, an explanation of one step, and a recipe read from a screenshot.
- [ ] Handle a slow or failed call with a loading state, a retry, and a saved sample plan for the
      demo in case the network drops.

## Data model, first pass

Claude drafts these once the decisions above are made.

- Profile: restrictions, allergies, dislikes, skill level, equipment and household size.
- Recipe: title, servings, total time, ingredients with amounts and units, steps with technique
  notes and timers, source, rating and notes, with room for nutrition later.
- Meal plan: days, meals per day and the recipe for each meal.
- Shopping list: ingredients combined across the plan's recipes.

## Open source and submission

- [ ] Make the repo public before 2:15.
- [ ] Add a LICENSE. Apache-2.0 matches Gemma 4's license.
- [ ] Write the README with what the app does, the model's name and a link to its license (the
      open-source track requires both), how to build it and screenshots.
- [ ] List the AI tools we used (Claude Code and Gemma 4) in the submission, as MLH's rules ask.
