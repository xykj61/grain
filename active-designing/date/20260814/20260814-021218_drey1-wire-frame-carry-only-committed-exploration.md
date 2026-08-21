# DREY1 — the wire frame that carries only what was committed

**Stamp:** `20260814.021218` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (Season A · waymark **DREY** · Mikrophone firmware journey · rung DREY1)
**Kin:** [`20260814-020500_drey-mikrophone-firmware-memory-that-forgets-exploration.md`](20260814-020500_drey-mikrophone-firmware-memory-that-forgets-exploration.md) · [`../mikrophone/session.rye`](../mikrophone/session.rye) · [`../foundations/20260801-005853_mantrapod-venture-pitch.md`](../foundations/20260801-005853_mantrapod-venture-pitch.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)

---

## Why this rung opens

DREY0 proved the Mikrophone's founding promise pure: a session holds a capture only while powered, keeps nothing except on a deliberate commit, and dissolves the working buffer whole on power-down. Its `carry()` verb hands back the one committed payload as bytes — the single thing a keeper chose to take out across the wire. What DREY0 did not yet name is *how* those bytes cross.

The design read for DREY0 already named the road: "Everything the Mikrophone firmware grows later — the wire protocol to Comlink, the amber-light idle, the field-recorder controls — stands on a session model already known correct." By Lindy-first, crux-first, the most durable next crux is the **wire frame**: the bridge from `carry()` to Comlink, built the way the whole tree already carries bytes it must trust — verify the digest before reading a single byte (the Open Image artifact proves every bead against its address first; the constellation binds a Deed with a `Sha256` digest before it trusts a presented key).

## The crux

**A wire frame carries only the committed payload, and the far side proves the payload intact before it yields a single byte — a corrupted or truncated frame refuses by name, never a wrong byte handed onward.** The hardest still-tractable move is the framing discipline itself, proven pure: turn a session's committed payload into a self-describing frame (magic · version · length · digest · payload), and deframe it with every check ordered *before* the payload is trusted.

The invariant that makes it the Mantrapod's frame and not a generic codec: **the wire carries only what `commit` deliberately kept.** `frame` reads `carry()`, so a session powered down without a commit frames nothing — the forgetting promise reaches all the way to the wire. Uncommitted work never leaves the device.

## The shape

A new module `mikrophone/wire.rye`, importing `session.rye` for the `Session` type, inventing no network and asking no board:

- `Frame` — a bounded fixed buffer (`[max_frame]u8`) plus a length. `max_frame = header_len + max_samples`, so a frame can never outgrow the session it carries. No heap.
- Header layout (a named, fixed prefix): `magic` (4 bytes, `"MPOD"`) · `version` (1 byte) · `payload_len` (`u32`, little-endian) · `digest` (32 bytes, `Sha256` of the payload). `header_len = 41`.
- `frame(session, out) !void` — write the header and copy the committed payload after it. Refuses `NothingToCarry` when the session has committed nothing (`carry()` is empty) — the wire never carries an uncommitted or forgotten buffer. The payload copy is a plain bounded loop, never a bare memcpy.
- `deframe(bytes) ![]const u8` — parse and prove, every check *before* the payload is yielded:
  - `FrameTooShort` when the bytes are shorter than `header_len`.
  - `BadMagic` when the four magic bytes do not match.
  - `BadVersion` when the version byte is not the one this firmware speaks.
  - `LengthOverflow` when the declared `payload_len` exceeds `max_samples` — a wire length is never trusted past the named ceiling, before any read.
  - `FrameTruncated` when the bytes are shorter than `header_len + payload_len`.
  - `DigestMismatch` when `Sha256` of the payload region does not equal the header digest — **before** the payload slice is returned.
  - only when every check passes does it return the payload slice.

## The invariants the witness proves

1. **Round-trip is exact.** For a committed session, `deframe(frame(...))` returns the payload byte-for-byte equal to `session.carry()`.
2. **The wire carries only the committed.** A session captured and powered down without a commit refuses `NothingToCarry` — the forgotten working buffer never reaches the wire. A session that captured, committed, then captured more (an uncommitted tail) frames exactly the committed bytes, never the tail.
3. **Every corruption refuses by name, before a byte is yielded.** A flipped magic byte refuses `BadMagic`; a wrong version refuses `BadVersion`; a length inflated past `max_samples` refuses `LengthOverflow`; a truncated tail refuses `FrameTruncated`; a single flipped payload byte refuses `DigestMismatch` — each returns before yielding the payload.
4. **The frame is bounded.** A full-capacity session (`max_samples` committed) frames within `max_frame`, and no frame ever claims a length past `max_samples`.

## Custody

Bytes are framed, verified, and yielded in memory — nothing is written to disk, nothing reaches a network, no key signs, no funds move. The `Sha256` digest is an integrity check the far side computes itself, not a signature (a signed carry is a later, gated rung). Real Mikrophone hardware and any real wire stay **custody gate #2**; this rung proves the frame's shape pure in Rye on the bench, so the day a board and a Comlink link exist, the framing they use is already known correct.

*A device that forgets on purpose must also refuse to hand on a byte it cannot prove. DREY1 writes that refusal into the wire itself — the frame carries only what was kept, and proves it whole before it trusts it.*
