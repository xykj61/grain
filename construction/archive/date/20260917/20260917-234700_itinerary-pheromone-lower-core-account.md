# Pheromone -- the last singleton, and the room reaches zero copies

**Stamp:** `20260917.234700` (EDT) -- shelved whole from `construction/ITINERARY.md`.

`lower_core`'s four call sites -- the payload face in `emit_arm_methods` and in
`emit_payload_field`, and an arm name in `emit_arm_methods` and in `emit_checks` -- all delegate
to `glow/zig_ident.rye`, calling `zig_ident.safe_ident` with `.refuse` and each naming its own
field (`"payload"` or `"arm"`), matching the room's per-site convention. Its body was the plain
28-copy rule with no dot-mapping and no length-ceiling divergence; its return type moved `usize`
to `u32` in the same commit. `width-check`'s corpus held at 274 flagged files (the file carries
other seam locals past this one) and fell 1,125 to 1,123 lines; `corpus_lines_ceiling` lowered to
match. `glow_ident_duplication`'s own ceiling falls 1 to 0 -- **every copy this room ever carried
is now a stub reaching the one published rule.**

**PROVEN:** `glow_lower_core_witness`, `glow_lower_core_lib_witness` (both build, self-test,
welcome/unwelcome and library-emit binaries all GREEN), `glow_ident`, `glow_run_contract`,
`width-check`, `tame_style_check`, `glow_ident_duplication` (scan + 17-leg control,
`control_failed=0`), GREEN on metal.

**Yours:** the singleton ladder this room offered is finished. `glow/zig_ident.rye` is the one
Zig-identifier rule in the tree, every one of its 29 elder copies now a stub. The card's own open
`YOURS` questions further down -- the `th5` two-width-instrument disagreement and the Glow field
capacity ceiling -- still wait for your word.
