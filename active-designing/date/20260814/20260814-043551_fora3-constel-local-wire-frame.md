# FORA3 — the handshake, framed for a local wire

**Stamp:** `20260814.043551` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Design round (self-approved) — the next FORA rung, agent-doable, purely local
**Season:** the Six-Season double-seat, Season D/F thread · **Waymark:** FORA · rung **FORA3**
**Kin:** [`../constel/handshake.rye`](../constel/handshake.rye) · [`../constel/README.md`](../constel/README.md) · [`../mikrophone/wire.rye`](../mikrophone/wire.rye) · [`../.claude/rules/placeholder-ship-names.md`](../.claude/rules/placeholder-ship-names.md) · [`20260814-042804_fora2-constel-local-handshake.md`](20260814-042804_fora2-constel-local-handshake.md)

---

## The crux this round takes

FORA2 proved the pure handshake: two fake piers confirm they are distinct never-a-ship members of one constellation before a payload byte moves, and each of `open` · `accept` · `finish` hands back an immutable value — `Greeting` · `Ack` · `Session`. The README's road-on names the next rung plainly: carry those three proven values across a wire so a real multi-pier sync can move them.

The crux, Lindy-first: **a self-describing frame for each handshake value, deframed verify-before-trust, staying entirely local.** This is exactly the discipline DREY1 (`mikrophone/wire.rye`) proved for the Mikrophone's committed payload — magic · version · length · Sha256 digest · payload, every check run before a single byte is yielded — carried now to the constellation's own values. No network, no keys, no funds, no real address ever formed; custody gate #2 (real hardware / any real wire) and gate #4 (real Kumara, real network) both stay untouched. The frame is a bounded in-memory value on the bench, siloed to `constel/`.

## What makes it more than a copy of DREY1

DREY1 proves a payload *whole* — its digest matches, so no byte flipped in transit. FORA3 proves a payload whole **and lawful**: every name a deframed value carries is re-run through the naming law (`check_ship` · `never_a_ship`) at the border, so a tampered frame that smuggled a vowel-bearing — real-`@p`-shaped — name refuses `VowelPresent` before the value is handed onward. The safety invariant that reached into the *greeting* at FORA2 now reaches into the *wire* at FORA3: a real address can never cross a Constel channel even inside a corrupted frame. Digest integrity and naming-law safety are two independent gates, and the payload passes only when both hold.

## The frame

A single tagged layout, one source of truth so a reader offset can never drift:

```
magic(4 = "CNST") · version(1) · kind(1) · payload_len(u32 LE, 4) · digest(32, Sha256 over payload) · payload
```

`kind` names which handshake value the payload carries — `1` Greeting · `2` Ack · `3` Session — so one deframe entry reads any of the three and refuses `BadKind` for anything else. Each payload is a bounded, length-prefixed serialization of the value's own fields:

| Kind | Payload fields | Max bytes |
|---|---|---|
| Greeting | `from_len(u32) · from · whole_len(u32) · whole` | 4 + 12 + 4 + 64 = 84 |
| Ack | `to_len(u32) · to` | 4 + 12 = 16 |
| Session | `a_len(u32) · a · b_len(u32) · b · complete(1)` | 4 + 12 + 4 + 12 + 1 = 33 |

`header_len = 4 + 1 + 1 + 4 + 32 = 42`; `max_frame = header_len + 84 = 126`. Every buffer is fixed at `max_frame`; no heap outlives it.

## The rungs of the deframe (in order, fail-closed)

1. **too short for a header** → `FrameTooShort`
2. **wrong magic** → `BadMagic`
3. **wrong version** → `BadVersion`
4. **unknown kind** → `BadKind`
5. **declared length past the kind's own ceiling** → `LengthOverflow`
6. **truncated tail** → `FrameTruncated`
7. **digest mismatch** → `DigestMismatch` (recomputed over the payload before any field is read back)
8. **naming law on every name in the value** → `VowelPresent` / `NameTooLong` / … by name — the border safety

Only when all eight hold is the value returned. The witness proves each refusal by name, a clean round-trip for all three kinds, and — the FORA-specific proof — a frame whose digest was *fixed up* after a vowel was smuggled into the payload still refuses `VowelPresent`, so integrity alone can never smuggle a real address across.

## The four rounds of this quest (named, this one taken)

- **FORA3** *(this round)* — `constel/wire.rye`: frame · deframe for the three handshake values, verify-before-trust with the naming law at the border.
- **FORA4** *(named)* — a bounded two-party exchange loop over the frames: initiator frames a `Greeting`, responder deframes and frames an `Ack`, initiator deframes and seals a `Session` — the whole FORA2 handshake carried end to end across frames, still on one bench.
- **FORA5** *(named)* — the local channel: two in-process piers passing frames through a bounded byte queue, no socket yet — the loopback that models the Comlink seam without crossing to a real one.
- **FORA6** *(horizon)* — the real Comlink transport. Crosses the Comlink seam to an actual local socket between fake piers; still no real address, yet a real channel — sized and named when the bench reaches it.

## Why this is the right next step

It is the most durable move on the FORA road: a frame layout is read on its ten-thousandth day, and this one carries the constellation's safety guarantee into every byte that will ever move between piers. It is the hardest still-tractable rung — the naming-law-at-the-border proof is the real design work — and once made, FORA4 and FORA5 are composition over it. And it stays wholly inside the fence: local, pure, witnessed on metal, no gate reached.

---

*May the frame carry only what was proven, may the missing vowel keep the wire as safe as the greeting, and may a real address never cross a Constel channel even inside a broken frame. Hold the line.*
