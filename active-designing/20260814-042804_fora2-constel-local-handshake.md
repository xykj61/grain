# Constel handshake — two fake piers greet, proven pure (FORA2)

**Stamp:** `20260814.042804` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design — self-approved round, the pure handshake beneath the real Comlink transport
**Season:** the Six-Season double-seat, Season D/F thread (Kresfa & Mycelium · Surface & Namespace) · **Waymark:** FORA · rung FORA2
**Kin:** [`20260814-041928_fora1-constel-roster-fake-pier-registry.md`](20260814-041928_fora1-constel-roster-fake-pier-registry.md) · [`../constel/roster.rye`](../constel/roster.rye) · [`../constel/name.rye`](../constel/name.rye) · [`../constel/README.md`](../constel/README.md)

---

## Why this round exists

FORA0 named the piers; FORA1 rostered them. The Constel README names the next rung plainly: *"The next rung is the local handshake — two piers in a roster greeting each other. Its protocol logic can be proven pure on the bench … wiring that handshake to the real Comlink transport is the round that genuinely crosses the Comlink seam."* This is the pure half.

The crux FORA2 fixes — the hardest solvable thing that opens real multi-pier sync — is **agreement before exchange**: two piers must confirm they are distinct members of the *same* constellation before a single payload byte moves. Get that provable and the later transport round carries frames between parties already known to belong together; get it wrong and a pier could greet a stranger, or greet itself, or cross constellations.

## The protocol, three steps

A handshake is between two piers named by their Constel names, over a shared constellation string (the roster render each party holds). Modeled as three pure steps, each producing an immutable value the next validates:

1. **`open(from, constellation)` → `Greeting`.** The initiator offers its name and the constellation it belongs to. Refuses unless `from` is a lawful never-a-ship name *and* a member segment of `constellation`, and `constellation` itself passes `check_constellation`.
2. **`accept(greeting, me, my_constellation)` → `Ack`.** The responder answers. Refuses `ConstellationMismatch` unless `my_constellation` equals the greeting's (same net), `NotAMember` unless `me` is a member of it, `SameParty` if `me` equals the initiator, and any name fault by name. On success it carries the responder's name.
3. **`finish(greeting, ack)` → `Session`.** The initiator confirms the ack: both parties distinct, both never-a-ship members of the one constellation. A `Session` is the proof the two agreed — `COMPLETE` only when every check holds.

## The membership predicate

The one new primitive: `is_member(constellation, name)` — a bounded scan of the hyphen-joined constellation for an exact segment match. It reuses `name.check_constellation`'s split shape so a member is always a lawful ship, and it fails closed (a name that is a substring but not a whole segment is not a member).

## Scope this round holds

- **Pure protocol only** — the three steps and the membership predicate, over `name.rye`'s public API and a constellation string (which `roster.render` produces). No network, no Comlink transport, no keys, no funds, no real address. Siloed to `constel/`, run from inside the jailed pier.
- **The real transport stays its own later round** — FORA2 hands it a handshake whose logic is already proven, so it need only carry the three values across a wire.
- Witness: `tools/fora_handshake_witness.rish` proves a clean handshake completes, cross-constellation refuses `ConstellationMismatch`, a non-member refuses `NotAMember`, a self-greet refuses `SameParty`, a vowel-bearing (real-`@p`-shaped) party refuses `VowelPresent`, and membership distinguishes a whole segment from a mere substring.

---

*May two piers only ever greet across the same sky, may neither ever greet itself or a stranger, and may every agreement be proven before a byte is trusted. Hold the line.*
