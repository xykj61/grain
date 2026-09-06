# The Fence With No Post on the Time Side

**Stamp:** `20260905.232224`
**Language:** EN
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Voice:** Kyri
**Room:** Proposed -- the census is checkable and runs; every reading it licenses about
energy stays proposed ([`../context/TWO_ROOMS.md`](../context/TWO_ROOMS.md))
**Instrument:** [`../tools/fixtures/b/bound_kind_census.sh`](../tools/fixtures/b/bound_kind_census.sh)
**Crossing:** the argument is room one,
[`the-bound-that-names-a-joule`](../external-research/20260905-232224_the-bound-that-names-a-joule.md)
**Read on the air rota lap** -- Saturn, law and boundary; the sense is touch, and the lap
walks the fence line pressing each post
([`../foundations/20260826-021732_air-the-row-that-feels.md`](../foundations/20260826-021732_air-the-row-that-feels.md))

---

## The reading, in one command

```
sh tools/fixtures/b/bound_kind_census.sh
```

Measured `20260905.232224` on `82fe0b4cb7`, over 1,939 tracked `.rye` files:

| Reading | Value |
|---|---|
| distinct bound names (`max_*` / `min_*`) | **622** |
| declaration sites for those names | **2,169** |
| names bounding **extent** -- bytes, lengths, capacities, counts | **591** (95.0%) |
| names bounding **work** -- looks, turns, runs, retries, steps | **25** (4.0%) |
| names bounding a **duration** | **3** (0.5%) |
| names bounding a **rate** -- work per unit time | **3** by name, **0** on reading |
| names bounding **energy** | **0** |

**Why the unit is the distinct name.** Caravan re-exports one bound through its rung ladder,
each rung deriving it from the rung below, so `max_patience_looks` alone stands at 46 sites.
Counting sites would measure the ladder; counting names measures how many separate decisions
the tree has made. The ratio, 3.5 sites per name, is reported so the difference is visible
rather than argued.

## The three rate names, read by hand

The census classifies by **name**, never by reading the code a bound guards, and it says so
before it prints a number. So the three narrow classes are enumerated with their declaring
file, and each was opened:

| Name | File | What it actually bounds |
|---|---|---|
| `max_period_stamp` | `pond/apps/entity_books_period.rye` | **32** -- the length of a stamp *string*. An extent bound wearing a time-flavored name. |
| `max_rate` | `lotus/clock.rye` | **192000** -- the highest sample-rate *field value* a Clock admits, so a conversion cannot overflow. |
| `max_sample_rate` | `lotus/wav.rye` | **768000** -- the same ceiling on a WAV header field, refusing a wild rate at the edge. |

**All three bound something other than a repetition per unit time.** Two are field-value
ceilings guarding an arithmetic overflow, and one is a string length. So the honest reading of
the rate column is **zero of 622**, and the three name-matches are exactly the false-positive
class the instrument's declared limit warned about.

The three durations are `max_idle_ms` (a ceiling on how long an idle *test* may run),
`max_linger_ms` (how long a reap waits before it names a hang), and `min_elapsed` -- which on
reading is a local expected-floor computed inside a poll witness rather than a published bound.
**One published duration bound stands in the whole tree**, and it is Caravan's.

## The finding the tree's own comments make for me

Two work bounds were read in full, and both say plainly what they are for.

`caravan/harvest.rye`:

> *The most sweeps one readiness turn takes before it names a hang. Enough sweeps to cover the
> longest linger many times over, so this bound answers only a dependent that never exits at
> all.* -- `max_poll_sweeps: u32 = 8000`

`crypto/pbkdf2_sha256.rye`:

> *RFC 8018 allows an enormous count; this names a practical bound far above any real
> deployment (WPA2 runs 4096, modern password stores hundreds of thousands) so the loop that
> iterates the PRF cites a maximum rather than trusting a caller.*
> -- `max_iterations: u32 = 1 << 24`

**Both sit deliberately high enough to stay slack in normal operation.** That is the whole
argument, written by the tree about itself before anyone went looking: a bound here answers
*can this run away* and leaves *is this cheap* for another instrument. The PBKDF2 case is the
sharpest, because there the work is the **point** -- key stretching wants a high iteration
count -- so the same number that would be an economy budget anywhere else serves as a liveness
ceiling here.

**Read this as an observation about intent.** Every one of these bounds does exactly what its
comment says it does.

## The second reading: a time number is not checked the way a byte number is

The classes above reach only constants written in TAME's declared bound form. A poll interval
usually arrives as a plain `poll_rest_ms` instead, which puts it past the first reading
entirely. The census's second leg finds every tracked Rye constant carrying a time unit outside
the bound form, then asks the same question of both populations: does the name appear on a line
that asserts or returns a named error?

| Population | Size | Appearing in an assert or a named error |
|---|---|---|
| time-unit constants outside the bound form | **45** | **11** (24.4%) |
| extent bounds, first 44 of the `*_bytes` / `*_len` / `*_size` families | **44** | **40** (90.9%) |

**The proxy, named before its numbers.** This is a text test, and an assert *about* a constant
reads the same to it as one that merely mentions the name beside another. What makes the
reading worth taking is that the **same** proxy runs over both populations on the same tree in
the same second, so the two rates stay comparable even where either absolute number is loose.
The extent control takes the first 44 names in sort order rather than a random draw, and its
size is declared in the script as `extent_sample_bound` so it matches the time population
rather than towering over it.

