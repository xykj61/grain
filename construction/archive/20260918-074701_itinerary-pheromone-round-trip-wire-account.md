# Shelved account -- pheromone, `comlink/discovery/round_trip_wire.rye` closes a third named zero-assert file

**Status:** Historical -- shelved from `construction/ITINERARY.md` on `20260918.074701` under
[`the-writer-sheds`](../../.claude/rules/the-writer-sheds.md).

`comlink/discovery/round_trip_wire.rye` CLOSES A THIRD NAMED ZERO-ASSERT FILE. Elder account
[shelved whole](20260918-071100_itinerary-pheromone-descriptor-test-account.md): the
`descriptor_test.rye` lap. This lap stayed in pheromone's own comlink lane: three bare postcondition
asserts across `table_digest`, `write_intro`, and `read_intro` -- an ordering invariant tying the
post-swap `ids` pair to ascending order (so the digest is order-independent), a buffer-bound
invariant tying `write_intro`'s final `off` to `buf.len`, and a truncation invariant in `read_intro`
tying the post-increment `off` to the earlier `IntroTrunc` check that already proves the signature
fits -- each a new invariant statement rather than a duplicate of an existing if/return-error check.
`env RYE_ZIG=vendor/zig-toolchain/zig rye/bin/rye build comlink/discovery/round_trip_wire.rye -lc
-femit-bin=comlink/.build/discovery_round_trip_wire` then
`rishi/bin/rishi run tools/d/discovery_round_trip_wire.rish` GREEN unchanged (peers=2, both-sides,
fold parity, refusals loud); `width-check` clean; `tame_style_check`'s zero-assert ratchet fell 12
to 11. Claim `pheromone-round-trip-wire-asserts` opened, pushed, and closed per the ABSENCE clause
across one rebase (a peer's `%401` follow-up landed the same window). The remaining 11
`tame_style_check` zero-assert files at the time were `ember/ember_core.rye`,
`lantern/lantern_core.rye`, `linengrow/glow_seva_b0_fold.rye`, `linengrow/setu65_lab_tx_check.rye`,
`linengrow/setu6_device_lab_check.rye`, `linengrow/setu_desk_hold0_check.rye`,
`linengrow/setu_desk_hold1_check.rye`, `linengrow/setu_desk_hold_wayland_check.rye`,
`mycelium/puddle_convergence.rye`, `scribble/scribble_core.rye`, `tally/pedersen.rye`.
