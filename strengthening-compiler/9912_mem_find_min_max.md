# Pass 9912 · mem.findMin / findMax — extremum index stays in-range

**Witnesses:** 91 programs (grew from 90)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.001112`

## What this pass covers

**`std.mem.min`**, **`max`**, **`minMax`**, **`findMin`**, **`findMax`**, and **`findMinMax`** — linear scan for slice extrema and their indices. Snapshot verify when `slice.len <= 64`.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.mem.findMin`**

```zig
pub fn findMin(comptime T: type, slice: []const T) usize {
    assert(slice.len > 0);
    var best = slice[0];
    var index: usize = 0;
    for (slice[1..], 0..) |item, i| {
        if (item < best) {
            best = item;
            index = i + 1;
        }
    }
    // Postcondition: index is the first position of the minimum value.
    assert(index < slice.len);
    assert(slice[index] == best);
    const max_minmax_check: u32 = 64;
    if (slice.len <= @as(usize, max_minmax_check)) {
        for (slice) |item| assert(best <= item);
    }
    return index;
}
```

**`std.mem.findMax`**

```zig
pub fn findMax(comptime T: type, slice: []const T) usize {
    assert(slice.len > 0);
    var best = slice[0];
    var index: usize = 0;
    for (slice[1..], 0..) |item, i| {
        if (item > best) {
            best = item;
            index = i + 1;
        }
    }
    // Postcondition: index is the first position of the maximum value.
    assert(index < slice.len);
    assert(slice[index] == best);
    const max_minmax_check: u32 = 64;
    if (slice.len <= @as(usize, max_minmax_check)) {
        for (slice) |item| assert(best >= item);
    }
    return index;
}
```

**`std.mem.findMinMax`**

```zig
pub fn findMinMax(comptime T: type, slice: []const T) struct { usize, usize } {
    assert(slice.len > 0);
    var minVal = slice[0];
    var maxVal = slice[0];
    var minIdx: usize = 0;
    var maxIdx: usize = 0;
    for (slice[1..], 0..) |item, i| {
        if (item < minVal) {
            minVal = item;
            minIdx = i + 1;
        }
        if (item > maxVal) {
            maxVal = item;
            maxIdx = i + 1;
        }
    }
    // Postcondition: indices point at the first min and first max in the slice.
    assert(minIdx < slice.len);
    assert(maxIdx < slice.len);
    assert(slice[minIdx] == minVal);
    assert(slice[maxIdx] == maxVal);
    const max_minmax_check: u32 = 64;
    if (slice.len <= @as(usize, max_minmax_check)) {
        for (slice) |item| {
            assert(minVal <= item);
            assert(maxVal >= item);
        }
    }
    return .{ minIdx, maxIdx };
}
```

## Width notes

**`std.mem.findMin`** / **`findMax`** / **`findMinMax`** — Public signatures inherit Zig `usize` for slice length and return. Snapshot bound `max_minmax_check: u32 = 64` at the slice seam.

| Surface | Width policy |
|---------|-------------|
| Inherited `slice: []T`, return `usize` | `usize` — Zig seam |
| Named snapshot bound | `u32` + `@as(usize, …)` |
| Postcondition compare | index in-range + value at index |

## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.

### `std.mem.findMin`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len`, return `usize` | inherited `usize` (Tier C) | inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only | done |
| `max_minmax_check` | `u32` (Tiger explicit) | Named snapshot bound = 64 | done |

### `std.mem.findMax`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len`, return `usize` | inherited `usize` (Tier C) | inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only | done |
| `max_minmax_check` | `u32` (Tiger explicit) | Named snapshot bound = 64 | done |

### `std.mem.findMinMax`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len`, return `usize` pair | inherited `usize` (Tier C) | inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only | done |
| `max_minmax_check` | `u32` (Tiger explicit) | Named snapshot bound = 64 | done |

### Witness `rye/tests/mem_find_min_max_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — no authored `usize` fields | done |
| witness body | value checks only | compares min/max and index results | done |

## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/mem.zig` | `min`/`max`/`minMax`/`findMin`/`findMax`/`findMinMax` — named `u32` bounds | done |
| `rye/tests/mem_find_min_max_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9912_mem_find_min_max.md` | pass record + audited surfaces | done |

## Postconditions

`findMin`/`findMax`: returned index in-range and points at the extremum; when `len <= 64`, independent walk confirms no smaller/larger element exists. `findMinMax`: both indices and values agree; snapshot walk confirms bounds. `min`/`max`/`minMax`: returned values bracket every element when `len <= 64`.

## What the test asserts

- `min`/`max` on `"abcdefg"` and permutations
- `minMax` returns `'a'` and `'g'`
- `findMin` first at 0, last at 6 for `"bcdefga"`
- `findMax` at 6 and 0 for reversed strings
- `findMinMax` returns `(0, 6)` on `"abcdefg"`
