# Pass 9978 · path.basename — final component stays within the input

**Corpus:** 25 programs (grew from 24)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.160312`

## What this pass covers

**`std.fs.path.basename`** — returns the final path component. Complements `path.dirname` (9980) on the path pair the rye bridge and Pond policy will compose.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..fs.path.basename`**

```zig
pub fn basename(path: []const u8) []const u8 {
    if (native_os == .windows) {
        return basenameWindows(path);
    } else {
        return basenamePosix(path);
    }
}
```

## Width notes

**`std.fs.path.basename`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..fs.path.basename`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/path_basename_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `basename` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/path_basename_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9978_path_basename.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9978 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..fs.path.basename` — [`misc`](../misc)

```zig
pub fn basename(path: []const u8) []const u8 {
    if (native_os == .windows) {
        return basenameWindows(path);
    } else {
        return basenamePosix(path);
    }
}
```

## Postcondition

At `basenameInner` return:

```zig
assert(result.len <= path.len);
if (result.len > 0) assert(mem.indexOf(u8, path, result) != null);
```

## What the test asserts

- Nested path yields the filename
- Absolute path yields the last segment
- Bare filename returns itself
- Empty path and root return empty
- Parity holds against baseline std
