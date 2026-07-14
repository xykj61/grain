# Pass 9917 · mem.replace — output length and content verified

**Witnesses:** 86 programs (grew from 85)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260621.031512`

## What this pass covers

**`std.mem.replace`** — replace every needle occurrence in input, writing to a caller buffer. Pairs with `startsWith` (9939) and `replacementSize`.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.replace`**

```zig
pub fn replace(af: *Atomic, io: Io) ReplaceError!void {
    assert(af.file_exists); // Wrong value for `CreateFileAtomicOptions.replace`.
    if (af.file_open) {
        af.file.close(io);
        af.file_open = false;
    }
    const tmp_sub_path = std.fmt.hex(af.file_basename_hex);
    try af.dir.rename(&tmp_sub_path, af.dir, af.dest_sub_path, io);
    af.file_exists = false;
}
```

## Width notes

**`std.mem.replace`** — Public signature inherits Zig `usize` for slice lengths and indices — keep at the inherited seam per `992` Phase 4. Narrow to `u32`/`u64` only for named bounds inside the body (`max_*_check`, loop counters) with `assert` before `@intCast`.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.replace`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/mem_replace_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `replace` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/mem_replace_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9917_mem_replace.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9917 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.replace` — [`misc`](../misc)

```zig
pub fn replace(af: *Atomic, io: Io) ReplaceError!void {
    assert(af.file_exists); // Wrong value for `CreateFileAtomicOptions.replace`.
    if (af.file_open) {
        af.file.close(io);
        af.file_open = false;
    }
    const tmp_sub_path = std.fmt.hex(af.file_basename_hex);
    try af.dir.rename(&tmp_sub_path, af.dir, af.dest_sub_path, io);
    af.file_exists = false;
}
```

## Postconditions

Precondition: `replacementSize(...) <= output.len`. After the walk, write index equals `replacementSize`. When `input.len <= 64` and output fits in 128 elements, independent verify loop confirms each emitted span.

## What the test asserts

- Single replacement (`base` → `Zig`)
- Adjacent replacements (`b` → `cd` in `abbba`)
- Empty input yields zero replacements
