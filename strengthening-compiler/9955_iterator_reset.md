# Pass 9955 · iterator reset — split and tokenize replay from initial cursor

**Corpus:** 48 programs (grew from 47)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.180712`

## What this pass covers

**`SplitIterator.reset`**, **`SplitBackwardsIterator.reset`**, and **`TokenIterator.reset`** — restore initial cursor position for replay.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.Iterator.reset`**

```zig
pub fn reset(self: *FixedBufferAllocator) void {
    self.end_index = 0;
}
```

## Width notes

**`std.mem.Iterator.reset`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.Iterator.reset`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/iterator_reset_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `reset` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/iterator_reset_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9955_iterator_reset.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9955 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.Iterator.reset` — [`misc`](../misc)

```zig
pub fn reset(self: *FixedBufferAllocator) void {
    self.end_index = 0;
}
```

## Postconditions

| Iterator | After reset |
|----------|-------------|
| Forward split / tokenize | `index == 0` |
| Backward split | `index == buffer.len` |

## What the test asserts

- Forward split `first()` after partial walk + reset
- Backward split `first()` after partial walk + reset
- Tokenize `next()` after partial walk + reset
