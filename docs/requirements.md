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
| BR-10 | Give the assistant a chef character the user talks to by voice or text, who answers out loud and does a cooking animation while he works. | Demo | TR-11, TR-12, TR-21 |
| BR-11 | Compare deals at nearby stores and turn the shopping list into a drive-up pickup list. | Later | TR-19 |
| BR-12 | Let the user place a pickup order with stores that offer car pickup. | Later | TR-19 |
| BR-13 | Let users connect with each other and share recipes and plans. | Later | TR-18 |
| BR-14 | Send calories and macros to health apps, starting with Apple Health. | Later | TR-16 |
| BR-15 | Notice a restaurant visit and ask afterwards what the user ordered and how it was, which feeds later plans. | Later | TR-15, TR-17 |
| BR-16 | Plan around health goals, covering macros, calories, fiber and sugar, and specific diets. | Next | TR-03, TR-22 |
| BR-17 | Plan around each profile's flavour preferences and the time they have to cook. | Demo | TR-03, TR-05 |
| BR-18 | Give the user points for using the app regularly, with streaks, and let them spend the points dressing up the chef and his kitchen. | Next | TR-05, TR-23 |

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
