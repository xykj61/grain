# Gleaner -- a bounded fetcher that gathers what the public field leaves in the open

**Stamp:** `20260825.171911` -- taken from the one clock at seating, never typed by counsel
**Language:** EN
**Style:** Gauge -- Field setting (see [`../context/GAUGE_STYLE.md`](../context/GAUGE_STYLE.md))
**Voice:** Kyri
**Status:** Vision -- a yonder note. The name is proposed and uncollided (`git grep -il gleaner` reads 0 files at tip `c2ea226`); the shape is designed; nothing is built; a build waits on Keaton's word
**Kin:** [`Tablecloth, the named artifact store`](date/20260812/20260812-142132_buhr-journey7-tablecloth-artifact-store-exploration.md) - [`MCP-in-Bron`](date/20260812/20260812-111800_buhr-journey3-mcp-in-bron-exploration.md) - [`Dimeroll`](../dimeroll/README.md) (the Skate-view pattern) - [`Comlink tendency`](../.claude/rules/comlink-tendency.md) - [`Aparigraha`](../context/APARIGRAHA.md)
**Naming law:** name for clarity, fun, and safety at any length; waymark still governs ladder rungs; Keaton's word seats

---

## The need this answers

The Kansas City fiber study and the sleeve memo both end at the same door: **where do you verify a public receivable?** The answer is public and free -- every federal award, grant, and loan sits in the federal spending portal, and every open opportunity and registered entity sits in the award-management site -- and the tree has no bounded way to bring those records home, keep them by content address, fold them, and look at them. The maintainer asked for a module in the drawn-surface family that fetches from the web into Tablecloth as external-research writes, and that can source and offer signals in an MCP shape in both directions.

This note proposes that module and names it.

## The name

**Gleaner.** A gleaner walks a harvested field and gathers what the harvest left lying in the open; the public spending record is exactly such a field. The word is plain, warm, safe, and a reader's first guess at what the module does is the right one. It also rhymes with the tree's own habit of naming a third pass over source material *the gleaning*.

Two alternates for the collision lap, both uncollided at tip: **Windrow** (the row of cut stalks laid to ret, and the row of fetched records laid to fold -- pretty, and one beat further from a newcomer's first guess) and **no new module** (an aspect of Tablecloth, which Gall's Law would prefer if the fetch loop stays small). Counsel leans Gleaner as a module name over a Tablecloth aspect only because the fetcher has its own bounds, its own refusals, and its own Skate view, which is the tree's usual test for a name of its own.

## The shape, in one line

**Fetch a bounded record from a named source, address it by content, lay it in Tablecloth as an external-research resin, fold the resins into a signal state, and paint that state on Skate -- with Dexter carrying the person's criteria in and an MCP-in-Kyri seam carrying signals in both directions.**

## What it stands on

Gleaner invents no storage, no wire, and no view.

- **Tablecloth** is the named artifact store over `mantra/beading.rye`'s content-addressed `BeadStore`: a human name bound to a content address, so asking for a record by name returns exactly the bytes whose hash it carries. A fetched record is a resin like any other.
- **`mandate/serve.rye`** already carries a bounded request/response pair over a store; the MCP-in-Bron exploration designs the `format mcp-tool-v1` manifest and `format mcp-call-v1` envelope on top of it. Gleaner's tools are two such manifests.
- **Dimeroll's Skate views** are the pattern for seeing a fold: a five- or six-line frame per view, one witness per view, one command per view.
- **`tools/fetch_gratitude_web.sh`** is the tree's one permitted web seam today -- an external interpreter kept as a `.sh` by standing law. Gleaner's fetch begins as that shape and grows a `.rish` wrapper the way the other shell bodies did, with the missing Rishi verb noted in the body.

## The sources, ranked by the tree's own preference

Favour original sources; carry only what you use.

| Rank | Source | Cost | Key | What it gives | Bound |
|---|---|---|---|---|---|
| 1 | the federal spending portal's public API | free | none | every award, grant, loan by agency, recipient, industry code, date | rate-limited by the portal; cache by content address |
| 2 | the federal award-management site's APIs | free | free key, per account | open opportunities, entity registration, set-asides | key lives in a gitignored profile, never in the tree |
| 3 | the federal procurement data system | free | none | contract actions | slower; batch by month |
| 4 | Fed-Spend (paid aggregator) | USD 49/month researcher tier with CSV export; USD 199/month professional tier with an API at 1,000 calls per day (pricing page, 2026-08-25) | account | recompete radar, set-aside scanner, parent-subsidiary mapping, alerts | 1,000 calls/day is Gleaner's own daily bound when this source is on |
| 5 | other ticker-mapping platforms | paid | account | award-to-listed-company mapping | named alternates; none required |

