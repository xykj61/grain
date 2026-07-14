# Pass 9958 · cutLast and cutScalarLast — backward split-once stays in-range

**Corpus:** 45 programs (grew from 44)
**Gate:** GREEN — parity confirmed
**Stamp:** `20260620.175312`

## What this pass covers

**`std.mem.cutLast`** and **`cutScalarLast`** — return before/after slices at the **last** needle occurrence. Pairs with `cut`/`cutScalar` (9959); use `findLast` / `findScalarLast` (9970, 9975).

## Rye std surface

Live implementation from `rye/lib/std` (strengthened):

**`std..mem.cutLast`**

```zig
pub fn cutLast(comptime T: type, haystack: []const T, needle: []const T) ?struct { []const T, []const T }
```

**`std..mem.cutScalarLast`**

```zig
pub fn cutScalarLast(comptime T: type, haystack: []const T, needle: T) ?struct { []const T, []const T }
```

**`std.mem.cutScalarLast`**

```zig
pub fn cutScalarLast(comptime T: type, haystack: []const T, needle: T) ?struct { []const T, []const T }
```

## Width notes

**`std.mem.cutLast`** — No `usize` in the public signature; internal slice walks still use `usize` at the seam where Zig slices require it.

| Surface | Width policy |
|---------|-------------|
| Inherited params (`[]T`, `len`, indices) | `usize` — Zig seam |
| Named snapshot/check bounds | prefer `u32` + `assert(len <= max)` |
| Wire-persistent counts | `u64` when on the wire (`992` Phase 2) |





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### `std..mem.cutLast`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std..mem.cutScalarLast`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### `std.mem.cutScalarLast`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| slice params / `.len` | inherited `usize` (Tier C) | Tiger: avoid `usize` in APIs we publish — this surface is inherited Zig `std`; unchanged per `10024` rule 3 | done |
| Tier | C — inherited `std` | `992` Phase 4 — touch named bounds only; do not rename public seam | done |

### Witness `rye/tests/cut_last_test.rye`

| Check | Type | Tiger/TAME policy | Status |
|-------|------|-------------------|--------|
| Tier | B — witness `.rye` | `992` — `usize` only at `buf[0..n]` slice edge | done |
| witness body | slice edge only | Stack buffers + `.len` at seam — no authored `usize` fields | done |


## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `misc` | `cutLast` — Phase 4 `usize` seam policy applied | done |
| `misc` | `cutScalarLast` — Phase 4 `usize` seam policy applied | done |
| `rye/lib/std/mem.zig` | `cutScalarLast` — Phase 4 `usize` seam policy applied | done |
| `rye/tests/cut_last_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9958_cut_last.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9958 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `std..mem.cutLast` — [`misc`](../misc)

```zig
pub fn cutLast(comptime T: type, haystack: []const T, needle: []const T) ?struct { []const T, []const T }
```

- [x] `std..mem.cutScalarLast` — [`misc`](../misc)

```zig
pub fn cutScalarLast(comptime T: type, haystack: []const T, needle: T) ?struct { []const T, []const T }
```

- [x] `std.mem.cutScalarLast` — [`rye/lib/std/mem.zig`](../rye/lib/std/mem.zig)

```zig
pub fn cutScalarLast(comptime T: type, haystack: []const T, needle: T) ?struct { []const T, []const T }
```

## Postconditions

Same contract as forward `cut`/`cutScalar` — index in range, parts reassemble haystack.

## What the test asserts

- Absent needle returns null
- Sequence and scalar last-split match upstream cases
