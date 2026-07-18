# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-18 (TAME + Acme first-code pointers)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Audience:** Acme Corporation employees reading the working Glow pin
**Status:** Checkable — eight heads emit · shared `expr.rye` nests incl. `(lent …)` and `(mix …)` on face and arms · truth semantics, GREEN
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

## Generator hop

All eight heads lower today. Desk files live under [`gen/`](gen/). Rishi hand: [`../tools/glow_run.rish`](../tools/glow_run.rish) · desk witness: [`../tools/glow_run_desk_witness.rish`](../tools/glow_run_desk_witness.rish).

```bash
rishi/bin/rishi run tools/glow_run.rish glow/gen/alias-records.glow
rishi/bin/rishi run tools/glow_run_desk_witness.rish
# → GREEN: glow_run desk — all eight generator hops …
```

Each hop lowers one named shape from its front-half parser. Under `|-`, `(lent …)` still emits a shrinking-list fold under `face.len`. Nest forms parse once through [`expr.rye`](expr.rye): decimal · nested `^-  @uN  <decimal>` through `@u64` · bare face · **`(lent <face>)`** as a length payload under `=/` and as then/else or mint/send arms on `?:` · `?-` · `?~` (desk `face-lent` · `if-lent` · `switch-lent` · `null-lent`) · **`(mix <face> <face>)`** as bitwise XOR under `=/` and as arms on `?:` · `?-` · `?~` (desk `face-mix` · `if-mix` · `switch-mix` · `null-mix`; Hoon `+mix` parallel; witness [`../tools/glow_expr_witness.rish`](../tools/glow_expr_witness.rish)). `=.` takes optional trailing decimals; `=*` takes an optional source wing. Cast hop covers `@u8` · `@u16` · `@u32` · `@u64`. Other parenthesized values (`(jam …)`, …) and a fuller token stream stay later. Generator welcome/unwelcome paths use Zig/POSIX exits (0 / 1), per the Truth section above.

---

*May every generator stay a short spelling of ordinary Rye, and may the shell stay the hand that runs it.*
