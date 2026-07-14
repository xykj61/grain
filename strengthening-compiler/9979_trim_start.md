# Pass 9979 · trimStart — leading strip stays within the input

**Corpus:** 24 programs (grew from 23)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.152712`

## What this pass covers

**`std.mem.trimStart`** — removes leading characters from a slice. Rishi calls it indirectly through `trim` on every line; the arithmetic parser and `let` binder trim leading whitespace before names and values.

Completes the trim family alongside `trim` (9996) and `trimEnd` (9982).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.trimStart`**

```zig
pub fn trimStart(comptime T: type, slice: []const T, values_to_strip: []const T) []const T {
    var begin: usize = 0;
    while (begin < slice.len and findScalar(T, values_to_strip, slice[begin]) != null) : (begin += 1) {}
    const result = slice[begin..];
    // Postcondition: trimStart only shortens or preserves the slice; it never extends it.
    assert(begin <= slice.len);
    assert(result.len <= slice.len);
    return result;
}
```

## Width notes

**`std.mem.trimStart`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.trimStart`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/trim_start_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `trimStart` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/trim_start_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9979_trim_start.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9979 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.trimStart` — [`misc`](../misc)

```zig
pub fn trimStart(comptime T: type, slice: []const T, values_to_strip: []const T) []const T {
    var begin: usize = 0;
    while (begin < slice.len and findScalar(T, values_to_strip, slice[begin]) != null) : (begin += 1) {}
    const result = slice[begin..];
    // Postcondition: trimStart only shortens or preserves the slice; it never extends it.
    assert(begin <= slice.len);
    assert(result.len <= slice.len);
    return result;
}
```

## Postcondition

```zig
assert(begin <= slice.len);
assert(result.len <= slice.len);
```

## What the test asserts

- Leading whitespace removed
- No-op when nothing to strip
- Empty input returns empty
- Result length never exceeds input length
- Trailing characters left untouched

## Design notes

Same contract as `trimEnd`: the cursor advances inward from the start and the returned slice never extends past the input bounds.
