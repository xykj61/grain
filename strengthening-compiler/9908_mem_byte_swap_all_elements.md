# Pass 9908 · mem.byteSwapAllElements — scalar swap matches snapshot

**Witnesses:** 95 programs (grew from 94)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.003312`

## What this pass covers

**`std.mem.byteSwapAllElements`** — in-place endian reversal for each element in a slice. Pairs with `readInt`/`writeInt` (9909) on the wire-endian arc.

## Rye std surface

```zig
pub fn byteSwapAllElements(comptime Elem: type, slice: []Elem) void {
    const max_byteswap_check: u32 = 64;
    var original: [max_byteswap_check]Elem = undefined;
    const snapshot = slice.len <= @as(usize, max_byteswap_check);
    if (snapshot) @memcpy(original[0..slice.len], slice);
    // ... swap loop ...
    if (snapshot) {
        switch (@typeInfo(Elem)) {
            .int => for (slice, 0..) |elem, i| assert(elem == @byteSwap(original[i])),
            // float and enum branches verify via bitcast / intFromEnum
            else => {},
        }
    }
}
```

## Width notes

| Surface | Width policy |
|---------|-------------|
| `slice.len` | inherited `usize` seam |
| `max_byteswap_check` | `u32` = 64 elements |

## Postconditions

When `slice.len <= 64` and `Elem` is int/float/enum, each element equals `@byteSwap` of the pre-mutation snapshot at that index.

## What the test asserts

- `u32` pair swaps to `@byteSwap` values
- `u16` pair swaps `0x1234` → `0x3412`, `0x5678` → `0x7856`
