# Pass 9942 · mem.len — sentinel length points at terminator

**Witnesses:** 61 programs (grew from 60)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.195112`

## What this pass covers

**`std.mem.len`** — length of sentinel-terminated many-item and `[*c]` pointers. Pairs with `sliceTo` (9945) and `findSentinel` (9952).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.len`**

```zig
pub fn len(self: Slice) Index {
            return self.end - self.start;
        }
```

## Width notes

**`std.mem.len`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.len`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_len_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `len` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_len_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9942_mem_len.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9942 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.len` — [`misc`](../misc)

```zig
pub fn len(self: Slice) Index {
            return self.end - self.start;
        }
```

## Postconditions

On return, the byte/element at the returned index is the sentinel (`0` for `[*c]`).

## What the test asserts

- Custom sentinel on `[:4]u16` pointer
- `[*:0]const u8` C string with embedded NUL
- Empty C string
- String literal length
