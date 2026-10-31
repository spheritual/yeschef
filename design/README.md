# Design

This folder holds the app's design, exported from the team's Figma file
(<https://www.figma.com/design/2avhsCApicqhfoXXjHm6KB/Untitled?node-id=1-2>) on October 31, 2026.
Figma stays the source of truth, and these files are a copy anyone can open without a Figma seat.

## What's here

- `screens/`: a PNG of every Figma frame at its natural 402-point width. The numbers follow the
  order a user meets them, and 12 to 14 are the proposal frames for the Tamagotchi-style main
  screen, the open burger menu and Basil cooking while Gemma works.
- `assets/`: Basil and his four wardrobe outfits (everyday apron, Sunday baker, tomato club and
  golden hour) as SVGs, plus the burger menu button. These are vectors, which means they scale to
  any size without blurring, and Xcode can take them straight into an asset catalog.
- `tokens.json`: the colors, type sizes and corner radii the screens use, each with a role name.
  The headings use Fraunces and the body text uses Inter. Both are open-source fonts under the SIL
  Open Font License, and the app has to bundle them to match the screens.
- `code/`: the code Figma generates for each screen, one folder per screen. Figma returns it as
  React with Tailwind classes even when asked for SwiftUI, which makes it a layout reference for
  building the SwiftUI views and nothing the app compiles. Each folder's `assets/` holds the icons
  and photos that screen uses. The photos keep the .png names Figma gave them, but they're JPEG
  inside.

## Refreshing it

Any Claude Code session in this repo has Figma's MCP server through `.mcp.json` (see `CLAUDE.md`).
`get_screenshot` re-renders a screen, `download_assets` exports a node as SVG or PNG, and
`get_design_context` regenerates a screen's code. The node IDs are in the table below.

| File | Figma frame | Node |
| --- | --- | --- |
| 01-welcome | Welcome to Yeschef | 4:1235 |
| 02-home | Your kitchen home | 4:1110 |
| 03-meal-planner | Weekly meal planner | 4:943 |
| 04-shopping-list | Weekly shopping list | 4:769 |
| 05-recipe-library | Recipe library | 4:648 |
| 06-salmon-recipe | Lemon and herb salmon recipe | 4:517 |
| 07-family-preferences | Family and preferences | 4:358 |
| 08-chat | Chat with Basil | 4:244 |
| 09-wardrobe | Basil's wardrobe and outfit shop | 4:2 |
| 10-learning-library | Learning library | 19:838 |
| 11-salmon-lesson | Pan-searing salmon lesson | 19:977 |
| 12-proposal-main | Yeschef main screen (proposal) | 9:2 |
| 13-proposal-burger-menu | Yeschef burger menu open (proposal) | 9:82 |
| 14-proposal-loading | Yeschef Basil cooking, loading state (proposal) | 9:183 |
