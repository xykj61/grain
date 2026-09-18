# The binary that stays with its reading

**Language:** EN - **Style:** Gauge, Field - **Voice:** Kyri
**Stamp:** `20260912.151017` - **Status:** Landed - **Room:** checkable

## The fault

Eighteen Amphora witnesses each built the same three programs into `amphora/bin/`. A roster pass
and a hand-run witness could therefore share an output file while one process rewrote it. The
build-target instrument measured 110 fixed emit sites and 6 paths with multiple writers before
this lap. Amphora owned three of those shared paths, each with 18 writers.

## The repair

Each witness already opens a unique directory with `mktemp -d`. Its build now creates a `bin/`
directory there, writes every program into that directory, and runs those exact paths. Amphora's
main program finds `vessel-core` and `vessel-seal` beside its own executable, so the move keeps the
module's real sibling-resolution seam under test.

The same invocation now owns the binary from build through execution. A concurrent roster pass
uses another pen and cannot rewrite it.

## The reading

All 18 Amphora witnesses ran GREEN on metal after the move. The build-target control kept all 33
legs, including both ratchet refusals. Its live reading moved:

```
emit_fixed=51
shared_paths=2
max_writers=2
emit_tracked=0
emit_unignored=0
verdict=ok
```

The seated ceilings fell with the measured population, from 110 to 51 fixed sites and from 6 to 2
shared paths. A new fixed writer or shared output therefore refuses on the lap where it arrives.

## What remains

Two shared build paths remain outside Amphora. They belong to their module lanes and stay visible
through the same scan. The instrument reports them without making this lap reach across ownership.
