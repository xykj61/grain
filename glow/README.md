# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-17 (first generator hop — `|-` lowers to Rye)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — eight rune heads + first lowering hop, GREEN
**Ground:** [`active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md) · [`20260716-093000_glow-and-rye-what-shares-under-the-hood.md`](../active-designing/20260716-093000_glow-and-rye-what-shares-under-the-hood.md)

---

Glow is the **language** (Hoon-parallel). Rishi is the **shell** (Dojo-parallel). Glow emits ordinary `.rye`; Rye's bridge takes it to Zig. Rishi drives witnesses and `glow_run`.

## Rune heads

| File | Rune | Proves |
|---|---|---|
| [`rune_bounded_trap.rye`](rune_bounded_trap.rye) | `\|-` | Bound shapes + `run_bounded` / `BoundExceeded` |
| [`rune_cast.rye`](rune_cast.rye) | `^-` | Mold name — aura or named mold |
| [`rune_conditional.rye`](rune_conditional.rye) | `?:` | Test expression |
| [`rune_switch.rye`](rune_switch.rye) | `?-` | Subject wing |
| [`rune_face.rye`](rune_face.rye) | `=/` | Face + optional mold |
| [`rune_null.rye`](rune_null.rye) | `?~` | Null-test subject |
| [`rune_mutate.rye`](rune_mutate.rye) | `=.` | Wing to mutate |
| [`rune_alias.rye`](rune_alias.rye) | `=*` | Alias face |

## First generator hop

| Piece | Role |
|---|---|
| [`lower_trap.rye`](lower_trap.rye) | Lower literal `\|-  N` → complete `.rye` main |
| [`gen/bound-tick.glow`](gen/bound-tick.glow) | Smallest desk generator (`\|-  32`) |
| [`glow_run.rye`](glow_run.rye) | Lower `.glow` → `.rye` path on stdout |
| [`../tools/glow_run.rish`](../tools/glow_run.rish) | Rishi hand: lower, rye-build, run |
| [`../tools/glow_lower_trap_witness.rish`](../tools/glow_lower_trap_witness.rish) | Welcome exit 0 / unwelcome exit 1 |

```bash
rishi/bin/rishi run tools/glow_run.rish glow/gen/bound-tick.glow
# → GREEN: glow_run — … exit 0
```

`(lent …)` bounds parse but do not lower yet (`NotYetLowered`). No general Glow lexer yet.

---

*May every generator stay a short spelling of ordinary Rye, and may the shell stay the hand that runs it.*
