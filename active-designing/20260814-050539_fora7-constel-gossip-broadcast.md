# FORA7 — gossip: one frame reaches the whole constellation at once

**Stamp:** `20260814.050539` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design round (self-approved) — the next FORA rung, agent-doable, purely local
**Season:** the Six-Season double-seat, Season D/F thread · **Waymark:** FORA · rung **FORA7**
**Kin:** [`../constel/switchboard.rye`](../constel/switchboard.rye) · [`../constel/exchange.rye`](../constel/exchange.rye) · [`../constel/README.md`](../constel/README.md) · [`20260814-045802_fora6-constel-switchboard-multi-pier.md`](20260814-045802_fora6-constel-switchboard-multi-pier.md)

---

## The crux this round takes

FORA6 gave the constellation a switchboard: one pier speaks to **one** named other, a frame routed to a single mailbox. Yet the shape a real network leans on for a shared fact — a new member joining, a name claimed, a block proposed — is **one-to-many**: a pier announces something once and every *other* member hears it. FORA7 takes that one new concern and nothing more: **fan a single frame out to the whole constellation at once** — every other member's mailbox receives its own whole copy, the announcer's own mailbox stays empty, and the fan-out is bounded by the roster.

This is the primitive every gossip and flood protocol stands on, and it is the honest bridge from the point-to-point FORA ladder toward the constel consensus track already sketched (`pond/apps/constel_consensus*.rye`, a separate silo). It stays purely local — a bounded loop over the switchboard's mailboxes on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) both stay untouched.

## The broadcast

A single function over the FORA6 switchboard — no new value model, no new bound beyond the switchboard's own `max_piers` mailboxes.

```
broadcast(sb, from, frame) -> u32     deliver `frame` to every member EXCEPT `from`; return the count reached
```

`broadcast` refuses `NoSuchPier` if the announcer is not a member, then walks the roster and `deliver`s the frame's bytes to each *other* member's mailbox — never to the announcer's own. It returns how many piers were reached (`size - 1` on a clean fan-out), a bounded number the caller can assert against. Each recipient later reads its own copy with the switchboard's ordinary `receive`, so the two FORA3 trust gates (Sha256 + the naming-law border) still run per recipient at `wire.deframe_*` — a broadcast is many honest deliveries, never a shortcut around the border.

## What the witness proves

- **A broadcast reaches every other member exactly once** — in a constellation of four, an announce from one pier lands one whole frame in each of the other three mailboxes (`available() == frame.len` at each), and the count returned is three.
- **The announcer never hears its own broadcast** — the announcing pier's own mailbox stays empty (`available() == 0`) after the fan-out.
- **Each recipient reads its own whole copy** — every other member `receive`s exactly the announced frame, byte-for-byte, independently; one recipient reading does not consume another's copy.
- **A broadcast of two is a single delivery** — in a constellation of two, a broadcast reaches exactly one pier (the fan-out degenerates cleanly to point-to-point).
- **A stranger cannot broadcast** — an announce from a name no roster holds refuses `NoSuchPier` before any mailbox is touched (no partial fan-out).
- **The border still guards every copy** — a broadcast frame carrying a smuggled vowel (digest fixed up) is delivered to every mailbox, yet each recipient's `wire.deframe` still refuses `VowelPresent`; the fan-out routes, it never re-checks, so a real-`@p`-shaped name cannot enter the constellation even by announcement.

## Why this is the right next step

It is the smallest honest step from routing-to-one to routing-to-all, and one-to-many is the primitive every shared-fact protocol needs — a gossip round, a flood, a membership announcement, a consensus proposal all begin here. It stays inside the fence: a bounded loop, every delivery failing closed exactly as FORA6 proved, the border guarding each copy. And it hands the consensus track a fan-out already proven pure, so the round that builds a real gossip protocol builds on a primitive witnessed on metal rather than a new design under pressure.

---

*May one voice reach the whole sky at once, may the speaker never mistake its own echo for another's word, and may the border keep its watch over every copy. Hold the line.*
