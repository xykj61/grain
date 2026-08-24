# ALES10 -- Lotus's pan, and the second channel

**Stamp:** `20260814.123000` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge (see `../context/GAUGE_STYLE.md`)
**Status:** Living design capture -- the self-approved round after ALES9
**Waymark:** ALES - rung ALES10
**Kin:** [`ALES8 -- the fader column`](20260814-fill-ales8-lotus-fader-column.md) - [`ALES9 -- mute and solo`](20260814-fill-ales9-lotus-mute-solo.md) - [`lotus/pan.rye`](../lotus/pan.rye) - [`lotus/fader.rye`](../lotus/fader.rye) (ALES8)

---

## Why this round

Every rung so far rendered **one** master -- a mono mix. Yet a keeper hears in stereo, and the first stereo gesture on any desk is **pan**: placing each track somewhere between the left and right speaker. Pan is what turns a stack of centered tracks into a field a listener can sit inside.

Lindy-first, crux-first: pan is the **crux** left on the road -- the decisive move that opens the whole second half of the mixer (balance, width, stereo metering, stereo bussing). It is a larger leap than a transport loop (which only re-drives the ALES7 read head) or an equal-power fade curve (which refines ALES4), because it opens the **second channel** -- the architectural step from mono to stereo. Crux-first says take the hardest *still-tractable* move, not the easy lap; pan is exactly that, and it stays tractable because a panned track is nothing more than **two faded contributions**.

## The one crux this rung fixes

**Pan is a pure fraction fold into the fader, so the only sum in the suite stays ALES8's -- run once per channel.** The temptation is to invent a stereo accumulator; the durable move is to reuse the mono one twice. A panned track's left contribution is its fader scaled by a left weight, its right contribution the fader scaled by a right weight. Two fractions compose to one, so each channel is ALES8's `fader.render` over a **pan-folded effective fader column**. No new sum, no new saturation.

The law is the simplest honest one -- a **linear pan**: left weight `den - pos`, right weight `pos`, the two summing to `den`. Its defining invariant, and the sharpest proof the fold is exact:

> **left + right reproduces the mono mix exactly, for any pan position** (on in-range signals).

Because the two weights sum to `den`, each sample's left and right contributions sum back to the un-panned level. This is what a linear (-6 dB-center) pan law preserves -- the **sum** -- as distinct from an equal-power curve, which a later rung may add to preserve **power** instead. Center pan therefore splits a track equally (each side half, the honest -6 dB center dip); hard left routes the whole track to the left channel; and summing the stereo field always returns the mono mix.

Bounds are proven, not trusted: `max_pan_den` bounds the pan denominator, and `side_fader` asserts the fader and pan are within range so the folded numerator (`num x weight`) and denominator (`den x den`) never overflow the fader's `i32`/`u32`.

## The shape

`lotus/pan.rye`:

- `StereoClip` -- two mono `timeline.Clip`s (`left`, `right`); the mono rungs are untouched.
- `Pan` -- a position `pos/den` across the field (0 hard left, `den` hard right, `den/2` center); default center.
- `make(pos, den)` -- validated: `BadGain` on a zero denominator, `BadRange` on a position past the field or a denominator past `max_pan_den`.
- `render_stereo(session, faders, pans, clock, out)` -- fold each track's fader with its channel pan weight into a per-channel effective fader, then run ALES8's `fader.render` once per channel. Forwards `ClipFull` / `DurationTooLong`. A hard-panned track folds to a `0/N` fader on the silent side -- silence, never a divide fault.

## What the witness proves (GREEN on metal)

`tools/al/ales_pan_witness.rish`: center pan splits a track equally; hard left and hard right route the whole track to one channel; pan composes with the fader (half level, center pan -> a quarter each side); two tracks panned opposite separate into the two channels; the linear-pan invariant holds -- left + right reproduces the mono fader mix exactly for any pan position; `make` refuses `BadGain` / `BadRange`; a track past the master bound forwards `ClipFull`. GREEN on the first build. Purely local -- no socket, no network, no keys, no funds, no real device, no real speaker.

## The road on

With the second channel open, the mixer grows a stereo half. The next Lotus rung can name a stereo **balance/width** control (panning an already-stereo source), a transport **loop** over a marked region (extending ALES7), or the equal-power **crossfade curve** -- the pan and fade law that preserves power rather than sum, for a click-free, level-steady crossfade. The audio-interface **hardware** -- the real two-channel sound-card write a stereo master would ultimately feed -- stays a paused research round, taken only on Keaton's word.
