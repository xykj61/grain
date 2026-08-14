# FORA6 — a switchboard: a whole local constellation, routed by name

**Stamp:** `20260814.045802` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design round (self-approved) — the next FORA rung, agent-doable, purely local
**Season:** the Six-Season double-seat, Season D/F thread · **Waymark:** FORA · rung **FORA6**
**Kin:** [`../constel/channel.rye`](../constel/channel.rye) · [`../constel/exchange.rye`](../constel/exchange.rye) · [`../constel/roster.rye`](../constel/roster.rye) · [`../constel/README.md`](../constel/README.md) · [`20260814-044915_fora5-constel-channel-byte-stream.md`](20260814-044915_fora5-constel-channel-byte-stream.md)

---

## The crux this round takes

Every rung so far has connected exactly **two** piers — one initiator, one responder, one pair of channels. Yet *Constel* is named for a **constellation**: many piers, standing up together on one bench. FORA1's roster already holds up to eight distinct fake piers; nothing yet lets three or more of them **meet through one shared medium**. FORA6 takes the one new concern that a real network of many piers forces and nothing before it did: **routing a frame to the right pier by name** — every pier holding its own mailbox, a delivery reaching exactly one of them, and a stranger's name refused before a byte moves.

This is still purely local. A `Switchboard` is a bounded set of per-pier inbound byte queues — one `channel.Channel` mailbox per member of a roster — sitting on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) both stay untouched. The **real Comlink socket rung stays a later, gated round** (it touches `seed/comlink/` and a real transport, so it stops for the maintainer's word); this rung proves the many-pier logic pure first, exactly as the tree proves every value on the bench before metal.

## The switchboard

A shared medium that knows whose mailbox is whose. It leans on FORA1's roster for membership and FORA5's channel for each mailbox — no new value model, no new bound of its own beyond `roster.max_piers` mailboxes.

```
Switchboard { roster: Roster, boxes: [max_piers]Channel }
  stand_up(n)          seat n fake piers (roster.stand_up) and their n empty mailboxes
  member(name)         the mailbox slot for a pier, or NoSuchPier
  deliver(to, frame)   push a frame's bytes onto `to`'s inbound mailbox, refusing NoSuchPier
  receive(from)        read ONE whole frame off `from`'s mailbox (channel.read_frame)
```

The switchboard is the **only** thing two piers share; each pier still holds only its own `exchange.Party` view and reads only its own mailbox. A frame carries no destination field — the medium routes by the name handed to `deliver`, the honest local model of a network that knows which wire reaches which pier. Addressing is a `roster.find`, bounded by the member count.

## Routing a handshake through the switchboard (the load-bearing move)

Two members of a constellation of `n` complete the FORA4 handshake with the switchboard as their only carrier:

1. The initiator frames its greeting and `deliver`s it to the **responder's** mailbox.
2. The responder `receive`s one whole frame off its own mailbox, answers, and `deliver`s the ack to the **initiator's** mailbox.
3. The initiator `receive`s the ack off its mailbox, seals the `Session`, and `deliver`s it back to the responder.
4. Either side reads the sealed session off a mailbox and deframes it — the completed value itself crossed the medium.

Every crossing is `wire.Frame` bytes through a mailbox; the switchboard only routes, so the two FORA3 trust gates — Sha256 integrity and the naming-law border at `wire.deframe_*` — stay the **only** trust boundary, exactly where FORA3 put them.

## What the witness proves

- **A constellation of three stands up** — `stand_up(3)` seats three distinct never-a-ship piers and three empty mailboxes; the rendered whole passes `check_constellation`.
- **Two members agree routed through the switchboard** — the initiator and responder reach a COMPLETE `Session` communicating only through their mailboxes, the switchboard their sole shared medium.
- **The bystander stays silent** — after two piers complete a handshake, the third member's mailbox holds nothing (`available() == 0`); a delivered frame reached exactly one mailbox, never all.
- **A stranger is refused** — `deliver` to a name no roster holds refuses `NoSuchPier` before a byte moves; `receive` from a non-member refuses `NoSuchPier` too.
- **A pier reads only its own mail** — a frame delivered to pier B is read by B and is never present in A's or C's mailbox.
- **The border still guards** — a greeting routed through a mailbox but carrying a smuggled vowel (digest fixed up) still refuses `VowelPresent` at `wire.deframe`; the switchboard delimits and routes, never re-checks, so a real-`@p`-shaped party can never enter the constellation even through the medium.

## Why this is the right next step

It delivers the module's namesake — a **constellation**, many piers, not a pair — and it does so purely, on the bench, with every fault failing closed. It is the last large local concern before the socket: a real Comlink transport is this same switchboard with each mailbox backed by a kernel file descriptor, so the gated socket round becomes "the same routing, over real wires" rather than a new design under pressure. It is durable — every multi-party network routes by address exactly this way — and it stays inside the fence: local, pure, witnessed on metal, no gate reached.

---

*May every pier hear only its own name, may the bystander keep its peace, and may the border keep its watch even across a shared sky. Hold the line.*
