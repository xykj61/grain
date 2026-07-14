# Pass 9906 · mem.readVarPackedInt / writeVarPackedInt — variable bit-field round-trip

**Witnesses:** 97 programs (grew from 96)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.004012`

## What this pass covers

**`std.mem.readVarPackedInt`** and **`writeVarPackedInt`** — load/store integers at arbitrary bit offsets with an explicit bit count and signedness. MMIO and packed-struct field access; pairs with `readPackedInt`/`writePackedInt` (9907).

## Rye std surface

**`std.mem.readVarPackedInt`**

```zig
pub fn readVarPackedInt(comptime T: type, bytes: []const u8, bit_offset: usize, bit_count: usize, endian: Endian, signedness: Signedness) T {
    const max_var_packed_bits_check: u32 = 64;
    if (bit_count <= max_var_packed_bits_check) {
        assert(bit_offset + bit_count <= bytes.len * 8);
    }
    // ... existing decode ...
}
```

**`std.mem.writeVarPackedInt`**

```zig
pub fn writeVarPackedInt(bytes: []u8, bit_offset: usize, bit_count: usize, value: anytype, endian: Endian) void {
    // ... existing encode ...
    const max_var_packed_bits_check: u32 = 64;
    if (bit_count > 0 and bit_count <= max_var_packed_bits_check) {
        assert(readVarPackedInt(T, bytes, bit_offset, bit_count, endian, signedness) == value);
    }
}
```

## Postconditions

`readVarPackedInt` (≤64 bits): `bit_offset + bit_count` fits in `bytes.len * 8`. `writeVarPackedInt` (1–64 bits): `readVarPackedInt` round-trips the written value.

## What the test asserts

- Read `b` field (`u7`, 7 bits) from packed struct → `2`
- Write `0x7f` into `b`, verify struct field and read-back
