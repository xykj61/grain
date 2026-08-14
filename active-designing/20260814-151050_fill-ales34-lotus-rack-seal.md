# ALES34 — Lotus's slot sheet, sealed (verify before trust)

**Stamp:** `20260814.151050` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES33
**Waymark:** ALES · rung ALES34
**Kin:** [`ALES33 — the rack travels as text`](20260814-150213_fill-ales33-lotus-rack-sheet.md) (render_rack / parse_rack reused whole) · [`ALES0 — the audio wire`](20260814-fill-ales0-lotus-audio-wire-shape.md) (the Sha256 verify-before-trust idiom) · [`lotus/rack_seal.rye`](../lotus/rack_seal.rye) · [`lotus/rack_sheet.rye`](../lotus/rack_sheet.rye) · [`lotus/wire.rye`](../lotus/wire.rye)

---

## Why this round

ALES33 lets a keeper's whole rack travel as a `format lotus-rack-sheet-v1` record — yet plain text carries no proof it arrived whole. A byte flipped in a copy-paste, a truncated file, a hand-edited sample all parse as *some other rack* without a word of warning. The ALES0 audio wire already answers exactly this for a live frame: a Sha256 over the payload, recomputed by the far side and checked **before** the payload is trusted (deframe verify-before-trust). ALES33's own road-on named this as the next agent-doable rung: give the slot sheet a content digest so it verifies before it is trusted.

Lindy-first, crux-first: an integrity gate on a persistence format is durable — the day a keeper's saved rack matters most is the day it might be corrupt, and a silent wrong parse is the worst outcome a format can have. It is the hardest still-tractable rung on the sheet side (the signing rung — *who* wrote it, not only *that* it arrived whole — is a Kumara-key module seam that waits for Keaton's word). And it composes cleanly: it wraps ALES33 whole and adds only the digest layer.

## The one crux this rung fixes

**A sealed slot sheet parses back to exactly the same rack only when its digest matches its body — `verify_and_parse` recomputes the Sha256 over the embedded ALES33 record and refuses `DigestMismatch` before a single slot is trusted.** Two facts make this exact:

- **The seal wraps ALES33 whole.** `seal_rack` renders the plain record with `rack_sheet.render_rack` and writes a Sha256 over exactly those body bytes, so the digest covers the canonical text with nothing added or omitted.
- **Verify runs before trust.** `verify_and_parse` checks the digest first and hands the body to `rack_sheet.parse_rack` only on a match, so no corrupt record ever reaches the parser — the integrity gate is independent of, and prior to, every ALES33 grammar and bound check.

## The shape

`lotus/rack_seal.rye`:

- A sealed record is its own format: `format lotus-rack-sheet-sealed-v1`, then a `digest <64 lowercase hex>` line, then the **whole plain ALES33 record** as the body. The sealed header is distinct from the plain one, so a plain sheet is never mistaken for a sealed one.
- `RackSealError` — `error{ DigestMismatch } || rack_sheet.RackSheetError`; a body that no longer matches its digest refuses `DigestMismatch`, a malformed header or digest line refuses `BadRecord`, a render past the buffer refuses `Overflow`, and every rack bound forwards by name.
- `seal_rack(r, out) -> u32` — write the sealed header, reserve the digest line, render the body directly into `out`, then backfill the Sha256 over exactly those body bytes (no scratch buffer, so a large rack never needs a second copy).
- `verify_and_parse(text, out) -> void` — locate the header and digest lines by their newlines to recover the exact body slice, validate the digest line's structure (`BadRecord`), recompute the Sha256 and compare (`DigestMismatch`), and only on a match hand the body to `rack_sheet.parse_rack`.

Structure versus content is kept distinct: a missing, short, or non-hex digest line is `BadRecord` (the seal is malformed); a well-formed digest that does not match the body is `DigestMismatch` (the body changed). The seal proves a sheet arrived **whole**, not *who* wrote it — it is an integrity check the reader recomputes itself, never a signature.

## What the witness proves (GREEN on metal)

`tools/ales_rack_seal_witness.rish`: a sealed two-slot rack opens with the sealed header and a `digest` line, its body is exactly the plain ALES33 record, and `verify_and_parse` recovers the exact rack (both names and both channels, checked by pasting each recovered slot); a single flipped body byte and a truncated tail each refuse `DigestMismatch` with the output rack left empty; a plain (unsealed) record, a sealed header with no digest line, a too-short digest, and a digest carrying a non-hex character each refuse `BadRecord`; and a seal into a too-small buffer refuses `Overflow`. Purely local — a Sha256 over an in-process text record, no socket, no network, no keys, no funds, no real device, no real meter, no real speaker.

## The road on

With a sealed slot sheet a keeper's saved rack is caught the moment it is corrupt rather than silently mis-parsed. The next rung can **sign** the seal with a Kumara key — proving *who* wrote a rack, not only that it arrived whole — a module seam taken on Keaton's word; or carry a slot across the ALES0 audio **wire** as its own framed payload, also a seam. The real two-channel sound-card write stays a paused hardware research round, taken only on Keaton's word.
