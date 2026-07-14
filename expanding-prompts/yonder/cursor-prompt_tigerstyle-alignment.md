# Cursor prompt — TigerStyle-alignment pass for TAME Style

**Goal:** Bring our written standard and our lint surface into line with real, working TigerBeetle — the idioms in `docs/TIGER_STYLE.md` and the checkable rules in `src/tidy.zig`. Three phases, each gated propose-then-confirm: adopt the improved supplement, refresh the one stale lint header, and grow the first textual TAME checks as small increments.

This is accretion and alignment — no behavior changes, no renames across the tree. Work in Radiant Style. Touch no other work.

---

## Step 0 — Footing check

Confirm and report, then stop:

- Current branch is `main`, working tree clean, level with `github/main`.
- `context/TAME_STYLE.md` exists (the operational supplement) and `tools/width-check.rish` exists (the one live lint).
- Report the current first three lines of `tools/width-check.rish` so we can see the stale header before refreshing it.

---

## Phase A — Adopt the improved supplement

Replace **`context/TAME_STYLE.md`** with the TigerStyle-aligned version authored alongside this prompt (the companion file `TAME_STYLE.md`). It is a permanent context file: plain header, no dated co-author line.

The improvements, so you can confirm the right text landed:

- Examples now import **unqualified `assert`** (`const assert = std.debug.assert;`) and call it bare — the form `tidy.zig` enforces. The previous `std.debug.assert(...)` call form is gone from the examples.
- The assertions section now carries the canon: **two assertions per function** on average, **paired assertions** across positive and negative space, **split compound assertions** (`assert(a); assert(b);`), the **implication idiom** (`if (a) assert(b)`), **`comptime assert`**, and the **gated expensive check**.
- Naming gains **types and receivers**: a type-returning function ends in **`Type`**; alias `@This()` to the **real type name**, never `Self`; prefer the type-named receiver in non-generic structs.
- Named errors gains **switch-on-errors** (no `== error.` / `!= error.`).
- Short functions gains the **70-line hard limit, ratcheted from the bottom**, and **push-`if`s-up / `for`s-down**.
- Root gains **state invariants positively**, **smallest scope**, **explicit options at the call site**, and folds **no-recursion / bounded loops** into Bounds.
- A new closing section, **What We Check, and When**, names the lint surface — enforced-now textual checks versus AST-horizon checks.

Integrity check after writing: the file begins with the `---` frontmatter and `name: TAME Style — Operational Supplement`; the "Last updated" line names the **TigerStyle-alignment pass**; the section **`## What We Check, and When`** is present; and the closing line is the benediction beginning "May the root hold firm." Confirm these, then commit alone:

```
context: align TAME Style with working TigerBeetle (tidy.zig + canon)

Adopt unqualified assert, paired assertions across positive and
negative space, split compound assertions, the 70-line function
limit ratcheted from the bottom, switch-on-errors, type/receiver
naming (real type name over Self), and a "What We Check, and When"
lint surface. Idioms drawn from src/tidy.zig and docs/TIGER_STYLE.md,
kept in gratitude.

Written together by Kaeden and Reya 2.
```

Report the hash and stop.

---

## Phase B — Refresh the stale width-check header

The check in `tools/width-check.rish` stays exactly as it is — zero literal `usize` in authored `.rye` is still correct. Only its **comment header and closing messages** speak the retired fork-first language ("debt to be eliminated by the compiler fork," "the F1 gate," "F2 complete"). Replace the header block with the one below, and soften the two closing lines so they name explicit-width discipline rather than fork debt. Propose the diff, then commit on confirmation.

New header:

```
# width-check.rish — verify authored .rye carry zero literal `usize`.
#
# TAME Style (context/TAME_STYLE.md, Rye supplement): prefer fixed
# widths; avoid architecture-specific `usize` in authored Rye. Use
# `u32` for bounded in-memory counts and indices, `u64` for
# wire-persistent sizes. At the inherited-std seam — calling Zig's std
# through pristine symlinks — assert the bound and `@intCast`; that
# lives in std-facing code, not in the authored .rye this check scans.
#
# The compiler fork is a deferred horizon, never the rationale here.
# We keep authored .rye usize-free because explicit width is good
# Tiger on its own merit.
#
# Usage: rishi run tools/width-check.rish
```

Closing messages: keep the GREEN line; reword the RED line from "debt for the compiler fork" to "explicit-width debt in authored Rye."

Commit:

```
tools: refresh width-check header to the thin-frontend direction

Keep the check; retire the fork-first rationale. Explicit width is
good Tiger on its own merit.

Written together by Kaeden and Reya 2.
```

---

## Phase C — Grow the first textual TAME checks (demand-driven, not a blocker)

Grow a new `tools/tame-check.rish` that holds the textual rules from "What We Check, and When." Do the cheapest, highest-leverage checks first, each as **its own small commit with a witness** — a tiny fixture that should fail, and a confirmation that the check catches it, mirroring how `tidy.zig` snapshot-tests each rule. This grows beside SLC-1; it does not block it.

For each check, **propose the concrete `.rish` against Rishi's real builtins** (`run`, `grep`, `map`, `where`, `for-each`, `lines`, `length`, `starts-with`, `ends-with`, `contains`) and wait for confirmation before writing it.

Order by leverage:

1. **Unqualified assert** — in authored `.rye`, flag any line containing `std.debug.assert(` or `debug.assert(`. The single line `const assert = std.debug.assert;` is the allowed mention; everything else is a violation.
2. **No `Self = @This()`** — flag the literal string `Self = @This()` in authored `.rye`.
3. **No tabs; no trailing whitespace** — flag any tab character, and any line ending in a space, across authored `.rye` and `.rish`.
4. **Line length ≤ 100** — flag lines longer than 100 columns, allowing a line that contains `https://` or whose multiline-string content itself fits.
5. **One `# Title` per markdown** — for each `.md` we own, count top-level `# ` lines outside fenced code blocks; flag zero (for documents longer than two lines) or more than one. This one serves our doc-heavy tree directly.
6. **No leftover `FIXME` or `dbg(`** — flag both in authored `.rye` and `.rish`; `FIXME` is welcome while iterating, gone before merge.

Hold the AST-level rules — the 70-line function limit, bitwise/arithmetic precedence, `defer` blank lines, dead declarations and dead files — as a **documented horizon**. They wait for a Zig parser, and we build them when Rye's own tooling can parse or the need is proven, rather than cloning `tidy.zig` ahead of the need.

Each check commits on its own, Radiant message, co-author trailer. Leave the push to Kaeden.

---

*May the standard and the check speak with one voice, and may each rule we add make the next line of Rye a little surer than the last.*
