# Fill ALES220 — Lotus stereo_preset: a named preset carried over both channels

**Stamp:** `20260815.133213` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES220**
**Kin:** [`../lotus/preset.rye`](../lotus/preset.rye) (ALES219 — from_name and build) · [`../lotus/stereo_render.rye`](../lotus/stereo_render.rye) (ALES218 — the balanced render) · [`20260815-132711_fill-ales219-lotus-preset.md`](20260815-132711_fill-ales219-lotus-preset.md)

## The crux

ALES219 gave a keeper a named effect chain over one mono `Clip`; ALES218 gave a keeper an arbitrary chain over both channels of a stereo master. The honest next durable thing is their join: a **named preset over a stereo master** — the same one-word gesture (`gentle_master`) applied to the two-channel master a real Lotus session actually holds (a `pan.StereoClip`, ALES10). Every stereo family before it (reverb, width, pan, render) closed its mono→stereo twin whole; the preset surface owes the same.

## What ALES220 adds

`lotus/stereo_preset.rye`, a pure composition inventing no new effect, check, or name:

- `render_preset(rate, preset, sc, out)` — build the preset's chain against the master's shared length, then run ALES218's `render_stereo`. Because `build` is **total** over the length (every span clamped to the clip), the chain is always legal — no `BadRange` can originate here, only the container's own faults.
- `render_named(rate, name, sc, out)` — the literal keeper gesture: `from_name` the string, then `render_preset`. An unknown name refuses `UnknownPreset` before the master is read, so both channels stay byte-for-byte unchanged.

`StereoPresetError = preset.PresetError || stereo_render.StereoRenderError` — the honest union of the two halves.

## The laws the witness proves on metal

- **THE NAMED-STEREO LAW** — each catalog preset rendered by name decodes byte-for-byte on each channel to the same preset applied by hand.
- **THE INDEPENDENT-CHANNEL LAW** — a named stereo preset is the same preset rendered mono per channel (proven against `render.render` on each channel), sharing one interleaved container.
- **THE UNKNOWN LAW** — a stranger name refuses `UnknownPreset`, both channels untouched.
- **THE BALANCE LAW** — every render leaves the two channels equal length.
- **THE ATOMIC LAW** — a small container refuses `OutputTooSmall`, both channels untouched; `build` is total, so no preset ever refuses for `BadRange`.

## Honest scope

Software only, purely local — ALES218 and ALES219 joined. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. Siloed to `lotus/`. No custody gate.
