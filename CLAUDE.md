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
- One local SQLite database, through SwiftData or the sqlite3 library (still open)

## Docs

- `docs/requirements.md`: the business requirements (BR) and technical requirements (TR), with proposed priorities.
- `docs/architecture.md`: Mermaid diagrams for the system, the code split, the data model, the main flows and the screens, plus the file layout.
- `.plans/coding-start-checklist.md`: the decisions and setup still open before coding.

## Design

The Figma file is <https://www.figma.com/design/2avhsCApicqhfoXXjHm6KB/Untitled?node-id=1-2>. The team's screens call the app Sprig and the chef Basil, with Fraunces headings, Inter body text, a cream background (`#f8f5ec`), dark green text (`#263b2e`) and green buttons (`#386347`). Three proposal frames sit to the right of them: the main screen (node `9:2`), the burger menu open (`9:82`) and Basil cooking as the loading state (`9:183`). Whether the app is called Sprig or yeschef! is still open.

## Figma for agents

`.mcp.json` adds Figma's official MCP server (`https://mcp.figma.com/mcp`). In the terminal, Claude Code asks to approve it on first start. After that, run `/mcp`, pick `figma` and sign in through the browser with your own Figma account. If the approval prompt never shows (the VS Code extension didn't show it on Linux), run `claude mcp add --transport http --scope local figma https://mcp.figma.com/mcp` in this folder and restart Claude Code. Read Figma's `skill://figma/figma-use/SKILL.md` resource before any `use_figma` call, and `skill://figma/figma-design-to-code/SKILL.md` before `get_design_context`. Editing the team's file needs a Full seat on its Figma team.

## Building on the MacBook

1. Create the Xcode project as an iOS App with SwiftUI and Swift, product name `YesChef`, saved at the repo root, with "Create Git repository" unticked.
2. Put the Gemini key in `Secrets.xcconfig` as `GEMINI_API_KEY = your-key-here`, set it as the target's configuration file, and read it through an Info.plist entry `GEMINI_API_KEY = $(GEMINI_API_KEY)`. The file is gitignored, and a key never goes in the repo.
3. Put the non-UI code (models, the Gemini client, prompts, recipe parsing) in a local Swift package `YesChefCore`, which also builds with `swift test` on the Linux laptop. The UI and the Apple-only frameworks stay in the app target.
4. The lowest iOS version is still open. iOS 17 or later covers SwiftData and `@Observable`.

The Linux laptop has Swift 6.3.2 and can't build SwiftUI, which keeps its agent on `YesChefCore` and the docs.

## Principles

- Clean and minimalist, in code and in UI.
- Keep it simple. No speculative abstractions or features beyond what's asked.
- Ask before making big architectural decisions; they're still open.

## Skills

Project skills live in `.claude/skills/`.

- `/interview`: in-depth interview to produce a detailed spec in `.plans/<name>-spec.md`.
- `/swiftui-pro`: Paul Hudson's SwiftUI review skill, copied from twostraws/SwiftUI-Agent-Skill at commit f2920b6 (MIT).
- `/swiftui-expert-skill`: Antoine van der Lee's SwiftUI skill, copied from AvdLee/SwiftUI-Agent-Skill at commit 204dba7 (MIT). Its Instruments scripts were left out, which means its trace recording and analysis steps won't run.
