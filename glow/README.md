# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-17 (generator hop through `?~` null)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — eight rune heads + six lowering hops, GREEN
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

## Generator hop

Six heads lower today: `|-` · `^-` · `?:` · `?-` · `=/` · `?~`. Desk files live under [`gen/`](gen/). Rishi hand: [`../tools/glow_run.rish`](../tools/glow_run.rish).

```bash
rishi/bin/rishi run tools/glow_run.rish glow/gen/null-records.glow
# → GREEN: glow_run — … exit 0
```

Each hop lowers one named shape from its front-half parser; other shapes refuse until a later lap. Remaining heads without a lower yet: `=.` · `=*`. No general Glow lexer yet.

---

*May every generator stay a short spelling of ordinary Rye, and may the shell stay the hand that runs it.*
