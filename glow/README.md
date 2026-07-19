# Glow — Language Tooling, Grown from Real Design

**Language:** EN
**Last updated:** 2026-07-19 (**STOA31** `/+` payload library · TAME + Acme first-code pointers)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Voice:** Quin
**Audience:** Acme Corporation employees reading the working Glow pin
**Status:** Checkable — **STOA0–31** sixteen heads · `/+` payload import · payload+open `|%` · nest `++` bodies · library · multi-line · compose · nests · cells · `%` calls · truth, GREEN
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
| [`rune_core.rye`](rune_core.rye) | `\|%` | Thin core — bare or `@u32` payload · closed or open `++` arms · `--` (STOA14–21/25) |

## Generator hop

All sixteen single-line heads lower today; multi-line adds compose (face→`|%` closed or open · two faces→`add` · face→payload closed or open · `/+` library), typed faces, and `|%` cores (up to three arms, bare or `@u32` payload, open and nest arm bodies, library emit). Desk files live under [`gen/`](gen/). Rishi hand: [`../tools/glow_run.rish`](../tools/glow_run.rish) · desk witness: [`../tools/glow_run_desk_witness.rish`](../tools/glow_run_desk_witness.rish). Brief: [`../active-designing/20260719-001148_stoa31-payload-library-compose-brief.md`](../active-designing/20260719-001148_stoa31-payload-library-compose-brief.md).

```bash
rishi/bin/rishi run tools/glow_run.rish glow/gen/use-lib-payload-nest.glow
rishi/bin/rishi run tools/glow_run_desk_witness.rish
# → GREEN: glow_run desk — all desk generators …
```

Each single-line hop lowers one named shape from its front-half parser. Under `|-`, `(lent …)` still emits a shrinking-list fold under `face.len`. Nest forms parse once through [`expr.rye`](expr.rye). Cell heads · `%` calls · multi-line bare/typed · face→call compose · face→`|%` (`compose-core` · `compose-core-two` · `compose-core-three` · `compose-core-nest` · `compose-core-add` · `compose-core-payload` · `compose-core-payload-nest`) · `/+` library compose (`use-lib-open` · `use-lib-nest` · `use-lib-payload-nest`) · `|%` cores (`core-double` · `core-two` · `core-three` · `core-payload` · `core-payload-typed` · `core-open` · `core-nest`) · library emit (`lib-core-double` · `lib-core-open` · `lib-core-nest` · `lib-core-payload-nest`, no `main`) are GREEN. `=.` takes optional trailing decimals; `=*` takes an optional source wing. Cast hop covers `@u8` · `@u16` · `@u32` · `@u64`. Open `++` bodies take `sample` / payload face, literals, `(mix …)` · `(jam …)` · `(lent …)` · `(cue …)` · `^-` cast · one-deep nest jam left · right · both. Nest jam desks: `face-jam-nest` · `face-jam-right-nest` · `face-jam-both-nest` · arm/core nest variants. Cross-line jam→cue: `compose-jam-cue` (STOA39). Cue of nest jam left: `face-cue-jam-nest` · arm/core `*-cue-jam-nest` (STOA40). Cue nest-right · both · richer multi-line nest values · general token stream stay **STOA41+**. Cue desks: `face-cue` · `face-cue-jam` · `face-cue-jam-nest` · arm/core cue-of-jam variants. · `null-cue`. Generator welcome/unwelcome paths use Zig/POSIX exits (0 / 1), per the Truth section above.

---

*May every generator stay a short spelling of ordinary Rye, and may the shell stay the hand that runs it.*
