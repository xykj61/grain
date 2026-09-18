# Deterministic and Degenerate -- the two promises a pen's generator makes

**Language:** EN
**Stamp:** `20260916.112900` (EDT)
**Voice:** Kyri
**Style:** Gauge, Field setting -- see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md)
**Room:** mixed -- the arithmetic and the measured periods are checkable against
[`../tools/a/awk_lcg_exact_witness.rish`](../tools/a/awk_lcg_exact_witness.rish); the claim about
how the fault class generalizes is a proposal
**Status:** Living -- ledger row `20260916.112900`
**Lens:** [`20260823-204456_single-stranded.md`](../foundations/20260823-204456_single-stranded.md) --
two promises braided into one word

---

## The finding in one paragraph

A pseudorandom generator inside a test pen makes two promises, and this tree had a word for only
one of them. The first is **reproducibility**: every host draws the same sequence, so a leg that
passes here passes there. The second is **variety**: the sequence visits enough distinct states
that the population it plants means what the leg says it means. Those are different properties,
they fail independently, and a comment that says *deterministic* claims the first alone.
`tools/fixtures/t/torus_fold_control.sh` kept the first perfectly while the second had quietly
gone, and every instrument in the tree read past it.

## What was measured, and how

**Observation.** The line read `seed = (seed * 1103515245 + 12345) % 2147483648`, evaluated by
awk. awk carries every number as an IEEE-754 double, which holds integers exactly up to
2^53 = 9,007,199,254,740,992 and rounds above it. The largest intermediate this line produces is
`1103515245 * 2147483647`, which is 2.37e18 -- **263 times past the exact range**.

**Observation, on metal `20260916` on this pier, gawk 5.4.1.** Running the rounded map from its
own seed and recording the first repeated state:

| Reading | Rounded map | Exact generator |
|---|---|---|
| tail before the cycle | 3,253 draws | 0 |
| cycle length | 10,466 | 2,147,483,648 |
| distinct states reachable | **13,719** | 2^31 |
| consumed byte `int(seed/65536) % 256` differing from exact | **4,079 of 4,096 draws** | -- |

**Observation.** The pen draws 2,048 values -- 512 planted names at four draws each -- and 2,048
is inside the tail of 3,253. That is why every leg stayed green, and the margin is one growth
of the plant wide.

**Inference.** The rounded map is a different and far smaller object that shares a first
line of source with the generator its comment names, rather than a weakened version of it.

## The half that never failed

**Observation.** IEEE-754 specifies multiplication, addition, and `fmod` exactly: each rounds once,
to the nearest representable double, by a rule every conforming implementation shares. So the
rounded stream is reproducible on any awk carrying doubles, which is every mainstream awk.

**Inference.** The comment beside that line -- *the pen must plant the same population on every
host* -- was **true the whole time**, and the author's reasoning that led to writing a generator
by hand rather than reaching for `rand()` was sound. The fault entered one layer below the
question anybody was asking.

**Caveat, named rather than measured.** This pier carries one awk. An implementation evaluating
intermediates in x87 80-bit registers would round differently, which was an ordinary configuration
on 32-bit x86 and stands nowhere in this fleet today. Cross-implementation agreement is therefore
**unmeasured here** and asserted only from the IEEE specification.

## Why a guard could not have caught it by reading for determinism

A reproducibility check compares two runs and asks whether they agree. The rounded map passes that
check on every host, every time, forever. A variety check asks how many distinct states a map
reaches, which takes a count of states rather than a comparison of runs.

**Inference.** The two readings want two instruments, and the tree had written a comment where the
second instrument should stand. This is the shape
[`single-stranded`](../foundations/20260823-204456_single-stranded.md) names: one word, *deterministic*,
carrying two claims, so satisfying either reads as satisfying both.

## The guard that now stands, and the line it draws

[`../tools/fixtures/a/awk_lcg_exact_scan.sh`](../tools/fixtures/a/awk_lcg_exact_scan.sh) reads
every tracked shell and Rishi source for a multiply-then-mod site and sorts it into three classes.

A **fed-back** site is one where the variable assigned is the variable multiplied. Its state is
bounded by its own modulus, so the largest intermediate follows from the line alone and
the reading stays pure arithmetic: the gate compares `multiplier` against
`2^53 / (modulus - 1)` and holds sites past it at **zero**. Seven such sites in this tree stand
inside the range, the two repaired this lap among them.

An **index hash** -- `h = (i * 2654435761) % 4294967296` -- is bounded by the range of `i`, which a
scanner cannot know. Seventeen stand in the tree and are **counted and reported rather than gated**.
Printing that number is the point: a reader there can otherwise not tell an empty blind spot from
a large one.

