# Pass 9914 · mem.replaceScalar — in-place scalar swap verified

**Witnesses:** 89 programs (grew from 88)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.033712`

## What this pass covers

**`std.mem.replaceScalar`** — replace every `match` scalar in a mutable slice with `replacement`. Pairs with the replace trio (9915–9917); `std` path normalization uses it (`zip`, `tar`, `os/windows`).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.replaceScalar`**

```zig
pub fn replaceScalar(comptime T: type, slice: []T, match: T, replacement: T) void {
    const max_replace_scalar_check: u32 = 64;
    var original: [max_replace_scalar_check]T = undefined;
    const snapshot = slice.len <= @as(usize, max_replace_scalar_check);
    if (snapshot) {
        @memcpy(original[0..slice.len], slice);
    }
    for (slice) |*e| {
        if (e.* == match)
            e.* = replacement;
    }
    if (snapshot) {
        for (slice, 0..) |*e, i| {
            if (original[i] == match) {
                // Postcondition: matches became replacement (pairs with replace 9917).
                assert(eql(u8, asBytes(e), asBytes(&replacement)));
            } else {
                assert(eql(u8, asBytes(e), asBytes(&original[i])));
            }
        }
    }
}
```

## Width notes

**`std.mem.replaceScalar`** — Public signature inherits Zig `usize` for slice length. Snapshot bound `max_replace_scalar_check: u32 = 64` at the slice seam.

| Surface | Width policy |
|---------|-------------|
| Inherited `slice: []T` | `usize` — Zig seam |
| Named snapshot bound | `u32` + `@as(usize, …)` |
| Postcondition compare | `eql(u8, asBytes(...))` for any `T` |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.replaceScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |
| `max_replace_scalar_check` | `u32` (Tiger explicit) | Named snapshot/verify bound = 64 — design width, not `usize` | done |
| `@as(usize, usize, max_replace_scalar_check)` | seam widen | TAME: `usize` only at slice seam — widen `u32` bound for `.len` compare | done |

### Witness `rye/tests/mem_replace_scalar_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `replaceScalar` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_replace_scalar_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9914_mem_replace_scalar.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9914 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.replaceScalar` — [`misc`](../misc)

```zig
pub fn replaceScalar(comptime T: type, slice: []T, match: T, replacement: T) void {
    const max_replace_scalar_check: u32 = 64;
    var original: [max_replace_scalar_check]T = undefined;
    const snapshot = slice.len <= @as(usize, max_replace_scalar_check);
    if (snapshot) {
        @memcpy(original[0..slice.len], slice);
    }
    for (slice) |*e| {
        if (e.* == match)
            e.* = replacement;
    }
    if (snapshot) {
        for (slice, 0..) |*e, i| {
            if (original[i] == match) {
                // Postcondition: matches became replacement (pairs with replace 9917).
                assert(eql(u8, asBytes(e), asBytes(&replacement)));
            } else {
                assert(eql(u8, asBytes(e), asBytes(&original[i])));
            }
        }
    }
}
```

## Postconditions

When `slice.len <= 64`, snapshot before mutation; after loop each index is either `replacement` (was `match`) or unchanged (`eql(u8, asBytes(...))`).

## What the test asserts

- Path separator `\\` → `/`
- All-`x` → all-`y`
- `i32` selective replacement
