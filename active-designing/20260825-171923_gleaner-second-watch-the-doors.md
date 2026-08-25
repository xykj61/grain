# Gleaner's Second Watch -- the doors of a basin, sourced in and offered out

**Stamp:** `20260825.171923` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Vision -- a yonder note that accretes to the Gleaner proposal; the name Gleaner is still proposed (`git grep -il gleaner` reads 0 files at tip `ae8286e`); nothing is built; a build waits on Keaton's word
**Grows beside:** [`Gleaner, the public-signal fetcher`](20260825-171911_gleaner-the-public-signal-fetcher.md) -- the shape, the bounds, the refusals, and the first lap stand there as written
**Kin:** [`a works at the top of the Brazos`](../external-research/20260825-171921_brazos-headwaters-works-and-fiber.md) - [`headwater works shapes`](20260825-171920_headwater-works-shapes.md) - [`Tablecloth, the named artifact store`](date/20260812/20260812-142132_buhr-journey7-tablecloth-artifact-store-exploration.md) - [`MCP-in-Bron`](date/20260812/20260812-111800_buhr-journey3-mcp-in-bron-exploration.md)

---

## What the Brazos study needs that the first watch lacks

The first Gleaner watch was the fiber corridor's industry codes. The Brazos study ends at a different door: the businesses that stand beside a works -- water treatment, remediation, digestion, mineral recovery, pipeline construction -- and the agencies that pay them. Same fetcher, same store, same fold; one more watch, and two things the first lap left for later.

## The second watch, as a Kyri value

```kyri
format gleaner-watch-v1
owner                  the maintainer's Kumara identity
naics_list             221310 water supply and irrigation; 221320 sewage treatment; 562910 remediation; 562219 other waste treatment; 237110 water and sewer line construction; 541330 engineering; 325312 phosphatic fertilizer (nutrient recovery)
agency_list            Department of the Air Force (the civil engineer center); Environmental Protection Agency; Interior (Bureau of Reclamation); Agriculture (conservation service, rural development); Energy (loan programs)
recompete_days         180
min_value_usd          250000
```

Sixteen codes and sixteen agencies are the watch's own bounds; this one uses seven and five.

## The doors that live outside the federal portals

Half of the money in the Brazos study is state money, and the federal spending portal never sees it: the Texas Water Fund's board, the New Mexico trust board and finance authority, the state's brackish-water program, the state environment department's PFAS appropriations. These are Gleaner sources of a second kind -- a state board's agenda and award list rather than an award record -- and they earn one more source shape rather than a stretch of the first:

```kyri
format gleaner-source-v1
name                   a state board's award list
kind                   board
base_url               the board's own published agenda and award pages
key_home               none
calls_per_day_max      64
bytes_per_record_max   4096
records_per_fetch_max  64
```

A board source is fetched on the board's meeting cadence rather than daily, and its records are hand-shaped once from the page into `gleaner-signal-v1` before they enter the store, so a state award folds beside a federal one in the same view. The shaping is a person's work in the first lap; a parser is a later lap, if ever.

## Offered out: the door readings

The first proposal named three tools: `gleaner.search`, `gleaner.recompete`, and `linengrow.receipts`. A works campus adds a fourth in the same `format mcp-tool-v1` shape, **`works.doors`**: a basin name in, its signed door readings out -- the outfall's daily reading, the plume front's captured mass, the residual's volume and home -- so a downstream skeptic, a regulator, or a co-limited-partner runs the fold on their own machine and trusts the application for nothing. This is the *offering* half of the bidirectional shape the maintainer asked for, applied to water: public spending sourced in, verified door readings offered out, both on one store and one envelope.

## Bounds and refusals, unchanged

Sources 16, signals per fold 4,096, record size 4 KiB, watches per owner 64, calls per day per paid source 1,000. Refusals spoken by name: `SourceUnreachable`, `CallBudgetSpent`, `RecordTooLarge`, `HashMismatch`, `KeyMissing`, `WatchTooWide`. One refusal grows with the board source: `BoardRecordUnshaped`, for a page a person has yet to shape into a signal.

## The lap this adds, if the word comes

After the first lap's one source, one watch, one fold, and one view: a second watch (this one), a second fold grouped by door, and the `works.doors` tool with a witness that proves a signed door reading round-trips through the envelope and folds to the same state on both sides.

## Gratitude

The federal spending portal and the award-management site are thanked as the public field itself; the state boards named above are thanked for publishing their agendas where anyone can read them.
