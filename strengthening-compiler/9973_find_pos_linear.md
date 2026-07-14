# Pass 9973 · findPosLinear — offset needle search stays in-range

**Corpus:** 30 programs (grew from 29)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.163512`

## What this pass covers

**`std.mem.findPosLinear`** (`indexOfPosLinear`) — linear forward search for a sub-slice from `start_index`. `findPos` delegates here on small inputs; complements `find` (9993) and the scalar search trio (9974–9975, 9996).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.findPosLinear`**

```zig
pub fn findPosLinear(comptime T: type, haystack: []const T, start_index: usize, needle: []const T) ?usize {
    if (needle.len > haystack.len) return null;
    var i: usize = start_index;
    const end = haystack.len - needle.len;
    while (i <= end) : (i += 1) {
        if (eql(T, haystack[i..][0..needle.len], needle)) {
            // Postcondition: a found index fits the needle from start_index onward.
            assert(i + needle.len <= haystack.len);
            assert(i >= start_index);
            return i;
        }
    }
    return null;
}
```

## Width notes

**`std.mem.findPosLinear`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.findPosLinear`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/find_pos_linear_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `findPosLinear` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/find_pos_linear_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9973_find_pos_linear.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9973 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.findPosLinear` — [`misc`](../misc)

```zig
pub fn findPosLinear(comptime T: type, haystack: []const T, start_index: usize, needle: []const T) ?usize {
    if (needle.len > haystack.len) return null;
    var i: usize = start_index;
    const end = haystack.len - needle.len;
    while (i <= end) : (i += 1) {
        if (eql(T, haystack[i..][0..needle.len], needle)) {
            // Postcondition: a found index fits the needle from start_index onward.
            assert(i + needle.len <= haystack.len);
            assert(i >= start_index);
            return i;
        }
    }
    return null;
}
```

## Postcondition

On match:

```zig
assert(i + needle.len <= haystack.len);
assert(i >= start_index);
```

## What the test asserts

- First match from zero
- Next match from offset
- No match when offset is past end
- Single-byte and multi-byte needles
- Second occurrence found when search starts after first
