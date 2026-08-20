# Fill ALES196 — Lotus's console pre-delay (the dry-composed pre-delay, end to end)

**Stamp:** `20260815.103104` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES196**
**Kin:** [`20260815-102559_fill-ales195-lotus-stereo-reverb-predelay.md`](20260815-102559_fill-ales195-lotus-stereo-reverb-predelay.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES194 and ALES195 gave the reverb its **when** — the pre-delay — yet both are **wet-domain**: they delay the reverberant tail within the span and leave nothing of the original dry behind. On a real console the pre-delay is heard *against* the dry: the voice sounds first, then the delayed room blooms behind it. That is the classic console pre-delay, and it is exactly the composition ALES194's own scope named — "combined with the dry through ALES192's wet/dry mix it is the classic console pre-delay, a later rung."

By Lindy-first, crux-first this is the highest-Lindy tractable move: it **finishes the pre-delay axis end to end**, the control a mixing keeper actually reaches for, and it is a clean composition of two proven arithmetics — ALES192's linear wet/dry blend and ALES194's bounded reindex — with no new sample law.

## The shape — snapshot the dry, reverberate wet, pre-delay the wet, blend against the dry

`reverb_console_predelay(clip, clk, room, start_ms, count_ms, predelay_ms, mix_num, mix_den)`:

1. Validate the clock and the mix fraction (`BadMix` on a zero denominator or a numerator past it).
2. Convert the span through ALES5's clock (forwarding `DurationTooLong`) and validate it against the clip length (`BadRange`); convert `predelay_ms` and refuse `BadPredelay` if it exceeds `count` — all **before any write**.
3. **Snapshot the dry span** (a read only — a later refusal leaves the clip untouched).
4. Run ALES190's `reverb_preset` over the span — the **wet**, in place, unchanged.
5. **Snapshot the wet**, then form the **pre-delayed wet** in a second bounded buffer: `pw[i] = 0` for `i < predelay`, else `wet[i − predelay]`.
6. **Blend** each sample against the dry snapshot: `out[i] = saturate((den − num)·dry[i]/den + num·pw[i]/den)` — the exact ALES192 balance, the pre-delayed wet standing in for the wet.

## The provable laws the witness proves

1. **THE NO-GAP EDGE (predelay = 0)** — equals ALES192's `reverb_mix` over the span at the same mix, byte for byte. With no gap the console pre-delay is exactly the wet/dry mix.
2. **THE DRY EDGE (mix = 0)** — the span is restored to the exact dry at any pre-delay; the room fully closed is the identity, the delayed wet weighted to nothing.
3. **THE FULL-WET EDGE (mix = den)** — equals ALES194's `reverb_predelay` over the span, byte for byte. Fully open it is exactly the wet-domain pre-delay.
4. **THE COMPOSITION IS EXACT** — for a mid pre-delay and a mid mix, each sample is the honest weighted average of the dry and the pre-delayed wet, byte for byte against the dry snapshot and the un-delayed wet computed side by side.
5. **SILENCE STAYS SILENCE** — an all-zero clip at any pre-delay and any mix stays all zeros.
6. **THE FAULTS FORWARD** — a bad fraction refuses `BadMix`, a pre-delay past the span `BadPredelay`, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name with the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one clip, a validated clock, ALES190's fixed banks, and two bounded stack snapshots (max_clip = 4096 samples each), siloed to `lotus/`. No new audio arithmetic — the blend is ALES192's proven linear weighted average summed in i64 and saturated once (so it can never wrap), and the pre-delay is ALES194's bounded reindex with a true-zero gap. The pre-delay is a named duration in milliseconds and the mix a named fraction, so both mean the same at any sample rate. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The **stereo console pre-delay** (the same dry-composed blend over both channels of a `StereoClip`, one shared gap, the image held) is the thin twin, exactly as ALES195 followed ALES194 — after which the reverb's *which · how much · when* are all complete for both mono and stereo, and a **damping** knob (a high-frequency roll-off inside the tail) is the next genuinely new primitive.
