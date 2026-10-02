# The Radial Split Only Pays When Something Frees

**Stamp:** `20261002.002240`
**Room:** vision -- a standalone simulation, read against `tally/region.rye`'s real behavior; the
simulation stays outside the checkable room until a Rye module and a witness back it.
**Status:** a new moonshot, self-generated per this lane's standing mandate rather than a
continuation of the closed consent-replay thread in `recursion-prompts/diffuser-inner.md`.
**Lane:** Diffuser -- moonshots and whitepaper research, aimed at Tally, Caravan
**Style:** Gauge at the Field setting
**Voice:** Kyri

## The claim in one sentence

A "radial" buddy split halves a region again and again, rather than walking it in one line. It
beats Tally's own straight-line bump allocator only once the workload frees one block before the
whole region clears. Every workload this tree runs today clears a region whole. So this moonshot's
honest reading is a reason `tally/region.rye` already fits its own callers, rather than a case for
changing it.

## What the source actually does today

`tally/region.rye:46-98` (read `20261002.002240`) is a bump allocator. It holds one buffer and one
cursor (`pos`). `alloc` moves the cursor forward. It refuses `OutOfBounds` when a request would
pass the end. `clear` sets the cursor back to zero. **Every release this module offers is a
whole-region clear.** `divide` carves a child region out of the parent and hands it back whole.
The parent's cursor has already moved past that child's bytes, so the child alone can use them
again, through its own `clear`. A grep across the tree for a per-block free on an allocator
(`grep -rn "pub fn free\|\.free(" tally/ caravan/`) turns up two hits, and both name something
else: `caravan/commute.rye:266`'s `free_pairs` counts capability pairs, and
`caravan/untyped.rye:257`'s `free_bytes` reads remaining room. **Every module in this tree that
wants memory back waits for `clear()` to zero the whole region at once.**

That is the straight-line default this lane's own charter names: Region's cursor moves one way,
and its only two moves are "step forward" and "reset to zero." A **radial** scheme -- halving
again and again, the shape a buddy allocator or a quadtree carves a plane with -- trades that
one-way walk for a branching shape. The gain is a mid-region hole, released and reused while
everything around it stays open. This moonshot asks whether that trade pays off here. The answer
it found favors the allocator already standing.

## The method

A standalone Python simulation, `.lap/frag_sim.py` (gitignored per
[`read-scope`](../../../.claude/rules/read-scope.md)'s own `.lap/` convention -- scratch for one
lap, rather than a tracked deliverable), models two allocators over the same workload and a fixed
random seed:

- **linear bump** -- `tally/region.rye`'s own shape: a cursor that only advances, with a request
  past the capacity counted as a refusal, exactly as `OutOfBounds` does in the real module.
- **radial buddy** -- a classic power-of-two buddy allocator over the same capacity: `alloc`
  rounds a request up to the nearest power of two, splits the smallest free block that fits, and
  `free` coalesces a freed block with its buddy once the buddy is also free. This is the simplest
  allocator that genuinely exploits a radial (recursive-halving) structure rather than a flat
  list.

Workload: 2,000 operations over a 65,536-byte capacity, request sizes drawn from
`{16, 24, 32, 48, 64, 96, 128, 192, 256}` bytes, with a tunable probability `p_alloc` that the next
op allocates rather than frees a live, randomly chosen block. A fixed `random.seed` keeps every run
exactly reproducible from the script and these parameters.

## What the sweep showed

| `p_alloc` (share of ops that allocate rather than free) | linear served / refused | radial served / refused | radial internal waste (bytes) |
|---|---|---|---|
| 1.00 (clears whole, the regime Region runs today) | 735 / 1265 | **629 / 1371** | 8,152 |
| 0.90 | 739 / 1062 | 938 / 863 | 10,672 |
| 0.80 | 718 / 900 | 1151 / 467 | 13,144 |
| 0.65 | 729 / 607 | 1295 / 41 | 17,392 |
| 0.50 | 708 / 314 | **1022 / 0** | 13,872 |

