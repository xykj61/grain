# Pass 9901 · mem.alignInBytes / alignInSlice — aligned sub-slice extraction

**Witnesses:** 102 programs (grew from 101)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.015612`

## What this pass covers

**`std.mem.alignInBytes`** and **`alignInSlice`** — return the largest byte or typed sub-slice whose pointer meets a compile-time alignment. Pairs with `alignForward` (9904) and `bytesAsSlice` (9924).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `bytes.len`, slice lengths | inherited `usize` seam (Phase 4 — signature unchanged) |
| `new_alignment` | comptime `usize` — inherited |

## Rye std surface

**`std.mem.alignInBytes`**

```zig
pub fn alignInBytes(bytes: []u8, comptime new_alignment: usize) ?[]align(new_alignment) u8 {
    // ...
    assert(@intFromPtr(result.ptr) == begin_address_aligned);
    assert(isAligned(@intFromPtr(result.ptr), new_alignment));
    assert(result.len == new_length);
    assert(result.len <= bytes.len);
    return result;
}
```

**`std.mem.alignInSlice`**

```zig
pub fn alignInSlice(slice: anytype, comptime new_alignment: usize) ?AlignedSlice(...) {
    // ...
    assert(slice_length_bytes % @sizeOf(Element) == 0);
    assert(isAligned(@intFromPtr(result.ptr), new_alignment));
    assert(@intFromPtr(result.ptr) == @intFromPtr(aligned_bytes.ptr));
    return result;
}
```

## Postconditions

`alignInBytes`: pointer at `alignForward` boundary; length matches computed span; fits inside input. `alignInSlice`: whole elements only; pointer matches byte-level aligned slice.

## What the test asserts

- `alignInBytes` on 32-byte buffer → 16-byte aligned pointer at `alignForward` address
- `alignInSlice` on `u32` view shares aligned pointer with byte path
