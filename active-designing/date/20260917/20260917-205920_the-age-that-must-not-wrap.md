# Three counters, three rules -- the open question row 11 left, answered by Caravan's own code

**Stamp:** `20260917.205920`
**Room:** checkable -- every reading below is a live witness run on this pier at this stamp.
**Status:** Landed
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri

---

## The question this paper closes

[`20260917-204915_bounded-cyclic-computing.md`](20260917-204915_bounded-cyclic-computing.md) --
the paper row 11 of the bounded-torus moonshot ladder landed -- proved that a bound stated at
construction and a period stated at construction are one fact, on three independent instruments.
It closed by leaving open one further question: *should Caravan (which supervises what runs) and
Tally (which bounds what is allocated) adopt "declare the period, get the bound for free" as a
standing convention, rather than leaving it a proposal?*

That question already has an answer, sitting in Caravan's own tracked source. `caravan/dwell.rye`
counts something too, and it keeps to a different rule entirely.

## Three counters, one tree, read live

**Reading one -- a position that earns its wrap.** `tools/rye/wrap_ring.rye`, the same instrument
row 11 cited. Its own comment states the claim plainly: *the wrap IS the bound, asserted at the
seam.* Run at this paper's own stamp:

```
$ rishi/bin/rishi run tools/w/wrap_ring_witness.rish
GREEN: wrap-ring -- the period and the bound are one number, C=16
```

The index `self.written % circumference` returns to a value it has held before. That return is the
whole point. The ring's own contract reads: *whichever page you are holding stays yours for exactly
one circumference of writes.* A repeated index simply means the slot has come around to someone
else's turn. Wrapping costs the ring nothing, because its own promise only ever covers one lap.

**Reading two -- a history that keeps every step it has taken.** `caravan/dwell.rye` counts how
many runs a standing quarrel has stood through, and its own header names the reason plainly:

> *An age only ever climbs... At the bound the count holds rather than wrapping, which says AT
> LEAST this many runs and never rolls a long quarrel back to nothing.*

The function is `stood_longer`, run live at this paper's own stamp:

```
$ rishi/bin/rishi run tools/ca/caravan_dwell_witness.rish
GREEN: Caravan dwell witness passed.
```

Reading the module directly (`caravan/dwell.rye:1490-1497`):

```rye
pub fn stood_longer(before: u32) u32 {
    // invariant: an age handed in already stands within the byte that carries it
    assert(before <= max_dwell_runs);
    if (before >= max_dwell_runs) return max_dwell_runs;
    return before + 1;
}
```

`max_dwell_runs` is `255`. At the bound the function holds steady at `max_dwell_runs`, by design,
run after run. Holding steady here is what keeps a quarrel raised this morning honestly younger
than the oldest position on the wire. The comment already says why, in its own words, before this
paper restates it: an age is a claim about elapsed history, and a ring's position carries no
history at all to make that same claim about.

**Reading three -- a resource whose limit gets a refusal, and nothing else.**
`tally/region.rye`'s bump allocator advances a cursor, `self.pos`, toward a fixed `cap`, and its own
comment marks the seam where the other two conventions would apply, and states its own choice
instead (`tally/region.rye:42-44`):

```
// invariant: the length casts to u32 on the next line, so a buffer past that ceiling would wrap
// rather than refuse
assert(buf.len <= std.math.maxInt(u32));
```

The comment names wrapping as the risk being guarded against. It names refusal as the design it
keeps instead. A region's cursor stays wherever it stopped. There is no lap to complete, and the
history behind it is already spent the moment the buffer runs out. When `end <= self.buf.len`
fails, the allocator holds an assert rather than a wrapped index or a frozen maximum -- a lawful
next value simply does not exist here. A bump allocator draws on neither the ring's cyclic reuse
nor the age's preserved history. Once full, a refusal is the one honest answer left standing.

## The finding

**"Declare the period, get the bound for free" is true of exactly one of the three counters this
tree already writes, and the other two keep their own rules for their own good reasons.** The
distinguishing question is what happens, semantically, at the counter's own top:

