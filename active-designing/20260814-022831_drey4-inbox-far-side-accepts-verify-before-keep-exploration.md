# DREY4 — the inbox: the far side keeps a carried frame only once it is proven whole

**Stamp:** `20260814.022831` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (Season A · waymark **DREY** · Mikrophone firmware journey · rung DREY4)
**Kin:** [`20260814-021218_drey1-wire-frame-carry-only-committed-exploration.md`](20260814-021218_drey1-wire-frame-carry-only-committed-exploration.md) · [`20260814-022312_drey3-firmware-loop-carry-committed-run-to-the-wire-exploration.md`](20260814-022312_drey3-firmware-loop-carry-committed-run-to-the-wire-exploration.md) · [`../mikrophone/wire.rye`](../mikrophone/wire.rye) · [`../mikrophone/firmware.rye`](../mikrophone/firmware.rye)

---

## Why this rung opens

DREY3 proved the whole sending gesture: a keeper presses record, keeps on purpose, and only the kept capture crosses the single wire as a verify-before-trust frame. What no rung yet holds is the other end of that wire — the **far side that receives**. A carry has two hands: the device that frames and the desk that keeps. DREY1 proved a frame can be deframed verify-before-trust; it did not prove what a receiver *does* with a good frame, nor — the sharper promise — that a receiver keeps *nothing* from a bad one. The SETU waymark already names this hearth carry, Glass to Desk; DREY4 gives the Desk side its firmware discipline.

By Lindy-first, crux-first, the receiving discipline is the durable crux now. A field recording is only as trustworthy as the hand that keeps it: a receiver that keeps a payload before proving it whole would let a flipped byte, a truncated tail, or a forged magic land in the archive. The crux is a bounded inbox that keeps a payload **only** after every corruption check passes, and leaves no residue when one fails — the forgetting promise extended past the wire to the receiver.

## The crux

**A carried frame is kept by the far side only once it is proven whole; a corrupted, truncated, or forged frame is refused by name and leaves not one byte in the inbox.** The hardest still-tractable move is verify-before-keep across the seam: the inbox must deframe first, and only a clean deframe may write into its bounded store — a failed accept is total, keeping nothing.

## The shape

A new module `mikrophone/inbox.rye`, standing on DREY1's `wire.deframe`, inventing no new transport:

- `Inbox` — a bounded fixed buffer (sized by `wire.max_frame`'s payload ceiling, `session.max_samples`) and the length actually kept. A fresh inbox is empty; no heap outlives it.
- `accept(box, frame_bytes)` — deframe the wire bytes first (`wire.deframe`, every check before a byte is yielded), and only on a clean deframe copy the proven payload into the inbox by a plain bounded loop. Any wire error propagates by name and the inbox is left exactly as it was — empty, or holding its prior kept payload untouched.
- `held(box)` — the kept payload as it stands, exactly the bytes of the last accepted frame; empty until a frame is accepted.
- `clear(box)` — forget the kept payload, zeroing the buffer whole, so a receiver can set down what it held with no residue — the forgetting promise on the Desk side.

## The invariants the witness proves

1. **A whole frame is kept exactly.** A frame framed by the sending loop and accepted by the inbox leaves `held` equal to the original payload, byte-for-byte.
2. **A corrupted frame is refused and keeps nothing.** Each of a flipped magic, a wrong version, an over-declared length, a truncated tail, and a flipped payload byte makes `accept` refuse by the wire's own name (`BadMagic`, `BadVersion`, `LengthOverflow`, `FrameTruncated`, `DigestMismatch`), and the inbox reads empty afterward — no residue of a rejected frame.
3. **A failed accept does not disturb a prior keep.** An inbox holding a good payload, then handed a corrupt frame, refuses and still holds exactly the earlier good payload — a bad frame neither lands nor erases.
4. **Clear forgets whole.** After `clear`, `held` reads empty and the buffer is zeroed, so nothing the inbox once kept can be recovered.

## Custody

The inbox keeps bytes in a bounded buffer in memory — nothing is written to disk, nothing reaches a network, no key signs, no funds move. Verifying a frame's `Sha256` remains an integrity check the receiver recomputes, not a signature check; a signed carry with an authenticated sender stays a later, gated rung. Real Mikrophone hardware and a real Desk stay **custody gate #2**; this rung proves the receiving discipline pure in Rye, so both hands of the carry are known correct before a board or a cable exists.

*A carry is trustworthy only when both hands keep the same promise: the device sends only what was kept on purpose, and the desk keeps only what it has proven whole. DREY4 writes that promise into the receiving hand.*
