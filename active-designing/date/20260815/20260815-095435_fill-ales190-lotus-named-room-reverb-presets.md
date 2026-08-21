# Fill ALES190 — Lotus's named-room reverb presets (`reverb_preset`)

**Stamp:** `20260815.095435` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round — a curated constant bank over a proven tool, no new arithmetic on the audio path, no custody gate reached
**Waymark:** ALES · **Rung:** ALES190 · **Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite)
**Kin:** [`../lotus/reverb_time.rye`](../lotus/reverb_time.rye) (ALES188) · [`../lotus/stereo_reverb_time.rye`](../lotus/stereo_reverb_time.rye) (ALES189) · [`../lotus/reverb.rye`](../lotus/reverb.rye) (ALES186)

## The crux chosen

ALES186–189 built the reverb network whole: mono, stereo, and both real-time faces. Yet the network is bare — a caller must hand it a whole bank of comb and allpass specs. A musician does not think *"four combs at 25, 27, 29, 31 ms with feedbacks 7/10"*; a musician thinks *"a hall," "a room," "a plate."* By Lindy-first, crux-first, this is the highest-Lindy move in the reverb arc: it turns the raw network into an instrument a keeper reaches for by name, read thousands of times over years.

## The shape — a preset is exactly its named bank

`reverb_preset(clip, clk, room, start_ms, count_ms)`:

1. **`Room`** is an enum of three named rooms — `room` (small, close, quick), `hall` (large, spacious, long), `plate` (dense, bright, metallic).
2. Each room's bank is a **published compile-time constant** of `CombSpecMs` / `AllpassSpecMs` (ALES188's own spec types), tuned as bounded honest constants — delays in milliseconds, feedbacks and gains named fractions strictly below unity so every stage decays.
3. `bank_for(room)` returns that room's combs and allpasses — the single source of truth a preset and its witness both read.
4. `reverb_preset` picks the bank and **delegates to ALES188's `reverb_ms` unchanged**.

The law, the family's signature made higher: **a preset is exactly its named bank, nothing more.** It invents no new arithmetic and no new fault — `ReverbPresetError = reverb_time.ReverbTimeError`, forwarded whole. Because the banks are named in milliseconds, one preset sounds the same room at any sample rate.

## Five laws the witness proves

1. **A preset is its named bank** — for every room, `reverb_preset` equals `reverb_ms` called with that room's published bank, byte-for-byte. (This is the honest provable claim: there is no external reference reverb, but a preset *is* reproducibly its documented bank.)
2. **The rooms differ** — hall, room, and plate over one impulse are three genuinely different washes, not three names for one bank.
3. **Each room decays** — every preset's tail settles to silence within a long-enough clip (every stage below unity, so the composition settles).
4. **Silence stays silence.**
5. **The underlying faults forward** — a span past the clip `DurationTooLong`, an out-of-range span `BadRange`, each leaving the clip untouched.

## Honest scope

Software only, purely local. Bounded in-process i16 PCM, a validated clock, three fixed compile-time banks each within `reverb.max_stages`. No new arithmetic on the audio path — a constant bank, then the proven timed reverb. The room names are a keeper's word for a tuning, not a claim about any real hall; the delays are milliseconds, the feedbacks and gains named fractions, none a decibel or a room size in metres. **No custody gate reached** — a self-approved design round.

## The next crux

A **stereo named-room preset** (`stereo_reverb_preset`, the same banks through ALES189's `stereo_reverb_ms`) is the thin twin. Beyond that, a **wet/dry mix** control — blending the reverberated span with a snapshot of the dry — is the next genuinely new expressive knob the reverb wants, nameable as a fraction over any of these presets.
