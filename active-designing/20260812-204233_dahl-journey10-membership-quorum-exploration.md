# DAHL Journey 10 — Membership, the quorum surface (exploration)

**Stamp:** `20260812.204233` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — opens Journey 10 of Season 3 (Commons) in the 1,024-round itinerary
**Waymark:** **DAHL** (Harvest Equinox 3 — Commons, already seated; each journey is `DAHL-J<N>`)
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md) · [`20260812-201611_dahl-journey9-skate-consent-first-exploration.md`](20260812-201611_dahl-journey9-skate-consent-first-exploration.md) · [`../settlement/names.rye`](../settlement/names.rye) · [`../pond/apps/skate_circle.rye`](../pond/apps/skate_circle.rye) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## Where the road stands

Season 3, Commons, Journey 9 (Skate) stands complete end to end — two keepers come to *see* each other only by mutual consent, the whole arc signed, travelled as Bron, and read true on a real fixture. Journey 9 answered how **exactly two** keepers meet. The 1,024-round itinerary's next Lindy-first crux on the whole road is **Journey 10 — Membership**: the one surface that genuinely needs **quorum**, proven at **more than two keepers**, extending the consensus idea `settlement/names.rye` already names.

This is a new domain, so the itinerary's filling law asks for a design read before the first round — this document.

## The durable promise this journey turns on

`settlement/names.rye` says it plainly in its own header: *"Names are the one surface that genuinely needs consensus."* A point's keys and custody are its owner's own business; a **name**, or a **group**, must be agreed by more than one hand. Journey 9's mutual link was consensus at its smallest size — two keepers, each opting in. Journey 10 draws the next size up, the load-bearing one: **a decision that needs a named threshold of keepers, not one and not necessarily all.** Everything a commons later builds — council skies, quorum votes, shared naming — rests on getting quorum right, so this is the crux, and it is Lindy-durable: the quorum rule is read for as long as the commons lives.

## The crux — quorum, not one hand and not unanimity

Journey 9's link placed when **both** of two keepers asked; the number two was baked into the rule. A group is different: a member is admitted when a **quorum** — a named threshold `t` of the group's current members — consents, where `t` is at least two (genuine consensus, more than one hand) and at most the whole roster. The honest heart:

- **refuse** — the resting state. No member has voted for a candidate; a stranger is admitted by nobody's default.
- **hold** — some members have voted, yet fewer than the quorum. A below-quorum tally is a standing intention, never an admission.
- **place (admitted)** — `t` **distinct** members have voted for the candidate; only then is the candidate seated.

The crux is the distinctness and the threshold together: **one keeper can never manufacture a quorum.** A member who votes twice for the same candidate is counted once (`AlreadyVoted`), so a lone steward cannot inflate a tally to the threshold; admission is *derived* from the count of distinct member votes reaching `t`, never written directly, exactly as Journey 9 derived a link from two opposing requests rather than storing it. This is what "the surface that needs quorum" means: a seat exists only when the named number of distinct hands agreed.

## Why this shape, against the alternatives

- **Not the mutual-only link.** Two-keeper mutual consent (J9) is quorum with `t = 2` and `n = 2` hardwired. A group generalizes both numbers: `t` distinct votes among a roster of `n`. Reusing J9's `Circle` would force the number two into a rule that must hold at three, five, nine — so Membership earns its own module rather than bending Skate's link.
- **Not one-owner naming.** `settlement/names.rye` binds one name to one point by that point's own signature — custody by a single hand, the right shape for a name a keeper owns alone. A group is owned by no single hand; its admissions are the shared decision names.rye's header points at but leaves to a later surface. This journey is that surface.
- **Not unanimity.** Requiring *every* member to consent would let a single hold-out veto the commons forever — brittle, not durable. A named threshold below the whole is the resilient law a real council runs on.
- **Not signed yet, at r1.** Round one fixes the *rule* as a pure bounded state machine — quorum as a count of distinct explicit votes, refusing dishonesty — exactly as `skate_circle` r1, `entity_books` r1, and `commerce_trade` r1 fixed their laws before signing. Signing is r2's crux, mirroring `skate_circle_signed` / `commerce_trade_signed`.

## The four rounds (Lindy-first, crux-first)

- **r1 — Quorum.** `pond/apps/skate_group.rye`: a `Group` opens with a founder roster and a fixed quorum `t` (`2 ≤ t ≤ roster`); a member votes for a candidate; the candidate is seated only when `t` **distinct** members have voted. Pure state machine, bounded. Refusals: a non-member votes (`NotMember`), a member votes twice for one candidate (`AlreadyVoted`), a candidate already seated (`AlreadyMember`), a quorum below two or above the founders (`BadThreshold` / `TooFewFounders`), a duplicate founder (`DuplicateFounder`), a full roster (`GroupFull`), a full vote book (`VotesFull`). The crux made checkable: a single member voting twice never reaches a quorum of two; three distinct votes are needed to admit under `t = 3`; admission is derived from the distinct-vote count, never written.
- **r2 — Signed.** `pond/apps/skate_group_signed.rye`: each vote is signed by that member's settled Kumara identity over the exact facts (a tag, the group id, the voter point, the candidate point), verified against a caller-supplied keyring, mirroring `skate_circle_signed`. A steward cannot fabricate a member's vote; relabel a vote's candidate after signing and the signature falls.
- **r3 — Travels.** `pond/apps/skate_group_bron.rye`: render a group's roster, quorum, and signed votes to a `format skate-group-v1` Bron record and parse it back byte-for-byte, still quorum-honest offline (a vote signature flipped after the crossing refuses); unknown/missing field · bad header · bad hex each refuse.
- **r4 — Read-true.** `pond/apps/skate_group_true.rye`: carry the reader onto a real fixture (`skate/fixtures/group.bron`, real Ed25519 vote signatures) and cross-check the roster size, vote count, and **admitted-by-quorum count** against an independent measure (an awk truth script) — two tools, one answer — so a group's membership can never drift from what a keeper can count by hand.

## Boundaries (custody-first)

Membership records the *facts* of quorum and holds nothing — it opens no network, moves no funds, and generates no real identity. The Comlink-served rung (a group shared over the wire) reaches the serve custody gate and is the maintainer's hand; demo keeper seeds only, never a real Kumara instance (gate #4). Everything above — the pure rule, signing over demo seeds, Bron travel, reading a real fixture — is agent-doable and does not wait.

---

*May the commons admit by counting true hands, never by one hand counted twice; and may the threshold it agrees on hold every keeper it names and no keeper it does not.*
