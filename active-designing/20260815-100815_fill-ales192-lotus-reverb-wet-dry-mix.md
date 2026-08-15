# Fill ALES192 — Lotus's reverb wet/dry mix

**Stamp:** `20260815.100815` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES192**
**Kin:** [`20260815-100148_fill-ales191-lotus-stereo-named-room-reverb-presets.md`](20260815-100148_fill-ales191-lotus-stereo-named-room-reverb-presets.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES190 and ALES191 gave the reverb a face reached for by name, mono and stereo. Every knob so far has been a *bank choice* — which room. Yet a mixing keeper reaches for one more control before any other: **how much reverb** — the wet/dry balance that sits a voice in a room without drowning it. ALES191's own recommend named it next: *a wet/dry mix, blending the reverberated span with a snapshot of the dry — the first preset control that is not a bank choice.*

By Lindy-first, crux-first this is the highest-Lindy tractable move: the wet/dry balance is the single most-reached-for reverb knob, read for years by anyone placing a sound in a room. The mono `reverb_mix` is the thin crux; the stereo twin follows.

## The shape — snapshot the dry, wet in place, blend the span

`reverb_mix(clip, clk, room, start_ms, count_ms, mix_num, mix_den)`:

1. Validate the clock and the mix fraction (`mix_num/mix_den`, `0 ≤ num ≤ den`, `den ≥ 1` — else `BadMix`).
2. Convert the span through ALES5's clock (forwarding `DurationTooLong`) and validate it against the clip's length (`BadRange`) **before any write** — so the dry snapshot reads only in-bounds and a refusal leaves the clip untouched.
3. **Snapshot the dry span** into a bounded stack buffer (`max_clip` = 4096 samples, an 8 KB snapshot).
4. Run ALES190's `reverb_preset` over the span — the **wet**, in place, unchanged.
5. **Blend** each sample: `out[i] = saturate((den−num)·dry[i]/den + num·wet[i]/den)` — a linear wet/dry balance, saturating once to the i16 rail exactly as ALES3's mix.

## The provable laws the witness proves

1. **THE DRY EDGE (mix = 0)** — `mix_num = 0` restores the span to the exact dry: the clip is byte-for-byte unchanged. The knob fully closed is the identity.
2. **THE WET EDGE (mix = den)** — `mix_num = mix_den` equals ALES190's `reverb_preset` over the span, byte for byte. The knob fully open is exactly the preset.
3. **THE BLEND IS BETWEEN** — a half-open mix differs from both the pure dry and the pure wet, and each blended sample is the honest weighted average of the two (proven against a hand-computed value).
4. **SILENCE STAYS SILENCE** — an all-zero clip at any mix stays all zeros.
5. **THE FAULTS FORWARD** — a span past the clip refuses `DurationTooLong`, an out-of-range span `BadRange`, a bad fraction (`den = 0` or `num > den`) `BadMix`, each by name with the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one clip, a validated clock, ALES190's fixed banks, and a bounded stack snapshot, siloed to `lotus/`. The one new arithmetic is the linear blend — a weighted average of two i16 spans, summed in i64 and saturated once, so it can never wrap. The mix is a named fraction, not a decibel. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The **stereo wet/dry mix** (the same blend over both channels of a `StereoClip`, image held) is the thin twin, exactly as ALES191 followed ALES190.
