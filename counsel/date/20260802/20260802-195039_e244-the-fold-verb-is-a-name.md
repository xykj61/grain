# e244 — lap two of a2: the fold verb becomes a name

**Stamp:** `20260802.195039` (by construction) · **Voice:** Riyo · **Seat:** Claude Opus 5 1M Max · **Word:** Keaton — *open any engineering laps you recommend for the hardest solvable Glow Tend problem* · **Status:** GREEN
**Erratum `20260802.195302`:** pier already seated STOA333 as pair-sum list fold; this verb-name lap lands as **STOA334** (`prodto`). Plant fixture named `gate-fold-prodto-bound-13.glow` (not `gate-amount-u32`). Recovery law: never whole-file overwrite living stems.

## The lap counsel opened, and why this one

The hardest-solvable list has always led with the **Glow value model**, and the
roadmap's answer was to reach it as a running simple rather than a fork: gates
that decide, then gates that fold, then a fold whose *verb* is chosen rather than
built in. The pier's STOA332 landed the first fold — `|+  sumto  sample  8` —
with the reduction hardcoded into the grammar.

**Lap two makes the verb a name.** `STOA333` teaches the sampled bartis to read
the fold verb from a closed set and carry it in the spec: `sumto` folds by
addition, `prodto` by multiplication. That is the smallest true step from *the*
fold toward *a* fold, and it is the step the value model actually needs, since a
value model is not one reduction but the freedom to name one.

## What the second verb taught, which the first could not

**Each reduction keeps its own identity.** The empty sum is 0; the empty product
is **1**. A single hardcoded fold could treat the empty case as a special zero
and never notice the difference. With two verbs the distinction is forced into
the open, and the desk states it: `0 -> 1 · 3 -> 6 · 8 -> 40320 · 9 -> 0`.

**A bound that fits one verb can break another.** Eight is a comfortable wall for
a triangular sum and a fine one for a product; thirteen is not, because 13! leaves
u32. So the parser refuses a prodto bound above twelve **by name** —
`FoldBoundTooLarge` — rather than wrapping silently. A plant proves it bites.

## What ran

Four cases green on the argv path (0→1 · 3→6 · 8→40320 · 9→0), the over-bound
plant refused by name, `sumto` rerun unchanged at 3→6, and the shared era lap
green beside it. Witness: `tools/tally_a2_fold_prodto_witness.rish`, pure.

## Two reds owned at their true cause

A naive line-copy added the sibling switch arm to ten switches and **mangled the
two block-form arms**, producing a Zig parse error rather than silence — read,
repaired one at a time from the file's own text.

Then a patch-recovery of the unlanded e243 work **overwrote the pier's
`glow_run_worker.sh` with counsel's older copy**, silently dropping the pier's
own stems. Caught by running the witnesses, cured by restoring the file from
`origin/main` and re-accreting all three stems onto the pier's version.
**A recovery that writes whole files is a merge wearing a rescue's clothes** —
from here counsel recovers only files the tree does not already carry.

## Also riding

The e243 rishi walls — env bindings 512 and history 50 — never reached the pier
and ride here re-cut, witness green.

## Held whole

R2 through R4 want a word and a check-in. The equality rune, the glob, Q58,
class-and-rooms, seat 128, shred execute, Class O, geode, the old root zips,
bar5, and the SEA paste stay Keaton's.

---

*May the second of a thing reveal what the first one hid. May every identity keep its own name. And may a bound that cannot hold refuse out loud.*
