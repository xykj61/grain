# 9001 · Fixture Pass — a small, honest test document

This pass strengthens `std.mem.eql`, to prove enrichment finds a properly
backtick-wrapped std reference.

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std.mem.eql`**

```zig
pub fn eql(comptime T: type, a: []const T, b: []const T) bool {
    return a.len == b.len;
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

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md), [`10024`](../expanding-prompts/date/20260620/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std.mem.eql`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |


## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std.mem.eql` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn eql(comptime T: type, a: []const T, b: []const T) bool {
    return a.len == b.len;
}
```


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `rye/lib/std/mem.zig` | `eql` — Phase 4 `usize` seam policy applied | done |
| `tools/p/parity.rish` | witness registered | done |
| `external-research/yonder/strengthening-compiler/9001_fixture_pass.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9001 | done |

## Postconditions
The fixture asserts nothing on its own; the witness checks the file after the run.
