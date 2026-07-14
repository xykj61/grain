# Pass 9904 · mem.alignForward / alignBackward — power-of-2 address rounding

**Witnesses:** 99 programs (grew from 98)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.004612`

## What this pass covers

**`std.mem.alignForward`** and **`alignBackward`** — round addresses to power-of-2 alignment boundaries. Foundation for `alignPointer` (allocator path in 9987).

## Rye std surface

**`std.mem.alignBackward`**

```zig
pub fn alignBackward(comptime T: type, addr: T, alignment: T) T {
    const result = addr & ~(alignment - 1);
    assert(result <= addr);
    assert(@mod(result, alignment) == 0);
    assert(addr - result < alignment);
    return result;
}
```

**`std.mem.alignForward`**

```zig
pub fn alignForward(comptime T: type, addr: T, alignment: T) T {
    const result = alignBackward(T, addr + (alignment - 1), alignment);
    assert(@mod(result, alignment) == 0);
    assert(result >= addr);
    assert(result - addr < alignment);
    return result;
}
```

## Postconditions

`alignBackward`: greatest aligned address ≤ `addr`, within one `alignment` step. `alignForward`: least aligned address ≥ `addr`, within one `alignment` step.

## What the test asserts

- `alignBackward(17, 8)` → `16`; `alignForward(17, 8)` → `24`
- Already-aligned `alignForward(16, 8)` → `16`
- `isAlignedGeneric` agrees with `alignForward(15, 8)`
