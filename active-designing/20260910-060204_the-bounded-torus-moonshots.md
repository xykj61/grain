# The Bounded Torus -- Twelve Moonshots for the Diffuser Lane

**Stamp:** `20260910.060204`
**Room:** vision -- a proposal page. Every line below is a proposal, and each one waits for its own first witness.
**Status:** Proposed -- vision. Nothing here runs today.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri
**Row 6 erratum:** `20260911.081019` -- row 6 was ranked third on *one host read away*, and the read says no. `tools/fixtures/e/energy_instrument_scan.sh` answers `joule_source=none` and `tier=counters` on this pier, so the millijoule witness cannot be built here. The counters-tier reshaping, its measurement, and its witness stand at [`20260911-081019_the-unit-this-pier-can-carry.md`](20260911-081019_the-unit-this-pier-can-carry.md). Every other word on this page is kept as written.
**Row 9 erratum:** `20260911.190217` -- row 9 was ranked fifth at *one to two weeks* on *a fake clock is enough for the first witness*, and the clock is not enough. Its proposed first witness prints parked and running sector counts, which are properties of the parking rule; its falsifier is about BACKLOG, which needs an arrival rate and a service rate the clock holds nowhere -- so that witness stays green whatever the falsifier does. `tools/rye/duty_cycle_backlog.rye` supplies the missing terms and proves three closed forms against a tick loop: a park stays under `S * (1 - rho)`, it drains in `k * rho / (1 - rho)` spans, and the worst wait is `k` spans with utilization entering it nowhere. So row 9's own *3 of 8* states two entry conditions -- utilization at or under 62.5 pct, and a latency budget of at least three sector-spans. The reading stands at [`20260911-190217_the-clock-that-could-not-hear-the-queue.md`](20260911-190217_the-clock-that-could-not-hear-the-queue.md). Every other word on this page is kept as written.
**Row 10 erratum:** `20260911.111917` -- row 10 was ranked fourth at *three to six weeks*, and it already stood. Measured through `glow/bin/glow_run` on this pier: a trap written with no bound refuses at exit 1 with `MissingBound`, and the same trap with `32` written in is accepted at exit 0 -- row 10's first witness verbatim, reachable because `glow/rune_bounded_trap.rye` has held the required-bound rune since `20260716`. Its falsifier also retires twice over: the dependent form `|-  (lent records)` is ACCEPTED, and of 451 tracked `.glow` sources exactly two carry a trap, both fixtures, so there is no real Glow loop to falsify against. What was genuinely open is the gate's third cell, now closed by `tools/g/glow_trap_bound_witness.rish`. The reading stands at [`20260911-111917_the-loop-that-already-refused.md`](20260911-111917_the-loop-that-already-refused.md). Every other word on this page is kept as written.

---

## What this page is

Twelve ideas sit here, one to a row. Each carries a claim, a smallest first witness, a horizon,
the assumptions it rests on, the fact that would falsify it, and a plain confidence. Each row
stands alone, so a lane can take any one of them and leave the other eleven where they are.

The lane's shape is a torus. A torus is a surface that wraps in two directions, like the skin of
a doughnut. Walk far enough along it and you arrive where you began. Three properties follow, and
all three serve this tree's existing discipline. Distance on a torus is bounded, so a coordinate
system built on one has a maximum by construction. Every path returns, so a proof written on one
has a period. And a torus has two angles rather than one, so a name and a privilege can travel on
separate axes.

The complementary shape is polar. Polar coordinates name a point by radius and bearing. Where
Cartesian coordinates ask *how far along each wall*, polar asks *how far out, and which way*.
That question fits a supervision tree, where distance from the root already means something real.

**One sentence of honesty before the twelve.** This page proposes; witnesses decide. A claim here
enters the checkable room the day a witness on metal binds it, and stays here until then.

---

## The twelve, single-stranded

### 1. The wrap is the bound

**Claim.** Working memory is a torus of fixed circumference C pages. The TAME bound and the period
of the ring are one number rather than two, so a reader who knows the circumference knows the
budget.

**First witness.** A Rye ring buffer of C pages whose wrap is asserted at the seam: the index after
C steps equals the index at step zero, and the assert says so out loud.

**Horizon.** One week on this pier.

**Assumptions.** Rye compiles here today; C is a comptime constant; the buffer holds fixed-size
pages.

**Falsifier.** The assert holds while a second writer overwrites a page a reader still holds, which
would show the wrap bounds the index alone rather than the memory.

**Confidence.** High. The mechanism is a ring buffer, which is ordinary; the claim it carries is
that the ring's period IS the declared bound, and one witness settles that.

### 2. Caravan as pole

**Claim.** The process graph reads in polar coordinates. Radius is privilege -- 0 supervisor,
1 Pond, 2 desk, 3 wire -- and angle is capability class. A message names a hop `(dr, dtheta)`, and
the supervisor refuses any hop past the declared maximum.

