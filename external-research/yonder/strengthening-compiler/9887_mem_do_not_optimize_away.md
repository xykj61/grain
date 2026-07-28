# Pass 9887 · mem.doNotOptimizeAway — compiler deoptimization barrier

**Witnesses:** 116 programs (grew from 115)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.033012`

## What this pass covers

**`std.mem.doNotOptimizeAway`** — inline asm / volatile-store barrier so the compiler retains evaluation of `val`. Pairs with `crypto.timingSafeEql` and other anti-optimization paths.

## Width notes

| Surface | Width policy |
|---------|-------------|
| Snapshot bound | `comptime_int` 64 bytes |

## Rye std surface

```zig
pub fn doNotOptimizeAway(val: anytype) void {
    if (@inComptime()) return;
    // int/float: assert(val == snap) after asm
    // pointer .one, size <= 64: byte snapshot unchanged
    // array total bytes <= 64: byte snapshot unchanged
}
```

`doNotOptimizeAwayC` (stage2_c): same byte snapshot check on pointed-to memory.

## Postconditions

The barrier is observation-only: scalars match pre-call snapshot; pointed-to / small-array bytes are unchanged (`verifyDeoptMemoryUnchanged`).

## What the test asserts

- `u32` by value and by pointer survive
- four-byte array unchanged
- `f64` and `bool` calls complete without altering caller state