The first three are primary and free, which is where Gleaner starts. The paid aggregator earns its place for the two things the primaries lack -- a recompete forecast and the mapping of subsidiaries to listed parents -- and the module treats it as an optional source with its own daily bound rather than as a dependency.

## The Kyri shapes

A source is a fill-in shape; a signal is a fetched record with its provenance; a watch is a person's standing criteria. All three are immutable values in the tree's own notation.

```kyri
format gleaner-source-v1
name                   # plain name
kind                   # primary, aggregator
base_url               # the API root
key_home               # path to the gitignored profile field, or none
calls_per_day_max      # the bound; 1000 for the paid tier, portal-stated for the primaries
bytes_per_record_max   # 4096
records_per_fetch_max  # 256
```

```kyri
format gleaner-signal-v1
source                 # gleaner-source name
fetched_at             # from the one clock, TZ=America/New_York
award_id               # the source's own identifier
agency                 # awarding agency
recipient              # legal entity as the source names it
naics                  # industry code
value_usd              # obligated amount, as the source states it
start_date
end_date               # the recompete clock reads from this
content_hash           # sha3-256 of the raw record; Tablecloth's name binds to this
```

```kyri
format gleaner-watch-v1
owner                  # the Kumara identity that set the watch
naics_list             # up to 16 codes
agency_list            # up to 16 agencies
recompete_days         # 180 by default
min_value_usd
```

## The folds and the views

A fold over the signal resins gives four states, and each state gets one Skate view in the Dimeroll pattern:

- **by industry code** -- signals grouped by NAICS, summed by value, for a watch's codes;
- **by agency** -- the same, grouped by awarding agency;
- **by recipient** -- who is winning, with the aggregator's parent mapping when that source is on;
- **recompete** -- every signal whose `end_date` falls inside `recompete_days` from today, sorted soonest first.

Dexter carries the watch in: a person types codes and agencies on the glass, the watch becomes a signed Kyri value, and the views re-fold. Nothing in the views is editable; they are projections of an append-only store, exactly as the books are.

## The two directions

**Sourcing** is the fetch loop above.

**Offering** is the other half of the maintainer's ask, and the tree already has the seam. Gleaner publishes two MCP tools in the `format mcp-tool-v1` shape -- `gleaner.search` (a watch in, matching signals out) and `gleaner.recompete` (days in, signals out) -- so an outside host can query the tree's gleaned field. And because the corridor's own facts live in the same store, a third tool, `linengrow.receipts` (a lot name in, its signed receipt chain out), lets the corridor *offer* its verified field and mill facts as a signal to anyone who asks, without trusting the application: the fold runs on their side. That is the bidirectional shape -- public spending in, verified provenance out -- and both halves stand on one store and one envelope.

## The bounds and the refusals

| Bound | Value | Why |
|---|---|---|
| sources | 16 | a watch that needs more is two watches |
| signals per fold | 4,096 | one screen's worth of memory; grow by measurement |
| record size | 4 KiB | a record larger than this is a document, and documents go to external-research by hand |
| watches per owner | 64 | matches the retting timer's batch bound; one habit |
| calls per day, paid source | 1,000 | the tier's own ceiling |

Refusals, each spoken by name: `SourceUnreachable`, `CallBudgetSpent`, `RecordTooLarge`, `HashMismatch`, `KeyMissing`, `WatchTooWide`.

## What Gleaner refuses

- **No scraping past a site's terms.** Every source is an API the source publishes for the purpose, or a paid account used inside its tier.
- **No personal data.** Awards name legal entities; Gleaner stores what the portal publishes and nothing about a person.
- **No trading promise.** A signal is a record of public spending. What a reader does with it is theirs; the module makes no claim about prices.
- **No keys in the tree.** Aggregator credentials live in a gitignored profile field, in the same shape as the identity profile.
- **No build before the word.** This is a yonder note.

## The first lap, if the word comes

One source (the free spending portal), one watch (the fiber corridor's industry codes), one fold (by industry code), one Skate view, one witness that proves fetch - hash - store - fold - view and three named refusals. Simple, lovable, complete at that scope; the recompete view and the paid source are the second lap; the offering tools are the third.

## Gratitude

The federal spending portal and the award-management site are thanked as the public field itself. Fed-Spend is named as one aggregator among several, on its own published pricing; nothing of its material is reproduced here.