**First witness.** One hop table, 16 rings by 8 sectors, with every legal hop marked and the
refusal path proven from both sides.

**Horizon.** Two to four weeks, as a table and a checker ahead of any Caravan change.

**Assumptions.** Privilege in Caravan is already ordered; capability classes are countable and
number eight or fewer at this stage.

**Falsifier.** A real supervised process needs a privilege that sits between two rings, which would
show privilege is a lattice rather than a line.

**Confidence.** Medium. The radius half rests on an order Caravan already keeps. The angle half is
the guess.

### 3. Cyclic topos

**Claim.** A proof that returns to its start state is a loop with a declared period P, and its log
stays size P forever. Witnesses become cycles rather than lines.

**First witness.** One existing witness rewritten so the hash of its exit state equals the hash of
its entry state, printed as a Meter row.

**Horizon.** One week on this pier, using a witness the tree already runs.

**Assumptions.** The chosen witness owns its own state; its state is hashable; its teardown is
already complete enough to return.

**Falsifier.** The exit hash differs from the entry hash for a witness that passes, which would
show the witness leaves residue and the cycle claim covers the report rather than the state.

**Confidence.** High for one witness, low for the class. One green cycle proves one witness cycles;
a general law needs many.

### 4. Aether as falloff field

**Claim.** Listening has a radius. Intensity falls with distance -- 1/r, chosen on `20260910` for
this first pass -- and rows beyond the radius stay cold.

**First witness.** A roster scan that wakes only the rows within path-distance R of the touched
row, with the woken count and the wall time both printed.

**Horizon.** Two weeks, as a scan-level experiment beside the existing roster.

**Assumptions.** Path distance between roster rows is computable and cheap; the roster has real
locality to exploit.

**Falsifier.** The woken set at any useful R covers most of the roster, which would show the roster
is dense and a radius buys the same work under a new name.

**Confidence.** Medium. The saving depends entirely on locality that this page has yet to measure.

### 5. Tablecloth on a torus

**Claim.** The hash space folds onto a 2-torus, so names that sit near each other in the fold sit
near each other in storage.

**First witness.** A 256 by 256 toy cloth, standing beside the store rather than inside it, with
the neighbour distance for a sample of names reported.

**Horizon.** Two to three weeks for the toy.

**Assumptions.** A fold from the hash space onto two axes exists that keeps the distribution even;
the toy stays a fixture and touches the real store on a later word.

**Falsifier.** The fold clusters real names into a few cells, which would trade lookup evenness for
adjacency at a price the store declines.

**Confidence.** Medium-low. The idea is elegant, and evenness under a real name distribution is the
open question.

### 6. Joules as a Tally unit

**Claim.** Energy joins bytes as a bounded quantity. A lap declares millijoules the way it declares
allocations, in the same sentence.

**First witness.** One Rye run wrapped in a RAPL read, printing a Meter row that carries
millijoules beside bytes and wall time.

**Horizon.** One to two weeks, given a host that exposes RAPL.

**Assumptions.** This pier's CPU exposes RAPL counters to a reader with the permissions we have;
the counter resolution is fine enough for one lap.

**Falsifier.** Two identical runs report millijoules that differ by more than the effect any lap
would try to measure, which would put the counter below the resolution the claim needs.

**Confidence.** Medium-high for the reading, low for the bound. Reading energy is mechanical;
choosing a ceiling anyone would keep is the harder half.

### 7. Aurora as a small torus of cores

**Claim.** Aurora targets a 4-core or 16-core network-on-chip whose topology Grain knows to be a
torus, so placement and routing are computable ahead of time.

**First witness.** A placement map: which module sits on which node, and the hop count for every
pair, written as a paper artifact.

**Horizon.** Paper until a board exists, which is a year or more out.

**Assumptions.** A board of this shape becomes reachable; the module set is stable enough to place.

**Falsifier.** The reachable boards are mesh rather than torus, which would leave the wrap-around
hops the map depends on unavailable.

**Confidence.** Low, and honestly so. This one is the furthest from metal.

### 8. Mycelium that does not flood

**Claim.** Consensus routing travels on polar bearings. A node announces along a meridian and
confirms along a parallel, so message count grows with the perimeter rather than the area.

**First witness.** A three-node fixture where one packet is withheld and the refusal comes back
GREEN, proving the protocol reports the gap rather than papering over it.

**Horizon.** Three to four weeks for the fixture.

**Assumptions.** Nodes carry stable coordinates; the network stays small enough that a fixture is
meaningful.

**Falsifier.** The withheld packet leaves two nodes agreeing on different states with both
reporting success, which would show the bearing scheme hides a partition.

**Confidence.** Medium. The fixture is cheap; the general routing claim is a research question.

### 9. Seasonal duty cycle

