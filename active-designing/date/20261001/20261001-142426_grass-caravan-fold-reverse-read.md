# Grass -- the caravan FOLD note, reverse-read

**Stamp:** `20261001.142426`
**Language:** EN
**Voice:** Kyri
**Style:** Gauge, Field setting
**Status:** Checkable -- a measured finding against a live `functions_over_70` ratchet and a landed
design call
**Room:** checkable

## The note on the card

The last grass account left three items under **YOURS**: `caravan/` wants a FOLD;
`functions_over_70` (694); claim-board. This packet reads the first against the ladder's own
history and finds it already answered -- the remaining size is accumulated self-test rather than
an unfolded copy.

## What the ladder already folded

`caravan/ladder_checks.rye` (11,380 lines) is the landed **option B** harness from
[`20260820-131713_caravan-ladder-shared-harness.md`](20260820-131713_caravan-ladder-shared-harness.md):
every rung's check functions take their own rung as a comptime parameter and run against that
rung's own report, store, and wire. 523 check bodies folded off the ladder the day it landed, and
every rung from `farewell.rye` through `beckon.rye` imports it **143 times each** -- the bulk of
each rung's own checks already run through the one shared body.

## What stayed home, and why it is not a missed fold

The top of `functions_over_70` names seven `check_suffice_runs` functions, one per rung
(`farewell.rye` 809 lines down to `beckon.rye` 671), none of them inside `ladder_checks.rye` and
none byte-identical to its neighbor. A direct diff of `farewell.rye`'s and `refrain.rye`'s bodies
shows real content differing throughout: distinct helper names (`refrain_published` beside
`respect_published`), distinct RED messages naming each rung's own new scenario, and a differing
argument count into the shared `run_one` call as each rung adds one more case to the list.

That is exactly the shape the landed design call already named and declined to fold: *"This is
accumulated self-test rather than duplicated logic... a ratchet, in the tree's own sense --
something not yet uniform, which turns on touch and books nothing."* A rung's self-test is the one
place that is supposed to differ, because each rung proves one new thing about a supervised run.
Folding it further would ask one body to speak for scenarios that have not been written yet.

## What this answers

The YOURS note read as an open fold the ladder had already done twice over (A then B). The
remaining size is seven functions whose growth is organic and rung-specific, not a residue the
2026-08-20 design call missed -- its own addendum already named this exact shape ("a check whose
tail chains into a check this rung invented stays home") and resolved it by letting the harness
carry everything that *could* be shared. The `functions_over_70` ratchet keeps counting them
honestly; nothing here calls for a sweep.

## What remains open

`functions_over_70` stands at 694 across the whole tree, most of it outside caravan's own ladder
and outside this lap's lane. The claim-board read clean at lap open -- one unrelated live claim
(`patchouli-weave-tablecloth-seam-falsifier`), no caravan claim standing.
