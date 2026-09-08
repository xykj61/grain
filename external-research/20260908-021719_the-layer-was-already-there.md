# The Layer Was Already There, and the Meter Had Already Found the Gap

**Stamp:** `20260908.021719`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Proposed -- **mixed room**: every count below is a grep or a hand read of tracked
sources and is reproducible; the tightening proposed at the end binds nothing until a witness
takes it ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Kin:** [`20260905-232224_the-bound-that-names-a-joule.md`](20260905-232224_the-bound-that-names-a-joule.md) (the parent paper, whose second falsifier this runs) -- [`20260908-005732_the-share-that-is-not-a-property-of-the-parts.md`](20260908-005732_the-share-that-is-not-a-property-of-the-parts.md) (the third falsifier, run the lap before) -- [`../tools/fixtures/b/bound_kind_census.sh`](../tools/fixtures/b/bound_kind_census.sh) (the instrument, whose second reading this paper hand-checks) -- [`../caravan/harvest.rye`](../caravan/harvest.rye) -- [`../caravan/gap.rye`](../caravan/gap.rye)

The parent paper argued that a bound on a quantity carrying a time denominator -- how often a
component wakes -- is as ordinary a bound as one on bytes, and belongs under the same law that
already makes every allocation name a maximum. It named three ways the argument could be wrong.
The third was run the lap before this one and converted into a threshold. This paper runs the
second:

> **The runtime might already own it.** On a system where the scheduler, the kernel, or the
> runtime governs wakeups centrally, a per-component bound duplicates a decision made better one
> layer down, and duplicated decisions drift apart. *Falsifier: exhibit the layer that already
> bounds wakefulness, and show a component held under it.*

**The exhibit exists, and it is in Caravan.** Finding it changes what the parent paper should ask
for, while leaving intact whether it should ask. The lap then turned the same question on this lane's
own instrument and found the gap already measured -- and understated.

## The exhibit the falsifier asked for

**Observation.** Caravan bounds wakefulness in two places, by two mechanisms.

**The first is causal suppression.** `caravan/gap.rye` declares `Wake`, an enum of two readings,
and line 277 is the whole of it:

```
if (pending == 0 and wake == .when_moved) return queue.nothing_new;
```

Under `when_moved` a pass that moved nothing rings nobody; under `every_pass` it rings anyway, so
a wake swallowed by a fall is replaced by the attempt that returns. Six tracked modules read a
wake word off their argument list and hand it down -- `concurrent`, `cohort`, `decline`, `gap`,
`inflight`, `standby` -- and the same six render one back out for the dependent they spawn.

**The second is a rest interval.** `caravan/entrust.rye:145` declares `pub const note_rest_ms: u32
= 2`, and forty-five further modules re-export that value by naming the rung below them, so one
decision reaches the length of the ladder without being made twice. Fourteen call sites across six
files rest on it:

```
std.Io.sleep(io, std.Io.Duration.fromMilliseconds(note_rest_ms), .awake) catch {};
```

**So the falsifier fires on its literal terms.** A layer bounds wakefulness, and components are
held under it. The ground is occupied, and the parent paper must argue on it.

## The shape the parent paper proposed is already written, once

**Observation.** `caravan/harvest.rye:120-134` states a work bound beside the rest interval and
asserts the two against a duration at compile time:

```
pub const poll_rest_ms: u32 = 2;
pub const max_poll_sweeps: u32 = 8000;

comptime {
    // invariant: the patience of a turn covers the longest linger allowed
    assert(max_poll_sweeps * poll_rest_ms > max_linger_ms);
}
```

Read it as a rate and it is the pair the parent paper asked for. A rest of 2 ms is a ceiling of
500 sweeps per second, a sweep count of 8,000 is a ceiling on the total, and the product is
asserted to cover the longest linger the module permits -- 16,000 ms against 2,000. Each comment
says why its number is that number, which is the habit the parent paper wanted the bound to carry.

**Inference.** The proposal was never novel. It was written once, in one module, by a hand that
reached for it because a readiness turn made the need plain, and every other module went on resting without it.

## The meter had already found the gap, and it understates it

**Observation.** `tools/fixtures/b/bound_kind_census.sh`, built in this lane, already carries a
second reading for exactly this. Its own header states the reason: *"A poll interval is rarely
written that way -- it is a plain constant like `poll_rest_ms` -- so the first reading cannot see
it at all."* It gathers every tracked Rye constant carrying a time unit outside the `max_`/`min_`
form, gathers a same-sized control from the `*_bytes`, `*_len`, `*_size` families, and asks one
question of both: does the name ever appear on a line that asserts or returns a named error?

Run `20260908.021719`:

| Population | Names | On a guard line | Share |
|---|---|---|---|
| Time constants outside the bound form | 47 | 11 | 23.4 pct |
| Extent control, same size | 44 | 40 | 90.9 pct |

**The census declares its proxy loose in its own comment** -- *"A name on an `assert(` line may be
the subject of the assert or merely mentioned beside it, and the scan cannot tell them apart"* --
and defends the reading on the ground that the same proxy runs over both populations, so the two
rates stay comparable. **This lap read both sides by hand to test that defence, and it does not
hold: the proxy is loose on one side only.**

