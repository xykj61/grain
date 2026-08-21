# Fill ALES152 — Lotus's stereo_collapse_silence: the interior silence-capper carried into stereo, the first stereo edit that keeps its cuts

**Stamp:** `20260815.055202` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- a design round that proposes; no witness binds its claims yet.
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · **Waymark:** ALES · **Rung:** ALES152
**Kin:** [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`20260813-020035_double-seat-expansion-six-seasons.md`](20260813-020035_double-seat-expansion-six-seasons.md) · [`20260815-051802_fill-ales148-lotus-stereo-trim-silence.md`](20260815-051802_fill-ales148-lotus-stereo-trim-silence.md)

---

## The next crux, honestly chosen

ALES148 carried the silence stripper into stereo — the first stereo edit whose cut is *decided* rather than given, cutting only the frames silent in both channels so the image never tears. ALES100 (`collapse_silence`) is the mono edit that stands directly on the stripper: instead of removing every silent run, it caps each one to a maximum, keeping the pauses yet shortening the long ones — the single most-reached-for gesture in every voice-memo cleanup, "truncate silence to a quarter-second." Its whole honesty is the **zero-cap law**: `collapse_silence(max=0)` equals `trim_silence` byte for byte.

Carrying `collapse_silence` into stereo is the Lindy-first crux after ALES148/149/150/151: it completes the silence family's most useful editorial gesture on a real stereo master, and it inherits ALES148 as its zero-cap twin, so it can never drift from the stripper it caps down to.

## The wall, and the honest rule

A stereo master is a `StereoClip` (ALES10) whose defining invariant is that left and right hold the **same length**, and ALES147 proved the two channels' silences are **independent** — they differ in count and boundary. Run the mono capper on each channel apart and the two speakers cap different runs to different lengths: the pair desyncs and the stereo image tears, exactly the wall ALES148 met.

So this rung decides **one cap for both**. The rule is the **joint-silence cap**: read the jointly-silent frames through ALES148's own intersection (a frame is dead air only where *neither* speaker carries sound), coalesce consecutive jointly-silent frames into jointly-silent **runs**, and for each run longer than `max_silence` cut only the **excess** — keep the run's first `min(count, max_silence)` samples, cut the rest — from both channels in lockstep, walking back to front. A frame silent in only one channel is kept whole (its other speaker carries sound); only the shared dead air is shortened, and only its excess is cut, so the breath that makes speech legible stays.

## The shape

`stereo_collapse_silence(sc, frame_len, t_low, t_high, silence_floor, voice_split, max_silence)`:

1. Segment **both** channels once through ALES147's `segment_stereo` over one shared frame grid — read-only, all validation up front (band/span precheck, floor ceiling, dividing frame length, empty-clip `BadFrame`). On refusal both channels are untouched.
2. **Forward pass** — walk the frames, advancing one monotonic cursor per channel across its own tiling run list, marking a bounded jointly-silent mask (`[max_clip]bool`, sized once) only where the frame is `.silent` in both channels; coalesce consecutive marked frames into runs and count the excess over `max_silence` for the exact length postcondition.
3. **Backward pass** — for each jointly-silent run longer than `max_silence`, cut the excess (keeping `min(count, max_silence)` samples) from both channels through ALES2's `cut`, back to front so earlier run indices stay valid, the in-bounds span asserted before each cut so neither can fault and leave the pair half-capped.

`StereoCollapseError = stereo_segment.StereoSegmentError || timeline.EditError` — reused whole, no new fault; `max_silence` is a plain count with no illegal value (a huge cap keeps every joint pause whole).

## The laws proven

- **The zero-cap law (the crux tie):** `stereo_collapse_silence(max=0)` equals ALES148's `stereo_trim_silence` byte for byte on both channels, across many frame lengths, floors, and splits — capping every joint-silent run to zero removes all joint silence, exactly the stereo stripper.
- **The cap law:** the result equals a by-hand keep where each jointly-silent run keeps its first `min(count, max_silence)` samples and every other frame stays whole, per channel, both channels leaving equal length; a cap past the longest joint run leaves the master unchanged; monotone in `max_silence`.
- **The lockstep law:** running the proven mono `collapse_silence` per channel caps different runs and desyncs the pair, where the stereo capper holds both at one length.
- **The atomicity / degenerate law:** an all-jointly-silent master caps its one coalesced run (empty at 0, unchanged past its length); a master with no joint silence is unchanged on both; an empty clip, a ragged frame length, an inverted band, and an illegal floor each refuse by name with both channels untouched and still balanced.

## Scope

Purely local, siloed to `lotus/`. Two bounded i16 Clips edited only by removing whole excess-silent frames from within each jointly-silent run through `cut`, in lockstep — fabricating no samples, reordering nothing, never touching a non-silent sample or the kept head of any joint pause. NOT a transcript or a real adaptive VAD; no real sample rate, no network, no keys, no funds, no real speaker. No custody gate reached — a self-approved design round.
