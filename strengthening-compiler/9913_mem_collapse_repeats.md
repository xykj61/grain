# Pass 9913 · mem.collapseRepeats — consecutive duplicates collapsed

**Witnesses:** 90 programs (grew from 89)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.034412`

## What this pass covers

**`std.mem.collapseRepeats`** and **`collapseRepeatsLen`** — in-place collapse of consecutive `elem` runs to one entry. Pairs with `replaceScalar` (9914); `os/windows` path normalization calls `collapseRepeatsLen` after separator swap.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.collapseRepeatsLen`**

```zig
pub fn collapseRepeatsLen(comptime T: type, slice: []T, elem: T) usize {
    const max_collapse_check: u32 = 64;
    var original: [max_collapse_check]T = undefined;
    const snapshot = slice.len <= @as(usize, max_collapse_check);
    if (snapshot) {
        @memcpy(original[0..slice.len], slice);
    }

    if (slice.len == 0) return 0;
    var write_idx: usize = 1;
    var read_idx: usize = 1;
    while (read_idx < slice.len) : (read_idx += 1) {
        if (slice[read_idx - 1] != elem or slice[read_idx] != elem) {
            slice[write_idx] = slice[read_idx];
            write_idx += 1;
        }
    }

    // Postcondition: consumed input, result fits (pairs with replaceScalar 9914, os/windows).
    assert(read_idx == slice.len);
    assert(write_idx <= slice.len);
    if (snapshot) {
        var expected: [max_collapse_check]T = undefined;
        var exp_len: usize = 0;
        if (slice.len > 0) {
            expected[0] = original[0];
            exp_len = 1;
            var r: usize = 1;
            while (r < slice.len) : (r += 1) {
                if (!(original[r - 1] == elem and original[r] == elem)) {
                    expected[exp_len] = original[r];
                    exp_len += 1;
                }
            }
        }
        assert(write_idx == exp_len);
        var j: usize = 0;
        while (j < write_idx) : (j += 1) {
            assert(eql(u8, asBytes(&slice[j]), asBytes(&expected[j])));
        }
    }
    return write_idx;
}
```

**`std..mem.collapseRepeats`**

```zig
pub fn collapseRepeats(comptime T: type, slice: []T, elem: T) []T {
    const collapsed_len = collapseRepeatsLen(T, slice, elem);
    assert(collapsed_len <= slice.len);
    return slice[0..collapsed_len];
}
```

**`std.mem.collapseRepeatsLen`**

```zig
pub fn collapseRepeatsLen(comptime T: type, slice: []T, elem: T) usize {
    const max_collapse_check: u32 = 64;
    var original: [max_collapse_check]T = undefined;
    const snapshot = slice.len <= @as(usize, max_collapse_check);
    if (snapshot) {
        @memcpy(original[0..slice.len], slice);
    }

    if (slice.len == 0) return 0;
    var write_idx: usize = 1;
    var read_idx: usize = 1;
    while (read_idx < slice.len) : (read_idx += 1) {
        if (slice[read_idx - 1] != elem or slice[read_idx] != elem) {
            slice[write_idx] = slice[read_idx];
            write_idx += 1;
        }
    }

    // Postcondition: consumed input, result fits (pairs with replaceScalar 9914, os/windows).
    assert(read_idx == slice.len);
    assert(write_idx <= slice.len);
    if (snapshot) {
        var expected: [max_collapse_check]T = undefined;
        var exp_len: usize = 0;
        if (slice.len > 0) {
            expected[0] = original[0];
            exp_len = 1;
            var r: usize = 1;
            while (r < slice.len) : (r += 1) {
                if (!(original[r - 1] == elem and original[r] == elem)) {
                    expected[exp_len] = original[r];
                    exp_len += 1;
                }
            }
        }
        assert(write_idx == exp_len);
        var j: usize = 0;
        while (j < write_idx) : (j += 1) {
            assert(eql(u8, asBytes(&slice[j]), asBytes(&expected[j])));
        }
    }
    return write_idx;
}
```

## Width notes

**`std.mem.collapseRepeatsLen`** / **`collapseRepeats`** — Public signatures inherit Zig `usize` for slice length and return. Snapshot bound `max_collapse_check: u32 = 64` at the slice seam.

| Surface | Width policy |
|---------|-------------|
| Inherited `slice: []T`, return `usize` | `usize` — Zig seam |
| Named snapshot bound | `u32` + `@as(usize, …)` |
| Postcondition compare | `eql(u8, asBytes(...))` per element |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.collapseRepeatsLen`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len`, return `usize` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |
| `max_collapse_check` | `u32` (Tiger explicit) | Named snapshot/verify bound = 64 — design width, not `usize` | done |
| `@as(usize, usize, max_collapse_check)` | seam widen | TAME: `usize` only at slice seam — widen `u32` bound for `.len` compare | done |

