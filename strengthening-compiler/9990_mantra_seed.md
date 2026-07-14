# 9990 — Mantra seed: the living history of a text stream

**Target:** `mantra/src/main.rye` (new module), `rye/tests/mantra_weave_test.rye` (new witness test)
**Parity:** 14/14 GREEN

---

## Rye std surface

**Authored:** `mantra/src/main.rye` — not an inherited `std` function. Width migration is Tier A in `992`.

## Width notes

Migrate struct fields and counters to `u32`/`u64` per `10024`; keep `usize` only at `buf[0..n]` slice seams with `bufLenU32` helpers.





## usize explicit audit

Tiger Style: *use explicitly-sized types like `u32`; avoid architecture-specific `usize`* ([`gratitude/TIGER_STYLE.md`](../gratitude/TIGER_STYLE.md) § Safety).

TAME: **`usize` is a boundary type, not a design type** — [`context/TAME_STYLE.md`](../context/TAME_STYLE.md), [`10024`](../expanding-prompts/20260620-210812_explicit-width-audit.md), [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md).

Lexicon ✅ requires every row **`done`** and zero **`fail`** rows.
### Authored `mantra/src/main.rye`

| Width locus | Type | Policy | Status |
|-------------|------|--------|--------|
| `mantra/src/main.rye` struct fields | Tier A `u32`/`u64` | Authored API — migrate per `10024` | done |
| `buf[0..n]` slice seams | inherited `usize` | `bufLenU32` at boundary only | done |

## Width audit (affected files)

| File | Audit | Status |
|------|-------|--------|
| `mantra/src/main.rye` | authored Tier A widths | done |
| `tools/parity.rish` | witness registered | done |
| `strengthening-compiler/9990_mantra_seed.md` | pass record + audited surfaces | done |
| `## usize explicit audit` | per-surface locus table — gates lexicon ✅ | done |
| `992_strengthening_width_crosswalk.md` | lexicon row 9990 | done |

## Audited surfaces

Checkmark requires **`## usize explicit audit`** all `done`, zero `fail` (Tiger/TAME — [`992`](../work-in-progress/20260620-212126_usize-width-baseline.md)). Full implementation from `rye/lib/std`:
- [x] `mantra/src/main.rye` — [`mantra/src/main.rye`](../mantra/src/main.rye)

## What we built

Mantra is the version-control layer of the Rye family. The seed is the smallest version that runs: one file, three commands, one weave.

### The weave model

A **Weave** is a list of **Lines**. Each Line carries:
- `text: []const u8` — the content, permanent once assigned
- `gen: u32` — generation count; odd = present, even = gone; never decreases
- `pos: u32` — stable position; assigned monotonically, never reused

Generation parity names presence; generation value names history depth. The weave never forgets a line — it accumulates. `current()` surfaces only what is present now.

Invariants asserted at every operation:
- `line.gen >= 1` — zero is reserved
- `line.gen % 2 == 1` ↔ line is present
- `line.pos < next_pos` — positions are monotone

### The diff

`computeDiff(old_lines, new_text) → Diff` — pure LCS over line text equality. Same inputs produce the same Diff, every time. The diff names the minimal edit between the weave's current view and the desired new text.

Postcondition: applying the returned Diff to a weave whose `current()` equals `old_lines` produces a weave whose `current()` equals `new_text`.

### The store

Content-addressed blob storage under `.mantra/blobs/`. A blob's identity is its SHA3-256 digest (64-char hex). Write-once: if the name exists, the content is already there. HEAD holds the 64-char blob name of the current weave state.

This is the first use of SHA3-256 as a content-naming primitive in running code — the promise from pass 9994 made real.

### The commands

```
mantra init           — create .mantra/ (idempotent)
mantra add <file>     — weave the file's current content into the history
mantra status <file>  — show what has changed since the last weave
```

---

## Architecture note: single-file seed

`rye build` bridges only the root file to `.zig`; relative `@import` of other `.rye` files does not chain. All existing Rye programs are single-file for this reason. Mantra seed follows the same discipline. The logical sections (Weave, Diff, Store, main) are separated by section headers within the file — the future module boundaries are named, ready for when `rye build` gains multi-file support.

---

## Parity test

`rye/tests/mantra_weave_test.rye` — pure computation, no file I/O.

Scenarios:
1. Empty weave: `current()` returns zero lines.
2. Apply insert diff: 3 lines present, positions 0/1/2.
3. Apply delete+insert: position 1 gone, new line at position 3.
4. LCS diff: `old=["a","b","c"]`, `new=["a","c","d"]` → delete pos 1, insert `"d"`.
5. Apply diff, confirm `current()` equals `["a","c","d"]`.
6. Idempotent: diff of unchanged text = empty diff.

Output (both baseline and Rye std):
```
rye: Mantra weave assertions confirmed (Weave, Diff, LCS, idempotent).
```
Exit code: 0.

---

## Position in the stack

| Pass | Subject |
|------|---------|
| 9999 | Manifesto |
| 9998 | SHA3-512 |
| 9997 | Keccak generic |
| 9996 | SHA3-512 boundary |
| 9995 | Ed25519 + X25519 + AEAD |
| 9994 | SHA3-256 |
| 9993 | mem diff primitives |
| 9992 | std.Io.Dir filesystem boundary |
| 9991 | Dir.iterate name invariants + exhaustion state |
| **9990** | **Mantra seed: Weave, LCS diff, SHA3-256 store, init/add/status** |

SHA3-256 names Mantra's blobs. The mem diff primitives power the LCS. The fs boundary guards every file read/write. Dir.iterate will walk the repository in a future pass. The four strengthening passes that gated this seed are all in use.
