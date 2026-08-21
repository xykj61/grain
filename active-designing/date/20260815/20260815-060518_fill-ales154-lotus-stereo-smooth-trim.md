# Fill ALES154 — Lotus's stereo_smooth_trim: the smoothed silence trim carried into stereo, two independent silences smoothed then fused into one joint cut

**Stamp:** `20260815.060518` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES154
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-055925_fill-ales153-lotus-stereo-smooth-runs.md`](20260815-055925_fill-ales153-lotus-stereo-smooth-runs.md)

---

## The next crux, honestly chosen

ALES153 carried the run-length smoother (`smooth_runs`) into stereo — read-only over the labels, the two channels smoothing apart. ALES148 carried the *raw* silence trim into stereo through the silence intersection — cut only a frame silent in both channels, so the two speakers leave equal length and the image never tears. The mono ladder already fused these two moves at ALES102 (`smooth_trim`): smooth the runs, *then* strip the smoothed silence, so a short voiced tick in a pause is declicked and a short silent gap in speech is kept. Carrying that fusion into stereo is the ascending Lotus crux — the speech-aware dead-air remover a keeper actually reaches for, now across two speakers without desync.

## The shape — ALES148 reading ALES153's smoothed labels

`stereo_smooth_trim(sc, frame_len, t_low, t_high, silence_floor, voice_split, min_run)` is exactly ALES148 with one line inserted: after segmenting both channels, smooth each channel's runs through ALES153's `smooth_runs_stereo` with the shared `min_run`, then run the silence intersection over the *smoothed* labels instead of the raw ones.

1. Segment both channels once over one shared frame grid (ALES147) — all validation runs here, before any cut.
2. Smooth each channel's runs through ALES153 (`smooth_runs_stereo`), read-only over the labels — no PCM touched, the two channels smoothing apart.
3. Forward pass: mark a frame jointly-silent only where it is `.silent` in **both smoothed** channels.
4. Backward pass: cut every jointly-silent frame from both channels in lockstep, back to front.

ALES101's coverage law guarantees each smoothed run list tiles its channel's span exactly, so every jointly-silent frame is a valid span in both original clips — cut exactly as ALES148 cuts. `StereoSmoothTrimError = StereoSegmentError || StereoSmoothError || EditError` — every fault reused by name, the fusion inventing none.

## The laws proven

- **The stereo smooth-trim law (the crux):** the result equals a by-hand keep of the frames *not* jointly-smoothed-silent, per channel, across five frame lengths, four floors, three splits, and six `min_run` values — both channels leaving equal length, checked against a second implementation.
- **The min-zero law:** `stereo_smooth_trim(min=0)` equals ALES148's `stereo_trim_silence` byte for byte on both channels — identity smoothing collapses the fusion to the raw trim, so this rung is a strict generalization.
- **The declick law:** a short voiced tick jointly buried in silence, at a `min_run` past the tick, is removed on both — strictly shorter than the min-zero trim, the click gone.
- **The keep-gap law:** a short silent gap jointly between speech, at a `min_run` past the gap, is kept on both — strictly longer than the min-zero trim, the breath preserved.
- **The balance / lockstep law:** running the proven mono `smooth_trim` per channel desyncs to lengths 8 and 12, where the stereo smoothed trim holds both at 12 — the stereo image never tears.
- **The degenerate laws:** an all-joint-silent master empties both channels whatever the `min_run`; a master loud on at least one channel per frame is unchanged on both.
- **The atomicity laws:** an empty clip, a ragged frame length, an inverted band, and an illegal floor each refuse by name — `BadFrame`, `BadFrame`, `BadThreshold`, `BadFloor` — before any cut, both channels untouched and still balanced.

## Scope

Purely local, siloed to `lotus/`. This rung writes — it edits both clips — yet only by removing whole jointly-smoothed-silent frames through ALES2's own cut, on both channels in lockstep; the smoothing it adds is read-only over the labels, fabricating no sample and reordering nothing. A causal left-to-right minimum-duration hold per channel, not the symmetric smoothing or adaptive floors a production VAD would add; not a transcript or a diarization; no real sample rate, no network, no keys, no funds, no real speaker. Not monotone in `min_run` — the honest twin of ALES102's own non-monotonicity, now across two independent silences fused into one joint cut. No custody gate reached — a self-approved design round.
