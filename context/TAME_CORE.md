# TAME Core — the highest points, compressed

**Stamp:** `20260811.200854` · **Voice:** Kyri · **Status:** Living — the **core** of a core/shelf pair.
**Shelf (full, lossless):** [`TAME_GUIDANCE.md`](TAME_GUIDANCE.md) · **Source:** `../gratitude/TIGER_STYLE.md` (studied) · **Agent rules:** [`../.claude/rules/tame-guidance.md`](../.claude/rules/tame-guidance.md) · [`../.cursor/rules/tame-guidance.mdc`](../.cursor/rules/tame-guidance.mdc)

Token-dense on purpose. This is the smallest form that still holds TAME's highest points, so it can ride in the agent rules and be present every time we write **`.rye` · `.rish` · `.brix` · `.bron` · `.kyri` · Glow · Brush · `.myc`** code. The shelf keeps the full reasoning; the core keeps the reflexes.

## The spine

**Safety > Performance > Joy.** Safety is structural, not by convention. Performance is measured before optimized. Joy is clarity, named things, the habit of saying why. When they pull, safety wins; safety = performance ⇒ joy votes.

## Root — every family language

1. **Bound everything.** Every allocation, collection, loop, pipeline names a **max**. Name the budget at construction; check at the edge; fail with a **named error**, never silent corruption. No unbounded recursion.
2. **Assert invariants first.** Write `assert` at construction · mutation · postcondition **before** the body; aim **≥2 per fn**; each preceded by `// invariant:`. State them **positively**.
3. **Explicit widths.** `u32` in-memory counts/indices/lengths (bounded by a named const) · `u64` wire-persistent sizes/timestamps · `usize` **only** at the inherited-std seam (assert the bound, keep arithmetic in `u32`, `@intCast` at the edge). Never `usize` in authored fields/params/returns.
4. **Say why.** Every assert, named const, and surprising choice earns a reason comment.
5. **Accrete, never break — by tier.** Tier 1 proof-sealed (absolute) · Tier 2 testimony (recorded pass / erratum) · Tier 3 living (revisable). Only Tier 1 is absolute.
6. **One value model.** string · integer · bool · list · record — composed side by side, never tangled.
7. **Smallest scope, fewest variables; explicit options at the call site; docs and implementation stay synced (assert it, don't assume it).**
8. **Reds-first.** A red books the allocation; a fix is closed by a **witness on metal**, never a claim.

## Rye reflexes (`.rye`)

- **Opening triad**, every hosted file: `const std` · `const assert = std.debug.assert` · `const print = std.debug.print`. Then bare `assert(...)` / `print(...)`.
- **`snake_case`** fns/vars/files · **short fns** (split past ~70 lines at natural seams) · **named errors with `try`**.
- **No bare `@memcpy`** in new code → `tally/copy.rye` `copy_disjoint`. **No `std.debug.assert(`** (unqualified only). **No compound `assert(a and b)`** (split). No `Self = @This()`, `usingnamespace`, `FIXME`, `dbg(`.
- **Season allocator:** reach the arena via `const garden = init.arena.allocator()`; never construct `ArenaAllocator` in authored `.rye`.
- Prefer `tally/parse_int.rye` over bare `std.fmt.parseInt`; `tally/kumara.rye` over bare Ed25519.

## The other family tongues

- **Rishi (`.rish`)** — `run` returns `{ ok, out, code }`; check `status`/`.ok` **before** trusting `out`. `assert … else "msg"` as a gate. `if/then/else`, `for-each`. No integer div/mod; put `run [ … ]` args on one line.
- **Brix (`.brix`)** — composition language; declares systems, **evaluates to Bron**; every field bounded; override by **`double-seat`**/infuse, never silent reflow.
- **Bron / Kyri (`.bron` · `.kyri`)** — data notation: one `key value` per line, `#` comments, no quotes/braces; **parsed, not evaluated**; immutable values.
- **Glow** — the language: runes, **shape** (never Hoon's *mold*), lowers Glow→Rye→Zig→RISC-V; the Root rules hold through the lowering.
- **Brush (Brushstroke)** — paint/Skate surface; bounded frames, zero-copy where the pixels allow.
- **Myc (`.myc` / Mycelium)** — Sui-side reimpl; the same bounds, asserts, and named errors cross the seam.

## The checkable surface (the audit runs these)

- `tools/w/width-check.rish` — widths (seam-only `usize`).
- `tools/t/tame_style_check.rish` — tidy **bans** (fail) + **ratchets** (migrate on touch).
- `tools/r/rune_assert_sweep.rish` — asserting cores keep their asserts.
- `tools/l/living_docs_lint.rish` — living-doc links, status, retired words.

Run them when touching authored code; the **TAME Guidance Audit Quest** (one Quest/Equinox, double-seated) walks all four and books reds.

## Crash headroom

Reserve a doubling of the durable write up front (static allocation, TigerBeetle-style) so we never OOM and always **fail fast** at a bounded assert with room to name why. `[[crash headroom]]` · `[[double-seat]]`.

---

*The shelf holds the reasons; the core holds the reflexes. Read the core at the keyboard; reach the shelf when you must say why.*
