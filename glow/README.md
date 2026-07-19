# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-18 (**STOA9** `%*` call · TAME + Acme first-code pointers)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Audience:** Acme Corporation employees reading the working Glow pin
**Status:** Checkable — **STOA0–9** sixteen heads emit · nests · cells · full `%` calls · truth semantics, GREEN
**Waymark:** **STOA** — compressor [`../docs/STOA.md`](../docs/STOA.md) · seat [`../active-designing/20260718-202730_stoa-glow-language-waymark.md`](../active-designing/20260718-202730_stoa-glow-language-waymark.md)
**Ground:** [`active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md`](../active-designing/20260716-033000_sameness-and-the-rune-glow-grammar-riscv.md) · [`20260716-093000_glow-and-rye-what-shares-under-the-hood.md`](../active-designing/20260716-093000_glow-and-rye-what-shares-under-the-hood.md) · truth [`../context/specs/20260717-154943_glow-truth-zig-ambient-nock-loobean-seam.md`](../context/specs/20260717-154943_glow-truth-zig-ambient-nock-loobean-seam.md)
**Law:** [`../context/TAME_GUIDANCE.md`](../context/TAME_GUIDANCE.md) (root) · Glow supplement still horizon — scoping [`../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md`](../external-research/20260713-225841_glow-supplement-scoping-runes-auras-jet-state.md)
**Acme first code:** [`../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md`](../expanding-prompts/20260717-213242_glow-first-code-beside-glass-and-open-runes.md)

---

Glow is the **language** (Hoon-parallel). Rishi is the **shell** (Dojo-parallel). Glow emits ordinary `.rye`; Rye's bridge takes it to Zig. Rishi drives witnesses and `glow_run`. Foundations and TAME stay the unmoved north star; this README is the working surface pin, not a seated Glow TAME chapter yet.

## Truth

**Ambient Glow truth is Zig / Rye** — `bool`, ordinary `if`, process exit **0** = success. Glow does **not** inherit Hoon/Nock loobeans (0 = yes, 1 = no) as ambient meaning. Loobeans convert only at an explicit Nock/Hoon seam via [`truth_semantics.rye`](truth_semantics.rye) (`loob_to_bool` / `bool_to_loob`). Desk arm decimals such as `1` and `0` are ordinary payloads, not loobean yes/no. Witness: [`../tools/glow_truth_semantics_witness.rish`](../tools/glow_truth_semantics_witness.rish).

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
| [`rune_cell.rye`](rune_cell.rye) | `:-` | Pair cell — two faces (STOA2) |
| [`rune_triple.rye`](rune_triple.rye) | `:+` | Triple cell — three faces (STOA3) |
| [`rune_quad.rye`](rune_quad.rye) | `:^` | Quad cell — four faces (STOA4) |
| [`rune_list.rye`](rune_list.rye) | `:~` | List cell — one to four faces (STOA5) |
| [`rune_call.rye`](rune_call.rye) | `%-` | One-arg call — closed demo gate `double` (STOA6) |
| [`rune_call2.rye`](rune_call2.rye) | `%+` | Two-arg call — closed demo gate `add` (STOA7) |
| [`rune_call3.rye`](rune_call3.rye) | `%^` | Three-arg call — closed demo gate `sum` (STOA8) |
| [`rune_calln.rye`](rune_calln.rye) | `%*` | Named-arg call — closed demo gate `mix` (STOA9) |

## Generator hop

All sixteen heads lower today. Desk files live under [`gen/`](gen/). Rishi hand: [`../tools/glow_run.rish`](../tools/glow_run.rish) · desk witness: [`../tools/glow_run_desk_witness.rish`](../tools/glow_run_desk_witness.rish).

```bash
rishi/bin/rishi run tools/glow_run.rish glow/gen/call-named.glow
rishi/bin/rishi run tools/glow_run_desk_witness.rish
# → GREEN: glow_run desk — all desk generators …
```

Each hop lowers one named shape from its front-half parser. Under `|-`, `(lent …)` still emits a shrinking-list fold under `face.len`. Nest forms parse once through [`expr.rye`](expr.rye): decimal · nested `^-  @uN  <decimal>` through `@u64` · bare face · **`(lent <face>)`** · **`(mix <face> <face>)`** · **`(jam <face> <face>)`** under `=/` and arms (desks as before; witness [`../tools/glow_expr_witness.rish`](../tools/glow_expr_witness.rish)). Cell heads: **`:-`** pair · **`:+`** triple · **`:^`** quad · **`:~`** list (desks `cell-pair` · `cell-triple` · `cell-quad` · `cell-list`). Calls: **`%-`** `double` · **`%+`** `add` · **`%^`** `sum` · **`%*`** named `mix` (desks `call-one` · `call-two` · `call-three` · `call-named`). `=.` takes optional trailing decimals; `=*` takes an optional source wing. Cast hop covers `@u8` · `@u16` · `@u32` · `@u64`. `(cue …)`, nested jam, cores, and multi-line stay **STOA10+**. Generator welcome/unwelcome paths use Zig/POSIX exits (0 / 1), per the Truth section above.

---

*May every generator stay a short spelling of ordinary Rye, and may the shell stay the hand that runs it.*
