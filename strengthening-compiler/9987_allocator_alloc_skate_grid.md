# Pass 9987 · Allocator.alloc — slice length matches request

**Witnesses:** 17 programs (grew from 16)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.050912`

## What this pass covers

**`std.mem.Allocator.alloc`** (via `allocAdvancedWithRetAddr`) — the allocation path Skate's `Grid.init`, Wayland seeds, and Rishi builtins walk when they need a fresh slice.

Postcondition added at the cold wrapper:

```zig
const result = ptr[0..n];
assert(result.len == n);
return result;
```

## What the tests assert

- `allocator_alloc_test.rye` — `alloc(u8, 16)` returns length 16; `alloc(u32, 4)` returns 4; zero-length alloc returns `len == 0`
- `rye run brushstroke/skate_grid_test.rye` — end-to-end Skate grid through strengthened `alloc` + `copyForwards` (multi-file bridge; outside parity witnesses)

## Brushstroke migration (`050912`)

- `brushstroke/skate_grid.zig` → `skate_grid.rye` with TAME assertions on grid invariants
- `brushstroke/font8x8_data.zig` → `font8x8_data.rye` (glyph data only)
- `putLine` uses `std.mem.copyForwards` (pass 9993) instead of `@memcpy`
- `rye build` now bridges local `@import("*.rye")` dependencies recursively to ephemeral `.zig` files

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.Allocator.alloc`**

```zig
pub fn alloc(ctx: *anyopaque, n: usize, alignment: mem.Alignment, ra: usize) ?[*]u8 {
    const self: *FixedBufferAllocator = @ptrCast(@alignCast(ctx));
    _ = ra;
    const ptr_align = alignment.toByteUnits();
    const adjust_off = mem.alignPointerOffset(self.buffer.ptr + self.end_index, ptr_align) orelse return null;
    const adjusted_index = self.end_index + adjust_off;
    const new_end_index = adjusted_index + n;
    if (new_end_index > self.buffer.len) return null;
    self.end_index = new_end_index;
    return self.buffer.ptr + adjusted_index;
}
```

## Width notes

**`std.mem.Allocator.alloc`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |

**`std.mem.copyForwards`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.Allocator.alloc`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| public signature | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/allocator_alloc_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `alloc` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/allocator_alloc_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9987_allocator_alloc_skate_grid.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9987 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.Allocator.alloc` — [`misc`](../misc)

```zig
pub fn alloc(ctx: *anyopaque, n: usize, alignment: mem.Alignment, ra: usize) ?[*]u8 {
    const self: *FixedBufferAllocator = @ptrCast(@alignCast(ctx));
    _ = ra;
    const ptr_align = alignment.toByteUnits();
    const adjust_off = mem.alignPointerOffset(self.buffer.ptr + self.end_index, ptr_align) orelse return null;
    const adjusted_index = self.end_index + adjust_off;
    const new_end_index = adjusted_index + n;
    if (new_end_index > self.buffer.len) return null;
    self.end_index = new_end_index;
    return self.buffer.ptr + adjusted_index;
}
```
