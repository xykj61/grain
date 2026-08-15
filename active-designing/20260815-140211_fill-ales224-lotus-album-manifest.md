# Fill ALES224 — Lotus album_manifest: a whole record's own content address, sealed

**Stamp:** `20260815.140211` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES224**
**Kin:** [`../lotus/render_album.rye`](../lotus/render_album.rye) (ALES223 — the catalog this manifest names) · [`../lotus/render_manifest.rye`](../lotus/render_manifest.rye) (ALES221 — the per-render manifest this is one level up from) · [`../lotus/seal.rye`](../lotus/seal.rye) (ALES38 — the verify-before-trust frame reused whole)

## The crux

ALES221 gave a single render a sealed, content-addressed manifest; ALES223 gathered many renders into an album. Yet the album as a whole has no small, citable name. A keeper who wants to publish a record, cite it in a chain of custody, or prove two copies are the same record needs **one short sealed record** that fixes the whole collection's identity — without shipping the audio to do it.

`album_manifest` is to the album exactly what `render_manifest` is to a single render, one level up: a sealed `format lotus-album-v1` body listing the track count and, per track, its name and the Sha256 of its whole bundle bytes (which already binds that track's manifest *and* audio). The album's content address is thus a few hundred bytes a keeper can print, cite, or compare, and `verify_album` confirms a collection in hand is the exact record the manifest names.

The crux is again a quiet composition: **no new hash, no new frame.** The seal (ALES38) binds the manifest text; each track's bundle Sha256 binds that track's whole. The rung only renders the readable body and proves the binding.

## What ALES224 adds

`lotus/album_manifest.rye`, over ALES223 and the ALES38 seal:

- `seal_album_manifest(out, tracks) → u32` — hash each track's bundle, render a `count <n>` line then one `track <name> <digest>` line per track inside a `seal.begin`/`finish` frame. Refuses `NameTooLong` for a name that is not a single token (the readable line grammar reserves space and newline), `TooManyTracks` past the bound, `Overflow` past the buffer.
- `open_album_manifest(text) → AlbumManifest` — the integrity gate: `seal.open` verifies the record whole, then the body parses into a bounded catalog of `(name, digest)` entries; a malformed field refuses `BadAlbumManifest`, a trailing field a refusal too.
- `verify_album(am, tracks) → void` — confirm a collection in hand: the count must match (`CountMismatch`), and each track's name (`TrackNameMismatch`) and recomputed bundle Sha256 (`TrackDigestMismatch`) must match the manifest, in order.

`AlbumManifestError = seal.SealError || error{ BadAlbumManifest, NameTooLong, TooManyTracks, CountMismatch, TrackNameMismatch, TrackDigestMismatch }`.

## The laws the witness proves on metal

- **THE CONTENT-ADDRESS LAW** — seal then open recovers the count and every `(name, digest)` in order; `verify_album` accepts the exact tracks.
- **THE TAMPER LAW** — a single flipped byte in any track's bundle refuses `TrackDigestMismatch`; a swapped track name refuses `TrackNameMismatch`; a missing or extra track refuses `CountMismatch`.
- **THE SEAL LAW** — a tampered manifest body refuses `DigestMismatch`, a wrong header `BadRecord` (inherited from ALES38).
- **THE GRAMMAR LAW** — a name with a space or past the bound refuses `NameTooLong` at seal; a malformed body refuses `BadAlbumManifest` at open; a count past the bound refuses `TooManyTracks`.
- **THE ATOMIC LAW** — a too-small buffer refuses `Overflow`, nothing half-written.

## Honest scope

Software only, purely local — a Sha256 record over in-process bytes, siloed to `lotus/`. It proves a *collection's identity* is whole, **not who made it** — content-addressing, never a signature; no key, no custody. No real file, no DAC, no acoustic fact, no network, no funds, no real device.
