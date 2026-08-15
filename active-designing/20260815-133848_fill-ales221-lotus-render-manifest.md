# Fill ALES221 — Lotus render_manifest: a render describes itself, sealed

**Stamp:** `20260815.133848` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES221**
**Kin:** [`../lotus/render.rye`](../lotus/render.rye) (ALES217 — the mono render) · [`../lotus/stereo_render.rye`](../lotus/stereo_render.rye) (ALES218 — the balanced render) · [`../lotus/seal.rye`](../lotus/seal.rye) (ALES38 — the general verify-before-trust frame) · [`20260815-133213_fill-ales220-lotus-stereo-preset.md`](20260815-133213_fill-ales220-lotus-stereo-preset.md)

## The crux

The render family is whole for mono and stereo — a chain of the tree's own proven effects becomes a canonical `.wav` another program plays. Yet the `.wav` leaves carrying nothing about *what it is*: which preset shaped it, at what rate, how many frames, over how many channels, and — the durable question — whether the bytes in hand are the exact bytes the render produced. A creative suite that means to **publish** an artifact (Season 1, Journey 2) or carry a **content-addressed chain of custody** (Season 2, Journey 6) needs a small, honest record that travels beside the audio and binds it.

The crux is the highest-Lindy, still-tractable move: **a render's manifest binds its own `.wav` bytes by Sha256, sealed verify-before-trust** — so the manifest cannot be silently edited, and the audio it names cannot be silently swapped. This is content-addressing, not signing: it proves the artifact arrived whole, never who made it. No key, no custody gate.

## What ALES221 adds

`lotus/render_manifest.rye`, a pure composition over the sealed frame and standard Sha256, inventing no new acoustic fact:

- `seal_manifest(out, preset_name, sample_rate, channels, frames, wav) → u32` — render a `format lotus-render-v1` body (preset · sample_rate · channels · frames · wav_bytes · wav_digest) into a `seal.begin`/`seal.finish` frame, where `wav_digest` is the Sha256 of the `.wav` bytes themselves. Two hashes, two jobs: the seal's own digest binds the manifest *text*; `wav_digest` binds the *audio* the text describes.
- `open_manifest(text) → Manifest` — the integrity gate before trust: `seal.open` recomputes the record's digest and refuses `DigestMismatch` / `BadRecord` before a field is read, then the body parses into a bounded `Manifest` (its `wav_digest` a slice into the verified text). Metadata reads whole *without the artifact present*.
- `verify_wav(manifest, wav)` — when the audio is in hand, confirm it against its manifest: refuse `WavLenMismatch` if the length differs, `WavDigestMismatch` if the recomputed Sha256 differs.

`ManifestError = seal.SealError || error{ BadManifest, NameTooLong, WavLenMismatch, WavDigestMismatch }` — the honest union of the seal's faults and the manifest's own.

## The laws the witness proves on metal

- **THE SELF-DESCRIBING LAW** — a render sealed, then opened, recovers every field exactly (preset name, rate, channels, frames, wav_bytes) and its `wav_digest` matches the render's `.wav`.
- **THE CONTENT-ADDRESS LAW** — `verify_wav` accepts the exact `.wav` and refuses `WavDigestMismatch` for a single flipped audio byte; a different-length `.wav` refuses `WavLenMismatch` before the digest is even computed.
- **THE SEAL LAW** — a tampered manifest body refuses `DigestMismatch`, a wrong header refuses `BadRecord` — inherited from ALES38, proven still to hold through this wrapper.
- **THE GRAMMAR LAW** — a malformed field or an over-long preset name refuses `BadManifest` / `NameTooLong`, never a guessed value.
- **THE ATOMIC LAW** — a too-small output buffer refuses `Overflow`, nothing half-written.

## Honest scope

Software only, purely local — a Sha256 record over in-process bytes, siloed to `lotus/`. It proves an artifact arrived whole, **not who made it** — no signature, no key. A signed carry stays a later rung on Keaton's word. No real file, no DAC, no acoustic or electrical fact, no network, no funds, no real device. No custody gate.
