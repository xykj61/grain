# Caravan ladder -- the spine the meter cannot see

**Language:** EN
**Version:** `20260820.204641`
**Status:** LANDED `20260820.212419` -- the measurement stood GREEN on metal, and fold D ran the round after it, Option B written in Option A's seam
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Kin:** [`20260820-131713_caravan-ladder-shared-harness.md`](20260820-131713_caravan-ladder-shared-harness.md) -- folds A and B - [`20260820-182533_caravan-ladder-the-harness-answers-for-silence.md`](20260820-182533_caravan-ladder-the-harness-answers-for-silence.md) -- fold C
**Meter:** [`../tools/caravan_ladder_spine_witness.rish`](../tools/caravan_ladder_spine_witness.rish) over [`../tools/fixtures/caravan_ladder_spine_scan.sh`](../tools/fixtures/caravan_ladder_spine_scan.sh)

---

## What the number says

Three folds took the Caravan ladder's carried checks from 54,612 lines to **47**, and the meter that counts them reads 47 today. Beside that number, measured this round for the first time, stands another:

```
SPINE_MODULES 101 holding=21 fn=close_the_quarrel
SPINE_LINES total=1003 distinct=106 carried=897
SPINE_NEIGHBOR carried=897
SPINE_RATCHET over_bound=4 bound=70 longest=refrain:86
```

**The ladder's orchestration spine is 106 distinct lines standing on disk 1,003 times.** Every rung of the correspondence arc holds one function that runs the whole thing in order -- `close_the_quarrel` carries a position, hears a finding, answers it, takes a matter up again, walls it, calls a person about the wall, spares a reader who is done, and books what is owed. A rung born from the rung beneath it copies that function whole and inserts its own step. The staircase is exact: sixteen lines at `refer`, three more at each rung, eighty-six at `refrain`.

Two readings agree at 897 carried lines, and they ask different questions. The union count asks how many *different* lines the whole ladder holds; the neighbor walk asks of each spine how many of its lines already stand in the spine directly beneath it. A number that survives being counted two ways is one a design call may rest on.

## Why the meter beside it reads zero here, and is right to

The copy meter counts **byte-identical bodies**. No two rungs hold the same `close_the_quarrel`, because each is the rung below's plus three lines -- so by that measure the spine costs nothing at all, and a thousand lines of orchestration rode free past a meter reading 47.

**This is a ratchet, never a red.** The copy scan names its subject in its own first sentence -- *"how many lines of the Caravan ladder are still a byte-identical copy"* -- and every claim it makes about that number is true. What it cannot see is a **near** copy, which is exactly what a staircase is. Nothing was measured wrong; something was never measured. So the honest close is a second meter beside the first rather than an erratum against it, and both numbers now stand together in one witness: 47 byte-identical, 897 near.

## The ratchet TAME already names

Four rungs hold a spine past TAME's seventy-line function bound -- `abate` at 71, `conclude` at 74, `respect` at 80, `refrain` at 86 -- and every rung born from here forward adds three more. TAME names function length a **ratchet** that turns on touch rather than a gate, so the spine scan prints it and the carried-line ceiling is the only wall. The wall sits at 1,100 against a standing of 897, which is about two rungs of headroom at the spine's own rate.

## The seam

Read in order, the spine falls into four movements and a closing line, and the seam has been there since the arc began:

| Movement | Steps | Complete since |
|---|---|---|
| **The standing** | carry the position - weigh, date, and herald the standing - refer the quarrel | `refer` |
| **The finding** | read it - say the word - meet the debt - redress the meeting - apprise the raiser - weigh the answer | `suffice` |
| **The second look** | take up again - look again - tell the reopener - read the reply | `allay` |
| **The correspondence** | mind the impasse - bound the relay - carry the wall - open the answer - abate the wall - refrain from calling - respect the ending - close the matter - hold the matter | still growing |
| *and the close* | book the debt | always last |

Three movements finished growing rungs ago and have stopped teaching anything; every new rung extends the fourth. That asymmetry is the useful part: what is frozen is pure carry, and what is live is the thing each rung exists to show.

## Fold D -- two ways, and the one to take

**Option A -- split each rung in place.** Every rung's `close_the_quarrel` becomes a five-line table of contents calling four movements. It answers the seventy-line ratchet honestly and reads better than the eighty-six-line list it replaces.

Yet it moves nothing. The three frozen movements would become **byte-identical across rungs by construction**, so the copy meter would begin counting them and the carry would climb from 47 into the hundreds. Option A trades a cost the meter cannot see for one it can, without removing it -- and the ladder has spent three folds learning that a shape repeated per rung wants a home rather than a nicer shape.

