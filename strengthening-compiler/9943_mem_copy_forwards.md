# Pass 9943 · copyForwards — copied prefix matches source

**Witnesses:** 60 programs (grew from 59)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.194512`

## What this pass covers

**`std.mem.copyForwards`** — copy from the start for overlapping destinations where `dest.ptr <= source.ptr`. Pairs with `copyBackwards` (9944); Mantra weave logic depends on the forward direction (9993).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.copyForwards`**

```zig
pub fn copyForwards(comptime T: type, dest: []T, source: []const T) void {
    // Precondition: dest must have room for every element of source.
    assert(dest.len >= source.len);
    for (dest[0..source.len], source) |*d, s| d.* = s;
    // Postcondition: when regions do not overlap, copied prefix matches source.
    const source_addr = @intFromPtr(source.ptr);
    const dest_addr = @intFromPtr(dest.ptr);
    const sources_end = source_addr + source.len * @sizeOf(T);
    const dests_end = dest_addr + dest.len * @sizeOf(T);
    const non_overlapping = source.len == 0 or dest_addr >= sources_end or dests_end <= source_addr;
    if (non_overlapping) assert(eql(T, dest[0..source.len], source));
}
```

## Width notes

**`std.mem.copyForwards`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.copyForwards`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_copy_forwards_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `copyForwards` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_copy_forwards_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9943_mem_copy_forwards.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9943 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.copyForwards` — [`misc`](../misc)

```zig
pub fn copyForwards(comptime T: type, dest: []T, source: []const T) void {
    // Precondition: dest must have room for every element of source.
    assert(dest.len >= source.len);
    for (dest[0..source.len], source) |*d, s| d.* = s;
    // Postcondition: when regions do not overlap, copied prefix matches source.
    const source_addr = @intFromPtr(source.ptr);
    const dest_addr = @intFromPtr(dest.ptr);
    const sources_end = source_addr + source.len * @sizeOf(T);
    const dests_end = dest_addr + dest.len * @sizeOf(T);
    const non_overlapping = source.len == 0 or dest_addr >= sources_end or dests_end <= source_addr;
    if (non_overlapping) assert(eql(T, dest[0..source.len], source));
}
```

## Postcondition

When source and destination do not overlap:

```zig
assert(eql(T, dest[0..source.len], source));
```

Overlapping copies skip the assert — aliased memory may mutate `source` during the forward walk.

## What the test asserts

- Non-overlapping prefix copy into a larger buffer
- Overlapping copy when destination starts before source (`memmove` semantics)
- Empty source is a no-op
