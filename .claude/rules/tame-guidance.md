# TAME Guidance -- Code

**Canon:** `external-research/TAME_GUIDANCE.md` (voiced Tiger Style) - **Source:** `gratitude/TIGER_STYLE.md`
**Operational supplement (the shelf):** `context/TAME_GUIDANCE.md`. **Compressed core (read first):** `context/TAME_CORE.md`. Apply when writing or reviewing Rye (`.rye`), Rishi (`.rish`), Brix (`.brix`), Bron (`.bron`), Kyri (`.kyri`), Glow, Brush (Brushstroke), and Mycelium (`.myc`) code.

Full checkable surface: supplement section **What We Check, and When**.

## TAME Core -- the reflexes (always, every code write)

The highest points, token-dense; the full form is [`context/TAME_CORE.md`](../../context/TAME_CORE.md) (core) and `context/TAME_GUIDANCE.md` (shelf).

- **Safety > performance > joy** -- safety structural, performance measured, joy is clarity + saying why.
- **Bound everything** -- every allocation/collection/loop names a max; check at the edge; fail with a **named error**. No unbounded recursion.
- **Assert invariants first** -- construction - mutation - postcondition, **>=2 per fn**, each `// invariant:`, stated **positively**.
- **Explicit widths** -- `u32` in-memory - `u64` wire - `usize` **seam-only** (assert bound, `@intCast` at edge). **Say why.** Accrete by tier. One value model (string-int-bool-list-record).
- **Rye reflexes** -- opening triad (`std`-`assert`-`print`) - `snake_case` - short fns - named errors with `try` - `copy_disjoint` not bare `@memcpy` - unqualified `assert` (never `std.debug.assert(`) - no compound `assert(a and b)` - `garden` arena, never raw `ArenaAllocator`.
- **Rishi** -- `run` -> `{ out, err, code, ok }`, check `ok` before trusting `out`; no integer div/mod; `run [ ... ]` args on one line.
- **Reds-first** -- a red books the allocation; a fix closes on a **witness on metal**, never a claim.

## When this rule is active

- Writing or editing any `.rye` source file
- Writing or editing any `.brix` descriptor or `.bron` notation
- Writing or editing any `.rish` script
- Reviewing, suggesting changes to, or explaining any of the above

## Core moves (root -- all family languages)