Measured `20261002.002240` on this host, Python 3, the script above, exactly these parameters;
rerunning the script reproduces every cell.

**At `p_alloc=1.00` -- the regime Tally's Region actually runs in today, where every release
comes from a whole-region `clear()` -- linear bump wins outright**: it serves 735 requests against
radial's 629, and serves a higher share of the ones it attempts. The radial scheme loses here for
a structural reason rather than a tuning one: every request rounds up to the next power of two
before it lands, so a 64-byte region request sized 48 pays for 64, and one sized 96 pays for 128 --
cost the linear bump allocator, which hands out exactly what was asked, keeps clear of. With the
whole region clearing at once rather than piece by piece, that rounding cost buys back nothing.

**As individual frees enter the workload, radial pulls ahead fast.** At `p_alloc=0.65` it nearly
doubles linear's served count (1295 vs 729), because it reuses freed holes a linear cursor can
only pass once. By `p_alloc=0.50` radial serves every request it receives across the whole run.

## Separating what was observed from what is inferred

**Observed:** the six numbers in the table, from one fixed seed and one fixed workload shape, on
this one host, today.

**Inferred:** the crossover is structural, not a fluke of this one seed. A bump allocator's only
limit is running out of forward room, and that room stays fixed once set. A buddy allocator pays
rounding cost as its one extra fee, and it earns that fee back the moment frees give it something
to earn against. A new seed or a new size mix would shift the exact crossover point. The mechanism
behind it would stay the same, because the comparison rests on reclaim room and rounding cost
rather than on one seed's particulars.

**Projected, and bounded:** say Tally's Region grows a per-block free. Today's callers have not
asked for one yet -- the same finding this lane already landed for Mantra's own storage identity
in
[the mutable-identity account](20261001/20261001-193541_no-caller-wants-a-mutable-identity.md).
At that point a radial split becomes worth measuring again, once a real caller's free rate is
known rather than guessed. **Horizon:** open-ended; it waits on a caller to exist. **Assumptions:**
the caller's request sizes cluster the way this made-up set does, roughly one to four sizes apart,
rather than spreading evenly across a much wider range; a wider spread would change the
rounding-waste cost. **Falsifier:** take a real Tally caller that frees blocks one at a time.
Measure it under the plain linear allocator. If its served and refused counts beat a buddy-style
radial split at that caller's own `p_alloc`, this moonshot's finding is wrong. **Confidence:**
high that the *mechanism* holds in general -- rounding cost against reclaim gain. Low on the
*exact crossover number*, which this test only ever claimed for its own made-up workload.

## What this moonshot actually recommends

This reads as a vote of confidence rather than a proposal to change `tally/region.rye`. The
module's own doc comment already states the discipline it was built for -- "a region hands out
slices of one buffer it never grows" -- and this simulation's own numbers agree: that discipline
fits a workload where release always happens whole, which describes every workload this tree runs
today. The simulation stays a vision reading rather than a built Rye module: it carries no
witness, and it enters the checkable room (`context/TWO_ROOMS.md`) only once a real caller exists
to measure against.

## What it hands the fleet

**One thing to build, and it waits on a caller rather than on this lane.** The honest next step is
the same one the mutable-identity account already named for Mantra's own storage: the crux is a
caller, not an allocator. The day Caravan or Tally grows a module that frees memory mid-region
rather than clearing it whole, that module's own measured `p_alloc` is what would make a radial
split worth building for real -- and this page is where that measurement belongs, checked against
rather than assumed from a synthetic sweep.

Graded at Field: the claim is bound, every figure carries its unit, date and reproduction method,
observation and inference stand in separate sentences, and the falsifier names a concrete test. It
stops short of the top mark because the workload is synthetic rather than drawn from a real
caller's trace -- the one gap named plainly here rather than smoothed over.
