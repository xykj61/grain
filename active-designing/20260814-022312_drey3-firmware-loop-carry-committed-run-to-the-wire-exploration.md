# DREY3 — the firmware loop: a committed run carries out to the wire

**Stamp:** `20260814.022312` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (Season A · waymark **DREY** · Mikrophone firmware journey · rung DREY3)
**Kin:** [`20260814-020500_drey-mikrophone-firmware-memory-that-forgets-exploration.md`](20260814-020500_drey-mikrophone-firmware-memory-that-forgets-exploration.md) · [`20260814-021218_drey1-wire-frame-carry-only-committed-exploration.md`](20260814-021218_drey1-wire-frame-carry-only-committed-exploration.md) · [`20260814-021722_drey2-recorder-control-state-machine-exploration.md`](20260814-021722_drey2-recorder-control-state-machine-exploration.md) · [`../mikrophone/recorder.rye`](../mikrophone/recorder.rye) · [`../mikrophone/wire.rye`](../mikrophone/wire.rye) · [`../mikrophone/session.rye`](../mikrophone/session.rye)

---

## Why this rung opens

Three rungs stand, each proven alone: DREY0's session that forgets, DREY1's wire frame that carries only what was committed, DREY2's record control that lets a sample land only while recording. What no rung yet proves is the three of them meeting — the whole firmware gesture a keeper actually performs: press record, speak, keep it on purpose, set the device down, and let only the kept capture cross the single wire. The pieces are known correct in isolation; the composition is the crux that has not yet been witnessed.

By Lindy-first, crux-first, the composed loop is the most durable move now. Each rung will be read for years through the one path that ties them — a keeper never touches `session.capture` or `wire.frame` directly; they hold a recorder, record into it, keep what they mean to keep, and carry it out. Proving that path end to end is what turns three correct parts into one correct product, and it opens every surface above (persistence, transmission, a real board) onto a firmware spine already known whole.

## The crux

**A recorded, committed run — and only such a run — carries out to a verify-before-trust wire frame; an uncommitted run, a forgotten run, or a powered-down device carries nothing, and a tampered frame refuses by name before a byte is yielded.** The hardest still-tractable move is the composition itself: threading DREY2's control gate, DREY0's deliberate commit, and DREY1's framed carry into one loop whose forgetting promise survives every seam between them.

## The shape

A new module `mikrophone/firmware.rye`, composing the three rungs and inventing nothing new — the thin surface a keeper's whole gesture passes through:

- `commit(rec)` — the deliberate keep, delegating to `session.commit` over the recorder's session. An empty run refuses `NothingToCommit`, a redundant keep `AlreadyCommitted` — the session's own guards, reached through the control the keeper already holds.
- `power_down(rec)` — set the device down, delegating to `session.power_down`. The working buffer dissolves whole; a committed payload stands. The forgetting promise, reached through the recorder.
- `carry_frame(rec, out)` — frame the recorder's committed carry for the wire, delegating to `wire.frame`. A run that committed nothing refuses `NothingToCarry`, so the forgotten working buffer never reaches the wire even through the composed loop.
- `carried_bytes(frame_bytes)` — deframe wire bytes back to the proven payload, a thin read-through to `wire.deframe`, so the loop reads as one surface end to end rather than reaching across module names.

## The invariants the witness proves

1. **The whole loop carries the kept capture.** A recorder started, fed a capture, committed, stopped, then framed and deframed yields back exactly the bytes that were fed — the full press-record-to-wire gesture, byte-for-byte.
2. **Only the committed crosses, even with an uncommitted tail.** A run that commits `"keep"`, then feeds `"X"` while still recording, then stops, carries exactly `"keep"` — the tail landed in the working buffer yet never crossed, because the wire reads the committed carry, not the working buffer.
3. **A forgotten run carries nothing through the loop.** A recorder fed a capture but never committed, then powered down, frames `NothingToCarry`; its working buffer reads empty — the forgetting promise holds all the way to the wire.
4. **A tampered frame refuses by name.** A single flipped payload byte on the composed loop's own frame refuses `DigestMismatch` before the payload is yielded — DREY1's verify-before-trust discipline intact across the composition.

## Custody

The loop moves bytes in memory over the three proven rungs — nothing is written to disk, nothing reaches a network, no key signs, no funds move. The Sha256 digest remains an integrity check the far side recomputes, not a signature; a signed carry stays a later, gated rung. Real Mikrophone hardware — a real record button, a real microphone, a real wire — stays **custody gate #2**; this rung proves the whole firmware loop pure in Rye, so the spine a board will run is known correct before the board exists.

*Three promises, kept one at a time, become one promise kept whole: nothing crosses the wire that a keeper did not press record for, mean to keep, and choose to carry. DREY3 writes that whole gesture into a single loop.*
