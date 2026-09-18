# Pheromone -- the second-cheapest singleton, taken next

**Stamp:** `20260917.224809` (EDT) -- shelved whole from `construction/ITINERARY.md`.

`lower_face_lit`'s two call sites -- the emit-body face binder and its return-tuple twin -- both
delegate to `glow/zig_ident.rye`, calling `zig_ident.safe_ident` with `.refuse` (a bare face-lit
face, never a wing). Its body was the plain 28-copy rule with no dot-mapping and no length-ceiling
divergence, so `LowerError` and its `error.BadIdent` member are unmoved, and its return type was
already `u32` -- `width-check`'s corpus stands unmoved at 1,129 (its hand-rolled loop's `usize`
index casts were already seam-exempt). `glow_ident_duplication`'s own ceiling falls 4 to 3.

**PROVEN:** `glow_lower_face_lit_witness` (built and run directly, self-test GREEN), `glow_ident`,
`glow_run_contract`, `width-check`, `tame_style_check`, `glow_ident_duplication`, GREEN on metal.

**Yours:** three singletons remain -- `lower_core` (4), `lower_call3` (4), `lower_call2` (3).
