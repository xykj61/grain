# Bounded cyclic computing -- the paper two rows support

**Stamp:** `20260917.204915`
**Room:** mixed -- every measurement below is checkable, bound to a green witness read on this
pier at this stamp; the closing section on what the pair still owes is vision.
**Status:** Landed -- this is row 11 of
[`20260910-060204_the-bounded-torus-moonshots.md`](20260910-060204_the-bounded-torus-moonshots.md),
written at the size its own measurements support, per the recommendation in
[`20260915-212827_the-paper-that-checked-its-own-premise.md`](20260915-212827_the-paper-that-checked-its-own-premise.md).
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Style:** Gauge at the Field setting
**Voice:** Kyri

---

## What this paper is, and what it dropped

Row 11 of the bounded-torus page proposed one paper binding three definitions: a bound when space
wraps, a radius when privilege is distance, and a topos when every proof is a cycle. The
`20260915.212827` reading measured all three against the tree's own green witnesses rather than
against their own prose, and found one refuted and one unrun. This paper is the one the survivors
support: **two** definitions, not three, both about the same shape.

**Dropped: the radius.** Privilege-as-distance asked for a line -- a total order a reader could walk
step by step. `tools/fixtures/c/capability_lattice_scan.sh` reads this tree's own seated privilege
classes and finds **32 incomparable unordered pairs** and **48 over-admissions** a radius-only
checker would grant, where a line reads zero of each. A falloff needs distinct radii to grade a
population across, and `tools/fixtures/a/aether_falloff_scan.sh` reads a mapped saturation radius of
**2**, where a gradient needs at least three rungs to show a slope. Three instruments, three
independent readings, one cause: this tree's privilege structure is a lattice, not a line, so a
radius has nowhere honest to stand. The finding is kept as a refusal rather than softened into a
deferral, because a paper binding a definition three instruments refuse would be prose vouching for
something the tree's own code denies.

**Kept: the bound, and the cycle.** Both are read live below, at this paper's own stamp, on this
pier.

## The claim

**A bounded, cyclic computation is one whose state space is a closed loop of known length, so that
naming the length is the same act as naming the bound.** Two things follow from a loop rather than
from a line: the loop returns, so a computation that reaches its own start again has produced
evidence it left nothing behind; and the loop has a period, so "how much can this hold" and "how
long until this repeats" are one question asked twice.

This is deliberately smaller than a torus. A torus needs two independent axes -- the
`20260915.212827` reading already showed that the definitions this paper keeps rest on **one**
axis, the maximum among the supported definitions, while the page they came from is titled for two.
A ring is what the evidence draws; a torus is what the page proposed. This paper draws the ring.

## Definition one -- a bound is a period

**Statement.** A working set of fixed capacity C, visited by a monotonically advancing writer, has
one honest name for "how much fits": the number of writes before the writer's own position returns
to where it started. Declaring C is declaring both the bound and the period in the same breath.

**The witness.** `tools/rye/wrap_ring.rye`, a 207-line ring buffer of C pages, under
`tools/w/wrap_ring_witness.rish`. Read live at this paper's own stamp, `20260917.204915`:

```
wrap-ring: one lap of 16 returns index 0
wrap-ring: after one lap a lap-0 page is still the reader's own
wrap-ring: a page held from a spent lap is refused
wrap-ring: an index outside the ring is refused
GREEN: wrap-ring -- the period and the bound are one number, C=16
```

The ring is checked at C=16, single-threaded, in one program -- the claim is proven at one size and
one concurrency level, and generalizing past that pair is this paper's own debt, named rather than
assumed away.

**A second, independent instance of the same shape.** `glow/rune_bounded_trap.rye` -- Glow's `|-`
rune -- refuses to parse a loop with no stated ceiling (`MissingBound`) and accepts the identical
loop once a literal bound is written in. `tools/g/glow_trap_bound_witness.rish` proves this through
the real compiler driver, `glow/bin/glow_run`, rather than through the parser module alone: a bare
trap is planted, built, and run, and the driver itself refuses it by name before ever reaching the
ring-buffer question of how memory behaves. Two unrelated mechanisms -- one a buffer holding data,
one a compiler admitting source text -- converge on the same sentence: **a bound stated at
construction is the same fact as a period stated at construction.**

**A third instance, at the network's edge rather than inside one process.** `bearing_quorum`, row 8
of the moonshot page (Mycelium routing on polar bearings), reads live at this stamp:

```
cost_half=stands meet_guarantee=yes wrap_worth_one_cut=yes
```

`cost_half=stands` means message cost grows with the perimeter of the announced set rather than
with its area -- the closed-loop shape buys a real saving over a line, measured across grids of 4,
8, 16, and 32 nodes with a cost exponent read at **0.56** across the whole range and **0.52** on the
tail, both under 1.0, which is what "grows with the boundary rather than the interior" means as a
number. `wrap_worth_one_cut=yes` names the specific mechanism: closing the loop with one extra edge
is what buys the saving, over a line of the same length with the same node count.

## Definition two -- a proof that returns is a cycle

**Statement.** A witness that ends in the same state it began -- same working tree, same residue --
has proven it consumed exactly what it claimed to consume and left exactly what it claimed to
leave. The check is not "did it pass" but "did it come back to where it started," which is a
stronger question a passing witness does not automatically answer.

