# STOA — Glow language SLC ladder

*Waymark for Glow the language: rune heads that lower, nest forms that deepen, composition that grows toward Glow-authored modules. Compresses the working pin; never replaces it.*

**Status:** Checkable — operator compressor (STOA0–STOA11 GREEN)  
**Depth:** guide  
**Ceiling:** ≤80 lines  
**Last updated:** 2026-07-18 (STOA11 face→call compose GREEN)  
**Compresses:** [`../glow/README.md`](../glow/README.md) · first-code [`../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md`](../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md) · sameness [`../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md) · seat [`../active-designing/20260718-202730_stoa-glow-language-waymark.md`](../active-designing/20260718-202730_stoa-glow-language-waymark.md)

---

## Thesis — name the language lap

Product glass and wire stay Rye-hosted under their own waymarks. **STOA** names the language path so eight GREEN heads count as an SLC Lap, and every nest or composition rung has a home beside them — not a rewrite of SETU or ZETA.

**Waymark draw:** input `glow-language-rune-heads-nest-and-lowering-2` · SHA3-512 · flw.txt → **STOA** (`tools/waymark_derive.rish`, `20260718.202730`). First draw **MAIR** (`…-lowering`, `20260718.202414`) superseded same day by Keaton’s redraw.

## Rung table

| Rung | Claim | Witness / gate | State |
|------|-------|----------------|-------|
| **STOA0** | Eight rune heads + desk hop · `(lent)` · `(mix)` | `glow_run_desk_witness` · `glow_expr_witness` | **GREEN** (claimed `20260718.202730`) |
| **STOA1** | `(jam <face> <face>)` thin cell-pack · desks | `glow_expr` · `glow_lower_*` · desk | **GREEN** `20260718.203000` |
| **STOA2** | `:-` pair cell · ninth rune head | `glow_rune_cell` · `glow_lower_cell` · desk | **GREEN** `20260718.204500` |
| **STOA3** | `:+` triple cell · tenth rune head | `glow_rune_triple` · `glow_lower_triple` · desk | **GREEN** `20260718.205200` |
| **STOA4** | `:^` quad cell · eleventh rune head | `glow_rune_quad` · `glow_lower_quad` · desk | **GREEN** `20260718.205400` |
| **STOA5** | `:~` list cell · twelfth rune head | `glow_rune_list` · `glow_lower_list` · desk | **GREEN** `20260718.205715` |
| **STOA6** | `%-` one-arg call · thirteenth rune head | `glow_rune_call` · `glow_lower_call` · desk | **GREEN** `20260718.205959` |
| **STOA7** | `%+` two-arg call · fourteenth rune head | `glow_rune_call2` · `glow_lower_call2` · desk | **GREEN** `20260718.210823` |
| **STOA8** | `%^` three-arg call · fifteenth rune head | `glow_rune_call3` · `glow_lower_call3` · desk | **GREEN** `20260718.211059` |
| **STOA9** | `%*` named-arg call · sixteenth rune head | `glow_rune_calln` · `glow_lower_calln` · desk | **GREEN** `20260718.211343` |
| **STOA10** | Multi-line bare `=/` desk (2–4 lines) | `glow_lower_multi` · desk | **GREEN** `20260718.211817` |
| **STOA11** | Cross-line face→`%-` compose | `glow_lower_compose` · desk | **GREEN** `20260718.212131` |
| **STOA12** | Cores · richer composition | horizon — check-in | horizon |

## Hands-on

```bash
cd ~/urbit
rishi/bin/rishi run tools/glow_run.rish glow/gen/compose-call.glow
rishi/bin/rishi run tools/glow_run_desk_witness.rish
```

Sibling product ladders: **ZETA** · **LULU** · **SETU** · **TUBE**. Language door: [`../manual/README.md`](../manual/README.md).

---

*May every head lower honestly, and every nest deepen the same language.*
