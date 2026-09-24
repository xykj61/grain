# Shelved account -- PHEROMONE, `comlink/discovery/descriptor_test.rye` closes a named zero-assert file

**Shelved:** `20260918.071100` -- superseded by the next PHEROMONE account on
`construction/ITINERARY.md`, per [`the-writer-sheds`](../../../../.claude/rules/the-writer-sheds.md).

**PHEROMONE -- `comlink/discovery/descriptor_test.rye` CLOSES ANOTHER NAMED ZERO-ASSERT FILE.**
Elder account [shelved
whole](20260918-070100_itinerary-pheromone-bolt-apply-account.md): the
`bolt_apply_step.rye` lap. This lap moved into pheromone's own comlink lane: two bare postcondition
asserts on `main`'s `empty` and `ok` descriptors, tying `remaining()` to `descriptor_max_bytes -
len` and `as_slice().len` to `len` -- new invariant statements rather than duplicates of the
existing if/return-error checks. `env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye run
comlink/discovery/descriptor_test.rye` GREEN unchanged; `width-check` clean;
`tame_style_check`'s zero-assert ratchet fell 14 to 12 (this file plus incense's concurrent
`lower_cast.rye` landing). Claim `pheromone-descriptor-test-asserts` opened, pushed, and closed
per the ABSENCE clause across two rebases. **YOURS:** whether a body carries a parent hash at all
is convention, and Keaton's; the 12 remaining `tame_style_check` zero-assert files are
`comlink/discovery/round_trip_wire.rye` (pheromone's own lane, next), `ember/ember_core.rye`,
`lantern/lantern_core.rye`, `linengrow/glow_seva_b0_fold.rye`,
`linengrow/setu65_lab_tx_check.rye`, `linengrow/setu6_device_lab_check.rye`,
`linengrow/setu_desk_hold0_check.rye`, `linengrow/setu_desk_hold1_check.rye`,
`linengrow/setu_desk_hold_wayland_check.rye`, `mycelium/puddle_convergence.rye`,
`scribble/scribble_core.rye`, `tally/pedersen.rye` -- most outside pheromone's own lane, each its
own honest scope to check before claiming.
