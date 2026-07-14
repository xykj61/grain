# Pass 9969 · SplitIterator.peek — lookahead stays within the buffer

**Corpus:** 34 programs (grew from 33)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.165112`

## What this pass covers

**`SplitIterator.peek`** (via `splitScalar`, `splitAny`, `splitSequence`) — returns the next field without advancing. Rishi peeks while splitting lines and fields; `next()` was strengthened in 9993.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.splitScalar`**

```zig
pub fn splitScalar(s: [32]u8, endian: std.builtin.Endian) NonCanonicalError!SplitScalar {
            const b1_neg_s = comptime s: {
                var buf: [32]u8 = undefined;
                mem.writeInt(u256, &buf, 303414439467246543595250775667605759171, .little);
                break :s buf;
            };
            const b2_neg_s = comptime s: {
                var buf: [32]u8 = undefined;
                mem.writeInt(u256, &buf, scalar.field_order - 64502973549206556628585045361533709077, .little);
                break :s buf;
            };
            const k = mem.readInt(u256, &s, endian);

            const t1 = math.mulWide(u256, k, 21949224512762693861512883645436906316123769664773102907882521278123970637873);
            const t2 = math.mulWide(u256, k, 103246583619904461035481197785446227098457807945486720222659797044629401272177);

            const c1 = @as(u128, @truncate(t1 >> 384)) + @as(u1, @truncate(t1 >> 383));
            const c2 = @as(u128, @truncate(t2 >> 384)) + @as(u1, @truncate(t2 >> 383));

            var buf: [32]u8 = undefined;

            mem.writeInt(u256, &buf, c1, .little);
            const c1x = try scalar.mul(buf, b1_neg_s, .little);

            mem.writeInt(u256, &buf, c2, .little);
            const c2x = try scalar.mul(buf, b2_neg_s, .little);

            const r2 = try scalar.add(c1x, c2x, .little);

            var r1 = try scalar.mul(r2, lambda_s, .little);
            r1 = try scalar.sub(s, r1, .little);

            return SplitScalar{ .r1 = r1, .r2 = r2 };
        }
```

**`std..mem.splitAny`**

```zig
pub fn splitAny(comptime T: type, buffer: []const T, delimiters: []const T) SplitIterator(T, .any) {
    const it: SplitIterator(T, .any) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std..mem.splitSequence`**

```zig
pub fn splitSequence(comptime T: type, buffer: []const T, delimiter: []const T) SplitIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: SplitIterator(T, .sequence) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std.mem.splitScalar`**

```zig
pub fn splitScalar(comptime T: type, buffer: []const T, delimiter: T) SplitIterator(T, .scalar) {
    const it: SplitIterator(T, .scalar) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std.mem.splitAny`**

```zig
pub fn splitAny(comptime T: type, buffer: []const T, delimiters: []const T) SplitIterator(T, .any) {
    const it: SplitIterator(T, .any) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

**`std.mem.splitSequence`**

```zig
pub fn splitSequence(comptime T: type, buffer: []const T, delimiter: []const T) SplitIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: SplitIterator(T, .sequence) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

## Width notes

**`std.mem.split`** — Authored module or iterator family — width migration lives in Tier A (`992`); std iterator indices remain `usize` until wrapped at our API.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.splitScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.splitAny`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.splitSequence`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.splitScalar`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.splitAny`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.splitSequence`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/split_peek_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `splitScalar` — Phase 4 `usize` seam policy applied | done |
| `misc` | `splitAny` — Phase 4 `usize` seam policy applied | done |
| `misc` | `splitSequence` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `splitScalar` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `splitAny` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `splitSequence` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/split_peek_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9969_split_peek.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9969 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.splitScalar` — [`misc`](../misc)

```zig
pub fn splitScalar(s: [32]u8, endian: std.builtin.Endian) NonCanonicalError!SplitScalar {
            const b1_neg_s = comptime s: {
                var buf: [32]u8 = undefined;
                mem.writeInt(u256, &buf, 303414439467246543595250775667605759171, .little);
                break :s buf;
            };
            const b2_neg_s = comptime s: {
                var buf: [32]u8 = undefined;
                mem.writeInt(u256, &buf, scalar.field_order - 64502973549206556628585045361533709077, .little);
                break :s buf;
            };
            const k = mem.readInt(u256, &s, endian);

            const t1 = math.mulWide(u256, k, 21949224512762693861512883645436906316123769664773102907882521278123970637873);
            const t2 = math.mulWide(u256, k, 103246583619904461035481197785446227098457807945486720222659797044629401272177);

            const c1 = @as(u128, @truncate(t1 >> 384)) + @as(u1, @truncate(t1 >> 383));
            const c2 = @as(u128, @truncate(t2 >> 384)) + @as(u1, @truncate(t2 >> 383));

            var buf: [32]u8 = undefined;

            mem.writeInt(u256, &buf, c1, .little);
            const c1x = try scalar.mul(buf, b1_neg_s, .little);

            mem.writeInt(u256, &buf, c2, .little);
            const c2x = try scalar.mul(buf, b2_neg_s, .little);

            const r2 = try scalar.add(c1x, c2x, .little);

            var r1 = try scalar.mul(r2, lambda_s, .little);
            r1 = try scalar.sub(s, r1, .little);

            return SplitScalar{ .r1 = r1, .r2 = r2 };
        }
```

- [x] `std..mem.splitAny` — [`misc`](../misc)

```zig
pub fn splitAny(comptime T: type, buffer: []const T, delimiters: []const T) SplitIterator(T, .any) {
    const it: SplitIterator(T, .any) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std..mem.splitSequence` — [`misc`](../misc)

```zig
pub fn splitSequence(comptime T: type, buffer: []const T, delimiter: []const T) SplitIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: SplitIterator(T, .sequence) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std.mem.splitScalar` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn splitScalar(comptime T: type, buffer: []const T, delimiter: T) SplitIterator(T, .scalar) {
    const it: SplitIterator(T, .scalar) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std.mem.splitAny` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn splitAny(comptime T: type, buffer: []const T, delimiters: []const T) SplitIterator(T, .any) {
    const it: SplitIterator(T, .any) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiters,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

- [x] `std.mem.splitSequence` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn splitSequence(comptime T: type, buffer: []const T, delimiter: []const T) SplitIterator(T, .sequence) {
    assert(delimiter.len != 0);
    const it: SplitIterator(T, .sequence) = .{
        .index = 0,
        .buffer = buffer,
        .delimiter = delimiter,
    };
    assert(it.index.? == 0);
    assert(it.index.? <= buffer.len);
    assert(it.rest().len == buffer.len);
    return it;
}
```

## Postcondition

```zig
assert(start <= end);
assert(end <= self.buffer.len);
```

Same contract as `next()`, stated at peek so lookahead cannot name bytes outside the buffer.

## What the test asserts

- first + peek + next agree on the same field
- Empty field between delimiters visible via peek
- Final peek is null when exhausted
