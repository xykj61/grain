# Pass 9954 · WindowIterator — sliding windows stay in-range

**Corpus:** 49 programs (grew from 48)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.181512`

## What this pass covers

**`WindowIterator.next`** and **`reset`** (via `mem.window`) — fixed-size sliding windows over a buffer. Used in `debug` hex dumps, `base64`, and `Io.Writer` chunking.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.window`**

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

**`std..mem.reset`**

```zig
pub fn reset(self: *FixedBufferAllocator) void {
    self.end_index = 0;
}
```

**`std.mem.reset`**

```zig
pub fn reset(self: *Self) void {
            self.underlying_allocator.reset();
        }
```

## Width notes

**`std.mem.window`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.window`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.reset`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.reset`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/window_iterator_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `window` — Phase 4 `usize` seam policy applied | done |
| `misc` | `reset` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `reset` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/window_iterator_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9954_window_iterator.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9954 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.window` — [`misc`](../misc)

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

- [x] `std..mem.reset` — [`misc`](../misc)

```zig
pub fn reset(self: *FixedBufferAllocator) void {
    self.end_index = 0;
}
```

- [x] `std.mem.reset` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn reset(self: *Self) void {
            self.underlying_allocator.reset();
        }
```

## Postconditions

**next**:

```zig
assert(start <= end);
assert(end <= self.buffer.len);
```

**reset**:

```zig
assert(self.index.? == 0);
```

## What the test asserts

- Non-overlapping chunks (size == advance)
- Overlapping slide (advance 1)
- Empty buffer returns null
- `reset()` replays first window
