# DREY2 — the recorder controls: samples land only while recording

**Stamp:** `20260814.021722` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (Season A · waymark **DREY** · Mikrophone firmware journey · rung DREY2)
**Kin:** [`20260814-020500_drey-mikrophone-firmware-memory-that-forgets-exploration.md`](20260814-020500_drey-mikrophone-firmware-memory-that-forgets-exploration.md) · [`20260814-021218_drey1-wire-frame-carry-only-committed-exploration.md`](20260814-021218_drey1-wire-frame-carry-only-committed-exploration.md) · [`../mikrophone/session.rye`](../mikrophone/session.rye)

---

## Why this rung opens

DREY0 proved the session that forgets; DREY1 proved the wire frame that carries only what was committed. Both are the *substrate* — what a byte does once captured, and how a committed payload crosses. What neither yet names is the surface a keeper's thumb actually touches: the **record control**. A field recorder is not a raw buffer a keeper writes into byte by byte — it is a device with a record button, a pause, a stop. DREY0's design read named this next: "the field-recorder controls" stand on a session already known correct.

By Lindy-first, crux-first, the recorder's operating discipline is the durable crux now: a bounded state machine that decides *when* a sample is allowed to land, so the session's `capture` is never reached except during a live recording. The forgetting promise deepens — a paused or stopped recorder accepts nothing, and only what landed during recording can ever be committed and carried.

## The crux

**A sample lands in the session only while the recorder is actively recording; a paused, idle, or stopped recorder refuses the sample by name, and every illegal control transition refuses by name — no byte enters the buffer outside a live record run.** The hardest still-tractable move is the control state machine itself, proven pure: four states, a small set of transitions, and the single invariant that `feed` reaches `session.capture` only in the `recording` state.

## The shape

A new module `mikrophone/recorder.rye`, wrapping a `session.Session` and inventing no input hardware:

- `RecState` — `idle` · `recording` · `paused` · `stopped`. A fresh recorder is `idle`.
- `Recorder` — a `Session` and a `RecState`, nothing more; no heap beyond the session's own fixed buffers.
- `start(rec)` — `idle → recording`. A recorder already recording refuses `AlreadyRecording`; a stopped recorder refuses `Stopped` (a run is over; power-cycle to begin again).
- `feed(rec, sample)` — accept one sample **only** while `recording`, delegating to `session.capture`; any other state refuses `NotRecording` before a byte moves. A full buffer still surfaces the session's own `BufferFull`.
- `pause(rec)` — `recording → paused`. Only a recording recorder can pause (`NotRecording` otherwise). The buffer is untouched — pause holds, it does not forget.
- `resume(rec)` — `paused → recording`. Only a paused recorder can resume (`NotPaused` otherwise).
- `stop(rec)` — `recording | paused → stopped`. The captured buffer is ready to `commit`; a sample fed after stop refuses `NotRecording`. An idle or already-stopped recorder refuses `NotRecording`.
- `committed_carry(rec)` — a thin read-through to the session's `carry()`, so a caller commits and carries through the recorder it already holds.

## The invariants the witness proves

1. **Samples land only while recording.** `feed` in `idle`, `paused`, or `stopped` refuses `NotRecording` before a byte moves; a recording recorder accepts exactly, and the session's working buffer reads back byte-for-byte what was fed.
2. **The control transitions are a real state machine.** `start` on a recording recorder refuses `AlreadyRecording`; `pause` off a recording run refuses `NotRecording`; `resume` off a paused run refuses `NotPaused`; a stopped run refuses `Stopped` to a fresh `start`.
3. **Pause holds, it does not forget.** A recorder recorded, paused, then resumed keeps every earlier sample; the buffer across a pause is exactly the samples fed before it plus the samples fed after resume, in order.
4. **Only a recorded, committed run carries.** A recorder recorded and stopped without a commit carries nothing; recorded, committed, then stopped carries exactly the committed bytes — the forgetting promise, now gated behind the record control.

## Custody

The recorder gates bytes in memory over DREY0's session — nothing is written to disk, nothing reaches a network, no key signs, no funds move. Real Mikrophone hardware (a real record button, a real microphone) stays **custody gate #2**; this rung proves the control discipline pure in Rye, so the surface a keeper's thumb meets is already known correct before a board exists.

*A recorder owes its keeper one honest promise about its button: nothing is captured unless it is recording. DREY2 writes that promise into the control itself.*
