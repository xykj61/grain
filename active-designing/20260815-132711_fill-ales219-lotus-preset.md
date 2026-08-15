# Fill ALES219 — Lotus preset: a named effect chain a keeper loads by name

**Stamp:** `20260815.132711` · **Voice:** Kyri · **Style:** Radiant · **Status:** Self-approved design round
**Season:** Six-Season double-seat, Season C (Lotus · the creative suite) · waymark **ALES** · rung **ALES219**
**Kin:** [`../lotus/render.rye`](../lotus/render.rye) (ALES217 — the Step and the render) · [`../lotus/stereo_render.rye`](../lotus/stereo_render.rye) (ALES218) · [`20260815-132120_fill-ales218-lotus-stereo-render.md`](20260815-132120_fill-ales218-lotus-stereo-render.md)

## The crux the loop named

ALES218 closed the render family whole — mono and stereo, an ordered chain of proven effects into a canonical `.wav`. It named its own next crux plainly: *a named preset chain a keeper loads by name — a `Step[]` from a small catalog.* That is the honest next durable thing. Every effect in Lotus reaches toward render; render reaches toward a keeper who does not want to hand-assemble a chain of `Step` records, but to say **"bookend fades"** or **"gentle master"** and receive a chain that is already legal for their clip.

## What ALES219 adds

`lotus/preset.rye` seats a **small, bounded catalog of named chains**. Its whole value is two promises the raw `Step[]` cannot make on its own:

1. **Load by name.** `from_name("bookend_fades")` maps a plain string to a `Preset`, refusing `UnknownPreset` for anything else — the literal "a keeper loads by name" gesture. `name(preset)` gives the plain word back.
2. **Total over clip length.** `build(preset, clip_len)` returns a `Chain` — a bounded `Step` buffer and its count — whose spans are already clamped to the clip, so **render never refuses a preset chain for `BadRange`**, whatever the clip length (short, long, or empty). The preset owns the arithmetic (a tail fade is `start = len - edge`, clamped when `len < edge`), so the keeper never computes a span.

The catalog composes only the three effects render already proves — `gain`, `fade`, `invert` — so ALES219 adds no new acoustic fact, only sequencing and naming. The returned `Chain.slice()` feeds `render.render` (mono) or `stereo_render.stereo_render` (both channels) verbatim.

## The catalog (first four, each a real gesture)

| Name | Chain | Gesture |
|---|---|---|
| `phase_flip` | `[invert]` | flip the whole clip's phase |
| `half` | `[gain 1/2 whole]` | drop the whole clip's level by half |
| `bookend_fades` | `[fade-in head edge, fade-out tail edge]` | ease the clip in and out |
| `gentle_master` | `[gain 1/2 whole, fade-in head, fade-out tail]` | a small level-and-ease master |

`edge_samples` is a named constant, clamped to the clip so a short clip's head and tail simply overlap — still legal, since overlapping spans are sequential gestures.

## The laws the witness proves on metal

- **THE NAME LAW** — `from_name` round-trips every catalog name, and refuses `UnknownPreset` for a stranger.
- **THE LEGAL-CHAIN LAW** — every preset builds a chain `render` accepts (no `BadRange`) at three clip lengths: shorter than the edge, longer than the edge, and empty.
- **THE HAND LAW** — a preset's rendered `.wav` decodes byte-for-byte to the same gestures applied by hand.
- **THE DISTINCT LAW** — two different presets render one clip to two different files: the name selects the work.
- **THE BOUND LAW** — no preset exceeds `max_preset_steps`.

## Honest scope

Software only, purely local. A `Step[]` catalog over a bounded `i16` buffer; the same byte container ALES215 proved. No real file, no DAC, no acoustic or electrical fact, no network, no keys, no funds, no real device. Siloed to `lotus/`. No custody gate.
