# yeschef!

A personal AI cooking assistant. Gemma 4 is the brain, Swift/SwiftUI is the stack.

## Status

**Planning phase.** This is a rough foundation, not a spec. Do not start implementing until the user says so. Use the `/interview` skill to flesh out specs first; specs are saved to `.plans/`.

## Vision

- **AI meal planner.** Asks for the week's plan and the user's preferences. Also draws on restaurants the user recently visited, their taste preferences, and local stores.
- **Recipe and plan database.** Stores previous recipes and past plans so future plans build on history.
- **Meal prep focus.** Generates a shopping list of what's needed and simple, easy-to-follow cooking instructions.
- **The assistant is a character.** A squishy, cute creature the user interacts with directly. Voice-to-text input is supported.
- **Future:** calorie tracking, MyFitnessPal-style. Keep the data model open to it, but do not build it yet.

## Stack

- Swift / SwiftUI
- Gemma 4 as the LLM (on-device vs. hosted is undecided; settle it in a spec)

## Principles

- Clean and minimalist, in code and in UI.
- Keep it simple. No speculative abstractions or features beyond what's asked.
- Ask before making big architectural decisions; they're still open.

## Skills

Project skills live in `.claude/skills/`.

- `/interview`: in-depth interview to produce a detailed spec in `.plans/<name>-spec.md`.