**All eleven time hits, read at their line.** Five sit beside a guard that constrains something else entirely.
`allpasses_ms` and `combs_ms` appear on `.len > max_stages` checks -- an array length, not a span.
`want_ms` is an expected-value fixture in a round-trip check, `huge_ms` a deliberately oversized
test input whose error is about a different value, and `turn_block_seconds` sits on a line whose
`return error.DateAbsent` concerns an absent object. Six are genuine: `caret_period_ms` and
`long_press_ms` carry positivity checks (the second two-sided, `> 0` and `< 60_000`),
`wire_outer_timeout_seconds` is pinned by equality, `tc_max_seconds` and `linger_ms` are ceilings
checked at an edge, and `poll_rest_ms` carries the comptime triad above.

**All forty control hits, read the same way.** Every one constrains a length or a size against the
bound it names -- `assert(path.len <= max_abs_path_len)`, `if (aad.len > max_aad_bytes) return
error.AadTooLong`, and thirty-eight more of that shape. **The proxy is exact on this side.**

| After the hand read | Names | Genuinely guarded | Share |
|---|---|---|---|
| Time constants | 47 | **6** | **12.8 pct** |
| Extent control | 44 | **40** | 90.9 pct |

**Inference.** The gap the census reports is real and larger than reported: hand reading moves the
time side from 23.4 to 12.8 percent and leaves the control where it stood. **The asymmetry has a cause
the census itself predicted** -- its header already names the standing counterexample, *a
time-flavored name over an extent bound*. Four of the five false positives are exactly that: a
Lotus constant ending `_ms` that holds an array of millisecond specifications, guarded on its
length. The failure mode was declared, and it fires four times.

## What is buildable, with its measured effect

**One line, and it is not already built.** The census gathers with `^[[:space:]]*(pub )?const`,
which admits function-local constants. Anchoring the time leg at column zero -- `^(pub )?const` --
admits only module-level declarations, which is what a policy constant is:

| Reading | Time names | Guarded | Control names | Control guarded |
|---|---|---|---|---|
| As it stands | 47 | 11 | 44 | 40 |
| Anchored at column zero | **33** | **6** | 44 | **40** |

The four Lotus fixtures are function-local and drop out; so does `linger_ms`, which is parsed from
an argument rather than declared. **The control does not move at all**, because every extent name
in it was already module-level -- which is what shows the anchor tightens the instrument while holding the comparison fixed. One false positive survives, `turn_block_seconds`, so the anchored reading
is 6 counted and 5 read against a control of 40 and 40.

**Handed to BAKERY** as a one-pattern change to a scan that already partitions, already refuses on
a broken partition, and already enumerates its narrow classes for a hand to confirm.

**Not buildable from here.** Whether Caravan's other rest constants should each carry a
`harvest.rye`-shaped assert is that module's own design question. The ratchet class is its right home: the tree works, and a ratchet is what carries something toward uniform.

**Projection, with its parts named.** *Horizon:* one round. *Assumption:* the census keeps
counting distinct names rather than sites, so Caravan's forty-five re-exports stay one decision.
*Falsifier:* an anchored leg that lands and reports a control other than 44 and 40, which would
mean the anchor reached the comparison as well as the population. *Confidence:* high on every count
here, which are greps and reads anyone can repeat.

## What this does to the parent paper

**The falsifier fires on its terms and stops short of its purpose.** Its worry was duplication -- that a
per-component wake bound would restate a decision made better one layer down. The layer is real,
so the first half holds. The second half turns on one exact fact: **there is nothing to
duplicate, because the existing layer states almost no maximum.** A rest constant sets a wake rate
as a side effect of a sleep argument. Six of forty-seven are constrained anywhere, one of those
relates a rest to a work count and a span, and the tree's own meter reads the shortfall correctly
while understating its size.

**So the proposal survives, restated and smaller.** The tree does not need a new kind of bound. It
needs to name the bounds it already has as the maxima they already are, and to carry once more the
assert `harvest.rye` proved.

## Three ways this paper could be wrong

**The naming convention might be the point.** A constant called `note_rest_ms` tells a reader *this
is how long we rest*, faster than `max_note_wake_rate_hz` would. *Falsifier: a rename tried on one
Caravan file that its own hand reads as clearer.* Should the current name read better, the whole
repair belongs in the instrument and the source keeps every name it has.

**The hand read might be one reader's judgment.** Eleven lines and forty lines were classified by
opening each and asking whether the constant is what the guard constrains. *Falsifier: a second
reader returning a time count outside 4 to 8, or any control count below 38.* The mechanical
numbers -- 47, 11, 44, 40, 33, 6 -- hold under either reading.

**A time-shaped suffix might miss its own population.** Every count begins from a suffix and
substring list, so a constant named `heartbeat` or `refresh` with no unit in its name is outside
the reading entirely. *Falsifier: a scan reading constants by their use -- every value passed to a
sleep or timer call -- returning sites this list never saw.* That instrument reads use rather than
name, which is the same lesson this paper is making about the census.

## What this paper does not do

It stays clear of energy measurement on any device, and leaves every claim about joules to the parent. It runs one falsifier of
one parent paper, names the exhibit that falsifier asked for, and hand-checks a reading this lane
had already taken. The parent's **first** falsifier -- *name the deployment; given a roadmap
holding only mains-powered targets, this paper is enthusiasm* -- remains unrun, and is now the
last of the three.
