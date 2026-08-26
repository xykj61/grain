# Skate Returns -- the DAG Rendering Platform GUI

**Stamp:** `20260826.014903`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; Skate's return as the DAG rendering platform GUI, DVUI read MIT 2026-08-26; every seat DJINN's (gate %6) and Keaton's to word
**Kin:** [`20260825-233309_the-bit-design-system-season-opens.md`](20260825-233309_the-bit-design-system-season-opens.md) -- [`../external-research/20260826-014904_bret-victor-the-immediate-connection.md`](../external-research/20260826-014904_bret-victor-the-immediate-connection.md)

## The gate, first

Every seat on this page is a proposal. The design lead is DJINN's (custody gate %6), and
the words that seat anything are Keaton's. The page lays the offering on the table and
stops at the gate, the way the season-opening record asks
(`active-designing/20260825-233309_the-bit-design-system-season-opens.md`).

## The name comes back

Observation. Skate carried the GUI-framework sense from its first seating: a paint target
for Pond agents, text grid to pixel buffer, an aspect of Brushstroke. On `20260823.094410`
the name moved to the social layer, which became **Surf Social** at `surf-social.com`
(source: `context/LEXICON.md`, Surf entry, read 2026-08-26). The elder sense stayed true
beneath, in the Lexicon's own words, and nineteen code files kept their skate identifiers
the whole time.

Proposal. **Skate returns as the platform GUI's own name.** Surf Social keeps the social
layer, its domain, and its outfits concept whole. Surf Social becomes an SLC concept --
a small, lovable, complete application -- implemented *for* Skate and Realidream in
Brushstroke, rather than a name competing for the framework beneath it. One name per
layer, and both names are loved.

## What Skate renders

Skate is the **DAG rendering platform GUI**: the surface that paints Mantra and Weave DAG
state for a person to see and steer. Realidream instantiates Skate as its GUI target and
stays the branded application face; Skate stays the general framework (source:
`context/LEXICON.md`, Realidream entry, read 2026-08-26). The pipeline reads plainly --
state lives in the DAG, Skate draws it, Brushstroke is the drawn surface underneath.

## DVUI, read with its license in hand

Observation, read 2026-08-26. DVUI (`github.com/david-vanderson/dvui`) is an
immediate-mode GUI toolkit for Zig, tested against Zig 0.16.0, with SDL, Web, Raylib,
DirectX 11, OpenGL, and wio backends, theming, animations, touch support, and font
rendering through FreeType or stb_truetype (source: the DVUI README). Its LICENSE file
names the **MIT License** -- "DVUI Copyright (c) David Vanderson and Contributors", with
TinyVG under Felix Queissner's copyright (ss for the German eszett, per the ASCII rule;
source: `raw.githubusercontent.com/david-vanderson/dvui/master/LICENSE`, read 2026-08-26).

Inference. MIT is permissive, so the license allows far more than concept study: reading
code line by line, vendoring, porting with attribution. The discipline here still writes
our own. Skate's return is a **New Gauge Civic TAME reimplementation** -- code under TAME
Guidance (bounds named, invariants asserted, widths explicit), prose in Gauge, rewards
named in Civic Style -- informed by DVUI's immediate-mode shape rather than assembled
from its files. The clean room stays the habit even where the license opens the door.

## The immediate connection -- hot reload with witnesses

Bret Victor's working principle, stated at CUSEC in January 2012 in *Inventing on
Principle* (worrydream.com, read 2026-08-26): a creator needs to see the effect of a
change the moment the change is made. Skate seats that principle as
**live-hot-reloading TAME-driven development**: edit a `.brush` file, the page repaints
within the same breath, and the witness strip repaints beside it. The witnesses are the
Grain turn on Victor's loop -- immediacy alone shows you what happened, and a witness
shows you whether what happened still holds the invariants. See the change, and see the
proof, in one glance. The companion research page sits at
`external-research/` (Bret Victor, immediate connection), and the gratitude note thanks
him by name.

## DJINN's helpers, as concepts

