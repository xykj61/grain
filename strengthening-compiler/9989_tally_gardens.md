# 9989 — Tally v1: named gardens

**Target:** `tally/gardens.rye` (new module), `rye/tests/tally_gardens_test.rye` (new witness test)
**Parity:** 15/15 GREEN

---

## Rye std surface

**Authored:** `tally/gardens.rye` — not an inherited `std` function. Width migration is Tier A in `992`.

## Width notes

Migrate struct fields and counters to `u32`/`u64` per `10024`; keep `usize` only at `buf[0..n]` slice seams with `bufLenU32` helpers.





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### Authored `tally/gardens.rye`

| Width locus | Type | Policy | Status |
|-------------|------|--------|--------|
| `tally/gardens.rye` struct fields | Tier A `u32`/`u64` | Authored API — migrate per `10024` | done |
| `buf[0..n]` slice seams | inherited `usize` | `bufLenU32` at boundary only | done |

## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `tally/gardens.rye` | authored Tier A widths | done |
| `rye/tests/tally_gardens_test.rye` | witness program | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9989_tally_gardens.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9989 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `tally/gardens.rye` — [`tally/gardens.rye`](../tally/gardens.rye)

## What we built

Tally is the memory-management layer of the Rye family. Pass 9989 delivers Tally v1: the full `Gardens` model. The seed (`tally/seed.rye`, pass 9990) proved one `Region` with 13 asserted invariants. v1 names them.

### The Gardens model

A **Gardens** holds a fixed set of named `Region`s. Each Region is a bounded garden with a stated edge — bump-allocate within, fail past, clear whole in one gesture. Gardens adds the naming layer: a caller declares "this memory is the blob garden" or "this memory is the diff garden" and retrieves it by name at any time.

Three gardens cover the near stack:
- `blob` — working memory for one Mantra blob (read buffer, serialize buffer)
- `diff` — line buffer for LCS diff computation
- `frame` — Brushstroke widget tree per redraw

The backing memory lives with the caller. `Gardens` holds views and asserts the edges at every operation.

### Invariants, asserted at every mutation

```
region.pos <= region.buf.len    (the edge — never crossed)
name.len > 0                    (every garden has a name)
name.len <= max_name_len        (names fit in the declared limit)
no two gardens share a name     (asserted at add)
```

### API surface

| Method | What it does |
|--------|-------------|
| `init()` | Empty Gardens — no regions yet |
| `add(name, buf)` | Register a named Region over `buf`; asserts all invariants |
| `get(name) ?*Region` | Look up by name; returns a live pointer or null |
| `clearOne(name)` | Reset one garden's position; asserts the name exists |
| `clearAll()` | Reset all gardens at once; postcondition: all pos == 0 |
| `totalRemaining()` | Total bytes remaining across all gardens |

### Parity test design

`rye/tests/tally_gardens_test.rye` uses `pub fn main() void` with stack buffers (64/32/16 bytes). Pure computation — no Init dependency, no file I/O, no allocator — so the test is identical against baseline and Rye stds. It exercises:

- `add` three gardens; `get` finds all three, absent name returns null
- `alloc` within bounds: slice length and remaining both correct
- `alloc` past edge: `error.OutOfBounds`, named and loud
- `clearOne`: resets one garden, others untouched
- `clearAll`: resets all; `totalRemaining` returns full backing size
- Pointer reuse after clear: same backing memory, fresh season
- Invariant loop: `name.len`, `name.len <= max_name_len`, `pos <= buf.len` all hold at rest

### Single-file constraint

`tally/gardens.rye` inlines `Region` from `tally/seed.rye` directly — `rye build` bridges only the root `.rye` file to Zig, so relative `@import("seed.rye")` is not available. The inline is honest about the source: `§ Region — the bounded garden (from tally/seed.rye, inline for rye build)`.

---

## What grows from here

- **Mantra for the repo** — `blob`, `diff`, and `frame` gardens now have names; Mantra's memory floor is declared. The next pass grows Mantra from seed to multi-file weave.
- **Brix minimum** — `.brix` project descriptor at the repo root; Mantra reads it at startup to know which paths to walk.
- **`tally/heap-garden.rye`** — a future pass: stack Gardens → heap Garden, backed by `std.heap.ArenaAllocator`. The same season model, one level up.
