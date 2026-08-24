# Stamp and Name -- how a piece of work is marked

**Seated:** `20260821.160050` on Keaton's word - **Status:** Living - **Molted into Gauge:** `20260823.234815` (register only; every claim, number, path, and stamp held exactly, checkpoint `1d5ade54b7`)
**Kin:** [`waymark-ladders`](waymark-ladders.md) - [`one-clock naming law`](../../context/specs/20260627-102012_one-clock-naming-law.md) - [`comlink-tendency`](comlink-tendency.md) - [`lindy-first-crux`](lindy-first-crux.md)

**A mark is a stamp and a name.** The stamp orders it; the name means it. Those two carry everything a mark
needs, and the law is what keeps a third thing from creeping in.

## The law, in four lines

1. **Mark by stamp and name.** `the standing movement (20260821-142939)`. The stamp comes from the one
   clock; the name says what the work was.
2. **Keep counted marks for work already done.** `Fold A -> Fold AH -> Fold AI`, `f0-f63`, and `X0/X1`
   rungs belong to planned work, where a sequence label is a forecast written somewhere it will stay
   uncorrected. See *A census number keeps its place* below for the counted marks that stay.
3. **Count, never number.** A total is derived by measurement --
   `git log --oneline --grep="caravan: fold" | wc -l` -- so it stays true as the work grows. A total
   carried inside a name stays at whatever it was on the day somebody typed it.
4. **Keep the whole stamp in every filename.** `date/YYYYMMDD/YYYYMMDD-HHMMSS_sprig.ext`. The repeated
   day is a check digit, and *The path* below gives the three reasons it earns its place.

## What a stamp and a name give you, and what a counted rung asks instead

A stamp and a name give a mark four properties, and a counted rung asks a price for each one. The
four ladders below are this tree's own evidence, all of it measured.

**A promise the work can keep.** A stamp claims that this happened then, and stops there. A counted rung claims a length: the Fascia Equinox announced `f0-f63` and reached **f3**; the MUR Season announced `u0-u127`
and paused at **u91**; the Inner Scope Season announced `i0-i15` and paused at **i6**; the Geode
Season announced sixteen rounds and filled **two rooms of twelve**. Each was a plan wearing a name's
clothes, and every citation of a name depends on the name staying as written.

**Independence, stated honestly.** A lap marked by stamp and name announces itself as complete in
itself. `Fold AI` reads as the thirty-fifth link of a chain, so a newcomer assumes fold AH comes
first -- when what fold AI depended on was the ladder's shape that morning.

**One sort order everywhere.** A stamp sorts the same way in `ls`, in `git log`, in a file browser, and
in a reader's head, permanently, and a reader carries one order rather than two. `Fold Z` precedes `Fold AA`
alphabetically and follows it chronologically, so a letter needs the reader to hold two orders at once.

**A mark that reads alone.** A stamp and a name are legible with no context. A second ladder reaching
`AI` produces a mark that needs its ladder name to be read at all -- the same `G0` collision the
waymark law was drawn to rescue once already.

**And the replacement was already running.** This tree's own commit subjects carry no letters and are
perfectly clear -- `caravan: fold the courier cluster, eleven at once`. The commit already holds a
stamp in its author date and a name in its subject, so the letter was the one part carrying
nothing the other two already said. The law is subtraction rather than substitution.

## What keeps its place

- **Waymarks stay.** A waymark is a **name** drawn for a ladder rather than a number counted up
  (`waymark-ladders.md`). HAWM, STOA, and JABS keep their draws. What retires is the numbered **rung**
  after the waymark, for planned work.
- **`rung` stays where a real ladder exists.** `caravan/ladder_checks.rye` genuinely runs its checks in a
  load-bearing order, so its entries are rungs and the metaphor is exact. The retirement reaches `rung`
  only as a label for a step of *planned* work.
- **`lap` and `round` carry planned work.** A lap is complete in itself, owing the lap before it nothing at all; a round is a bounded unit of session with an opening and a close. All ten daily words -- arc,
  round, lap, ladder, rung, fold, lift, carry, delegate, fascia -- are defined for a first-day reader in
  [`../../foundations/20260821-175723_the-words-a-round-uses.md`](../../foundations/20260821-175723_the-words-a-round-uses.md).
