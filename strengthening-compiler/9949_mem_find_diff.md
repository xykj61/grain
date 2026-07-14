# Pass 9949 · findDiff — first inequality agrees with equality

**Witnesses:** 54 programs (grew from 53)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.191212`

## What this pass covers

**`std.mem.findDiff`** — index of first differing element, or null when slices are equal. Complements `mem.eql` (9996) and `mem.order` (9953).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.findDiff`**

```zig
pub fn findDiff(comptime T: type, a: []const T, b: []const T) ?usize {
    const shortest = @min(a.len, b.len);
    if (a.ptr == b.ptr) {
        const result: ?usize = if (a.len == b.len) null else shortest;
        if (result) |idx| {
            assert(idx == shortest);
            assert(a.len != b.len);
        } else assert(eql(T, a, b));
        return result;
    }
    var index: usize = 0;
    while (index < shortest) : (index += 1) {
        if (a[index] != b[index]) {
            assert(index < shortest);
            assert(a[index] != b[index]);
            return index;
        }
    }
    const result: ?usize = if (a.len == b.len) null else shortest;
    if (result) |idx| {
        assert(idx == shortest);
        assert(a.len != b.len);
    } else assert(eql(T, a, b));
    return result;
}
```

## Width notes

**`std.mem.findDiff`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.findDiff`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_find_diff_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `findDiff` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_find_diff_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9949_mem_find_diff.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9949 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.findDiff` — [`misc`](../misc)

```zig
pub fn findDiff(comptime T: type, a: []const T, b: []const T) ?usize {
    const shortest = @min(a.len, b.len);
    if (a.ptr == b.ptr) {
        const result: ?usize = if (a.len == b.len) null else shortest;
        if (result) |idx| {
            assert(idx == shortest);
            assert(a.len != b.len);
        } else assert(eql(T, a, b));
        return result;
    }
    var index: usize = 0;
    while (index < shortest) : (index += 1) {
        if (a[index] != b[index]) {
            assert(index < shortest);
            assert(a[index] != b[index]);
            return index;
        }
    }
    const result: ?usize = if (a.len == b.len) null else shortest;
    if (result) |idx| {
        assert(idx == shortest);
        assert(a.len != b.len);
    } else assert(eql(T, a, b));
    return result;
}
```

## Postconditions

On every return path:

- `null` ⇒ `eql(a, b)`
- `Some(idx)` ⇒ `idx == @min(a.len, b.len)` when lengths differ, else `a[idx] != b[idx]` with `idx < shortest`

## What the test asserts

- Equal slices, length mismatch at common prefix end, mid-string diff
- Shared-pointer sub-slice vs full slice
