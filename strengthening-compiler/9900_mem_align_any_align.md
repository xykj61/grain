# Pass 9900 · mem.alignForwardAnyAlign / alignBackwardAnyAlign — arbitrary alignment

**Witnesses:** 103 programs (grew from 102)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.020012`

## What this pass covers

**`std.mem.alignForwardAnyAlign`** and **`alignBackwardAnyAlign`** — round addresses to any positive alignment (not only powers of 2). Power-of-2 alignments delegate to `alignForward`/`alignBackward` (9904).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `addr`, `alignment` | generic `T` — inherited Zig signatures (Phase 4) |

## Rye std surface

**`std.mem.alignBackwardAnyAlign`**

```zig
pub fn alignBackwardAnyAlign(comptime T: type, addr: T, alignment: T) T {
    const result = addr - @mod(addr, alignment); // non-POT path
    assert(@mod(result, alignment) == 0);
    assert(result <= addr);
    assert(addr - result < alignment);
    return result;
}
```

**`std.mem.alignForwardAnyAlign`**

```zig
pub fn alignForwardAnyAlign(comptime T: type, addr: T, alignment: T) T {
    const result = alignBackwardAnyAlign(T, addr + (alignment - 1), alignment); // non-POT path
    assert(@mod(result, alignment) == 0);
    assert(result >= addr);
    assert(result - addr < alignment);
    return result;
}
```

## Postconditions

Non-power-of-2 path: backward yields greatest multiple ≤ addr; forward yields least multiple ≥ addr; both on `alignment` boundary within one step.

## What the test asserts

- Power-of-2 `6` vs `8`: `alignForwardAnyAlign(17, 8)` → `24`; `alignBackwardAnyAlign(17, 8)` → `16`
- Arbitrary `6`: `alignBackwardAnyAlign(17, 6)` → `12`; `alignForwardAnyAlign(17, 6)` → `18`
