# Fill ALES188 — Lotus's reverb in real time (`reverb_ms`)

**Stamp:** `20260815.094453` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — a thin real-time twin over a proven tool, no new arithmetic on the audio path, no custody gate reached
**Waymark:** ALES · **Rung:** ALES188 · **Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite)
**Kin:** [`../lotus/reverb.rye`](../lotus/reverb.rye) (ALES186) · [`../lotus/clock.rye`](../lotus/clock.rye) (ALES5) · [`../lotus/multitap_time.rye`](../lotus/multitap_time.rye) (ALES69) · [`../lotus/echo_time.rye`](../lotus/echo_time.rye) (ALES67)

## The crux chosen

ALES186 seated the reverb — Schroeder's network, parallel combs summed then diffused through series allpasses — and ALES187 carried it into stereo. Both name every comb and allpass delay in sample **indices**. A keeper names a room in **time**: a hall's pre-delays and decays are milliseconds, not sample counts. reverb.rye's own header already named this exact rung as the road ahead — *"a real-time twin `reverb_ms` through the ALES5 clock is a later rung, exactly as echo_ms followed the index-named echo"* — and ALES187's session log recommended it as the next Lindy-first crux.

By Lindy-first, crux-first: the real-time face is the most durable next move (a musician reaches for milliseconds, not sample counts, on the ten-thousandth day) and the most tractable (it invents no new sample law — every sample is still written by ALES186's proven network). It is the finishing edge for the whole time-based reverb family: with `reverb_ms` standing, the reverb speaks the keeper's own units.

## The shape — the family's signature

`reverb_ms` mirrors `multitap_ms` (ALES69) exactly, because the reverb, like the multi-tap, carries a **bank** of delays rather than one:

1. **Check the bank counts first** — `NoCombs` on an empty comb bank, `TooManyStages` on either over-long bank — *before any conversion*, so the two bounded stack banks (`[reverb.max_stages]`) always hold their stages and the clip is untouched on a bad count. This mirrors `multitap_ms`'s tap-count check.
2. **Convert each stage's `delay_ms`** through ALES5's `clock.samples_for` into an index-named `CombSpec` / `AllpassSpec`, feedback and gain carried unchanged.
3. **Convert `start_ms`, `count_ms`.**
4. **Delegate to ALES186's `reverb` unchanged** — the same network, now named in real time. The reverb re-validates the whole bank atomically, so a fault in a late stage still leaves the clip untouched.

The law: **the clock adds only the units, never the audio.** So the millisecond-named reverb lands byte-for-byte the same samples as the index-named reverb over the converted delays and span. A stage delay too short to be one whole sample converts to 0, which ALES186 already refuses `BadDelay` — a sub-sample stage refuses honestly rather than silently doing nothing.

## Five laws the witness proves

1. **The clock adds only units** — at 1 sample/ms, `reverb_ms` over ALES186's own two-comb + one-allpass network equals the index-named reverb byte-for-byte, and equals ALES186's hand value `[-8000,0,10000,-1333,8000,2000,5056,1000]`. Both tools run.
2. **A real rate converts honestly** — at 48 kHz, 1 ms → 48 samples; a single comb's first recirculation sits exactly at index 48, matching the index-named reverb at delay 48.
3. **A sub-sample comb refuses BadDelay** — 0 ms → 0 samples, refused by name, the clip untouched.
4. **A stage delay past the clip refuses DurationTooLong** — an allpass delay past `max_clip` refused during conversion (a valid comb ahead of it, so the fault forwards from the allpass, not only the first stage).
5. **The reverb's bank faults forward** — `NoCombs`, `TooManyStages`, `BadGain` (unity feedback), `BadRange` (out-of-range span), each by name, the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM in one clip, a validated clock, two bounded stack banks. No socket, no network, no keys, no funds, no real device — the clock is a samples-per-second count, not a hardware claim; feedbacks and gains are plain fractions, not room sizes in seconds. No new arithmetic on the audio path. **No custody gate reached** — a self-approved design round.

## The next crux

With the reverb named in real time in mono, its stereo twin `stereo_reverb_ms` (each channel's shared bank converted once, then ALES187's `stereo_reverb`) is the thin next rung, exactly as `stereo_echo_time` followed `echo_time`. A named-room preset (a curated hall/room/plate bank of `CombSpecMs`/`AllpassSpecMs`) is the higher-Lindy move once the timed face stands on both channels.
