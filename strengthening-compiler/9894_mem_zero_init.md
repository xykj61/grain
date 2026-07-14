# Pass 9894 · mem.zeroInit — struct init with defaults and zero fill

**Witnesses:** 109 programs (grew from 108)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.024612`

## What this pass covers

**`std.mem.zeroInit`** — initialize a struct from a partial initializer; unspecified fields get defaults or `zeroes`. Pairs with `zeroes` (9895).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `@sizeOf(T)` | inherited `usize` seam (Phase 4) |
| `max_zero_init_check` | `u32` = 64 bytes |

## Rye std surface

```zig
pub fn zeroInit(comptime T: type, init: anytype) T {
    // ... field walk ...
    if (!@inComptime() and @sizeOf(T) <= 64) {
        verifyZeroInitPostcondition(T, Init, init, value);
    }
    return value;
}
```

## Postconditions

At runtime when `@sizeOf(T) <= 64` (named-field init): explicit scalar fields match init; default fields match `defaultValue`; other scalars match `zeroes`. Nested struct/array fields verified by recursive init; tuple inits verified in witness only.

## What the test asserts

- Partial init: `a = 42`, `b = null`, nested `c.d = 0`, `f = -1` (default)
- Tuple init: `Color{ 255, 255, 0, 0 }`
