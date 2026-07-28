# Pass 9893 · mem.Alignment forward / backward / check — enum alignment helpers

**Witnesses:** 110 programs (grew from 109)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.025012`

## What this pass covers

**`std.mem.Alignment`** methods **`forward`**, **`backward`**, and **`check`** — enum-level address alignment. Completes the alignment cluster from the `Alignment` type side (9902–9904).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `address` | inherited `usize` seam (Phase 4) |

## Rye std surface

```zig
pub fn forward(a: Alignment, address: usize) usize {
    const result = (address + x) & ~x;
    assert(result == alignForward(usize, address, a.toByteUnits()));
    assert(isAligned(result, a.toByteUnits()));
    return result;
}

pub fn backward(a: Alignment, address: usize) usize {
    const result = address & ~x;
    assert(result == alignBackward(usize, address, a.toByteUnits()));
    return result;
}

pub fn check(a: Alignment, address: usize) bool {
    const result = @ctz(address) >= @intFromEnum(a);
    assert(result == isAlignedLog2(address, @intFromEnum(a)));
    return result;
}
```

## Postconditions

`forward`/`backward` agree with `alignForward`/`alignBackward` at `toByteUnits()`. `check` agrees with `isAlignedLog2`.

## What the test asserts

- `Alignment.@"8"`: `forward(17)` → `24`, `backward(17)` → `16`, `check(16)` true
- `fromByteUnits(4)` + `isAlignedLog2` cross-check