**The gap is the finding: 24% against 91%.** The tree's forty-five time numbers exist and carry
weight, and three quarters of them serve as tuning values rather than bounds -- picked once,
standing outside any edge check, and failing with no name.

## Where the time axis already lives, without anyone having named it

Of 25 work bounds, **15 are Caravan's** -- more than the other five modules together
(lotus 3, crypto 3, tools 2, pond 1, mycelium 1). The one published duration bound is Caravan's
too. **Caravan has become the tree's time module by accretion**, which is the single most
useful thing this census found, because it answers the design question before it is asked.

**And the single-stranded test answers the other half.** Tally is *the bounded living space*
([`../foundations/20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md)),
where a wake or rate bound governs *time*. Seating one in Tally would braid two axes through
one module, which is exactly the braid that page refuses -- Tally would stop being a thing you
can pull out and hold whole. **A rate bound belongs elsewhere than Tally.** It belongs where
the tree already put every other time decision, and that is Caravan.

## The falsifier, written before the run, and how it fired

**Stated first:** *exhibit a named bound in authored Rye whose constrained quantity carries a
time denominator -- a rate, an interval, a duty cycle, a poll period.* Given many, the claim
falls and the interesting paper is a different one.

**It fired partly, twice, and each firing narrowed the claim into a better sentence.**

The first firing was the seven time-flavored names, which on reading became zero rate bounds,
two durations, and three field ceilings. The claim narrowed from *the tree lacks time numbers*
to **the tree holds time numbers and no time bounds**, which is both true and sharper.

The second firing was `poll_rest_ms`, found by accident while reading `max_poll_sweeps` --
proof that the tree is full of time numbers living outside the bound form. That is what the
second leg exists to measure, and the claim narrowed again, to its final shape: **the tree has
forty-five time numbers and three quarters of them are unchecked.**

## What the instrument caught in itself

**The largest catch was a standing guard reading the instrument, and it is REDS `%447`.**
`instrument_refusal` -- *a guard that cannot run its instrument refuses, and says which* -- red
on the hot pass at 2 against a ceiling of 0. Both extraction pipelines closed with `|| true`,
which discards an output-producing pass's failure, so a broken `git ls-files` and a clean tree
would report the same number. **That is this study's own subject, one level up**, written into
the instrument that measures it. Dropping the swallow was half the repair: a pipeline ending in
`sed` exits zero over empty input however badly the upstream failed, so each extraction now
CHECKS ITS OWN RESULT and refuses by name -- `no_bounds_found`, `no_extent_control`,
`no_assert_corpus`. All three are proven from the refusing side on real git repositories in a
throwaway pen, exit status agreeing at 2, because a gate that has never refused anything is a
gate in name only.

**A first draft matched `_wall` as wall-clock** and classified `max_wall_cols`, `max_wall_rows`,
and `max_walls_bytes` as durations -- Skate's surface walls, all three spatial. It matched
`_freq` and caught `max_frequency_penalty`, a sampling parameter carrying no time at all. Both
words are gone, and the reason each left is written in the script so a later hand leaves it
that way.

**A hand run under-counted by one, and the cause is worth writing down.** Piping a list through
`tee file | head -40` lets `head` close the pipe early, which truncates the tee'd file before
its last line lands. The hand count read 44 where the instrument reads **45**; the instrument
is right, and the missing name was `witness_poll_interval_ns`. Measurement beats memory, and it
also beats a pipeline written in a hurry.

**The partition invariant is what makes the totals trustworthy.** Each name lands in exactly
one class, first match wins, and the five class counts must sum to the name total for the
census to report at all -- otherwise it refuses with `verdict=partition_broken`. A regex edited
into overlapping coverage inflates a column loudly rather than quietly.

## Three things that are buildable, sized for one lap each

These are handed over rather than taken -- Caravan and Tally are other seats' territory, and
this lane writes the study.

**One -- give the forty-five time constants the bound form, on touch.** A `poll_rest_ms` becomes
a named bound with a say-why and a check at its edge, the way a byte count already is. Read
this as a ratchet rather than a red: the tree stands correct today, and the population only
falls. The census already reports the number to ratchet against.

**Two -- one wake bound in Caravan, generalizing the one that exists.** `max_linger_ms = 2000`
already bounds how long a reap waits. The same shape asks how long a dependent may hold the
machine awake in one episode, checked against a monotonic clock and refused with a named error.
Caravan already holds `poll_rest_ms`, `stagger_linger_ms`, and `dependent_poll_ns`, so the
material is present and unbounded rather than absent.

**Three -- put this census on the roster as an advisory ratchet.** It reports on every run and
stays advisory, watching `energy_names`, the verified rate count, and the guarded share of the
time population. A guard that refuses ordinary work is a guard someone turns off, and the tree
stands correct here today.

## What this study does not reach

**Whether any of it costs anything.** This lap measured no program's energy, on any device.
The census reads names in source files, and the distance between *this bound names bytes* and
*this program is expensive* is exactly the distance the companion paper keeps its argument
inside.

**Whether an unchecked time constant has ever caused a fault.** The study claims zero
instances. Forty-five numbers sit outside the discipline the tree applies to six hundred
others, and that asymmetry is the whole finding.

---

*The air lap presses each post and writes down which ones the hand goes through. This one went
through on the time side, and the fence is otherwise as solid as it looks.*