| Counter kind | At the bound | Why | Example, read live |
|---|---|---|---|
| **Cyclic position** | wraps | the slot's old content was only ever a promise for one lap | `wrap_ring`, GREEN |
| **Cumulative history** | saturates | holding steady is what preserves the fact being counted | `caravan/dwell.rye`, GREEN |
| **Exhaustible resource** | refuses | a lawful next state, cyclic or frozen, simply does not exist | `tally/region.rye`, invariant read |

Row 11's convention -- period equals bound -- holds for the first row of this table and is answered
differently by the tree's own code for the other two. A standing convention that told Caravan or
Tally to "declare the period" for a dwell age or a region cursor would ask a real module to name a
number that its own subject never had: an age's whole meaning is that it keeps growing rather than
returning, and a region's cursor stops rather than laps.

## What decides which row a new counter belongs to

A counter belongs to **cyclic position** exactly when overwriting the value at index `i` after `P`
steps keeps every promise the counter ever made. The ring's own contract names one lap of safety and
stops there, honestly. A counter belongs to **cumulative history** when the counted quantity is a
claim about the past that stays true regardless of how much later time passes. An age can only grow;
holding it steady at a ceiling is what lets a later reader trust it as a floor rather than an exact
count. A counter belongs to **exhaustible resource** when it measures consumption of something
handed out once within the object's own lifetime. A bump allocator's arena is granted a single time,
per Tally's own garden discipline, and a refusal at its limit keeps two owners from ever sharing the
same bytes.

## Assumptions

- The three modules cited (`wrap_ring`, `caravan/dwell.rye`, `tally/region.rye`) keep reading as
  they read at this paper's own stamp; each witness stays free to move, so a later reader should
  re-run rather than cite this paper's transcript as current.
- The taxonomy rests on three examples in one tree. A further counter kind may exist in a module
  outside this reading; the paper claims coverage of what it examined alone.
- `max_dwell_runs = 255` and `circumference = 16` are the two constants read; changing either leaves
  the argument above standing, since the argument concerns the shape of the update rule rather than
  its size.

## Falsifier

**A future counter in this tree whose update rule saturates or refuses at its bound, while its
counted quantity is genuinely cyclic in the sense `wrap_ring`'s is, would refute the "why" column of
the table** -- it would mean a position-kind counter took a different row's rule for a reason this
taxonomy cannot explain. Equally, **a future counter that wraps while counting elapsed history would
refute the dwell row directly**, the same way a wrapped age would quietly understate how long a
position has stood. Either reading is checkable the way this paper's own readings are: read the
module's own comment for what it counts, then check whether its update rule matches the row this
paper assigns to that kind of counting.

## Confidence

**High for the three readings themselves** -- each is a live witness run at this paper's own stamp,
plus the module's own comment stating the reason in its own words before this paper restates it.
**Medium for the taxonomy as a closed set of three** -- three examples support three rows, and a
fourth kind of counter may yet stand in a module outside this reading.

## What this hands back to Caravan and Tally

Row 11 asked whether "declare the period, get the bound for free" should become a standing
convention. This reading supports a narrower answer: the convention holds exactly where a counter's
own comment would say "this may safely repeat," and the same module family already states its own
different choice wherever it makes one. Caravan and Tally already practice this distinction --
`dwell.rye`'s own words are "holds rather than wrapping," and `region.rye`'s own words are "wrap
rather than refuse." What a standing convention could usefully add, left for Bakery or a
Caravan-owning hand to decide, is naming the three rows of the table above as a checklist a new
counter's own header answers before its first assert is written -- so the choice among wrap,
saturate, and refuse is stated once, by name, rather than found again by reading whichever counter
came before it. That checklist belongs beside the fleet's own build road in
[`construction/ITINERARY.md`](../construction/ITINERARY.md), under the Bakery entry that already
names Caravan's toroidal scheduler and Tally's memory gardens as one build graph.

## A closing note on the method

This paper stays smaller than row 11's on purpose -- one table, three readings, entirely on
instruments already built. That is still real work: the answer to row 11's own open question was
already written, twice, in code Bakery's own ships maintain, and the task left was to read the two
together as one answer. A moonshot paper's job is sometimes to build a fresh witness, and sometimes
to point at three that already stand and name what they agree about.

May the count that keeps a history hold its ground, and the count that only marks a turn wrap
freely and often.
