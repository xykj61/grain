# The Works Town Infusion -- seat three writings beside the seated water bundles, project the seed, stop at the custody gate

**Stamp:** `20260825.200050` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting for the prose, Meter setting for the lap tables (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Mixed -- proposed. Every lap below stays PROPOSED until the bench runs it and the witness prints green; the push is Keaton's word
**Expands:** the counsel cell pasted with this prompt (ANSWER - SHAPE - PROPOSE - BATON), applied per [`.claude/rules/cell.md`](../.claude/rules/cell.md)
**Reuses:** [`the headwater works infusion`](20260825-171924_the-headwater-works-infusion.md) -- its nine laps and its laws apply unchanged; this prompt names only what a third bundle landing on seated ground changes
**Trees:** `xykj61/grain` (the full tree, written once) and `grain-os/grain` (the public seed, projected by `tools/fixtures/sow_project.sh`)

---

## The counsel this expands

Counsel delivered three writings as a third relay bundle of the same season, each with `STAMP` standing where a one-clock stamp belongs:

| Bundle file | Home in the full tree | Room | Setting | Seed disposition |
|---|---|---|---|---|
| `external-research/20260825-200047_the-first-works-town-on-the-brazos.md` | `external-research/` | mixed - research for understanding | Field | ships, scrubbed |
| `active-designing/20260825-200048_the-works-town-shape.md` | `active-designing/` | mixed - design | Field | ships, scrubbed |
| `active-designing/20260825-200049_the-works-town-sleeve-siya.md` | `active-designing/` | design | Field | **withheld** by construction -- it names the fund; confirm it lands in `.sow-withheld.log` |

## What changed since the last prompt

Counsel read the tree at tip `383b46e` (2026-08-25 19:33:55 -0400, "external-research: the four readings, taken"). At that tip both earlier bundles are seated under real stamps (`20260825-1719xx_*`), the Lexicon already carries Proposed rows for *Gleaner*, *fiber corridor shapes*, *headwater works shapes*, and *basin door*, and the external-research room holds the readings note `20260825-193122_the-four-readings-taken.md`. So Lap 0 of the headwater works infusion resolves to **Case A** unless the bench's own tip says otherwise: every cross-link in this bundle to a seated file already carries its hyphen-form stamp, and only the links between this bundle's own three files use `STAMP_` names.

## Pre-flight

Read `CLAUDE.md`, `.claude/rules/kyri.md`, `.claude/rules/gauge-style.md`, `.claude/rules/stamp-and-name.md`, `.claude/rules/design-rooms.md`, `.claude/rules/ascii-first.md`, `.claude/rules/session-logs.md`, `.claude/rules/commit-messages.md`, `.claude/rules/cell.md`, `context/TWO_ROOMS.md`, `context/SILO_TECHNIQUE.md`. Then confirm the basis:

```
git rev-parse --short HEAD            # counsel read 383b46e; name the tip you actually hold
git grep -il "works town" | wc -l     # counsel read 0 at 383b46e; the collision lap for the proposed name
ls external-research | grep -c '20260825-1719\|20260825-1931'   # the seated water files this bundle links to
```

Measurement beats memory: the tip you print is the basis.

## Laps

Run Laps 1 through 9 of the headwater works infusion for the three files, with these substitutions:

- **Lap 1, stamps.** Three stamps, one per file, taken into shell variables at the moment each file is written. Rewrite the three `STAMP_` cross-links (study -> shape, shape -> study, sleeve -> shape and study) with the hyphen form of the linked file's stamp.
- **Lap 3, index rows.** `external-research/README.md` keeps an *Explorations (newest first)* table with columns Stamp, Note, Meaning; prepend one row for the study directly below the delimiter, at or under 192 bytes: *the first works town on the Brazos -- eleven towns read by headwater, polis, and commons; Plainview leads*. `active-designing/README.md` keeps a Stamp, Brief, Meaning table; prepend one row for the shape: *one form for choosing the town a first works is read for; the tie rule headwater, polis, commons*. The sleeve memo takes a row only if that index already lists the earlier sleeve memos; match what stands.
- **Lap 4, Lexicon.** Append one **Proposed** row, in the shape the *headwater works shapes* row already uses: **works town** -- the town a first works is read for, chosen by the works town shape's tie rule; keeps clear of *seat*. Record the collision reading from pre-flight in the row.
- **Lap 5, witnesses.** The same six, from bare, in the same order; the register witness reports the study and the shape at Field.
- **Lap 6, the session log.** `session-logs/${STAMP_HYPHEN}_the-works-town-infusion.kyri`, `format session-log-v1`, `voice Kyri`, with an `obs` line per witness reading and a `file` line per placed file.
- **Lap 7, commits.** Three subjects, component-prefixed, under 50 characters: `external-research: add the first works town`, `active-designing: add the works town shape, sleeve`, `context: propose works town in the Lexicon`; plus the session-log commit. Sign with the sandbox key.
- **Lap 8, the seed.** `sow_project`, `sow_leak_scan`, `sow_witness`, `seed_link_witness`; `grep -n 'the-works-town-sleeve-siya' seed/.sow-withheld.log` expects exactly one line; read the two shipped copies once for the scrub's effect and name any substitution that changes a claim.
- **Lap 9.** Stop at custody gate 1. The push is Keaton's word.

## What the bench holds to

One clock: every stamp comes from `TZ=America/New_York date` into a variable. Accretion over breakage: dated files on disk stay whole, and the three new files are additions. Proposal over seating: the works town, the shape's name, and every home named here stay proposals in the record until the word. Money parks: the sleeve memo is placed and withheld, and the bench reads it and leaves it. The seed is projected by the tool alone. ASCII first. Every completion claim carries the witness line that proves it.

## Recommend

**Recommend: check-in after Lap 5.** The tip, the three stamps, the files placed, the Lexicon row, and the six witness lines are the honest checkpoint; Laps 6 through 9 follow on the same word once the readings are on the record, and the push waits on Keaton.
