# Stamp and Name -- how a piece of work is marked

**Seated:** `20260821.160050` on Keaton's word - **Status:** Living - **Kin:** [`waymark-ladders`](waymark-ladders.md) - [`one-clock naming law`](../../context/specs/20260627-102012_one-clock-naming-law.md) - [`comlink-tendency`](comlink-tendency.md) - [`lindy-first-crux`](lindy-first-crux.md)

**A mark is a stamp and a name.** The stamp orders it; the name means it. Nothing else is added, and no letter or number is minted to say where a piece of work sits in a sequence.

## The law, in four lines

1. **Mark by stamp and name.** `the standing movement (20260821-142939)`. The stamp comes from the one clock; the name says what the work was.
2. **Never mint an ascending mark.** No `Fold A -> Fold AH -> Fold AI`, no `f0-f63`, no `X0/X1` rungs for planned work. A sequence label is a forecast written where it can never be corrected.
3. **Count, never number.** A total is derived by measurement -- `git log --oneline --grep="caravan: fold" | wc -l` -- rather than carried inside a name where it will eventually be carried wrong.
4. **Keep the whole stamp in every filename.** `date/YYYYMMDD/YYYYMMDD-HHMMSS_slug.ext`, never `date/YYYYMMDD/HHMMSS_slug.ext` -- no `date/` room stands yet, so the shape is written as a shape rather than as a path to a file that is not there. The repeated day is a check digit, and the reason is in *The path* below.

## Why the ascending mark is retired

**It promises a length the work does not keep.** Four seated ladders announced a size and stopped short: the Fascia Equinox announced `f0-f63` and reached **f3**; the MUR Season announced `u0-u127` and paused at **u91**; the Inner Scope Season announced `i0-i15` and paused at **i6**; the Geode Season announced sixteen rounds and filled **two rooms of twelve**. Each number was a plan wearing a name's clothes, and a name cannot be corrected without breaking every citation of it.

**It implies a dependency that is not there.** `Fold AI` reads as the thirty-fifth link of a chain, so a newcomer assumes fold AH must be understood first. What fold AI actually depended on was the ladder's shape that morning.

**It sorts wrong in every tool that sorts text.** `Fold Z` precedes `Fold AA` alphabetically and follows it chronologically. A stamp sorts correctly in `ls`, in `git log`, in a file browser, and in a reader's head, permanently and with no convention to remember.

**It collides across ladders.** A second ladder reaching `AI` produces a mark that is ambiguous without its ladder name -- the same `G0` collision the waymark law was drawn to rescue once already.

**And the replacement was already running.** This tree's own commit subjects carry no letters and are perfectly clear -- `caravan: fold the courier cluster, eleven at once`. The commit already holds a stamp in its author date and a name in its subject. The letter was the only part carrying no information, so the law is subtraction rather than substitution.

## What keeps its place

- **Waymarks stay.** A waymark is a **name** drawn for a ladder, not a number counted up (`waymark-ladders.md`). HAWM, STOA, JABS keep their draws. What retires is the numbered **rung** after the waymark, for planned work.
- **`rung` stays where a real ladder exists.** `caravan/ladder_checks.rye` genuinely runs its checks in a load-bearing order; its entries are rungs and the metaphor is exact. What retires is `rung` as a label for a step of *planned* work.
- **`lap` and `round` carry planned work.** Both are already seated here: a lap is complete in itself and owes nothing to the lap before it; a round is a bounded unit of session with an opening and a close.
- **Version stamps are unchanged.** The one-clock naming law already marks files chronologically; this law simply extends the same habit from filenames to the marks used in prose, plans, and commit bodies.

## The path -- how a folded room is named

A room folds when it outgrows a reader. The shape is:

```
<room>/date/YYYYMMDD/YYYYMMDD-HHMMSS_slug.ext
```

**`date/`, not `archive/`.** `ORGANIZING.md` defines archive as *backward-pointing, finished-and-historical*. A log from nine days ago is neither; it is the live record. `date/` claims only *when*, which is the only thing that is true of every file in it.

**The whole stamp stays in the filename**, and the eight repeated characters earn their place three times over:

- **The move becomes an invertible function.** Old path to new is computable from the basename alone -- read the first eight characters, insert `date/YYYYMMDD/`. No index, no table, no memory, and it works for rooms not yet folded. This is what makes a stale reference *resolvable* instead of lost, and it is the whole basis of [`tools/dated_path_resolve.rish`](../../tools/dated_path_resolve.rish).
- **The basename stays globally unique.** `152409_align.md` can exist on two hundred days; `grep -r` would then find the wrong one, silently, which is the worst failure a reference can have.
- **The name survives leaving its path.** Editor tabs, `find` output, a filename pasted into a message -- `20260821-152409_the-standfast-read` still says when and what. `152409_the-standfast-read` says neither.

