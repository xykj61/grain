# Caravan rearchitected -- the optimization spine

**Stamp:** `20260826.021136`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Mixed -- design; five bounded moves proposed `2026-08-26` from the sibling reading, each one round of the panchanga, none seated
**Kin:** [`../external-research/20260826-021135_caravan-read-against-the-optimization-spine.md`](../external-research/20260826-021135_caravan-read-against-the-optimization-spine.md) -- [`20260826-001744_the-bound-in-the-shape.md`](20260826-001744_the-bound-in-the-shape.md) -- [`20260826-001747_the-wafer-rehearsed-in-software.md`](20260826-001747_the-wafer-rehearsed-in-software.md)

## The design stance

The sibling reading found the spine already half-native: `mask.rye` carries a bound in its
shape, `roster.rye` derives rather than duplicates, `queue.rye` reads the medium rather than
counting rings. The rearchitecture therefore accretes -- it names the pattern each mechanism
already lives, promotes it to a law of the room, and adds the witness that holds it there.
Five moves, each sized to one round, each with its falsifier. Nothing here rewrites a rung;
dated rungs keep every line they proved.

## Move one -- every wrap site says which wrap it is

The queue's head and tail advance over a bounded region, and advance means wrap. The
bound-in-the-shape essay's rule seats here as a room law: **wrap where the quantity is
genuinely periodic, assert where it is linear, and every wrap site carries an `// invariant:`
comment naming which of the two it is.** The move is a survey-and-comment round over the
ring-shaped rungs (`queue.rye`, `notify.rye`, `roundtrip.rye`, `serve.rye`, `unprompted.rye`),
plus one grep-shaped scan that counts wrap sites without a naming comment and holds the count
at zero. Falsifier: a wrap site the scan cannot classify -- that site is a design question,
which is the point of making it loud.

## Move two -- the word-wide set becomes the room's law

`mask.rye` fits a turn's whole dependency set in one `u32` because `max_queue_len` is sixteen.
That is a fact today and a law only by luck: raise the bound past thirty-two and the shape
silently stops fitting the word. The move: a comptime assert beside the bound --
`max_queue_len <= 32`, with its why -- so the day someone wants a wider turn, the compiler
convenes the design conversation instead of the debugger. One assert, one comment, one
witness run. Falsifier: a legitimate turn wider than thirty-two phases arriving before the
wafer horizon does; then the set genuinely becomes a small graph, and the essay's own honest
line about that stands ready.

## Move three -- the drain becomes a replayable fold

The room proves each rung's property in isolation; it has never stated the whole-drain
property: **the same submissions in the same order leave the same dependents in the same
state.** The move is one witness that runs a planted submission sequence through a drain
twice and requires byte-identical final state -- the pure-fold discipline Mycelium proved one
room over, applied to supervision. Falsifier: a legitimate source of nondeterminism inside a
drain (a timestamp, an id from a counter shared across runs); each one found is either
seeded, moved out of the fold, or named as the reason the property honestly cannot hold --
and any of those three answers is worth more than the silence.

## Move four -- the region offset derives from the index

`roster.rye` derives the capability table from the declaration. The same argument reaches
memory: where a dependent's region offset is stored beside its index, the two can disagree;
where the offset is a pure function of the index and a named stride, no table exists to
drift. The move: one derivation function with its two edge asserts, the stored offsets
re-derived and compared in a witness, and the stored form retired only when the comparison
holds over every seated system declaration. Falsifier: a system whose regions are genuinely
irregular -- then the table is honest, and the witness that proved the disagreement earns
its keep by documenting why the table stays.

## Move five -- the wafer rehearsal is Caravan's far bench

The wafer-rehearsed-in-software essay proposes a bounded field of cores, coordinate-addressed,
swept deterministically. That module, when its chapter arrives, is Caravan's far scheduler
bench: a supervisor over a thousand-core field is a drain over a bigger ring, and every law
above -- wrap named, set bounded, fold replayable, address derived -- transfers unchanged.
The move this round is one paragraph in the rehearsal's plan naming Caravan as its first
consumer, so the two designs grow toward each other on purpose. Horizon honestly labeled:
the toroidal aetheric compiler the landing copy dreams toward is this bench matured --
shape the field, and the schedule follows. Falsifier: the rehearsal module seating with an
interface no supervisor can drive; the paragraph exists so that mismatch is caught on paper.

## What holds it honest

Each move lands with its witness in the same round or does not land. The room's own
`ladder_checks.rye` pattern -- one body, the rung handed in -- is how the new scans avoid
becoming forty-seven copies of themselves. And the reading beside this page stays the
authority on what was actually found in the sources; where this design says "already
native," the citation lives there.
