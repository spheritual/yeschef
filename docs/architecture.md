# yeschef! architecture

This page shows how the app is put together. The requirements it builds on are in
[requirements.md](requirements.md), and the TR numbers below point there. Anything the team hasn't
decided yet is marked as open, and the screens stay a proposal until the Figma frames land.

## System context

The app runs on the phone and keeps its data in one SQLite file there. Gemma 4 answers over the
Gemini API. Apple's frameworks give it the calendar, health data, location, voice input and photos.
The dotted lines are for later, since they need grocer access or a sharing backend we don't have.

```mermaid
flowchart LR
    user(["Home cook"])
    subgraph phone ["iPhone"]
        app["yeschef! app"]
        db[("SQLite")]
        apple["Apple frameworks<br/>EventKit, HealthKit, Core Location,<br/>MapKit, Speech, PhotosUI"]
    end
    gemini["Gemini API<br/>Gemma 4"]
    grocer["Grocer APIs<br/>later, unverified"]
    cloud["iCloud CloudKit<br/>later, for sharing"]
    user --> app
    app --> db
    app --> apple
    app -- "prompts and JSON replies" --> gemini
    app -.-> grocer
    app -.-> cloud
```

## Components

The code splits into two parts (TR-06). `YesChefCore` is a Swift package with no UI, which means
it builds and tests on the Linux laptop as well as the Mac. The app target holds the SwiftUI views
and everything that needs an Apple-only framework. If the team picks the sqlite3 library over
SwiftData, the storage code moves into `YesChefCore` too.

```mermaid
flowchart TB
    subgraph appTarget ["YesChef app target, builds on the Mac"]
        views["SwiftUI views<br/>Onboarding, Week, Recipes, Cook, Shopping, Household"]
        stores["Observable stores<br/>PlanStore, RecipeStore, HouseholdStore"]
        adapters["Apple adapters<br/>CalendarReader, HealthWriter, VisitMonitor,<br/>SpeechInput, Notifier"]
        storage["Storage<br/>SQLite repository"]
    end
    subgraph core ["YesChefCore package, builds on the Mac and Linux"]
        models["Models<br/>Profile, Recipe, MealPlan, ShoppingList"]
        planner["Planner<br/>day rules, budget, shopping list builder"]
        prompts["Prompts and JSON schemas"]
        gemma["GemmaClient<br/>REST over URLSession"]
        importer["RecipeImporter<br/>JSON-LD from links, screenshots through Gemma"]
    end
    views --> stores
    stores --> adapters
    stores --> storage
    stores --> planner
    stores --> importer
    planner --> prompts
    planner --> gemma
    importer --> gemma
    planner --> models
    storage --> models
```

## Data model

This is the first pass at the SQLite schema (TR-05). One account holds several profiles, which is
how a parent keeps a child's preferences apart (BR-09). Calories are nullable on recipes, which
leaves room for health tracking later without building it now. The last three tables are for the
"Later" features and don't get created until those are built.