**Living things are repointed; dated testimony is resolved.** A room's own index is repointed in the same pass, because an index's whole job is to point correctly. So is **living code** -- a witness running `grep -q ... <room>/<file>.md` resolves nothing, it simply fails, and folding four rooms broke roughly a thousand such functional references at once. Dated testimony is never rewritten. The line needs no roster because the tree already draws it: **a file whose own basename carries a one-clock stamp is testimony**; everything else is living. [`tools/dated_path_repoint.rish`](../../tools/dated_path_repoint.rish) applies exactly that rule, and [`tools/dated_path_repoint_witness.rish`](../../tools/dated_path_repoint_witness.rish) proves it -- a living file repointed, a dated-named file left byte-identical, no double fold, idempotent on a second pass. With 4,138 broken dated references already standing across 19,787 before the first fold, repointing by hand would mean editing thousands of dated logs -- a Tier 2 breach at scale, in service of tidiness. A stale reference is **resolved**, never rewritten:

```
rishi/bin/rishi run tools/dated_path_resolve.rish <reference> [<citing-file>]
```

**A room folds past 256 flat files** -- a power of two, well below GitHub's 1,000-entry listing cap, because a bound placed at the cliff fails on the day it matters. [`tools/room_bound_witness.rish`](../../tools/room_bound_witness.rish) discovers rooms rather than listing them, so a room made tomorrow cannot escape the meter by going unnamed.

**A room earns ENFORCE by folding.** Once a room has been carried across, its references repointed and its resolver proven, letting it drift back over the bound is a choice rather than an inheritance -- so it moves from advisory to enforced, where crossing 256 is a red. Six rooms hold that seat: **`session-logs`, `counsel`, `active-designing`, `expanding-prompts`, `waymarks`** (`20260821.171331`), and **`active-development`**, which was **born enforced** on `20260821.174047` -- a room opened under the law never accumulated a backlog, so it has nothing to grandfather. An enforced room is **reported whether or not it holds anything** -- two of the five sit at zero flat files, and a discovery-only report dropped them entirely; a room that vanishes from a meter is not a room that passed it. Every other room stays advisory until its own fold.

**The three tools must agree on what a dated file is.** The fold moves them, the resolver recovers references to them, and the census counts them -- and each disagreement cost a round: a fold looser than the resolver would have moved 33 files it could never find again, a census blind to the fold rule reported 82 recoveries as ambiguous, and a repointer whose regex did not anchor the extension silently missed 49 real references. One shape, `YYYYMMDD-HHMMSS_slug.ext`, checked the same way everywhere.

**No fold ships without the witness green.** [`tools/dated_path_witness.rish`](../../tools/dated_path_witness.rish) proves the resolver's five verdicts on real cases, proves the fold rule on a room that has never folded, refuses three RED paths, and holds the **lost-reference** census under a ceiling with **no slack**. The gate is on what the resolver *cannot* recover -- a basename that exists nowhere, or one at two paths where no answer is safe -- rather than on the whole broken count, because a reference the resolver recovers is the expected steady state and rises whenever a room folds. Moving a file changes its path and never its basename, so a correct fold leaves the lost count exactly where it stood. Lower it when a repair lands; never raise it.

## Write an illustration as a shape

An example path in prose is a **shape**, not a path: `date/YYYYMMDD/YYYYMMDD-HHMMSS_slug.ext`, with letter placeholders standing where the digits would go. Never build an example out of a real-looking stamp and a slug that names no file -- write the placeholders and the illustration stays honest. A fabricated path reads as a real citation to every reader and to every tool -- the census counted three of them as broken references on the day this law was written, in the law itself, in the resolver's witness, and in the research note that proposed it. A lantern that fires twice becomes a loom, so it is written here: **illustrate with placeholders, cite only what exists.**

## Accrete-never-break

Every dated log, counsel note, waymark, and commit that already wrote `Fold AI`, `f0-f63`, or `STOA178` **keeps every letter it wrote** -- the one-clock law and accrete-never-break protect them, and the marks stay readable forever. This law governs what is marked from here forward, and living *Now* lines may sweep to it as they are touched.

## Why the law exists

A name owes nothing to an alphabet and everything to two readers: the one meeting it on their first day, and the one typing it on their ten-thousandth. A stamp tells them when, a name tells them what, and neither ever promises an order the work did not keep.

Canonical Cursor twin: [`../../.cursor/rules/stamp-and-name.mdc`](../../.cursor/rules/stamp-and-name.mdc).
