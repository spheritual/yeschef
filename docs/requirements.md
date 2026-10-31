# yeschef! requirements

yeschef! is an iPhone app that plans a household's meals for the week and teaches a beginner to
cook them. Gemma 4 does the planning, the recipe reading and the cooking help. This page lists what
the app has to do for its users (business requirements, BR) and how it has to be built (technical
requirements, TR). The diagrams are in [architecture.md](architecture.md), and the decisions still
open are in [the start checklist](../.plans/coding-start-checklist.md).

The BR table combines the team's high-level overview with the feature list a teammate wrote at
13:00, which added BR-16 to BR-18. The priority column is a proposal for the team to confirm, and
the [feature sheet](design/feature-sheet.md) says what's actually built. "Demo" means it works on stage at 2:45
today. "Next" means it's the first thing after the hackathon, and "Later" needs outside access or
a server we don't have yet.

## Business requirements

| ID | The app has to | Priority | Built on |
| --- | --- | --- | --- |
| BR-01 | Plan a week of meals for the household from each profile's preferences, dietary needs and the week's budget. | Demo | TR-02, TR-03, TR-05 |
| BR-02 | Teach a beginner to cook each recipe one step at a time, explaining every technique in plain words and answering questions about a step. | Demo | TR-02, TR-14 |
| BR-03 | Keep the user's recipes and let each profile rate them, which feeds later plans. | Demo | TR-05 |
| BR-04 | Build a shopping list from the week's plan. | Demo | TR-05 |
| BR-05 | Import a recipe quickly from a photo or screenshot, and later from a web link. | Demo | TR-02, TR-03 |
| BR-06 | Read the user's calendar and plan each day around it, with a meal on the go, no meal on a night out, a dish to bring to a family get-together, and meals prepped ahead for busy days. | Next | TR-08, TR-09 |
| BR-07 | Respect the kitchen the user has that day, such as no fridge, stove or microwave while on the go. | Next | TR-03 |
| BR-08 | Keep the week's groceries within a budget the user sets. | Next | TR-19 |
| BR-09 | Hold several profiles under one account, such as children, each with their own preferences and needs. | Next | TR-05 |
| BR-10 | Give the assistant a chef character the user talks to by voice or text, who answers out loud. He cooks with a frying pan only while he's thinking, looks at a clock on the wall while a timer runs, hops up and down while the user talks to him, and pulls out a cookbook to teach from. | Demo | TR-11, TR-12, TR-21 |
| BR-11 | Compare deals at nearby stores and turn the shopping list into a drive-up pickup list. | Later | TR-19 |
| BR-12 | Let the user place a pickup order with stores that offer car pickup. | Later | TR-19 |
| BR-13 | Let users connect with each other and share recipes and plans. | Later | TR-18 |
| BR-14 | Send calories and macros to health apps, starting with Apple Health. | Later | TR-16 |
| BR-15 | Notice a restaurant visit and ask afterwards what the user ordered and how it was, which feeds later plans. | Later | TR-15, TR-17 |
| BR-16 | Plan around health goals, covering macros, calories, fiber and sugar, and specific diets. | Next | TR-03, TR-22 |
| BR-17 | Plan around each profile's flavour preferences and the time they have to cook. | Demo | TR-03, TR-05 |
| BR-18 | Give the user points for using the app regularly, with streaks, and let them spend the points dressing up the chef and his kitchen. | Next | TR-05, TR-23 |
| BR-19 | Check in once a week, on the household's grocery shopping day, to plan the coming week and build that week's shopping list. | Next | TR-25 |
| BR-20 | Make the plan editable. A default plan comes first, and any meal can be changed to a custom one, with the user choosing who from the household is eating and adding guests for that day. | Next | TR-26 |
| BR-21 | Teach techniques with short videos on a Learning page of their own, also linked from the recipe step that uses each technique. | Next | TR-27 |
| BR-22 | Give the chef reactions and life. A bad rating makes him spit at the screen as if it were a camera, covering it; a great rating gets sparkles and a belly rub; he walks around his stage; and a bell gets his attention. | Demo for the rating reactions, Next for the rest | TR-28 |

## Technical requirements