- **`fold` files; `lift` takes out of a ladder.** One word held both senses, and both are operational
  verbs about moving things around the tree -- the one real collision. `fold` keeps the filing sense,
  seated in this law and three tools; **`lift`** takes the ladder sense from `20260821.175723` forward.
- **Version stamps are unchanged.** The one-clock naming law already marks files chronologically; this
  law extends the same habit from filenames to the marks used in prose, plans, and commit bodies.

## The path -- how a folded room is named

A room folds when it outgrows a reader. The shape is:

```
<room>/date/YYYYMMDD/YYYYMMDD-HHMMSS_sprig.ext
```

**`date/`, rather than `archive/`.** `ORGANIZING.md` defines archive as *backward-pointing,
finished-and-historical*, and a log from nine days ago is the live record. `date/` claims only *when*,
which is the one thing true of every file in the room.

**The whole stamp stays in the filename**, and the eight repeated characters earn their place three
times over:

- **The move becomes an invertible function.** Old path to new is computable from the basename alone --
  read the first eight characters, insert `date/YYYYMMDD/`. The computation stands alone -- index-free,
  table-free, memory-free -- and it works for rooms that have yet to fold. This is what makes an elder reference *resolvable*, and it is the
  whole basis of [`../../tools/d/dated_path_resolve.rish`](../../tools/d/dated_path_resolve.rish).
- **The basename stays globally unique.** `152409_align.md` could exist on two hundred days, and
  `grep -r` would then land on one of them silently -- the failure mode a reference can least afford,
  since it looks exactly like success.
- **The name survives leaving its path.** Editor tabs, `find` output, a filename pasted into a message --
  `20260821-152409_the-standfast-read` still says when and what, where `152409_the-standfast-read` has
  left both behind.

**Living things are repointed; dated testimony is resolved.** A room's own index is repointed in the same
pass, because an index's whole job is to point correctly. So is **living code** -- a witness running
`grep -q ... <room>/<file>.md` reads an absent path and reds, and folding four rooms reached roughly a
thousand such functional references at once. Dated testimony keeps every word it wrote, and the tree
draws the line for itself: **a file whose own basename carries a one-clock stamp is testimony**, and
everything else is living. [`../../tools/d/dated_path_repoint.rish`](../../tools/d/dated_path_repoint.rish)
applies exactly that rule, and [`../../tools/d/dated_path_repoint_witness.rish`](../../tools/d/dated_path_repoint_witness.rish)
proves it -- a living file repointed, a dated-named file left byte-identical, no double fold, idempotent
on a second pass. With 4,138 broken dated references already standing across 19,787 before the first fold,
repointing by hand would mean editing thousands of dated logs, which is a Tier 2 breach at scale in
service of tidiness. A stale reference is **resolved**:

```
rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference> [<citing-file>]
```

**A room folds past 256 flat files** -- a power of two, well below GitHub's 1,000-entry listing cap,
because a bound placed at the cliff fails on the day it matters.
[`../../tools/r/room_bound_witness.rish`](../../tools/r/room_bound_witness.rish) discovers rooms rather
than listing them, so a room made tomorrow is measured like every other.

**A room earns ENFORCE by folding.** Once a room has been carried across, its references repointed and
its resolver proven, holding it under the bound is a choice the room has already made -- so it moves
from advisory to enforced, where crossing 256 is a red. Six rooms hold that seat: **`session-logs`,
`counsel`, `active-designing`, `expanding-prompts`, `waymarks`** (`20260821.171331`), and
**`active-development`**, which was **born enforced** on `20260821.174047` -- a room opened under the law
starts with nothing to grandfather. An enforced room is **reported at every count, empty or full**; two
of the five sit at zero flat files, and a discovery-only report dropped them entirely -- so a room that
vanishes from a meter is a room whose pass nobody witnessed. Every other room stays advisory until its own
fold.

**The three tools must agree on what a dated file is.** The fold moves them, the resolver recovers
references to them, and the census counts them, and each disagreement cost a round: a fold looser than
the resolver would have moved 33 files it could never find again, a census reading the fold rule differently
reported 82 recoveries as ambiguous, and a repointer whose regex left the extension unanchored passed
over 49 real references in silence. One shape, `YYYYMMDD-HHMMSS_sprig.ext`, checked the same way everywhere --
and the stamp alone is what marks it, since the sprig is optional (REDS %175: 237 logs carry a stamp and
no sprig, and a pattern requiring one read every last of them as living).

