# Pheromone -- the cheapest singleton, taken alone

**Stamp:** `20260917.221033` (EDT) -- shelved whole from `construction/ITINERARY.md`.

`lower_trap`'s one call site delegates to `glow/zig_ident.rye`, its plain 28-body rule with no
dot-mapping and no length-ceiling divergence, return type moves `usize` to `u32` in the same
commit -- `width-check`'s corpus falls 1,131 to 1,129, `glow_ident_duplication`'s ceiling falls 6
to 5.

**PROVEN:** `glow_lower_trap`, `glow_ident`, `glow_run_contract`, `width-check`,
`tame_style_check`, `glow_ident_duplication`, GREEN on metal.

**Yours:** five singletons remain -- `lower_core` (4), `lower_call3` (4), `lower_call2` (3),
`lower_face_lit` (2), `lower_shop_nest` (2).
