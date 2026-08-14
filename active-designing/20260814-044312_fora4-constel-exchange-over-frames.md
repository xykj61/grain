# FORA4 — the handshake, carried end to end across frames

**Stamp:** `20260814.044312` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Design round (self-approved) — the next FORA rung, agent-doable, purely local
**Season:** the Six-Season double-seat, Season D/F thread · **Waymark:** FORA · rung **FORA4**
**Kin:** [`../constel/wire.rye`](../constel/wire.rye) · [`../constel/handshake.rye`](../constel/handshake.rye) · [`../constel/README.md`](../constel/README.md) · [`20260814-043551_fora3-constel-local-wire-frame.md`](20260814-043551_fora3-constel-local-wire-frame.md)

---

## The crux this round takes

FORA3 proved each handshake value crosses a frame whole and lawful. FORA4 proves the thing that matters more: **two piers reach a COMPLETE `Session` communicating only through frames** — bytes — never once sharing an in-memory value. This is the real pier boundary. Until now the handshake's three steps passed Zig values by pointer, as one program's locals; a real constellation has two piers, each holding only its own state and the bytes the other handed it. FORA4 models exactly that: the initiator never sees the responder's `Ack` value, only its frame; the responder never sees the initiator's `Greeting` value, only its frame. Agreement is reached purely over the wire representation, and the naming-law border guards every crossing.

It stays wholly local and pure — a bounded exchange over in-memory frame buffers on one bench, no socket, no network, no keys, no funds. Custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) both stay untouched.

## The two piers, each blind to the other's value

Two small views, each a pier's own local state — its name and the constellation it belongs to. Neither reaches into the other; the only thing that crosses between them is a `wire.Frame`.

```
Initiator (from_name, sky)                 Responder (me_name, my_sky)
  g = handshake.open(from, sky)
  frame_greeting(g)  ──frame──►            g' = deframe_greeting(frame)   ← border re-proves lawful
                                           a  = handshake.accept(g', me, my_sky)
                     ◄──frame──  frame_ack(a)
  a' = deframe_ack(frame)  ← border
  s  = handshake.finish(g, a')
  frame_session(s)   ──frame──►            s' = deframe_session(frame)   ← border
  ▸ COMPLETE                               ▸ COMPLETE (both, from bytes alone)
```

The crux invariant, asserted: the `Session` the initiator seals and the `Session` the responder reads back from the final frame **name the same two distinct piers and both read COMPLETE** — reached without either pier ever holding the other's intermediate value. A single function `exchange(from, sky, me, my_sky)` drives the three crossings and returns the sealed `Session`, so the witness can assert the whole round in one call while the frames remain the only channel.

## What the witness proves

- **A clean exchange completes end to end across frames** — `xnb` and `xnc` on `xnb-xnc-xnd` reach a COMPLETE Session naming both, communicating only through three frames.
- **Both sides agree on the sealed session** — the responder's `deframe_session` reads back the same two piers the initiator sealed.
- **A cross-constellation responder refuses at accept** — the responder deframes the greeting fine (it is lawful), yet `accept` refuses `ConstellationMismatch` because the skies differ; the exchange never completes.
- **A non-member and a self-greet each refuse by name**, mid-exchange, exactly as FORA2 proved — the frame carries the fault forward faithfully.
- **The border still guards** — a tampered greeting frame (a smuggled vowel with a fixed-up digest) refuses `VowelPresent` at the responder's `deframe_greeting`, so a real-`@p`-shaped party cannot enter the exchange even over the wire.

## Why this is the right next step

It is the rung that turns three proven values and a proven frame into a proven *conversation* — the smallest whole that a real transport (FORA5's byte queue, FORA6's socket) will simply carry unchanged. It is durable: the exchange shape is the contract every later transport implements. It is the hardest still-tractable step on the road — the pier-boundary discipline (neither pier holds the other's value) is the real design work — and once made, FORA5 is that same exchange with a byte queue standing in for the direct hand-off. And it stays inside the fence: local, pure, witnessed on metal, no gate reached.

---

*May the two piers agree over bytes alone, may the border keep the wire as safe as the greeting, and may this small conversation be the whole that every real transport need only carry. Hold the line.*