**Option B -- lift the spine to the harness.** `caravan/ladder_checks.rye` already proves the mechanism: a body takes the rung as a `comptime` parameter and reaches every helper through it, so one body runs against whichever rung handed itself in -- that rung's own report, its own helpers, its own wire. Fold C then taught the harness to answer for a rung that says nothing, through `link` and `@hasDecl`. A spine lifted the same way would gate each step on whether the rung declares it, so **one body serves the rung holding five steps and the rung holding twenty-five**, and the staircase becomes a property the harness derives rather than twenty-one hand-copies of it.

What it costs is named plainly:

- **Twenty-five step functions and their report accessors go public on each rung.** Fold A already set that precedent for checks, and the reason is the same: a private function cannot be reached from a body that lives above it.
- **The newest rung reads its own field directly** (`report_out.refrained`) where every rung below reaches through an accessor (`refrain_of(report_out)`). The lifted body needs one small helper to ask for whichever form the rung publishes -- the same shape `link` already wears.
- **A reader loses the whole correspondence on one screen of one rung.** This is the real cost, and worth saying without softening: opening `refrain.rye` today shows the entire arc in order, which is the most legible artifact the ladder has produced. After the lift that order lives in the harness, in one complete copy, gated per step. The mitigation is that the harness spine is the *only* place it is written whole, so it can be written to be read.

**Recommended: Option B, written in Option A's seam.** Lift the spine into the harness, and write the harness spine as the four movements above, so the one remaining copy is itself under the seventy-line bound and reads as the correspondence rather than as a list. 897 lines leave the ladder, the ratchet is answered in every rung at once rather than in four of them, and a new rung's step costs three lines in one file rather than a fresh copy of everything beneath it.

## What fold D landed, and what the numbers did

Fold D ran on `20260820.212419`, exactly as recommended: Option B, written in Option A's seam. The spine lives in `caravan/ladder_checks.rye` -- one `close_the_quarrel` taking the rung as a `comptime` parameter, calling four movement functions that gate each step on whether the rung declares it. Twenty-one rungs keep four lines apiece at the callsite and no spine at all.

Every symbol the lifted body reaches went public on each rung, a staircase of its own: six published at `refer`, eight at `deem`, two more at every rung up to forty-six at `refrain` -- one step and one accessor per rung, which is the structure the measurement predicted, confirming itself on the way out. The one shape that needed a helper is the one the brief named: a rung's own newest step reads its count as a plain field while every inherited step reaches through a named accessor, so `tally` asks for whichever form the rung publishes, the same `comptime` reach `link` already wears.

| Reading | Before | After |
|---|---|---|
| Rungs holding a spine | 21 | **1** -- the harness |
| Spine lines on disk | 1,003 | **19** at the entry, 170 counting its four movements |
| Carried spine lines, both readings | 897 | **0** |
| Spines past TAME's seventy-line bound | 4 | **0** -- the longest movement is 59 |
| Byte-identical carry, beside it | 47 | **47**, unmoved |

**Parity is the proof, and it was taken two ways.** All twenty-one rungs were built and run before the lift and again after; every one prints the same multiset of lines, and the only differences are the order of concurrent `client_a/b/c` reports. That the interleave is the run rather than the fold was proven rather than assumed -- the same folded binary run twice shows the same class of reordering and a sorted diff of zero.

**The ratchet was answered everywhere at once, including in the answer.** The four rungs standing past seventy lines are gone from the list, and the harness spine itself stays under the bound in every part: 15, 37, 27, 59, plus a 19-line entry and a 13-line helper. That is what "Option B in Option A's seam" was for, and it held.

**One cost arrived that the brief did not name.** The guard REDS %99 left to protect prose refused two hand-written sentences of the new harness doc, because its pattern matched any `rung.` while its stated rule was about a `rung.` that *reaches a symbol* -- and an English sentence may close on the ordinary noun. Booked and closed as **REDS %100**: the pattern narrowed to the reach it names, both planted RED controls still refusing, and a new PASS control proving the plain word welcomed. A gate that reds on valid input teaches the bench to route around it, so it was fixed rather than worked around.

## What the measuring round landed

The measurement and its guard, nothing more. `tools/fixtures/caravan_ladder_spine_scan.sh` reads the spine two ways, holds the carry under a named ceiling, and reports the seventy-line ratchet beside it; `tools/caravan_ladder_spine_witness.rish` proves the living reading, proves the counter by hand on a two-rung corpus whose twelve lines and five carried lines are countable by eye, holds the copy meter's 47 beside the spine's 897 so neither number can be read alone, and refuses three RED paths by name -- a corpus with no modules, a corpus whose modules hold no spine at all, and a carry grown past its ceiling. The witness is registered in `tools/caravan_suite_witness.rish`, so it is never a scan nobody runs (REDS %97).

Fold D took the round after this one, with that number to move -- and moved it to zero.
