# Pass 9892 · mem.Alignment byte units / compare — enum conversion helpers

**Witnesses:** 111 programs (grew from 110)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.025712`

## What this pass covers

**`std.mem.Alignment`** methods **`toByteUnits`**, **`fromByteUnits`**, **`fromByteUnitsOptional`**, **`order`**, **`compare`**, **`max`**, and **`min`** — log2 enum ↔ byte-unit conversion and ordering. Completes the `Alignment` type surface before address methods (9893).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `n`, `maybe_n`, byte counts | inherited `usize` seam (Phase 4) |

## Rye std surface

```zig
pub fn toByteUnits(a: Alignment) usize {
    const result = @as(usize, 1) << @intFromEnum(a);
    assert(isValidAlign(result));
    assert(@ctz(result) == @intFromEnum(a));
    return result;
}

pub fn fromByteUnits(n: usize) Alignment {
    assert(std.math.isPowerOfTwo(n));
    const result = @enumFromInt(@ctz(n));
    assert(isValidAlign(n));
    assert(result.toByteUnits() == n);
    return result;
}

pub fn fromByteUnitsOptional(maybe_n: ?usize) ?Alignment {
    // null stays null; some(n) round-trips through toByteUnits
}

pub fn order(lhs: Alignment, rhs: Alignment) std.math.Order {
    // log2 order agrees with byte-unit order
}

pub fn compare(lhs: Alignment, op: CompareOperator, rhs: Alignment) bool {
    // agrees with compare on toByteUnits()
}

pub fn max(lhs: Alignment, rhs: Alignment) Alignment {
    // toByteUnits matches @max; result is one of the inputs
}

pub fn min(lhs: Alignment, rhs: Alignment) Alignment {
    // toByteUnits matches @min; result is one of the inputs
}
```

(Runtime postconditions guarded with `!@inComptime()`.)

## Postconditions

`toByteUnits` / `fromByteUnits` round-trip on valid power-of-2 byte counts. `order` / `compare` / `max` / `min` agree with the same operations on `toByteUnits()`.

## What the test asserts

- `@"8".toByteUnits()` → `8`; `fromByteUnits(4)` round-trip; `fromByteUnitsOptional` some/null
- `@"4"` vs `@"8"`: `order` lt, `compare(.gt)` true, `max` → `@"8"`, `min` → `@"4"`
