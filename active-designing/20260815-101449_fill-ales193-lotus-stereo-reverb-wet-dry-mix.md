# Fill ALES193 — Lotus's stereo reverb wet/dry mix

**Stamp:** `20260815.101449` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES193**
**Kin:** [`20260815-100815_fill-ales192-lotus-reverb-wet-dry-mix.md`](20260815-100815_fill-ales192-lotus-reverb-wet-dry-mix.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

ALES192 gave the mono reverb its most-reached-for knob — **how much reverb**, the wet/dry balance that sits a voice in a room without drowning it. Its own recommend, and the recommend before it, named the twin plainly: *a stereo wet/dry mix — the same blend over both channels of a `StereoClip`, image held.* This rung is that twin, exactly as ALES191 followed ALES190 and ALES189 followed ALES188.

By Lindy-first, crux-first this is the highest-Lindy tractable move on the reverb thread: the wet/dry balance is the single most-reached-for reverb control, and a stereo master is what a mixing keeper actually places a voice into. The stereo mix completes the wet/dry pair for the whole reverb family.

## The shape — snapshot both dry channels, wet in place, blend each span

`stereo_reverb_mix(sc, clk, room, start_ms, count_ms, mix_num, mix_den)`:

1. Assert the channels enter balanced (`sc.left.len == sc.right.len` — the defining `StereoClip` invariant) and the clock is valid; validate the mix fraction (`0 ≤ num ≤ den`, `den ≥ 1` — else `BadMix`).
2. Convert the span through ALES5's clock (forwarding `DurationTooLong`) and validate it against the channel length (`BadRange`) **before any write** — so the two dry snapshots read only in-bounds and a refusal leaves both channels untouched.
3. **Snapshot the dry span of each channel** into two bounded stack buffers (`max_clip` = 4096 samples each).
4. Run ALES191's `stereo_reverb_preset` over the span — the **wet**, in place, unchanged, both channels reverberating their own audio through one shared named bank.
5. **Blend** each sample of each channel independently: `out[i] = saturate((den−num)·dry[i]/den + num·wet[i]/den)` — the same linear wet/dry balance ALES192 proved, applied per channel, saturating once to the i16 rail.

## The provable laws the witness proves

1. **THE DRY EDGE (mix = 0)** — `mix_num = 0` restores both spans to the exact dry: each channel byte-for-byte unchanged. The knob fully closed is the identity, both ears.
2. **THE WET EDGE (mix = den)** — `mix_num = mix_den` equals ALES191's `stereo_reverb_preset` over the span, byte for byte on both channels. The knob fully open is exactly the stereo preset.
3. **THE BLEND IS BETWEEN** — a half-open mix differs from both the pure dry and the pure wet on each channel, and each blended sample is the honest weighted average of the two (proven against a hand-computed value on both channels).
4. **THE IMAGE IS HELD** — a centred master (`left == right`) stays identical channel-to-channel through any mix (one shared bank, one blend fraction); a genuinely stereo master keeps its channels distinct (no crossing).
5. **THE CHANNELS LEAVE BALANCED** — after every mix `sc.left.len == sc.right.len`, and silence stays silence on both channels.
6. **THE FAULTS FORWARD** — a span past the clip refuses `DurationTooLong`, an out-of-range span `BadRange`, a bad fraction (`den = 0` or `num > den`) `BadMix`, each by name with both channels untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one `StereoClip`, a validated clock, ALES191's fixed banks, and two bounded stack snapshots, siloed to `lotus/`. The one arithmetic is ALES192's proven linear blend — a weighted average of two i16 spans, summed in i64 and saturated once, so it can never wrap — now run per channel with no cross-channel read. The mix is a named fraction, not a decibel. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

With the wet/dry pair complete for both mono and stereo, the reverb family reaches for a **pre-delay** (a silent gap before the wet onset, sitting the room a hair behind the dry) or a **damping** knob (a one-pole lowpass in the comb feedback, so the tail darkens as it decays) — either a genuinely new expressive control on the proven network. The mono rung leads, the stereo twin follows.
