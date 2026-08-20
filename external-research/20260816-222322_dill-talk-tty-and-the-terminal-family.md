# Dill, Talk, and the Terminal Family -- a Tablecloth study of command-line chat and TTY, clean-room

*A design-research study, with gratitude, of the elder command-line world we want to reimplement in our own bounded, asserted way: Urbit's Dill terminal vane and its Talk chat app, the ncurses tradition beneath them, and the modern terminal libraries (Ghostty and its libghostty). It names our own terminal module (Dexter) and the chat app (Scooter), and captures the wider decision wave this session raised. Voice: Kyri - Style: Radiant - ASCII only. Clean-room: concepts honored, no code copied.*

**Stamp:** `20260816.222322` - **Status:** Research for understanding -- Living design-research
**Gratitude:** [`../gratitude/Urbit.md`](../gratitude/Urbit.md) (Dill, Talk, Gall) - Ghostty and libghostty (Mitchell Hashimoto) - the ncurses tradition (Free Software Foundation)
**Kin:** [`../context/specs/20260709-225343_thin-view-dexter-exception.md`](../context/specs/20260709-225343_thin-view-dexter-exception.md) (Dexter, the drawn-terminal frame) - [`../active-designing/20260816-205859_double-seat-expansion-eight-seasons.md`](../active-designing/20260816-205859_double-seat-expansion-eight-seasons.md) (the itinerary) - [`../foundations/20260810-011514_pond-the-application-module.md`](../foundations/20260810-011514_pond-the-application-module.md) (Pond, where these apps run)

---

## What we are studying, and why

Before around 2019, Urbit shipped a small command-line chat that a lot of people quietly loved: **Talk** (later `:chat`), a permissioned peer-to-peer messenger you drove from a terminal prompt. Ships hosted channels; you joined by a Hoon-term channel name; messages, journals, and inboxes flowed between ships directly, with no central server. Beneath it sat **Dill**, Urbit's terminal vane -- the piece that owned the TTY, the line editor, and the drawn frame -- and **Gall**, which hosted the long-running agents the app was built from.

We want that experience back, in our own tree, built our own way: bounded, asserted, explicit-width, witnessed on metal. This study reads the elder world with thanks so our reimplementation is informed, and names nothing we would copy.

## The approved research fetch (clean-room)

An Acme Corporation employee picking this up may **fetch the elder source for study**: `xykj61/arvo` (a pre-2019 snapshot) or `urbit/arvo`, read specifically for the **Talk / Dill / Gall** shape -- how a channel is named, how a journal and an inbox differ, how permissioning gates a join, how Dill draws a line. Urbit is permissive (MIT), so studying it freely is sound; the clean-room boundary still holds -- understanding crosses into `active-designing/`, code never does. The fetch itself is a plain `git clone` of a public repository for reading, not a dependency and not vendored into our build.

## The three elders, and what each teaches

- **Dill (Urbit's terminal vane)** -- teaches the *shape of owning a TTY*: one vane holds the terminal, mediates keystrokes and draws, and exposes a clean event stream to the apps above. Our lesson: a terminal module should be one bounded owner of the drawn frame, not a capability every app reinvents.
- **ncurses** -- teaches the *portable drawn grid*: cells, cursors, windows, and refresh over a capability database, so one program draws the same on many terminals. Our lesson: a bounded cell grid with an explicit refresh model, sized by named maxima, is the right floor -- and it pairs naturally with our open image module's bounded RGBA grid.
- **Ghostty and libghostty (Mitchell Hashimoto)** -- teaches the *modern reusable terminal core*: a fast, correct terminal emulator whose engine is offered as a library so other surfaces can embed it. Our lesson: build the terminal as a library first (a core others compose), not as one welded application -- exactly how Dexter should relate to Pond, Skate, and a CLI app.

## Our reimplementation, named

- **Dexter -- the terminal module.** Already seated as our drawn-terminal frame (the thin-view aspect, `context/specs/20260709-225343`), Dexter is our Dill parallel: the bounded owner of the TTY and the drawn cell grid, offered as a library the way libghostty is. Affirmed, kept.
- **Scooter -- the CLI chat app (seated `20260816` on Keaton's word).** The Talk reimplementation: permissioned peer-to-peer command-line chat with channels, journals, and inboxes, each conversation hosted by a ship under a plain channel name, run over Comlink and **on Pond** like every Grain app. Named **Scooter** -- a quick, light way to get to your people from the prompt. Collision-free.
- **The TTY library family** rides beneath both: a bounded cell grid, a line editor, a capability-lean draw model, all TAME-guided, gratitude-fetching the elders above for study only.

## Where this lands on the itinerary

This is a natural **double-seat beside Season G (Open Media Primitives)** and Season A's Photos/Skate surface -- the terminal is the *text* media primitive as QOI is the image one and the audio wire is the sound one. It shares Season G's spirit: open, bounded, ours. It does not disturb the fixed road; it doubles it.

## The wider decision wave, captured

This session also raised several threads recorded here so none is lost:

- **Dimeroll over Dimeroll** stays seated: `dimeroll.com` is the born name, Dimeroll the fossil (147 living references await a cairn-first molt/debride, Season B). Remembered in the operator card's breach queue.
- **The Quin inference vane is renamed Lumen** (seated `20260816` on Keaton's word). The host gathers Lattice, Lantern, Ember, and Scribble -- two of them light-givers -- and a lumen is the SI measure of luminous flux, so the name means the illumination the inference gives. The rename of everything referencing Quin's *vane* hat is a breach molt (cairn-first), scheduled in the docs season beside the Quin-to-Kyri voice molt.
- **The rota** gains the foundations you named -- *sameness is the macro*, *single-stranded*, *the language of the system* (growing a language), and the *happy zone* -- by dropping the three living pins already read every lap and unifying the two style guides, holding at d27.
- **A folder-organizing molt** is scheduled: sort `active-designing/` and `external-research/`, move the spent to `archive/` or `yonder/`, and refresh still-living writings at fresh stamps with current metadata and repointed references -- a docs-season ratchet, not a mid-session sweep.

## Why the study exists

The best command-line chat many people ever used was small, owned, and gone. We can build its spirit again -- bounded, proven, and ours -- if we read the elders with thanks first. This page is that reading, and the map from it to Dexter, Scooter, and the terminal family we will grow on Pond.
