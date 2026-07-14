# Pass 9910 · mem.readVarInt — wire decode matches bounded re-walk

**Witnesses:** 93 programs (grew from 92)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.002612`

## What this pass covers

**`std.mem.readVarInt`** — decode an integer from a byte buffer whose width is `bytes.len * 8` bits. Wire-endian paths for packed formats and MMIO-adjacent reads.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

```zig
pub fn readVarInt(comptime ReturnType: type, bytes: []const u8, endian: Endian) ReturnType {
    assert(@typeInfo(ReturnType).int.bits >= bytes.len * 8);
    // ...
    const truncated: ReturnType = @truncate(result);
    // Postcondition: empty wire reads zero; bounded lengths re-walk to the same value.
    if (bytes.len == 0) assert(truncated == 0);
    const max_read_varint_check: u32 = 8;
    if (bytes.len <= @as(usize, max_read_varint_check)) {
        var expected: WorkType = 0;
        switch (endian) {
            .big => for (bytes) |b| expected = (expected << 8) | b,
            .little => for (bytes, 0..) |b, index| {
                expected = expected | (@as(WorkType, b) << @as(ShiftType, @intCast(index * 8)));
            },
        }
        assert(truncated == @truncate(expected));
    }
    return truncated;
}
```

## Width notes

**`std.mem.readVarInt`** — Return type is explicit wire width (`u8`…`u80`, signed variants). Snapshot bound `max_read_varint_check: u32 = 8` bytes at the seam.

| Surface | Width policy |
|---------|-------------|
| `bytes: []const u8` | inherited `usize` seam |
| `ReturnType` | explicit integer width — design type |
| Named snapshot bound | `u32` + `@as(usize, …)` |

## usize explicit audit

### `std.mem.readVarInt`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `bytes` slice / `.len` | inherited `usize` (Tier C) | inherited Zig `std` | done |
| `ReturnType` | explicit int width | wire-persistent design width | done |
| `max_read_varint_check` | `u32` | named snapshot bound = 8 bytes | done |

### Witness `rye/tests/mem_read_varint_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | no authored `usize` fields | done |

## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/mem.zig` | `readVarInt` — named `u32` bound; empty-wire assert | done |
| `rye/tests/mem_read_varint_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9910_mem_read_varint.md` | pass record | done |

## Postconditions

Empty buffer → truncated zero. When `bytes.len <= 8`, independent endian walk reproduces the returned value.

## What the test asserts

- `u0` empty → 0
- `u8`/`u16` big and little endian
- signed `i8`/`i16` negative values
- oversized `u80` nine-byte big-endian wire value
