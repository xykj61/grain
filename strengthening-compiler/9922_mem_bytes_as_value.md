# Pass 9922 · mem.bytesAsValue — byte buffer aliases at least one T

**Witnesses:** 81 programs (grew from 80)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.023612`

## What this pass covers

**`std.mem.bytesAsValue`** — reinterprets bytes as a pointer to `T`, preserving pointer attributes. Pairs with `asBytes` (9925), `toBytes` (9923), and `bytesToValue`.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.bytesAsValue`**

```zig
pub fn bytesAsValue(comptime T: type, bytes: anytype) BytesAsValueReturnType(T, @TypeOf(bytes)) {
    const elem_size = @sizeOf(T);
    switch (@typeInfo(@TypeOf(bytes))) {
        .pointer => |ptr| switch (ptr.size) {
            .slice => assert(bytes.len >= elem_size),
            .one => assert(@sizeOf(ptr.child) >= elem_size),
            else => {},
        },
        else => {},
    }
    const Result = BytesAsValueReturnType(T, @TypeOf(bytes));
    const result: Result = @ptrCast(bytes);
    // Postcondition: returned pointer aliases at least one T (pairs with asBytes 9925, toBytes 9923).
    return result;
}
```

## Width notes

**`std.mem.bytesAsValue`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.bytesAsValue`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_bytes_as_value_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `bytesAsValue` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_bytes_as_value_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9922_mem_bytes_as_value.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9922 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.bytesAsValue` — [`misc`](../misc)

```zig
pub fn bytesAsValue(comptime T: type, bytes: anytype) BytesAsValueReturnType(T, @TypeOf(bytes)) {
    const elem_size = @sizeOf(T);
    switch (@typeInfo(@TypeOf(bytes))) {
        .pointer => |ptr| switch (ptr.size) {
            .slice => assert(bytes.len >= elem_size),
            .one => assert(@sizeOf(ptr.child) >= elem_size),
            else => {},
        },
        else => {},
    }
    const Result = BytesAsValueReturnType(T, @TypeOf(bytes));
    const result: Result = @ptrCast(bytes);
    // Postcondition: returned pointer aliases at least one T (pairs with asBytes 9925, toBytes 9923).
    return result;
}
```

## Postconditions

Slice inputs satisfy `bytes.len >= @sizeOf(T)`; one-item pointers satisfy `@sizeOf(child) >= @sizeOf(T)`.

## What the test asserts

- `u32` round-trip through `asBytes` → `bytesAsValue`
- Two-byte struct round-trip
