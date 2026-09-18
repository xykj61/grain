# ITINERARY account -- the largest lap this room offered, taken whole

**Language:** EN
**Style:** Gauge, Meter setting
**Voice:** Kyri
**Status:** Shelf -- one landed account, immutable once written
**Room:** checkable -- proven on metal, witnesses named
**Folded:** `20260917.211803` from [`../ITINERARY.md`](../ITINERARY.md), to bring the card back
under its byte bound after the landing.

**AIR FEELS** (row 1, N=5496): law and boundary, felt by pressing. The sibling account left this
door named rather than opened -- the cheap `lower_multi` pair taken first, the `max_arm_len` three
left standing at 93 call sites together. This lap opens it.

**THE MECHANISM.** `glow/lower_conditional.rye`, `glow/lower_null.rye`, and `glow/lower_switch.rye`
each declared a hand-rolled `fn zig_safe_ident` byte-identical to the twenty-nine-times-copied body
`glow/zig_ident.rye` already names in its own header. All three now delegate to
`zig_ident.safe_ident` with `max_arm_len` as the ceiling, `.refuse` as the dot mode (none of the
three ever lowers a wing, only a bare arm face), and a module-named field
(`conditional-arm`, `null-arm`, `switch-arm`) for the refusal record. Each wrapper answers `u32`
now, matching the rule it delegates to, where it answered `usize` before.

**THE 93 CALL SITES NEEDED NO SIGNATURE CHANGE.** The field name is fixed inside each module's own
wrapper rather than threaded through 31 call sites apiece -- every call in one file lowers the same
kind of thing, so one field name serves all of them, exactly as `lower_multi`'s single call site
already established the idiom. What moved at each site was the seam: `const zn = try
zig_safe_ident(...)` (inferred `usize`, since the elder function answered `usize`) became `const
zn: usize = @intCast(try zig_safe_ident(...))` (an explicit `usize` local, cast once at the call,
per TAME's own seam rule) -- so every downstream `zb[0..zn]` slice, `MixEmitted` buffer, and
`bufPrint` call needed no touch at all. 93 lines changed; zero lines of lowering logic moved.

**THE WIDTH BILL FELL.** `width-check`'s `corpus_flagged_lines` reads **1133**, down from 1139 --
the three removed authored `usize` return types. `corpus_lines_ceiling` is lowered to `1133` in the
same commit; `corpus_files_ceiling` stands at 282 unmoved, since `corpus_flagged_files` held at 277
both before and after (a return-type edit, not a file gaining or losing its flag).

**THE DUPLICATION METER FELL WITH THEM.** `glow_ident_duplication_scan.sh`'s `copies` reads **8**,
down from 11; `stubs` reads **21**, up from 18. `CEILING` is lowered to `8` in the same commit, and
its own comment now names the `max_arm_len` three as landed rather than as the largest lap left.

**PROVEN.** `glow_lower_conditional_witness`, `glow_lower_null_witness`, `glow_lower_switch_witness`,
`glow_ident_witness`, `glow_run_contract_witness`, `width-check` (with its own control), `tame_style_check`,
`glow_ident_duplication_scan` beside its own `glow_ident_duplication_control` (17 legs,
`control_failed=0`), GREEN on metal, in that order, after the round-open's fast-forward pull settled
the tree at a fresh HEAD.

**YOURS:** the eight singletons `glow_ident_duplication_scan.sh` already names --
`lower_shop_gate` (12), `lower_core` (4), `lower_call3` (4), `lower_call2` (3), `lower_alias` (2),
`lower_face_lit` (2), `lower_shop_nest` (2), `lower_trap` (1) -- and `lower_alias` stays the one
body that is genuinely a different rule, wanting `Dot.to_underscore`.
