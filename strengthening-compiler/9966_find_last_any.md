# Pass 9966 · findLastAny — backward any-delimiter search stays in-range

**Corpus:** 37 programs (grew from 36)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.170312`

## What this pass covers

**`std.mem.findLastAny`** (`lastIndexOfAny`) — backward search for any of a set of scalars. Backs `SplitBackwardsIterator` with `.any` delimiters; pairs with `findAnyPos` (9967).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.findLastAny`**

```zig
pub fn findLastAny(comptime T: type, slice: []const T, values: []const T) ?usize {
    var i: usize = slice.len;
    while (i != 0) {
        i -= 1;
        for (values) |value| {
            if (slice[i] == value) {
                // Postcondition: a found index lands inside the slice at a sought value.
                assert(i < slice.len);
                assert(slice[i] == value);
                return i;
            }
        }
    }
    return null;
}
```

## Width notes

**`std.mem.findLastAny`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.findLastAny`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/find_last_any_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `findLastAny` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/find_last_any_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9966_find_last_any.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9966 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.findLastAny` — [`misc`](../misc)

```zig
pub fn findLastAny(comptime T: type, slice: []const T, values: []const T) ?usize {
    var i: usize = slice.len;
    while (i != 0) {
        i -= 1;
        for (values) |value| {
            if (slice[i] == value) {
                // Postcondition: a found index lands inside the slice at a sought value.
                assert(i < slice.len);
                assert(slice[i] == value);
                return i;
            }
        }
    }
    return null;
}
```

## Postcondition

On match:

```zig
assert(i < slice.len);
assert(slice[i] == value);
```

## What the test asserts

- Last match in mixed string (std upstream case)
- Last delimiter in path-like string
- Repeated scalar returns final index
- Absent set returns null
