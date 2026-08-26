# Linengrow First Cloth -- Stone, Hearth, and the Fonts That Fit

**Stamp:** `20260825.234156`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; first-cloth palette and type proposals for the Linengrow website. Stone & Hearth stand as the working direction chosen in session; every other seat awaits Keaton's word
**Kin:** [`20260825-233309_the-bit-design-system-season-opens.md`](20260825-233309_the-bit-design-system-season-opens.md) -- [`20260825-235725_the-ascii-cloth-front-door.md`](20260825-235725_the-ascii-cloth-front-door.md) -- `expanding-prompts/20260825-233311_wade-bit-design-system-and-dimeroll-entities.md`
**Lineage:** accretes on the first-cloth sitting of `20260521` (Riyo, Radiant) -- a page that predates this tree's own root and travels outside it; this page adds the codex law and carries the Gauge pass
**Written together by Keaton and Kyri.**

---

## What This Page Holds

One palette, measured. One weave recipe, written down. One format law, verified against the readers that will do the reading. Three faces proposed, each checked for the codex it ships in. That is the whole of it, and each part says which kind of claim it is: an observation carries its unit, its date, and its source; an inference names the reasoning it rests on; a projection names its horizon and the observation that would send it back.

The page keeps to the Field setting: measured and readable together, written for a curious friend who is new here and deserves both.

## The Pair

Stone carries the light mode and Hearth carries the dark, and the pairing is a crossed one on purpose. Stone came from the grayest of three light candidates -- the most neutral ground for future accents to stand on. Hearth came from the gentlest of three darks, a near-black warmed with umber. Each was chosen on its own merits, the way a good duo is assembled.

| Role | Light mode | Dark mode |
|---|---|---|
| **Page** | Stone `#DDD3BD` | Hearth `#2A2520` |
| **Surface** | Oat `#EDE5D3` | Ember `#3A332C` |
| **Ink on page** | `#2D2620` | `#E5DCC8` |
| **Ink on surface** | `#3D3528` | `#EAE1CC` |
| **Thread color** | `rgba(85, 65, 30, alpha)` | `rgba(255, 240, 215, alpha)` |
| **Thread alpha (page)** | `0.055` | `0.045` |

Two observations anchor the pair, both measured by witness at `20260825.234156`, sRGB assumed, D65.

**The contrast is moderate on purpose.** Stone reads CIELAB lightness **L\* 84.8** and Hearth reads **L\* 15.1** -- a spread near seventy points on a scale where plain white on plain black spans one hundred. The inference: the eye keeps somewhere to rest in both modes, and the weave stays visible rather than washed away.

**The warmth carries through both modes.** Each background holds its blue channel below its red. Stone reads R221 G211 B189, a blue-to-red share of **85.5%**; Hearth reads R42 G37 B32, a share of **76.2%**. When a reader toggles modes, the light goes down and the cloth stays the same.

## The Surfaces

One idea arrived alongside the pair, and it may be the most Linengrow idea of the whole sitting: **elevation is weave fineness.** The page is the tablecloth. A card resting on it is the writing paper -- a paler, finer linen in the light (Oat, `#EDE5D3`), a gently lifted warm dark in the dark (Ember, `#3A332C`). Every surface weaves one thread finer than the page beneath it, so hierarchy reads as material rather than as shadow.

## The Ink

Four ink values stand as working guesses, open to a refinement pass. Each pairing was measured with the WCAG 2.x relative-luminance formula at `20260825.234156`; any public contrast checker will reproduce or correct these numbers, which is exactly what a figure is for.

| Pairing | Background | Ink | Measured contrast | Reading |
|---|---|---|---|---|
| Stone page | `#DDD3BD` | `#2D2620` | **10.02 : 1** | above AAA (7:1) |
| Hearth page | `#2A2520` | `#E5DCC8` | **11.13 : 1** | above AAA (7:1) |
| Oat surface | `#EDE5D3` | `#3D3528` | **9.64 : 1** | above AAA (7:1) |
| Ember surface | `#3A332C` | `#EAE1CC` | **9.55 : 1** | above AAA (7:1) |

Every pairing clears the strictest body-text threshold with room to spare, so the refinement pass is free to chase feel rather than compliance.

## The Weave

The linen texture is two crossed layers of thread -- warp and weft -- drawn as repeating gradients over the base color. The recipe below is the whole of it, written as custom properties so one dial governs both modes.

