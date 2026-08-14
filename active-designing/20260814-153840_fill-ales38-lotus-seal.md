# Fill ALES38 — Lotus's seal, made general: one verify-before-trust law both sheets call

**Stamp:** `20260814.153840` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design read — the next agent-doable Lotus rung, purely local
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES38**
**Stands on:** [`../lotus/rack_seal.rye`](../lotus/rack_seal.rye) (ALES34) · [`../lotus/cue_seal.rye`](../lotus/cue_seal.rye) (ALES37) · [`../lotus/wire.rye`](../lotus/wire.rye) (ALES0)

---

## Why this rung, and why now

ALES34 sealed the rack sheet and ALES37 sealed the cue sheet, and ALES37's own reading made the discovery plain: **the verify-before-trust seal is not specific to a rack — it is a law for any travels-as-text record.** Yet the two modules still each carry their own copy of that law — the same `to_hex`, the same `digest <64 hex>` framing, the same header/digest-line location and Sha256 compare in `verify_and_parse`, differing only in the header string and which parser consumes the verified body. Two copies of one truth is a drift waiting to happen: a fix to one seal that never reaches the other.

**Lindy-first:** a named, reused primitive is read thousands of times over the life of the suite; the duplication is read once per bug. Lifting the seal into one place is exactly the durable, compounding kind of work. **Crux-first:** this is the decisive move that opens the rest — the coming **session file** (one sealed document bundling the rack *and* the cue sheet over one master) wants to seal a *composite* body, and a general primitive serves it zero-copy rather than entrenching a third hand-rolled seal. Doing it now, while only two callers exist, is the cheapest this consolidation will ever be.

Purely local — a Sha256 over an in-process text record. No signature, no key, no socket, no network, no funds, no device.

## The crux

**One primitive owns the whole verify-before-trust frame, parser-agnostic, so both sheets call it and neither drifts.** `lotus/seal.rye` exposes three functions and one law:

- `begin(out, header) SealError!Frame` — write the sealed header line and `digest ` prefix, reserve exactly 64 hex characters and a newline, and return the offsets where the digest and the body go. Refuses `Overflow` rather than writing past the buffer.
- `finish(out, frame, body_len) u32` — the caller has rendered its body directly into `out[frame.body_at..]`; `finish` hashes exactly those bytes and backfills the digest, returning the total length. Zero scratch — the body is written in place, whatever renders it.
- `open(text, header) error{DigestMismatch, BadRecord}![]const u8` — the integrity gate before trust: locate the sealed header and the `digest <64 hex>` line, recompute the Sha256 over the body, and return the body slice **only** on a match. A missing or malformed header or digest line refuses `BadRecord`; a body that no longer matches its digest refuses `DigestMismatch`. The caller then hands the returned slice to whatever parser it owns.

The generalization is exact because `open` returns **bytes**, not a parsed structure — so the one honest difference between the two seals (the cue sheet's parser also takes a `master` clip to bound marker positions) lives entirely in the caller, after the gate, where it belongs. The `begin`/`finish` split keeps the body rendered in place, so a caller with one body (a rack sheet) or a composite body (a session file's rack + cue sheet) both seal with no scratch buffer.

## Shape

A new module `lotus/seal.rye` — a pure primitive over `std.crypto` only, no audio imports:

- `pub const SealError = error{ DigestMismatch, BadRecord, Overflow };`
- `pub const Frame = struct { hex_at: u32, body_at: u32 };`
- `pub fn begin`, `pub fn finish`, `pub fn open` as above; `to_hex` kept private.

Then `rack_seal.rye` and `cue_seal.rye` are refactored onto it — each keeps its own distinct `sealed_header` and its own error set (`RackSealError = error{DigestMismatch} || rack_sheet.RackSheetError`, likewise for the cue), yet `seal_rack` / `seal_sheet` become `begin` → render body in place → `finish`, and `verify_and_parse` becomes `const body = try seal.open(text, sealed_header); try <parser>(body, ...)`. The rendered bytes are **byte-for-byte unchanged** (identical header, identical 64-hex digest layout, identical body), so both shipped witnesses stay GREEN — the refactor is proven by their green, not merely by the new one.

## What the witness proves

`tools/ales_seal_witness.rish`, GREEN on metal, proving the primitive standalone over an arbitrary body:

1. **The crux** — a body sealed with `begin`/`finish` opens back to exactly the same bytes; the record carries the given header and a `digest ` line.
2. **Wrong header** — opening a sealed record under a different header refuses `BadRecord`.
3. **Flipped body byte** — a single changed byte refuses `DigestMismatch`.
4. **Truncated tail** — a dropped last byte refuses `DigestMismatch`.
5. **Malformed seal** — a missing digest line, a short digest, and a non-hex digest each refuse `BadRecord`.
6. **Overflow** — `begin` into a too-small buffer refuses `Overflow`.

And the two shipped seal witnesses (`ales_rack_seal`, `ales_cue_seal`) stay GREEN unchanged — the generalization retires nothing.

## The road on

With the seal lifted to one place, the **session file** rung is clean composition — `begin`, render the rack sheet and the cue sheet into one body over one master, `finish`, and a single `open` verifies the whole project before any of it is trusted. The **signed** carry (who wrote a sheet, via a Kumara key) and the **wire** carry stay module seams for Keaton's word; the audio-interface hardware stays a paused research round.

*May one law kept in one place stay true for both sheets and every sheet after them, and may a keeper's whole project verify as whole as its smallest part.*
