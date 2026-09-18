# Pheromone -- the genuinely different rule, taken last of the five

**Stamp:** `20260917.224500` (EDT) -- shelved whole from `construction/ITINERARY.md`.

`lower_shop_nest`'s two call sites -- the welcome path and the argv path -- both delegate to
`glow/zig_ident.rye`, calling `zig_ident.safe_ident` with `.refuse` (a bare barket face, never a
wing). Its body was the one the seating ladder had already named as genuinely different: the elder
rule answered a LENGTH ceiling and a bad character both with `error.MissingFace`, where every other
copy in the room answered `error.BadIdent`. `LowerError` therefore gains the `error.BadIdent`
member the module never carried before, and its return type was already `u32` -- `width-check`'s
corpus stands unmoved at 1,129. `glow_ident_duplication`'s own ceiling falls 5 to 4.

**PROVEN:** `glow_lower_shop_nest_witness` (built and run directly, 884-line self-test, GREEN),
`glow_ident`, `glow_run_contract`, `width-check`, `tame_style_check`,
`glow_ident_duplication` (control 17 legs, 0 failing), GREEN on metal.

**Yours:** four singletons remain -- `lower_core` (4), `lower_call3` (4), `lower_call2` (3),
`lower_face_lit` (2).
