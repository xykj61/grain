# Pass 9895 · mem.zeroes — zero initialization postconditions

**Witnesses:** 108 programs (grew from 107)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.023212`

## What this pass covers

**`std.mem.zeroes`** — comptime/runtime zero initialization for supported types. Pairs with `crypto.secureZero` (9929) and C-interop patterns.

## Width notes

| Surface | Width policy |
|---------|-------------|
| `@sizeOf(T)` | inherited `usize` seam (Phase 4) |
| `max_zeroes_check` | `u32` = 64 bytes |

## Rye std surface

```zig
pub fn zeroes(comptime T: type) T {
    const result = zeroesImpl(T);
    if (!@inComptime()) verifyZeroesPostcondition(T, result);
    return result;
}
```

`verifyZeroesPostcondition` when `@sizeOf(T) <= 64`: scalars at zero/null/false; extern/auto structs and unions all bytes zero via `allEqual`.

## Postconditions

Runtime verification for types up to 64 bytes: integers/floats zero, bool false, enum tag 0, optional null, empty slice, struct/union bytes all zero via `eql`.

## What the test asserts

- `u32` → `0`; `bool` → `false`; `?*u8` → `null`
- `extern struct { x, y: u32 }` fields zero; byte view all zero
