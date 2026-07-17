# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-17 (eighth rune head — `=*` alias; `=` category complete)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — eight small rune-head parsers, GREEN
**Ground:** [`active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md)

---

This is where Glow's own language tooling lives once a design earns real code. Each tenant is one rune's **front half** — real text parsed at the head — connected to a named discipline, never a leap to a general grammar.

| File | Rune | Proves |
|---|---|---|
| [`rune_bounded_trap.rye`](rune_bounded_trap.rye) | `\|-` | Bound shapes `32` and `(lent records)` + checked `run_bounded` / `BoundExceeded` |
| [`rune_cast.rye`](rune_cast.rye) | `^-` | Mold name — aura (`@u32`) or named mold (`record`) |
| [`rune_conditional.rye`](rune_conditional.rye) | `?:` | Test expression — parenthesized or bare identifier; then/else not yet |
| [`rune_switch.rye`](rune_switch.rye) | `?-` | Subject wing (`kind.cur-record`); arm exhaustiveness not yet |
| [`rune_face.rye`](rune_face.rye) | `=/` | Face + optional mold (`cur-record=record`, `next-root=@u32`); value not yet |
| [`rune_null.rye`](rune_null.rye) | `?~` | Subject wing (`records.cur`); then/else null arms not yet |
| [`rune_mutate.rye`](rune_mutate.rye) | `=.` | Wing to mutate (`root`, `kind.cur-record`); new value not yet |
| [`rune_alias.rye`](rune_alias.rye) | `=*` | Alias face (`records`); source wing not yet |

Witnesses: `rune_*_witness.rye` · rish wrappers under `tools/` · wired in `tools/parity_ch01.rish`.

## What This Is, and Is Not

Eight heads across four categories: **bar**, **cast**, **conditional** (`?:` · `?-` · `?~`), **bindings** (`=/` · `=.` · `=*` — category complete). The brief's composition heads are covered, and the whole `=` trio is named. It is **not** a general Glow lexer or lowering pass — those stay design until a real need asks.

---

*May the next rune's own front half arrive the same way — small, real, and connected to a discipline already named, rather than argued and left waiting.*