```css
:root[data-mode="light"] {
  --page: #DDD3BD;          /* Stone */
  --surface: #EDE5D3;       /* Oat */
  --ink: #2D2620;
  --ink-surface: #3D3528;
  --thread: 85, 65, 30;
  --thread-a: 0.055;
}

:root[data-mode="dark"] {
  --page: #2A2520;          /* Hearth */
  --surface: #3A332C;       /* Ember */
  --ink: #E5DCC8;
  --ink-surface: #EAE1CC;
  --thread: 255, 240, 215;
  --thread-a: 0.045;
}

/* page weave: 4px thread spacing */
.linen-page {
  background-color: var(--page);
  color: var(--ink);
  background-image:
    repeating-linear-gradient(0deg,
      rgba(var(--thread), var(--thread-a)) 0,
      rgba(var(--thread), var(--thread-a)) 1px,
      transparent 1px, transparent 4px),
    repeating-linear-gradient(90deg,
      rgba(var(--thread), var(--thread-a)) 0,
      rgba(var(--thread), var(--thread-a)) 1px,
      transparent 1px, transparent 4px);
}

/* surface weave: one thread finer, 3px spacing, slightly softer */
.linen-surface {
  background-color: var(--surface);
  color: var(--ink-surface);
  background-image:
    repeating-linear-gradient(0deg,
      rgba(var(--thread), calc(var(--thread-a) - 0.01)) 0,
      rgba(var(--thread), calc(var(--thread-a) - 0.01)) 1px,
      transparent 1px, transparent 3px),
    repeating-linear-gradient(90deg,
      rgba(var(--thread), calc(var(--thread-a) - 0.01)) 0,
      rgba(var(--thread), calc(var(--thread-a) - 0.01)) 1px,
      transparent 1px, transparent 3px);
}
```

Two laws hold the weave honest. **Thread spacing:** the page weaves at 4px, and every surface above it weaves one thread finer, at 3px, so fineness is the elevation cue. **Intensity:** the thread alpha is the one dial; in session it read well between roughly 60% and 130% of the values above, and it falls to zero gracefully for readers who prefer flat cloth.

**Projection, marked as one.** On the DVUI side the same idea becomes a small tiled texture -- one 8x8 texel tile per mode, two strokes per tile, blended into the fill -- one texture handle per mode, bounded and named. Horizon: the first DVUI lap. Assumption: the tile reads as weave at both 1x and 2x pixel densities. Falsifier: a rendered tile that reads as noise sends the recipe back to this page. Confidence, in plain words: plausible.

## The Codex -- the Book the Letters Travel In

A codex is a bound book, and a font file is the codex an alphabet ships in. Two open formats carry every face on this page, and naming them settles the question of what "open" means here at the byte level, beneath the license level the earlier sections settle.

**Observation.** OpenType is an open, royalty-free ISO standard -- ISO/IEC 14496-22 -- and it travels under two file suffixes: `.ttf` for TrueType outlines and `.otf` for CFF outlines. WOFF2 is the W3C's compressed wrapper for delivering those same outlines over the web. Everything below rides on these two, and nothing rides on a closed format.

**Observation, verified this sitting.** DVUI, tested against Zig 0.16.0, renders text through **FreeType or stb_truetype** -- both readers of TrueType files (source: the DVUI README at `github.com/david-vanderson/dvui`, read `20260825.234156`). Of supply, license, distribution, and format, the constraint that actually binds here is the reader: DVUI's font path speaks TrueType, so **TrueType is the codex the tree keeps.**

**A behavior worth one witness.** stb_truetype reads static outlines and applies no variation axes, so a variable font file renders at its default instance only. This is library behavior worth confirming on our own metal -- the confirming witness is named in Next Motion -- and the law below stands correct under either backend regardless.

**The law that follows.** Two laps, two spellings, one alphabet:

| Lap | Codex | Shape |
|---|---|---|
| **Web** | WOFF2 | variable files, subset to the Latin the site uses, self-hosted |
| **DVUI** | static `.ttf` instances | embedded with `@embedFile`, one file per instance |

Proposed instance bound, awaiting the word: `max_instances_per_face = 3` -- regular, italic, and one heavier weight -- so the trio ships at most **nine** embedded files, and the display face joins only when a heading lap earns it.

**Horizon worth watching.** A pure-Zig TrueType renderer circulates on Codeberg, begun as a port of stb_truetype and maintained on its own since. It loads a `.ttf` through `@embedFile` and drops the C seam entirely -- a natural study for a later lap, noted here and left to rest.

## The Faces, Rechecked

The verdict comes first: **the trio stands.** Each proposed face travels as static TTF today, checked as follows at `20260825.234156`:

