# Pass 9924 · mem.bytesAsSlice — typed slice length matches byte span

**Witnesses:** 79 programs (grew from 78)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.022612`

## What this pass covers

**`std.mem.bytesAsSlice`** — reinterprets `[]u8` as `[]T` preserving pointer attributes. Inverse of `sliceAsBytes` (9926); pairs with `asBytes` (9925).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.bytesAsSlice`**

```zig
pub fn bytesAsSlice(comptime T: type, bytes: anytype) BytesAsSliceReturnType(T, @TypeOf(bytes)) {
    // let's not give an undefined pointer to @ptrCast
    // it may be equal to zero and fail a null check
    if (bytes.len == 0 or @sizeOf(T) == 0) {
        const result = &[0]T{};
        assert(result.len == 0);
        return result;
    }

    const elem_size = @sizeOf(T);
    assert(bytes.len % elem_size == 0);
    const cast_target = CopyPtrAttrs(@TypeOf(bytes), .many, T);
    const elem_len = @divExact(bytes.len, elem_size);
    const result = @as(cast_target, @ptrCast(bytes))[0..elem_len];
    // Postcondition: typed slice length matches byte length (pairs with sliceAsBytes 9926).
    assert(result.len == elem_len);
    assert(result.len * elem_size == bytes.len);
    return result;
}
```

## Width notes

**`std.mem.bytesAsSlice`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.bytesAsSlice`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_bytes_as_slice_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `bytesAsSlice` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_bytes_as_slice_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9924_mem_bytes_as_slice.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9924 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.bytesAsSlice` — [`misc`](../misc)

```zig
pub fn bytesAsSlice(comptime T: type, bytes: anytype) BytesAsSliceReturnType(T, @TypeOf(bytes)) {
    // let's not give an undefined pointer to @ptrCast
    // it may be equal to zero and fail a null check
    if (bytes.len == 0 or @sizeOf(T) == 0) {
        const result = &[0]T{};
        assert(result.len == 0);
        return result;
    }

    const elem_size = @sizeOf(T);
    assert(bytes.len % elem_size == 0);
    const cast_target = CopyPtrAttrs(@TypeOf(bytes), .many, T);
    const elem_len = @divExact(bytes.len, elem_size);
    const result = @as(cast_target, @ptrCast(bytes))[0..elem_len];
    // Postcondition: typed slice length matches byte length (pairs with sliceAsBytes 9926).
    assert(result.len == elem_len);
    assert(result.len * elem_size == bytes.len);
    return result;
}
```

## Postconditions

Empty bytes or zero-sized `T` returns `len == 0`. Otherwise `result.len * @sizeOf(T) == bytes.len` and `bytes.len % @sizeOf(T) == 0`.

## What the test asserts

- Four bytes as two `u16` values; round-trip via `sliceAsBytes`
- Empty byte slice
- Zero-sized element type
