# Pass 9898 · mem.isValidAlign / isValidAlignGeneric — alignment validation

**Witnesses:** 105 programs (grew from 104)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.020612`

## What this pass covers

**`std.mem.isValidAlign`** and **`isValidAlignGeneric`** — test whether an alignment value is a positive power of 2. Gates the POT branches in `alignForward` (9904), `alignForwardAnyAlign` (9900), and `isAlignedAnyAlign` (9899).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `alignment` | inherited `usize` / generic `T` (Phase 4) |

## Rye std surface

**`std.mem.isValidAlignGeneric`**

```zig
pub fn isValidAlignGeneric(comptime T: type, alignment: T) bool {
    const result = alignment > 0 and std.math.isPowerOfTwo(alignment);
    if (result) {
        const U = std.meta.Int(.unsigned, @bitSizeOf(T));
        const bits = @as(U, @bitCast(alignment));
        assert(bits > 0 and bits & (bits -% 1) == 0);
    }
    return result;
}
```

**`std.mem.isValidAlign`**

```zig
pub fn isValidAlign(alignment: usize) bool {
    const result = isValidAlignGeneric(usize, alignment);
    assert(result == isValidAlignGeneric(u64, alignment));
    return result;
}
```

## Postconditions

`isValidAlignGeneric`: when true at runtime, alignment has exactly one bit set. `isValidAlign`: usize path agrees with u64 widening. Postconditions skip `@inComptime()` calls — `alignBackward` invokes validation at comptime in `debug_allocator`.

## What the test asserts

- `1`, `8`, `16` valid; `0`, `6`, `12` invalid
