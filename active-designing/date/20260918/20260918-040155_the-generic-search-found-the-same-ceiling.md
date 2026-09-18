# The generic search found the same ceiling

**Stamp:** `20260918.040155`
**Language:** EN
**Style:** Gauge, Field setting (see [`../../../context/GAUGE_STYLE.md`](../../../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Checkable -- `tools/t/torus_offset_generic_search_witness.rish` GREEN on metal, 16
behaviors, two grids, one mutation bitten.
**Room:** checkable -- an arithmetic claim bound by a witness rather than a projection.
**Lane:** Diffuser -- moonshots and whitepaper research, walked in tandem with Bakery
**Kin:** [`../../20260918-005400_the-search-found-the-ceiling.md`](../../20260918-005400_the-search-found-the-ceiling.md)
(the constrained one-parameter search, this piece's parent question),
[`../../20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md`](../../20260918-002526_round-two-three-moonshots-grounded-in-round-ones-refusals.md)
(round two, proposal 1), [`20260918-034116_declustering-stays-a-storage-scale-question.md`](20260918-034116_declustering-stays-a-storage-scale-question.md)
(the checked negative this note continues the ladder past)

---

## The question this note closes

`tools/t/torus_offset_search_witness.rish` swept one free parameter, `d`, inside a shape both of
round one's own hand-picked offset sets already shared: `{d, -d, 2d, -2d} mod C`. At round one's
own founding grid (g=8, C=64 cells) the sweep found `d=13`, a run-kill spread of **52** -- past
round one's already-measured 33, and equal to the theoretical ceiling for five points splitting a
ring of 64 cells as evenly as the integers allow (`C - ceil(C/5) + 1 = 64 - 13 + 1 = 52`).

That essay named its own open door plainly: *"a fully generic four-offset search ... hints the
generic search would land at the same ceiling by a different route, which stays a conjecture until
it is run."* This note runs it.

## What "generic" means, and why the constrained search could not answer this alone

The `{d,-d,2d,-2d}` shape forces two of the four offsets to be the negatives of the other two --
a symmetry inherited from the torus and ring axes the shape generalized, rather than from the
criterion (even spacing) that actually governs declustering spread. A generic four-offset set
drops that constraint entirely: any four distinct residues from `{1, ..., C-1}`, each free of a
sign relationship to the others. The population searched **strictly contains** the constrained
family -- every `{d,-d,2d,-2d}` set is one particular 4-subset among the generic ones -- so a
generic search can match or beat the constrained family's best by construction, whatever it finds.

## What was built, and what it found

`tools/fixtures/t/torus_offset_generic_search_scan.sh` enumerates every 4-subset of the offset
range with four plain nested loops (`a < b < c < d`), computes the same shortest-circular-run
metric the elder scans use, and reports the best spread found alongside the theoretical ceiling.
Candidate count is named before the sweep starts and bounded by a named budget (5,000,000): a grid
whose `C(C-1, 4)` exceeds it is refused by name, honestly, at the door.

**At C=9** (g=3, 70 candidates -- small enough to check by hand): the best offsets `{1,3,5,7}`
give points `{0,1,3,5,7}`, gaps `1,2,2,2,2`, widest gap 2, span `9-2+1=8` -- exactly the ceiling
`9 - ceil(9/5) + 1 = 8`.

**At C=64** (g=8, round one and two's own founding grid, 595,665 candidates): the best offsets
`{12,25,38,51}` give a run-kill of **52** -- the same number the constrained one-parameter search
already found, matching bit for bit.

**At C=1024** (g=32): the candidate count, `C(1023, 4) = 45,367,119,105`, exceeds the named budget
and the scan refuses by name, printing the exact count it would have had to search in place of
running for hours or hanging silently. The constrained search already checked this grid, at a
lighter cost -- its own one free parameter costs C/2 evaluations, where the generic version's cost
grows with the fourth power of the grid. A third confirming grid at this size is future work,
bounded by a faster search strategy, named below.

## Why the conjecture held, in the arithmetic rather than in luck

Five points (the cell itself plus four offsets) split a ring of C cells into at most five gaps.
Run-kill length is C minus the widest gap plus one, so it is maximized exactly when the gaps sit
as evenly as the integers allow -- each near C/5. That bound rests entirely on gaps between five
points on a circle, whatever their signs. So the ceiling was always reachable by **any** five-point
split that happens to space itself evenly, symmetric or not, and the constrained family's own
success at reaching it (proven in the parent essay) already pointed to the ceiling's general
reachability, rather than to a property of that one shape. This note turns that pointer into a
checked claim: the generic search was asked to find a BETTER split than even spacing allows, and
at both grids tried, the ceiling itself is the best answer either search returns.

## What this settles, and what it leaves open

**Settled, at two grids:** the `{d,-d,2d,-2d}` family already stood at the table's full spread.
A fully free search, searching strictly more candidates than the constrained family ever
considered, lands exactly on the ceiling the constrained family already reached.

**Left open, named rather than assumed closed:**

- **A third grid**, past C=64, needs a faster search than four nested loops -- a local-search or
  branch-and-bound approach that prunes toward even spacing directly, since the brute-force cost
  is the fourth power of C and C=1024 already exceeds the named budget by four orders of
  magnitude. Worth building only if a future round wants the confirmation; the arithmetic argument
  above already gives the reason to expect it.
- **A different replica count.** Five copies is round one's own inherited assumption, carried
  forward unchanged through every reading in this ladder. Six or more offsets would ask the same
  question over a different number of gaps, and the closed form generalizes directly (`C -
  ceil(C/k) + 1` for k points); this ladder leaves that check to a future round.
- **Any real store.** This reading, like its two parents, stays at the level of abstract offset
  sets -- one integer quantity, measured over the same kind of population round one opened.

## Falsifier

This finding holds while the ceiling formula `C - ceil(C/5) + 1` is the true upper bound for a
five-point circular split, which the witness proves as a gate against a planted lie about the
ceiling (the mutation lowers the printed ceiling below the real best and the comparison catches
it). The finding itself -- that the generic best REACHES the ceiling exactly -- stands on two
grids; a third grid whose generic best fell short of its own ceiling would falsify the claim that
the ceiling is generically reachable at every grid, and would point to a gap the two tested grids
happened to miss (an odd C, or a C whose remainder mod 5 is small, are the likeliest candidates for
a future check to start with).

**Horizon.** Immediate -- both readings ran on this lap. **Assumptions.** The five-copy population
is the right one to search (inherited, unchecked here). **Confidence.** High on the two grids
actually run (both closed-form and exhaustive agree); medium on the generalization to grids beyond
the brute-force budget's reach, where the arithmetic argument alone speaks for them.

## What comes next, and why it waits

Round two's proposal 2 -- the two-field key -- already landed
(`20260918-013435_the-two-fields-that-composed-and-the-one-that-did-not.md`). Proposal 3 stands at
one ship of eight reporting, waiting on the other seven ships' own hosts. The declustering ladder
itself has now run to a genuine close: two checked negatives (Caravan's supervision tables, and --
per this note -- the constrained offset family's own optimality) and two landed positives (the
constrained search's ceiling, and this note's confirmation that the ceiling holds however the
constraint is dropped). A fourth opening on THIS thread would want either a faster search strategy
or a different replica count to reach past what the arithmetic here already predicts; naming that
next step, and leaving it there, is this note's own finishing edge.

---

*May the offsets we search for be exactly as clever as the arithmetic that already names their
limit -- and stay there gladly.*
