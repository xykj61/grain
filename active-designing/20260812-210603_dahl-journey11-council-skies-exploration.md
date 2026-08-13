# DAHL Journey 11 — Council skies, the loadable topology (exploration)

**Stamp:** `20260812.210603` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — opens Journey 11 of Season 3 (Commons) in the 1,024-round itinerary
**Waymark:** **DAHL** (Harvest Equinox 3 — Commons, already seated; each journey is `DAHL-J<N>`)
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260812-204233_dahl-journey10-membership-quorum-exploration.md`](20260812-204233_dahl-journey10-membership-quorum-exploration.md) · [`20260809-234413_loadable-topologies-and-pond-silo-brief.md`](20260809-234413_loadable-topologies-and-pond-silo-brief.md) · [`../comlink/topology.rye`](../comlink/topology.rye) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the road stands

Season 3, Commons, Journey 10 (Membership) stands complete end to end — a group seats a candidate only when a **named threshold** `t` of distinct members votes, the whole arc signed, travelled as Bron, and read true on a real fixture. Journey 10 answered *quorum at a threshold a caller chooses*, over a flat roster. The 1,024-round itinerary's next Lindy-first crux on the whole road is **Journey 11 — Council skies**: the community does not merely pick a threshold, it **loads a whole shape** — a *sky* — the way a console loads a game, and the sky's own odd fractal *gives* the council its tie-free quorum and its roles.

This is a new domain, so the itinerary's filling law asks for a design read before the first round — this document.

## The durable promise this journey turns on

The loadable-topologies brief carries the whole insight in one line: *"the shape of a constellation is data, not law."* `comlink/topology.rye` already proves it — the `Sky` struct lifts the geometry out of hardcoded constants, and two skies sit side by side: the civic **`compass_sky`** (12·5·12, a d60) and the **`council_sky`** (15·3·9, a d27). What no rung has yet built is the **council** those skies were named for: a deliberating body whose size, whose quorum, and whose roles all read straight off the loaded sky. That is Lindy-durable — a council's rule is read for as long as the commons meets, and it is the surface every later civic act (a shared naming, a proposal, a rite) stands on.

## The crux — an odd sky gives a tie-free quorum and a complete triad

Journey 10's quorum was a number a caller supplied; nothing in the rule *cared* whether it was odd or even, and a group of an even size could split its votes evenly with no forced answer. A council is different: it loads a sky, and it seats a body at one of the sky's own **fractal levels**. The council sky's levels are its four counts — `stars` **3**, `planets` **9**, `galaxies` **15**, `prosperity` **27** — the odd-quorum fractal **3 · 9 · 15 · 27**, every one of them odd. The honest heart:

- **A council seats only at an odd fractal level of its sky.** The quorum is the strict majority of that odd body — `size / 2 + 1`. Because the body is **odd**, yes-votes and no-votes can never tie: once every seat has voted, one side always holds the majority, so a proposal is never left forever undecided. This is what "the quorum, asserted odd, so every vote clears without a tie-breaker" means, made a checkable law.
- **The civic sky is not a council sky.** `compass_sky`'s prosperity is **60** — even — so a council cannot seat its d60 as a deliberating body without risking a tie. The odd fractal is exactly why `council_sky` exists beside it; the rule refuses an even level (`EvenCouncil`) rather than seat a body that could deadlock.
- **Every seat wears a modality role, and a triad is complete.** Each seat's **mode** — one of **initiator · sustainer · adapter** — is derived from its position (`seat mod 3`), so any three consecutive seats hold one of each: odd *and* complete, one to open, one to hold, one to bridge (the brief's role tilak, drawn here as the seat's own worn role). The typing is a pure function of the seat, so it can never drift from the body the sky seated.

The crux is the **odd fractal and the derived roles together**: a community that loads a council sky gets a body that always decides and a triad that is always whole, neither chosen by a steward's hand — both *read off the loaded shape*.

## Why this shape, against the alternatives

- **Not Journey 10's flat group.** J10's `Group` took any `t` over any roster; it is the general quorum machine, and it stays. A council is the *loaded* specialization — its size and quorum are not passed in, they are computed from a sky's odd fractal — so Membership earns the threshold and Council earns the shape. Reusing `Group` would lose the sky, which is the whole point of this journey.
- **Not a new topology.** `comlink/topology.rye` already holds `Sky`, `council_sky`, and the fractal counts, witnessed round-tripping. This journey *composes over* that ground; it invents no geometry, only the deliberating body that reads it.
- **Not even quorums.** An even body can split evenly and stall; requiring an odd level is the resilient law a real council runs on, and it is why the odd fractal was drawn. The rule refuses an even level rather than pretend a tie-breaker exists.
- **Not signed yet, at r1.** Round one fixes the *rule* as a pure bounded state machine — a council loaded from a sky, an odd quorum that never ties, modality roles derived from seats — exactly as `skate_group` r1 and `commerce_trade` r1 fixed their laws before signing. Signing is r2's crux, mirroring `skate_group_signed`.

## The four rounds (Lindy-first, crux-first)

- **r1 — Council loads a sky; the odd quorum never ties.** `pond/apps/council_sky.rye`: a `Council` loads a `Sky` and seats a body at one of the sky's own fractal levels (`galaxies · stars · planets · prosperity`), refusing any level not the sky's (`NotAFractalLevel`) and any even level (`EvenCouncil`). Its quorum is the strict majority of the odd body; a member votes yes or no on a proposal; the proposal **passes** at a quorum of yes, **fails** at a quorum of no, and because the body is odd the two can never tie. Each seat wears a modality role (`initiator · sustainer · adapter`) by `seat mod 3`; a triad holds one of each. The crux made checkable: `council_sky`'s four levels (3·9·15·27) all seat a council, `compass_sky`'s prosperity (60) refuses `EvenCouncil`, an even yes/no split on a size-3 council is impossible once all vote, and the three modes of a triad are distinct.
- **r2 — Signed.** `pond/apps/council_sky_signed.rye`: each vote is signed by that member's settled Kumara identity over the exact facts (a tag, the council id, the sky level, the voter point, the proposal, the yes/no), verified against a caller-supplied keyring, mirroring `skate_group_signed`. A steward cannot fabricate a member's vote; flip a vote's yes-to-no after signing and the signature falls.
- **r3 — Travels.** `pond/apps/council_sky_bron.rye`: render a council's sky level, roster, and signed votes to a `format council-sky-v1` Bron record and parse it back byte-for-byte, still tie-free and quorum-honest offline (a vote signature flipped after the crossing refuses); unknown/missing field · bad header · bad hex each refuse.
- **r4 — Read-true.** `pond/apps/council_sky_true.rye`: carry the reader onto a real fixture (`skate/fixtures/council.bron`, real Ed25519 vote signatures) and cross-check the roster size, vote count, and **decided-proposal count** against an independent measure (an awk truth script) — two tools, one answer — so a council's outcome can never drift from what a keeper can count by hand.

## Boundaries (custody-first)

Council records the *facts* of a loaded shape and its votes, and holds nothing — it opens no network, moves no funds, and generates no real identity. The Comlink-served rung (a council shared over the wire) reaches the serve custody gate and is the maintainer's hand; demo keeper seeds only, never a real Kumara instance (gate #4). Everything above — the pure rule, signing over demo seeds, Bron travel, reading a real fixture — is agent-doable and does not wait.

---

*May a community load the sky that fits its hour, decide by an odd count that never ties, and seat a triad always whole — one to open, one to hold, one to bridge.*
