# Classical Vedic Astrology -- The Reading Craft

**Language:** EN
**Last updated:** 2026-08-24 (Gauge molt -- studies depersonalized, style updated)
**Style:** Gauge Field (see `../context/GAUGE_STYLE.md`), gentle register
**Stamp of founding:** `20260702.010412`

---

This folder holds the reading craft whole: a siloed study library, composable reading templates, one demonstration reading, and the caster that computes a sky. Everything here serves one purpose -- that a chart can be read with depth, written with warmth, and given with a whole heart.

The method is the classical hybrid this project keeps: **tropical zodiac signs** carry each planet's dignity, **sidereal nakshatras** under the Lahiri ayanamsa carry the stars and their padas, and **whole-sign houses** rise from the ascendant. Every chart is cast twice -- once with [`cast_a_chart.rish`](cast_a_chart.rish) (hosted pyswisseph seam), once with an independent tool -- and the writing begins only when the two oracles agree, placement for placement. The same discipline that keeps the code honest keeps the sky honest.

---

## Privacy, Kept by Design

The studies that once named a specific person now speak of **the native** -- the standard Jyotish term for the chart holder. Study files ship in the public seed as teaching material; natal readings carry a named person's birth date, time, and place and are withheld. Working drafts for any future reading follow the same rule: the generic term does the teaching work, and the true name enters only the final copy handed to its person.

---

## What Lives Here

```
classical-vedic-astrology/
+-- _method/                 diurnal wheel + rendering discipline (index: _method/README.md)
+-- cast_a_chart.rish         dual-zodiac caster (canonical; hosts cast_a_chart_host.sh)
+-- cast_a_chart_host.sh      POSIX seam -> cast_a_chart.py (pyswisseph)
+-- studies/                 silo library by topic (index: studies/README.md)
|   +-- life-frame/
|   +-- nakshatras/
|   +-- lunar-craft/
|   +-- planets-in-signs/
|   +-- rising-signs/
|   +-- planet-in-house/
|   +-- synthesis/
|   +-- reading-themes/
|   +-- teaching/
+-- templates/               composable reading skeleton (md + html + tokenized two-wheel)
+-- readings/                finished readings -- WITHHELD from the public seed
|   +-- alice-sample-reading.md      the demonstration, under a placeholder name
|   +-- <person>/            one folder per reading: a two-wheel cast and its chapters
+-- yonder/                  superseded drafts -- WITHHELD from the public seed
```

## Readings (newest first)

| Stamp | Reading | Meaning |
|-------|---------|---------|
| 20260701.232912 | [Sample reading](readings/alice-sample-reading.md) | The demonstration reading, under a placeholder name. This is the one that ships. |

*One complete two-wheel reading of fifteen chapters stands in the maintainer's field and is withheld from the public seed, along with the superseded drafts in `yonder/`. A natal chart carries a named person's birth date, time, and place, and privacy is kept by design. **The method ships; the chart stays private.** The `readings/` and `yonder/` rooms are `sub_exclude`d in `template-manifest.bron` (`20260823.184309`), so the boundary is a declaration a program reads rather than a habit.*

## Templates

| Stamp | File | Meaning |
|-------|------|---------|
| 20260705.020812 | [Two-wheel HTML template](templates/20260705-020812_reading-template.html) | Tokenized D1/D9 renderer -- `{{NAME}}`, wheels, chapters |
| 20260701.232912 | [Reading template (md)](templates/reading-template.md) | Composable skeleton and silo map |
| 20260701.232912 | [Reading template (html)](templates/reading-template.html) | Single-wheel demonstration |

## Yonder

| Stamp | Index | Meaning |
|-------|-------|---------|
| -- | [yonder/README.md](yonder/README.md) | Morning-cast drafts superseded by the evening recast |

- **`studies/`** -- silo library `00`-`58` and growing. Each study lives in a **topic folder** (`nakshatras/`, `planets-in-signs/`, `planet-in-house/`, ...) with a hyphenated sprig. The master index is [`studies/README.md`](studies/README.md); the composable map lives in [`templates/reading-template.md`](templates/reading-template.md).
- **`templates/reading-template.md`** -- how a reading is made, section by section, silo by silo.
- **`templates/reading-template.html`** -- the demonstration as a self-drawing page.
- **`templates/20260705-020812_reading-template.html`** -- tokenized two-wheel template for full classical readings.
- **`readings/`** -- finished readings and per-chapter silos; placeholder names only.
- **`cast_a_chart.rish`** -- dual-zodiac caster witness. Edit birth constants in `cast_a_chart.py`, then run from repo root: `rishi/bin/rishi run classical-vedic-astrology/cast_a_chart.rish`.

---

## How a New Reading Grows

Receive the birth moment verbatim and honor it exactly -- the one-clock rule, applied to a life. Cast the sky twice and compare until the oracles agree. Compose each section from the matching studies, weaving rather than pasting, in Gauge voice and the gentle register. Where a placement has no study yet, write the new silo first -- choose the topic folder, add a row to `studies/README.md` -- and keep the person's name apart until the final copy.

---

*May every sky here be cast twice and written once. May the studies deepen with each new chart. And may every reading leave its person feeling seen, blessed, and gently sent onward.*