**Agreement is now held by a meter rather than by care.** REDS %175 named eight scans still carrying
the narrow pattern; a grep for the three spellings this tree writes stamps in found **nineteen sites
across fifteen files** (REDS %178), so the remainder in that row was itself counted from memory. All
nineteen read `[_.]`, `(_|\.)`, or `(_<sprig>)?\.` now, and
[`../../tools/d/dated_spelling_witness.rish`](../../tools/d/dated_spelling_witness.rish) over
[`../../tools/fixtures/dated_spelling_scan.sh`](../../tools/fixtures/dated_spelling_scan.sh) gates 4,705
living tracked sources at zero, proven both ways on real git repositories in a throwaway pen. Two of
the eleven unnamed sites carried a consequence past a miscount: the guard that refuses edits to dated
artifacts could not see a sprigless log, and the repointer's map, candidate filter, and line matcher
could none of them see a sprigless reference.

**A reference begins at a boundary.** Widening the right side surfaced a looseness on the left that had
stood the whole time: the census's reference pattern could match a stamp sitting inside a longer
filename, and the retired countdown-prefix names (`99991_20260619-090912.md`) are exactly that shape --
24 such substrings read as lost references. A lookbehind seats the boundary now. The census sees **239
genuine references it was blind to**, and its lost count stands where it stood.

**Every fold ships with the witness green.**
[`../../tools/d/dated_path_witness.rish`](../../tools/d/dated_path_witness.rish) proves the resolver's
five verdicts on real cases, proves the fold rule on a room that has never folded, refuses three RED
paths, and holds the **lost-reference** census under a ceiling with **no slack**. The gate reads what the
resolver *cannot* recover -- a basename that exists nowhere, or one at two paths where no answer is safe
-- rather than the whole broken count, because a reference the resolver recovers is the expected steady
state and rises whenever a room folds. Moving a file changes its path and keeps its basename, so a
correct fold leaves the lost count exactly where it stood. Lower it when a repair lands.

## Illustrate with placeholders, cite only what exists

An example path in prose is a **shape**: `date/YYYYMMDD/YYYYMMDD-HHMMSS_sprig.ext`, with letter
placeholders standing where the digits would go. Build an illustration from placeholders and it stays
honest; build one from a real-looking stamp and a sprig naming no file, and it reads as a real citation
to every reader and every tool. The census counted three such fabrications as broken references on the
day this law was written -- in the law itself, in the resolver's witness, and in the research note that
proposed it. A lantern that fires twice becomes a loom, so it is written here.

## One shape, every room -- amended `20260823.111029`

The `YYYYMMDD-HHMMSS_sprig.ext` name and its `date/YYYYMMDD/` fold are **the tree's one filing shape**,
holding in every room that dates its work. Foundations, active-designing, active-development,
expanding-prompts, counsel, waymarks, and context specs all carry it today; a room opened tomorrow
carries it from its first file.

Three things follow, and each is machinery rather than intention:

- **A stamp comes from the one clock.** `TZ=America/New_York date +%Y%m%d.%H%M%S` on this pier, proven by
  `tools/o/one_clock_witness.rish`.
- **A version is chronological.** A later stamp is a later version. A ladder is marked by stamp and name,
  and its length is counted with `git log`.
- **A room folds past 256 flat files**, into `date/YYYYMMDD/` with the whole stamp kept in the basename,
  so the move stays an invertible function and a stale reference is resolved.

**The public projection versions the same way.** The seed ships every fifth round
([`../../foundations/20260823-111029_the-seed-that-ships-every-fifth-round.md`](../../foundations/20260823-111029_the-seed-that-ships-every-fifth-round.md)),
so its freshness is measured in rounds against the same clock rather than in an announcement.

## A room folds by what its files are found by -- amended `20260823.144100`

The bound is one number for every room: **256 flat entries.** The fold *shape* follows from a different
question, and it has exactly two answers today.

**A room whose files are found by WHEN folds by day**, into `date/YYYYMMDD/`. Session logs, counsel, the
design rooms, and waymarks all work this way -- you look for the note from the afternoon a decision was
made, so the day is the key and the whole stamp stays in the basename.

