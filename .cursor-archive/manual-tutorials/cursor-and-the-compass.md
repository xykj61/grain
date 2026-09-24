# Cursor and the Compass -- First Day with Glow OS

**Language:** EN
**Version:** `20260717.173427` (Eastern)
**Style:** Gauge, Door setting (see `../../context/GAUGE_STYLE.md`)
**Voice:** Quin
**Status:** Fossil -- retired `20260920.135100` on Keaton's word, moved whole from
`manual/tutorials/cursor-and-the-compass.md` in the same round that archived every
`.cursor/rules/*.mdc` file. Kept for its onboarding shape -- foundations, witness habitat, log,
send -- which a future first-day tutorial for the current editor may reuse; the Cursor-specific
steps themselves no longer apply.
**Audience:** an Acme Corporation employee opening Cursor on this tree for the first time.

---

## What This Tutorial Is

One reading order carries the whole first day: foundations -> rules -> first witness -> session log -> send. It teaches how this project *steers*, rather than the full Glow language -- that waits on a general parser.

## 1. Why We Build

Start with the compressor when context is short: [`../../docs/COMPASS.md`](../../docs/COMPASS.md) - Kyri cold-start card [`../../docs/compass_card.kyri`](../../docs/compass_card.kyri). Then the raw shelf: [`../../foundations/README.md`](../../foundations/README.md) -- sovereignty, calm, the person owns the device. Compass habit: [`../../foundations/20260826-024943_follow-our-compass.md`](../../foundations/20260826-024943_follow-our-compass.md).

## 2. How Work Is Shaped

| Idea | Where |
|---|---|
| Grain (the strands) | [`../../foundations/20260826-024942_the-grain-and-the-crossing.md`](../../foundations/20260826-024942_the-grain-and-the-crossing.md) |
| Sameness | [`../../foundations/20260703-182612_sameness-is-the-macro.md`](../../foundations/20260703-182612_sameness-is-the-macro.md) |
| Two Rooms | [`../../context/TWO_ROOMS.md`](../../context/TWO_ROOMS.md) |
| Single-stranded modules | [`../../foundations/20260823-204456_single-stranded.md`](../../foundations/20260823-204456_single-stranded.md) |

## 3. How We Prove -- Witness Habitat

Foundations name this the **happy zone** (teacher: J.B. Rainsberger). In Acme-facing docs, say **witness habitat**:

> The fast, isolated suite of checks that prove pure folds and seam contracts; devices and hosts stay on a **thin edge** with a few **metalsmoke** proofs.

Canon: [`../../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md`](../../foundations/20260826-194850_the-happy-zone-and-the-thin-edge.md) - naming study [`../../external-research/date/20260717/20260717-173427_witness-habitat-foundations-fit-and-onboarding-gaps.md`](../../external-research/date/20260717/20260717-173427_witness-habitat-foundations-fit-and-onboarding-gaps.md).

## 4. How Cursor Behaves Here

Always-on rules live under `.cursor/rules/`. Read in this order on day one:

1. Quin voice - Radiant Style  
2. TAME Guidance (`context/TAME_GUIDANCE.md`)  
3. Session logs (Kyri)  
4. Collaboration (keep-going vs check-in)  
5. Align - send  
6. Acme employee voice (for design docs)  
7. Vocabulary -- **nib** for landed edges  

Loop words (LEXICON): gate - itinerary - lap - nib - Rest-until.

## 5. First Checkable Act

```bash
rishi/bin/rishi run tools/g/glow_expr_witness.rish
# or, for product glass:
rishi/bin/rishi run tools/d/dexter_glass_witness.rish
```

When it prints GREEN, you stand inside the witness habitat.

## 6. Log, Then Send

Every turn closes with a Kyri session log (`session-logs/YYYYMMDD-HHMMSS_sprig.kyri`) and a newest-first row in `session-logs/README.md`. Once work is ready for the pier, **send** (commit - push - merge) -- Cursor's one word for shipping to your own history.

## 7. Markup Pipeline (orientation only)

prose -> Scribble -> Brix -> Kyri -> Mantra -> Seva - Glow programs under TAME.  
Map: [`../../external-research/date/20260717/20260717-173427_markup-dsl-fusion-map-glow-brix-kyri.md`](../../external-research/date/20260717/20260717-173427_markup-dsl-fusion-map-glow-brix-kyri.md).

## What This Tutorial Does Not Yet Claim

- Full Glow rune textbook  
- Udon/Sail mark conversion  
- Mirrored seam pairs seated in TAME  

Those are named horizons; this path gets you steering today.

---

*May your first GREEN be small, and your compass stay nearby.*