- State invariants **before** implementing: write `assert` calls at construction, mutation, and postcondition, each preceded by a `// invariant:` comment.
- Import assert once per file: `const assert = std.debug.assert;` -- then call bare `assert(...)`, not `std.debug.assert(...)`.
- Import print once per file in hosted `.rye`: `const print = std.debug.print;` -- then bare `print(...)`; as-you-touch, no tame-check gate yet.
- **Opening lines:** every hosted `.rye` file opens with `const std`, `const assert`, `const print` -- canonical head per design sitting `20260702.031312`.
- Bounds on everything: every allocation, collection, and pipeline names a maximum. Name the budget at construction; enforce at the edge.
- Say why: every assertion, every named constant, every surprising design choice earns a comment that names the reason.
- Accrete, never break -- **three tiers**: Tier 1 sealed by proof (absolute); Tier 2 sealed by testimony (recorded Radiant pass / errata); Tier 3 open to revision. Only Tier 1 is absolute. Canon: `context/TAME_GUIDANCE.md` section 4.
- One value model: string, integer, bool, list, record -- composed side by side, never tangled.
- **`snake_case`** for functions, variables, and file names.
- **Seated word choices** (`20260828.233241`): **dependent** over *child* for supervised or spawned things (`std.process.Child` keeps Zig's name); **red** / **error** over *bug*; **first resident** over the banned *dogfooding* -- [`vocabulary-dependent.md`](vocabulary-dependent.md) - [`vocabulary-red-over-bug.md`](vocabulary-red-over-bug.md) - [`vocabulary-first-resident.md`](vocabulary-first-resident.md).

## Explicit widths (authored Rye)

Tiger Style discipline: **`usize` is a boundary type, not a design type.** Read the full table and seam exemplar in `context/TAME_GUIDANCE.md`.

- **`u32`** -- in-memory counts, indices, lengths bounded by a named constant.
- **`u64`** -- wire-persistent sizes, timestamps, cross-target quantities.
- **`usize`** -- **only** at the inherited-std seam. Assert the bound, keep arithmetic in `u32`, `@intCast` at the Zig API edge. Seam casts are correct Tiger code, not debt awaiting a fork.
- **Never** `usize` in struct fields, function parameters, return types, or locals we publish as authored API.
- Live lint: `tools/w/width-check.rish`. Growing: `tools/t/tame-check.rish`.
- Charter: `expanding-prompts/date/20260620/20260620-210812_explicit-width-audit.md`; baseline: `construction/20260620-212126_usize-width-baseline.md`.

**Compiler fork (F1-F5):** deferred **horizon** -- not the active primary track. See `active-designing/date/20260628/20260628-043542_thin-frontend-slc-direction.md`.

## Supplement cheatsheet

| Language | Key discipline |
|----------|----------------|
| **Rye** | `u32` bounded, `u64` wire. Seam-only `usize`. Unqualified `assert`. Named errors with `try`. Short functions named with a verb. |
| **Brix** | Composition language -- declares systems. Evaluates to Bron. Interfaces with Mantra, targets Aurora + Tally. |
| **Bron** | Data notation -- plain key-value, one field per line. Parsed, not evaluated. |
| **Rishi** | `run` always returns `{ out, err, code, ok }`. Check `ok` before trusting `out`. `assert` as a pipeline gate. `if/then/else` for conditionals. `for-each` for iteration. |

## Chapter memory (Rye only)

- **Never** construct or name `std.heap.ArenaAllocator` in authored `.rye`.
- **Always** reach for the season allocator via `const garden = init.arena.allocator()` -- `init.arena` at the std seam; `garden` as the warm local name (Tally's future concept).
- Never rename it either: `std.heap.GardenAllocator` as a thin alias steals the name reserved for Tally's own region type.
- **Walled at zero** by [`../../tools/c/chapter_allocator_witness.rish`](../../tools/c/chapter_allocator_witness.rish) over [`../../tools/fixtures/c/chapter_allocator_scan.sh`](../../tools/fixtures/c/chapter_allocator_scan.sh), seated `20260908.083050`. Both readings are gated separately, because reaching for the inherited type and renaming it are two faults with two cures; a comment teaching the ban passes free, and inherited std keeps the name by the spec's own clause. Until that stamp the reflex stood on three law pages as an absolute and in no guard at all.
- Full policy: `context/specs/inherited-names.md`.

## The priority order

Safety first -- structural rather than by convention. Performance second -- measure before optimizing. Joy third -- clarity, named things, the habit of saying why.

When these pull against each other, safety wins. When safety and performance are equal, joy earns the vote.

## Tidy rules (`tame_style_check`)

**Witness:** `tools/t/tame_style_check.rish` - **Scan:** `tools/fixtures/t/tame_style_scan.sh` - **Brief:** `active-designing/date/20260707/20260707-164612_tame-tidy-rules-brief.md` - **Study:** `external-research/20260707-053212_tigerbeetle-alignment-study.md`

**Bans fail parity** -- fix before commit:

- `) == error.` / `) != error.` at call seams (captured `|err|` in assert is welcome)
- `std.debug.assert(` -- unqualified `assert` only
- `assert(a and b)` -- split compound asserts
- `copyForwards` / `copyBackwards` -- use `tally/copy.rye` `copy_disjoint`
- `Self = @This()`, `usingnamespace`, `!comptime`, `FIXME`, `dbg(`

**Ratchets print, never fail** -- migrate on touch in every file you edit:

- `@memcpy(` application sites -> `copy_disjoint`. The one intentional `@memcpy` inside `copy_disjoint` is the only one the rule permits; the count standing is **135**, read `20260909` after two sites in `glow/rune_core.rye` migrated on touch -- and it is a FREE figure, held by no gate, so run `rishi/bin/rishi run tools/t/tame_style_check.rish` rather than reading this number. It read 137 on `20260908` after the ratchet's roster widened from fifteen rooms to the twenty its sibling half already read (`tools/fixtures/t/tame_style_rooms.txt`). This line has said `1` since `20260707`, when the ratchet reached one on the population it could see, and that was a reading of the population rather than of the tree -- `glow/` alone carries 129 of them.
- camelCase `fn` -> `snake_case` for all functions in the touched file; grep inbound references
- functions past 70 lines -> split at natural seams; run module witnesses
- zero `assert(` in core modules -> import assert; contract postconditions; see honest exempt list in scan script

Run when touching authored `.rye`: `rishi/bin/rishi run tools/t/tame_style_check.rish`

## SLC Rye Definition of Done (hosted - linengrow - glass)

No new law -- the supplement already seats this. Agents must not skip it when shipping an SLC.

1. **Opening triad** on every new or touched hosted `.rye`: `const std`, `const assert = std.debug.assert`, `const print = std.debug.print` (witnesses use bare `print` for claim lines).
2. **Contract asserts** on every new/touched `fn` -- aim >= two per function (preconditions, postconditions, bounds). `// invariant:` on each assert.
3. **No new `@memcpy`** -- use `tally/copy.rye` `copy_disjoint` (linengrow: `@import("tally_copy.rye")` symlink).
4. **Witnesses are not enough** -- a GREEN `*_witness.rye` does not excuse zero asserts in the module under test.
5. **Before claiming GREEN** -- run `tame_style_check` and the module's own witness; trust advise ratchet counts (native must match legacy after `20260717.181715`).
6. **Glass / NativeActivity touch** -- migrate `@memcpy` and add opening lines in that file before leaving.

**Ledger:** `active-designing/20260717-181715_tame-slc-rye-audit-ledger.md` - **Brief:** `active-designing/date/20260707/20260707-164612_tame-tidy-rules-brief.md`
