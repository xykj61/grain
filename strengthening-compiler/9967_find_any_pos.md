# Pass 9967 · findAnyPos and findAny — any-delimiter search stays in-range

**Corpus:** 36 programs (grew from 35)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.165812`

## What this pass covers

**`std.mem.findAnyPos`** and **`std.mem.findAny`** — search for any of a set of scalar delimiters. Backs `splitAny` inside `SplitIterator`; pairs with `findScalarPos` (9974).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.findAnyPos`**

```zig
pub fn findAnyPos(comptime T: type, slice: []const T, start_index: usize, values: []const T) ?usize {
    if (start_index >= slice.len) return null;
    for (slice[start_index..], start_index..) |c, i| {
        for (values) |value| {
            if (c == value) {
                // Postcondition: a found index lands inside the slice at a sought value.
                assert(i < slice.len);
                assert(slice[i] == value);
                assert(i >= start_index);
                return i;
            }
        }
    }
    return null;
}
```

**`std..mem.findAny`**

```zig
pub fn findAny(comptime T: type, slice: []const T, values: []const T) ?usize {
    const result = findAnyPos(T, slice, 0, values);
    // Postcondition at cold wrapper (pairs with findScalar, 9996).
    if (result) |i| {
        assert(i < slice.len);
        var matched = false;
        for (values) |value| {
            if (slice[i] == value) matched = true;
        }
        assert(matched);
    }
    return result;
}
```

## Width notes

**`std.mem.findAnyPos`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |

**`std.mem.findAny`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.findAnyPos`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.findAny`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/find_any_pos_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `findAnyPos` — Phase 4 `usize` seam policy applied | done |
| `misc` | `findAny` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/find_any_pos_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9967_find_any_pos.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9967 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.findAnyPos` — [`misc`](../misc)

```zig
pub fn findAnyPos(comptime T: type, slice: []const T, start_index: usize, values: []const T) ?usize {
    if (start_index >= slice.len) return null;
    for (slice[start_index..], start_index..) |c, i| {
        for (values) |value| {
            if (c == value) {
                // Postcondition: a found index lands inside the slice at a sought value.
                assert(i < slice.len);
                assert(slice[i] == value);
                assert(i >= start_index);
                return i;
            }
        }
    }
    return null;
}
```

- [x] `std..mem.findAny` — [`misc`](../misc)

```zig
pub fn findAny(comptime T: type, slice: []const T, values: []const T) ?usize {
    const result = findAnyPos(T, slice, 0, values);
    // Postcondition at cold wrapper (pairs with findScalar, 9996).
    if (result) |i| {
        assert(i < slice.len);
        var matched = false;
        for (values) |value| {
            if (slice[i] == value) matched = true;
        }
        assert(matched);
    }
    return result;
}
```

## Postconditions

**findAnyPos** on match:

```zig
assert(i < slice.len);
assert(slice[i] == value);
assert(i >= start_index);
```

**findAny** cold wrapper:

```zig
assert(i < slice.len);
assert(slice[i] matches one of values);
```

## What the test asserts

- First delimiter from zero
- Next delimiter from offset
- Past end returns null
- Whitespace set for trim-adjacent scans
- findAny from start finds vowel
- findAny absent set returns null
