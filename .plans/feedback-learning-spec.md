# Feedback learning spec

How yeschef! learns from a household's feedback and keeps trying new dishes. The Linux laptop
writes the learning code in `YesChefCore/Sources/YesChefCore/Learning/`, and the MacBook agent
wires it into the SwiftUI app. This page is the contract between the two. Change it here first,
then in code.

## The approach

Gemma proposes candidate recipes, and a contextual bandit picks among them. A bandit is a learner
that has to choose one option at a time, sees how that choice went, and balances picking what it
already knows the user likes (exploitation) against trying options it knows little about
(exploration). "Contextual" means each choice is described by features, which lets what it learns
about one taco recipe carry over to the next spicy, quick, chicken dish.

We use Linear Thompson Sampling (Agrawal and Goyal, "Thompson Sampling for Contextual Bandits
with Linear Payoffs", ICML 2013). Each profile keeps a Bayesian linear model over recipe features.
To rank candidates, the model draws one plausible set of weights from what it currently believes
and scores every candidate with that draw. A feature combination it has rarely seen gets a wide
spread of possible scores, which sometimes lands on top, and that is how new dishes get tried
without a separate rule. LinUCB (Li et al., WWW 2010) was the alternative, and Thompson Sampling
won because it explores by drawing at random, which keeps a week's plan from repeating itself.

Deep Q-networks and two-tower networks were ruled out. Both need far more interaction data than
one household gives, and both would need training infrastructure we don't have on a phone.

## The loop

1. The planner asks Gemma for 3 to 5 candidate recipes per meal slot, each with its feature tags
   in the JSON (protein, flavours, minutes, difficulty, cost per serving).
2. Hard rules for allergies, restrictions and dislikes remove candidates first. These are never
   learned and never outvoted by the model.
3. The recommender ranks what's left. For a meal several profiles eat, each profile's model
   scores the candidate and the household score is their average.
4. The top candidate goes in the plan, and the others become the "swap" options for that meal.
5. Feedback updates the model of every profile it applies to.

## Features

`FeatureEncoder.encode(recipe:day:)` turns a recipe and the day's context into 15 numbers.

| Index | Feature | Value |
| --- | --- | --- |
| 0 | bias | always 1 |
| 1 to 5 | protein | one-hot: chicken, beef, pork, fish, vegetarian |
| 6 to 9 | flavours | multi-hot: spicy, sweet, savory, fresh |
| 10 | cook time | minutes / 60, capped at 1.5 |
| 11 | difficulty | easy 0, medium 0.5, hard 1 |
| 12 | cost | cost per serving / 10, capped at 1.5 |
| 13 | busy day x cook time | 1 on a busy day times feature 10 |
| 14 | busy day x difficulty | 1 on a busy day times feature 11 |

The last two are what make it contextual. The model can learn "quick and easy on busy days"
separately from "quick and easy in general."

## Feedback signals

| Signal | Where the UI sends it | Reward |
| --- | --- | --- |
| `.rated(stars:)` | the rating sheet after cooking | (stars - 1) / 4, stars clamped to 1 to 5 |
| `.cooked` | "Done" at the end of cook mode | 0.8 |
| `.swapped` | the user swaps a planned meal for another | 0.1 for the meal swapped out |
| `.skipped` | a planned meal passes uncooked | 0.3 |

Rewards run from 0 to 1. Older feedback fades with a decay of 0.97 per update, which lets tastes
change over time while the prior stays in place.

## Swift interface

All types are value types and `Sendable`, and none of them touch the network, the clock or
storage. That keeps them testable on Linux.

```swift
public enum Protein: String, Codable, Sendable, CaseIterable { case chicken, beef, pork, fish, vegetarian }
public enum Flavour: String, Codable, Sendable, CaseIterable { case spicy, sweet, savory, fresh }
public enum Difficulty: String, Codable, Sendable { case easy, medium, hard }

public struct RecipeFeatures: Codable, Sendable, Hashable {
    public var protein: Protein
    public var flavours: Set<Flavour>
    public var minutes: Int
    public var difficulty: Difficulty
    public var costPerServing: Double
}

public struct DayContext: Codable, Sendable, Hashable { public var isBusy: Bool }

public enum FeedbackSignal: Codable, Sendable, Hashable {
    case rated(stars: Int), cooked, swapped, skipped
    public var reward: Double { get }
}

public enum FeatureEncoder {
    public static let dimension: Int   // 15
    public static let labels: [String] // human-readable name per index, for the chart
    public static func encode(_ recipe: RecipeFeatures, on day: DayContext) -> [Double]
}

public struct PreferenceModel: Codable, Sendable {
    public init(dimension: Int = FeatureEncoder.dimension, prior: Double = 1, decay: Double = 0.97, spread: Double = 0.5)
    public mutating func record(_ signal: FeedbackSignal, for features: [Double])
    public func expectedScore(_ features: [Double]) -> Double // what it believes now
    public func uncertainty(_ features: [Double]) -> Double   // how unsure it is
    public var weights: [Double] { get }                      // posterior mean, one per feature
}

public struct Ranked<Item> { public let item: Item; public let score: Double; public let expected: Double; public let uncertainty: Double }

public enum Recommender {
    public static func rank<Item>(_ items: [Item], features: (Item) -> [Double], models: [PreferenceModel], using rng: inout some RandomNumberGenerator) -> [Ranked<Item>]
}

public enum HardRules {
    // drops any item with an ingredient containing a banned term, ignoring case
    public static func excluding<Item>(_ items: [Item], ingredients: (Item) -> [String], banned: Set<String>) -> [Item]
}

public struct SeededGenerator: RandomNumberGenerator { public init(seed: UInt64) }
```

`banned` is every allergy, restriction and dislike term across the profiles eating that meal. The
filter matches on substrings, which means "peanut" also removes "peanut butter". It's a backstop
behind Gemma's prompt, and it can't catch an allergen hidden under another name.

The app passes `SystemRandomNumberGenerator()` to `rank`, and tests and previews pass
`SeededGenerator(seed:)`, which makes a ranking repeatable.

## Storage

The MacBook side adds two tables to the schema in `docs/architecture.md`.

- `PREFERENCE_MODEL`: `profile_id`, `state_json` (the `PreferenceModel` encoded as JSON),
  `updated_at`.
- `FEEDBACK_EVENT`: `profile_id`, `recipe_id`, `signal`, `reward`, `features_json`, `at`. This is
  also the dated log the points and streaks in TR-23 count from.

## What the UI shows

A "Basil is learning you" card charts `weights` against `FeatureEncoder.labels` with Swift Charts,
leaving out the bias. Bars to the right mean "more of this", and bars to the left mean "less of
this". The planner can also say why it picked a dish, using `expected` and `uncertainty` from
`Ranked`. A high expected score reads as "you loved something like this", and a high uncertainty
reads as "something new to try."

## Who edits what

The Linux laptop owns `YesChefCore/Package.swift` and `YesChefCore/Sources/YesChefCore/Learning/`.
The MacBook agent adds `YesChefCore` to the Xcode project as a local package and owns the views,
the storage and the Gemma call. Neither side edits the other's files without pulling first, and an
interface change goes into this file before it goes into code.

## Acceptance checks

These are tests in `YesChefCore/Tests/YesChefCoreTests/` that run with `swift test` on Linux.

- Repeated high rewards on one feature vector and low rewards on another rank the first above the
  second, by expected score.
- Uncertainty along a vector drops after feedback on that vector.
- A vector with features the model hasn't seen has higher uncertainty than one it has.
- With decay, the latest run of feedback outweighs an older run of the opposite feedback.
- The same seed gives the same ranking.
- A model encoded to JSON and decoded scores the same as before.
- The star reward maps 1 to 0 and 5 to 1, and clamps anything outside 1 to 5.
- The hard-rule filter removes an allergen even when the model scores it highest.
