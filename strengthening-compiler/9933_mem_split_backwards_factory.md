# Pass 9933 · mem split backwards factories — cursor starts at buffer end

**Witnesses:** 70 programs (grew from 69)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.205912`

## What this pass covers

**`splitBackwardsScalar`, `splitBackwardsAny`, `splitBackwardsSequence`** — factory postconditions beside strengthened `SplitBackwardsIterator` (`9962`) and forward factories (`9934`).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.splitBackwardsScalar`**

```zig
pub fn splitBackwardsScalar(comptime T: type, buffer: []const T, delimiter: T) SplitBackwardsIterator(T, .scalar) {
    const it: SplitBackwardsIterator(T, .scalar) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std..mem.splitBackwardsAny`**

```zig
pub fn splitBackwardsAny(comptime T: type, buffer: []const T, delimiters: []const T) SplitBackwardsIterator(T, .any) {
    const it: SplitBackwardsIterator(T, .any) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std..mem.splitBackwardsSequence`**

```zig
pub fn splitBackwardsSequence(comptime T: type, buffer: []const T, delimiter: []const T) SplitBackwardsIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: SplitBackwardsIterator(T, .sequence) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std.mem.splitBackwardsScalar`**

```zig
pub fn splitBackwardsScalar(comptime T: type, buffer: []const T, delimiter: T) SplitBackwardsIterator(T, .scalar) {
    const it: SplitBackwardsIterator(T, .scalar) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std.mem.splitBackwardsAny`**

```zig
pub fn splitBackwardsAny(comptime T: type, buffer: []const T, delimiters: []const T) SplitBackwardsIterator(T, .any) {
    const it: SplitBackwardsIterator(T, .any) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std.mem.splitBackwardsSequence`**

```zig
pub fn splitBackwardsSequence(comptime T: type, buffer: []const T, delimiter: []const T) SplitBackwardsIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: SplitBackwardsIterator(T, .sequence) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

## Width notes

**`std.mem.split_backwards_factory`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.splitBackwardsScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.splitBackwardsAny`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.splitBackwardsSequence`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.splitBackwardsScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.splitBackwardsAny`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.splitBackwardsSequence`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_split_backwards_factory_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `splitBackwardsScalar` — Phase 4 `usize` seam policy applied | done |
| `misc` | `splitBackwardsAny` — Phase 4 `usize` seam policy applied | done |
| `misc` | `splitBackwardsSequence` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `splitBackwardsScalar` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `splitBackwardsAny` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `splitBackwardsSequence` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_split_backwards_factory_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9933_mem_split_backwards_factory.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9933 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.splitBackwardsScalar` — [`misc`](../misc)

```zig
pub fn splitBackwardsScalar(comptime T: type, buffer: []const T, delimiter: T) SplitBackwardsIterator(T, .scalar) {
    const it: SplitBackwardsIterator(T, .scalar) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std..mem.splitBackwardsAny` — [`misc`](../misc)

```zig
pub fn splitBackwardsAny(comptime T: type, buffer: []const T, delimiters: []const T) SplitBackwardsIterator(T, .any) {
    const it: SplitBackwardsIterator(T, .any) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std..mem.splitBackwardsSequence` — [`misc`](../misc)

```zig
pub fn splitBackwardsSequence(comptime T: type, buffer: []const T, delimiter: []const T) SplitBackwardsIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: SplitBackwardsIterator(T, .sequence) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std.mem.splitBackwardsScalar` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn splitBackwardsScalar(comptime T: type, buffer: []const T, delimiter: T) SplitBackwardsIterator(T, .scalar) {
    const it: SplitBackwardsIterator(T, .scalar) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std.mem.splitBackwardsAny` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn splitBackwardsAny(comptime T: type, buffer: []const T, delimiters: []const T) SplitBackwardsIterator(T, .any) {
    const it: SplitBackwardsIterator(T, .any) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std.mem.splitBackwardsSequence` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn splitBackwardsSequence(comptime T: type, buffer: []const T, delimiter: []const T) SplitBackwardsIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: SplitBackwardsIterator(T, .sequence) = .{
        .index = buffer.len,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

## Postconditions

On return from each factory:

- `index == buffer.len`
- `rest().len == buffer.len` (full buffer visible before first `next`)

## What the test asserts

- Scalar, any, and sequence delimiters at creation
- Empty buffer: `rest` is zero-length; `first` yields empty field
