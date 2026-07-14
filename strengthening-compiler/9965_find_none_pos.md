# Pass 9965 · findNonePos and findNone — strspn search stays outside the set

**Corpus:** 38 programs (grew from 37)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.171112`

## What this pass covers

**`std.mem.findNonePos`** and **`std.mem.findNone`** — find the first scalar not in a set (`strspn`-like). Pairs with `findAnyPos` (9967).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.findNonePos`**

```zig
pub fn findNonePos(comptime T: type, slice: []const T, start_index: usize, values: []const T) ?usize {
    if (start_index >= slice.len) return null;
    outer: for (slice[start_index..], start_index..) |c, i| {
        for (values) |value| {
            if (c == value) continue :outer;
        }
        // Postcondition: a found index lands inside the slice outside the sought set.
        assert(i < slice.len);
        assert(i >= start_index);
        for (values) |v| assert(slice[i] != v);
        return i;
    }
    return null;
}
```

**`std..mem.findNone`**

```zig
pub fn findNone(comptime T: type, slice: []const T, values: []const T) ?usize {
    const result = findNonePos(T, slice, 0, values);
    // Postcondition at cold wrapper (pairs with findAny, 9967).
    if (result) |i| {
        assert(i < slice.len);
        for (values) |value| assert(slice[i] != value);
    }
    return result;
}
```

## Width notes

**`std.mem.findNonePos`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |

**`std.mem.findNone`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.findNonePos`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.findNone`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/find_none_pos_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `findNonePos` — Phase 4 `usize` seam policy applied | done |
| `misc` | `findNone` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/find_none_pos_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9965_find_none_pos.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9965 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.findNonePos` — [`misc`](../misc)

```zig
pub fn findNonePos(comptime T: type, slice: []const T, start_index: usize, values: []const T) ?usize {
    if (start_index >= slice.len) return null;
    outer: for (slice[start_index..], start_index..) |c, i| {
        for (values) |value| {
            if (c == value) continue :outer;
        }
        // Postcondition: a found index lands inside the slice outside the sought set.
        assert(i < slice.len);
        assert(i >= start_index);
        for (values) |v| assert(slice[i] != v);
        return i;
    }
    return null;
}
```

- [x] `std..mem.findNone` — [`misc`](../misc)

```zig
pub fn findNone(comptime T: type, slice: []const T, values: []const T) ?usize {
    const result = findNonePos(T, slice, 0, values);
    // Postcondition at cold wrapper (pairs with findAny, 9967).
    if (result) |i| {
        assert(i < slice.len);
        for (values) |value| assert(slice[i] != value);
    }
    return result;
}
```

## Postconditions

**findNonePos** on match:

```zig
assert(i < slice.len);
assert(i >= start_index);
for (values) |v| assert(slice[i] != v);
```

**findNone** cold wrapper:

```zig
assert(i < slice.len);
for (values) |value| assert(slice[i] != value);
```

## What the test asserts

- First non-digit in mixed string
- Skip leading digits
- All-in-set returns null
- Absent set returns null
- Positional search past tail returns null
- Positional search from offset finds first outside set