### `std..mem.collapseRepeats`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.collapseRepeatsLen`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len`, return `usize` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |
| `max_collapse_check` | `u32` (Tiger explicit) | Named snapshot/verify bound = 64 — design width, not `usize` | done |
| `@as(usize, usize, max_collapse_check)` | seam widen | TAME: `usize` only at slice seam — widen `u32` bound for `.len` compare | done |

### Witness `rye/tests/mem_collapse_repeats_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `collapseRepeatsLen` — Phase 4 `usize` seam policy applied | done |
| `misc` | `collapseRepeats` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `collapseRepeatsLen` — named `u32` bounds; public `usize` unchanged | done |
| `rye/tests/mem_collapse_repeats_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9913_mem_collapse_repeats.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9913 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.collapseRepeatsLen` — [`misc`](../misc)

```zig
pub fn collapseRepeatsLen(comptime T: type, slice: []T, elem: T) usize {
    const max_collapse_check: u32 = 64;
    var original: [max_collapse_check]T = undefined;
    const snapshot = slice.len <= @as(usize, max_collapse_check);
    if (snapshot) {
        @memcpy(original[0..slice.len], slice);
    }

    if (slice.len == 0) return 0;
    var write_idx: usize = 1;
    var read_idx: usize = 1;
    while (read_idx < slice.len) : (read_idx += 1) {
        if (slice[read_idx - 1] != elem or slice[read_idx] != elem) {
            slice[write_idx] = slice[read_idx];
            write_idx += 1;
        }
    }

    // Postcondition: consumed input, result fits (pairs with replaceScalar 9914, os/windows).
    assert(read_idx == slice.len);
    assert(write_idx <= slice.len);
    if (snapshot) {
        var expected: [max_collapse_check]T = undefined;
        var exp_len: usize = 0;
        if (slice.len > 0) {
            expected[0] = original[0];
            exp_len = 1;
            var r: usize = 1;
            while (r < slice.len) : (r += 1) {
                if (!(original[r - 1] == elem and original[r] == elem)) {
                    expected[exp_len] = original[r];
                    exp_len += 1;
                }
            }
        }
        assert(write_idx == exp_len);
        var j: usize = 0;
        while (j < write_idx) : (j += 1) {
            assert(eql(u8, asBytes(&slice[j]), asBytes(&expected[j])));
        }
    }
    return write_idx;
}
```

- [x] `std..mem.collapseRepeats` — [`misc`](../misc)

```zig
pub fn collapseRepeats(comptime T: type, slice: []T, elem: T) []T {
    const collapsed_len = collapseRepeatsLen(T, slice, elem);
    assert(collapsed_len <= slice.len);
    return slice[0..collapsed_len];
}
```

- [x] `std.mem.collapseRepeatsLen` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn collapseRepeatsLen(comptime T: type, slice: []T, elem: T) usize {
    const max_collapse_check: u32 = 64;
    var original: [max_collapse_check]T = undefined;
    const snapshot = slice.len <= @as(usize, max_collapse_check);
    if (snapshot) {
        @memcpy(original[0..slice.len], slice);
    }

    if (slice.len == 0) return 0;
    var write_idx: usize = 1;
    var read_idx: usize = 1;
    while (read_idx < slice.len) : (read_idx += 1) {
        if (slice[read_idx - 1] != elem or slice[read_idx] != elem) {
            slice[write_idx] = slice[read_idx];
            write_idx += 1;
        }
    }

    // Postcondition: consumed input, result fits (pairs with replaceScalar 9914, os/windows).
    assert(read_idx == slice.len);
    assert(write_idx <= slice.len);
    if (snapshot) {
        var expected: [max_collapse_check]T = undefined;
        var exp_len: usize = 0;
        if (slice.len > 0) {
            expected[0] = original[0];
            exp_len = 1;
            var r: usize = 1;
            while (r < slice.len) : (r += 1) {
                if (!(original[r - 1] == elem and original[r] == elem)) {
                    expected[exp_len] = original[r];
                    exp_len += 1;
                }
            }
        }
        assert(write_idx == exp_len);
        var j: usize = 0;
        while (j < write_idx) : (j += 1) {
            assert(eql(u8, asBytes(&slice[j]), asBytes(&expected[j])));
        }
    }
    return write_idx;
}
```

## Postconditions

`read_idx == slice.len`, `write_idx <= slice.len`. When `slice.len <= 64`, independent expected walk matches collapsed prefix byte-for-byte.

## What the test asserts

- Empty slice
- `//a` → `/a`
- `a//a` → `a/a`
- Long slash run from std tests
