# Pass 9926 · mem.sliceAsBytes — byte view length matches element width

**Witnesses:** 77 programs (grew from 76)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.015612`

## What this pass covers

**`std.mem.sliceAsBytes`** — reinterprets a typed slice as `[]u8` preserving pointer attributes. Pairs with `asBytes` on single items and the copy/compare mem arc.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.sliceAsBytes`**

```zig
pub fn sliceAsBytes(slice: anytype) SliceAsBytesReturnType(@TypeOf(slice)) {
    const Slice = @TypeOf(slice);
    const elem_size = @sizeOf(std.meta.Elem(Slice));

    // a slice of zero-bit values always occupies zero bytes
    if (elem_size == 0) {
        const result = &[0]u8{};
        assert(result.len == 0);
        return result;
    }

    // let's not give an undefined pointer to @ptrCast
    // it may be equal to zero and fail a null check
    if (slice.len == 0 and std.meta.sentinel(Slice) == null) {
        const result = &[0]u8{};
        assert(result.len == 0);
        return result;
    }

    const cast_target = CopyPtrAttrs(Slice, .many, u8);
    const byte_len = slice.len * elem_size;
    const result = @as(cast_target, @ptrCast(slice))[0..byte_len];
    // Postcondition: byte view spans exactly one element width per item (pairs with asBytes).
    assert(result.len == byte_len);
    return result;
}
```

## Width notes

**`std.mem.sliceAsBytes`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.sliceAsBytes`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_slice_as_bytes_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `sliceAsBytes` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_slice_as_bytes_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9926_mem_slice_as_bytes.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9926 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.sliceAsBytes` — [`misc`](../misc)

```zig
pub fn sliceAsBytes(slice: anytype) SliceAsBytesReturnType(@TypeOf(slice)) {
    const Slice = @TypeOf(slice);
    const elem_size = @sizeOf(std.meta.Elem(Slice));

    // a slice of zero-bit values always occupies zero bytes
    if (elem_size == 0) {
        const result = &[0]u8{};
        assert(result.len == 0);
        return result;
    }

    // let's not give an undefined pointer to @ptrCast
    // it may be equal to zero and fail a null check
    if (slice.len == 0 and std.meta.sentinel(Slice) == null) {
        const result = &[0]u8{};
        assert(result.len == 0);
        return result;
    }

    const cast_target = CopyPtrAttrs(Slice, .many, u8);
    const byte_len = slice.len * elem_size;
    const result = @as(cast_target, @ptrCast(slice))[0..byte_len];
    // Postcondition: byte view spans exactly one element width per item (pairs with asBytes).
    assert(result.len == byte_len);
    return result;
}
```

## Postconditions

Returned byte slice length is `slice.len * @sizeOf(Elem)` on the main path; zero-bit elements and empty non-sentinel slices return `len == 0`.

## What the test asserts

- `u16` array yields four bytes with correct endian layout
- Empty sentinel `u8` string yields zero bytes
- Zero-bit element slice yields zero bytes
