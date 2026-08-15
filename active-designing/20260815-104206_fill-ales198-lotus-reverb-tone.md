# Fill ALES198 — Lotus's reverb tone (the darkness knob)

**Stamp:** `20260815.104206` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES198**
**Kin:** [`20260815-102052_fill-ales194-lotus-reverb-predelay.md`](20260815-102052_fill-ales194-lotus-reverb-predelay.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

The reverb now carries *which room* (ALES190 presets), *how much* (ALES192/193 wet/dry), and *when* (ALES194–197 pre-delay, mono · stereo · console). The one axis a mixing keeper reaches for next is **how bright** — the **tone** of the tail. A real room absorbs high frequencies as the sound bounces, so the reverberant tail is always *darker* than the source: the highs die first and the low wash lingers. Every console and plugin names this knob — *damping*, *high-cut*, *tone*, *colour*. Without it a reverb rings metallic and glassy; with it the tail sits behind the mix the way a real space does.

By Lindy-first, crux-first this is the highest-Lindy tractable move: a genuinely new expressive axis (spectrum, not time or level), read for years, and a **clean composition of two proven pieces** — no new audio arithmetic. It reverberates the span WET through ALES190's `reverb_preset` unchanged, then rolls the treble off the wet with ALES40's proven one-pole low-pass (`tone.low_pass`).

## The shape — reverberate wet, then darken the wet within the span

`reverb_tone(clip, clk, room, start_ms, count_ms, tone_num, tone_den)`:

1. Validate the clock; convert the span through ALES5's clock (forwarding `DurationTooLong`) and validate it against the clip length (`BadRange`) **before any write**.
2. **Pre-check the tone coefficient through ALES40's `tone.precheck`** against the same span — refuse `BadTone` on an illegal coefficient (a zero denominator, a numerator below one, or a numerator past the denominator) **before the wet is written**, so a bad tone leaves the clip *dry* rather than half-reverbed. This up-front check is the atomicity crux: the tone is validated before the reverb runs, never after.
3. Run ALES190's `reverb_preset` over the span — the **wet**, in place, unchanged.
4. Low-pass the wet span through `tone.low_pass(clip, start, count, tone_num, tone_den)` — `tone_num == tone_den` is the identity (pass-through); a smaller fraction rolls off more treble, darkening the tail.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`tone_num == tone_den`)** — equals ALES190's `reverb_preset` over the span, byte for byte. A full-open tone is exactly the un-darkened reverb.
2. **IT EQUALS ITS COMPOSITION** — for a sub-unity coefficient, `reverb_tone` equals `reverb_preset` then `tone.low_pass`, computed side by side, byte for byte. It invents no arithmetic; every darkened sample is written by a stage already proven.
3. **THE TAIL DARKENS** — the summed first-difference (a measure of high-frequency roughness) of the darkened tail is strictly less than the un-darkened wet's. A room absorbs highs: the treble dies, the wash lingers. And the darkened tail genuinely differs from the un-darkened one.
4. **SILENCE STAYS SILENCE** — an all-zero clip at any tone stays all zeros; a low-pass of silence is silence.
5. **THE FAULTS FORWARD, ATOMIC** — an illegal tone coefficient refuses `BadTone` with the clip **untouched (still dry)**, a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each by name before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one clip, a validated clock, and ALES190's fixed banks, siloed to `lotus/`. No new audio arithmetic — the tone is ALES40's proven one-pole low-pass over the proven wet, so no value is recomputed or can wrap. This is a **wet-tail tone**: a single first-order high-cut applied to the whole reverberant span, an honest first darkness knob. A true in-loop Freeverb-style damping (a low-pass *inside* each comb's feedback, so later echoes darken progressively) is a richer, separate rung that wants a damped-comb primitive; this rung is the honest, provable first step and names that horizon plainly. The coefficient is a plain fraction, so it means the same roll-off at any sample rate. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The **stereo tone** (the same high-cut over both channels of a `StereoClip`, one shared coefficient, the image held) is the thin twin, exactly as ALES195 followed ALES194.
