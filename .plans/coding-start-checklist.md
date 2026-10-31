# Hack day checklist

Started at 11:50 and updated at 13:48. The open tasks come first, with who owns each one. The
sections after them are the original setup list, ticked as things got done. Items marked
"unverified" are things nobody has checked yet.

## Open tasks for the demo (as of 13:48)

Submissions open at 2:15 and close at 2:45, and demos run from 2:45. No new features after 2:00.

MacBook:

- [x] Pull `main` (96fc980 or later) and rebuild. Done at 13:48: the app builds and carries
      `YesChefCore_YesChefCore.bundle/cookbooks.json`. YesChefCore now bundles
      `Resources/cookbooks.json` (2.6 MB, six public-domain cookbooks from Project Gutenberg) as a
      package resource. Check the app still builds, and that `Cookbook.bundled` isn't nil in the
      simulator, which means the resource made it into the app.
- [ ] Show where a dinner came from. `DinnerIdea.source` holds the cookbook's title when Gemma based
      the idea on a classic, and it's nil otherwise. A line like "Adapted from The Century Cook
      Book (Project Gutenberg)" on the day card and the recipe screen shows the grounding to the
      judges.
- [x] Plan fewer days for the demo. Done in fa7799c: three days, and with retrieval on, the plan,
      a recipe and a question took under 60 seconds on the simulator. `AppModel.planWeek()` asked for all seven days, which nobody had
      timed. A two-day plan, a recipe and a question took about 37 seconds together on the Linux
      laptop. Passing `days: Array(MealPlanner.weekdays.prefix(3))` keeps the wait short while
      Basil cooks.
- [ ] Rehearse the demo path end to end in the simulator with the real key: plan, open a dinner,
      cook a step, ask Basil by voice, rate it, show the learning card, import the salmon
      screenshot. Plan, open and a typed question ran live at 13:48 via the debug launch argument
      `-demo plan,recipe,ask`. Voice, rating and import need a person tapping.
- [x] Trim the README's "What it does" to what the demo shows, and add one line on the Gutenberg
      cookbooks.

MacBook, after 14:08:

- [x] Pull bd449e1 or later and build. c80627a fixes voice input, the learning card labels and
      Basil's moods, and bd449e1 saves the shopping list. Both were written on the Linux laptop,
      which means Xcode is the first compiler to see them. Fix any build error before anything else.
      Checked at 14:32 on 5bd9337: `xcodebuild -destination 'generic/platform=iOS Simulator'` builds
      with no errors. Not run, because this Mac's simulator has no iOS runtime installed, so nothing was run or screenshotted.
- [ ] Check the shopping list: check items off, close and reopen the page, and quit and relaunch
      the app. The checks should stay, and editing, adding and swiping away lines should work.
- [ ] Try the mic in the simulator. It should now wait up to 8 seconds for the first word and stop
      2 seconds after the last, and Basil should still speak his answer afterwards.
- [ ] Check the new moods: the pan only while Gemma thinks, a hop while listening, the cookbook
      for answers and recipes, the wall clock beside a running timer in cook mode, and the
      reactions to a 5-star and a 1-star rating.

Hardcoded for the demo, found at 14:10:

- [ ] `AppModel.household` is `SampleData.household` (Alex and Sam, a peanut allergy, a $90
      budget). The Household page only shows it, with nothing to edit.
- [ ] `AppModel.busyDays` is always `["Wednesday"]`, set in code, with no screen or calendar to
      change it.
- [ ] `AppModel.plan` starts as `SampleData.weekPlan`, and `planWeek` always plans Monday to
      Wednesday (`weekdays.prefix(3)`), not the next three days from today.
- [x] Cook mode now passes the real busy day to feedback (68e1080, nrlutken), which lets the two
      busy-day features learn.
