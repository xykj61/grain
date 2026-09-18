# GRASS -- comlink/turn_route.rye gains five asserts across its three functions (shelved)

**Shelved:** `20260918.070909` -- the writer sheds its own predecessor account
(`.claude/rules/the-writer-sheds.md`) to make room for the next live block.

---

**GRASS -- `comlink/turn_route.rye` GAINS FIVE ASSERTS ACROSS ITS THREE FUNCTIONS.** Elder account
[shelved whole](20260918-064716_itinerary-grass-nock-jet-dec-shed.md). This lap:
`turn_newer` gained an antisymmetry postcondition (strict newness never holds in both directions
at once, split from a compound assert per `tame_style_check`'s ban); `freshest` gained a
returned-pointer-is-one-of-the-two postcondition; `read_turn` gained a never-accepted-on-refusal
postcondition and a key-never-rolls-back postcondition on its stale-kept branch. Five bare
`assert()` calls total; `assert` already imported. Witness GREEN unchanged
(`comlink_turn_route_witness`); `tame_style_check` confirms the file carries no zero-assert entry,
ratchet fell 15 to 14 (pheromone's `bolt_apply_step.rye` lap took it 16 to 15 first this same
round); `width-check` clean. Claim `grass-turn-route-asserts` opened, pushed, and closed per the
ABSENCE clause.
