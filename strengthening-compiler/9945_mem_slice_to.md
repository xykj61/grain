# Pass 9945 · sliceTo — sentinel slice length agrees with terminator search

**Witnesses:** 58 programs (grew from 57)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.193612`

## What this pass covers

**`std.mem.sliceTo`** and **`lenSliceTo`** (slice branch) — slice sentinel-terminated pointers and buffers up to a terminator. Pairs with `findSentinel` (9952) and `orderZ` (9952).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.sliceTo`**

```zig
pub fn sliceTo(ptr: anytype, comptime end: std.meta.Elem(@TypeOf(ptr))) SliceTo(@TypeOf(ptr), end) {
    if (@typeInfo(@TypeOf(ptr)) == .optional) {
        const non_null = ptr orelse return null;
        return sliceTo(non_null, end);
    }
    const Result = SliceTo(@TypeOf(ptr), end);
    const length = lenSliceTo(ptr, end);
    const ptr_info = @typeInfo(Result).pointer;
    if (ptr_info.sentinel()) |s| {
        const result = ptr[0..length :s];
        // Postcondition: slice length matches lenSliceTo (pairs with findSentinel 9952).
        assert(result.len == length);
        return result;
    } else {
        const result = ptr[0..length];
        assert(result.len == length);
        return result;
    }
}
```

## Width notes

**`std.mem.sliceTo`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.sliceTo`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_slice_to_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `sliceTo` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_slice_to_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9945_mem_slice_to.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9945 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.sliceTo` — [`misc`](../misc)

```zig
pub fn sliceTo(ptr: anytype, comptime end: std.meta.Elem(@TypeOf(ptr))) SliceTo(@TypeOf(ptr), end) {
    if (@typeInfo(@TypeOf(ptr)) == .optional) {
        const non_null = ptr orelse return null;
        return sliceTo(non_null, end);
    }
    const Result = SliceTo(@TypeOf(ptr), end);
    const length = lenSliceTo(ptr, end);
    const ptr_info = @typeInfo(Result).pointer;
    if (ptr_info.sentinel()) |s| {
        const result = ptr[0..length :s];
        // Postcondition: slice length matches lenSliceTo (pairs with findSentinel 9952).
        assert(result.len == length);
        return result;
    } else {
        const result = ptr[0..length];
        assert(result.len == length);
        return result;
    }
}
```

## Postconditions

**sliceTo** — returned slice length matches `lenSliceTo`.

**lenSliceTo** (slice inputs) — when a terminator is found inside the slice, the index is in bounds and points at `end`.

## What the test asserts

- NUL-terminated string literals and embedded NUL
- Scalar delimiter before sentinel
- `[*:0]const u8` C string via `sliceTo` and `len`
- Optional null pointer returns null
