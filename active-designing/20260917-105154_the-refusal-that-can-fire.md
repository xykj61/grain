# The Refusal That Can Fire -- Nine Moonshots Drawn From What the Torus Left

**Stamp:** `20260917.105154`
**Room:** vision -- every row below is a proposal, and each one waits for its own first witness.
**Status:** Proposed -- vision. Nothing here runs today.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Elder:** [`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md) -- the first ranked page of this lane, whose twelve rows all carry dated errata
**Kin:** [`20260917-101905_the-verdict-that-came-home.md`](20260917-101905_the-verdict-that-came-home.md) -- the reading that found this lane holds exactly one ranked elder

---

## Why a second ranked page exists

The first page of this lane ranked twelve speculative rows and then spent five days reading them.
Every row now carries a dated erratum, so the forecast is gradeable, and
`tools/fixtures/r/rank_outcome_scan.sh` grades it. Run on this tree at `20260917.105154`, it
answers two things that point in opposite directions.

**The ranking worked.** Rank against read order reads Kendall tau `0.9556` and Spearman rho
`0.9879` over the ten rows whose erratum was their own first witness, with 44 concordant pairs
against 1 discordant. The ranking's stated operand was startability -- *what a lane can start on
this pier, with no new hardware, this month* -- and the lane started them in very nearly the order
it wrote down.

**The falsifiers did not.** `falsifier_faulted` reads **10 of 12**, a share of `0.8333`: six were
structurally incapable of firing, three were already settled so that firing would discriminate
nothing, and one was aimed at the wrong subject. Three claims stood, one was blocked by the pier,
and eight were altered by their own readings.

**Both figures are FREE** -- the elder page is living and may gain an erratum -- so run
`sh tools/fixtures/r/rank_outcome_scan.sh` rather than reading them here.

**So the second page inherits a discipline rather than a subject.** A Gauge Field row carries a
claim and a falsifier, and the elder's measurement says the claim half is the easy half. Every row
below therefore names **the reading that would fire its falsifier**, and names it as a command or
as an instrument this tree already owns. A row whose falsifier has no reachable reading is a row
this page declines to write.

**And the subject moved, because the measurements moved it.** The elder page asked what a *shape*
buys. Its readings answered that a shape buys little: the torus fold clustered nothing
(chi-squared `58.50` against a critical `103.51`), the privilege radius admitted 48 conferrals the
lattice refuses, and a 2 x 2 torus and a 2 x 2 mesh were proven one graph. What held were the rows
stating a **bound** or a **refusal** -- the wrap that is the budget, the trap that declines a
missing bound, the quorum that meets rather than floods. This page follows the surviving half.

---

## The nine, single-stranded

### 1. The wrap under a second writer

**Claim.** The ring's circumference bounds *memory* rather than only the index, and a second writer
is what proves the difference. A reader holding a page from a spent lap is refused by the page's
own lap tag, and that refusal holds while another thread writes.

**First witness.** Two Rye threads over one `tools/rye/wrap_ring.rye` ring: a writer advancing
the head and a reader holding a page across a full circumference, with the lap-tag refusal asserted
on the reader's side.

**Horizon.** One to two weeks on this pier.

**Assumptions.** Rye compiles a second thread here today; the lap tag is written before the page
body and read after it.

**Falsifier.** The reader accepts a page the writer has already overwritten, which would show the
lap tag orders writes rather than guarding them.

**The reading that fires it.** `tools/w/wrap_ring_witness.rish` extended with a concurrent leg:
the reader's assert either refuses or does not, and the exit code says which. The elder row's own
erratum names this gap in its own words -- *no second writer thread ever runs, so the falsifier is
answered by the lap tag rather than by concurrency.*

**Confidence.** Medium-high. The single-threaded half is GREEN on metal; the claim that remains is
precisely the one the first witness could not reach.

### 2. The quorum that meets, stated as a quorum

**Claim.** Comlink's announce-and-query pattern is a **quorum system** whose cost is the square
root of the node count, and naming it that way is worth more than the coverage it never had. An
announce along a row and a query along a column intersect in exactly one node.

**First witness.** A three-node fixture over `tools/fixtures/b/bearing_quorum_scan.sh`'s arithmetic,
carried onto real Comlink message passing: one announce, one query, one proven intersection, and a
refusal when the grid is a path rather than a cycle.

**Horizon.** Three to six weeks, after the Comlink message seam is stable.

**Assumptions.** Nodes are addressable by a two-coordinate name; the grid stays a cycle in both
axes.

**Falsifier.** A query finds no announcer where the arithmetic says the row and column meet, which
would show the addressing rather than the geometry decides delivery.

**The reading that fires it.** `sh tools/fixtures/b/bearing_quorum_scan.sh` already reads the
intersection as exactly **one** for all **1,360** distinct cases at four grids; the witness fires
the falsifier the first time a real node pair disagrees with that count.

**Confidence.** High on the cost half, which is measured. The delivery half is the open one, and
the elder erratum refuted the word *consensus* it once wore.

### 3. Instructions retired as the energy unit this pier can carry

**Claim.** Energy-saving work is measurable here today, in **instructions retired** rather than in
joules, and that unit ranks two implementations the same way a joule would.

**First witness.** A Tally-side counter reading `hw_instructions` around a named workload, reported
beside wall time, over two implementations whose wall times already differ.

**Horizon.** One to two weeks.

**Assumptions.** `perf_event_paranoid` stays at 2 or lower and the hardware counters stay readable;
the workload is deterministic in its instruction stream.

**Falsifier.** Instructions retired ranks two implementations in the opposite order from wall time
on the same pier, which would show the proxy measures a different quantity from the one a lane
cares about.

**The reading that fires it.** `sh tools/fixtures/e/energy_instrument_scan.sh` answers
`joule_source=none`, `tier=counters`, `hw_instructions=yes` on this pier, read `20260917` -- so the
unit is available and the joule is not. Two readings over one workload settle the ranking question
in one run.

**Confidence.** Medium-high. The counters are present; what stays open is whether they agree with
wall time under this pier's own load, which the elder's trial row measured at a baseline spread of
**16.7 to 54.8 percent**.

### 4. The admission gate that keeps utilization inside its proven band

**Claim.** Caravan can refuse a subscription that would push a parked queue past the utilization
its own closed forms permit. The entry conditions are already derived: utilization at or under
`0.625`, and a latency budget of at least three sector-spans.

**First witness.** A Caravan admission check that reads the declared arrival and service rates of a
pending subscription, computes the resulting utilization, and refuses with a named error above the
band.

**Horizon.** Two to four weeks, after the subscription seam declares its rates.

**Assumptions.** A subscription declares an arrival rate; the service rate is measurable or
declared; the three closed forms in `tools/rye/duty_cycle_backlog.rye` hold for the real queue.

**Falsifier.** A subscription admitted inside the band still exceeds the parked bound
`S * (1 - rho)`, which would show the closed forms describe the tick loop rather than the queue.

**The reading that fires it.** `tools/rye/duty_cycle_backlog.rye` proves the three forms against a
tick loop today; the gate fires its falsifier the first time a real queue crosses the bound while
the check reads green.

**Confidence.** Medium. The arithmetic is proven and the operand is the open half -- a declared
arrival rate is a thing this tree does not yet ask a subscription for.

### 5. The key that declares which property it sold

**Claim.** A Tablecloth key can carry a **declared locality budget**, and the declaration is what
makes the trade honest. Locality, evenness, and confidentiality are one quantity read three ways,
so a key that buys neighbour-finding sells grouping-resistance by exactly that much.

**First witness.** A key constructor taking a locality parameter between 0 and 1, with the three
readings printed beside each other at each setting: cell distance for same-room pairs, chi-squared
evenness, and an observer's room-placement share.

**Horizon.** Three to six weeks.

**Assumptions.** The three readings stay computable over the same population; a key's locality is
tunable rather than binary.

**Falsifier.** A setting exists where all three readings improve together, which would show the
three are separable and the one-quantity finding was an artifact of the two keys measured.

**The reading that fires it.** `sh tools/fixtures/l/locality_key_scan.sh` reads all three today at
the two extremes -- prefix key at cell distance `0.410` with chi-squared `13134.05`, digest key at
`15.693` with `79.05` -- and a middle setting that beats both on every reading fires the falsifier
in one run.

**Confidence.** Medium. The extremes are measured and the interior is the guess; the falsifier is
cheap and would be decisive.

### 6. Placement by file rather than by module

**Claim.** Aurora's placement map wants **files** as its unit. Every assignment of modules to nodes
overflows a node at either grid the elder row named, since `caravan` alone is 40 percent of the
tracked Rye bytes and `6.43x` an equal sixteenth, while the largest single file is a quarter of a
node's share.

**First witness.** A file-level placement over the static import graph read as a lower bound on
coupling, with the node capacity term enforced and the gain measured against a
node-occupancy-matched random baseline.

**Horizon.** Four to eight weeks; the arithmetic runs today and the board does not exist.

**Assumptions.** The static import graph tolerates the measured structure drift; capacity is a byte
count; a file is indivisible.

**Falsifier.** A file-level layout under the capacity term places no better than the
occupancy-matched baseline, which would show the import graph carries no usable signal at file
granularity.

**The reading that fires it.** `sh tools/fixtures/a/aurora_placement_scan.sh` already reads the
module-level gain share at `0.8574` and shows it falling to `-0.1057` under total structure drift,
so the baseline and the drift tolerance are both in hand; the file-level run is the new reading.

**Confidence.** Medium. The capacity finding is measured and forces the unit; whether the signal
survives the finer granularity is genuinely open.

### 7. The lattice height as the hop bound

**Claim.** Caravan's privilege is a Boolean lattice rather than a line, and what a bounded-hop
model wants from it is the **height**. A conferral chain is bounded by the number of rights, which
is a maximum stated by construction.

**First witness.** A conferral-chain checker reading `caravan/capabilities.rye`'s `u8` rights mask,
refusing a chain longer than the popcount of the full mask, proven from both sides.

**Horizon.** Two to four weeks.

**Assumptions.** Rights stay a fixed-width mask; a conferral adds rights rather than replacing
them.

**Falsifier.** A lawful conferral chain longer than the lattice height exists in the `caravan/`
room, which would show conferral removes rights as well as adding them and the height bounds
nothing.

**The reading that fires it.** `sh tools/fixtures/c/capability_lattice_scan.sh` reads the ten masks
the room constructs and finds **32 of their 45 unordered pairs incomparable**; a chain walk over
the same masks either exceeds the height or does not.

**Confidence.** Medium-high. The lattice reading is measured and the height is arithmetic; the open
half is whether real conferrals ever shorten a mask.

### 8. The minimum detectable effect, declared before the trial

**Claim.** A performance claim on this pier carries a **minimum detectable effect**, and stating it
is what makes a single trial admissible. Below roughly a fifth, one trial here cannot tell an
improvement from the baseline's own spread.

**First witness.** A trial harness that takes a declared effect size, reads the baseline spread at
the trial's own workload size, and refuses to report a verdict when the effect sits inside the
spread.

**Horizon.** One to two weeks.

**Assumptions.** The baseline spread is measurable per workload; the pier's load average is
recorded beside each reading.

**Falsifier.** A declared effect inside the measured spread is nonetheless recovered by repeated
trials at a rate better than chance, which would show the spread overstates what a single reading
hides.

**The reading that fires it.** `sh tools/fixtures/w/workload_trial_scan.sh` measured a zero-change
workload's baseline spread at **16.7 to 54.8 percent** of its median across eight readings, with
**40 to 100 percent** of zero-change trials landing inside the band; a repeated-trial run at a
declared sub-band effect either recovers it or does not.

**Confidence.** High. The spread is measured on this pier, and the refusal it motivates costs one
comparison.

### 9. The slice that pays for its own wake

**Claim.** Turning one cadence guard a lap costs less total work than one whole cadence pass at
equal coverage over the window, because a pass pays every guard's fixed startup at once while a
slice spreads it and skips nothing.

**First witness.** Instructions retired and wall time for 87 single-slice laps against one whole
cadence pass, both over the same roster, reported per guard and in total.

**Horizon.** Two to four weeks; the slice already runs and the measurement does not.

**Assumptions.** The roster's cadence tier stays near its current size; a guard's cost is dominated
by its own run rather than by the launcher.

**Falsifier.** The slice schedule's total instructions over a full rotation exceed one whole pass,
which would show the per-launch fixed cost dominates and a pass is the cheaper shape.

**The reading that fires it.** The roster reads **87 cadence** guards against **290 lap** guards at
`20260917`, by `awk '/^guard /{g=$2} /^ *tier /{print $2}' construction/standing-equipment.kyri |
sort | uniq -c` -- a **FREE** figure, so run the command. Two timed runs settle the comparison.

**Confidence.** Medium. The shape is already chosen and running; what is unmeasured is whether it
is cheaper as well as fairer, and the answer could go either way.

---

## The ranking

Ranked by what a lane can start on this pier, with no new hardware, this month -- the same operand
the elder page used, kept deliberately, so the two forecasts are comparable.

| Rank | Row | Why here |
|---|---|---|
| 1 | 3. Instructions retired as the energy unit | Counters are readable today; gives every later row a unit |
| 2 | 8. The minimum detectable effect | The baseline spread is already measured; the refusal costs one comparison |
| 3 | 9. The slice that pays for its own wake | The slice already runs; only the timing is missing |
| 4 | 1. The wrap under a second writer | One green witness away from its own open half |
| 5 | 7. The lattice height as the hop bound | Reads bytes the `caravan/` room already carries |
| 6 | 5. The key that declares its budget | The two extremes are measured; the interior is one scan |
| 7 | 4. The admission gate | Arithmetic proven; the declared rate is a seam change |
| 8 | 6. Placement by file | Runs in arithmetic; the finer granularity is the open half |
| 9 | 2. The quorum that meets | A three-node fixture is cheap; the Comlink seam is not ready |

---

## The one that goes first

**Row 3, instructions retired as the energy unit.** It goes first for the reason the elder page's
row 6 was ranked third and then blocked: this lane has wanted an energy unit since `20260910`, and
the joule is unavailable here while the counter is present. Every other row that compares two
implementations wants a unit, and wall time on this pier carries a spread of up to half its own
median. A counter that agrees with wall time on ranking gives the lane a reading that survives a
loaded pier, and a counter that disagrees is a finding worth more than the row.

## What would make this page wrong

**The page's own falsifier, stated as one reading.** If `rank_outcome_scan.sh --page` run on this
page a month from now reports `falsifier_faulted` above `6 of 9` -- worse than half, where the
elder read `10 of 12` -- then naming a reading beside each falsifier bought nothing, and the
discipline this page inherits is decoration.

That reading is available the day this page's rows carry errata, by the instrument that graded the
elder:

```
sh tools/fixtures/r/rank_outcome_scan.sh --page active-designing/20260917-105154_the-refusal-that-can-fire.md
```

**And the elder's own limit closes with it.** `tools/fixtures/f/falsifier_verdict_home_scan.sh` reads
`elders_distinct=1` today, so one ranked page is the whole evidence that a position keeps better
than a spelling. A second page under the same door key is the first real test of that sentence, and
this is it.

May every claim here meet a reading that can tell it apart from its own shadow.