**Claim.** Compute sleeps by sector of day. On a torus, "which sector is dark" is a coordinate
rather than a schedule, so parking work is arithmetic.

**First witness.** A fake clock that parks 3 of 8 sectors, with the parked and running sector counts
printed each tick.

**Horizon.** One to two weeks with a fake clock; longer for anything that touches a real one.

**Assumptions.** The workload tolerates delay; a fake clock is enough to prove the parking logic.

**Falsifier.** Parked sectors accumulate a backlog that the waking sectors take longer to clear
than the parking saved, which would make the cycle a deferral rather than a saving.

**Confidence.** Medium-high for the mechanism, medium for the saving.

### 10. Glow loops with circumference

**Claim.** A Glow loop declares its period the way a list declares its length. A loop that declares
none is a type error at compile time, so unbounded iteration joins the class of things the compiler
catches.

**First witness.** The Glow compiler refuses a loop written with no C, and accepts the same loop
once C is written in.

**Horizon.** Three to six weeks, inside a language this tree already owns.

**Assumptions.** Glow's type checker is the right seat for the check; every honest loop in the tree
can name a period.

**Falsifier.** A loop whose true period depends on runtime input appears in real Glow code, which
would need a dependent form rather than a constant.

**Confidence.** Medium-high. Grain owns the compiler, which is what makes this reachable.

### 11. Whitepaper -- Bounded Topos Computing

**Claim.** One paper binds the three definitions the other eleven rows lean on: what a bound is when
space wraps, what a radius is when privilege is distance, and what a topos is when every proof is a
cycle.

**First witness.** A draft whose three definitions each cite a green witness from this list, so the
paper rests on measurement rather than on itself.

**Horizon.** Six to eight weeks, and it follows the first witnesses rather than leading them.

**Assumptions.** At least two rows above go green first; the definitions survive contact with those
results.

**Falsifier.** The first two green witnesses give definitions that pull against each other, which
would mean the paper describes two ideas wearing one name.

**Confidence.** Medium. A paper written after the measurements is a summary; written before, it is a
wish.

### 12. The workload trial that pays for the rest

**Claim.** Among the eleven above, the smallest trial that touches metal goes first, and its result
funds the ordering of everything after it.

**First witness.** A one-page trial report: the workload, the measurement, the wall time, the
energy where a counter exists, and the next row the number points at.

**Horizon.** Immediately after the first green witness above.

**Assumptions.** The first trial produces a number comparable to a baseline this tree already has.

**Falsifier.** The trial's number sits inside the run-to-run spread of the baseline, which would
leave the ordering exactly where it started.

**Confidence.** High as a method, unknown as a result. That gap is the point of running it.

---

## The ranking

Ranked by what a lane can start on this pier, with no new hardware, this month.

| Rank | Row | Why here |
|---|---|---|
| 1 | 1. The wrap is the bound | Runs today in Rye; one assert carries the whole claim |
| 2 | 3. Cyclic topos | Runs today on a witness the tree already owns |
| 3 | 6. Joules as a Tally unit | One host read away; gives every later row a unit |
| 4 | 10. Glow loops with circumference | Grain owns the compiler; the seat is ours |
| 5 | 9. Seasonal duty cycle | A fake clock is enough for the first witness |
| 6 | 4. Aether as falloff field | Cheap to try; the saving rests on locality yet to be measured |
| 7 | 2. Caravan as pole | A table first, a Caravan change much later |
| 8 | 5. Tablecloth on a torus | A toy cloth stands well clear of the real store |
| 9 | 8. Mycelium that does not flood | A three-node fixture is cheap; the routing claim is deep |
| 10 | 12. The workload trial | Sequenced after the first green, by its own definition |
| 11 | 11. Whitepaper | Follows the measurements it means to bind |
| 12 | 7. Aurora on a core torus | Paper until a board exists |

---

## The one that goes first

**Row 1, the wrap is the bound.** Two rows can run on this pier this week, and row 1 wins on the
smaller surface. Its whole witness is a Rye ring buffer with an assert at the wrap, which is code
this tree writes fluently and law it already keeps: bound everything, assert the invariant, name
the maximum at construction. The claim it tests is the load-bearing one for the other eleven --
that a period and a bound can be one number a reader holds in mind at once. Every later row leans
on that sentence, so proving it early is worth more than proving it well.

Row 3 is the close second, and the reason it sits second is scope rather than merit. Rewriting an
existing witness as a cycle touches a file another lane owns, and it asks a second question at the
same time: whether that particular witness returns cleanly. Row 1 asks one question of one new
file. The lane takes the single-question door first, and row 3 follows the week after, with a
sharper idea of what a declared period buys.

**What would change this recommendation.** A host that exposes RAPL cleanly today would raise row 6,
because a unit for energy makes every later measurement comparable. The reading is worth taking
early, and it stays second in line while row 1 is one file away from green.

---

*May the circumference stay honest, and may the first assert land green.*
