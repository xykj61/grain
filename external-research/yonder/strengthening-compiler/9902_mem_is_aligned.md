# Pass 9902 · mem.isAligned / isAlignedGeneric / isAlignedLog2 — alignment predicates

**Witnesses:** 101 programs (grew from 100)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.013812`

## What this pass covers

**`std.mem.isAligned`**, **`isAlignedGeneric`**, and **`isAlignedLog2`** — test whether an address sits on a power-of-2 boundary. Closes the alignment cluster with `alignBackward` (9904) and `alignPointer` (9903).

## Rye std surface

**`std.mem.isAlignedGeneric`**

```zig
pub fn isAlignedGeneric(comptime T: type, addr: T, alignment: T) bool {
    const result = alignBackward(T, addr, alignment) == addr;
    assert(result == (@mod(addr, alignment) == 0));
    return result;
}
```

**`std.mem.isAligned`**

```zig
pub fn isAligned(addr: usize, alignment: usize) bool {
    const result = isAlignedGeneric(u64, addr, alignment);
    assert(result == isAlignedGeneric(usize, addr, alignment));
    return result;
}
```

**`std.mem.isAlignedLog2`**

```zig
pub fn isAlignedLog2(addr: usize, log2_alignment: u8) bool {
    const result = @ctz(addr) >= log2_alignment;
    assert(result == isAligned(addr, 1 << log2_alignment));
    return result;
}
```

## Postconditions

`isAlignedGeneric`: result agrees with `@mod(addr, alignment) == 0`. `isAligned`: u64 widening agrees with usize path. `isAlignedLog2`: ctz fast path agrees with `isAligned`.

## What the test asserts

- `isAligned(16, 8)` true; `isAligned(17, 8)` false
- `isAlignedGeneric(u32, 24, 8)` true; `26` false
- `isAlignedLog2(16, 4)` true; `8` false
