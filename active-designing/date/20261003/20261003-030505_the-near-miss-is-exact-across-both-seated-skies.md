# The near-miss is exact across both seated skies

**Style:** Gauge at Field - **Status:** checkable -- read-only confirmation, nothing lands beyond
this page
**Stamp:** `20261003.030505`

## What this closes

[The distance half of the fractal address has no caller](20261003-024623_the-distance-half-of-the-fractal-address-has-no-caller.md)
read `kumara/tilak.rye`'s `Point.seat` (`kumara/tilak.rye:75-87`) and found it hand-builds a point's
default parent through three steps -- `encode(decode(number).?.parent())` -- that are the identical
three steps `Sky.sponsor_of` already performs for the same number (`kumara/topology.rye:311-320`):
decode, take the address's parent, encode. That essay confirmed the two reads "non-divergent" by
reading both bodies side by side and named a falsifier for a later lap rather than attempting it:
*swap the call, re-run the selftest.*

This essay runs that falsifier, exhaustively, on scratch metal, rather than arguing from the two
function bodies that they must agree.

## The method

A scratch probe (`kumara/scratch_sponsor_parity_probe.rye`, built and deleted before this lap ends)
imports `kumara/topology.rye` and, for both seated skies, walks every point number from `0` to
`universe_points() - 1` and compares:

- `via_decode_parent_encode` -- the exact computation `Point.seat` performs: `sky.encode(sky.decode(n).?.parent())`.
- `via_sponsor_of` -- `sky.sponsor_of(n).?`.

`compass_sky` (12 galaxies, 5 stars, 12 planets) holds 720 points; `council_sky` (15 galaxies, 3
stars, 9 planets) holds 405 points -- both small enough that "exhaustive" means every point, not a
sample.

Built with `RYE_ZIG="$PWD/vendor/zig-toolchain/zig" sh tools/fixtures/r/rye_build.sh
kumara/scratch_sponsor_parity_probe.rye -femit-bin=kumara/bin/scratch_sponsor_parity_probe`, this
host, `20261003.030505`.

## The result

```
verdict=ok compass_checked=720 council_checked=405
```

Zero divergence across all 1,125 points of both seated skies. `Point.seat`'s hand-built
default-parent computation and `Sky.sponsor_of`'s own answer agree at every point number either
sky can hold.

## The mutation that proves the check was load-bearing

Adding `+ 1` to the `sponsor_of` side of the comparison and rebuilding produced an immediate,
first-point failure:

```
DIVERGE sky=compass n=0 decode_parent_encode=0 sponsor_of=1
error: Diverged
```

exit code 1, caught at `n=0` before the loop could run further. The clean probe was then restored
and re-run, returning to `verdict=ok` with the same two counts. A check that cannot be made to fail
proves nothing; this one fails on the first point it is asked to, and passes cleanly once restored.

## What this adds past the prior essay

The prior essay's "non-divergent" finding rested on reading two function bodies and judging them
equivalent by inspection -- correct, and also exactly the kind of claim a later lap is asked to run
rather than trust (`docs-implementation-sync.md`). This essay turns that read into a run: every
point in both skies this tree has seated, checked on metal, with the check proven capable of
catching a disagreement before it is trusted to report the absence of one.

## What this does not reach

**A third sky.** Nothing here proves the two computations agree for a hypothetical sky this tree
has not yet declared -- only that for the two it has, they do, for every point each one holds. A
future sky is a one-line addition to the same probe's sky list, should Kumara ever declare one.

**Whether `Point.seat` should be rewritten to call `sponsor_of` directly.** That edit is
`kumara/tilak.rye`'s own, not this lane's; the prior essay named it a redundant reimplementation
rather than a defect, and this essay's exhaustive agreement is evidence for that reading rather than
a reason to make the edit here. Nothing in `kumara/` was touched by this lap -- the probe lived and
died entirely in `kumara/bin/` and one scratch `.rye` file, both deleted before this essay was
written.

## Grade

Composite 80, letter B, per `tools/fixtures/q/qa_report_card.sh --setting field --service 90`
(register 58, reach 70, truth 100, service 90 judged -- a closed falsifier from a named prior essay,
run rather than left open, with no new tracked instrument). No new witness, no new module; the
probe file and its binary are deleted before this lap that wrote it ends.