| ID | Requirement |
| --- | --- |
| TR-01 | The app is an iOS app in Swift 6 and SwiftUI. The lowest iOS version is still open, and SwiftData or `@Observable` would make it iOS 17. |
| TR-02 | Gemma 4 runs through the Gemini API (`gemma-4-26b-a4b-it`, with `gemma-4-31b-it` as the alternative), called over REST with `URLSession` and no Google SDK. |
| TR-03 | Every Gemma reply the app keeps is JSON, decoded into `Codable` types and checked against the profile's allergies, the budget and the day's limits. A reply that fails the check is retried once with the errors, then shown as an error. |
| TR-04 | The Gemini key lives in a gitignored `Secrets.xcconfig` and never enters the repo. The README says a release needs a small server to hold the key, since a key built into an app can be pulled out of it. |
| TR-05 | The demo keeps everything in memory and saves nothing, which the team decided at 13:22. After the hackathon the app stores everything in one local SQLite database, using SwiftData or the sqlite3 C library, with the schema in architecture.md. |
| TR-06 | The non-UI code (models, the Gemma client, prompts, recipe parsing and the plan rules) lives in a `YesChefCore` Swift package that builds and tests on Linux and macOS. The UI and the Apple-only frameworks stay in the app target. |
| TR-07 | The app uses the Swift standard library and Apple's frameworks only. Adding any third-party package is a team decision first. |
| TR-08 | Data stays on the phone except what a Gemma request needs, as listed in architecture.md. Calendar event titles go to Gemma only after the user turns that on, and location never leaves the phone. |
| TR-09 | The app asks for each permission (calendar, location, microphone, speech recognition, photos, health) when a feature first needs it, with an Info.plist string saying why, and every other feature keeps working if the user says no. |
| TR-10 | Saved recipes, plans and shopping lists work offline, and only new Gemma work needs the network. |
| TR-11 | Every Gemma call shows progress, can be cancelled and times out (60 seconds proposed). The demo keeps a saved sample plan in case the network drops. |
| TR-12 | The UI supports Dynamic Type, VoiceOver labels and Reduce Motion, which matters most for the animated character. Voice input uses Apple's Speech framework on the phone. |
| TR-13 | `YesChefCore` has unit tests that run with `swift test` on Linux. Gemma sits behind a protocol with a fake that replays saved replies, which keeps tests and SwiftUI previews off the network. The Mac builds and runs the UI in the iOS simulator. |
| TR-14 | Cook mode keeps the screen awake, and each step's timer fires a local notification. |
| TR-15 | Notifications are local only (UserNotifications), with no push server. |
| TR-16 | HealthKit writes dietary energy and macros after the user allows it. Whether MyFitnessPal, Fitbit and Google Fit still let new apps use their APIs is unverified. |
| TR-17 | Restaurant visits come from Core Location's visit monitoring plus a MapKit place lookup, which needs "Always" location permission. |
| TR-18 | Connecting users needs a shared backend, either iCloud sharing through CloudKit or our own server, because one phone's SQLite file can't reach another user. The choice is open. |
| TR-19 | Which grocers offer deal data and pickup-order APIs is unverified. Until someone checks, the app uses sample deal data labelled as samples, and prices beyond that are estimates the UI marks as estimates. |
| TR-20 | The repo is public with an Apache-2.0 license, and the README names Gemma 4 and links its license, which the open-source track requires. |
| TR-21 | The chef speaks through `AVSpeechSynthesizer` on the phone, with no cloud voice service. His words also show in the subtitle bar, which keeps him usable with the sound off. |
| TR-22 | Each recipe stores calories, protein, carbs, fat, fiber and sugar per serving. Where those numbers come from (Gemma's estimate or a nutrition database) is open, and the UI labels an estimate as one. |
| TR-23 | Points and streaks are kept in the local database as a log of dated actions, which lets the streak be recomputed and never just counted up. Outfits and kitchen items cost points only, with no real money. |
| TR-24 | Gemma's prompts are grounded in recipe passages from six public-domain cookbooks on Project Gutenberg, bundled with the app and searched on the phone with BM25. Passages naming a banned ingredient are dropped, and an idea based on a passage names its book. No web search or outside search service is involved. |
| TR-25 | The household picks a shopping day. A weekly local notification (UserNotifications with a repeating calendar trigger) asks Basil to plan the seven days that start on that day, and the shopping list covers exactly those seven days. Today the plan only runs when someone asks, and the demo plans Monday to Wednesday. |
| TR-26 | Each planned meal stores who's eating it and how many guests are coming. The planner applies the allergy rules and the preference models of only those eating, scales servings to the eaters plus guests, and the plan's default comes from the whole household. Today the household is the sample household and can't be edited. |
| TR-27 | Technique videos are linked out to their source, not copied into the app, because the licenses of the team's chosen sources in RESOURCES.MD are unverified. A table maps each technique to a video, and a recipe step links the technique its note names. |
| TR-28 | The rating reactions run as Basil moods in the app (yum and yuck). The bad-rating spit still has to cover the whole screen as a full-screen overlay, where it now stays around Basil; walking is an idle movement across the stage; the bell is a tap target on the stage that makes him turn and listen. |
