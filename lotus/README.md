# Lotus -- Grain's creative suite

**Stamp:** `20260824.091754` - **Language:** EN - **Voice:** Kyri - **Style:** Gauge, Door setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Status:** Living front door -- Chapter C, the ALES ladder, **240 modules** standing with **241 witnesses** (measured `20260827`)
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Chapter:** the Six-Chapter double-seat, Chapter C thread - **Waymark:** ALES
**Kin:** [`the Lotus DAW`](../active-designing/yonder/20260630-014012_lotus-the-daw.md) - [`the eight-season double-seat`](../active-designing/date/20260816/20260816-205859_double-seat-expansion-eight-seasons.md) - the surface it draws on, [`Skate / Surf`](../skate/README.md) under [`alias-sameness`](../.claude/rules/alias-sameness.md) - the ladder law it is marked by, [`stamp-and-name`](../.claude/rules/stamp-and-name.md) - the waymark roster [`waymark-ladders`](../.claude/rules/waymark-ladders.md), where **ALES** is seated

---

## What this is

**Lotus** is Grain's own creative suite -- one tool for composing, producing, mixing, and
sound-engineering, built for the musicians, filmmakers, podcasters, journalists, and editors this
tree serves. A keeper records into it, edits, mixes, masters, and ships a sealed record somebody
else can verify.

The suite is built as a **ladder**. Each rung is a small, complete audio gesture with its own Rye
module and its own witness, and each one stands on the rungs below it. The ladder opens at
`wire.rye`, which carries a buffer of samples from a source into the software and proves it whole
before the timeline ever sees it. It reaches, today, a whole catalog of sealed records that verify
end to end.

## Honest scope -- software only

Everything here is software. The **audio-interface hardware** -- real XLR, USB-C, and guitar
pinouts, signal levels, the balanced and unbalanced electrical design -- is a paused
hardware-research round, bookmarked on Keaton's word. The cable kinds this code names are
**routing tags** on a buffer, and the tree keeps them at exactly that weight.

## What stands, measured

| Reading | Count | Where | Measured |
|---|---|---|---|
| Rye modules in `lotus/` | **240** | every one with a row in [`MODULES.md`](MODULES.md) | `20260827` |
| Witnesses on disk | **241** | `tools/al/ales_*_witness.rish` | `20260827` |
| Rungs climbed, in code | **ALES0 through ALES238** | the newest is `catalog_verify.rye` | `20260827` |
| Rungs written into the ledger | **ALES0 through ALES214** | [`LADDER.md`](LADDER.md) | `20260827` |

**The last twenty-four rungs live in their modules rather than in the ledger.** ALES215 through
ALES238 ran and are green; `LADDER.md` carries its last entry at ALES214. They are named here rather
than transcribed, because a ledger pointing at rows it has read serves better than one transcribing
rows it has only guessed at. Whoever next works this ladder folds them in from the modules and their
witnesses -- the same repair `docs/STOA.md` took on `20260827.173952`, and the same lesson: a
compressor drifts quietly, because it keeps looking exactly as it did the day it was true.

Two of the 240 are seam symlinks into `../tally/` -- `parse_int.rye` and `tally_copy.rye` -- and
they carry rows too, since a reader who finds a file in this directory expects the page to explain
it.

## Where to read

**[`MODULES.md`](MODULES.md)** answers *what is here*: all 240 modules in twelve families, each
sentence taken from that module's own head comment. Start here to find the thing you want.

**[`LADDER.md`](LADDER.md)** answers *why in this order*: the rung ledger, which question each rung
settled, and how the next one followed. Read this to understand the design rather than to locate a
file.

## Prove the rungs

Every rung carries a witness of its own under the matching name, so the whole suite runs in one
line from the repository root:

```
for w in tools/al/ales_*_witness.rish; do rishi/bin/rishi run "$w"; done
```

A single rung runs on its own the same way:

```
rishi/bin/rishi run tools/al/ales_wire_witness.rish
rishi/bin/rishi run tools/al/ales_reverb_witness.rish
```

Each witness names its Language, Style, and Lens, then prints one `GREEN` line stating what it
proved.

## What holds this page honest

The roster in [`MODULES.md`](MODULES.md) is held to the directory by
[`../tools/l/lotus_module_roster_witness.rish`](../tools/l/lotus_module_roster_witness.rish), the
44th standing guard, which gates four readings at zero: a module on disk with no row, a row naming
a module that is absent, one module wearing two rows, and a row whose text and link disagree.

The guard exists because this page once stood at **297,878 bytes** and named 83 of the 240 modules
beside it. A page that names some of a directory gets read as naming all of it, and the larger the
page the more completely it is believed (REDS %190).

---

*One tool for the people who make things -- and it begins, as everything here does, by proving the
sound whole before it touches the work. May Lotus open plainly, and may no timeline ever receive a
half-sample.*
