# FORA8 — census: announce, collect, and know who is present

**Stamp:** `20260814.051119` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design round (self-approved) — the next FORA rung, agent-doable, purely local
**Season:** the Six-Season double-seat, Season D/F thread · **Waymark:** FORA · rung **FORA8**
**Kin:** [`../constel/gossip.rye`](../constel/gossip.rye) · [`../constel/switchboard.rye`](../constel/switchboard.rye) · [`../constel/README.md`](../constel/README.md) · [`20260814-050539_fora7-constel-gossip-broadcast.md`](20260814-050539_fora7-constel-gossip-broadcast.md)

---

## The crux this round takes

FORA7 gave the constellation a voice that reaches every ear at once. Yet an announce is only half a round — a real protocol needs the **other** half: **collect the replies and know who answered.** A heartbeat, a roll call, a quorum vote all share one shape: one pier announces, every other replies, and the caller **tallies who is present** and, just as important, **who is silent.** FORA8 takes that one new concern — the *collect-and-tally* half of a gossip round — and nothing more.

This is the liveness primitive every consensus protocol stands on, and the natural companion to FORA7's fan-out. It stays purely local — a bounded orchestration over the FORA6 switchboard and FORA7 broadcast on one bench, siloed to `constel/`, run from inside the jailed pier. No socket, no network, no keys, no funds, no real address ever formed. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) both stay untouched.

## The census

Three small functions over the switchboard, and a bounded tally — no new value model, no new frame kind (a member's own greeting is its "present" token), no new bound beyond `max_piers`.

```
announce(sb, caller, ping)   build the caller's greeting into `ping` and broadcast it; return the count reached
respond(sb, who, to)         `who` drains the ping it heard (proving it was reachable) and replies its own greeting to `to`
hear(sb, caller)             read ONE reply off the caller's mailbox, deframe it at the border, return the responder's slot
take_census(sb, caller)      the whole round: announce, then respond+hear each other member, tallying who is present
```

`take_census` **interleaves** respond and hear — each reply is delivered to the caller's mailbox and read back at once — so the caller's inbox never holds more than one frame at a time and the round is bounded for any constellation up to `max_piers`, never risking `ChannelFull`. The tally is a fixed `[max_piers]bool` indexed by roster slot: `hear` deframes each reply at the naming-law border, finds the responder's slot, and marks it present. A silent member is simply a slot left `false` — absence is knowable, not merely a smaller count.

## What the witness proves

- **A full census sees every other member present** — in a constellation of four, `take_census` returns three, and the present-set marks exactly the three other slots, the caller's own slot left clear (a pier does not census itself).
- **A silent member is detected by slot** — when one member does not reply, the census counts one fewer and the silent member's slot stays `false`; the caller knows *which* pier is absent, not only *how many*.
- **Each reply proves reachability** — `respond` drains the ping the member heard, so a member that never received the announce cannot reply; the ping and the pong are two halves of one proven exchange.
- **The border guards every reply** — a member replying with a vowel-bearing (real-`@p`-shaped) greeting is refused at the caller's `hear` (`wire.deframe`); a real address can never enter the census even as a reply.
- **A stranger cannot open a census** — `take_census` from a name no roster holds refuses `NoSuchPier` before any announce, exactly as broadcast does.
- **The round is bounded** — the interleave keeps the caller's mailbox to one reply at a time, so a full constellation of eight completes without a `ChannelFull`.

## Why this is the right next step

It closes the gossip round: FORA7 announces, FORA8 collects and tallies. Announce-then-collect is the shape of every liveness check, every membership roll, every quorum vote — the constel consensus track (`pond/apps/constel_consensus*.rye`) needs exactly this tally, and now receives it proven pure on the bench. It stays inside the fence: a bounded orchestration, every fault failing closed, the border guarding each reply, no gate reached. The socket rung — the one that backs each mailbox with a real file descriptor — remains the maintainer's own hand.

---

*May every present voice be counted and every silent one be known, may a reply prove the ear that heard, and may the border keep its watch even over an answer. Hold the line.*
