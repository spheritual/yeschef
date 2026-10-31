# yeschef! feature sheet

Every feature, what the cook does, where it lives and how far along it is. "On main" means the code
is on the `main` branch; I've run the YesChefCore parts on Linux against the live Gemini API, and
the screens have been built by the MacBook but not checked by me on a phone. The BR numbers point
to [requirements.md](../requirements.md).

| Feature | What the cook does | Screens | Gemma 4 call | Status | BR |
| --- | --- | --- | --- | --- | --- |
| Week plan | Taps Plan my week or asks Basil for one | Main screen, This week | `planWeek`: one call per day, all at once, 3 ideas each, then allergy rules and ranking | On main; live call runs | BR-01 |
| Cookbook grounding | Sees which classic cookbook a dinner was adapted from | Day cards, Recipe | every prompt carries the best-matching passages from six public-domain Project Gutenberg cookbooks | On main; tested, live calls run with it on, and the MacBook build carries the cookbooks | BR-01, BR-02 |
| Swaps | Picks another dinner for a day | This week | none, the ranked alternatives come with the plan | On main | BR-01 |
| Allergy and dislike rules | Lists what each member must never eat | Household | none, the rules run in code before ranking and after every recipe | On main; tested, including "peanut-free" notes | BR-01 |
| Recipe with teaching notes | Opens a dinner | Recipe, Cook mode | `recipe(for:)`: steps, each with a plain-words technique note | On main; live call runs | BR-02 |
| Cook mode with timers | Goes through one step at a time | Cook mode | none | On main (MacBook) | BR-02 |
| Ask Basil | Asks by voice or text, about the step or anything | Subtitle bar, Chat | `askChef`: a short answer in Basil's voice | On main; live call runs | BR-02, BR-10 |
| Basil speaks and listens | Hears answers out loud; talks to the mic | Main screen, Chat | none, Apple's speech frameworks on the phone | On main (MacBook) | BR-10 |
| Basil's moods | Watches him cook with the pan while Gemma thinks, hop while listening, read from a cookbook when teaching, and watch the wall clock during a timer | Main screen, Cook mode | none | On main since c80627a, not yet built on the Mac | BR-10 |
| Rating reactions | Sees sparkles and a belly rub for 4 or 5 stars, and a spit at the screen for 1 or 2 | Main screen | none | On main since c80627a, not yet built; the spit stays around Basil and doesn't cover the screen yet | BR-22 |
| Weekly check-in | Gets asked on shopping day to plan the coming week | none yet | `planWeek` for the seven days from shopping day | Planned | BR-19 |
| Editable meals and guests | Changes a meal, picks who's eating and adds guests | This week | the allergy rules and models of only those eating | Planned | BR-20 |
| Technique videos | Watches a short video on a technique | Learning page, recipe steps | none | Planned; source licenses unverified | BR-21 |
| Basil walks and the bell | Rings a bell to get Basil's attention and sees him walk his stage | Main screen | none | Planned | BR-22 |
| Photo recipe import | Picks a photo or screenshot of a recipe | Import a recipe | `recipeFromImage`: Gemma reads the image | On main; live call read the team's salmon screen | BR-05 |
| Shopping list | Checks items off, edits and adds lines, and swipes them away, like a notepad | Shopping list | none, built from the plan's ingredients | On main since bd449e1; saved to a file after every change; the list logic is tested, the page not yet built on the Mac | BR-04 |
| Rating and learning | Rates a dinner 1 to 5 stars | Rating sheet, Learning card | none, Thompson sampling on the phone | On main; tested, and the terminal demo shows it learning | BR-03, BR-17 |
| Mute Basil | Turns his voice off | Settings | none | On main (MacBook) | BR-10 |
| Calendar-aware days | Busy, out or bringing a dish | none yet | planned | Planned | BR-06 |
| Health goals and nutrition | Sees each member's goals and a per-serving nutrition estimate on every recipe | Household, Recipe card | goals go into the planning and recipe prompts, and Gemma estimates calories, protein, carbs, fat, fiber and sugar | On main since 941b900; goals come from the sample household and can't be edited yet | BR-16 |
| Budget | Sets a weekly budget | Household (shown only) | the budget goes into the planning prompt | Partly: the sample budget reaches Gemma, nothing checks the total | BR-08 |
| Store deals and pickup orders | Builds a drive-up list and orders | none yet | planned; grocer APIs unverified | Planned | BR-11, BR-12 |
| Leaves, streaks and outfits | Earns leaves for planning, cooking, rating, asking and importing, keeps a daily streak, and spends leaves dressing Basil | Streak chip on Basil's stage, Basil's wardrobe | none | On main since 941b900, saved like the shopping list; the log is tested, the screens not yet built on the Mac | BR-18 |
| Restaurant check-ins | Gets asked how a meal out went | none yet | planned | Planned | BR-15 |

## Timing

Live calls on October 31 took about half a second for a one-line reply with thinking off, about 18
seconds to read a recipe photo, and about 37 seconds for a two-day plan, a recipe and a question
together on the Linux laptop. With the cookbooks on, the MacBook timed a three-day plan, a recipe
and a question at under 60 seconds in the simulator. A full seven-day plan wasn't timed, which is
why the demo plans three days while Basil does his cooking animation.

Gemma's time grows with how much it writes, at about 160 characters a second on every call we
timed. A three-day plan in one call took 30 seconds on the Linux laptop, which is why `planWeek`
now asks for each day in its own call, all at once, and the same plan took 11.8 seconds. A recipe
takes about 20 seconds. The app now starts fetching the recipe for each planned dinner as soon as
the plan arrives, which hides that wait when the cook doesn't tap a dinner right away. Indexing
the cookbooks took about 4 seconds in a debug build, and it now runs off the main thread when the
app starts. The Mac timings for these changes aren't measured yet.
