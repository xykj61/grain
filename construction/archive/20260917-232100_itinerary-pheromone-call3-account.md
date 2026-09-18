# Pheromone -- the fourth singleton, taken next

**Stamp:** `20260917.232100` (EDT) -- shelved whole from `construction/ITINERARY.md`.

`lower_call3`'s four call sites -- gate, `a`, `b`, `c` -- all delegate to `glow/zig_ident.rye`,
calling `zig_ident.safe_ident` with `.refuse` and each naming its own field, matching the
`lower_call2.rye` sibling's own wrapper shape (three-arg call beside two-arg call). Its body was
the plain 28-copy rule with no dot-mapping and no length-ceiling divergence; its return type moved
`usize` to `u32` in the same commit -- `width-check`'s corpus falls 1,127 to 1,125 across one fewer
flagged file (275 to 274). `glow_ident_duplication`'s own ceiling falls 2 to 1.

**PROVEN:** `glow_lower_call3_witness` (build, self-test, welcome/unwelcome binaries all GREEN),
`glow_ident`, `glow_run_contract`, `width-check`, `tame_style_check`, `glow_ident_duplication`
(scan + 17-leg control), GREEN on metal. The width-check fall was tasted rather than assumed:
the scan's own `corpus_flagged_files=274` and `corpus_flagged_lines=1125` were read directly from
the post-edit tree before the ceiling was lowered to match.

**Yours:** one singleton remains -- `lower_core` (4).
