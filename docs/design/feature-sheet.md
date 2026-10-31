# yeschef! feature sheet

Every feature, what the cook does, where it lives and how far along it is. "On main" means the code
is on the `main` branch; I've run the YesChefCore parts on Linux against the live Gemini API, and
the screens have been built by the MacBook but not checked by me on a phone. The BR numbers point
to [requirements.md](../requirements.md).

| Feature | What the cook does | Screens | Gemma 4 call | Status | BR |
| --- | --- | --- | --- | --- | --- |
| Week plan | Taps Plan my week or asks Basil for one | Main screen, This week | `planWeek`: 3 ideas per day, then allergy rules and ranking | On main; live call runs | BR-01 |
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
| Shopping list | Opens the list for the week | Shopping list | none, built from the plan's ingredients | On main | BR-04 |
| Rating and learning | Rates a dinner 1 to 5 stars | Rating sheet, Learning card | none, Thompson sampling on the phone | On main; tested, and the terminal demo shows it learning | BR-03, BR-17 |
| Mute Basil | Turns his voice off | Settings | none | On main (MacBook) | BR-10 |
| Calendar-aware days | Busy, out or bringing a dish | none yet | planned | Planned | BR-06 |
| Budget and health goals | Sets a weekly budget, calories and macros | none yet | planned | Planned | BR-08, BR-16 |
| Store deals and pickup orders | Builds a drive-up list and orders | none yet | planned; grocer APIs unverified | Planned | BR-11, BR-12 |
| Points, streaks and outfits | Earns points and dresses Basil | Basil's wardrobe (Figma only) | none | Designed, not built | BR-18 |
| Restaurant check-ins | Gets asked how a meal out went | none yet | planned | Planned | BR-15 |

## Timing

Live calls on October 31 took about half a second for a one-line reply with thinking off, about 18
seconds to read a recipe photo, and about 37 seconds for a two-day plan, a recipe and a question
together on the Linux laptop. With the cookbooks on, the MacBook timed a three-day plan, a recipe
and a question at under 60 seconds in the simulator. A full seven-day plan wasn't timed, which is
why the demo plans three days while Basil does his cooking animation.
