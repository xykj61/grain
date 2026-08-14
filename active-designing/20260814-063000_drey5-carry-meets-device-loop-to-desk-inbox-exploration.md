# DREY5 — the carry meets: a committed run leaves the device and lands in the desk inbox

**Stamp:** `20260814.063000` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (Season A · waymark **DREY** · Mikrophone firmware journey · rung DREY5)
**Kin:** [`20260814-022312_drey3-firmware-loop-carry-committed-run-to-the-wire-exploration.md`](20260814-022312_drey3-firmware-loop-carry-committed-run-to-the-wire-exploration.md) · [`20260814-022831_drey4-inbox-far-side-accepts-verify-before-keep-exploration.md`](20260814-022831_drey4-inbox-far-side-accepts-verify-before-keep-exploration.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)

---

## Why this rung opens

The Mikrophone firmware journey has proven each hand of the carry alone. DREY3 built the **sending hand** — the device firmware loop that frames only a recorded, committed run for the single wire. DREY4 built the **receiving hand** — the desk inbox that keeps a carried frame only once it is proven whole. Two hands, each witnessed pure, yet they have never been shown *meeting*: no module carries a real recorder's committed run all the way across the wire and into a real inbox in one gesture, so the whole promise — *only what a keeper pressed record for, meant to keep, and chose to carry ever reaches the far side* — has been proven in halves rather than end to end.

By Lindy-first, crux-first, the most durable next move is not a sixth new surface but the **join** of the two proven ones. The SETU hearth carry (Glass↔Desk) names exactly this shape: a device that sends only what was kept on purpose, and a desk that keeps only what it has proven whole. DREY5 proves those two hands are one carry.

## The crux

**A recorded, committed run on the device lands in the desk inbox byte-for-byte — and only such a run does.** The hardest still-tractable move is the composition itself, held to the same forgetting promise across the seam: an uncommitted tail never reaches the desk, a forgotten run powered down never touches the inbox, a frame tampered in transit is refused at the desk and the desk keeps nothing, and after both hands forget (device power-down, desk clear) no residue remains on either side.

## The shape

A new module `mikrophone/carry.rye`, composing the two proven rungs over their public APIs only — inventing no transport, no buffer, no new error:

- `carry_to_inbox(rec, box)` — one gesture: frame the recorder's committed carry (`firmware.carry_frame`, which refuses `NothingToCarry` for a forgotten run so the inbox is never touched), hand the frame across the single wire, and accept it verify-before-trust into the inbox (`inbox.accept`, which refuses any corruption by name and leaves the inbox exactly as it was). On success the desk holds exactly the device's committed carry, byte-for-byte — asserted as the postcondition.

Every refusal is inherited, not re-implemented: `NothingToCarry` from the sending hand, `BadMagic` · `BadVersion` · `LengthOverflow` · `FrameTruncated` · `DigestMismatch` · `FrameTooShort` from the receiving hand. The join adds one invariant of its own — that a successful carry leaves the desk holding the device's committed bytes and nothing else.

## The invariants the witness proves

1. **The carry meets.** A recorder started, fed, committed, and stopped carries into the inbox, and the desk holds exactly the committed bytes, byte-for-byte.
2. **Only the committed crosses.** A run that commits `keep` then feeds an uncommitted tail `X` carries exactly `keep` to the desk — the tail lives in the working buffer and never crosses.
3. **A forgotten run never touches the desk.** Recorded, never committed, powered down: `carry_to_inbox` refuses `NothingToCarry`, and an inbox already holding a prior keep is left untouched (the forgotten run neither lands nor erases).
4. **A frame tampered in transit is refused at the desk.** A single flipped payload byte between framing and accept refuses `DigestMismatch`; the desk keeps nothing, and a prior good keep still stands.
5. **Both hands forget.** After the device powers down its working buffer reads zero, and after the desk clears its inbox reads zero — the whole carry leaves no residue on either hand.

## Custody

The carry composes two pure rungs on the bench. Nothing is stored to disk, nothing reaches a network, no key signs, no funds move. The single wire is still a byte slice handed function to function; the real Mikrophone hardware, a real cable, a real desk stay **custody gate #2**. The Sha256 digest stays an integrity check the receiving hand recomputes, not a signature — an authenticated sender is a later rung.

*Two hands proven alone become one carry proven whole: the device sends only what was kept on purpose, the desk keeps only what it has proven, and between them the forgetting promise holds across every seam.*
