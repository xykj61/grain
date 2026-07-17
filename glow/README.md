# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-17 (generator hop — `|-` · `^-` · `?:` lower to Rye)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Checkable — eight rune heads + trap/cast/conditional lowering, GREEN
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

| Piece | Role |
|---|---|
| [`lower_trap.rye`](lower_trap.rye) | Lower `\|-  N` and `\|-  (lent face)` → complete `.rye` main |
| [`lower_cast.rye`](lower_cast.rye) | Lower `^-  @u32` → checked `std.math.cast` |
| [`lower_conditional.rye`](lower_conditional.rye) | Lower `?:  (gth tick 32)` and `?:  ready` → if/else |
| [`gen/bound-tick.glow`](gen/bound-tick.glow) | Literal desk generator (`\|-  32`) |
| [`gen/lent-tick.glow`](gen/lent-tick.glow) | Lent desk generator (`\|-  (lent records)`) |
| [`gen/cast-u32.glow`](gen/cast-u32.glow) | Cast desk generator (`^-  @u32`) |
| [`gen/if-gth.glow`](gen/if-gth.glow) | Conditional desk generator (`?:  (gth tick 32)`) |
| [`glow_run.rye`](glow_run.rye) | Lower `.glow` → `.rye` path on stdout |
| [`../tools/glow_run.rish`](../tools/glow_run.rish) | Rishi hand: lower, rye-build, run |
| [`../tools/glow_run_desk_witness.rish`](../tools/glow_run_desk_witness.rish) | Desk gens via `glow_run` |
| [`../tools/glow_lower_trap_witness.rish`](../tools/glow_lower_trap_witness.rish) | Trap welcome 0 / unwelcome 1 |
| [`../tools/glow_lower_cast_witness.rish`](../tools/glow_lower_cast_witness.rish) | Cast welcome 0 / unwelcome 1 |
| [`../tools/glow_lower_conditional_witness.rish`](../tools/glow_lower_conditional_witness.rish) | Conditional welcome 0 / unwelcome 1 |

```bash
rishi/bin/rishi run tools/glow_run.rish glow/gen/bound-tick.glow
rishi/bin/rishi run tools/glow_run.rish glow/gen/lent-tick.glow
rishi/bin/rishi run tools/glow_run.rish glow/gen/cast-u32.glow
rishi/bin/rishi run tools/glow_run.rish glow/gen/if-gth.glow
# → GREEN: glow_run — … exit 0
```

Lent emit uses a demo subject so the bound is `face.len` at runtime. Cast emit checked-casts a demo `u64` into `u32`. Conditional emit takes then (exit 0) or else (exit 1) from a demo subject. Other tests refuse until a later lap. No general Glow lexer yet.

---

*May every generator stay a short spelling of ordinary Rye, and may the shell stay the hand that runs it.*
