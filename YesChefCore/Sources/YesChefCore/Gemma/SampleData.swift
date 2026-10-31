// Fixed data for SwiftUI previews and for the demo when the network drops.
public enum SampleData {
    public static let household = Household(members: [
        .init(name: "Alex", likes: ["tacos", "pasta"], avoid: ["peanut"], goals: ["under 650 calories a dinner", "less sugar"]),
        .init(name: "Sam", cookingSkill: "some experience", likes: ["spicy food"], diet: "vegetarian on Mondays", goals: ["high protein"]),
    ], weeklyBudget: 90)

    public static let fajitas = DinnerIdea(
        title: "Sheet-pan chicken fajitas",
        summary: "One pan, 25 minutes, and everyone builds their own.",
        features: RecipeFeatures(protein: .chicken, flavours: [.spicy, .savory], minutes: 25, difficulty: .easy, costPerServing: 3.5),
        ingredients: ["chicken thighs", "bell peppers", "onion", "tortillas", "lime"])

    public static let salmon = DinnerIdea(
        title: "Lemon and herb salmon",
        summary: "A fresh tray bake with potatoes and broccoli.",
        features: RecipeFeatures(protein: .fish, flavours: [.fresh, .savory], minutes: 30, difficulty: .easy, costPerServing: 6),
        ingredients: ["salmon fillets", "baby potatoes", "broccoli", "lemon", "dill"])

    public static let pasta = DinnerIdea(
        title: "Creamy tomato pasta",
        summary: "A pantry dinner that's ready while the pasta boils.",
        features: RecipeFeatures(protein: .vegetarian, flavours: [.savory], minutes: 20, difficulty: .easy, costPerServing: 2),
        ingredients: ["penne", "canned tomatoes", "garlic", "cream", "parmesan"])

    public static let weekPlan = WeekPlan(days: [
        .init(day: "Monday", isBusy: false, pick: pasta, alternatives: [salmon]),
        .init(day: "Tuesday", isBusy: false, pick: salmon, alternatives: [fajitas]),
        .init(day: "Wednesday", isBusy: true, pick: fajitas, alternatives: [pasta]),
    ])

    public static let recipe = RecipeDetail(
        title: "Sheet-pan chicken fajitas",
        servings: 4,
        minutes: 25,
        ingredients: [
            .init(name: "chicken thighs", amount: "1.5", unit: "lb"),
            .init(name: "bell peppers", amount: "3", unit: ""),
            .init(name: "onion", amount: "1", unit: ""),
            .init(name: "fajita seasoning", amount: "2", unit: "tbsp"),
            .init(name: "tortillas", amount: "8", unit: ""),
            .init(name: "lime", amount: "1", unit: ""),
        ],
        steps: [
            .init(instruction: "Heat the oven to 425F and line a sheet pan with foil.", technique: "A hot oven browns the edges instead of steaming everything.", timerSeconds: nil),
            .init(instruction: "Slice the peppers and onion into thin strips.", technique: "Strips the same width cook at the same speed.", timerSeconds: nil),
            .init(instruction: "Cut the chicken into strips and toss everything with the seasoning and a little oil.", technique: "Oil carries the spices onto every piece and helps it brown.", timerSeconds: nil),
            .init(instruction: "Spread it out in one layer and roast.", technique: "Crowded pieces steam; space lets them char.", timerSeconds: 1200),
            .init(instruction: "Squeeze the lime over the pan and serve in warm tortillas.", technique: "Acid at the end wakes up the flavours.", timerSeconds: nil),
        ],
        nutrition: Nutrition(calories: 540, protein: 38, carbs: 48, fat: 20, fiber: 6, sugar: 7))
}
