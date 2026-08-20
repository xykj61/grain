# Fill ALES218 — Lotus's stereo render (an effect chain over two channels becomes a stereo .wav)

**Stamp:** `20260815.132120` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Vision -- Self-approved design round (agent-doable · purely local byte work · no custody gate)
**Season:** the Six-Season double-seat, Season C thread (Lotus · the creative suite) · waymark **ALES** · rung **ALES218**
**Kin:** [`20260815-131432_fill-ales217-lotus-render.md`](20260815-131432_fill-ales217-lotus-render.md) · [`../lotus/render.rye`](../lotus/render.rye) · [`../lotus/stereo_wav.rye`](../lotus/stereo_wav.rye) · [`../lotus/pan.rye`](../lotus/pan.rye)

---

## The crux this round takes

ALES217 rendered a mono Clip through an effect chain into a canonical `.wav`. Yet a Lotus master is a **StereoClip** (ALES10) — two mono Clips heard together, whose defining invariant is that left and right hold the **same length**. The reverb, width, and pan families each closed their axis whole across both channels; the mono render owes the same completeness, so a keeper who placed a stereo image can render *that* to a stereo file rather than folding it to mono first.

`render_stereo` is the mono→stereo twin of ALES217, and it is a pure composition: it reuses ALES217's own `Step`, `check_step`, and `apply_step` **verbatim**, applying each proven step to both channels, then encodes the two channels interleaved through ALES216's `stereo_wav` container. It invents no new effect and no new check — it only widens the render to the second channel.

## The shape — a StereoClip in, an interleaved stereo .wav out

- `render_stereo(sample_rate, sc, steps, out) StereoRenderError!u32` — validate the whole request first against the balanced length (chain length, sample rate, output size, and every step's span, checked once because both channels share one length), **then** apply each step to `sc.left` and `sc.right` in order, **then** encode the two channels interleaved `L₀ R₀ L₁ R₁ …` into `out`, returning the byte length.

The chain type is ALES217's `render.Step`, imported, not redefined — one definition for both renders. The per-channel work is ALES217's `render.check_step` and `render.apply_step`, reused so the mono and stereo renders can never drift in what a step means.

## THE BALANCED PROMISE

A StereoClip enters balanced (left and right equal length), and gain, fade, and invert each preserve a Clip's length. So the same step applied to both channels keeps them equal-length by construction, and the whole request is checkable against that one shared length before a sample moves. ALES217's atomic promise carries over unchanged: a faulty chain refuses **by name** and leaves **both channels byte-for-byte unchanged**, nothing written to `out` — and the two channels stay balanced through every legal render.

## The provable laws the witness proves

1. **THE STEREO-RENDER LAW** — a StereoClip through a real chain (per-channel gain, fade, invert) encodes to a stereo `.wav` that decodes back **byte-for-byte on each channel** to the same chain applied to each channel by hand, the rate preserved.
2. **THE INDEPENDENT-CHANNEL LAW** — each channel renders exactly as ALES217's mono render would render that channel alone: a stereo render is two mono renders sharing one container, proven by comparing each decoded channel against a mono render of the same source.
3. **THE BALANCE LAW** — every legal render leaves the two channels equal length (the StereoClip invariant held end to end).
4. **THE EMPTY-CHAIN LAW** — a bare chain renders both channels unchanged.
5. **THE ATOMIC-FAULT LAW** — a faulty step refuses by name (`BadRange`, `BadGain`) leaving both channels byte-for-byte unchanged and nothing written.
6. **THE OUTPUT-BORDER, STEP-BOUND, and BAD-RATE LAWS** — an output buffer too small refuses `OutputTooSmall`, a chain past `max_steps` refuses `TooManySteps`, a wild rate refuses `BadSampleRate`, each before any effect runs.
7. **THE EMPTY-CLIP LAW** — a zero-frame StereoClip renders to a valid 44-byte stereo header and decodes back to zero frames.

## Honest scope

Software only, purely local byte work — the same as ALES217, widened to two channels and the interleaved container. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device or speaker. The stored sample rate is a carried field, not a real clock. Siloed to `lotus/`. **No custody gate.**

## Next after this

With mono and stereo render both standing, the render family is whole. The natural next rung: a **named preset chain** a keeper loads by name (a `Step[]` fetched from a small catalog), or a **render-to-container** that writes any of the family's other outputs — each its own self-approved design round.
