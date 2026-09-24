# Pheromone -- the third-cheapest singleton, taken next

**Stamp:** `20260917.230329` (EDT) -- shelved whole from `construction/ITINERARY.md`.

`lower_call2`'s three call sites -- gate, `a`, `b` -- all delegate to `glow/zig_ident.rye`,
calling `zig_ident.safe_ident` with `.refuse` and each naming its own field, matching the
`lower_call.rye` sibling's own wrapper shape (one-arg call beside two-arg call). Its body was the
plain 28-copy rule with no dot-mapping and no length-ceiling divergence; its return type moved
`usize` to `u32` in the same commit, the last of the room's own copies still returning it --
`width-check`'s corpus falls 1,129 to 1,127 across one fewer flagged file (276 to 275).
`glow_ident_duplication`'s own ceiling falls 3 to 2.

**PROVEN:** `glow_lower_call2_witness` (build, self-test, welcome/unwelcome binaries all GREEN),
`glow_ident`, `glow_run_contract`, `width-check`, `tame_style_check`, `glow_ident_duplication`,
GREEN on metal. The width-check fall was tasted rather than assumed: stashed the edit and
re-ran the scan, confirming 1,129 pre-edit before trusting the 1,127 reading.

**Yours:** two singletons remain -- `lower_core` (4), `lower_call3` (4).
