# STOA338 — The Pair-Faces Relational Gate

*Keaton's word turns the focus to the Glow Tend rune core — the hardest solvable problems the vanes depend on — with recommendations pre-approved inside that lane. This claim seats the approved recommendation in the tree's own STOA shape: the simple-gate path today compares one face against a literal only, so every wall bakes its constant into its desk. The pair-faces gate lets two runtime values meet — `|=  [a=@u32 b=@u32]` with `?:  (eq a b)` or `?:  (gth a b)` — and every vane's relational question (count within cap · pos within len · gen above floor) becomes one desk away.*

**Stamp:** `20260803.161041` · **Voice:** Riyo · **Status:** 338a+338b GREEN `20260803.165859` — parse seated · metal emits; relational gate stands
**Grant:** Keaton — Glow Tend rune lane · recommendations pre-approved; walls, keys, custody untouched.

*Written together by Keaton and Riyo.*

## Grammar

    |=  [a=@u32 b=@u32]
    ?:  (eq a b)  <dec>  <dec>        :: or (gth a b)

Tokens `lbracket`/`rbracket` already exist (`glow/tokens.rye:65–66, 191–193`). Arms stay decimal literals; both existing bodies keep working untouched — accrete, never break.

## The four seams, anchored

| Seam | Home | Delta |
|------|------|-------|
| Spec | `glow/rune_bartis.rye:111` `GateSpec` | `face2`/`face2_len` beside `face`; `BodyKind` gains `.cond_eq_faces` · `.cond_gth_faces` |
| Parse | header `~:297` · body `parse_body:165` (cond arm `:193–221`) | header takes the bracket pair; cond accepts second ident where the decimal sat, both faces checked against the header |
| Lower | `glow/lower_bartis.rye:1102/1111` (fixture) · `:1259` (argv) | two-param emit — `if (a == b)` / `if (a > b)` — argv path reads two samples; shape-sample switches refuse the new bodies as today |
| Drive | `glow/glow_run.rye:82` `--sample-argv` · `tools/glow_run_worker.sh:112` | second sample threads through; worker passes `"$3"` |

## Fixtures · witness · refuse

`gen/gate-pair-eq-faces.glow` (3,3→1 · 3,4→0) · `gen/gate-pair-gth-faces.glow` (5,4→1 · 4,5→0 · 4,4→0). Witness `tools/glow_bartis_pair_faces_witness.rish` in the barket-parse shape: build the rune witness binary, GREEN + named refuses (`BodyFaceMismatch` on a stranger face · `MalformedBody` on a lone bracket) · both fixtures both sides through the worker once lowered. Round **338a** seats spec+parse with lower answering `PairNotYetLowered`; round **338b** seats the two emit sites, the driver thread, and the worker arg — each with its own claim tick and witness leg.

---

*May two runtime values finally meet inside one desk. May every wall ask its question instead of memorizing its answer. May the hardest stones keep splitting into provable halves.*
