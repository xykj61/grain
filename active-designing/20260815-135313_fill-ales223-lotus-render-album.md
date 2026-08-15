# Fill ALES223 — Lotus render_album: a whole record as one saveable artifact

**Stamp:** `20260815.135313` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES223**
**Kin:** [`../lotus/render_bundle.rye`](../lotus/render_bundle.rye) (ALES222 — the self-binding bundle the album carries) · [`../lotus/render_manifest.rye`](../lotus/render_manifest.rye) (ALES221 — the seal each bundle inherits) · [`20260815-134607_fill-ales222-lotus-render-bundle.md`](20260815-134607_fill-ales222-lotus-render-bundle.md)

## The crux

ALES222 joined a render's manifest and its `.wav` into one bundle — the durable unit a single publish saves. Yet a record is rarely one track. A keeper who masters an album, a podcaster who finishes a season of episodes, a filmmaker who cuts a reel of scenes holds **many** bundles, and once again they travel apart: a folder of files to keep together, to order, to name. The honest next durable move gathers them: an **album** — one framed byte artifact carrying an ordered, named catalog of bundles, opened verify-before-trust.

The crux is the same quiet one that carried ALES222, one level up: **the album needs no new seal.** Each bundle it carries already self-binds — its manifest binds its own text, and its `wav_digest` binds the audio it names — so an album that lays bundles side by side under a small length frame is *already* fully verify-before-trust. Tamper any track's audio and that bundle refuses `WavDigestMismatch`; tamper any track's manifest and it refuses `DigestMismatch`; corrupt a length header and the slices shift into one of those same refusals or `BadAlbum`. The rung's whole job is a bounded catalog frame plus the proof that every track binds its own whole.

## What ALES223 adds

`lotus/render_album.rye`, a pure composition over ALES222 and a small catalog frame:

- `pack(out, tracks) → u32` — write an 8-byte magic (`LOTUSALB`), a u32 little-endian track count, then for each track a u32 `name_len`, a u32 `bundle_len`, the track name, and the bundle bytes — all through `copy_disjoint`. Refuses `AlbumFull` past `max_tracks`, `BadAlbum` for an illegal track name, and `Overflow` rather than writing past the buffer.
- `unpack(bytes) → Album` — the integrity gate: match the magic (`BadAlbum` otherwise), read the count and require it within `max_tracks`, then walk each entry — read the two lengths, require they stay inside the buffer, slice the name (a single legal token) and the bundle, and `render_bundle.unpack` that slice (seal verify + parse + `verify_wav`). The whole frame must tile exactly. Returns a bounded `Album` of verified tracks, every slice into `bytes`.

`AlbumError = render_bundle.BundleError || error{ BadAlbum, AlbumFull }` — the bundle's whole fault set plus the catalog's own.

## The laws the witness proves on metal

- **THE ROUND-TRIP LAW** — pack then unpack recovers every track's name, every manifest field, and each exact `.wav`, in order.
- **THE SELF-BINDING LAW** — a single flipped byte in any track's `.wav` refuses `WavDigestMismatch`; a flipped byte in any track's manifest refuses `DigestMismatch` — the album needs no new seal, every track binds its own whole.
- **THE FRAME LAW** — a wrong magic, a count past `max_tracks`, or a length that does not tile the buffer refuses `BadAlbum` / `AlbumFull`.
- **THE ATOMIC LAW** — a too-small output buffer refuses `Overflow`, nothing half-written.
- **THE EMPTY LAW** — a zero-track album packs and unpacks cleanly to an empty catalog, so an opening record is a real, verifiable artifact rather than a special case.

## Honest scope

Software only, purely local — a bounded catalog frame over in-process byte slices, siloed to `lotus/`. It proves a *collection* of renders arrived whole, **not who made it** — no signature, no key. No real file, no DAC, no acoustic or electrical fact, no network, no funds, no real device. No custody gate.
