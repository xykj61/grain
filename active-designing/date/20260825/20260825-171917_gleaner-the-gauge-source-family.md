# Gleaner, the Gauge Source Family -- public water readings alongside public spending

**Stamp:** `20260825.171917` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Vision -- a yonder note, and an **accretion** rather than a new module. It extends the Gleaner proposal with a second source family; if Keaton parks the Gleaner name, this note parks with it and its contents move to whatever the fetcher is eventually called
**Kin:** [`Gleaner, the public signal fetcher`](20260825-171911_gleaner-the-public-signal-fetcher.md) - [`headwaters water shapes`](20260825-171914_headwaters-water-shapes.md) - [`the Missouri's first rung`](../external-research/20260825-171915_gallatin-headwaters-water-and-fiber.md) - [`Tablecloth, the named artifact store`](date/20260812/20260812-142132_buhr-journey7-tablecloth-artifact-store-exploration.md) - [`MCP-in-Bron`](date/20260812/20260812-111800_buhr-journey3-mcp-in-bron-exploration.md) - [`Aparigraha`](../context/APARIGRAHA.md)
**Naming law:** no new module name is proposed here; Gall's Law prefers a second source family inside a module that already exists in design over a sibling module that would duplicate its store, its fold, and its view

---

## The need this answers

The headwaters study ends where the fiber study ended, at the same door with a different sign on it. The fiber study asked *where do you verify a public receivable*. The headwaters study asks **where do you verify a river**.

Both answers are public and free. Federal water services publish continuous streamflow, gauge height, and water-quality readings by station. A national water-quality portal carries discipline-standard results from federal, state, and tribal programmes at named monitoring sites. State environmental agencies publish discharge permits, impairment listings, and load studies. Every one of those is a record somebody already paid for, and the tree has no bounded way to bring them home, hold them by content address, fold them, and look at them beside the spending record.

**One module, two source families.** The spending family answers *who is being paid to do what*. The gauge family answers *what the water actually reads*. Held in one content-addressed store, they answer the Civic question together: **did the money change the water.**

## What this adds to the existing design

Gleaner as proposed already carries a source shape, a signal shape, a watch shape, a content-addressed store, a fold, and a set of Skate views, with an MCP seam in both directions. This note adds one source kind and one signal kind, and reuses the rest unchanged.

```kyri
format gleaner-source-v1
kind                   # primary, aggregator, gauge   <- one new value, nothing else moves
```

```kyri
format gleaner-reading-v1
source                 # gleaner-source name
fetched_at             # from the one clock, TZ=America/New_York
station_id             # the publisher's own station identifier, verbatim
station_name           # as published
basin                  # the basin this station reports on
latitude
longitude
parameter              # discharge, gage height, total nitrogen, total phosphorus, temperature
value
unit                   # carried verbatim from the publisher, never converted at fetch
observed_at            # the publisher's own timestamp, verbatim
qualifier              # provisional, approved, estimated -- carried verbatim
content_hash           # sha3-256 of the raw record; Tablecloth's name binds to this
```

**Two disciplines make this shape correct rather than merely convenient.** The unit and the qualifier travel verbatim from the publisher, because a converted number with a lost qualifier is the exact failure Gauge Style names -- a figure without unit, date, and source is a rumour with a decimal point. And a provisional reading stays labelled provisional in every view, because a fold that quietly promotes provisional data to approved has told a story the log never authorised.

## The sources, ranked by the tree's own preference

Favour original sources; carry only what you use.

| Rank | Source | Cost | Key | What it gives | Bound |
|---|---|---|---|---|---|
| 1 | the federal water-data services for streamflow and gauge height | free | none | continuous discharge and stage by station, with qualifiers | publisher's own rate limit; cache by content address |
| 2 | the national water-quality portal | free | none | nutrient, temperature, and biological results by monitoring site, across federal, state, and tribal programmes | batch by site and by year |
| 3 | state environmental agency records | free | none | discharge permits, impairment listings, load studies | often documents rather than rows; a document goes to external-research by hand |
| 4 | the federal spending portal and award-management site | free | key for one | the spending family, already designed | unchanged from the elder note |

The first three are the gauge family and the fourth is the spending family. **Every one of them is a publisher's own interface, published for the purpose**, which keeps the module inside the refusal it already carries.

## The folds and the views

Two new folds, each with one Skate view in the Dimeroll pattern.

**The ladder** -- readings grouped by station, ordered by elevation or by river mile, for one basin. This is the load ladder shape rendered from live data rather than typed by hand, and it is the view that makes the headwaters argument visible: where the water is born, where the first load enters, what each rung reads.

**Above and below** -- for a named outfall, the paired stations upstream and downstream, with the same parameter side by side over the same window. One frame, two lines, and the plainest possible answer to *what is this works doing to this river*.

Dexter carries the watch in: a person names a basin and a parameter on the glass, the watch becomes a signed Kyri value, and the views re-fold. Nothing in the views is editable; they are projections of an append-only store.

## The two directions

**Sourcing** is the fetch loop above.

**Offering** is where this accretion earns its keep, and it is the piece the headwaters study actually needs. Gleaner publishes two more MCP tools in the `format mcp-tool-v1` shape:

- `gleaner.ladder` -- a basin in, its ordered rungs and their latest readings out.
- `gleaner.reading` -- a station and a window in, the readings with their qualifiers out.

And beside them, the tree's own contribution rather than a mirror of somebody else's: **`linengrow.water`** -- a lot or a site in, its *signed* water chain out. A district, a laboratory, or a watershed group holding a Kumara keypair signs its own readings, appends them, and offers them. The consumer runs the fold on their own machine and needs neither this tree's software nor its permission.

That is the shape the basin work has been reaching for the whole way through. **Public readings in, signed readings out**, on one store and one envelope.

## Bounds and refusals

The elder note's bounds hold. Three are added for the gauge family.

| Bound | Value | Why |
|---|---|---|
| stations per basin block | 64 | matches the retting timer's batch bound; one habit across the tree |
| readings per fold | 4,096 | one screen's worth of memory; grow by measurement |
| window per fetch | 366 days | a year and a leap day; a longer question is several fetches |

Refusals, each spoken by name, alongside the elder set: `StationUnknown`, `WindowTooWide`, `UnitMissing`, `QualifierMissing`.

**`UnitMissing` and `QualifierMissing` are refusals rather than warnings on purpose.** A reading that arrives with no unit or no provisional flag has lost the thing that makes it a measurement, and storing it would put a rumour in a store whose whole value is that it holds facts.

## What this refuses

- **No conversion at fetch.** Units travel verbatim; any conversion happens in a fold that names itself.
- **No interpretation.** The module reports what a publisher published. What a bloom means is a hydrologist's question.
- **No private water data.** Public stations and public programmes only.
- **No build before the word.** This is a yonder note, and it waits on Gleaner's own seat.

## The first lap, if both words come

One basin, one source (the federal streamflow service), one watch, the ladder fold, one Skate view, and one witness proving fetch - hash - store - fold - view with three named refusals. Simple, lovable, complete at that scope. The water-quality portal is the second lap; the offering tools are the third; `linengrow.water` is the fourth and the one worth building toward.

## Gratitude

The federal water-data services, the national water-quality portal, and the state environmental agencies that keep long public monitoring records are thanked as the gauge itself. Decades of unglamorous sampling in cold water by people whose names are on nobody's building is what makes any of this checkable.
