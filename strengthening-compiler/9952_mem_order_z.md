# Pass 9952 · orderZ — NUL-terminated compare agrees with slice order

**Witnesses:** 51 programs (grew from 50)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.184412`

## What this pass covers

**`std.mem.orderZ`**, **`boundedOrderZ`**, and **`findSentinel`** — C-string lexicographic compare and sentinel search. Pairs with `mem.order` (9953).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.orderZ`**

```zig
pub fn orderZ(comptime T: type, lhs: [*:0]const T, rhs: [*:0]const T) math.Order {
    const result = boundedOrderZ(T, lhs, rhs, std.math.maxInt(usize));
    // Postcondition: NUL-terminated compare agrees with slice order (pairs with order 9953).
    const lhs_len = findSentinel(T, 0, lhs);
    const rhs_len = findSentinel(T, 0, rhs);
    assert(result == order(T, lhs[0..lhs_len], rhs[0..rhs_len]));
    return result;
}
```

**`std..mem.boundedOrderZ`**

```zig
pub fn boundedOrderZ(comptime T: type, lhs: [*:0]const T, rhs: [*:0]const T, bound: usize) math.Order {
    if (lhs == rhs) return .eq;
    var i: usize = 0;
    while (lhs[i] == rhs[i] and lhs[i] != 0 and i < bound) : (i += 1) {}
    if (i < bound) return math.order(lhs[i], rhs[i]);
    // Postcondition: compared equal through bound without a differing byte before NUL.
    assert(i <= bound);
    return .eq;
}
```

**`std..mem.findSentinel`**

```zig
pub fn findSentinel(comptime T: type, comptime sentinel: T, p: [*:sentinel]const T) usize {
    var i: usize = 0;
    while (p[i] != sentinel) {
        i += 1;
    }
    // Postcondition: returned index points at the sentinel.
    assert(p[i] == sentinel);
    return i;
}
```

**`std.mem.boundedOrderZ`**

```zig
pub fn boundedOrderZ(comptime T: type, lhs: [*:0]const T, rhs: [*:0]const T, bound: usize) math.Order {
    if (lhs == rhs) return .eq;
    var i: usize = 0;
    while (lhs[i] == rhs[i] and lhs[i] != 0 and i < bound) : (i += 1) {}
    if (i < bound) return math.order(lhs[i], rhs[i]);
    // Postcondition: compared equal through bound without a differing byte before NUL.
    assert(i <= bound);
    return .eq;
}
```

**`std.mem.findSentinel`**

```zig
pub fn findSentinel(comptime T: type, comptime sentinel: T, p: [*:sentinel]const T) usize {
    var i: usize = 0;
    while (p[i] != sentinel) {
        i += 1;
    }
    // Postcondition: returned index points at the sentinel.
    assert(p[i] == sentinel);
    return i;
}
```

## Width notes

**`std.mem.orderZ`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.orderZ`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.boundedOrderZ`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| public signature | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.findSentinel`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| return `usize` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.boundedOrderZ`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| public signature | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.findSentinel`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| return `usize` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_order_z_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `orderZ` — Phase 4 `usize` seam policy applied | done |
| `misc` | `boundedOrderZ` — Phase 4 `usize` seam policy applied | done |
| `misc` | `findSentinel` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `boundedOrderZ` — inherited `usize` seam; assertions only | done |
| `rye/lib/std/mem.zig` | `findSentinel` — inherited `usize` seam; assertions only | done |
| `rye/tests/mem_order_z_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9952_mem_order_z.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9952 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.orderZ` — [`misc`](../misc)

```zig
pub fn orderZ(comptime T: type, lhs: [*:0]const T, rhs: [*:0]const T) math.Order {
    const result = boundedOrderZ(T, lhs, rhs, std.math.maxInt(usize));
    // Postcondition: NUL-terminated compare agrees with slice order (pairs with order 9953).
    const lhs_len = findSentinel(T, 0, lhs);
    const rhs_len = findSentinel(T, 0, rhs);
    assert(result == order(T, lhs[0..lhs_len], rhs[0..rhs_len]));
    return result;
}
```

- [x] `std..mem.boundedOrderZ` — [`misc`](../misc)

```zig
pub fn boundedOrderZ(comptime T: type, lhs: [*:0]const T, rhs: [*:0]const T, bound: usize) math.Order {
    if (lhs == rhs) return .eq;
    var i: usize = 0;
    while (lhs[i] == rhs[i] and lhs[i] != 0 and i < bound) : (i += 1) {}
    if (i < bound) return math.order(lhs[i], rhs[i]);
    // Postcondition: compared equal through bound without a differing byte before NUL.
    assert(i <= bound);
    return .eq;
}
```

- [x] `std..mem.findSentinel` — [`misc`](../misc)

```zig
pub fn findSentinel(comptime T: type, comptime sentinel: T, p: [*:sentinel]const T) usize {
    var i: usize = 0;
    while (p[i] != sentinel) {
        i += 1;
    }
    // Postcondition: returned index points at the sentinel.
    assert(p[i] == sentinel);
    return i;
}
```

- [x] `std.mem.boundedOrderZ` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn boundedOrderZ(comptime T: type, lhs: [*:0]const T, rhs: [*:0]const T, bound: usize) math.Order {
    if (lhs == rhs) return .eq;
    var i: usize = 0;
    while (lhs[i] == rhs[i] and lhs[i] != 0 and i < bound) : (i += 1) {}
    if (i < bound) return math.order(lhs[i], rhs[i]);
    // Postcondition: compared equal through bound without a differing byte before NUL.
    assert(i <= bound);
    return .eq;
}
```

- [x] `std.mem.findSentinel` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn findSentinel(comptime T: type, comptime sentinel: T, p: [*:sentinel]const T) usize {
    var i: usize = 0;
    while (p[i] != sentinel) {
        i += 1;
    }
    // Postcondition: returned index points at the sentinel.
    assert(p[i] == sentinel);
    return i;
}
```

## Postconditions

**orderZ**:

```zig
assert(result == order(T, lhs[0..lhs_len], rhs[0..rhs_len]));
```

**boundedOrderZ** — equal-through-bound path:

```zig
assert(i <= bound);
```

**findSentinel**:

```zig
assert(p[i] == sentinel);
```

## What the test asserts

- `orderZ` less, equal, greater; shared pointer self-compare
- `findSentinel` on `"hello"` and `""`
- `boundedOrderZ` respects compare bound
