# Pass 9931 · mem.window factory — sliding window starts at buffer front

**Witnesses:** 72 programs (grew from 71)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.212412`

## What this pass covers

**`mem.window`** — factory postconditions beside strengthened `WindowIterator` (`9954`) and sibling factories (`9932`–`9934`).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.mem.window`**

```zig
pub fn window(comptime T: type, buffer: []const T, size: usize, advance: usize) WindowIterator(T) {
    assert(size != 0);
    assert(advance != 0);
    const it: WindowIterator(T) = .{
        .index = if (buffer.len > 0) 0 else null,
        .buffer = buffer,
        .size = size,
        .advance = advance,
    };
    if (buffer.len > 0) {
        assert(it.index.? == 0);
        assert(it.index.? <= buffer.len);
    } else {
        assert(it.index == null);
    }
    assert(it.size == size);
    assert(it.advance == advance);
    return it;
}
```

## Width notes

**`std.mem.window_factory`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |








## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std.mem.window`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_window_factory_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/mem.zig` | `window` — inherited `usize` seam; assertions only | done |
| `rye/tests/mem_window_factory_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9931_mem_window_factory.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9931 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std.mem.window` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn window(comptime T: type, buffer: []const T, size: usize, advance: usize) WindowIterator(T) {
    assert(size != 0);
    assert(advance != 0);
    const it: WindowIterator(T) = .{
        .index = if (buffer.len > 0) 0 else null,
        .buffer = buffer,
        .size = size,
        .advance = advance,
    };
    if (buffer.len > 0) {
        assert(it.index.? == 0);
        assert(it.index.? <= buffer.len);
    } else {
        assert(it.index == null);
    }
    assert(it.size == size);
    assert(it.advance == advance);
    return it;
}
```

## Postconditions

On return from `window`:

- `size != 0` and `advance != 0` (precondition, unchanged)
- Non-empty buffer: `index == 0` and `index <= buffer.len`
- Empty buffer: `index == null`
- `size` and `advance` match arguments

## What the test asserts

- Chunk and slide modes yield expected first windows at creation
- Empty buffer yields null immediately
- Window larger than buffer returns the whole buffer once
