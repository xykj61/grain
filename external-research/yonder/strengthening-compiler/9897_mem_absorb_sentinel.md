# Pass 9897 · mem.absorbSentinel — sentinel slice absorption

**Witnesses:** 106 programs (grew from 105)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.022712`

## What this pass covers

**`std.mem.absorbSentinel`** — convert a sentinel-terminated slice to a plain slice by extending length by one to include the sentinel byte/element. Pairs with `span` (9942) and the slice view family (9924–9926).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `slice.len` | inherited `usize` seam (Phase 4) |
| `max_absorb_sentinel_check` | `u32` = 64 elements |

## Rye std surface

```zig
pub fn absorbSentinel(slice: anytype) AbsorbSentinelReturnType(@TypeOf(slice)) {
    const result = slice.ptr[0 .. slice.len + 1]; // sentinel path
    if (!@inComptime() and slice.len <= 64) {
        assert(result.ptr == slice.ptr);
        assert(result.len == slice.len + 1);
        if (std.meta.sentinel(@TypeOf(slice))) |s| assert(result[slice.len] == s);
    }
    return result;
}
```

## Postconditions

When sentinel-terminated and `slice.len <= 64` at runtime: same pointer, length + 1, trailing element equals compile-time sentinel. Non-sentinel slices pass through unchanged.

## What the test asserts

- `[:0]const u8` over `{1,2,3}` → length 4 with trailing `0`
- Plain `[]const u8` unchanged (length 3, same pointer)