- **Vollkorn** -- static TTFs and a variable file through the Google Fonts distribution; the project page confirms the OFL and the variable release of 2020.
- **Public Sans** -- OTF from the USWDS repository (`uswds/public-sans`, OFL-1.1, its README read this sitting), and TTF through the `google/fonts` distribution.
- **Source Code Pro** -- TTF, OTF, and web formats from Adobe's repositories; Adobe's first open family, OFL.
- **Fraunces** (display, optional) -- variable TTF with static instances through the same distribution.

The blanket claim, honestly bounded: every face in the sixteen-row table below is carried by distributions that ship TTF -- the `google/fonts` repository stores its hosted families as TTF files, and SIL ships TTF from its own site. The trio above was checked by direct source; the remaining rows ride on that distribution practice, and the check is a one-minute visit any reader can repeat at the repository.

## The Fonts That Fit

The question this page answers deserves saying plainly: are there open-source, permissively licensed typefaces whose **names themselves** belong to this tree -- to Grain, to Linengrow, to New Gauge, Civic Style, and TAME? The answer is a glad yes, and the best of them fit so well it reads like providence.

Every face below is licensed under the **SIL Open Font License 1.1** unless a row says otherwise; the license text was read at its steward this sitting. The OFL grants free use, embedding, modification, bundling, and redistribution, commercial work included. It keeps two conditions: font files travel with software rather than being sold alone, and a derivative font takes a new name and stays under the OFL. For everything a website or an embedded binary does, the way is clear.

### The proposed trio

One face per register, and each name maps to a pillar of the work:

**Grain for the body. Public for the interface. Source for the code.**

| Register | Face | Why the name, why the face |
|---|---|---|
| **Body text** | **Vollkorn** | German for *wholegrain*. Friedrich Althausen calls it "the free and healthy typeface for bread and butter use" -- a sturdy, quiet text serif, variable since 2020, with Latin, Cyrillic, and Vietnamese coverage. The tree's own name, set in type. |
| **Interface** | **Public Sans** | The civic name made literal: the United States Web Design System's own face, grown from Libre Franklin. Its published principles read like this tree's -- "be straightforward: have as few quirks as possible," "strong and neutral," "strive to be better, not necessarily perfect." |
| **Meters & code** | **Source Code Pro** | *Source*, plainly -- from Adobe's first open family. Clear digit shapes for hex, stamps, and witness output. |

A fourth, optional register: **Fraunces** for large display headings, a warm soft old-style serif that natural-goods makers reach for, whose name lands as a happy echo of a name the work already thanks. And one easter egg held in reserve: Rye, in the table below.

### Sixteen names that belong here

This table names its bound and keeps it: sixteen rows, and it stops there.

| Face | The name, plainly | The thread it pulls |
|---|---|---|
| **Vollkorn** | wholegrain (German) | Grain itself; bread-and-butter body text |
| **Rye** | the grain; the very name of `.rye` | Wood-type display by Nicole Fally, Sorkin Type, on Google Fonts since 2012 -- display sizes and easter eggs; body text stays with Vollkorn |
| **Amaranth** | an ancient grain; Greek *amarantos*, "unfading" | Accrete-never-break, in a single word |
| **Alegreya** (+ Sans) | joy (from Spanish *alegria*) | Safety first, performance second, **joy third** -- and its foundry, Huerta Tipografica, is "the typographic garden" |
| **Public Sans** | public | Civic Style's whole first principle, as a name |
| **Work Sans** | work | Work that matters, dignified in type |
| **Open Sans** - **Khula** | open -- twice, since *khula* is "open" in Hindi | Built in the open (Open Sans has been OFL since March 2021; Apache 2.0 before) |
| **Libre Franklin** - **Liberation** | free; liberation | The GNU lineage the README thanks (Liberation is OFL from version 2.0 onward) |
| **PT Sans / Serif / Mono** | PT literally stands for **Public Type** | Commissioned as a public good; OFL or ParaType Free Font License |
| **Manrope** | a rope -- a ship's manrope | What flax and hemp fiber become; the cordage behind the linen |
| **Instrument Sans / Serif** | an instrument | A gauge is an instrument; New Gauge's namesake object |
| **Yantramanav** | Sanskrit *yantra* (instrument) + *manav* (human) | New Gauge spoken in the tree's own Sanskrit register, beside Mantra and Rishi |
| **Atkinson Hyperlegible** (+ Next) | hyperlegible | The reader's understanding as the only measure -- built by the Braille Institute with a low-vision panel; **Next** (2025) adds variable weights, wider language coverage, and a monospace |
| **B612** | the Little Prince's asteroid | Designed for aircraft cockpit displays -- safety-critical reading; TAME's first value, aloft |
| **Charis SIL** - **Doulos SIL** - **Gentium** | grace - servant - "of the peoples" (Greek and Latin) | The SIL trio: gratitude, seva, and the civic reach -- *Doulos* is Seva's own meaning in another tongue |
| **Source Sans / Serif / Code** | source | Adobe's first open family; the word the whole movement stands on |