```mermaid
erDiagram
    ACCOUNT ||--|{ PROFILE : "has"
    PROFILE ||--o{ DIETARY_NEED : "has"
    PROFILE ||--o{ RATING : "gives"
    RECIPE ||--o{ RATING : "receives"
    RECIPE ||--|{ RECIPE_INGREDIENT : "uses"
    INGREDIENT ||--o{ RECIPE_INGREDIENT : "appears in"
    RECIPE ||--|{ STEP : "has"
    ACCOUNT ||--o{ MEAL_PLAN : "owns"
    MEAL_PLAN ||--|{ PLANNED_MEAL : "contains"
    RECIPE ||--o{ PLANNED_MEAL : "fills"
    MEAL_PLAN ||--|{ DAY_CONTEXT : "plans around"
    MEAL_PLAN ||--|| SHOPPING_LIST : "produces"
    SHOPPING_LIST ||--|{ SHOPPING_ITEM : "contains"
    INGREDIENT ||--o{ SHOPPING_ITEM : "is bought as"
    ACCOUNT ||--o{ RESTAURANT_VISIT : "logs"
    ACCOUNT ||--o{ CONNECTION : "has"
    ACCOUNT ||--o{ STORE_DEAL : "sees"

    ACCOUNT {
        int id PK
        string name
    }
    PROFILE {
        int id PK
        int account_id FK
        string name
        string skill_level "beginner, some, confident"
        string equipment "stove, oven, microwave, air fryer"
    }
    DIETARY_NEED {
        int id PK
        int profile_id FK
        string kind "allergy, restriction, dislike, preference"
        string value
    }
    RECIPE {
        int id PK
        string title
        int servings
        int total_minutes
        string source "manual, link, screenshot, gemma"
        string source_url
        int calories "nullable, for later"
        string notes
    }
    STEP {
        int id PK
        int recipe_id FK
        int position
        string instruction
        string technique_note "plain-words explanation"
        int timer_seconds "nullable"
    }
    INGREDIENT {
        int id PK
        string name
    }
    RECIPE_INGREDIENT {
        int recipe_id FK
        int ingredient_id FK
        float amount
        string unit
    }
    RATING {
        int profile_id FK
        int recipe_id FK
        int stars
        string comment
    }
    MEAL_PLAN {
        int id PK
        int account_id FK
        date week_start
        float budget
    }
    DAY_CONTEXT {
        int meal_plan_id FK
        date day
        string kind "normal, busy, out, gathering"
        bool has_kitchen
    }
    PLANNED_MEAL {
        int id PK
        int meal_plan_id FK
        int recipe_id FK
        date day
        string slot "breakfast, lunch, dinner, bring a dish"
        string mode "home, on the go, prep ahead"
    }
    SHOPPING_LIST {
        int id PK
        int meal_plan_id FK
        float estimated_total
    }
    SHOPPING_ITEM {
        int id PK
        int shopping_list_id FK
        int ingredient_id FK
        float amount
        string unit
        bool checked
    }
    RESTAURANT_VISIT {
        int id PK
        int account_id FK
        date visited_at
        string place_name
        string ordered
        int stars
    }
    CONNECTION {
        int account_id FK
        string other_account "for later, needs a backend"
    }
    STORE_DEAL {
        int id PK
        string store
        string item
        float price
        bool sample "true until real grocer data exists"
    }
```

## Planning a week

This is the main flow for the demo (BR-01, BR-04, BR-06). The planner checks Gemma's plan before
saving it, because a model can still suggest peanuts to a profile with a peanut allergy (TR-03).

```mermaid
sequenceDiagram
    actor U as User
    participant V as WeekView
    participant S as PlanStore
    participant C as CalendarReader
    participant P as Planner
    participant G as GemmaClient
    participant API as Gemini API
    participant DB as SQLite
    U->>V: Tap Plan my week
    V->>S: generateWeek()
    S->>C: events for the next 7 days
    C-->>S: day contexts (busy, out, gathering)
    S->>P: profiles, needs, budget, day contexts, past ratings
    P->>G: plan prompt with the JSON schema
    G->>API: POST generateContent
    API-->>G: meal plan as JSON
    G-->>P: decoded MealPlan
    P->>P: check allergies, budget and day limits
    alt the plan fails a check
        P->>G: retry once with the errors
        G-->>P: corrected MealPlan
    end
    P-->>S: MealPlan and ShoppingList
    S->>DB: save
    S-->>V: show the week
```

## Cooking a recipe

Cook mode is where the teaching happens (BR-02). Each step shows its technique in plain words, and
the user can ask about a step by voice or text.

```mermaid
sequenceDiagram
    actor U as User
    participant K as CookView
    participant G as GemmaClient
    participant N as Notifier
    U->>K: Start cooking
    loop each step
        K-->>U: step, technique note and timer
        opt the user asks about the step
            U->>K: question by voice or text
            K->>G: the step plus the question
            G-->>K: an answer a beginner can follow
        end
        opt the step has a timer
            K->>N: schedule a local notification
        end
    end
    U->>K: Done
    K-->>U: ask each profile for a rating
```

## Importing a recipe

A link goes through the page's own schema.org recipe data first, since many recipe sites publish
it and reading it costs no Gemma call. A screenshot goes to Gemma as an image, which is the
multimodal part of the Gemma entry (BR-05).

