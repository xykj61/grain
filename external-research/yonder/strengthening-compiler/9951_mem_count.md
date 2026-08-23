# Pass 9951 · mem.count — non-overlapping needle tally stays in bounds

**Witnesses:** 52 programs (grew from 51)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.184712`

## What this pass covers

**`std.mem.count`** and **`countScalar`** — tally non-overlapping needle occurrences (or scalar elements). Complements `findPos` (9971) and `contains` patterns in string builtins.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.count`**

```zig
pub fn count(set: Set) std.math.IntFittingRange(0, needed_bit_count) {
                var sum: usize = 0;
                for (set.ints) |x| sum += @popCount(x);
                return @intCast(sum);
            }
```

**`std..mem.countScalar`**

```zig
pub fn countScalar(comptime T: type, list: []const T, element: T) usize {
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
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
    }

    // Postcondition: tally never exceeds slice length.
    assert(found <= list.len);
    return found;
}
```

**`std.mem.countScalar`**

```zig
pub fn countScalar(comptime T: type, list: []const T, element: T) usize {
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
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
    }

    // Postcondition: tally never exceeds slice length.
    assert(found <= list.len);
    return found;
}
```

## Width notes

**`std.mem.count`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../../../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../../../context/TAME_STYLE.md), [`10024`](../../../expanding-prompts/date/20260620/20260620-210812_explicit-width-audit.md), [`992`](../../../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std...mem.count`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `std...mem.count` | — | Live `pub fn` not located — cannot run Tiger/TAME audit | pending |

### `std...mem.countScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len`, return `usize` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.countScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len`, return `usize` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.count`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `std..mem.count` | — | Live `pub fn` not located — cannot run Tiger/TAME audit | pending |

### `std.mem.countScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len`, return `usize` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_count_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `count` — Phase 4 `usize` seam policy applied | pending |
| `misc` | `countScalar` — co-strengthened in this pass | pending |
| `misc` | `countScalar` — co-strengthened in this pass | pending |
| `misc` | `count` — co-strengthened in this pass | pending |
| `rye/lib/std/mem.zig` | `countScalar` — co-strengthened in this pass | pending |
| `rye/tests/mem_count_test.rye` | witness program | pending |
| `tools/p/parity.rish` | witness registered | pending |
| `external-research/yonder/strengthening-compiler/9951_mem_count.md` | pass record + audited surfaces | pending |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | pending |
| `992_strengthening_width_crosswalk.md` | lexicon row 9951 | pending |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../../../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [ ] `std...mem.count` — [`misc`](../../../misc)

```zig
pub fn count(set: Set) std.math.IntFittingRange(0, needed_bit_count) {
                var sum: usize = 0;
                for (set.ints) |x| sum += @popCount(x);
                return @intCast(sum);
            }
```

- [x] `std...mem.countScalar` — [`misc`](../../../misc)

```zig
pub fn countScalar(comptime T: type, list: []const T, element: T) usize {
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
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
    }

    // Postcondition: tally never exceeds slice length.
    assert(found <= list.len);
    return found;
}
```

- [x] `std..mem.countScalar` — [`misc`](../../../misc)

```zig
pub fn countScalar(comptime T: type, list: []const T, element: T) usize {
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
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
    }

    // Postcondition: tally never exceeds slice length.
    assert(found <= list.len);
    return found;
}
```

- [ ] `std..mem.count` — [`misc`](../../../misc)

```zig
pub fn count(set: Set) std.math.IntFittingRange(0, needed_bit_count) {
                var sum: usize = 0;
                for (set.ints) |x| sum += @popCount(x);
                return @intCast(sum);
            }
```

- [x] `std.mem.countScalar` — [`rye/lib/std/mem.zig`](../../../rye/lib/std/mem.zig)

```zig
pub fn countScalar(comptime T: type, list: []const T, element: T) usize {
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
            }
        }
    }

    for (list[i..n]) |item| {
        found += @intFromBool(item == element);
    }

    // Postcondition: tally never exceeds slice length.
    assert(found <= list.len);
    return found;
}
```

## Postconditions

**count** — each match and final state:

```zig
assert(idx >= i);
assert(idx + needle.len <= haystack.len);
assert(i <= haystack.len);
assert(found <= haystack.len);
```

**countScalar**:

```zig
assert(found <= list.len);
```

## What the test asserts

- Empty haystack, single and double scalar hits
- Multi-byte needle non-overlap (`foo`, `ff`, `abc`)
- `countScalar` on spaced `abc` string
