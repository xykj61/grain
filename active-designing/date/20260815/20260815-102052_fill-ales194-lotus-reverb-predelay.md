# Fill ALES194 — Lotus's reverb pre-delay

**Stamp:** `20260815.102052` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local DSP · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES194**
**Kin:** [`20260815-101449_fill-ales193-lotus-stereo-reverb-wet-dry-mix.md`](20260815-101449_fill-ales193-lotus-stereo-reverb-wet-dry-mix.md) · [`../.claude/rules/lindy-first-crux.md`](../.claude/rules/lindy-first-crux.md)

---

## The crux this round takes

With the wet/dry pair complete for both mono and stereo (ALES192 · ALES193), the reverb has *which room* and *how much*. The next control a mixing keeper reaches for is **when** — the **pre-delay**: a short silent gap before the reverberant tail begins, so the room sits a hair behind the dry rather than smearing over its onset. Pre-delay is what separates a voice from its own reverb; on a real console it is the single knob that keeps a busy mix legible.

By Lindy-first, crux-first this is the highest-Lindy tractable move: a genuinely new expressive axis (time, not level or bank), read for years, and a **clean composition of proven pieces** — no new audio arithmetic, only a bounded reindex of ALES190's wet.

## The shape — reverberate wet, then shift the wet onset later within the span

`reverb_predelay(clip, clk, room, start_ms, count_ms, predelay_ms)`:

1. Validate the clock; convert the span through ALES5's clock (forwarding `DurationTooLong`) and validate it against the clip length (`BadRange`) **before any write**.
2. Convert `predelay_ms` through the SAME clock into `predelay` samples; refuse `BadPredelay` if it exceeds `count` (a gap longer than the span is no pre-delay at all).
3. Run ALES190's `reverb_preset` over the span — the **wet**, in place, unchanged.
4. **Snapshot the wet** into a bounded stack buffer, then rewrite the span shifted right by `predelay`: `out[i] = 0` for `i < predelay`, `out[i] = wet[i − predelay]` otherwise. The reverberant tail now begins `predelay_ms` into the span; the last `predelay` samples of tail fall off the span end (honest, bounded truncation).

## The provable laws the witness proves

1. **THE ZERO-DELAY EDGE (predelay = 0)** — equals ALES190's `reverb_preset` over the span, byte for byte. No gap is exactly the un-delayed reverb.
2. **THE FULL-DELAY EDGE (predelay = count)** — the whole wet is shifted off the span end; the span is all zeros. The gap as wide as the region leaves silence.
3. **THE SHIFT IS EXACT** — for `0 < predelay < count`, the first `predelay` samples are zero and the rest are the wet shifted by exactly `predelay`, byte for byte against the un-delayed wet computed side by side.
4. **SILENCE STAYS SILENCE** — an all-zero clip at any pre-delay stays all zeros.
5. **THE FAULTS FORWARD** — a span past the clip refuses `DurationTooLong`, an out-of-range span `BadRange`, a pre-delay past the span `BadPredelay`, each by name with the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one clip, a validated clock, ALES190's fixed banks, and a bounded stack snapshot, siloed to `lotus/`. No new audio arithmetic — the pre-delay is a bounded reindex of the proven wet, so no value is ever recomputed or can wrap; the gap is filled with true zeros. This is a **wet-domain** pre-delay: it delays the reverberant onset within the span; combined with the dry through ALES192's wet/dry mix it is the classic console pre-delay, and that composition is a later rung. The pre-delay is a named duration in milliseconds, so it means the same gap at any sample rate. No socket, no network, no keys, no funds, no real device, no real speaker. No custody gate reached — a self-approved design round.

## Next after this

The **stereo pre-delay** (the same shift over both channels of a `StereoClip`, one shared gap, the image held) is the thin twin, exactly as ALES193 followed ALES192.
