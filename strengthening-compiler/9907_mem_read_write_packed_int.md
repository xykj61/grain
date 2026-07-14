# Pass 9907 · mem.readPackedInt / writePackedInt — bit-field wire round-trip

**Witnesses:** 96 programs (grew from 95)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.003712`

## What this pass covers

**`std.mem.readPackedInt`** and **`writePackedInt`** — load/store integers at arbitrary bit offsets in a byte buffer. MMIO and packed-struct field access; pairs with `readInt`/`writeInt` (9909).

## Rye std surface

**`std.mem.readPackedInt`**

```zig
pub fn readPackedInt(comptime T: type, bytes: []const u8, bit_offset: usize, endian: Endian) T {
    const result = switch (endian) { ... };
    const bit_count: usize = @bitSizeOf(T);
    const max_packed_bits_check: u32 = 64;
    if (bit_count <= max_packed_bits_check) {
        assert(bit_offset + bit_count <= bytes.len * 8);
    }
    return result;
}
```

**`std.mem.writePackedInt`**

```zig
pub fn writePackedInt(comptime T: type, bytes: []u8, bit_offset: usize, value: T, endian: Endian) void {
    switch (endian) { ... };
    const bit_count: usize = @bitSizeOf(T);
    const max_packed_bits_check: u32 = 64;
    if (bit_count > 0 and bit_count <= max_packed_bits_check) {
        assert(readPackedInt(T, bytes, bit_offset, endian) == value);
    }
}
```

## Postconditions

`readPackedInt` (≤64-bit fields): `bit_offset + bit_count` fits in `bytes.len * 8`. `writePackedInt` (1–64 bits): `readPackedInt` round-trips the written value.

## What the test asserts

- Read `b` field (`u7`) from packed struct → `2`
- Write `0x7f` into `b`, verify struct field and read-back
