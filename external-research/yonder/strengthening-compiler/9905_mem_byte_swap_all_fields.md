# Pass 9905 · mem.byteSwapAllFields — struct field swap matches snapshot

**Witnesses:** 98 programs (grew from 97)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.004312`

## What this pass covers

**`std.mem.byteSwapAllFields`** — in-place endian reversal for each field in a struct (recursively). Pairs with `byteSwapAllElements` (9908) on the wire-endian arc.

## Rye std surface

```zig
pub fn byteSwapAllFields(comptime S: type, ptr: *S) void {
    const max_byteswap_fields_check: u32 = 64;
    var original: S = undefined;
    const snapshot = @sizeOf(S) <= max_byteswap_fields_check;
    if (snapshot) original = ptr.*;
    byteSwapAllFieldsAligned(S, .of(S), ptr);
    if (snapshot) verifyByteSwappedFields(S, original, ptr.*);
}
```

## Width notes

| Surface | Width policy |
|---------|-------------|
| `@sizeOf(S)` | inherited `usize` seam |
| `max_byteswap_fields_check` | `u32` = 64 bytes |

## Postconditions

When `@sizeOf(S) <= 64`, each int/float/enum field equals `@byteSwap` of the pre-mutation snapshot; bool fields unchanged; nested structs, arrays, and unions verified recursively.

## What the test asserts

- `extern struct { tag: u8, len: u16, value: u32 }` — `len` and `value` swap; `tag` (u8) unchanged
