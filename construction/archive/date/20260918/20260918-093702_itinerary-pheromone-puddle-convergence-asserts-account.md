# Shelved account -- `mycelium/puddle_convergence.rye` closes a fourth named zero-assert file

**Shelved from `construction/ITINERARY.md`:** `20260918.093702`, walk-back `add80ec902`.

**PHEROMONE -- `mycelium/puddle_convergence.rye` CLOSES A FOURTH NAMED ZERO-ASSERT FILE.** Elder
account [shelved
whole](20260918-074701_itinerary-pheromone-round-trip-wire-account.md): the
`round_trip_wire.rye` lap. Two named-invariant asserts landed: `host_key` now asserts its returned
byte slice is exactly `puddle.pk_len` long before any caller compares it (the invariant every
`berth_pk` byte-comparison in this file already relies on), and Scene 1's crux tally now asserts
`moved + stayed == ids.len` right before the crux checks read `moved` -- every world is accounted
for exactly once, so a silently-dropped world could never hide inside a passing `moved != best_load`
check. `rishi/bin/rishi run tools/m/mycelium_puddle_convergence_witness.rish` GREEN unchanged;
`width-check` clean; `tame_style_check`'s zero-assert ratchet fell 11 to 10. Claim
`pheromone-puddle-convergence-asserts` opened, pushed, and closed per the ABSENCE clause.
**Corrected below by Grass:** `linengrow/setu6_device_lab_check.rye` and `scribble/scribble_core.rye`
had already closed or closed since this list was written. `tally/pedersen.rye` is now exempt as a
pure re-export shim (`tools/t/tame_style_scan_advise.rish` za9, mirrored in the legacy shell twin) --
every exported symbol is a one-line delegation to `tally/bud.rye`, which already asserts every
invariant the shim could name. **7** `tame_style_check` zero-assert files remain,
`ember/ember_core.rye`, `lantern/lantern_core.rye`, `linengrow/glow_seva_b0_fold.rye`,
`linengrow/setu65_lab_tx_check.rye`, `linengrow/setu_desk_hold0_check.rye`,
`linengrow/setu_desk_hold1_check.rye`, `linengrow/setu_desk_hold_wayland_check.rye` -- all outside
pheromone's own lane now, each its own honest scope to check before claiming.
