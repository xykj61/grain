# Pass 9960 · cutPrefix and cutSuffix — prefix/suffix chop stays in-range

**Corpus:** 43 programs (grew from 42)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.174312`

## What this pass covers

**`std.mem.cutPrefix`** and **`cutSuffix`** — return the remainder after a verified prefix or suffix. Build on `startsWith` / `endsWith` (9993); used in CLI flag parsing patterns.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.cutPrefix`**

```zig
pub fn cutPrefix(comptime T: type, slice: []const T, prefix: []const T) ?[]const T {
    if (!startsWith(T, slice, prefix)) return null;
    const rest = slice[prefix.len..];
    // Postcondition: rest is the tail after a verified prefix.
    assert(prefix.len <= slice.len);
    assert(rest.len + prefix.len == slice.len);
    return rest;
}
```

**`std..mem.cutSuffix`**

```zig
pub fn cutSuffix(comptime T: type, slice: []const T, suffix: []const T) ?[]const T {
    if (!endsWith(T, slice, suffix)) return null;
    const rest = slice[0 .. slice.len - suffix.len];
    // Postcondition: rest is the head before a verified suffix.
    assert(suffix.len <= slice.len);
    assert(rest.len + suffix.len == slice.len);
    return rest;
}
```

**`std.mem.cutSuffix`**

```zig
pub fn cutSuffix(comptime T: type, slice: []const T, suffix: []const T) ?[]const T {
    if (!endsWith(T, slice, suffix)) return null;
    const rest = slice[0 .. slice.len - suffix.len];
    // Postcondition: rest is the head before a verified suffix.
    assert(suffix.len <= slice.len);
    assert(rest.len + suffix.len == slice.len);
    return rest;
}
```

## Width notes

**`std.mem.cutPrefix`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.cutPrefix`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.cutSuffix`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.cutSuffix`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/cut_prefix_suffix_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `cutPrefix` — Phase 4 `usize` seam policy applied | done |
| `misc` | `cutSuffix` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `cutSuffix` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/cut_prefix_suffix_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9960_cut_prefix_suffix.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9960 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.cutPrefix` — [`misc`](../misc)

```zig
pub fn cutPrefix(comptime T: type, slice: []const T, prefix: []const T) ?[]const T {
    if (!startsWith(T, slice, prefix)) return null;
    const rest = slice[prefix.len..];
    // Postcondition: rest is the tail after a verified prefix.
    assert(prefix.len <= slice.len);
    assert(rest.len + prefix.len == slice.len);
    return rest;
}
```

- [x] `std..mem.cutSuffix` — [`misc`](../misc)

```zig
pub fn cutSuffix(comptime T: type, slice: []const T, suffix: []const T) ?[]const T {
    if (!endsWith(T, slice, suffix)) return null;
    const rest = slice[0 .. slice.len - suffix.len];
    // Postcondition: rest is the head before a verified suffix.
    assert(suffix.len <= slice.len);
    assert(rest.len + suffix.len == slice.len);
    return rest;
}
```

- [x] `std.mem.cutSuffix` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn cutSuffix(comptime T: type, slice: []const T, suffix: []const T) ?[]const T {
    if (!endsWith(T, slice, suffix)) return null;
    const rest = slice[0 .. slice.len - suffix.len];
    // Postcondition: rest is the head before a verified suffix.
    assert(suffix.len <= slice.len);
    assert(rest.len + suffix.len == slice.len);
    return rest;
}
```

## Postconditions

**cutPrefix** on match:

```zig
assert(prefix.len <= slice.len);
assert(rest.len + prefix.len == slice.len);
```

**cutSuffix** on match:

```zig
assert(suffix.len <= slice.len);
assert(rest.len + suffix.len == slice.len);
```

## What the test asserts

- Prefix chop on flag-style string
- Absent prefix returns null
- Suffix chop and absent suffix
- Empty needle preserves whole slice
