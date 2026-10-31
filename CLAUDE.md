# yeschef!

A personal AI cooking assistant. Gemma 4 is the brain, Swift/SwiftUI is the stack.

## Status

**Building.** Coding starts on the MacBook. Submissions open at 2:15 PM on 2026-10-31 and close at 2:45, and demos run from 2:45 to 3:45. Several agents and people push to `main`, which is why every agent pulls before it starts, keeps commits small and pushes often. Use the `/interview` skill for any new spec; specs are saved to `.plans/`.

## Vision

- **AI meal planner.** Asks for the week's plan and the user's preferences. Also draws on restaurants the user recently visited, their taste preferences, and local stores.
- **Recipe and plan database.** Stores previous recipes and past plans so future plans build on history.
- **Meal prep focus.** Generates a shopping list of what's needed and simple, easy-to-follow cooking instructions.
- **The assistant is a character.** A squishy, cute creature the user interacts with directly. Voice-to-text input is supported.
- **Future:** calorie tracking, MyFitnessPal-style. Keep the data model open to it, but do not build it yet.

## Stack

- Swift 6 / SwiftUI, an iOS app built in Xcode on the MacBook
- Gemma 4 through the Gemini API (`gemma-4-26b-a4b-it`), called over REST with `URLSession`. The Gemma prize is for models "via the Gemini API", which rules out on-device for the prize.
- No storage for the demo: the app keeps everything in memory and saves nothing, not even settings (decided at 13:22). One local SQLite database, through SwiftData or the sqlite3 library, comes after the hackathon.

## Docs

- `docs/requirements.md`: the business requirements (BR) and technical requirements (TR), with proposed priorities.
- `docs/architecture.md`: Mermaid diagrams for the system, the code split, the data model, the main flows and the screens, plus the file layout.
- `.plans/coding-start-checklist.md`: the decisions and setup still open before coding.

## Design

The Figma file is <https://www.figma.com/design/2avhsCApicqhfoXXjHm6KB/Untitled?node-id=1-2>. The team's screens call the app Sprig and the chef Basil, with Fraunces headings, Inter body text, a cream background (`#f8f5ec`), dark green text (`#263b2e`) and green buttons (`#386347`). Three proposal frames sit to the right of them: the main screen (node `9:2`), the burger menu open (`9:82`) and Basil cooking as the loading state (`9:183`). The app is called yeschef!, not Sprig (decided at 13:22), and the chef is Basil.

Since 14:30 the app follows the system's light or dark mode. Every color is an adaptive token in `YesChef/Theme/Theme.swift` (the light values above are unchanged, the dark ones are a deep green-black with a sage green), plus `Theme.onGreen` for text on green and `Theme.hairline` for separators; don't hardcode colors in screens. Basil is a translucent jelly chef drawn in SwiftUI in `YesChef/Basil/` and `YesChef/Main/BasilView.swift`, not the exported SVG.

## Figma for agents

`.mcp.json` adds Figma's official MCP server (`https://mcp.figma.com/mcp`). In the terminal, Claude Code asks to approve it on first start. After that, run `/mcp`, pick `figma` and sign in through the browser with your own Figma account. If the approval prompt never shows (the VS Code extension didn't show it on Linux), run `claude mcp add --transport http --scope local figma https://mcp.figma.com/mcp` in this folder and restart Claude Code. Read Figma's `skill://figma/figma-use/SKILL.md` resource before any `use_figma` call, and `skill://figma/figma-design-to-code/SKILL.md` before `get_design_context`. Editing the team's file needs a Full seat on its Figma team.

## Building on the MacBook

The Xcode project exists (13:10). `YesChef.xcodeproj` has one app target, `YesChef`: iOS 17 to match `YesChefCore`, Swift 6, iPhone only, portrait. It is linked to the local `YesChefCore` package.

- The app's files live in `YesChef/`, which Xcode syncs as a folder. Add, move or delete files there without touching `project.pbxproj`, which keeps parallel pushes from conflicting.
- The Gemini key goes in `Config/Secrets.xcconfig` as `GEMINI_API_KEY = your-key-here`. The file is gitignored, and a key never goes in the repo. `Config/YesChef.xcconfig` includes it when it exists, `YesChef/Info.plist` passes it on, and code reads it through `AppSecrets.geminiAPIKey`, which is nil without the file.
- Build from the terminal with `xcodebuild -project YesChef.xcodeproj -scheme YesChef -destination 'platform=iOS Simulator,name=iPhone 18 Pro' build`.
- `YesChefCore/` is the only package; don't create a second one. It holds the feedback learning code from `.plans/feedback-learning-spec.md`, and it builds and tests with `swift test` on the Linux laptop and the Mac. Other non-UI code (models, the Gemini client, prompts, recipe parsing) goes in it too, and the UI and the Apple-only frameworks stay in the app target.
- The app target is main-actor isolated by default, so mark non-UI helpers in it `nonisolated`.

Gemma on the Gemini API, checked at 13:05 with the team key:
- `gemma-4-26b-a4b-it` and `gemma-4-31b-it` both answer, and system instructions work.
- JSON mode with a `responseSchema` returns valid JSON.
- Replies can include the model's reasoning as extra parts marked `"thought": true`. Keep only the parts without that flag.

The Linux laptop has Swift 6.3.2 and can't build SwiftUI, which keeps its agent on `YesChefCore` and the docs.

The open tasks for every machine are at the top of `.plans/coding-start-checklist.md`; read them after each pull.

The Gemma side is in `YesChefCore/Sources/YesChefCore/Gemma/`, and the MacBook uses it and doesn't write its own Gemini client. Since 13:44 the planner also searches six public-domain cookbooks from Project Gutenberg (`YesChefCore/Sources/YesChefCore/Cookbooks/`) and puts the best passages in each prompt, and `DinnerIdea.source` names the book an idea came from. `SampleData` has a fixed household, week plan and recipe for previews and for an offline demo.

```swift
import YesChefCore

let key = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String ?? ""
let planner = MealPlanner(model: GemmaClient(apiKey: key))
let plan = try await planner.planWeek(for: household, busyDays: ["Wednesday"], learning: models)
let recipe = try await planner.recipe(for: plan.days[0].pick, household: household)
let answer = try await planner.askChef("Is it done?", step: recipe.steps[0], recipe: recipe)
```

Every call can throw `GemmaError`, and the screen shows Basil's "Confused" mood with a retry when one does.

## Principles

- Clean and minimalist, in code and in UI.
- Keep it simple. No speculative abstractions or features beyond what's asked.
- Ask before making big architectural decisions; they're still open.

## Skills

Project skills live in `.claude/skills/`.

- `/interview`: in-depth interview to produce a detailed spec in `.plans/<name>-spec.md`.
- `/swiftui-pro`: Paul Hudson's SwiftUI review skill, copied from twostraws/SwiftUI-Agent-Skill at commit f2920b6 (MIT).
- `/swiftui-expert-skill`: Antoine van der Lee's SwiftUI skill, copied from AvdLee/SwiftUI-Agent-Skill at commit 204dba7 (MIT). Its Instruments scripts were left out, which means its trace recording and analysis steps won't run.
