# Pass 9896 · mem.bytesToValue — byte buffer to typed copy

**Witnesses:** 107 programs (grew from 106)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.022912`

## What this pass covers

**`std.mem.bytesToValue`** — copy bytes into a value of type `T` via `bytesAsValue`. Pairs with `bytesAsValue` (9922), `toBytes` (9923), and `asBytes` (9925).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `bytes.len` (slice path) | inherited `usize` seam (Phase 4) |
| `max_bytes_to_value_check` | `u32` = 64 bytes |

## Rye std surface

```zig
pub fn bytesToValue(comptime T: type, bytes: anytype) T {
    const ptr = bytesAsValue(T, bytes);
    const result = ptr.*;
    if (!@inComptime() and @sizeOf(T) <= 64) {
        assert(eql(u8, asBytes(&result), asBytes(ptr)));
        // slice path: result bytes match input prefix
    }
    return result;
}
```

## Postconditions

When `@sizeOf(T) <= 64` at runtime: copied value bytes match `bytesAsValue` view; for slice inputs, match first `@sizeOf(T)` bytes of input.

## What the test asserts

- `u32` from endian-correct four-byte wire
- `u32` from mutable `[4]u8` buffer → `0xC0DEFACE`
