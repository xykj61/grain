# Pass 9888 · mem.containsAtLeastScalar — deprecated scalar threshold wrapper

**Witnesses:** 115 programs (grew from 114)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260623.032712`

## What this pass covers

**`std.mem.containsAtLeastScalar`** — deprecated one-line wrapper over `containsAtLeastScalar2`. Pairs with `containsAtLeast` / `containsAtLeastScalar2` (9950) and `countScalar` (9951).

## Width notes

| Surface | Width policy |
|---------|-------------|
| `minimum`, `list.len`, counts | inherited `usize` seam (Phase 4) |
| Snapshot bound | `u32` 64 + `assert(minimum <= bound and len <= bound)` |

## Rye std surface

```zig
pub fn containsAtLeastScalar(comptime T: type, list: []const T, minimum: usize, element: T) bool {
    const result = containsAtLeastScalar2(T, list, element, minimum);
    assert(result == (countScalar(T, list, element) >= minimum)); // when bounded
    return result;
}
```

(Runtime postconditions guarded with `!@inComptime()`.)

## Postconditions

When `minimum <= 64` and `list.len <= 64`, result agrees with `countScalar(T, list, element) >= minimum`.

## What the test asserts

- `"aa"`, `'a'`, threshold 2 true / 3 false
- `"adadda"`, `'d'`, threshold 3 true; `countScalar` confirms
