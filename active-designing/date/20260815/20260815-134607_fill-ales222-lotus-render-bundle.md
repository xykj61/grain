# Fill ALES222 — Lotus render_bundle: manifest and .wav as one saveable artifact

**Stamp:** `20260815.134607` · **Voice:** Kyri · **Style:** Radiant · **Status:** Vision -- Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES222**
**Kin:** [`../lotus/render_manifest.rye`](../lotus/render_manifest.rye) (ALES221 — the sealed, content-addressed manifest) · [`../lotus/wav.rye`](../lotus/wav.rye) (ALES215 — the .wav the bundle carries) · [`20260815-133848_fill-ales221-lotus-render-manifest.md`](20260815-133848_fill-ales221-lotus-render-manifest.md)

## The crux

ALES221 gave a render a sealed manifest that binds its own `.wav` by Sha256 — yet the two still travel apart: a keeper holds a manifest *and* a `.wav`, two things to save, two things to keep together. A publish or a chain of custody wants **one** thing to save and later open. The honest next durable move joins them: a **bundle** — one framed byte artifact carrying the manifest and the `.wav` together, opened verify-before-trust.

The crux is a quiet, decisive one: **the bundle needs no new seal.** The manifest already binds its own text (the seal digest) and the audio it names (the `wav_digest`), so a bundle that lays the two side by side is *already* fully verify-before-trust — tamper the audio and `verify_wav` refuses `WavDigestMismatch`; tamper the manifest and `open_manifest` refuses `DigestMismatch`; corrupt a length header and the slices shift into one of those same refusals. The rung's whole job is a bounded frame plus proof that the two components bind the whole.

## What ALES222 adds

`lotus/render_bundle.rye`, a pure composition over ALES221 and a small length frame:

- `pack(out, manifest, wav) → u32` — write an 8-byte magic (`LOTUSBND`), the two u32 little-endian lengths, then the manifest bytes and the `.wav` bytes, through `copy_disjoint`. Refuses `Overflow` rather than writing past the buffer.
- `unpack(bytes) → Bundle` — the integrity gate: match the magic (`BadBundle` otherwise), read the two lengths and require they tile the buffer *exactly* (no trailing, no shortfall), then `open_manifest` the manifest slice (seal verify + parse) and `verify_wav` the `.wav` slice against it. Returns the parsed `Manifest` and the verified `.wav` slice, both into `bytes`.

`BundleError = render_manifest.ManifestError || error{ BadBundle }` — the manifest's faults plus the frame's own.

## The laws the witness proves on metal

- **THE ROUND-TRIP LAW** — pack then unpack recovers every manifest field and the exact `.wav` bytes.
- **THE SELF-BINDING LAW** — a single flipped `.wav` byte in the bundle refuses `WavDigestMismatch`; a flipped manifest byte refuses `DigestMismatch` — the bundle needs no new seal, its two components bind the whole.
- **THE FRAME LAW** — a wrong magic refuses `BadBundle`; a length that does not tile the buffer (truncated or trailing) refuses `BadBundle`.
- **THE ATOMIC LAW** — a too-small output buffer refuses `Overflow`, nothing half-written.

## Honest scope

Software only, purely local — a bounded byte frame over two in-process byte slices, siloed to `lotus/`. It proves an artifact arrived whole, **not who made it** — no signature, no key. No real file, no DAC, no acoustic or electrical fact, no network, no funds, no real device. No custody gate.
