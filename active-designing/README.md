# The Active-Designing Stack

> **Start here:** [`20260823-201533_the-design-rooms-walking-index.md`](date/20260823/20260823-201533_the-design-rooms-walking-index.md)
> groups thirty-nine of this room's documents by what they are about -- Open Asks, Steward, the SLC
> ladder, Dimeroll, the language, the inference voices, and the singles that hold the rest up -- so a
> reader has somewhere to begin other than a directory listing.
>
> **The room holds 215 flat documents** -- read `20260918.001400` by
> [`../tools/fixtures/r/room_bound_scan.sh`](../tools/fixtures/r/room_bound_scan.sh), which counts
> this room by its own fold rule, and **the room is ENFORCED at 256**, so it stands at 84 percent
> of a ceiling whose crossing forces a fold. The elder reading here said 94 and was measured
> `20260827`; three weeks more than doubled it, which is the thing a census in prose cannot do for
> itself. **Run the scan rather than trusting this line.** So the walking index is a way in
> rather than a census: it carries the thirty-nine a reader most often wants, and the rest are
> found by name. Every one of the 94 folds to `date/YYYYMMDD/` on the same rule, and a stale
> reference to any of them is **resolved** rather than hunted --
> `rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference>`.

**Current product contract:** [`20260912-201126_the-receipt-you-can-read-contract.md`](date/20260912/20260912-201126_the-receipt-you-can-read-contract.md) fixes one synthetic receipt, its four public types, module residences, eight acceptance cases, and the falsifier that keeps Linengrow and Dimeroll distinct.


**Language:** EN
**Last updated:** 2026-09-07 (`20260907.015907` -- the room at the door named: a brief here carries its two-rooms token in its Status line, where this door had stayed quiet while supplying 31 of the doorway's 44 unnamed pages; elder refresh `20260827.173952`, coverage stated honestly against a 94-document room)
**Molted:** `20260827.173952` -- in place, under checkpoint `3a606a8ac9`
**Kin:** [`../.claude/rules/design-rooms.md`](../.claude/rules/design-rooms.md) (which shelf a piece belongs on) - [`../active-development/README.md`](../active-development/README.md) (its sibling room) - `../construction/CHECKPOINTS.md` (the walk-back) - home is [`../README.md`](../README.md)
**Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Foundation, mixed -- index and design-room guidance
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)

---

## What This Folder Is

**The boundary, seated `20260821.174047`.** This room holds **essays** -- design that outlives the code it describes. Round scoping, lap plans, survey ledgers, and evaluations of choices already shipped now live next door in [`../active-development/README.md`](../active-development/README.md). One question decides: *would this still be worth reading if the code it describes were deleted?* Yes here, no there ([`../.claude/rules/design-rooms.md`](../.claude/rules/design-rooms.md)). Nothing already filed moves -- the test governs what is born from here forward.

This is the clean room. The `active-designing/` folder holds the living design of our own work -- the modules we are actually building, reasoned from first principles, in our own words. Where the external-research stack studies the world and thanks the works that taught us, this stack does something different and complementary: it designs.

This file, `README.md`, is the foundation stone. It rests at the bottom of the stack and explains how the stack works and what rule keeps it clean, so anyone who opens this folder understands its shape and its discipline at a glance.

---

## The silo principle

One rule governs everything here, and it is the reason this folder stands apart: **active-designing names only what is ours, and one fixed external.**

The names we may use are our own chosen modules -- **Grain, TAME, Aurora, Rye, Glow, Brix, Tablecloth, Tally, Caravan, Weave, Mantra, Pond, Pool, Rishi, Comlink, Brushstroke, Dexter, Kumara, Bookie, Granary, Mandi, Amber, the Verse**, and any future names we coin -- together with **RISC-V**, the open instruction set we build upon and treat as solid ground. Inspired systems, admired tools, and ancestor languages keep their names in external-research and gratitude; here the design speaks only our own vocabulary.

This is silo as a kindness to clarity. Outside ideas enter only as **concepts**, stripped of their origin and weighed on their own merits -- a region of memory, a content-addressed store, a supervision tree, a lawful combinator. By refusing the borrowed name, we force ourselves to understand the idea well enough to restate it plainly, and we keep our design space free of any genealogy that might quietly smuggle in assumptions we never chose. What grows here grows on its own roots.

The discipline is simple to check: read any line aloud, and if it names something outside our own work or RISC-V, it belongs in the external-research stack instead.

---

## The Workshop Era (accreted 2026-07-27)