**The witness.** `tools/c/cyclic_witness_witness.rish`, read live at `20260917.204915`, this
paper's own run rather than a cited figure:

```
seconds=0
code=0
exit=e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
residue_paths=0
verdict=cycles
coverage: 9 behaviors, residue shown from both sides, the control's own lift proven
pass=9 fail=0
GREEN: cyclic-witness -- a returning witness is a cycle, and residue is seen and named.
```

The digest is taken over `git status --porcelain` before and after the sampled witness runs, so
"cycles" names the working tree returning to its own state, never the witness's private memory. A
write into a gitignored scratch path is deliberately outside this reading, because that is where a
lap is supposed to write -- the definition is about the tree the fleet shares alone.

**What this reading corrects in the record it inherits.** The `20260916.025923` erratum on row 3
read this instrument as unturned by the fleet's own roster -- zero receipts in
`construction/standing-equipment-runs.kyri` for `cyclic_witness`, because it sits at `tier cadence`
and nothing had turned its rota yet. That reading is about the **roster's habit**, and it still
holds: `grep -c '^ran cyclic_witness '` still reads zero. It was never a reading about whether the
instrument itself passes when run directly, and this paper is the first place that ran it and
recorded the result: it does, on metal, at this stamp. A guard nobody has scheduled and a guard that
fails are different facts wearing the same absence of a receipt, and conflating them would have
cost this paper its second definition for a reason that was never true.

## The shape the pair actually needs

Both definitions describe the same geometry: a bound is a number of steps before return, and a
returning proof needs at least one independent cycle to return along. Both definitions rest on one
axis. The `20260915.212827` reading already proved this arithmetically -- the maximum
axis-count among the definitions that survive contact with a witness is **1** -- and this paper's
own two witnesses confirm it by construction: `wrap_ring` is one counter mod C, `cyclic_witness` is
one digest compared to itself, `rune_bounded_trap` is one bound checked against one step count, and
`bearing_quorum`'s saving comes from closing one loop alone.

**So the shape bounded cyclic computing actually describes is a ring: one axis, one period,
closed.** The moonshot page that proposed this whitepaper carries a torus in its title because the
twelve-row ladder as a whole reaches for two axes elsewhere (row 2's polar privilege, row 4's
falloff radius) -- and those are exactly the rows this reading, and the `20260915.212827` reading
before it, found unsupported. What survives is smaller and plainer than the page's own name, and
this paper keeps that plainer shape rather than stretching two witnesses to fill a larger one.

## Assumptions

- The four cited instruments (`wrap_ring`, `glow_trap_bound`, `bearing_quorum`, `cyclic_witness`)
  keep reading as they read at this paper's own stamp; each is free to move, so a later reader should
  re-run them and take this citation as good for its own day alone.
- `wrap_ring`'s single-threaded, C=16, single-program proof stands in for the general claim that any
  bounded-capacity structure with a monotonic writer has this property. That step is an
  extrapolation this paper takes and names, one no witness here proves directly.
- `bearing_quorum`'s cost-exponent reading (0.56 / 0.52) is taken over four grid sizes, 4 through 32
  nodes; whether the sub-linear trend continues past 32 is unmeasured.

## Falsifier

Per the `20260915.212827` recommendation, this paper's falsifier is not a claim about the world --
it is a claim about the tree's own instruments, which is the register this whole lane has learned to
trust over prose: **a green witness in this tree, read after this paper's own stamp, refutes one of
the two kept definitions the way `capability_lattice` and `aether_falloff` refuted the radius.**

That falsifier can fire in either direction and both are named. It fires against definition one if a
future reading of `wrap_ring`, `glow_trap_bound`, or `bearing_quorum` shows the bound-as-period
identity breaking under concurrency, a second writer, or a grid size past 32. It fires against
definition two if a future reading of `cyclic_witness` -- run for real, rather than left at zero
roster receipts -- finds a witness that passes while its digest disagrees, which the instrument's
own design already treats as the interesting case rather than the exception.

## Confidence

**Medium-high for the two kept definitions**, because each now rests on two or three independent
green readings taken on real metal at this paper's own stamp, rather than on the errata that
described them. **Low for the generalization past what was measured** -- one ring size, one
concurrency level, four grid sizes, one host. The paper binds what stands today, and leaves every
wider claim -- every C, every thread count, every grid this fleet might someday run -- for a future
reading to earn.

## What this closes, and what it leaves for Caravan and Tally

**Closed:** row 11 of the bounded-torus moonshot page. The page proposed a paper binding three
definitions; the measurements support two; this is that paper, at the size the evidence earns.

**Left open, named rather than guessed:** whether **Caravan** (which supervises what runs) and
**Tally** (which bounds what is allocated) should adopt "declare the period, get the bound for
free" as a standing convention rather than a proposal -- that is a design decision past what any
reading here can settle, and it waits on a hand rather than on a witness.

## A closing note on the method

The `20260915.212827` reading closed on a wish that the next paper this lane wrote would be one its
own instruments already agreed with. Every figure cited above was read live, at this paper's own
stamp, rather than copied forward from an erratum -- including the one correction this paper made to
its own inherited record, that an unturned roster rota and an untried instrument are not the same
fact. That is the standard this lane is trying to hold itself to, and it held this time.
