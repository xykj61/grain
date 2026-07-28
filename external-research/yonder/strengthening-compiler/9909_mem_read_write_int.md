# Pass 9909 · mem.readInt / writeInt — fixed-width wire round-trip

**Witnesses:** 94 programs (grew from 93)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.003112`

## What this pass covers

**`std.mem.readInt`** and **`writeInt`** — fixed-width integer decode/encode with explicit endian. Pairs with `readVarInt` (9910); used by Keccak sponge, crypto field math, and packed-int helpers.

## Rye std surface

**`std.mem.readInt`**

```zig
pub fn readInt(comptime T: type, buffer: *const [@divExact(@typeInfo(T).int.bits, 8)]u8, endian: Endian) T {
    const value: T = @bitCast(buffer.*);
    const result = if (endian == native_endian) value else @byteSwap(value);
    const byte_count = @divExact(@typeInfo(T).int.bits, 8);
    const max_read_int_check: u32 = 8;
    if (byte_count <= @as(usize, max_read_int_check)) {
        assert(result == readVarInt(T, buffer[0..byte_count], endian));
    }
    return result;
}
```

**`std.mem.writeInt`**

```zig
pub fn writeInt(comptime T: type, buffer: *[@divExact(@typeInfo(T).int.bits, 8)]u8, value: T, endian: Endian) void {
    buffer.* = @bitCast(if (endian == native_endian) value else @byteSwap(value));
    const byte_count = @divExact(@typeInfo(T).int.bits, 8);
    const max_write_int_check: u32 = 8;
    if (byte_count <= @as(usize, max_write_int_check)) {
        assert(readInt(T, buffer, endian) == value);
    }
}
```

## Width notes

| Surface | Width policy |
|---------|-------------|
| `T` type parameter | explicit wire width — design type |
| `max_read_int_check` / `max_write_int_check` | `u32` = 8 bytes snapshot bound |
| buffer slice | inherited `usize` seam |

## usize explicit audit

### `std.mem.readInt` / `writeInt`

| Check | Type | Policy | Status |
|-------|------|--------|--------|
| `T` width | explicit int | wire design width | done |
| snapshot bound | `u32` | 8-byte check | done |
| Tier | C — inherited `std` | assertions only | done |

### Witness `rye/tests/mem_read_write_int_test.rye`

| Check | Type | Policy | Status |
|-------|------|--------|--------|
| Tier | B — witness `.rye` | no authored `usize` fields | done |

## Postconditions

`readInt` (≤8 bytes): result equals `readVarInt` on the same buffer prefix. `writeInt` (≤8 bytes): `readInt` round-trips the written value.

## What the test asserts

- `u16` big/little write + read + byte pattern
- signed `i8` round-trip
- `u72` nine-byte big-endian round-trip
