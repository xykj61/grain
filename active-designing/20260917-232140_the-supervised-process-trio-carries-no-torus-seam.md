# The supervised-process trio borrows a ring rather than growing one -- a third checked negative

**Stamp:** `20260917.232140`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- checked negative, no build item claimed
**Room:** vision
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`20260917-230710_mantras-weave-and-store-hold-no-torus-seam.md`](20260917-230710_mantras-weave-and-store-hold-no-torus-seam.md)
(the prior round, naming this trio as its own open item) -
[`20260826-021136_caravan-rearchitected-the-optimization-spine.md`](20260826-021136_caravan-rearchitected-the-optimization-spine.md)
(Move one, "wrap where the quantity is genuinely periodic, assert where it is linear") -
[`../.claude/rules/vocabulary-dependent.md`](../.claude/rules/vocabulary-dependent.md) (names the trio) -
[`../caravan/unhand.rye`](../caravan/unhand.rye) - [`../caravan/confer.rye`](../caravan/confer.rye) -
[`../caravan/revoke.rye`](../caravan/revoke.rye) - [`../caravan/cycle.rye`](../caravan/cycle.rye) -
[`../caravan/queue.rye`](../caravan/queue.rye)

## The one sentence this piece is for

The prior round closed Aurora and then Mantra's weave and store as control cases, and named the
supervised-process trio -- `unhand.rye`, `confer.rye`, `revoke.rye` -- as the next candidate,
already cited by name in `vocabulary-dependent.md` as the arc that earned the word *dependent*.
This piece reads all three. Each imports `cycle.rye` for its bounded hop mechanism and stops
there, keeping the arithmetic it adds beyond that entirely linear. A third checked negative, and
the first one that also shows what a genuine ring looks like sitting one file away.

## What was read, and what it measures

Read in full on this tree, `20260917.232140`: `caravan/unhand.rye` (1,070 lines), `caravan/confer.rye`
(1,511 lines), `caravan/revoke.rye` (1,419 lines) -- 4,000 lines together, grepped for `%`, `wrap`,
`ring`, `cycle`, and every `max_` constant, the same discipline the two prior rounds used.

**All three name `cycle` and lean on it for depth alone, leaving position to a straight climbing
counter.** Each opens with `const cycle = @import("cycle.rye")` and reaches for exactly one field
from it: `cycle.max_hops` (a bound on how deep a domain traversal may run) and, in two of the
three, `cycle.Verb` (the shape of one hop's instruction). Every citation of `cycle.max_hops` in the
trio sits behind an `assert` comparing a depth counter against it -- `assert(depth <=
cycle.max_hops)`, `assert(seen <= cycle.max_hops)`, `assert(index < cycle.max_hops)` -- the
bound-and-check shape throughout.

**Every file in the trio stays free of a modulo operator and of the word `wrap`.** A direct grep
for `%` and `wrap` across all three turns up comments alone. Every bounded array in the three
files -- `live: [max_in_flight]cohort.Running`, `done: [max_queue_len]Finished`, `reserves:
[max_in_flight]?Task`, and their siblings -- is addressed by a counter that climbs
(`table.held`, `table.in_flight`, `table.finished`) and is asserted against its ceiling before
every write, the identical shape `store.rye` and `weave.rye` carried in the prior round. `confer.rye`
adds one linear byte accumulator, `out.bytes[out.len] = word[b]`, bounded by `max_words_bytes` and
indexed by its own running length alone.

**`cycle.rye` itself, read alongside the trio for the first time this round, carries the same shape
the trio borrows.** `max_hops` is a constant (`4`), asserted against `regions.max_regions` and
`relay.max_hops` at module init, and every one of its two call sites in the file
(`var stood: [max_hops]u32`, `assert(i < max_hops)`) is a bound rather than a wraparound index. So
the "domain lap" this tree's own summary names for `cycle.rye` is cyclic in the traversal sense
alone -- a walk that visits regions and eventually returns -- while the arithmetic underneath it
stays a straight climb rather than a variable computed modulo a period. The genuine ring the prior
rounds located sits one file over, in `queue.rye`:
`const ring: u32 = seq % max_outstanding;` (`queue.rye:224`) is the one line in the whole
114-file `caravan/` room, read across three rounds now, that actually wraps a value into a bounded
cyclic index.

## What this closes, and what it leaves

**Closed:** the supervised-process trio -- `unhand.rye`, `confer.rye`, `revoke.rye` -- reads as
bounded linear growth throughout, leaning on `cycle.rye`'s depth ceiling rather than growing a
ring of its own. `cycle.rye`, read for the first time this round rather than cited secondhand,
turns out to hold the same assert-a-bound shape as everything else this thread has checked; its
"lap" is a traversal property rather than a modulo. Three modules join Aurora's boot/handshake code
and Mantra's weave/store as control cases naming the same finding from different files.

**Left open, named rather than guessed:** `caravan/` holds 114 `.rye` files; three rounds across
this thread have now read six of them in full (`queue.rye`, `cycle.rye`, `unhand.rye`,
`confer.rye`, `revoke.rye`, plus `weave.rye` and `store.rye` in `mantra/src/`) and grepped the
room's remainder for `%`, `wrap`, `ring`, `cycle`, and `max_` at the whole-directory level in the
first round of this thread. That sweep turned up `queue.rye:224` alone. What remains unread
file-by-file is the other 108 files' internal logic past that grep: a grep proves the operator
absent, while a ring built from a hand-rolled increment and a manual reset would still read as a
ring and carry the `%` character nowhere. That gap is named plainly rather than closed by
assumption.

## The falsifier

A real wraparound anywhere in the trio or in `cycle.rye` overturns this reading -- concretely, any
array indexed by a value taken modulo a bound, or any counter that resets to zero on overflow
rather than asserting against a ceiling. The grep this piece ran stands printed above in full. A
future reader re-runs it in one line:

```
grep -n "% \|%=\|wrap\|ring\|cycle\|max_" caravan/unhand.rye caravan/confer.rye caravan/revoke.rye caravan/cycle.rye | grep -v '//'
```

**Confidence.** High that the reading is complete for these four files at this stamp -- each was
read whole rather than sampled, and every `%`, `wrap`, and `max_` citation is accounted for above.
Medium on whether the shape holds tomorrow: `unhand.rye`'s own header names live traffic under
active design (*"ring at any moment of a hop"* is header prose describing the channel's runtime
behavior rather than the file's own arithmetic), and a future field could still bring a bounded,
wrapping index into any of the three.

## Why a third checked negative earns its place

Two readings could still be an accident of which files a round happened to open; a third, landing
on the same shape from a completely different subject -- supervised process lifecycle rather than
storage or network handshake -- starts to describe the tree rather than a sample of it. The genuine
ring this thread keeps finding stays exactly where it was first located, `queue.rye`'s buffer
slot, and every neighbor checked so far borrows depth-bounding from `cycle.rye` and stops there.
A tree that only records its positive findings loses exactly this standing: the ability to say,
three rounds in, that the torus thread's remaining candidates are still worth reading rather than
already disproven by inference.

## Related

No tracked issue. This note adds zero dependency to any ship's Now line and leaves
`construction/ITINERARY.md` exactly as it stands, given the card's own tight headroom this stamp.

May the next reader who opens `caravan/`'s remaining 108 files find the grep as honest a guide as
it has been for six files running, and may the day it turns up a real second ring be a good one to
write down.