DJINN's public repositories carry no license, so they are read-for-concepts sources at
most (source: `external-research/20260825-235138_djinn-public-repositories-read-against-grain.md`,
read 2026-08-25). Two concepts are worth carrying in:

- **The ASCII module helpers** -- character-grid drawing, density ramps that carry what
  color usually carries, marks that travel as text. Concepts only; every line of Skate's
  character grid is written fresh under TAME.
- **The SCAPE tune-and-export loop** -- press a key, a tuning panel appears over the live
  page, dials move the render in real time, and export writes a config to paste over the
  whole file. This is Victor's create-by-reacting made into a file format habit, and it
  is the loop Skate profiles are shaped for below.

## The sameness macro, single-stranded

Proposal, defined plainly. A **sameness macro** is one macro strand -- exactly one --
that makes same things same across pages. A site declares its shared parts once (the
header, the palette, the animation timing), and every page pulls from that single strand
rather than each page carrying a private copy. Single-stranded means the mechanism
refuses nesting: a macro may reference values, and may never reference another macro.
The bound is the point. The tree's own law already says it -- public sameness compresses
without private macros, one named fold, many callers
(`foundations/20260703-182612_sameness-is-the-macro.md`) -- and the single strand keeps
that law checkable by a witness that counts to one.

## Whole-body page animation, one second, by default

Proposal. A Skate page animates as a whole body on load and on navigation: **1 second**,
default, the whole page arriving as one motion rather than parts popping in. The default
is configurable through the Skate profile, and it falls to zero gracefully for a reader
who prefers a still page. The kinship is DJINN's SCAPE intro-animation component
(concept only, as above); the difference is the body -- SCAPE animates a mounted
component, and a Skate page animates whole. Falsifier: a 1-second default that reads as
delay rather than as arrival on real hardware sends the number back to this page.

## The profile file -- two spellings, one recommendation

A Skate profile holds the tuned values: palette, weave density, animation timing, type
scale. Two patterns are on the table, where the `*-_` slot holds the profile's own name:

| Pattern | What it claims |
|---|---|
| `*-_.skate.brix` | The profile is a composition -- Brix declares, evaluates, can extend a base profile |
| `*-_.skate.kyri` | The profile is a record -- Kyri is parsed, never evaluated, one value per line |

**Recommendation: `*-_.skate.kyri`.** Three reasons. A profile read at render time should
be data that is parsed rather than code that is evaluated -- safety first, and the render
path stays bounded. The SCAPE-style export loop writes plain tuned values, and a Kyri
record round-trips that export byte for byte. And the sameness macro above already covers
composition: the one strand makes pages same, so the profile file can stay flat. When a
profile genuinely needs to compose, a `.skate.brix` file can evaluate *to* the Kyri
record, which keeps both spellings honest -- Brix authors, Kyri ships. This seat, like
every seat here, waits at gate %6.

## skate-ww.com -- Kumara sites in .brush

Observation. The placeholder domain `skate-ww.com` was purchased on Keaton's word,
2026-08-26, and the registry row already reads: placeholder -- Skate Kumara sites
written in `.brush` (source: `construction/domain-registry.bron`, read 2026-08-26; the
elder row `ska7e.com` sits nearby, role unassigned).

Proposal. The domain hosts **Skate Kumara sites**: pages owned by Kumara identities,
speaking **Comlink under the hood** for fetch and update, and **written as `.brush`
files** -- the site is a brush document the platform renders, rather than HTML assembled
by hand. A visitor sees a page; the author edits a `.brush` file and a `.skate.kyri`
profile; the hot-reload loop closes the distance between the two.

## Next motion, and what would send this back

The first constructive step is small: one `.brush` page rendered by a Skate walking
skeleton, its profile in a `.skate.kyri` file, hot reload proven with one witness beside
it. Horizon: the first Skate orbit -- 15 rounds under the panchanga (Keaton's word,
2026-08-26). What would send this page back: DJINN drawing a different direction at gate
%6, which the page is glad to be outdrawn by; a hot-reload loop that cannot hold a witness
green while repainting; or a 1-second whole-body default that reads as sluggishness on
the Daylight DC-1's reflective screen.
