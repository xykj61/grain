# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-17 (eight heads emit · unsigned cast auras `@u8`–`@u64`)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — eight rune heads + eight lowering hops + cast aura family, GREEN
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

All eight heads lower today. Desk files live under [`gen/`](gen/). Rishi hand: [`../tools/glow_run.rish`](../tools/glow_run.rish) · desk witness: [`../tools/glow_run_desk_witness.rish`](../tools/glow_run_desk_witness.rish).

```bash
rishi/bin/rishi run tools/glow_run.rish glow/gen/alias-records.glow
rishi/bin/rishi run tools/glow_run_desk_witness.rish
# → GREEN: glow_run desk — all eight generator hops …
```

Each hop lowers one named shape from its front-half parser; richer bodies refuse until a later lap. Cast hop covers `@u8` · `@u16` · `@u32` · `@u64`. No general Glow lexer yet.

---

*May every generator stay a short spelling of ordinary Rye, and may the shell stay the hand that runs it.*
