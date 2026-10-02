# Reverse-read -- mycelium's own `main` family is the caravan scene pattern, not a split queue

**Status:** Landed -- checkable (the two counts below are run commands, not estimates)
**Room:** checkable
**Stamp:** `20261002.100233`
**Lane:** GRASS (TAME Guidance over SLC-product-facing code)
**Kin:** [the caravan fold reverse-read](../20261001/20261001-142426_grass-caravan-fold-reverse-read.md) -- the ruling this one extends into a second room

## The question

`construction/ITINERARY.md`'s GRASS account carries `functions_over_70` (694) as **YOURS**, noting
it reads "mostly outside caravan's own ladder." Caravan already accounts for 206 of the 694 (every
`check_suffice_runs` rung, declined as a split target `20260820.131713` -- a rung's self-test is
the one place meant to differ). The question this lap asked: does the SAME shape repeat in
`mycelium/`, the ledger's own siloed demo family?

## What the walk found

```
grep -c "mycelium/" /tmp/ledger-of-functions-over-70   # 51
grep "mycelium/" ... | grep -c ": main ="               # 49
```

**49 of mycelium's 51 over-70-line functions are `pub fn main() !void` in a standalone demo
file**, each one a siloed, dev-only walkthrough (`warrant.rye`, `purse.rye`, `lapse.rye`,
`braid_knot.rye`, `portage_kyri.rye`, `chorus.rye`, `freight.rye`, and the rest of the `_knot`
roster). Five were read in full: `warrant.rye` (131 lines, 8 numbered Scenes), `purse.rye` (120
lines, a double-spend narrative with no Scene labels yet the identical shape -- genesis, two
competing transfers, a tie-break, a verdict, a conservation check), `lapse.rye` (124 lines, a
pledge-deadline race), `braid_knot.rye` (137 lines, a four-party chain), `portage_kyri.rye` (155
lines, a two-world crossing), `chorus.rye` (134 lines, labeled Scenes), `freight.rye` (132 lines,
labeled Scenes).

**Every one reads the same way caravan's rungs do.** A `main` here is not a dispatcher or a
production entry point. `rye run mycelium/<file>.rye` runs a standalone proof, and its length is
the argument it makes: seed keys, build a small DAG by hand, assert a refusal or a verdict at each
named step, print the GREEN line. Splitting one into `scene_1()`-`scene_8()` helpers repeats what
the caravan ruling already declined twice (design call A then B, `20260820.131713`). It would move
one sequential narrative behind indirection. A reader still follows the same assertions in the
same order, now through an extra layer of calls -- a cost paid for no gain. See
[the caravan ruling](../20261001/20261001-142426_grass-caravan-fold-reverse-read.md) for the fuller
argument this lap borrows.

**The two real exceptions, both named rather than buried:** `mycelium/pledge.rye: fold_pledge` (89
lines) and `mycelium/lapse.rye: fold_lapse` (97 lines) are **not** `main` -- they are the module's
own fold logic, called from elsewhere, and neither was read this lap. They stay open, genuinely,
as the two mycelium functions a future split pass should look at first.

## What this narrows

`functions_over_70`'s honest remaining population, after caravan (206, declined) and mycelium (49
of 51, same declined shape): **694 - 206 - 49 = 439** functions outstanding. Most sit in `glow/`
(compiler lowering, and the CLI driver `glow_run.rye: main` at 426 lines), in `rye/src/main.rye`
and `rishi/src/main.rye` (the two language drivers), and in the `caravan/` arc's own non-rung
helpers (`seat.rye`, `arrive.rye`, `refer.rye`, and others in the 71-79 line band -- each worth a
read of its own, rather than assumed). None of those were split this lap. A compiler driver and a
language's own `eval_expr` want a careful read and a green witness after, not a mechanical split
chosen from a line count alone. This lap's own budget ran to measurement, not to that work.

## YOURS

`functions_over_70`'s remaining ~439, with `glow/glow_run.rye: main` (426 lines), `rye/src/main.rye:
bridge_to_zig` (377), and `rishi/src/main.rye: eval_expr` (242) as the three largest real
candidates -- each wants a careful read of its own natural seams before any split, by whichever
lane takes it up. `mycelium/pledge.rye: fold_pledge` and `mycelium/lapse.rye: fold_lapse` are the
two small, genuine mycelium candidates left unread.
