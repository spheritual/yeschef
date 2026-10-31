# yeschef! design set

This folder is the software design for yeschef!, drawn to match the code on `main`. The diagrams
live in one draw.io file, [yeschef.drawio](yeschef.drawio), with a tab for each view. Open it at
<https://app.diagrams.net> (File, then Open from, then Device) or in VS Code with the Draw.io
Integration extension. [build_diagrams.py](build_diagrams.py) generates that file from plain
Python with no dependencies, which means a design change gets made in the script and the file is
rebuilt, instead of being hand-edited. The [feature sheet](feature-sheet.md) lists every feature
with its screens, its Gemma call and its status.

## The tabs

| Tab | Diagram | What it answers |
| --- | --- | --- |
| 1 | System context | Who and what the app talks to, now and later |
| 2 | Components | How the app target and YesChefCore split the work, and that screens reach Gemma only through AppModel |
| 3 | Use cases | What a home cook can do, and which of those call Gemma 4 |
| 4 | Class diagram, YesChefCore | The planner, the Gemma client and the learning types, with their fields and methods |
| 5 | Class diagram, app | AppModel and the screens that read it |
| 6 | Sequence, plan my week | Every call between tapping Plan my week and seeing the plan, including the retry |
| 7 | Sequence, cook, ask, rate | Opening a recipe, a voice question to Basil, and the rating that updates the model |
| 8 | State machine | Basil's five moods and what moves him between them |
| 9 | Activity diagram | The feedback learning loop, with the allergy rules ahead of the model |
| 10 | Deployment | Where each piece runs and where the Gemini key lives |
| 11 | Navigation map | Every screen and how the cook reaches it |
| 12 | Wireframes | Low-fidelity layouts of the main screen, the open burger menu, cook mode, chat and import |
| 13 | File structure | What each folder in the repo holds |

The finished visual design is in [design/](../../design/README.md), which holds Figma renders of
all 14 screens, Basil's SVGs, the color and type tokens, and the code Figma generates for each
screen.
The requirements are in [requirements.md](../requirements.md), and Mermaid versions of the main
flows render on GitHub in [architecture.md](../architecture.md).

## What a full design set covers

IEEE 1016-2009, the IEEE standard for software design descriptions, organizes a design into
viewpoints, each answering one kind of question about the system
([standard](https://cengproject.cankaya.edu.tr/wp-content/uploads/sites/10/2017/12/SDD-ieee-1016-2009.pdf),
[summary](https://en.wikipedia.org/wiki/Software_design_description)). The table maps its
viewpoints onto this set, which shows what's covered and what's still open.

| Viewpoint | Where it's covered |
| --- | --- |
| Context | Tab 1 |
| Composition | Tab 2, tab 13 |
| Logical | Tabs 4 and 5 |
| Dependency | Tab 2 (who calls whom), tab 4 (uses arrows) |
| Information | Tab 4, and the data model in architecture.md for the planned SQLite storage |
| Patterns use | Tab 2: one shared observable model, a protocol in front of the network |
| Interface | Tab 4 method signatures, and the Swift interface in .plans/feedback-learning-spec.md |
| Structure | Tabs 4 and 5 |
| Interaction | Tabs 6 and 7 |
| State dynamics | Tab 8 |
| Algorithm | Tab 9, and the math in .plans/feedback-learning-spec.md |
| Resource | Tab 10, plus the measured Gemma latency in the feature sheet |

A user-centered design adds pieces the standard doesn't name. Wireframes (tab 12) settle layout
before color, the Figma screens settle the look, the navigation map (tab 11) is the app's site
map, and the feature sheet ties each feature to its screens. Three are still missing, and each is
a short job after the hackathon. Personas would describe the two or three kinds of cook the app is
for. A user journey would follow one of them through a week, from planning to the rating. A
clickable prototype would wire the Figma frames together with Figma's prototype links.
