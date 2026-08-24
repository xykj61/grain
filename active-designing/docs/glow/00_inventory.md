# Glow Surface Inventory -- Generated Census

**Language:** EN
**Style:** Gauge (see `../../../context/GAUGE_STYLE.md`)
**Status:** Checkable -- every row below is generated from the tree at origin/main nib `4344cdc2a7`; regenerate with the command in the footer rather than editing rows by hand
**Voice:** Quin (workshop)

---

This census is the Glow Book's ground truth: one row per non-witness module in `glow/`, its opening self-description, its size, and whether a witness twin stands beside it. The desk carries **317** `.glow` fixtures and generators, with **14** Hoon study twins siloed under `gen/hoon-study/`. The STOA ledger ([`../../../docs/STOA.md`](../../../docs/STOA.md)) holds the claim-by-claim GREEN history, STOA0-333.

| Kind | Module | Lines | Witness | Opening line |
|---|---|---:|:---:|---|
| core | [`digraph_twin_check.rye`](../../../glow/digraph_twin_check.rye) | 46 | -- | Digraph twin check -- each fixture line tokenizes as Kind.rune2 (STOA333). |
| core | [`expr.rye`](../../../glow/expr.rye) | 440 | yes | expr.rye -- shared nest-expression surface for Glow lowers. |
| core | [`face_lit.rye`](../../../glow/face_lit.rye) | 136 | yes | face_lit.rye -- parse face=cord_lit|hex_lit sample clauses (STOA219). |
| core | [`glow_run.rye`](../../../glow/glow_run.rye) | 443 | -- | glow_run.rye -- lower a `.glow` generator to `.rye` (language hop). |
| lower | [`lower_alias.rye`](../../../glow/lower_alias.rye) | 107 | yes | lower_alias.rye -- lower a parsed `=*` alias to runnable `.rye`. |
| lower | [`lower_assert.rye`](../../../glow/lower_assert.rye) | 115 | yes | lower_assert.rye -- lower Glow `?>` / `?<` to Rye `assert` (STOA88). |
| lower | [`lower_barket.rye`](../../../glow/lower_barket.rye) | 822 | yes | lower_barket.rye -- lower a thin `|^` barket to runnable `.rye` (STOA113-118). |
| lower | [`lower_bartis.rye`](../../../glow/lower_bartis.rye) | 821 | yes | lower_bartis.rye -- lower a thin `|=` bartis gate to runnable `.rye` (STOA100-107). |
| lower | [`lower_call.rye`](../../../glow/lower_call.rye) | 94 | yes | lower_call.rye -- lower a parsed `%-` call to runnable `.rye`. |
| lower | [`lower_call2.rye`](../../../glow/lower_call2.rye) | 105 | yes | lower_call2.rye -- lower a parsed `%+` call to runnable `.rye`. |
| lower | [`lower_call3.rye`](../../../glow/lower_call3.rye) | 127 | yes | lower_call3.rye -- lower a parsed `%^` call to runnable `.rye`. |
| lower | [`lower_calln.rye`](../../../glow/lower_calln.rye) | 112 | yes | lower_calln.rye -- lower a parsed `%*` call to runnable `.rye`. |
| lower | [`lower_cast.rye`](../../../glow/lower_cast.rye) | 145 | yes | lower_cast.rye -- lower a parsed `^-` cast to runnable `.rye` text. |
| lower | [`lower_cell.rye`](../../../glow/lower_cell.rye) | 93 | yes | lower_cell.rye -- lower a parsed `:-` pair cell to runnable `.rye`. |
| lower | [`lower_compose.rye`](../../../glow/lower_compose.rye) | 155 | yes | lower_compose.rye -- lower a cross-line face->call desk to one `.rye`. |
| lower | [`lower_compose2.rye`](../../../glow/lower_compose2.rye) | 171 | yes | lower_compose2.rye -- lower face->face->`%+` compose to one `.rye`. |
| lower | [`lower_compose_core.rye`](../../../glow/lower_compose_core.rye) | 352 | yes | lower_compose_core.rye -- lower face->`|%` core compose to one `.rye`. |
| lower | [`lower_compose_core_add.rye`](../../../glow/lower_compose_core_add.rye) | 179 | yes | lower_compose_core_add.rye -- two faces -> two-arg `|%` arm. |
| lower | [`lower_compose_core_payload.rye`](../../../glow/lower_compose_core_payload.rye) | 320 | yes | lower_compose_core_payload.rye -- outer face -> payload `|%` core. |
| lower | [`lower_compose_jam_cue.rye`](../../../glow/lower_compose_jam_cue.rye) | 868 | yes | lower_compose_jam_cue.rye -- cross-line jam then cue (STOA39/43-52). |
| lower | [`lower_compose_lib.rye`](../../../glow/lower_compose_lib.rye) | 348 | yes | lower_compose_lib.rye -- `/+` Glow library -> face -> `%-` call. |
| lower | [`lower_conditional.rye`](../../../glow/lower_conditional.rye) | 524 | yes | lower_conditional.rye -- lower a parsed `?:` test to runnable `.rye`. |
| lower | [`lower_core.rye`](../../../glow/lower_core.rye) | 319 | yes | lower_core.rye -- lower a thin `|%` core to runnable `.rye`. |
| lower | [`lower_face.rye`](../../../glow/lower_face.rye) | 1844 | yes | lower_face.rye -- lower a parsed `=/` face binding to runnable `.rye`. |
| lower | [`lower_face_lit.rye`](../../../glow/lower_face_lit.rye) | 154 | yes | lower_face_lit.rye -- emit Zig bytes from face=lit samples (STOA220). |
| lower | [`lower_list.rye`](../../../glow/lower_list.rye) | 91 | yes | lower_list.rye -- lower a parsed `:~` list cell to runnable `.rye`. |
| lower | [`lower_multi.rye`](../../../glow/lower_multi.rye) | 163 | yes | lower_multi.rye -- lower a multi-line Glow desk to one `.rye` main. |
| lower | [`lower_multi_typed.rye`](../../../glow/lower_multi_typed.rye) | 163 | yes | lower_multi_typed.rye -- multi-line typed `=/` desks to one `.rye`. |
| lower | [`lower_mutate.rye`](../../../glow/lower_mutate.rye) | 74 | yes | lower_mutate.rye -- lower a parsed `=.` mutate to runnable `.rye`. |
| lower | [`lower_named_cast.rye`](../../../glow/lower_named_cast.rye) | 670 | yes | lower_named_cast.rye -- resolve `^-  <name>` against a `+$` mold. |
| lower | [`lower_null.rye`](../../../glow/lower_null.rye) | 531 | yes | lower_null.rye -- lower a parsed `?~` null-test to runnable `.rye`. |
| lower | [`lower_quad.rye`](../../../glow/lower_quad.rye) | 131 | yes | lower_quad.rye -- lower a parsed `:^` quad cell to runnable `.rye`. |
| lower | [`lower_shape.rye`](../../../glow/lower_shape.rye) | 490 | yes | lower_shape.rye -- lower a `+$` / `$:` / `$%` shape to runnable `.rye`. |
| lower | [`lower_switch.rye`](../../../glow/lower_switch.rye) | 525 | yes | lower_switch.rye -- lower a parsed `?-` subject to runnable `.rye`. |
| lower | [`lower_trap.rye`](../../../glow/lower_trap.rye) | 128 | yes | lower_trap.rye -- lower a parsed `|-` bound to runnable `.rye` text. |
| lower | [`lower_triple.rye`](../../../glow/lower_triple.rye) | 115 | yes | lower_triple.rye -- lower a parsed `:+` triple cell to runnable `.rye`. |
| core | [`nest_type.rye`](../../../glow/nest_type.rye) | 341 | yes | nest_type.rye -- nest/type surface (STOA107-110 - STOA118-130 - STOA148-160 - STOA328). |
| rune | [`rune_alias.rye`](../../../glow/rune_alias.rye) | 61 | yes | rune_alias.rye -- parses Glow's `=*` alias (no-copy) rune head. |
| rune | [`rune_assert.rye`](../../../glow/rune_assert.rye) | 118 | -- | rune_assert.rye -- parses Glow `?>` / `?<` assertion rune heads (STOA88). |
| rune | [`rune_barket.rye`](../../../glow/rune_barket.rye) | 239 | yes | rune_barket.rye -- parses Glow's `|^` barket (STOA112-120). |
| rune | [`rune_bartis.rye`](../../../glow/rune_bartis.rye) | 252 | -- | rune_bartis.rye -- parses Glow's `|=` bartis gate rune (STOA100-109 - STOA120). |
| rune | [`rune_bounded_trap.rye`](../../../glow/rune_bounded_trap.rye) | 125 | yes | rune_bounded_trap.rye -- parses Glow's bounded `|-` rune, for real. |
| rune | [`rune_call.rye`](../../../glow/rune_call.rye) | 81 | yes | rune_call.rye -- parses Glow's `%-` one-argument call rune head. |
| rune | [`rune_call2.rye`](../../../glow/rune_call2.rye) | 94 | yes | rune_call2.rye -- parses Glow's `%+` two-argument call rune head. |
| rune | [`rune_call3.rye`](../../../glow/rune_call3.rye) | 107 | yes | rune_call3.rye -- parses Glow's `%^` three-argument call rune head. |
| rune | [`rune_calln.rye`](../../../glow/rune_calln.rye) | 91 | yes | rune_calln.rye -- parses Glow's `%*` named-argument call rune head. |
| rune | [`rune_cast.rye`](../../../glow/rune_cast.rye) | 76 | yes | rune_cast.rye -- parses Glow's `^-` cast rune, for real. |
| rune | [`rune_cell.rye`](../../../glow/rune_cell.rye) | 72 | yes | rune_cell.rye -- parses Glow's `:-` pair-cell rune head. |
| rune | [`rune_conditional.rye`](../../../glow/rune_conditional.rye) | 83 | yes | rune_conditional.rye -- parses Glow's `?:` if/then/else rune head. |
| rune | [`rune_core.rye`](../../../glow/rune_core.rye) | 242 | yes | rune_core.rye -- parses Glow's thin `|%` ... `++` ... `--` core. |
| rune | [`rune_face.rye`](../../../glow/rune_face.rye) | 102 | yes | rune_face.rye -- parses Glow's `=/` typed-let (face binding) rune head. |
| rune | [`rune_list.rye`](../../../glow/rune_list.rye) | 74 | yes | rune_list.rye -- parses Glow's `:~` list-cell rune head. |
| rune | [`rune_mutate.rye`](../../../glow/rune_mutate.rye) | 81 | yes | rune_mutate.rye -- parses Glow's `=.` mutate-one-leg rune head. |
| rune | [`rune_null.rye`](../../../glow/rune_null.rye) | 82 | yes | rune_null.rye -- parses Glow's `?~` null-test rune head. |
| rune | [`rune_quad.rye`](../../../glow/rune_quad.rye) | 104 | yes | rune_quad.rye -- parses Glow's `:^` quad-cell rune head. |
| rune | [`rune_shape.rye`](../../../glow/rune_shape.rye) | 446 | yes | rune_shape.rye -- parses Glow's `+$` / `$:` / `$%` shape (STOA74-80). |
| rune | [`rune_switch.rye`](../../../glow/rune_switch.rye) | 87 | yes | rune_switch.rye -- parses Glow's `?-` exhaustive-switch rune head. |
| rune | [`rune_triple.rye`](../../../glow/rune_triple.rye) | 94 | yes | rune_triple.rye -- parses Glow's `:+` triple-cell rune head. |
| core | [`tally_copy.rye`](../../../glow/tally_copy.rye) | 73 | -- | tally/copy.rye -- the disjoint copy, with its preconditions written down. |
| core | [`text_floor.rye`](../../../glow/text_floor.rye) | 43 | yes | text_floor.rye -- bounded string buffers and named overflow errors. |
| core | [`tokens.rye`](../../../glow/tokens.rye) | 507 | yes | tokens.rye -- bounded shared Glow token stream (STOA83-86 - STOA93). |
| core | [`truth_semantics.rye`](../../../glow/truth_semantics.rye) | 39 | yes | truth_semantics.rye -- Glow ambient truth vs Nock loobean seam. |

**Totals:** 62 modules (21 rune - 32 lower - 9 core) - witness twins on 57.

---

Regenerate: run the census script in the workshop log (round 1) against a clean tree; the nib in the Status line must match the tree the rows were read from.
