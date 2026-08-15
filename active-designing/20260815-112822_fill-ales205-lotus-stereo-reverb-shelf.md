# Fill ALES205 — Lotus's stereo reverberant tone shelf (the reverb's two-band EQ, per ear)

**Stamp:** `20260815.112822` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES205**
**Kin:** [`20260815-112557_fill-ales204-lotus-reverb-shelf.md`](20260815-112557_fill-ales204-lotus-reverb-shelf.md) · [`20260815-104900_fill-ales199-lotus-stereo-reverb-tone.md`](20260815-104900_fill-ales199-lotus-stereo-reverb-tone.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES204 gave the **mono** reverb its two-band shelving EQ — bass and treble each boosting or cutting its own band of the tail independently. Yet a keeper mixing a **stereo master** still had only the plain darkness knob carried across (ALES199); the full two-band shelf stopped at mono, exactly as the darkness knob did before ALES199 carried *it* across. This rung is the thin twin ALES204 named next: the **same** two-band shelf, over **both** channels of a `StereoClip`, one shared bass, treble, and split, the image held.

The ladder always closes the mono/stereo pair before opening a fresh axis — crux-first within the finishing edge. It is a clean composition of proven stages: ALES191's stereo named-room wet, then ALES41's `shelf` run per ear.

## The shape — reverberate the master wet, then tone-shelve each ear

`stereo_reverb_shelf(sc, clk, room, start_ms, count_ms, coeff_num, coeff_den, bass_num, bass_den, treble_num, treble_den)`:

1. Assert the channels enter balanced; validate the clock; **pre-check the shelf setting** — coefficient, both band denominators, span — with ALES41's `precheck`, **before any write**, so a bad setting leaves both channels *dry and balanced* (the atomicity crux).
2. Convert the span through ALES5's clock (`DurationTooLong`) and range-check it (`BadRange`, one bound governs both balanced channels) before any write.
3. Run ALES191's `stereo_reverb_preset` over the master — the **wet**, in place, unchanged.
4. Tone-shelve **each** channel's wet span through ALES41's `shelf` at the **same** coefficient and gains, with **no cross-channel read** — the left ear shelves left, the right ear shelves right, so the image the preset held is held.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`bass == unity AND treble == unity`)** — equals ALES191's `stereo_reverb_preset` over the span, byte for byte on **both** channels, at any coefficient.
2. **IT EQUALS ITS COMPOSITION** — for a real shelf, each channel equals `stereo_reverb_preset` then `shelf.shelf` on that channel, byte for byte; and each shelved channel differs from its wet.
3. **THE TREBLE CUT DARKENS** — each treble-cut channel's high-frequency roughness is strictly less than its wet's.
4. **THE BASS BOOST LIFTS** — each bass-boost channel's total absolute energy is strictly greater than its wet's.
5. **THE IMAGE IS HELD** — a centred master (left == right) stays identical channel-to-channel; a genuinely stereo master keeps its channels distinct — no crossing.
6. **THE CHANNELS LEAVE BALANCED** and silence stays silence.
7. **THE FAULTS FORWARD, ATOMIC** — an illegal coefficient `BadCoeff`, a zero band denominator `BadGain`, each with **both channels untouched (still dry)**; a span past the clip `DurationTooLong`; an out-of-range span `BadRange`; each by name before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, and ALES191's fixed banks, siloed to `lotus/`. No new audio arithmetic — the shelf is ALES41's proven two-band shelf over the proven stereo wet, run per ear, each band scaled in the wide i64 domain and saturated once. A **wet-tail** stereo shelf; the split is a fraction per sample index, so it means the same at any sample rate. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The tone axis then stands whole for mono and stereo in both its plain-darkness and full-shelf forms. A fresh reverb axis opens next — **width** (the stereo spread of the tail), **freeze** (an infinite-hold sustain), or **early/late balance** (the ratio of the first reflections to the diffuse wash).
