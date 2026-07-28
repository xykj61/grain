# Pass 9903 · mem.alignPointer / alignPointerOffset — pointer bump alignment

**Witnesses:** 100 programs (grew from 99)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.013512`

## What this pass covers

**`std.mem.alignPointerOffset`** and **`alignPointer`** — align a many-item pointer forward to a power-of-2 boundary. Allocator bump path (9987); pairs with `alignForward` (9904).

## Rye std surface

**`std.mem.alignPointerOffset`**

```zig
pub fn alignPointerOffset(ptr: anytype, align_to: usize) ?usize {
    // when already aligned: assert @mod(@intFromPtr(ptr), align_to) == 0; return 0
    // when success: assert addr + delta == alignForward(usize, addr, align_to)
}
```

**`std.mem.alignPointer`**

```zig
pub fn alignPointer(ptr: anytype, align_to: usize) ?@TypeOf(ptr) {
    const result = @alignCast(ptr + adjust_off);
    assert(@intFromPtr(result) == alignForward(usize, @intFromPtr(ptr), align_to));
    return result;
}
```

## Postconditions

`alignPointerOffset`: zero offset when already aligned; otherwise byte delta reaches `alignForward` boundary. `alignPointer`: integer address equals `alignForward` on the original pointer.

## What the test asserts

- `[*]u8` at base+3 aligns to 16-byte boundary; offset matches pointer difference
- `[*]u32` at `0x4` aligns to `0x10` with element offset `3`
