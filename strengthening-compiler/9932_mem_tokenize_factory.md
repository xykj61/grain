# Pass 9932 · mem tokenize factories — cursor starts at buffer front

**Witnesses:** 71 programs (grew from 70)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.210412`

## What this pass covers

**`tokenizeScalar`, `tokenizeAny`, `tokenizeSequence`** — factory postconditions beside strengthened `TokenIterator` (`9956`–`9957`) and split factories (`9934`).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.tokenizeScalar`**

```zig
pub fn tokenizeScalar(comptime T: type, buffer: []const T, delimiter: T) TokenIterator(T, .scalar) {
    const it: TokenIterator(T, .scalar) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

**`std..mem.tokenizeAny`**

```zig
pub fn tokenizeAny(comptime T: type, buffer: []const T, delimiters: []const T) TokenIterator(T, .any) {
    const it: TokenIterator(T, .any) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

**`std..mem.tokenizeSequence`**

```zig
pub fn tokenizeSequence(comptime T: type, buffer: []const T, delimiter: []const T) TokenIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: TokenIterator(T, .sequence) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

**`std.mem.tokenizeScalar`**

```zig
pub fn tokenizeScalar(comptime T: type, buffer: []const T, delimiter: T) TokenIterator(T, .scalar) {
    const it: TokenIterator(T, .scalar) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

**`std.mem.tokenizeAny`**

```zig
pub fn tokenizeAny(comptime T: type, buffer: []const T, delimiters: []const T) TokenIterator(T, .any) {
    const it: TokenIterator(T, .any) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

**`std.mem.tokenizeSequence`**

```zig
pub fn tokenizeSequence(comptime T: type, buffer: []const T, delimiter: []const T) TokenIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: TokenIterator(T, .sequence) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

## Width notes

**`std.mem.tokenize_factory`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.tokenizeScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.tokenizeAny`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.tokenizeSequence`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.tokenizeScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.tokenizeAny`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.tokenizeSequence`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_tokenize_factory_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `tokenizeScalar` — Phase 4 `usize` seam policy applied | done |
| `misc` | `tokenizeAny` — Phase 4 `usize` seam policy applied | done |
| `misc` | `tokenizeSequence` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `tokenizeScalar` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `tokenizeAny` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `tokenizeSequence` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_tokenize_factory_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9932_mem_tokenize_factory.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9932 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.tokenizeScalar` — [`misc`](../misc)

```zig
pub fn tokenizeScalar(comptime T: type, buffer: []const T, delimiter: T) TokenIterator(T, .scalar) {
    const it: TokenIterator(T, .scalar) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

- [x] `std..mem.tokenizeAny` — [`misc`](../misc)

```zig
pub fn tokenizeAny(comptime T: type, buffer: []const T, delimiters: []const T) TokenIterator(T, .any) {
    const it: TokenIterator(T, .any) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

- [x] `std..mem.tokenizeSequence` — [`misc`](../misc)

```zig
pub fn tokenizeSequence(comptime T: type, buffer: []const T, delimiter: []const T) TokenIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: TokenIterator(T, .sequence) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

- [x] `std.mem.tokenizeScalar` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn tokenizeScalar(comptime T: type, buffer: []const T, delimiter: T) TokenIterator(T, .scalar) {
    const it: TokenIterator(T, .scalar) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

- [x] `std.mem.tokenizeAny` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn tokenizeAny(comptime T: type, buffer: []const T, delimiters: []const T) TokenIterator(T, .any) {
    const it: TokenIterator(T, .any) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

- [x] `std.mem.tokenizeSequence` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn tokenizeSequence(comptime T: type, buffer: []const T, delimiter: []const T) TokenIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: TokenIterator(T, .sequence) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index == 0);
    assert(it.index <= buffer.len);
    return it;
}
```

## Postconditions

On return from each factory:

- `index == 0`
- `index <= buffer.len`

Unlike split factories, `rest()` skips leading delimiters — not asserted at creation.

## What the test asserts

- Scalar, any, and sequence delimiters: `peek` on first token, `rest` from first token start
- Empty buffer and delimiter-only buffer yield null `peek`