A site within a tenth of a percent of the ratio counts as overflowing and says `borderline`, since
its verdict is one rounding wide. No site in the living tree lands in that band, so the case had to
be built in the pen to be proven at all.

**Observation, and the figure worth carrying forward.** The seven exact sites are not equally safe.
Five stand at 87x the range or better; the two in
[`../tools/fixtures/k/key_trade_control.sh`](../tools/fixtures/k/key_trade_control.sh) spell
`s * 1664525 % 4294967296`, whose largest intermediate is 7.149e15 against the range's 9.007e15 --
**1.260x of headroom**, using 79 percent of the multiplier the modulus allows. That is clear of
the band and clear of the gate, and it is the one site in the tree where an ordinary edit -- a
modulus raised to `2^33`, or a multiplier swapped for glibc's -- crosses the line. An earlier draft
of this paper claimed every site stood clear by a factor of two or more; the scan disagreed when
it was asked, which is the only reason the number above is a measurement rather than a memory.

## The guard's own first red, and what it cost to find

**Observation.** The scan reads every tracked `.sh` and `.rish` source. Its control is one, and that
control plants five overflowing generators inline -- it must, since proving a refusal needs the thing
refused. So the moment the control was staged, the live reading moved from `overflowing=0 exact=7
unread=17` to `overflowing=5 exact=8 unread=18`, and the wall reddened on arithmetic that exists only
to be refused inside a pen.

**Inference.** The author had already solved this exactly one class over. The scan's header spells
three generators to teach the rule, and a reading counting its own prose would count itself -- so a
line whose first non-blank character is `#` is read past, and the header says why. The same question
was never asked about the control, whose plants are code rather than prose.

**Observation.** This is the shape REDS `%775` booked one instrument over: a plant is a sentence that
must not be true, and a meter reading for truth cannot tell one from a claim. That row's ruling was
to **move the plant rather than the meter**, and the two alternatives here were both worse. Reading
past `tools/fixtures/` is the exclusion `%774` warned about, where a census stops measuring its own
subject to shrink a number -- 18 of this tree's 24 sites live under that path. Excluding the control
by name leaves the next control to rediscover the whole thing.

**What landed.** The plant's numerals moved into shell variables and its heredocs became unquoted, so
each pen file receives the literal arithmetic while the tracked bytes carry no `variable * digits %
digits` shape at all. The scan's pattern requires digits on both sides, which is what makes a
substituted numeral invisible to it -- a property of the pattern rather than a trick, and the control
says so on its own face so a later hand widening the pattern knows to move the plants again.

**Four legs now assert the property rather than trusting it**, and three were proven to bite by
planting a literal back into the live control and watching the wall red. The control stands at 57.

**Inference, and it is the lap's second finding.** A guard whose population includes its own control
has a failure mode no amount of care in the guard prevents, because the control's correctness
*requires* it to contain what the guard refuses. The founding fault of this paper was one word
carrying two promises; this one is one file holding two roles.

## The projection, with its falsifier

**Projection.** Over the next fifty pens this fleet writes, the fault that recurs is the **class**
rather than this arithmetic, which a wall now refuses on the lap it arrives: a property named by
one word that carries two promises, where the easy promise is checked and the load-bearing one is
asserted in a comment.

- **Horizon:** the next fifty pens, roughly a fortnight at this fleet's rate.
- **Assumptions:** the pen population keeps growing at its current rate; no lane seats a second
  variety reading in that window.
- **Falsifier:** if the next three faults booked against pen fixtures are each a single-promise
  failure -- a genuinely broken check of a property nobody had conflated -- the class is not the
  pattern and this projection is wrong.
- **Confidence:** moderate. Two firings support it -- this one, and the trap-spelling reading of
  `%769`, where *released* carried both *a removal exists* and *a refusal reaches it*. Two is a
  lantern that fired twice; it is not yet a measured rate.

## What this does not reach

**Whether a generator that stays inside the range is a good generator.** MINSTD has known lattice
structure and would be the wrong choice for anything but planting a pen population. The wall proves
the arithmetic is the arithmetic the line spells, and stops there.

**Any language but awk.** The Rye probes in this tree use `*%` wrapping arithmetic on `u64`, which
is exact by the language's own rule. The fault is specific to a language that carries integers in
floats, and awk is the one this tree reaches for from shell.

**Whether the 2,048-draw plant was ever wrong.** It was inside the tail, so the population it
planted was 2,048 distinct draws of a map that is deterministic. The leg's verdict stood; what
stood beside it was a margin nobody had measured.

---

*May the next promise we name be one promise, and may the word we give it carry exactly what we
can check.*
