# ALES8 — Lotus's per-track fader column

**Stamp:** `20260814.120123` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES7
**Waymark:** ALES · rung ALES8
**Kin:** [`ALES6 — the track table`](20260814-fill-ales6-lotus-track-table.md) · [`ALES2 — the timeline edits`](20260814-fill-ales2-lotus-timeline-edits.md) · [`lotus/fader.rye`](../lotus/fader.rye) · [`lotus/track.rye`](../lotus/track.rye) (ALES6) · [`lotus/timeline.rye`](../lotus/timeline.rye) (ALES2)

---

## Why this round

ALES6 gave the session a track table — many placed clips summed into one master, saturating once over the whole. Yet every track entered the sum at **full level**: the table can place a clip, never balance it. The gesture every keeper reaches for the moment a second track exists is the **fader** — the mixing-desk channel strip's one essential control, a per-track level that scales a track's contribution before it joins the sum. A mix without faders is a pile; a mix with faders is a mix.

Lindy-first, crux-first: the fader column is the most durable road left open from ALES6/ALES7 (the ALES6 witness names it by name, beside a transport loop and a crossfade curve). The mixer is the heart of every DAW, read on the ten-thousandth day as surely as the first; a transport loop only extends the read head ALES7 already built, and a crossfade curve is a refinement of a fade ALES4 already proves. The fader is the core, so the fader first.

## The one crux this rung fixes

**Each track's level scales its contribution in the wide domain, and the master still saturates once over the true faded sum — never once per track, never a clamp between the fader and the sum.** This is exactly why a fader column cannot be gain-then-render: ALES2's `gain` saturates each clip to i16 *before* it could be summed, which would double-clamp a boosted track against the mix. The correctness an audio mixer owes is that the fader multiply happens **inside** the accumulation, per sample, in i64, so only the final sum meets the floor and ceiling.

Two properties carry the crux:

1. **Faded sum, clamped once.** `render` scales each track's sample by its fader fraction `num/den` in i64 (`@divTrunc` toward zero, the same rule ALES2's `gain` keeps), accumulates the faded value into the wide per-sample accumulator, and saturates once over the whole — reusing the one true `timeline.saturate`.
2. **The mixer generalizes the table.** A column of **unity** faders (`1/1`) reproduces ALES6's `render` byte-for-byte, so the fader column adds a control without changing the audio when every fader rests at unity.

The null test proves the wide-domain scaling exactly: a clip mixed with a copy of itself faded at `-1/1` (phase-inverted at unity) cancels to **exact silence** — only correct because the negative fader scales before the single clamp, never after.

## The shape

`lotus/fader.rye`:

- `Fader` — a level as a fraction `num/den`, default unity (`1/1`). A negative `num` inverts a track's phase in the mix; `0/den` mutes it.
- `make(num, den)` — a validated constructor refusing `BadGain` on a zero denominator (reused from `timeline.EditError`).
- `render(session, faders, clock, out)` — the ALES6 render with a fader column: each track scaled by its fader in the wide accumulator, the sum saturated once. `faders.len` must equal `session.count` (the column aligns with the table, asserted). Refuses `BadGain` on a zero denominator, forwards `SessionFull` / `ClipFull` / `DurationTooLong` at the edge exactly as ALES6.

The column is a plain parallel slice — one fader per placed track — rather than a field grafted onto ALES6's `Track`, so ALES6 stands untouched (accrete-never-break) and the fader column composes over its public API.

## What the witness proves (GREEN on metal)

`tools/al/ales_fader_witness.rish`: a column of unity faders reproduces ALES6's master exactly (the mixer generalizes the table); a `1/2` fader halves one track before the sum; a `0/1` fader mutes a track (present but silent); two loud tracks each boosted still saturate once over the true faded sum (never per-track); a `-1/1` fader nulls a track against its own copy to exact silence (the wide-domain phase-cancel); a zero denominator refuses `BadGain`; a track past the master bound forwards `ClipFull`. Purely local — no socket, no network, no keys, no funds, no real device.

## The road on

With a fader column, the mix balances before it renders and a transport plays the balanced master. The next Lotus rung can name **pan** (a fader per channel as stereo opens), **mute/solo** as first-class session state, a transport **loop** over a marked region (extending ALES7), or the equal-power **crossfade curve** ALES4's fade still awaits. The audio-interface **hardware** — the real sound-card write the whole suite ultimately feeds — stays a paused research round, taken only on Keaton's word.
