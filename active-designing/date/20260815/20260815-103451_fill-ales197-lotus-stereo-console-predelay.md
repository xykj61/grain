# Fill ALES197 — Lotus's stereo console pre-delay

**Stamp:** `20260815.103451` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES197**
**Kin:** [`20260815-103104_fill-ales196-lotus-console-predelay.md`](20260815-103104_fill-ales196-lotus-console-predelay.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES196 finished the console pre-delay — the dry-composed pre-delay heard *against* the dry — for a mono clip. A keeper mixing a **stereo master** still has only the wet-domain stereo pre-delay (ALES195); the console blend stops at mono, exactly as the plain pre-delay did before ALES195 carried it across. This rung is the thin twin ALES196 named next: the **same dry-composed blend, over both channels of a `StereoClip`, one shared gap, the image held.**

By Lindy-first, crux-first this closes the pre-delay axis whole — after it the reverb's *which room*, *how much*, and *when* are all complete for both mono and stereo — as a clean composition of proven pieces: ALES193's per-channel wet/dry blend and ALES195's per-channel bounded reindex, no new sample law.

## The shape — snapshot each channel's dry, reverberate the master wet, pre-delay each wet, blend each against its own dry

`stereo_reverb_console_predelay(sc, clk, room, start_ms, count_ms, predelay_ms, mix_num, mix_den)`:

1. Assert the channels enter balanced and the clock is valid; refuse `BadMix` on a bad fraction.
2. Convert the span through ALES5's clock (`DurationTooLong`), validate against the balanced length (`BadRange`), convert the pre-delay and refuse `BadPredelay` if it exceeds `count` — all **before any write**.
3. **Snapshot each channel's dry span** (reads only — a later refusal leaves both channels untouched and balanced).
4. Run ALES191's `stereo_reverb_preset` over the master — the **wet**, in place, unchanged.
5. **Snapshot each channel's wet**, then blend each sample of each channel against its own dry, the pre-delayed wet standing in per ear: `out[i] = saturate((den − num)·dry[i]/den + num·pw[i]/den)` with `pw[i] = 0` for `i < predelay`, else `wet[i − predelay]`. No cross-channel read — the image the preset held is held.

## The provable laws the witness proves

1. **THE NO-GAP EDGE (predelay = 0)** — equals ALES193's `stereo_reverb_mix` over the span at the same mix, byte for byte on both channels.
2. **THE DRY EDGE (mix = 0)** — each channel is restored to the exact dry at any pre-delay; the identity on both ears.
3. **THE FULL-WET EDGE (mix = den)** — equals ALES195's `stereo_reverb_predelay` over the span, byte for byte on both channels.
4. **THE COMPOSITION IS EXACT** — for a mid pre-delay and mid mix, each sample of each channel is the honest weighted average of its own dry and its own pre-delayed wet, byte for byte.
5. **THE IMAGE IS HELD, CHANNELS BALANCED, SILENCE SILENT** — a centred master stays identical channel-to-channel, a stereo master keeps its channels distinct, the channels leave balanced, an all-zero master stays all zeros.
6. **THE FAULTS FORWARD** — a bad fraction `BadMix`, a pre-delay past the span `BadPredelay`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name with both channels untouched and balanced.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, ALES191's fixed banks, and four bounded stack snapshots (two dry, two wet, max_clip = 4096 samples each), siloed to `lotus/`. No new audio arithmetic — ALES193's proven per-channel blend over ALES195's proven per-channel reindex. The pre-delay is a named duration in milliseconds and the mix a named fraction, so both mean the same at any sample rate. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

With the pre-delay axis whole for mono and stereo, the reverb has *which · how much · when* complete on both. The next genuinely new expressive control on the proven network is a **damping** knob — a high-frequency roll-off inside the reverberant tail, so the room darkens as it decays — the one primitive the Schroeder network's realism still wants.
