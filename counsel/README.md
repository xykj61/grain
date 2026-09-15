# The Counsel Stack

**Language:** EN
**Last updated:** 2026-07-26 (`20260726.075641` workshop charter - r7.5)  
**Style:** Gauge, Door setting (see `../context/GAUGE_STYLE.md`)
**Status:** Foundation  
**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is
[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)
**Chapters roster:** [`CHAPTERS.md`](CHAPTERS.md)

---

## Status -- this room is closed, and kept

**Closed:** `20260821.174047` - **Folded to** `date/YYYYMMDD/` on `20260821.171105` - **Newest dated file:** `20260913-143321`

**Ten pieces carry a stamp later than the close**, read `20260915.194421`: one on `20260826`, four
on `20260908`, four on `20260912`, and one on `20260913`, the newest two days old. The close stands
as seated law ([`../.claude/rules/design-rooms.md`](../.claude/rules/design-rooms.md)), and it names
`20260805.000001` as the last dated file, which the room has since passed. Whether this room reopens
or those ten belong in another room is Keaton's word; the figure is here so a reader meets the tree
rather than the claim. Both readings are **free** -- run
`git ls-files 'counsel/' | grep -oE '[0-9]{8}-[0-9]{6}' | sort | tail -1`.

This room served a workflow the bench has since outgrown: counsel drafted in a web chat, exported as text and archives, and carried into the bench by hand. The bench and the counsel are one hand now, so a question and its answer land in the same round rather than crossing a boundary between two tools.

**Everything here is kept, whole, and true.** **935** dated pieces stand exactly as filed and **2,623** path mentions elsewhere in the tree point into them, both read `20260915.194421` and both **free** -- run `git ls-files 'counsel/' | grep -cE '(^|/)[0-9]{8}-[0-9]{6}[_.]'` and `git grep -ohE 'counsel/[A-Za-z0-9_./-]+' -- . ':!counsel' | wc -l` rather than reading these. Every citation still resolves -- [`../tools/d/dated_path_resolve.rish`](../tools/d/dated_path_resolve.rish) finds a piece from any path it was ever cited by. Closed is a claim about growth rather than about truth: every piece in the room stays true, and the ten later stamps above are where that word and the tree part.

**Where its work continues:** a ruling that needs seating goes to [`../context/specs/`](../context/specs/) or its module home; a shape still being reasoned about goes to [`../active-designing/`](../active-designing/); a round scoping its own lap goes to [`../active-development/`](../active-development/README.md); the record of what happened goes to [`../session-logs/`](../session-logs/README.md).

**Mined on touch, one piece at a time.** When living work cites a piece here, lift that piece's live insight into the room it belongs in *then*. Reading 935 files to extract insight is a project measured in weeks with an unknowable yield -- it would stall, and both ends serve a reader better than a half-converted room.

---

## What This Folder Is

This is where the bench answers what Kaeden asked. The `counsel/` folder holds analysis, rulings, proposals, and recommendations delivered in response to a specific question about this project's own pending decisions. A study of an external work stays in `external-research/`, and a decision made and seated lives in `active-designing/` or wherever the decision's own home is once Kaeden's word lands. Every piece here proposes, and Kaeden's word is what seats. Propose-never-seat is the whole reason this folder exists -- counsel proposes; Kaeden seats.

Each entry stays exactly as written the day it was filed. A later counsel document may revisit, refine, or overturn an earlier one -- the ruling that MUR (then MALA) still awaited graduation stands beside the fold-gap it found, both permanent, both kept exactly as written.

Filing law: [`../ORGANIZING.md`](../ORGANIZING.md) - reorg proposal: [`20260707-180712_claude-proposal-counsel-folder-reorganization.md`](date/20260707/20260707-180712_claude-proposal-counsel-folder-reorganization.md).

---

## Counsel -- where the pieces are

This room is closed, so its index is finished rather than growing. Every row folded onto a dated
shelf on `20260824.152800`, one shelf per day, and the [seasons roster](CHAPTERS.md) lists all ten
with their counts. A shelf reads exactly as this page read before the fold -- stamp, title, and
one line of what the piece holds -- so the way in is the same, one day at a time:

| Day | Pieces | Shelf |
|---|---:|---|
| `20260704` | 3 | [`date/README-index-20260704.md`](date/README-index-20260704.md) |
| `20260706` | 1 | [`date/README-index-20260706.md`](date/README-index-20260706.md) |
| `20260707` | 24 | [`date/README-index-20260707.md`](date/README-index-20260707.md) |
| `20260708` | 1 | [`date/README-index-20260708.md`](date/README-index-20260708.md) |
| `20260711` | 6 | [`date/README-index-20260711.md`](date/README-index-20260711.md) |
| `20260712` | 3 | [`date/README-index-20260712.md`](date/README-index-20260712.md) |
| `20260724` | 14 | [`date/README-index-20260724.md`](date/README-index-20260724.md) |
| `20260725` | 46 | [`date/README-index-20260725.md`](date/README-index-20260725.md) |
| `20260726` | 13 | [`date/README-index-20260726.md`](date/README-index-20260726.md) |
| `20260731` | 1 | [`date/README-index-20260731.md`](date/README-index-20260731.md) |

That is **112 indexed pieces** across ten days. The room holds **935** dated files in all, and a
piece beyond the index is found the way any dated piece is:
`rishi/bin/rishi run tools/d/dated_path_resolve.rish <reference>` computes its home from the
stamp in its own name.

---

*May every question find the drawer built for it. May counsel propose plainly, and may Kaeden's word be what seats.*

