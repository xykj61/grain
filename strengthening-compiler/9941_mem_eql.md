# Pass 9941 · mem.eql — equality verdict agrees with length and difference

**Witnesses:** 62 programs (grew from 61)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.195412`

## What this pass covers

**`std.mem.eql`** — slice equality. Rishi compares names on every line; complements `findDiff` (9949) and `order` (9953). Builds on the `maybe` documentation from 9996 with return-path postconditions.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.eql`**

```zig
pub fn eql(set: Set, other_set: Set) bool {
                return std.mem.eql(usize, &set.ints, &other_set.ints);
            }
```

## Width notes

**`std.mem.eql`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.eql`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_eql_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `eql` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_eql_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9941_mem_eql.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9941 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.eql` — [`misc`](../misc)

```zig
pub fn eql(set: Set, other_set: Set) bool {
                return std.mem.eql(usize, &set.ints, &other_set.ints);
            }
```

## Postconditions

**Vector path (`eqlBytes`):**

- `true` ⇒ `a.len == b.len`
- `false` ⇒ `a.len != b.len` or `findDiff(a, b) != null`

**Scalar path:**

- `false` on length mismatch ⇒ `a.len != b.len`
- `true` on empty or shared pointer ⇒ `a.len == b.len`
- `false` on element mismatch ⇒ differing element at that index
- final `true` ⇒ `a.len == b.len`

## What the test asserts

- Equal and unequal strings, length mismatch, empty slices
- Shared-pointer self-compare
- Mid-string inequality on longer inputs (exercises vector path on u8)
