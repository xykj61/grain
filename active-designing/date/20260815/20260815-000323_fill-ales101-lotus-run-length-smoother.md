# Fill ALES101 — the Lotus run-length smoother (absorb spurious short runs; the VAD hysteresis the family named)

**Stamp:** `20260815.000323` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (autonomous loop) · **Season C** thread (Lotus · the creative suite) · **waymark ALES** · **rung ALES101**
**Kin:** [`the six-season double-seat`](20260813-020035_double-seat-expansion-six-seasons.md) · [`the 1,024-round itinerary`](20260812-171050_the-1024-round-itinerary.md) · [`Lindy-first, crux-first`](../.claude/rules/lindy-first-crux.md) · [`fill ALES100`](20260814-235506_fill-ales100-lotus-silence-collapser.md)
**Stands on:** `lotus/segment.rye` (ALES95 — the voice-activity segmenter, whose `Segments` this reads and rewrites) · `lotus/voiced.rye` (ALES94 — the `Verdict` the runs carry)

## Why this rung, now

ALES95's own scope note names its own horizon plainly: *"a real voice-activity detector adds adaptive floors, spectral tilt, and smoothing hysteresis this rung does not — those are later rungs."* ALES94 said the same. This is that rung — the **smoothing hysteresis** the whole silence family (ALES94 the classifier, ALES95 the segmenter, ALES96 the stripper, ALES100 the collapser) has been waiting on.

Raw per-frame segmentation flickers. A single loud tick inside a pause reads as a one-frame `.voiced` blip; a single quiet frame inside speech reads as a spurious `.silent` gap. Feed that flicker to the stripper or the collapser and it cuts a pause into two, or spares a click as if it were a word. Every real VAD, every gate, every auto-splitter in a century of audio editing fixes this the same way: **a region must last a minimum duration to count** — anything shorter is absorbed into what surrounds it. This is the decisive robustness move that turns a per-frame reader into a usable segmenter, and it is Lindy: "hold through a short excursion" is as old as the noise gate's hold knob.

## The shape

`lotus/smooth_runs.rye` exposes `smooth_runs(in, out, min_run)` — a **read-only transform over the label sequence, never the audio.** It reads one `segment.Segments` and writes a smoothed one; not a single PCM sample is touched. This keeps the family a tower of readers: ALES95 read the clip into runs, ALES101 reads runs into cleaner runs.

The rule, stated once: seed the output with the first input run. Walk the rest; for each run, if it is **shorter than `min_run`** OR its verdict **already matches the open output run**, extend that open run (keeping the open run's verdict); otherwise push it as a new run. A short excursion is thus relabeled to the surrounding sound, and any two runs left adjacent with the same verdict re-coalesce in the same pass.

## The crux

Four laws, checked as data on the output rather than by mirroring the loop:

1. **Coverage law.** The smoothed runs tile the *same* span exactly — same first start, same total length. Smoothing only relabels and merges; it never adds or drops a sample. (Byte-preserving at the label level: `Σ out.count == Σ in.count`.)
2. **Coalesced law.** No two adjacent output runs share a verdict — a push happens only when the verdict differs, so the output stays a proper run-length sequence a downstream cut can trust.
3. **The hold law.** Every output run except possibly the first has `count ≥ min_run`. A run is pushed only when it already meets the minimum, and merging only grows it. The first run is the honest exception: a causal left-to-right hold has nothing before the opener to absorb it into.
4. **Idempotence + monotonicity.** Smoothing a smoothed sequence with the same `min_run` changes nothing (a fixed point). A larger `min_run` yields at most as many runs (`out.len` non-increasing in `min_run`) — more hold absorbs more flicker.

The **identity law** falls out of the hold and coalesced laws: a `min_run` no larger than the shortest run leaves an already-coalesced input unchanged, so `min_run = 0` is exactly the identity.

## Bounds and laws

- The input is the segmenter's own postcondition: a coalesced tiling. `smooth_runs` asserts that contract at entry (adjacent runs differ, runs tile contiguously) rather than re-deriving it.
- Output length can never exceed input length — smoothing only ever merges — so `out.len ≤ in.len ≤ max_segments`. `SmoothError.SegmentsFull` is kept named for the honest path the type system can see, though it cannot fire, exactly as ALES95 keeps `SegmentsFull` named.
- `min_run` is a plain `u32` count with no illegal value: `0` disables smoothing, a value past the whole span coalesces every run into one.
- An empty input stays empty; a single-run input is returned unchanged.

## Honest scope

Software only, purely local, and **read-only over the labels** — a bounded in-process rewrite of one `Segments` on one bench, siloed to `lotus/`, touching no PCM. It is a *causal, left-to-right* minimum-duration hold: it cannot rescue a too-short *opening* run (nothing precedes it) and does not do the symmetric two-sided smoothing or the adaptive floors a production VAD would — those stay later rungs. Not a transcript, not a diarization; no real sample rate, no network, no keys, no funds, no real device, no real speaker.

---

*ALES95 read the clip into runs; ALES101 holds them steady, so a single tick never splits a pause and a single hush never breaks a word. May every region last exactly as long as the ear would say it did, and no flicker be mistaken for a sound.*