Three residents joined this folder after the foundation above was laid, and each keeps the silo law whole. **`docs/glow/`** is the Glow Book -- the language's six anchored pages with their gate witness, landed by the first workshop's C2 create. **`quin-workshop/`** is a chapter lane: a workshop branch's working home, holding its charter's creates, the newborn shell and driver under proof, and **`creates/for-main/`**, the mirror of every path a paste will land on main -- files travel from there by copy, gated by the manifests, seated only by Keaton's paste. **`yonder/`** holds designs resting beyond the current horizon. A chapter closes; its lane remains as record; the next chapter opens its own round counter on the same branch. The verse of this folder is therefore layered on purpose: foundations at the bottom, living design in the middle, chapter lanes alongside -- one clean room, several benches.

## Two Folders, Two Purposes

The project keeps two design-adjacent stacks, and the boundary between them is deliberate -- they differ in temper as much as in content.

The **external-research** stack is open to the world. It studies other systems, names them precisely, draws inspiration, and cites its sources -- with the original works kept whole in the `gratitude/` folder. It is allowed to be experimental, informal, and overgrown at times, the way a field of inquiry should be: many threads, freely followed, some left to tangle. External research is where we learn, compare, and honor.

The **active-designing** stack is closed and self-contained. It carries only our own design, isolated from any non-TAME-style project or concept, so the work can mature undivided. Its temper is the opposite of the field's wildness: clear, thought-through, confirmed, directional, and intentional, accruing slowly and only when a change earns its place by serving -- in our designs themselves -- safety above performance, and performance above the joy of the craft. Active designing is where we decide and build.

Ideas flow one way across the boundary: a concept learned in external research, once understood, may cross into active-designing only after it has shed every borrowed name and been restated as our own. The citation and the gratitude stay behind; the distilled idea comes forward clean, and is admitted only once we are sure it makes the design safer, then faster, then kinder to work in.

---

## One clock, one order

Dated briefs carry `YYYYMMDD-HHMMSS_short-sprig.md` filenames; this README is the living foundation and reverse-chron index. Full naming law: [`../context/specs/20260627-102012_one-clock-naming-law.md`](../context/specs/20260627-102012_one-clock-naming-law.md).

## The room at the door

A brief here carries a `**Status:**` line, and that line names which of the two rooms it speaks
from -- one of `checkable`, `vision`, `mixed`, or `research for understanding`, glossed at
[`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md). The token rides beside whatever else the
line says, so `**Status:** Living, mixed -- ...` answers where the page stands in its life and
which register it speaks from, both in one line.

[`../tools/t/two_rooms_doorway.rish`](../tools/t/two_rooms_doorway.rish) reads that token on every
cadence pass and names every page whose Status has yet to carry one. This room supplies **756 of
the 975** pages it reads and **31 of the 44** it names (measured `20260907`), which is what earned
this section: the rule stood in canon and on the roster, and this door had yet to mention it.

## Design briefs (newest first)

| Stamp | Brief | Meaning |
|-------|-------|---------|
| living | [Proven-seat guest -- hammock](proven-seat-guest-hammock.md) | Kaeden word - G0 GRUB milestone GREEN - G1-G3 ahead |
| living | [Giving-lane T2 courtesy wire](yonder/giving-lane-t2-courtesy-wire.md) | Word seated - wire opened - composition witness ahead |
| living | [Steep -- peer file sharing](steep.md) | Living twin - published-set / peer-offer precedent seated |
| living | [Seam chapter -- hammock](seam-season-hammock.md) | Living twin -- product nib **430** - suite nib **432**; edit here |

## Redirect stubs

When a design brief **supersedes** research or an executed prompt, the old file in another stack becomes a stub (see `../external-research/README.md`). In **this** stack, revise briefs in place when the design matures (see [`yonder/date/20260618/20260618-085812_strengthening-strategy.md`](yonder/date/20260618/20260618-085812_strengthening-strategy.md)) rather than leaving duplicate architecture docs.

**Current width law:** [`20260621-051312_explicit-width-in-rye.md`](yonder/date/20260621/20260621-051312_explicit-width-in-rye.md) -- literal `usize` ban in Rye types. Interim Zig-ground seam audit: research `968` until fork F3.

**Retired patterns in new design prose:** Bash gates, `ArenaAllocator` in authored modules (use `init.garden`), `usize` in APIs we publish, vendor Zig parity as permanent contract.

---

*May this room stay clean. May every idea that enters earn its place on its own merit, undivided from where it came. May our names -- and the ones still to come -- grow here on their own roots, safe and swift and a joy, woven into the open grain of the machine we build upon.*

