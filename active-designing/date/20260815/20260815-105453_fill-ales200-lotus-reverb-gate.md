# Fill ALES200 — Lotus's gated reverb (the gate across the reverberant tail)

**Stamp:** `20260815.105453` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES200**
**Kin:** [`20260815-104900_fill-ales199-lotus-stereo-reverb-tone.md`](20260815-104900_fill-ales199-lotus-stereo-reverb-tone.md) · [`20260815-104206_fill-ales198-lotus-reverb-tone.md`](20260815-104206_fill-ales198-lotus-reverb-tone.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

The reverb already carries **which** room (ALES190), **how much** (ALES192/193, the wet/dry balance), **when** (ALES194–197, the pre-delay), and **how bright** (ALES198/199, the tone). The tone axis stands whole for mono and stereo, and its named horizon — a true in-loop damped-comb primitive — wants genuinely new arithmetic rather than a clean composition. So this rung opens a **fresh reverb axis** that a reader can build purely by composing proven stages: **how long the tail is heard**.

A real **gated reverb** reverberates a source into a big room, then slams a noise gate across the reverberant tail so the quiet decay below a chosen threshold is pushed toward silence, leaving only the loud early wash — the abrupt, dramatic drum sound every console has named since the eighties (the Phil Collins snare). By Lindy-first, crux-first this is a high-Lindy, tractable move: a famous, durable effect a keeper reaches for often, and a **clean composition of proven pieces** — ALES190's named-room wet and ALES49's downward gate.

## The shape — reverberate the span wet, then gate the tail

`reverb_gate(clip, clk, room, start_ms, count_ms, threshold, ratio_num, ratio_den)`:

1. Validate the clock; **pre-check the gate's threshold and ratio with the same guards ALES49's gate raises** (a threshold in `[1, sample_max]` → `BadThreshold`; a ratio at least one with a nonzero denominator → `BadRatio`) **before any write**, so a bad gate leaves the clip *dry* (the atomicity crux — the precedent ALES192's `reverb_mix` set by validating its knob inline up front).
2. Convert the span through ALES5's clock (forwarding `DurationTooLong`) and range-check it (`BadRange`) before any write.
3. Run ALES190's `reverb_preset` over the span — the **wet**, in place, unchanged.
4. Gate the wet span through ALES49's `gate` — the below-threshold decay pushed down by the ratio, the loud early wash passing byte-for-byte.

## The provable laws the witness proves

1. **THE IDENTITY EDGE (`ratio_num == ratio_den`)** — equals ALES190's `reverb_preset` over the span, byte for byte. A unit-ratio gate is exactly the un-gated reverb, at any threshold.
2. **IT EQUALS ITS COMPOSITION** — for a firm ratio (8:1) at a mid threshold, `reverb_gate` equals `reverb_preset` then `gate`, byte for byte; and the gated tail differs from the un-gated wet.
3. **THE TAIL IS GATED** — the gated tail's total energy (summed magnitude) is strictly less than the un-gated wet's. A gate pushes the quiet decay down, so the tail carries less energy than it did.
4. **SILENCE STAYS SILENCE** — an all-zero clip at any gate stays all zeros.
5. **THE FAULTS FORWARD, ATOMIC** — a bad threshold refuses `BadThreshold` and a bad ratio `BadRatio`, each with the clip **untouched (still dry)**; a span past the clip `DurationTooLong`; an out-of-range span `BadRange`; each by name before any write.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `Clip`, a validated clock, and ALES190's fixed banks, siloed to `lotus/`. No new audio arithmetic — the gate is ALES49's proven downward gate over the proven wet. A **wet-tail** gate: a single downward gate over the whole reverberant span, the honest first gated-reverb knob. A true **time-following envelope gate** (an attack/hold/release that opens on the transient and closes over the decay, so the cut has a shaped edge) is a richer, separate rung that wants the ALES gate-envelope primitive carried onto the wet — named here as a horizon, not claimed. No socket, no network, no keys, no funds, no real device. No custody gate reached — a self-approved design round.

## Next after this

A **stereo gate** (the same gate over both channels of a `StereoClip`, one shared threshold and ratio, the image held) is the thin twin the ladder always closes next. Beyond the pair, the shaped **envelope-gate** rung above, or a further reverb axis (width, freeze, or early/late balance), each remains open.
