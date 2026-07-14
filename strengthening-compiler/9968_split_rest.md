# Pass 9968 · SplitIterator.rest — tail slice stays within the buffer

**Corpus:** 35 programs (grew from 34)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.165512`

## What this pass covers

**`SplitIterator.rest`** — returns the unprocessed tail without advancing. Mantra uses it after `next()` on tab-separated weave rows and newline-split lines.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.mem.split`**

*see `rye/lib/std` — `mem.split` not auto-located*

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
### `std.mem.split`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| `std.mem.split` | — | Live `pub fn` not located — cannot run Tiger/TAME audit | pending |

### Witness `rye/tests/split_rest_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/mem.zig` | `split` — Phase 4 `usize` seam policy applied | pending |
| `rye/tests/split_rest_test.rye` | witness program | pending |
| `tools/parity.rish` | witness registered | pending |
| `strengthening-compiler/9968_split_rest.md` | pass record + audited surfaces | pending |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | pending |
| `992_strengthening_width_crosswalk.md` | lexicon row 9968 | pending |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [ ] `std.mem.split` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

## Postcondition

```zig
if (self.index) |idx| assert(idx <= self.buffer.len);
assert(start <= end);
```

## What the test asserts

- rest shrinks as fields are consumed
- rest is empty when iteration completes
- fresh iterator rest is the whole buffer
- Mantra-shaped tab field tail after first column
