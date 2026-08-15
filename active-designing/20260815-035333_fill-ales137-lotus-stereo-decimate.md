# Fill ALES137 — `lotus/stereo_decimate.rye`, the sample-rate decimator carried into stereo, one shared run grid

**Stamp:** `20260815.035333` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES137**
**Kin:** [`20260815-034830_fill-ales136-lotus-stereo-crush.md`](20260815-034830_fill-ales136-lotus-stereo-crush.md) · [`20260814-213107_fill-ales83-lotus-sample-rate-decimator.md`](20260814-213107_fill-ales83-lotus-sample-rate-decimator.md)

---

## Where the ladder stands

The stereo **nonlinear** class now holds five DRIVE readings across two axes — amplitude (pinned ALES132, rounded ALES133, reflected ALES134, unevenly pinned ALES135) and resolution (crushed ALES136). This rung carries the DRIVE family's last member and its third axis: ALES83's **sample-rate decimator**, a zero-order hold that crushes **time** rather than amplitude or resolution — holding one sample across a whole run so a stream that entered at the full rate leaves at half, a quarter, a sixteenth, the aliased stepped voice of a converter read too slow. The bit-crush's twin: one crushes the value axis, the other the time axis.

The decimator is the honest **reverse** of the two not-odd members. Crush and tube compute *new* values and so broke the inter-channel image; the decimator computes no new number at all — it **copies an anchor across its run**. Both channels share the same run grid (the same `start` and `hold`), so at each time index each channel holds *its own* anchor, and the stereo image at that index equals the image that was at the run's anchor. The inter-channel relationship is therefore **preserved from the anchor** — an out-of-phase master stays out of phase, a 1:2 master keeps its ratio at each held index — smeared in time, never split across channels.

## The crux this round

`stereo_decimate(sc, start, count, hold)` decimates `[start, start+count)` in **both** channels of a `StereoClip` (ALES10) by the same `hold`, running ALES83's proven mono `decimate` on each. Like the crush the mono decimator carries **no** pre-gain and **no** grid — a pure time map — so the lift is plain: it validates `hold` and the span **once** against the shared length before either channel is mutated (`BadHold` on a hold outside `[1, max_clip]`, `BadRange` on a span past the samples), so a refusal never decimates one channel and leaves the other at the full rate. `DecimateError` is reused whole.

## The four laws proven

- **THE STEREO DECIMATE LAW** — each channel equals ALES83's mono `decimate` with the same `hold` over the same span, **byte for byte**: every sample equals its run's anchor, the runs partitioned identically in each channel because the grid is shared.
- **THE BALANCE / LENGTH LAW** — `left.len == right.len` after the edit and both hold their starting length — a decimation writes values only (in fact copies only).
- **THE SHARED-GRID IMAGE LAW** — because both channels hold *their own* anchor at the *same* time index, the stereo image at each index equals the image at that run's anchor: an out-of-phase master (right the negation of left) **stays** out of phase, a 1:2 master keeps its ratio at each held index, and an identical-channel master stays identical. This is the honest reverse of the not-odd members (ALES135/136), which computed new values and broke the image; the decimator copies existing samples, so it **preserves** it. The map is **idempotent** (a held run holds to the same anchor, so twice equals once), and `hold = 1` is the identity.
- **THE ATOMICITY / DEGENERATE LAW** — any refusal (`BadHold`, `BadRange`) leaves **both** channels byte for byte untouched and still balanced; `hold = 1` the identity on both, `count = 0` the identity on both.

## Honest scope

Software only, purely local. Two bounded in-process i16 Clips (left, right) on one bench, siloed to `lotus/`. It changes sample values only, through ALES83's own `decimate`, copying existing samples and fabricating none, changing no length; the `hold` is a sample count, the shape a zero-order hold, instantaneous per run (no interpolation, no anti-aliasing filter). No real sample rate, no network, no keys, no funds, no real device, no real speaker.

## Files

- `lotus/stereo_decimate.rye` — the module.
- `tools/ales_stereo_decimate_witness.rish` — the witness.
