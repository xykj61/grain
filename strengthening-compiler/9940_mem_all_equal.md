# Pass 9940 · allEqual — every element matches the scalar

**Witnesses:** 63 programs (grew from 62)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.195612`

## What this pass covers

**`std.mem.allEqual`** — tests whether every element in a slice equals a scalar. Complements `eql` (9941) and `count` (9951).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.allEqual`**

```zig
pub fn allEqual(comptime T: type, slice: []const T, scalar: T) bool {
    for (slice) |item| {
        if (item != scalar) {
            assert(item != scalar);
            return false;
        }
    }
    // Postcondition: every element matches scalar (vacuously true when empty).
    for (slice) |item| assert(item == scalar);
    return true;
}
```

## Width notes

**`std.mem.allEqual`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.allEqual`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_all_equal_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `allEqual` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_all_equal_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9940_mem_all_equal.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9940 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.allEqual` — [`misc`](../misc)

```zig
pub fn allEqual(comptime T: type, slice: []const T, scalar: T) bool {
    for (slice) |item| {
        if (item != scalar) {
            assert(item != scalar);
            return false;
        }
    }
    // Postcondition: every element matches scalar (vacuously true when empty).
    for (slice) |item| assert(item == scalar);
    return true;
}
```

## Postconditions

- `false` ⇒ found element differs from scalar
- `true` ⇒ every element equals scalar (vacuous when empty)

## What the test asserts

- Uniform run, mixed run, empty slice
- Single-element match and mismatch
- Whitespace uniformity