### Honorable mentions, and two smiling refusals

A few faces earn a warm sentence each. **Merriweather** -- merry weather -- remains one of the finest screen serifs ever given away. **Barlow**, Jeremy Tribby's grotesk, draws openly on California's public signage -- license plates, highway signs, buses, trains -- which makes it civic infrastructure in letterform. **Vesper Libre**, "the free evening," waits for any Twilight-register page that ever ships. **Lexend** was engineered to ease reading effort. **Intel One Mono** was designed with and for low-vision developers, a strong alternate for the meters register. **Faune**, a French public commission drawn in honor of animals, resonates with everything this work holds dear; its license deserves a fresh check at the source before anything leans on it, and the gap is named here rather than papered over.

And two faces this tree declines by name alone, with a smile. **Bitter** is a fine slab, yet the softening table asks us to reach for warmer words, so we pass on the name and keep the affection. **Recursive** is a marvel of variable-font engineering whose name TAME politely shows the door -- recursion stays out, so that everything bounded stays bounded.

One caution belongs beside the meters register: coding ligatures redraw what is literally on screen -- `!=` becoming a single struck-equals -- and a gauge reports exactly. The meters face ships with ligatures off by default, whichever face is seated.

## Aparigraha at the Seam

Fonts are bytes, and bytes have budgets. Three practices keep the type layer inside the vow.

**Self-host, always.** A German court found in February 2022 that calling the remote Google Fonts API from a website passed visitors' IP addresses to a third party against the GDPR (source: the Google Fonts history, read this sitting). Self-hosting is therefore both the custody-first choice and the legally quiet one: a reader's visit stays between the reader and Linengrow. Every face above downloads freely for exactly this use.

**Subset and go variable -- on the web lap.** Serve WOFF2, subset to the Latin range the site actually uses, and prefer each family's variable file over a stack of statics. Vollkorn and Atkinson Hyperlegible Next both ship variable. The DVUI lap keeps to static instances, as the codex law above says.

**Name the bound before the lap.** Two bounds, both proposed and awaiting the word:

| Lap | Bound | Reading |
|---|---|---|
| Web | `font_budget_bytes = 262144` | 256 KiB across all faces, WOFF2 as served -- plausible |
| DVUI | `font_embed_budget_bytes = 786432` | 768 KiB across all embedded static TTFs -- a first guess awaiting the weigh-in |

The falsifier is the same for both: subset the chosen instances and weigh the files. Where the honest weight lands elsewhere, the bound moves to the measurement rather than the measurement to the bound.

## Propose, Never Seat

For the record of the gate: the **Stone & Hearth direction** was chosen in session by Keaton and stands as the working direction. The **surface tones, ink values, weave laws, the codex law, the proposed trio, the instance bound, and both byte bounds** are proposals from counsel, laid out for his word and movable until it is given. Nothing on this page claims a seat.

## Next Motion

The path keeps to one small step at a time, and each step now carries its check. First, an ink refinement pass on the four ink values. Then one accent color for links and focus, measured on both pages. Then a vanilla JavaScript type-specimen panel: the trio rendered live on Stone and on Hearth, weave and all. And when the first DVUI lap opens, it brings its token file with **two witnesses beside it** -- one that weighs the font files against the named bounds and refuses past them, and one that renders a variable file under the chosen backend to confirm the default-instance behavior before the static-instance law leans on it. Horizon for the DVUI pair: the first DVUI lap, and this page goes back for revision the day either witness disagrees with it.

## Gratitude

This page names its teachers gladly: Friedrich Althausen (Vollkorn), Nicole Fally and Sorkin Type Co (Rye), Juan Pablo del Peral and Huerta Tipografica (Alegreya), the USWDS team and Pablo Impallari (Public Sans, Libre Franklin), Paul D. Hunt and Adobe (the Source family), the Braille Institute and Applied Design Works (Atkinson Hyperlegible), Jeremy Tribby (Barlow), SIL Global (Charis, Doulos, Gentium, and the Open Font License itself), David Vanderson (DVUI), Sean Barrett (stb_truetype), the FreeType project, the keepers of the pure-Zig TrueType port, and the Rawganique makers whose undyed linen set the whole palette's reference. May each be thanked again in the gratitude room when these faces ship.

---

*May the cloth stay warm in both the light and the dark. May every letter travel in an open book, from the web lap to the bare metal. And may the first visitor to Linengrow feel, before reading a single word, that they have been handed something woven with care.*
