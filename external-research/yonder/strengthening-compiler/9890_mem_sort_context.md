# Pass 9890 · mem.sortContext / sortUnstableContext — index-based sorting

**Witnesses:** 113 programs (grew from 112)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.030312`

## What this pass covers

**`std.mem.sortContext`** and **`sortUnstableContext`** — index-based in-place sorting via `std.sort.insertionContext` (stable) and `std.sort.pdqContext` (unstable). Pairs with slice wrappers `sort` / `sortUnstable` (9891).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `a`, `b`, indices | inherited `usize` seam (Phase 4) |

## Rye std surface

```zig
pub fn sortContext(a: usize, b: usize, context: anytype) void {
    assert(a <= b);
    std.sort.insertionContext(a, b, context);
    assert(isSortedContextRange(a, b, context));
}

pub fn sortUnstableContext(a: usize, b: usize, context: anytype) void {
    assert(a <= b);
    std.sort.pdqContext(a, b, context);
    assert(isSortedContextRange(a, b, context));
}
```

(Runtime postconditions guarded with `!@inComptime()`.)

## Postconditions

`isSortedContextRange`: for all `i` in `(a, b)`, `!context.lessThan(i, i - 1)`.

## What the test asserts

- Stable `sortContext` on `u8` → `1 2 3 5 8 9`
- Unstable `sortUnstableContext` on `i32` → `10 15 20 30`
