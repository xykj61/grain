# Pass 9950 · containsAtLeast — threshold tally agrees with scan bounds

**Witnesses:** 53 programs (grew from 52)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.185712`

## What this pass covers

**`std.mem.containsAtLeast`** and **`containsAtLeastScalar2`** — true when a needle or scalar appears at least N times (non-overlapping for needles). Pairs with `mem.count` (9951).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.containsAtLeast`**

```zig
pub fn containsAtLeast(comptime T: type, haystack: []const T, expected_count: usize, needle: []const T) bool {
    if (needle.len == 1) return containsAtLeastScalar(T, haystack, expected_count, needle[0]);
    assert(needle.len > 0);
    if (expected_count == 0) return true;

    var i: usize = 0;
    var found: usize = 0;

    while (findPos(T, haystack, i, needle)) |idx| {
        assert(idx >= i);
        assert(idx + needle.len <= haystack.len);
        i = idx + needle.len;
        found += 1;
        if (found == expected_count) {
            assert(found >= expected_count);
            return true;
        }
    }
    assert(found < expected_count);
    return false;
}
```

**`std..mem.containsAtLeastScalar2`**

```zig
pub fn containsAtLeastScalar2(comptime T: type, list: []const T, element: T, minimum: usize) bool {
    const n = list.len;
    var i: usize = 0;
    var found: usize = 0;

    if (use_vectors_for_comparison and
        (@typeInfo(T) == .int or @typeInfo(T) == .float) and std.math.isPowerOfTwo(@bitSizeOf(T)))
    {
        if (std.simd.suggestVectorLength(T)) |block_size| {
            const Block = @Vector(block_size, T);

            const letter_mask: Block = @splat(element);
            while (n - i >= block_size) : (i += block_size) {
                const haystack_block: Block = list[i..][0..block_size].*;
                found += std.simd.countTrues(letter_mask == haystack_block);
                if (found >= minimum) {
                    assert(found >= minimum);
                    assert(found <= list.len);
                    return true;
                }
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
        if (found >= minimum) {
            assert(found >= minimum);
            assert(found <= list.len);
            return true;
        }
    }

    assert(found < minimum);
    assert(found <= list.len);
    return false;
}
```

**`std.mem.containsAtLeastScalar2`**

```zig
pub fn containsAtLeastScalar2(comptime T: type, list: []const T, element: T, minimum: usize) bool {
    const n = list.len;
    var i: usize = 0;
    var found: usize = 0;

    if (use_vectors_for_comparison and
        (@typeInfo(T) == .int or @typeInfo(T) == .float) and std.math.isPowerOfTwo(@bitSizeOf(T)))
    {
        if (std.simd.suggestVectorLength(T)) |block_size| {
            const Block = @Vector(block_size, T);

            const letter_mask: Block = @splat(element);
            while (n - i >= block_size) : (i += block_size) {
                const haystack_block: Block = list[i..][0..block_size].*;
                found += std.simd.countTrues(letter_mask == haystack_block);
                if (found >= minimum) {
                    assert(found >= minimum);
                    assert(found <= list.len);
                    return true;
                }
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
        if (found >= minimum) {
            assert(found >= minimum);
            assert(found <= list.len);
            return true;
        }
    }

    assert(found < minimum);
    assert(found <= list.len);
    return false;
}
```

## Width notes

**`std.mem.containsAtLeast`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.containsAtLeast`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.containsAtLeastScalar2`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.containsAtLeastScalar2`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_contains_at_least_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `containsAtLeast` — Phase 4 `usize` seam policy applied | done |
| `misc` | `containsAtLeastScalar2` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `containsAtLeastScalar2` — inherited `usize` seam; assertions only | done |
| `rye/tests/mem_contains_at_least_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9950_mem_contains_at_least.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9950 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.containsAtLeast` — [`misc`](../misc)

```zig
pub fn containsAtLeast(comptime T: type, haystack: []const T, expected_count: usize, needle: []const T) bool {
    if (needle.len == 1) return containsAtLeastScalar(T, haystack, expected_count, needle[0]);
    assert(needle.len > 0);
    if (expected_count == 0) return true;

    var i: usize = 0;
    var found: usize = 0;

    while (findPos(T, haystack, i, needle)) |idx| {
        assert(idx >= i);
        assert(idx + needle.len <= haystack.len);
        i = idx + needle.len;
        found += 1;
        if (found == expected_count) {
            assert(found >= expected_count);
            return true;
        }
    }
    assert(found < expected_count);
    return false;
}
```

- [x] `std..mem.containsAtLeastScalar2` — [`misc`](../misc)

```zig
pub fn containsAtLeastScalar2(comptime T: type, list: []const T, element: T, minimum: usize) bool {
    const n = list.len;
    var i: usize = 0;
    var found: usize = 0;

    if (use_vectors_for_comparison and
        (@typeInfo(T) == .int or @typeInfo(T) == .float) and std.math.isPowerOfTwo(@bitSizeOf(T)))
    {
        if (std.simd.suggestVectorLength(T)) |block_size| {
            const Block = @Vector(block_size, T);

            const letter_mask: Block = @splat(element);
            while (n - i >= block_size) : (i += block_size) {
                const haystack_block: Block = list[i..][0..block_size].*;
                found += std.simd.countTrues(letter_mask == haystack_block);
                if (found >= minimum) {
                    assert(found >= minimum);
                    assert(found <= list.len);
                    return true;
                }
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
        if (found >= minimum) {
            assert(found >= minimum);
            assert(found <= list.len);
            return true;
        }
    }

    assert(found < minimum);
    assert(found <= list.len);
    return false;
}
```

- [x] `std.mem.containsAtLeastScalar2` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn containsAtLeastScalar2(comptime T: type, list: []const T, element: T, minimum: usize) bool {
    const n = list.len;
    var i: usize = 0;
    var found: usize = 0;

    if (use_vectors_for_comparison and
        (@typeInfo(T) == .int or @typeInfo(T) == .float) and std.math.isPowerOfTwo(@bitSizeOf(T)))
    {
        if (std.simd.suggestVectorLength(T)) |block_size| {
            const Block = @Vector(block_size, T);

            const letter_mask: Block = @splat(element);
            while (n - i >= block_size) : (i += block_size) {
                const haystack_block: Block = list[i..][0..block_size].*;
                found += std.simd.countTrues(letter_mask == haystack_block);
                if (found >= minimum) {
                    assert(found >= minimum);
                    assert(found <= list.len);
                    return true;
                }
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
        if (found >= minimum) {
            assert(found >= minimum);
            assert(found <= list.len);
            return true;
        }
    }

    assert(found < minimum);
    assert(found <= list.len);
    return false;
}
```

## Postconditions

**containsAtLeast** — same in-loop bounds as count; on return:

- `true` ⇒ `found >= expected_count`
- `false` ⇒ `found < expected_count`

**containsAtLeastScalar2**:

- `true` ⇒ `found >= minimum` and `found <= list.len`
- `false` ⇒ `found < minimum` and `found <= list.len`

## What the test asserts

- Scalar and multi-byte thresholds, met and unmet
- Non-overlapping `radar` case
- `containsAtLeastScalar2` on `adadda`
