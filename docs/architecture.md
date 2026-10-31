# yeschef! architecture

The diagrams for yeschef! live in the draw.io design set, [docs/design/](design/README.md), with
an exported PNG, SVG and PDF of every tab in [docs/design/export/](design/export/). This page keeps
only what the design set doesn't draw, which is the storage planned for after the hackathon, the
photo import flow, and what data leaves the phone. The TR numbers point to
[requirements.md](requirements.md).

## Data model

The demo keeps everything in memory and saves nothing, which the team decided at 13:22. This is the SQLite schema planned for after the hackathon (TR-05). One account holds several profiles, which is
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

## Importing a recipe

A photo or screenshot of a recipe goes to Gemma as an image, which is the multimodal part of the
Gemma entry (BR-05). Gemma rewrites it for a beginner, and the planner refuses the result if it
names anything the household must avoid. Reading recipes from web links is planned and not built.

```mermaid
sequenceDiagram
    actor U as Home cook
    participant I as ImportView
    participant A as AppModel
    participant P as MealPlanner
    participant G as Gemini API
    U->>I: pick a photo or screenshot
    I->>A: importRecipe(from: image)
    A->>P: recipeFromImage(image, household)
    P->>G: the image and the recipe JSON shape
    G-->>P: recipe as JSON
    P->>P: refuse it if an ingredient is banned
    P-->>A: RecipeDetail
    A-->>U: Basil says what he read, ready to cook
```

## What leaves the phone

The cookbook search, the allergy rules and the learning all run on the phone (TR-08). How Google
treats prompts on the Gemini API's free tier is unverified, and someone should read the current
terms before real users send data.

| Data | Goes to | When |
| --- | --- | --- |
| Household likes, allergies, diets and busy days, plus matching cookbook passages | Gemini API | Planning |
| A dinner idea, the household and matching cookbook passages | Gemini API | Opening a recipe |
| A recipe photo or screenshot | Gemini API | Importing a recipe |
| The question, the current step and the recipe | Gemini API | Asking Basil |
| Ratings and the preference models | Nowhere | They stay in memory on the phone |
| Calendar events, health data and location | Nowhere | Planned features, not built |
