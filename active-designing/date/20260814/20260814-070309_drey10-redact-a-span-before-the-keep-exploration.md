# DREY10 — redact a span before the keep: the memory forgets on purpose

**Stamp:** `20260814.070309` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (Season A · waymark **DREY** · Mikrophone firmware journey · rung DREY10)
**Kin:** [`20260814-020500_drey-mikrophone-firmware-memory-that-forgets-exploration.md`](20260814-020500_drey-mikrophone-firmware-memory-that-forgets-exploration.md) · [`../foundations/20260801-005853_mantrapod-venture-pitch.md`](../foundations/20260801-005853_mantrapod-venture-pitch.md) · [`../mikrophone/session.rye`](../mikrophone/session.rye)

---

## Why this rung opens

The Mikrophone's founding line is *What forgets, protects.* DREY0 proved the whole working buffer forgets on power-down — every byte zeroed, no residue a later read could recover. That is the device forgetting *everything* when a keeper sets it down. This rung proves the smaller, more deliberate act the same promise implies: a keeper forgetting *one part on purpose* while the rest of the capture stands.

A civic microphone records a meeting, and a keeper hears a name, an address, a number that ought never to leave the room. Before the deliberate keep, they strike that span — and the founding promise says the struck bytes must be as gone as a powered-down buffer, not merely hidden past a length. Redaction is where "what forgets, protects" stops being a boot-time invariant and becomes a keeper's own hand: the device forgets exactly what they chose to forget, provably, before a single byte is committed to carry.

The whole local content-addressed sync (DREY7–9) proved the *desk* holds and serves only what it was handed. Networked serve waits at the Comlink-served custody gate (Season 1 J2, Keaton's hand). Redaction is the next Lindy-first crux that stays purely on the device, purely in Rye — and it is the most durable expression of the module's own reason to exist, so every later surface (the field-recorder trim, the civic-microphone strike) inherits a forgetting already proven correct.

## The crux

**A struck span leaves no residue.** After `redact(session, start, len)`, the working buffer reads exactly the pre-redaction buffer with that span removed, the length drops by exactly `len`, and every byte from the new length out to the buffer's ceiling is zero — no trace of the redacted bytes, and no trace of the tail bytes at the positions they were shifted away from. The hard, tractable move is closing the gap without leaving a ghost: zero the struck span, shift the tail down over it, then zero the region the tail vacated, so the freed bytes are as gone as `power_down` leaves them.

## The shape

A new module `mikrophone/redact.rye`, operating on `session.Session`'s working buffer **before** commit — inventing no storage, asking no network:

- `redact(session, start, len)` — strike `len` samples beginning at `start` from the working buffer while powered. A redaction on an unpowered session refuses `NotPowered`; a `len` of zero refuses `NothingToRedact` (redaction is a deliberate act, like commit); a span reaching past the working length refuses `SpanOutOfRange` before it touches a byte. Otherwise the span is zeroed, the tail is shifted down over it by a plain bounded loop (never a bare memcpy), the vacated tail region is zeroed, and the working length drops by `len`.
- The committed payload (`keep`) is never touched — redaction shapes only what a later commit *may* keep. A keeper redacts, then commits the trimmed working buffer; only then does the trimmed capture become carriable.

## The invariants the witness proves

1. **A struck middle span is removed exactly.** Redacting a span from the middle leaves the working buffer equal to the bytes before it followed by the bytes after it, and the length drops by exactly the span.
2. **No residue.** After a redaction, every byte from the new working length out to `max_samples` is zero — the struck bytes and the vacated tail positions alike, provable by a full scan (the same proof `power_down` earns).
3. **Redaction is bounded and deliberate.** A zero-length redaction refuses `NothingToRedact`; a span past the working length refuses `SpanOutOfRange` before a byte moves; an unpowered redaction refuses `NotPowered`.
4. **Head and tail edges hold.** Redacting the first bytes, the last bytes, and the whole buffer each leave exactly the expected remainder, with no residue.
5. **Only the trimmed capture carries.** A capture, a redaction, then a commit carries exactly the trimmed bytes — the redacted span never reaches the committed payload, and never crosses the wire.

## Custody

A sample is captured, struck, zeroed, and — only on a later deliberate commit — carriable. Nothing is stored to disk, nothing reaches a network, no key signs, no funds move. Real Mikrophone hardware stays **custody gate #2**; this rung proves the redaction discipline pure on the bench, where it can be read whole and witnessed, long before a board exists.

*A device that forgets on purpose owes its keeper a proof that a struck span is truly gone. DREY10 writes that proof, so every trim a keeper ever makes inherits a forgetting as complete as power-down.*
