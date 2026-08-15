# Fill ALES153 — Lotus's stereo_smooth_runs: the run-length smoother carried into stereo, two independent hysteresis holds

**Stamp:** `20260815.055925` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES153
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-055202_fill-ales152-lotus-stereo-collapse-silence.md`](20260815-055202_fill-ales152-lotus-stereo-collapse-silence.md)

---

## The next crux, honestly chosen

ALES101 (`smooth_runs`) is the smoothing hysteresis ALES95 named as a later rung: absorb every run shorter than a minimum into what surrounds it, so a one-frame tick inside a pause no longer splits it and a spurious quiet frame inside speech no longer spares a click. It is the decisive robustness move that turns a per-frame reader into a usable segmenter. Carrying it into stereo is the ascending Lotus crux after the silence-edit family (ALES148–152), and the natural companion to ALES147's stereo segmenter — a stereo VAD wants its per-channel flicker smoothed before any stereo trim reads it.

## Not the edit wall — the analysis shape

The silence *edits* (ALES148–152) all met one wall: they change length, and the two channels' silences are independent, so per-channel editing desyncs the pair. `smooth_runs` is **read-only over the labels** — it rewrites a run-length sequence and touches no PCM, changing no clip length. So it meets no desync wall. Its honest stereo shape is the **analysis-corner** one, exactly as ALES146 (`stereo_voiced`) and ALES147 (`stereo_segment`) took: run the proven mono reader on **each channel independently**, keeping the two results apart in a `StereoSegments{left, right}`. The two channels flicker independently, so they smooth independently — a tick on the left is absorbed by the left's neighbours, never the right's.

## The shape

`smooth_runs_stereo(in: *const StereoSegments, out: *StereoSegments, min_run)`:

1. Run ALES101's proven mono `smooth_runs` on `in.left → out.left`, then on `in.right → out.right`, with the one shared `min_run`.
2. Each channel inherits every one of ALES101's laws — coverage, coalesced, hold, idempotence, monotonicity — because each channel *is* a mono smooth.

`StereoSmoothError = smooth_runs.SmoothError` — reused whole, no new fault (the honest, unreachable `SegmentsFull` ALES101 keeps).

## The laws proven

- **The stereo smooth law (the crux):** each channel's smoothed runs equal ALES101's mono `smooth_runs` on that channel, run for run, across a grid of `min_run` values and several per-channel input shapes.
- **The independence law:** the two channels smooth apart — a left carrying a short blip and a right carrying none yield different run counts, each correctly smoothed; identical channels smooth identically.
- **The well-formed law (per channel):** each output tiles the same span (coverage), no adjacent runs share a verdict (coalesced), and every run past the first meets `min_run` (the causal hold) — checked as data on both channels.
- **The degenerate law:** `min_run = 0` is the identity on both; an empty channel stays empty; a single-run channel is unchanged; a `min_run` past a channel's whole span coalesces it to one run.

## Scope

Purely local, siloed to `lotus/`, read-only over the labels — a bounded rewrite of two run-length sequences, touching no PCM on either speaker. A causal left-to-right minimum-duration hold per channel, NOT the symmetric two-sided smoothing or adaptive floors a production VAD would add; not a transcript or a diarization; no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
