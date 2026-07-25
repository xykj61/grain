# Glow, Neth, and the Urbit Fleet — Graduated Trust Meets the Sponsorship Hierarchy

**Language:** EN
**Version:** `20260715.165500` (Pacific)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Status:** Research for understanding — study → design, siloed. Register: design (Two Rooms — proposal, not bound claim). Sources on urbit.org studied and thanked below; no code copied; every idea re-expressed in our own vocabulary. Addressed to a generic Acme Corporation employee.
**Companion:** `../external-research/20260714-041542_ironbeetle-patterns-for-the-neth-ladder.md` (Neth's graduated-trust ladder, now landed and green, which this reconciliation builds on)

---

## What This Answers

Whether Glow and Neth reconcile with Urbit's own **fleet** idea, studied directly from the code and documentation on urbit.org. The short finding: they reconcile tightly at the trust layer — a fleet's sponsor/sponsee relation is the same shape as Neth's monarch/follower relation, and Neth's two-posture root install already encodes the graduated trust a sponsorship hierarchy implies. One honest divergence sits underneath the parallel, named plainly rather than smoothed over.

## What "Fleet" Means on urbit.org

Two related senses, drawn from the documentation and the `%fleet` agent source:

1. **`%fleet`, the monitoring agent** — a userspace app a sponsor runs to watch its sponsees. It collects the sponsored-ship set from **Jael** (Urbit's identity/PKI vane), checks each ship's uptime on a **Behn** timer, and notifies steward ships when a heartbeat exceeds a threshold. A star watches its planets, a galaxy its stars, a planet its moons.

2. **The sponsorship hierarchy itself** — galaxy → star → planet → moon, the address-space ranks recorded on the Azimuth smart contract. The documentation is emphatic that Urbit keeps this **deliberately lightweight**: sponsorship means the sponsor distributes software updates and aids peer discovery, and whether that chain implies any *endorsement of trustworthiness* is, in the docs' own framing, entirely implicit. No shared consensus, no settled ledger of status — by design.

## The Reconciliation at the Trust Layer

The parallel is genuinely tight, and it is a parallel this fork's own landed work already fits. A fleet's sponsor is authoritative about its own sponsee set, and a sponsee's account of that set, learned from a peer, deserves verification — which is precisely **Neth's two-posture root install** (landed and green):

- A sponsor is **authoritative-at-source** about its own current view — Neth's `install_at_source`, the issuing monarch's root trusted outright, no chain-of-proof demanded.
- A peer's account, arriving by repair, is **verified-on-repair** — Neth's `install_on_repair`, admitted only if it hash-chains onto what is already held.
- A committed membership fact is **never truncated** — Neth's shared `RootTruncated` rule.

So Neth is the settlement engine a Glow fleet would run *on*. Where Urbit's `%fleet` observes uptime and fires notifications, a Glow fleet's membership, sponsorship changes, and last-contact facts become **signed facts folded to a shared root** every member reproduces identically. Witness-before-truth applied to a fleet: a ship is "up" because a signed contact fact within threshold exists and folds, never because a monitor guessed.

## Where Each Piece Lands in the Glow Vane Family

- **Rhyz** — the identity vane reviving Azimuth's point/planet/star tiers — plays Jael's role: it holds the sponsee set a fleet monitor reads. `%fleet` asks Jael; a Glow fleet asks Rhyz.
- **Neth** provides the replicated, settled status ledger — the piece Urbit's `%fleet` has no equivalent for.
- **Pool** (the application/Gall-role vane) hosts the fleet-monitor app itself.
- **Comlink** (Ames's role) carries the heartbeat facts over the same real sealed hop Neth's carriage lap just proved.
- A Behn-equivalent timer drives the heartbeat interval; Neth's own seeded-simulation ticks are its deterministic cousin.

A Glow fleet lap is therefore a **composition**, not a new vane: Rhyz (membership) × Neth (settled status) × Pool (the app) × Comlink (carriage). This is the same compose-don't-name instinct that shaped Pool and the sandbox loop.

## The One Honest Divergence

Urbit *chose* to keep sponsorship thin — no consensus in the fleet, endorsement left implicit — because heavy shared state at the sponsorship layer is a cost it declined. Layering Neth under a fleet **adds a settlement dimension Urbit deliberately omits**. That is a real design fork, not merely a parallel: a Glow fleet would be a heavier, more accountable object than Urbit's — a sponsor and its sponsees agreeing on a settled, replayable ledger of who-sponsors-whom and who-was-last-seen, rather than a monitor pinging into the dark.

Whether that weight is worth carrying depends on the use. For the civic and settlement work this tree already leans toward — sanctuary care logs, giving lanes, Open Asks — a fleet-as-settled-ledger is a natural fit. For general peer discovery, Urbit's lightweight instinct is likely right, and Glow should resist settling what does not need settling, honoring the same "do not order what does not need ordering" discipline the toll concept already names.

## What This Doc Does Not Claim

- No Glow fleet is built; this names a composable lap and the choice it hinges on, nothing seated.
- No claim that Urbit's maintainers want a heavier fleet — the divergence is Glow's own choice to make, gated behind Keaton's word.
- The `%fleet` and sponsorship facts are studied from urbit.org and re-expressed here; no Hoon is copied, per the clean-room discipline.

## With Gratitude

The fleet monitoring pattern (`%fleet` by `~midden-fabler`), the `%ahoy` ship-monitoring example, and the sponsorship-hierarchy and Azimuth-point documentation are studied here with gratitude to the Urbit Foundation's own docs at docs.urbit.org and urbit.org, and to the named community authors of the monitoring agents. Every concept is re-expressed in our own vocabulary; the understanding is ours to carry, and the sources are named here with warmth.

## Related

- `../external-research/20260714-041542_ironbeetle-patterns-for-the-neth-ladder.md` — Neth's graduated-trust ladder.
- `../external-research/20260714-044428_rhyz-r-vane-identity-reviving-kumara.md` — Rhyz reviving Azimuth's own tier words.

---

A fleet is a sponsorship hierarchy in motion, and graduated trust is the shape it already wants; Neth can settle what Urbit leaves implicit, wherever settling is worth its weight.
