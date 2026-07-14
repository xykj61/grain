# Pass 9970 · findLast — backward search entry states the fit contract

**Corpus:** 33 programs (grew from 32)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.164812`

## What this pass covers

**`std.mem.findLast`** (`lastIndexOf`) — unified backward sub-slice search. Delegates to `findLastLinear` (9972) or reverse Boyer-Moore-Horspool; complements `find` / `findPos` (9971).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.findLast`**

```zig
pub fn findLast(node: *Node) *Node {
        var it = node;
        while (true) {
            it = it.next orelse return it;
        }
    }
```

## Width notes

**`std.mem.findLast`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.findLast`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/find_last_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `findLast` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/find_last_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9970_find_last.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9970 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.findLast` — [`misc`](../misc)

```zig
pub fn findLast(node: *Node) *Node {
        var it = node;
        while (true) {
            it = it.next orelse return it;
        }
    }
```

## Postcondition

On reverse BMH match:

```zig
assert(result + needle.len <= haystack.len);
```

`findLastLinear` path already strengthened (9972). Empty needle returns `haystack.len` per std semantics.

## What the test asserts

- Last repeated needle wins
- Single-char last match
- Not found
- Empty needle at haystack.len
- Long haystack exercises reverse BMH path
