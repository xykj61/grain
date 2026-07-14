# Pass 9977 · path.extension — suffix stays within the input

**Corpus:** 26 programs (grew from 25)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.161312`

## What this pass covers

**`std.fs.path.extension`** — returns the filename suffix after the last dot. Completes the path trio with `basename` (9978) and `dirname` (9980).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..fs.path.extension`**

```zig
pub fn extension(path: []const u8) []const u8 {
    const filename = basename(path);
    const index = mem.lastIndexOfScalar(u8, filename, '.') orelse return path[path.len..];
    if (index == 0) return path[path.len..];
    const result = filename[index..];
    // Postcondition: extension is a sub-slice of the input path (doc guarantee).
    assert(result.len <= path.len);
    if (result.len > 0) assert(mem.indexOf(u8, path, result) != null);
    return result;
}
```

## Width notes

**`std.fs.path.extension`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..fs.path.extension`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/path_extension_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `extension` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/path_extension_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9977_path_extension.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9977 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..fs.path.extension` — [`misc`](../misc)

```zig
pub fn extension(path: []const u8) []const u8 {
    const filename = basename(path);
    const index = mem.lastIndexOfScalar(u8, filename, '.') orelse return path[path.len..];
    if (index == 0) return path[path.len..];
    const result = filename[index..];
    // Postcondition: extension is a sub-slice of the input path (doc guarantee).
    assert(result.len <= path.len);
    if (result.len > 0) assert(mem.indexOf(u8, path, result) != null);
    return result;
}
```

## Postcondition

```zig
assert(result.len <= path.len);
if (result.len > 0) assert(mem.indexOf(u8, path, result) != null);
```

## What the test asserts

- Normal extension on a file
- Last dot wins on multi-dot names
- No extension when absent
- Leading-dot hidden files return empty
- Nested path resolves through basename
- Empty path returns empty
