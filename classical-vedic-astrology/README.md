# Classical Vedic Astrology — The Reading Craft

**Language:** EN
**Last updated:** 2026-07-10 (Radiant Style pass round 3 · Movement 2 begun)
**Style:** Radiant (see `../context/RADIANT_STYLE.md`), gentle register
**Stamp of founding:** `20260702.010412`

---

This folder holds the reading craft whole: a siloed study library, composable reading templates, one demonstration reading, and the caster that computes a sky. Everything here serves one purpose — that a friend's birth chart can be read with depth, written with warmth, and given with a whole heart.

The method is the classical hybrid this project keeps: **tropical zodiac signs** carry each planet's dignity, **sidereal nakshatras** under the Lahiri ayanamsa carry the stars and their padas, and **whole-sign houses** rise from the ascendant. Every chart is cast twice — once with [`cast_a_chart.rish`](cast_a_chart.rish) (hosted pyswisseph seam), once with an independent tool — and the writing begins only when the two oracles agree, placement for placement. The same discipline that keeps the code honest keeps the sky honest.

---

## Privacy, Kept by Consent

The friends whose skies seeded this library asked that privacy be kept, and it is. Demonstration readings carry the placeholder **Alice**; the Brooke reading carries **Brooke** by consent. A whole-tree privacy gate confirms the guarded names appear nowhere in the repository; birthplaces rest as region or coordinates alone. The true-name HTML for Brooke stays in Kaeden's private keeping until her approval. Working drafts for any future reading follow the same rule: the placeholder does the work, and the true name enters only the final copy handed to its person.

---

## What Lives Here

```
classical-vedic-astrology/
├── _method/                 diurnal wheel + rendering discipline (index: _method/README.md)
├── cast_a_chart.rish         dual-zodiac caster (canonical; hosts cast_a_chart_host.sh)
├── cast_a_chart_host.sh      POSIX seam → cast_a_chart.py (pyswisseph)
├── studies/                 silo library by topic (index: studies/README.md)
│   ├── life-frame/
│   ├── nakshatras/
│   ├── lunar-craft/
│   ├── planets-in-signs/
│   ├── rising-signs/
│   ├── planet-in-house/
│   ├── synthesis/
│   ├── reading-themes/
│   └── teaching/
├── templates/               composable reading skeleton (md + html + tokenized two-wheel)
├── readings/                finished readings (placeholder names)
│   ├── alice-sample-reading.md
│   └── brooke/              complete two-wheel reading + 15 chapters (index: brooke/README.md)
└── yonder/                  superseded drafts (index: yonder/README.md)
```

## Readings (newest first)

| Stamp | Reading | Meaning |
|-------|---------|---------|
| 20260705.042512 | [Brooke — full reading](readings/brooke/20260705-020812_dharma-and-the-two-wheels.md) | Evening recast; D1 and D9; Makara sweep; fifteen chapters in `readings/brooke/` |
| 20260701.232912 | [Alice — sample](readings/alice-sample-reading.md) | Demonstration under placeholder name |

## Templates

| Stamp | File | Meaning |
|-------|------|---------|
| 20260705.020812 | [Two-wheel HTML template](templates/20260705-020812_reading-template.html) | Tokenized D1/D9 renderer — `{{NAME}}`, wheels, chapters |
| 20260701.232912 | [Reading template (md)](templates/reading-template.md) | Composable skeleton and silo map |
| 20260701.232912 | [Reading template (html)](templates/reading-template.html) | Single-wheel demo (Alice) |

## Yonder

| Stamp | Index | Meaning |
|-------|-------|---------|
| — | [yonder/README.md](yonder/README.md) | Morning-cast drafts superseded by the evening recast |

- **`studies/`** — numbered silo library `00`–`20` and growing. Each study lives in a **topic folder** (`nakshatras/`, `planets-in-signs/`, `planet-in-house/`, …) with a hyphenated slug. The master index is [`studies/README.md`](studies/README.md); the composable map lives in [`templates/reading-template.md`](templates/reading-template.md).
- **`templates/reading-template.md`** — how a reading is made, section by section, silo by silo.
- **`templates/reading-template.html`** — the Alice demonstration as a self-drawing page.
- **`templates/20260705-020812_reading-template.html`** — tokenized two-wheel template for full classical readings.
- **`readings/`** — finished readings and per-chapter silos; placeholder names only.
- **`cast_a_chart.rish`** — dual-zodiac caster witness. Edit birth constants in `cast_a_chart.py`, then run from repo root: `rishi/bin/rishi run classical-vedic-astrology/cast_a_chart.rish`.

---

## How a New Reading Grows

Receive the birth moment verbatim and honor it exactly — the one-clock rule, applied to a life. Cast the sky twice and compare until the oracles agree. Compose each section from the matching studies, weaving rather than pasting, in Radiant voice and the gentle register. Where a placement has no study yet, write the new silo first — choose the topic folder, assign the next number, add a row to `studies/README.md` — and keep the person's name apart until the final copy.

---

*May every sky here be cast twice and written once. May the studies deepen with each new chart. And may every reading leave its person feeling seen, blessed, and gently sent onward.*
