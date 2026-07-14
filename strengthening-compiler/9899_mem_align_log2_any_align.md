# Pass 9899 · mem.alignForwardLog2 / isAlignedAnyAlign — log2 and arbitrary predicates

**Witnesses:** 104 programs (grew from 103)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.020312`

## What this pass covers

**`std.mem.alignForwardLog2`** and **`isAlignedAnyAlign`** — log2 fast-path forward rounding and arbitrary-alignment test. Epilogue to alignment cluster 9900–9904.

## Width notes

| Surface | Width policy |
|---------|-------------|
| `addr`, `i`, `alignment` | inherited `usize` seam (Phase 4) |

## Rye std surface

**`std.mem.alignForwardLog2`**

```zig
pub fn alignForwardLog2(addr: usize, log2_alignment: u8) usize {
    const result = alignForward(usize, addr, 1 << log2_alignment);
    assert(isAlignedLog2(result, log2_alignment));
    return result;
}
```

**`std.mem.isAlignedAnyAlign`**

```zig
pub fn isAlignedAnyAlign(i: usize, alignment: usize) bool {
    const result = 0 == @mod(i, alignment); // non-POT path
    assert(result == (alignBackwardAnyAlign(usize, i, alignment) == i));
    return result;
}
```

## Postconditions

`alignForwardLog2`: result passes `isAlignedLog2` at same log2. `isAlignedAnyAlign` (non-POT): agrees with `alignBackwardAnyAlign` fixed point; POT delegates to `isAligned`.

## What the test asserts

- `alignForwardLog2(17, 3)` → `24`; result is log2-aligned at 3
- `isAlignedAnyAlign(18, 6)` true; `17` false; `16` on alignment 8 (POT path)
