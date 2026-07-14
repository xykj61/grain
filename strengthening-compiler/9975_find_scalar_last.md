# Pass 9975 · findScalarLast — last match stays in-range at the sought value

**Corpus:** 28 programs (grew from 27)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.162712`

## What this pass covers

**`std.mem.findScalarLast`** (`lastIndexOfScalar`) — linear search for the last occurrence of a scalar in a slice. Backs `path.extension` and `path.stem`; pairs with `findScalar` (9996).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.findScalarLast`**

```zig
pub fn findScalarLast(comptime T: type, slice: []const T, value: T) ?usize {
    var i: usize = slice.len;
    while (i != 0) {
        i -= 1;
        if (slice[i] == value) {
            const result = i;
            // Postcondition: a found index lands inside the slice at the sought value.
            assert(result < slice.len);
            assert(slice[result] == value);
            return result;
        }
    }
    return null;
}
```

## Width notes

**`std.mem.findScalarLast`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.findScalarLast`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/find_scalar_last_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `findScalarLast` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/find_scalar_last_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9975_find_scalar_last.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9975 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.findScalarLast` — [`misc`](../misc)

```zig
pub fn findScalarLast(comptime T: type, slice: []const T, value: T) ?usize {
    var i: usize = slice.len;
    while (i != 0) {
        i -= 1;
        if (slice[i] == value) {
            const result = i;
            // Postcondition: a found index lands inside the slice at the sought value.
            assert(result < slice.len);
            assert(slice[result] == value);
            return result;
        }
    }
    return null;
}
```

## Postcondition

On return when a match is found:

```zig
assert(result < slice.len);
assert(slice[result] == value);
```

## What the test asserts

- Last occurrence wins over earlier matches
- Repeated scalar returns the final index
- Missing scalar returns null
- Empty slice returns null
- Path-like string finds the last dot
