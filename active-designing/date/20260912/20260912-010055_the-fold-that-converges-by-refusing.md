# The fold that converges by refusing, and the candidate no prover can reach

**Stamp:** `20260912.010055`
**Language:** EN
**Style:** Gauge, Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every reading below is a verdict printed by a named
instrument, and the repair ships with its witness green
**Room:** checkable
**Kin:** [`../foundations/20260823-222019_what-brix-infuse-is.md`](../foundations/20260823-222019_what-brix-infuse-is.md) -- [`../foundations/20260826-021734_water-the-row-that-tastes.md`](../foundations/20260826-021734_water-the-row-that-tastes.md) -- [`../.claude/rules/stamp-and-name.md`](../.claude/rules/stamp-and-name.md)

## What changed

`tools/c/convergence_tree_prove_witness.rish` gained a sixth leg. It hands
`tools/fixtures/r/reds_fold.sh` to `tools/c/convergence_tree_prove.sh` with a `--perturb` command
that appends one planted `**BOOKED.**` row to `construction/REDS.md` and writes a shelf header
beside it, then folds that row. The leg asserts `verdict=write_once`.
`tools/c/convergence_census.sh` gained a header paragraph recording both readings taken here.

`sh tools/c/convergence_census.sh`, run before and after on this tree:

| Reading | Before | After |
|---|---|---|
| `candidates` | 15 | 15 |
| `candidates_proven` | 13 | **14** |
| `proven_by_prover_run` | 4 | **5** |
| `candidates_unproven` | 2 | **1** |

Not one line of `reds_fold.sh` moved. The tool already converged; what was missing was anybody
having asked.

## The reading the water row asks for

The rota's water seat holds
[`what-brix-infuse-is`](../foundations/20260823-222019_what-brix-infuse-is.md), whose claim is one
line -- `infusion(world') -> world'` -- and whose instruction is to test it by running the thing a
second time. `tools/c/convergence_census.sh` names the tools that write to the tracked tree and
have no such proof. It read **two**. Both were handed to the prover rather than reasoned about,
which is this census's own law: a static pattern finds candidates, only the prover classifies.

## `reds_fold.sh` converges by declining its own output

```
verdict=write_once
detail: the second run refused and changed nothing -- the tool converges by declining its own output
  reds-fold: refused -- row %999001 is not in construction/REDS.md
  verdict=row_absent
```

**This is the first real tool to earn that verdict, and the shape is worth naming.** The five
subjects the witness already held all REGENERATE a page -- the README metrics block, the geode
library index, the REDS headline. Run one twice and it writes the same bytes the second time, so its
convergence is a second write that happens to agree. A fold is a **one-way move**: the row leaves the
pin for the shelf, and asked the same question again the tool answers `row_absent` and touches pin,
shelf, and recital not at all. That refusal is exactly what accrete-never-break asks of a shelf
writer, so here the refusal IS the convergence. The prover tells it from `refused_on_second` by
asking the tree rather than by reading the exit code, because those are two facts wearing one
appearance.

**The planted row, and why it is planted.** `%999001` stands far above the living spine, which
`tools/gen/chapter/reds_ledger_monotone_witness.rish` holds gapless from 1, so it can never collide;
it exists only inside a `git worktree` pen that is removed on every exit path. A leg naming a live
row number would go stale the day that row folds -- the shape
[`stamp-and-name`](../.claude/rules/stamp-and-name.md) refuses under *count, never number*.

**The perturbation carries no backslash on purpose.** The prover's own header records a witness
whose `sed` expression had its backslashes doubled passing through Rishi, matched nothing, exited
zero, and read `inert` -- a broken sample wearing a true verdict's clothes. Two `echo` calls with a
single-quoted body need no escape, so there is nothing for a second parser to double.

**The perturbation is load-bearing, proven by removing it.** The same invocation with no `--perturb`
reads `verdict=refused -- shelf_absent`, and the leg's assertion fails on it.

## `bootstrap_wasmtime.sh` is a candidate no prover in this family can ever answer

```
verdict=unseen
detail: the first run wrote only paths git ignores, so the comparison is blind to its whole
        output -- no convergence claim can be made
  tools/.cache/
```

An ordinary run writes `tools/.cache/wasmtime/`, which `.gitignore` denies, so `git write-tree` is
blind to its whole output. The prover refuses rather than reporting, which is right: `inert` is a
claim about the subject, and the instrument never looked where this tool wrote.

Its one **tracked** write is `tools/fixtures/w/wasmtime_31_0_0.sha256`, and the tool's own header
says when that fires -- a first seating with no fixture. The fixture is tracked, so on any checkout
of this tree it is already present and that write can never happen. **The git strand admitted the
tool on a write its own live tree forbids.**

So `candidates_unproven` held two kinds: one gap a lap could close, and one member that owes no work
at all. The finding is written into the census header rather than split into a column, because
`admitted_on_comment_only` already retired above for reading a permanent zero, and a column whose
population is one tool would read the same way.

## What this does not reach

**Whether the fold is correct**, and whether the rows it moved belong where it put them. This proves
the move happens once and stops, and nothing beside that.

**The other write paths of `bootstrap_wasmtime.sh`.** Asking whether its cache seating converges
wants an instrument that compares a directory git ignores, which is a different subject from the one
this family measures -- and the tool fetches over the network to answer, so the cost is real.

**`candidates=15` itself.** Six denominators have been wrong here and each was learned by running.
Read the number as an upper bound on what might need proving, and the prover's verdicts as the
finding.

*May every one-way move stay one-way, and may the second asking always be met with a kind refusal.*
