# Pass 9930 · mem.trim — both ends stay within the input

**Witnesses:** 73 programs (grew from 72)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.012812`

## What this pass covers

**`std.mem.trim`** — removes leading and trailing characters. Completes the trim witness family beside `trimStart` (9979) and `trimEnd` (9988); Rishi calls `trim` on every parsed line.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.trim`**

```zig
pub fn trim(comptime T: type, slice: []const T, values_to_strip: []const T) []const T {
    var begin: usize = 0;
    var end: usize = slice.len;
    while (begin < end and findScalar(T, values_to_strip, slice[begin]) != null) : (begin += 1) {}
    while (end > begin and findScalar(T, values_to_strip, slice[end - 1]) != null) : (end -= 1) {}
    // Postcondition: the two cursors close inward and never cross, so the result
    // is a contiguous sub-slice of the input — never longer, never out of bounds.
    assert(begin <= end);
    assert(end <= slice.len);
    const result = slice[begin..end];
    assert(result.len <= slice.len);
    assert(result.len == end - begin);
    return result;
}
```

## Width notes

**`std.mem.trim`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.trim`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_trim_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `trim` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_trim_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9930_mem_trim.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9930 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.trim` — [`misc`](../misc)

```zig
pub fn trim(comptime T: type, slice: []const T, values_to_strip: []const T) []const T {
    var begin: usize = 0;
    var end: usize = slice.len;
    while (begin < end and findScalar(T, values_to_strip, slice[begin]) != null) : (begin += 1) {}
    while (end > begin and findScalar(T, values_to_strip, slice[end - 1]) != null) : (end -= 1) {}
    // Postcondition: the two cursors close inward and never cross, so the result
    // is a contiguous sub-slice of the input — never longer, never out of bounds.
    assert(begin <= end);
    assert(end <= slice.len);
    const result = slice[begin..end];
    assert(result.len <= slice.len);
    assert(result.len == end - begin);
    return result;
}
```

## Postconditions

- `begin <= end` and `end <= slice.len` (existing)
- `result.len <= slice.len`
- `result.len == end - begin`

## What the test asserts

- Both ends stripped, no-op, empty input
- Result length never exceeds input
- Leading-only and trailing-only cases
