# Pass 9980 · path.dirname — parent path stays within the input

**Corpus:** 23 programs (grew from 22)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.152412`

## What this pass covers

**`std.fs.path.dirname`** — returns the parent directory of a path, or null for roots and bare filenames. The rye bridge calls it on every multi-file `@import("*.rye")` resolution to find sibling modules.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..fs.path.dirname`**

```zig
pub fn dirname(path: []const u8) ?[]const u8 {
    if (native_os == .windows) {
        return dirnameWindows(path);
    } else {
        return dirnamePosix(path);
    }
}
```

## Width notes

**`std.fs.path.dirname`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..fs.path.dirname`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/path_dirname_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `dirname` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/path_dirname_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9980_path_dirname.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9980 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..fs.path.dirname` — [`misc`](../misc)

```zig
pub fn dirname(path: []const u8) ?[]const u8 {
    if (native_os == .windows) {
        return dirnameWindows(path);
    } else {
        return dirnamePosix(path);
    }
}
```

## Postcondition

At `dirnameInner` return:

```zig
assert(result.len <= path.len);
assert(mem.startsWith(u8, path, result));
```

When the function returns null, no postcondition applies — empty paths, roots, and filename-only paths legitimately have no parent.

## What the test asserts

- Nested relative path yields the expected parent
- Multi-component relative path (`a/b/c` → `a/b`)
- Absolute child (`/a` → `/`)
- Bare filename, empty string, and root return null
- Parity holds against baseline std

## Call graph note

`dirname` → `dirnamePosix` / `dirnameWindows` → `dirnameInner`. The invariant lands in `dirnameInner` so both platform paths share one stated contract.
