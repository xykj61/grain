# Fold head, beside current

**Stamp:** `20261009.141530`
**Language:** EN
**Style:** Bhakta Radiant, at Gauge Field (see `../../../context/GAUGE_STYLE.md`)
**Voice:** Kyri
**Status:** Checkable -- the function names below are marked with their path and line, read `20261009.141530`
**Room:** designing -- this is the shape worth reading after the function names change
**Kin:** [`../../../active-development/20261007-095245_the-center-learned.md`](../../../active-development/20261007-095245_the-center-learned.md) - [`../../../foundations/20261003-220920_the-fold-from-the-fact-to-the-frame.md`](../../../foundations/20261003-220920_the-fold-from-the-fact-to-the-frame.md)

## The one sentence Orbit 6's second note owed

The silo names the center as **fold head**: the one place that holds what is true right now,
reached by folding every fact in order rather than by keeping a second copy anywhere.

## Where that sentence lives in running code

One function receives a fact. One function reads the center back.

```1376:mantra/src/weave.rye
pub fn apply(self: *Weave, allocator: std.mem.Allocator, diff: Diff) !void {
```

`apply` takes one `Diff` and lands it on the weave -- the fold, happening.

```1689:1703:mantra/src/weave.rye
pub fn current(self: *const Weave, allocator: std.mem.Allocator) ![]const Line {
    ...
    for (self.lines.items, 0..) |line, i| {
        ...
        if (line.gen % 2 == 1) { // odd = present
            try out.append(allocator, line);
        }
    }
```

`current` is the fold head, read back. Each line carries a generation that starts at one; a
delete bumps it, so an odd generation is a line still standing and an even one is a line laid to
rest. The function asks that one small question of every line in order, and what comes back is
the picture as it stands right now -- nothing stored twice, nothing recomputed from scratch.

## Why this is worth a sentence of its own

A reader who has never opened `weave.rye` meets `apply` and `current` and already knows the
whole shape: one door in, one door out, and the parity of a number deciding whether a line is
still part of the story. The fold page this note sits beside already teaches the shape without
the function names; this note is where the two meet.

A witness already proves both functions: `tools/m/mantra_diff_witness.rish`, named on
`mantra/README.md`. This note does not run it; a future round that touches `weave.rye` should.

May the center stay one place, and the parity of a number keep doing honest work nobody has to
remember by hand.
