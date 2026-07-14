# Pass 9918 · mem.rotate — left-rotate matches snapshot

**Witnesses:** 85 programs (grew from 84)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.030912`

## What this pass covers

**`std.mem.rotate`** — in-place left rotation via three `reverse` calls. Pairs with `mem.reverse` (9921) and `mem.swap` (9919).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.rotate`**

```zig
pub fn rotate(comptime T: type, items: []T, amount: usize) void {
    assert(amount <= items.len);
    const max_rotate_check: u32 = 64;
    var original: [max_rotate_check]T = undefined;
    const snapshot = items.len <= @as(usize, max_rotate_check);
    if (snapshot) {
        @memcpy(original[0..items.len], items);
    }
    reverse(T, items[0..amount]);
    reverse(T, items[amount..]);
    reverse(T, items);
    if (snapshot and items.len > 0) {
        var j: usize = 0;
        while (j < items.len) : (j += 1) {
            const src = (j + amount) % items.len;
            // Postcondition: left-rotate by amount (pairs with reverse 9921 and swap 9919).
            assert(eql(u8, asBytes(&items[j]), asBytes(&original[src])));
        }
    }
}
```

## Width notes

**`std.mem.rotate`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.rotate`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |
| `max_rotate_check` | `u32` (Tiger explicit) | Named snapshot/verify bound = 64 — design width, not `usize` | done |
| `@as(usize, usize, max_rotate_check)` | seam widen | TAME: `usize` only at slice seam — widen `u32` bound for `.len` compare | done |

### Witness `rye/tests/mem_rotate_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `rotate` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_rotate_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9918_mem_rotate.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9918 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.rotate` — [`misc`](../misc)

```zig
pub fn rotate(comptime T: type, items: []T, amount: usize) void {
    assert(amount <= items.len);
    const max_rotate_check: u32 = 64;
    var original: [max_rotate_check]T = undefined;
    const snapshot = items.len <= @as(usize, max_rotate_check);
    if (snapshot) {
        @memcpy(original[0..items.len], items);
    }
    reverse(T, items[0..amount]);
    reverse(T, items[amount..]);
    reverse(T, items);
    if (snapshot and items.len > 0) {
        var j: usize = 0;
        while (j < items.len) : (j += 1) {
            const src = (j + amount) % items.len;
            // Postcondition: left-rotate by amount (pairs with reverse 9921 and swap 9919).
            assert(eql(u8, asBytes(&items[j]), asBytes(&original[src])));
        }
    }
}
```

## Postconditions

Precondition: `amount <= items.len`. When `items.len <= 64` and `items.len > 0`, each index holds the original at `(j + amount) % len` (`eql(u8, asBytes(...))`).

## What the test asserts

- Five-element `i32` rotate by 2
- Four-element `u8` rotate by 1
- Rotate by 0 leaves order unchanged
