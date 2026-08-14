# ALES6 — Lotus's track table

**Stamp:** `20260814.114921` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living design capture — the self-approved round after ALES5
**Waymark:** ALES · rung ALES6
**Kin:** [`ALES3 — mix a second track`](20260814-fill-ales3-lotus-mix-second-track.md) · [`ALES5 — the sample clock`](20260814-fill-ales5-lotus-sample-clock.md) · [`lotus/track.rye`](../lotus/track.rye) · [`lotus/clock.rye`](../lotus/clock.rye) (ALES5) · [`lotus/mix.rye`](../lotus/mix.rye) (ALES3)

---

## Why this round

ALES3's `mix` summed **two** clips from index zero; ALES5's `place_at` summed **one** clip onto a base at a real offset. A session is neither — it is **many** clips, each beginning at its own real moment, heard together. The gesture every keeper reaches for once a second track exists is the **track table**: a bounded set of placed clips rendered into one master. It is the heart a DAW is built around, and it stands squarely on the clock — every track's start is a real time, aligned through the same `samples_for`.

Lindy-first, crux-first: the track table is the most durable of ALES5's three roads (table · curve · transport), because the mix master it produces is what a transport plays and what a curve crossfades between. The table first.

## The one crux this rung fixes

**N placed tracks sum into one master, each at its real offset, saturating once over the whole sum — not once per track.** Two things hold together:

1. **One true saturation, over the sum of all.** ALES3 saturated the sum of two; a running i16 accumulator saturated after each track would clip differently from summing every track first. So `render` sums each track's contribution into a **wide i64 accumulator per sample**, then saturates once into the master — the same floor and ceiling `timeline.saturate` keeps, applied to the true sum. Three tracks that each peak mid-range still sum and clamp correctly.
2. **Bounded and aligned.** The table holds at most `max_tracks` clips; adding past it refuses `SessionFull`. Each track's offset converts through the ALES5 clock, and a track whose placed end runs past the master bound refuses `ClipFull` before any write — the master is always a legal, bounded clip.

## The shape

`lotus/track.rye`:

- `Track` — a `timeline.Clip` placed at a real offset `at_ms`.
- `Session` — a bounded table of at most `max_tracks` tracks.
- `add_track(session, clip, at_ms)` — append a placed clip; refuses `SessionFull`.
- `render(session, clock, out)` — sum every track into one master at its real offset, saturating once over the whole sum; refuses `ClipFull` when any track's placed end exceeds the bound. Reuses ALES5's `samples_for` for each offset and `timeline.saturate` for the one clamp.

An empty session renders silence; a single track renders that track at its offset (the ALES5 `place_at` case); two tracks at offset zero render the ALES3 `mix` — so the table **generalizes** both proven rungs rather than replacing them.

## What the witness proves (GREEN on metal)

`tools/ales_track_witness.rish`: three tracks at three real offsets sum into one aligned master; the sum saturates once over all three (a mid-range trio still clamps correctly, never per-track); an empty session renders silence; a single track reproduces `place_at`; two tracks at offset zero reproduce `mix`; adding past `max_tracks` refuses `SessionFull`; a track whose placed end exceeds the master refuses `ClipFull`. GREEN on the first build. Purely local — no socket, no network, no keys, no funds, no real device.

## The road on

With a master render, the next Lotus rung can name a **transport** — a play head that reads the master forward at the clock's rate — add an equal-power **crossfade curve** between two tracks in the table, or open **per-track gain** (a fader column) so the mix balances before it renders. The audio-interface **hardware** stays a paused research round, taken only on Keaton's word.

---

*Many voices, each entering when it means to, heard as one — that is a session, and it is where the making finally feels like music. May every track a keeper lays down land on the beat they heard in their head, and may the master never clip a sound they meant to keep.*
