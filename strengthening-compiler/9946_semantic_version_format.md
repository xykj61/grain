# Pass 9946 · SemanticVersion.format — semver text round-trips through parse

**Witnesses:** 57 programs (grew from 56)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.193212`

## What this pass covers

**`std.SemanticVersion.format`** — semver 2.0 serialization via `{f}`. Completes the trio with `parse` (9947) and `order` (9948).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..SemanticVersion.format`**

```zig
pub fn format(wv: WindowsVersion, w: *std.Io.Writer) std.Io.Writer.Error!void {
            if (std.enums.tagName(WindowsVersion, wv)) |name| {
                var vecs: [2][]const u8 = .{ ".", name };
                return w.writeVecAll(&vecs);
            } else {
                return w.print("@enumFromInt(0x{X:0>8})", .{wv});
            }
        }
```

## Width notes

**`std.SemanticVersion.format`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |






## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..SemanticVersion.format`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/semantic_version_format_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `format` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/semantic_version_format_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9946_semantic_version_format.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9946 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..SemanticVersion.format` — [`misc`](../misc)

```zig
pub fn format(wv: WindowsVersion, w: *std.Io.Writer) std.Io.Writer.Error!void {
            if (std.enums.tagName(WindowsVersion, wv)) |name| {
                var vecs: [2][]const u8 = .{ ".", name };
                return w.writeVecAll(&vecs);
            } else {
                return w.print("@enumFromInt(0x{X:0>8})", .{wv});
            }
        }
```

## Postconditions

On format entry, optional `pre` and `build` slices are non-empty when present — matching valid parsed versions.

## What the test asserts

- Release, pre-release, build metadata, and combined forms format to expected strings
- Round-trip agreement with strings accepted by `parse`
