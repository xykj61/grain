# TAME Guidance — Code

**Canon:** `external-research/TAME_GUIDANCE.md` (voiced Tiger Style) · **Source:** `gratitude/TIGER_STYLE.md`
**Operational supplement:** `context/TAME_GUIDANCE.md`. Apply when writing or reviewing Rye source (`.rye`), Brix descriptors (`.brix`), Bron notation (`.bron`), and Rishi scripts (`.rish`).

Full checkable surface: supplement section **What We Check, and When**.

## When this rule is active

- Writing or editing any `.rye` source file
- Writing or editing any `.brix` descriptor or `.bron` notation
- Writing or editing any `.rish` script
- Reviewing, suggesting changes to, or explaining any of the above

## Core moves (root — all family languages)

- State invariants **before** implementing: write `assert` calls at construction, mutation, and postcondition, each preceded by a `// invariant:` comment.
- Import assert once per file: `const assert = std.debug.assert;` — then call bare `assert(...)`, not `std.debug.assert(...)`.
- Import print once per file in hosted `.rye`: `const print = std.debug.print;` — then bare `print(...)`; as-you-touch, no tame-check gate yet.
- **Opening lines:** every hosted `.rye` file opens with `const std`, `const assert`, `const print` — canonical head per design sitting `20260702.031312`.
- Bounds on everything: every allocation, collection, and pipeline names a maximum. Name the budget at construction; enforce at the edge.
- Say why: every assertion, every named constant, every surprising design choice earns a comment that names the reason.
- Accrete, never break: a name once given is a promise. Add beside it; do not replace it silently.
- One value model: string, integer, bool, list, record — composed side by side, never tangled.
- **`snake_case`** for functions, variables, and file names.

## Explicit widths (authored Rye)

Tiger Style discipline: **`usize` is a boundary type, not a design type.** Read the full table and seam exemplar in `context/TAME_GUIDANCE.md`.

- **`u32`** — in-memory counts, indices, lengths bounded by a named constant.
- **`u64`** — wire-persistent sizes, timestamps, cross-target quantities.
- **`usize`** — **only** at the inherited-std seam. Assert the bound, keep arithmetic in `u32`, `@intCast` at the Zig API edge. Seam casts are correct Tiger code, not debt awaiting a fork.
- **Never** `usize` in struct fields, function parameters, return types, or locals we publish as authored API.
- Live lint: `tools/width-check.rish`. Growing: `tools/tame-check.rish`.
- Charter: `expanding-prompts/20260620-210812_explicit-width-audit.md`; baseline: `work-in-progress/20260620-212126_usize-width-baseline.md`.

**Compiler fork (F1–F5):** deferred **horizon** — not the active primary track. See `active-designing/20260628-043542_thin-frontend-slc-direction.md`.

## Supplement cheatsheet

| Language | Key discipline |
|----------|----------------|
| **Rye** | `u32` bounded, `u64` wire. Seam-only `usize`. Unqualified `assert`. Named errors with `try`. Short functions named with a verb. |
| **Brix** | Composition language — declares systems. Evaluates to Bron. Interfaces with Mantra, targets Aurora + Tally. |
| **Bron** | Data notation — plain key-value, one field per line. Parsed, not evaluated. |
| **Rishi** | `run` always returns `{ status, out, err }`. Check `status` before trusting `out`. `assert` as a pipeline gate. `if/then/else` for conditionals. `for-each` for iteration. |

## Season memory (Rye only)

- **Never** construct or name `std.heap.ArenaAllocator` in authored `.rye`.
- **Always** reach for the season allocator via `const garden = init.arena.allocator()` — `init.arena` at the std seam; `garden` as the warm local name (Tally's future concept).
- Full policy: `context/specs/inherited-names.md`.

## The priority order

Safety first — structural, not by convention. Performance second — measure before optimizing. Joy third — clarity, named things, the habit of saying why.

When these pull against each other, safety wins. When safety and performance are equal, joy earns the vote.

## Tidy rules (`tame_style_check`)

**Witness:** `tools/tame_style_check.rish` · **Scan:** `tools/fixtures/tame_style_scan.sh` · **Brief:** `active-designing/20260707-164612_tame-tidy-rules-brief.md` · **Study:** `external-research/20260707-053212_tigerbeetle-alignment-study.md`

**Bans fail parity** — fix before commit:

- `) == error.` / `) != error.` at call seams (captured `|err|` in assert is welcome)
- `std.debug.assert(` — unqualified `assert` only
- `assert(a and b)` — split compound asserts
- `copyForwards` / `copyBackwards` — use `tally/copy.rye` `copy_disjoint`
- `Self = @This()`, `usingnamespace`, `!comptime`, `FIXME`, `dbg(`

**Ratchets print, never fail** — migrate on touch in every file you edit:

- `@memcpy(` application sites → `copy_disjoint` (1 intentional `@memcpy` remains inside `copy_disjoint` only)
- camelCase `fn` → `snake_case` for all functions in the touched file; grep inbound references
- functions past 70 lines → split at natural seams; run module witnesses
- zero `assert(` in core modules → import assert; contract postconditions; see honest exempt list in scan script

Run when touching authored `.rye`: `rishi/bin/rishi run tools/tame_style_check.rish`