- [ ] The learning models are in memory only and reset when the app quits (decided at 13:22).
- [ ] With no key, `open` shows `SampleData.recipe` (the fajitas) for any dinner.
- [ ] YesChefCore defaults: 3 ideas per day, 4 servings per recipe, temperature 0.7, a 90-second
      timeout, prices in US dollars, and "chicken soup vegetables" as the cookbook search when no
      one has listed likes.

Team:

- [x] Remove `gummi-main/`. Done at 14:10 on the operator's word; none of its code was used.
- [ ] Fill in the MLH submission, listing Gemma 4 and Claude Code as the AI tools.

Linux laptop:

- [ ] Stays on YesChefCore fixes and the terminal backup demo (`cd YesChefDemo && swift run
      yeschef-demo`). Send it any planner error the Mac sees.

## Decisions for the team

- [x] Pick the demo cut: plan, recipe, cook mode with timers, ask Basil, rate, learning card and
      photo import.
- [x] Pick hosted or on-device Gemma. Hosted, `gemma-4-26b-a4b-it` through the Gemini API, which is
      what the Gemma prize asks for. Thinking is set to minimal, which took a one-line reply from 3
      seconds to half a second.
- [x] Pick where the Gemini key lives. It's in `Config/Secrets.xcconfig` on the Mac, gitignored. A real
      release would need a small server that holds the key.
- [x] Pick the database layer. Decided at 13:22: the demo saves nothing and keeps everything in
      memory, and SwiftData or the sqlite3 library waits until after the hackathon.
- [ ] Pick the lowest iOS version. SwiftData and `@Observable` need iOS 17 or later. If we demo on
      someone's iPhone, its iOS version sets the floor.
- [x] Pick what "teaching" looks like on screen. It's one step at a time, with a technique note on
      every step, a timer when the step has one, and questions to Basil about the step.
- [x] Name the screens in Figma (14 frames, exported to `design/`).
- [x] Settle the mascot's art. Basil's SVGs come from Figma in `design/assets/`.
- [x] Ground Gemma in real recipes. Six public-domain cookbooks from Project Gutenberg, searched on
      the phone, with the book cited in each idea.

## Accounts and access

- [x] Create a Gemini API key. Gemma 4's rate limits are still unverified.
- [x] Give each coder push access to spheritual/yeschef.
- [x] Install Xcode on the Mac with an iOS simulator downloaded.
- [ ] Check whether HealthKit works on a free Apple ID (unverified). Only needed after the
      hackathon.
- [ ] Check whether MyFitnessPal, Fitbit and Google Fit still let new apps use their APIs
      (unverified). Only needed after the hackathon.
- [x] Repo visibility. Neither of us can make it public, and the operator dropped it at 13:14.

## Project setup on the Mac

- [x] Create the Xcode project, `YesChef`, at the repo root.
- [x] Add `Secrets.xcconfig` to `.gitignore` before anyone creates the file.
- [x] Add the local Swift package `YesChefCore` to the app target.
- [x] Add privacy strings for the microphone and speech recognition. The photo picker doesn't need
      one.

## Laptop setup

- [x] Install Swift 6.3.2 with `sudo dnf install swift-lang`.
- [x] Store the Gemini key with secret-tool for the laptop tests.

## Gemma integration

- [x] Confirm our key answers for the chosen model ID.
- [x] Check whether Gemma on the Gemini API accepts a JSON response schema. It does: JSON mode with
      a `responseSchema` returned valid JSON at 13:05. The app still validates the reply and
      retries once.
- [x] Write the prompts for a meal plan, a recipe with technique notes, an answer about a step and
      a recipe read from a photo.
- [x] Handle a slow or failed call with Basil's cooking animation, a retry from his confused mood,
      and the saved sample plan when the app has no key.

## Open source and submission

- [x] Add a LICENSE (Apache 2.0, matching Gemma 4).
- [x] Write the README with the model, its license, how to build it and screenshots.
- [x] List the AI tools we used in the README.
