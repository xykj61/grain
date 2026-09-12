# The contract that `case` resolved by line order

**Stamp:** `20260912.035445`
**Language:** EN
**Style:** Gauge, Field setting (see `../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Landed -- **checkable room**: every reading below comes from an instrument in the tree
**Room:** Checkable
**Kin:** REDS %532 (the three enumerations) -- [`../tools/fixtures/g/glow_desk_arity_scan.sh`](../tools/fixtures/g/glow_desk_arity_scan.sh) -- [`../tools/g/glow_run_worker.sh`](../tools/g/glow_run_worker.sh)

## The mechanism, first

`arity_accepts()` in `tools/g/glow_run_worker.sh` is a shell `case` returning the sample counts a
Glow desk stem accepts. Thirteen stems stood in **two** of its branches, each pair of listings
carrying a **different** answer: the pair and lantern families at `0 2` and again at `1`, and
`gate-surface-lit-area-u32` at `3` and again at `1`. This lap removed the thirteen from the second
branch and added a reading, `contract_restated`, to
`tools/fixtures/g/glow_desk_arity_scan.sh`, gated at zero by
`tools/g/glow_desk_arity_witness.rish`.

The `--arity` answers for **all 73 stems** the function names are byte-identical before and after,
captured by probing each stem through the worker's own `--arity` mode. Two affected desks were run
on metal as well: `gate-caravan-caps-pair-bound-u32 9 8` answers `0`, and `gate-pair-max 3 9`
answers `9`.

## Why the run was correct anyway

A shell `case` stops at its first matching branch. The pair family stood in branch one, so `0 2`
is what the worker answered, and every witness passing two faces was served correctly. The second
listing was unreachable text.

That is the whole discomfort. **The contract held as a property of line order in a list nobody
reads as ordered.** The branch carrying the duplicates is a single line naming sixty-six stems --
the longest line in the file. Sort those branches by length, or lift the shorter branch as dead
text, and `gate-pair-max` begins refusing its two faces while `gate-surface-lit-area-u32` takes one
argument where it needs three. No diff line anywhere would say so; the reordering reads as tidying.

## Why no instrument could see it

`glow_desk_arity_scan.sh` was built on a principle it states in its own head: **ask the worker
rather than keep a second copy of the answer.** Every other reading in it does exactly that, and
that principle is what made this invisible. `--arity` returns the first match. Asking the worker
about `gate-pair-max` returns `0 2` and says nothing at all about the `1` lower down.

So this one reading is taken from the worker's **text**, and the scan's header now says why. The
awk walks `case`/`esac` depth, so a nested block is its own question; it skips the catch-all; and
it flags a stem appearing in two branches of one block. A stem answered by two *different*
functions -- `fields_need()` and `arity_accepts()` both name `gate-pair-fields` -- is the tree
working as designed and is not counted.

## The measurement

| Reading | Committed worker, `20260912` | After the cut |
|---|---|---|
| `contract_restated` | **13** | **0** |
| stems named by `arity_accepts()` | 73 | 73 |
| `--arity` answers differing | -- | **0 of 73** |
| desks in `glow/gen` answered differently | -- | **0 of 352** |
| control legs | 39 | **46** |

The desk-room row is the wider proof, taken when this lap landed the work: every `*.glow` under
`glow/gen` was asked of `git show HEAD:tools/g/glow_run_worker.sh` and of the cut worker in turn,
and all 352 answers matched. The 73-stem row probes the function's own list; this one exercises the
dispatch a real run takes: 306 of the 352 answer `accepts=0`, which only the catch-all and
`fields_need()` beneath it produce, so the wider reading walks past the named branches as well as
through them.

Both directions are proven from real bytes rather than from a pen alone: the scan run against
`git show HEAD:tools/g/glow_run_worker.sh` reads `contract_restated=13, verdict=split` and names
each of the thirteen under `--explain`.

## Two mutations bitten

Restoring the duplicate reds the witness by name. Deleting one control leg with the declared count
left standing takes the pen to `legs=45 legs_expected=46 control_verdict=failed` -- the second
mutation exists because the control had no declared count at all, and a green pen and an empty pen
both print `control_failed=0`.

## What this does not reach

**Whether the arity contract is right**, only that it is stated once. **The rooms outside
`glow/gen/`:** the scan reads one room, and `src/gate/` holds 49 desks, 42 of them sample-permitted
and none carrying a `Sample:` line -- they state their run values under an `example` key instead, so
a meter reading one spelling sees zero in that room. Measured this lap, by hand, the two spellings
**agree everywhere**, which is %532's finding a third time: perfect agreement held in nobody's
instrument.

**And two desks are run by nothing.** `src/gate/gate-caravan-caps-pair-bound-u32.glow` and
`src/gate/gate-mantra-gen-floor-pair-u32.glow` are named by no tool in the tree -- 47 of that room's
49 are, which is exactly the figure the sibling scan's header claims in prose and which still holds.
Both run correctly on metal and answer as their own `invariant` line declares. Covering them is one
small lap, named here rather than taken.