**A room whose files are found by WHAT folds by first sprig letter**, into `<room>/<letter>/`, with a
letter that stands over bound alone splitting one letter deeper: `tools/ca/`, `tools/cr/`. Nobody looks
for the witness they wrote on a Tuesday; they look for `caravan_suite_witness.rish`. `tools/` folded this
way on `20260823.144100`, carrying 1,917 flat entries into 35 rooms on Keaton's word.

**Both keep the one property that makes a fold safe:** the new path is a pure function of the basename,
so a stale reference is **resolved rather than rewritten** and an index stays true.
`tools/d/dated_path_resolve.rish` computes the day answer; `tools/t/tool_path_resolve.rish` computes the
letter answer, trying the two-letter room rather than consulting a table of which letters split. Living
references are repointed in the same round -- `tools/d/dated_path_repoint.rish` and
`tools/t/tool_path_repoint.rish` -- while dated testimony keeps every word it wrote.

**One extension names its own room, ahead of the letter.** A `.rye` source of `tools/` lives in
`tools/rye/`, together with the crypto shims and the `enrich/` room those sources import by bare name.
Zig refuses an import that escapes the root file's directory, so a bare-name `@import` is a directory
relationship the language enforces, and a room whose members import one another that way is one room by
the compiler's own rule. The extension is visible in the basename, so the resolver stays a pure function.

**A meter reads the room by its own rule.** `tools/fixtures/room_bound_scan.sh` counts a day-folded room
by dated basenames and a letter-folded room by every flat entry, printing `counts=all` beside the second.
That distinction is why `tools/` reached **7.4x the bound with every guard green**: not one of its entries
carried a stamp, so the dated count read zero for the room's whole life.

## A census number keeps its place -- amended `20260823.173634`

**A number that predicts is a forecast; a number that counts is a census, and this law retires only the
first.** Read the four ladders above again: every example is a plan that announced a length and stopped
short. A number naming work that has already happened forecasts nothing and holds.

**`construction/REDS.md` keeps its `%NNN` rows**, and the exemption is written here rather than left to be
re-derived. Three reasons, each checkable:

- **The row already carries the stamp and the name.** `**REDS %174 (`20260823.174500`) -- the roster ran
  on one tree and the commit shipped another.**` -- all three marks stand, so dropping the number removes
  something rather than adding chronology.
- **A gapless spine proves the record is whole**, where a stamp leaves it open.
  [`../../tools/gen/season/reds_ledger_monotone_witness.rish`](../../tools/gen/season/reds_ledger_monotone_witness.rish)
  reads N off disk across the living pin and every fold archive and holds `1..N` with no gaps. Take a
  stamped row away and the remainder still reads complete; take `%118` away and the guard reds.
- **The citations reach further than any migration could.** Measured `20260823.173634`: **2,519** across
  the tree, of which **532** sit in commit messages and **208** in dated testimony -- both beyond reach, so
  a conversion would leave the majority pointing at a retired scheme.

**The test, for the next sequence somebody wants to number:** *could this number turn out to be wrong?*
Planned work, yes -- stamp and name it. Work already done, no, and a gap in it would mean a record has
gone, which is worth being able to see.

The `%` sigil carries its own reason beside the GitHub one in [`git-signing`](git-signing.md): in Glow, as
in the Hoon it descends from, `%` marks a **constant term**, a value that is exactly itself and never
varies -- which is what an immutable ledger row number is.

Full argument and the standfast declined:
[`../../active-designing/20260823-173634_the-census-number-keeps-its-place.md`](../../active-designing/20260823-173634_the-census-number-keeps-its-place.md)
and [`../../external-research/20260823-173634_when-a-number-is-honest.md`](../../external-research/20260823-173634_when-a-number-is-honest.md).

## Accrete-never-break

Every dated log, counsel note, waymark, and commit that already wrote `Fold AI`, `f0-f63`, or `STOA178`
**keeps every letter it wrote** -- the one-clock law and accrete-never-break protect them, and those marks
stay readable forever. This law governs what is marked from here forward, and living *Now* lines may sweep
to it as they are touched.

## Why the law exists

A name owes nothing to an alphabet and everything to two readers: the one meeting it on their first day,
and the one typing it on their ten-thousandth. A stamp tells them when, a name tells them what, and
between them they promise only what the work actually keeps.

Canonical Cursor twin: [`../../.cursor/rules/stamp-and-name.mdc`](../../.cursor/rules/stamp-and-name.mdc).
