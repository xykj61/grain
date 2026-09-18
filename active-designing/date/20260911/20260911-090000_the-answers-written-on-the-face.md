# The answers written on the face

**Stamp:** `20260911.090000`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Status:** Landed -- **checkable room**: every count below is read by
[`../tools/fixtures/g/gate_example_scan.sh`](../tools/fixtures/g/gate_example_scan.sh) and gated by
[`../tools/g/gate_example_witness.rish`](../tools/g/gate_example_witness.rish)
**Voice:** Kyri
**Kin:** [`../foundations/20260826-021735_earth-the-row-that-breathes-in.md`](../foundations/20260826-021735_earth-the-row-that-breathes-in.md) -- [`../src/shape/PLACARD.md`](../src/shape/PLACARD.md) -- [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md)

Every desk in [`src/gate/`](../src/gate) opens with the six placard lines
[`src/shape/PLACARD.md`](../src/shape/PLACARD.md) seats, and one of them is `example`. On a shape
pedestal that line is a single literal, and two rungs seated `20260910` hold each of those numbers
against the Rye it describes. On a **gate** desk the same line is a table of input and answer:

```
::  example    3 5 -> 1 - 3 2 -> 0 - 3 3 -> 1
```

That is a program's behavior, written down by the hand that wrote the program, on the program's own
face, in a form a machine can read. Measured `20260911` over the room's 43 gate desks: **40 carry an
example, 39 parse as machine tables, and they hold 104 cases between them.** Every one of them stood unread until this lap.

## What the gap was, and what it was not

The desks themselves run.
[`tools/fixtures/g/glow_desk_reach_scan.sh`](../tools/fixtures/g/glow_desk_reach_scan.sh) reads 347
covered desks and holds its uncovered count at zero, so coverage was in hand. What was missing is
the **comparison**: a witness that runs a desk asserts an answer it typed into itself, and the
placard beside that desk states the same answer in a second place nobody had read.
[`tools/g/glow_vane_pair_mirrors_witness.rish`](../tools/g/glow_vane_pair_mirrors_witness.rish)
asserts `3 5 -> 1` for `gate-mantra-gen-floor-pair-u32` in its own text; the desk's placard says
`3 5 -> 1`; the two were written separately, and each would have stayed green while the other went
wrong.

This is the **earth reading**, in the row's own terms: a stamp is read off a filename, a room token
off a status line, and an answer off a placard -- the concrete fact taken in whole at the door,
before any argument about it. Running the table is what turns it into a fact the tree holds.

## The two readings that cost no build

**Parse.** Every case of every table resolves to decimal inputs and one decimal answer, or its desk
is named as prose and left alone. The count is a reading rather than a claim: the 104 parsed cases
plus the three arrows of the one prose desk account for all **107** arrows standing on `example`
lines in the room.

**Arity, per case.** The worker already answers its own run contract --
`sh tools/g/glow_run_worker.sh --arity <desk>` -- a mode built for exactly this, so a caller keeps
no second copy of how many samples a desk takes. The placard's table declares the same number in a
second room, and the comparison waited for this lap. All 104 stand inside the accepted set.

**Per case, rather than per desk, and that distinction is the design.**
`gate-lantern-face-core` carries cases of two inputs and cases of three, and the worker accepts
both. The obvious reading -- take the first case's shape as the desk's arity -- calls that desk
arity 2 and passes its three-input cases unseen. The control plants that exact shape; removing the
per-case loop from the scan drops a leg.

## What a prose example earns

`gate-compose-sumto-u32` writes its example as a sentence: *argv 4 -> 10 (inc of 3); welcome bakes
5 -> 15; past 65535 -> 0*. It carries arrows and it is plainly for a person. `PLACARD.md` asks for
one small literal and says nothing about a machine table, so an example that fails to parse is
**named by desk and left alone** -- the shape `members()` one room over already takes when it
answers `unresolved:<what>` rather than reading zero. Gating here would refuse honest prose, and a
guard that reds on honest work is a guard somebody turns off.

## Where the run half sits, and why

Each case lowers and builds its desk with Zig, and each pays for its own build:
measured `20260911`, **5.5 to 6.0 seconds each**, so the live 104 take about eleven minutes. Paying
that every lap would re-prove 104 answers that moved for nobody, so the run half is opt-in and the
runner is proven instead on miniature desk rooms in a pen, where a wrong answer is planted and
bitten in seconds. The live sweep is one command:

```
sh tools/fixtures/g/gate_example_scan.sh --run
```

**Its first reading, taken `20260911`: 104 ran, 0 failed, 0 wrong.** Every gate desk in the room
answers exactly what its own face declares. It drops nothing and samples nothing, and it prints a
line per case as that case lands, because a sweep that speaks only at its end is eleven minutes a
reader cannot tell from a hang.

## The one line the reader must read exactly

The worker prints the binary's own output and then `EXIT:<code>`. An answer read by substring finds
`0` inside `EXIT:0`, so a program that says **nothing at all** passes for a desk declaring zero --
which is [`REDS %310`](../construction/REDS.md)'s own shape, the fault that found a gate proving
itself against its own copy. The scan reads the last line standing before that tail, exactly, and a
silent program answers `<silence>`. The control plants it: mutating the comparison to a substring
test drops three legs.

## What this does not reach

**Whether a declared answer is the right answer.** That is each vane's own design question; this
rung proves the desk and its placard agree, and stops there.

**The three placardless desks.** `gate-surface-double-u32`, `gate-surface-inc-u32` and
`gate-tally-dec-u32` open with prose alone, where a placard would stand. Whether a gate desk must carry one
changes what declares a desk's kind, which is a language custody ruling rather than a repair a lap
takes.

**The sibling's question.** [`glow_desk_arity`](../tools/g/glow_desk_arity_witness.rish) compares
three statements of arity over 46 sampled desks in `glow/gen`. Measured the same day, **zero** desks
in `src/gate/` carry the `::  Sample:` line that rung's first statement is made of, so its reading
has never reached one of these desks. Two rooms, two statements, two instruments -- and this one
carries the answer beside the inputs, where a `Sample:` line states its inputs alone.

*May every placard say what its program does, may every stated answer meet a reader, and may the
fact at the door stay the fact the engine keeps.*
