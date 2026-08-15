# Fill ALES189 — Lotus's stereo reverb in real time (`stereo_reverb_ms`)

**Stamp:** `20260815.095002` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round — a thin real-time twin over a proven tool, no new arithmetic on the audio path, no custody gate reached
**Waymark:** ALES · **Rung:** ALES189 · **Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite)
**Kin:** [`../lotus/stereo_reverb.rye`](../lotus/stereo_reverb.rye) (ALES187) · [`../lotus/reverb_time.rye`](../lotus/reverb_time.rye) (ALES188) · [`../lotus/stereo_echo_time.rye`](../lotus/stereo_echo_time.rye) (ALES182) · [`../lotus/clock.rye`](../lotus/clock.rye) (ALES5)

## The crux chosen

ALES187 carried the reverb into stereo (the same comb-and-allpass bank on both channels, each channel through its own network), naming every delay in sample **indices**. ALES188 gave the mono reverb its real-time face. stereo_reverb.rye's own header named this exact rung — *"a real-time stereo twin through the ALES5 clock is a later rung, exactly as stereo_echo_time followed stereo_echo."* By Lindy-first, crux-first, this is the thin next move that completes the timed reverb family: with `stereo_reverb_ms` standing, the reverb speaks the keeper's own units on both channels.

## The shape — two families fused

`stereo_reverb_ms` fuses the two patterns the ladder has already proven:

- **The two-bank conversion** of ALES188's `reverb_ms` — check the bank counts first (`NoCombs`/`TooManyStages` before any conversion), convert each comb's and allpass's `delay_ms` through `clock.samples_for` into an index-named bank.
- **The stereo delegation** of ALES182's `stereo_echo_ms` — one shared conversion feeds both channels, then delegate to the proven stereo tool (`stereo_reverb`) unchanged.

It **reuses ALES188's `CombSpecMs` / `AllpassSpecMs`** as the timed spec types, keeping one source of truth for the millisecond-named reverb stage rather than redefining them.

The law: **the clock adds only the units, and the same conversion feeds both channels.** So the millisecond-named stereo reverb lands byte-for-byte the same samples on each channel as the index-named stereo reverb over the converted delays and span, the image held. `StereoReverbTimeError = clock.ClockError || reverb.ReverbError`, no new fault.

## Six laws the witness proves

1. **The clock adds only units** — at 1 sample/ms, both channels equal ALES187's index-named stereo reverb byte-for-byte, the channels genuinely differing.
2. **A real rate converts honestly** — at 48 kHz, 1 ms → 48 samples on both; the first recirculation sits exactly at index 48 on each channel (left 10000→5000, right 6000→3000).
3. **The identical-channel image law** — a centred master stays identical through the timed reverb (an exact panned ratio does not survive the `@divTrunc` recirculation, inherited whole from ALES187).
4. **A sub-sample comb refuses BadDelay** — 0 ms → 0 samples, both channels untouched and balanced.
5. **A stage delay past the clip refuses DurationTooLong** — an allpass delay past `max_clip`, a valid comb ahead of it.
6. **The reverb's bank faults forward** — `NoCombs`, `BadGain` (unity feedback), `BadRange`, each with both channels untouched and balanced; `count_ms = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded i16 Clips, a validated clock, two bounded stack banks. No new arithmetic on the audio path. Changes sample values only, never a length; the channels leave balanced. No cross-channel read, no real sample-rate device, no network, no keys, no funds. **No custody gate reached** — a self-approved design round.

## The next crux

With the reverb named in real time in mono and stereo, the timed reverb family is whole. The higher-Lindy next move is a **named-room preset** — a curated hall/room/plate bank of `CombSpecMs`/`AllpassSpecMs` a keeper reaches for by name (`reverb_preset(clip, clk, .hall)`), turning the raw network into a musician's instrument.