```mermaid
sequenceDiagram
    actor U as User
    participant I as ImportView
    participant R as RecipeImporter
    participant G as GemmaClient
    U->>I: pick a screenshot or paste a link
    alt link
        I->>R: the URL
        R->>R: fetch the page and read its JSON-LD recipe
        opt the page has no recipe data
            R->>G: the page text and the recipe schema
            G-->>R: recipe as JSON
        end
    else screenshot
        I->>R: the image
        R->>G: the image and the recipe schema
        G-->>R: recipe as JSON
    end
    R-->>I: a draft recipe
    U->>I: fix anything wrong, then save
```

## Screens

The app is one main screen built like a Tamagotchi. The chef character lives in the top third,
and the subtitle bar under him is the prompt box. He answers out loud, and the same words show in
the subtitle bar. While Gemma works, he does a cooking animation. The bottom two thirds hold the
recipes and whatever he produced. A round chat bubble in the bottom right opens a text screen with
the full conversation. The menu in the top left is a literal burger, and tapping it fans the layers
out, with each ingredient being one menu option. The Figma frames replace this sketch when they
land.

```text
+--------------------------------------+
| [burger]                             |  menu, top left
|                                      |
|            chef character            |  top third: the chef, cooking
|                                      |  while Gemma works
|  +--------------------------------+  |
|  | Ask the chef              [mic] |  |  subtitle bar: the prompt box,
|  +--------------------------------+  |  which also shows his replies
+--------------------------------------+
|                                      |
|  recipe cards, the week's plan,      |  bottom two thirds: recipes
|  or the current cooking step         |  and output
|                                      |
|                                      |
|                                 (o)  |  chat bubble, bottom right
+--------------------------------------+
```

The burger's layers need names from the design side. This mapping is a placeholder for the code
until then.

| Layer | Opens |
| --- | --- |
| Top bun | This week's plan |
| Lettuce | Recipes |
| Tomato | Shopping list |
| Cheese | Household profiles |
| Patty | Import a recipe |
| Bottom bun | Settings |

The chef's moods drive his animation, and each one maps to a moment in the app.

```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Listening : the user taps the mic or types
    Listening --> Cooking : prompt sent to Gemma
    Cooking --> Talking : Gemma replied
    Cooking --> Confused : the call failed or timed out
    Talking --> Idle : finished speaking
    Confused --> Idle : the user retries or moves on
```

```mermaid
flowchart LR
    main["Main screen<br/>chef on top, output below"]
    main --> burger["Burger menu"]
    burger --> week["This week"]
    burger --> recipes["Recipes"]
    burger --> shopping["Shopping list"]
    burger --> household["Household"]
    burger --> importScreen["Import a recipe"]
    burger --> settings["Settings"]
    main --> chat["Chat screen<br/>full text conversation"]
    recipes --> cook["Cook mode"]
    week --> cook
```

## What leaves the phone

Everything else stays in the SQLite file on the phone (TR-08). How Google treats prompts on the
Gemini API's free tier is unverified, and someone should read the current terms before real users
send data.

| Data | Goes to | When |
| --- | --- | --- |
| Preferences, dietary needs, budget and a summary of past ratings | Gemini API | Planning a week |
| Day labels from the calendar, plus event titles if the user turns that on | Gemini API | Planning a week |
| A recipe screenshot or the text of a recipe page | Gemini API | Importing a recipe |
| One cooking step and the user's question | Gemini API | Asking about a step |
| Calories and macros | Apple Health, on the phone | After the user allows it |
| Location | Nowhere | Never leaves the phone |

## Files

```text
yeschef/
  README.md
  LICENSE                         Apache-2.0
  CLAUDE.md
  docs/
    requirements.md
    architecture.md
  YesChef.xcodeproj/              made on the Mac
  YesChef/                        app target
    YesChefApp.swift
    Features/
      Onboarding/
      Week/
      Recipes/
      Cook/
      Shopping/
      Household/
    Services/                     Apple adapters
      CalendarReader.swift
      HealthWriter.swift
      VisitMonitor.swift
      SpeechInput.swift
      Notifier.swift
    Storage/
      Database.swift
    Resources/
      Assets.xcassets             character art from Figma
    Secrets.xcconfig              gitignored, holds the Gemini key
  YesChefCore/
    Package.swift
    Sources/YesChefCore/
      Models/
      Planning/
      Gemma/
      Import/
    Tests/YesChefCoreTests/
```
