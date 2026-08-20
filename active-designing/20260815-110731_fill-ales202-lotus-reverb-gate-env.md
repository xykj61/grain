# Fill ALES202 — Lotus's envelope-gated reverb (the shaped-edge gated tail)

**Stamp:** `20260815.110731` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES202**
**Kin:** [`20260815-105453_fill-ales200-lotus-reverb-gate.md`](20260815-105453_fill-ales200-lotus-reverb-gate.md) · [`20260815-110035_fill-ales201-lotus-stereo-reverb-gate.md`](20260815-110035_fill-ales201-lotus-stereo-reverb-gate.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES200/201 gave the reverb its **static** gated tail: reverberate a source into a big room, then slam a downward gate across the quiet decay so only the loud early wash is heard. Both the mono rung (ALES200) and its stereo twin (ALES201) named the same next horizon in their own docstrings — *"a true time-following envelope gate (an attack/hold/release that opens on the transient and closes over the decay, so the cut has a shaped edge) is a richer, separate rung that wants the ALES gate-envelope primitive carried onto the wet."*

That primitive already stands proven: ALES54's `gate_follow` — the attack/release noise gate whose downward push follows a smoothed envelope rather than the bare sample, so it opens as the sound arrives and stays open patiently as it falls away. So the richer horizon is not a new primitive to invent; it is a **clean composition of two proven stages**, exactly the crux-first move — the hardest still-tractable rung on the gate axis, taken before the axis turns to a fresh one. Where the static gate cuts the tail on a hard, instantaneous edge (a below-threshold sample silenced the instant it arrives), the envelope gate cuts it on a **shaped edge**: the release knob holds the gate open through the decay so the tail is not chopped and the gate does not chatter — the difference between a hard eighties slam and a musical, breathing gated tail.

## The shape — reverberate the span wet, then follow-gate the tail

`reverb_gate_env(clip, clk, room, start_ms, count_ms, threshold, ratio_num, ratio_den, attack_num, attack_den, release_num, release_den)`:

1. Validate the clock; **pre-check the gate's threshold, ratio, and both attack/release coefficients with the same guards ALES54's `gate_follow` raises** (a threshold in `[1, sample_max]` → `BadThreshold`; a ratio at least one with a nonzero denominator → `BadRatio`; each coefficient a fraction in `(0, 1]` through `envelope.coeff_ok` → `BadCoeff`) **before any write**, so a bad setting leaves the clip *dry* (the atomicity crux, exactly as ALES200 prechecked its gate up front).
2. Convert the span through ALES5's clock (forwarding `DurationTooLong`) and range-check it (`BadRange`) before any write.
3. Run ALES190's `reverb_preset` over the span — the **wet**, in place, unchanged.
4. Follow-gate the wet span through ALES54's `gate_follow` — the below-threshold decay pushed down as a smoothed envelope crosses the threshold, the release holding the gate open over the tail.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`ratio_num == ratio_den`)** — equals ALES190's `reverb_preset` over the span, byte for byte, at any threshold and any coefficients. A unit-ratio follow-gate makes the gated envelope equal the envelope, so the gain is exactly one everywhere (ALES54's own unit-ratio identity) — the un-gated reverb.
2. **IT EQUALS ITS COMPOSITION** — for a firm ratio (8:1) at a mid threshold with a real attack/release, `reverb_gate_env` equals `reverb_preset` then `gate_follow`, byte for byte; and the shaped-gated tail differs from the un-gated wet.
3. **THE INSTANTANEOUS LIMIT IS ALES200** — with **unit attack and unit release** (instant smoothing) the envelope IS the bare magnitude, so `reverb_gate_env` equals the static `reverb_gate` (ALES200) byte for byte. The shaped gate contains the hard gate as its zero-smoothing limit — the new rung ties back to the proven one.
4. **THE TAIL IS GATED** — the shaped-gated tail's total energy (summed magnitude) is strictly less than the un-gated wet's. A downward follow-gate pushes the quiet decay down, so the tail carries less energy than it did.
5. **THE RELEASE SHAPES THE EDGE (monotone)** — a **slower release** holds the gate open longer over the decay, so its gated tail carries **at least as much** energy as a faster release's. The release knob is the shaped edge the static gate cannot express, and it is monotone — the whole reason this rung exists beyond ALES200.
6. **SILENCE STAYS SILENCE** — an all-zero clip at any gate stays all zeros.
7. **THE FAULTS FORWARD, ATOMIC** — a bad threshold refuses `BadThreshold`, a bad ratio `BadRatio`, an illegal coefficient `BadCoeff`, each with the clip **untouched (still dry)**; a span past the clip `DurationTooLong`; an out-of-range span `BadRange`; each by name before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `Clip`, a validated clock, and ALES190's fixed banks, siloed to `lotus/`. No new audio arithmetic — the gate is ALES54's proven envelope-following gate over ALES190's proven wet, and the envelope's time base is the one ALES52 proved once. A **wet-tail** envelope gate: one attack/release gate over the whole reverberant span, the shaped-edge gated-reverb knob the static rung named as its horizon. The threshold is a magnitude and the ratio and coefficients are plain fractions per sample index — so the gate means the same relative shape at any sample rate, though the attack/release times, being per-index, are not milliseconds against a clock (a clock-timed envelope-gate face is a later rung, exactly as `reverb_ms` followed the index-named reverb). No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

A **stereo envelope gate** (the same follow-gate over both channels of a `StereoClip`, one shared threshold, ratio, and attack/release, the image held) is the thin twin the ladder always closes next. Beyond the pair, a fresh reverb axis remains open — **width** (the stereo spread of the tail), **freeze** (an infinite-hold sustain), or **early/late balance** (the ratio of the first reflections to the diffuse wash).
