# Append-Only Growth Law — Pin · Season Index · Seasons Roster

**Language:** EN  
**Stamp:** `20260725.040520`  
**Voice:** Quin  
**Status:** Living pin — seated  
**Bound:** under `living_pin_max_bytes`  
**Room:** Checkable  
**Counsel:** [`../../counsel/date/20260725/20260725-040247_what-the-shell-remembers.md`](../../counsel/date/20260725/20260725-040247_what-the-shell-remembers.md)

---

## The law

Every append-only genre grows in three levels so the recursion terminates:

1. **Living pin** — current season only, bounded by `living_pin_max_bytes` (24576). What an agent reads beside its lap.
2. **Season index** — when the pin approaches its bound, closed-season rows fold into one dated index under that genre’s `archive/` (or dated shelf). Immutable thereafter. Fold triggers on the pin’s measured bound, not on a calendar.
3. **Seasons roster** — one living file naming each season: range, count, index path. One line per season; growth is a handful of lines per year. Recursion stops here.

Nothing is deleted. Closed seasons keep their shelf.

## Genres that carry this shape

| Genre | Living pin | Seasons roster |
|-------|------------|----------------|
| Session logs | `session-logs/README.md` | [`session-logs/SEASONS.md`](../../session-logs/SEASONS.md) |
| Waymarks | `waymarks/README.md` | [`waymarks/SEASONS.md`](../../waymarks/SEASONS.md) |
| Counsel | `counsel/README.md` | [`counsel/SEASONS.md`](../../counsel/SEASONS.md) |
| Counsel replies | `counsel/replies/README.md` | [`counsel/replies/SEASONS.md`](../../counsel/replies/SEASONS.md) |
| Expanding prompts | `expanding-prompts/README.md` | [`expanding-prompts/SEASONS.md`](../../expanding-prompts/SEASONS.md) |

Rosters seat now. Folds run when each pin nears its bound.

## Lint

`tools/l/living_docs_lint.rish` duty 6 flags a pin **past** the bound. Companion advisory (same duty family): a pin **near** the bound (at or above 90% of `living_pin_max_bytes`) names the fold as the remedy and points at that genre’s seasons roster. Advisory; never blocking.

## Companion

Pin bound: [`20260724-132812_pin-and-ledger-living-pin-max-bytes.md`](20260724-132812_pin-and-ledger-living-pin-max-bytes.md).

---

*May every index fold before it breaks, and may the roster stay light enough to lift for years.*
