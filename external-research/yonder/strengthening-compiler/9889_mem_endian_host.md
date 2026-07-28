# Pass 9889 · mem host endian conversions — wire ↔ native integers

**Witnesses:** 114 programs (grew from 113)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.031712`

## What this pass covers

**`std.mem.littleToNative`**, **`bigToNative`**, **`toNative`**, **`nativeTo`**, **`nativeToLittle`**, and **`nativeToBig`** — integer endian conversion between wire layout and host. Pairs with `readInt` / `writeInt` (9909).

## Width notes

| Surface | Width policy |
|---------|-------------|
| Integer types `T` | inherited Zig int widths (Phase 4) |

## Rye std surface

Each function stores `result`, then at runtime asserts the explicit host/wire mapping via `native_endian` and `@byteSwap` (no mutual calls — avoids postcondition recursion).

- `littleToNative` / `nativeToLittle` — little wire ↔ host
- `bigToNative` / `nativeToBig` — big wire ↔ host
- `toNative` / `nativeTo` — dispatch path agrees with explicit mapping

(Runtime postconditions guarded with `!@inComptime()`.)

## Postconditions

Result matches the `native_endian` branch table; wrappers agree with inlined mapping.

## What the test asserts

Round-trip properties exercised at the witness layer (`nativeTo` ∘ `toNative` == id); postconditions state the mapping directly.
