# Pass 9891 · mem.sort / sortUnstable — in-place slice sorting

**Witnesses:** 112 programs (grew from 111)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.030012`

## What this pass covers

**`std.mem.sort`** and **`sortUnstable`** — in-place slice sorting via `std.sort.block` (stable) and `std.sort.pdq` (unstable). Pairs with `reverse` (9921) and index-based `sortContext` / `sortUnstableContext` (future).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `items.len`, indices | inherited `usize` seam (Phase 4) |
| Snapshot / permutation bound | `u32` 64 + `assert(len <= bound)` |

## Rye std surface

```zig
pub fn sort(comptime T: type, items: []T, context: anytype, lessThanFn: ...) void {
    // snapshot when len <= 64
    std.sort.block(T, items, context, lessThanFn);
    assert(std.sort.isSorted(T, items, context, lessThanFn));
    verifySortedPermutation(T, original, items); // multiset preserved
}

pub fn sortUnstable(...) void {
    std.sort.pdq(T, items, context, lessThanFn);
    // same postconditions
}
```

(Runtime postconditions guarded with `!@inComptime()`.)

## Postconditions

After sort: `std.sort.isSorted` holds. When `len <= 64`, byte-wise multiset of elements unchanged (`verifySortedPermutation` via `asBytes` + `eql`).

## What the test asserts

- Stable `u8` sort → `1 2 3 5 8 9`
- Unstable `i32` sort → ascending `10 20 30`
