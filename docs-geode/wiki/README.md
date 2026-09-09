# The Wiki -- how the shelf connects, both ways

**Language:** EN - **Style:** Gauge (see `../../context/GAUGE_STYLE.md`)
**Written:** `20260821.190149` - **Status:** Living
**Kind:** the shelf's connective tissue -- a crushed index of every page under [`../`](../)
**Where this sits:** home is [`../../README.md`](../../README.md) - a first hour in your hands is
[`../tutorials/the-first-hour.md`](../tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

*A wiki lives in the links between its pages. This is the geode's own crosslink map -- every shipped page, what it leads to, and what leads back.*

---

## The shipped pages

| Page | Leads to | Reached from |
|---|---|---|
| [tutorials / **The First Hour**](../tutorials/the-first-hour.md) | the api reference, the libraries index, the manual's welcome, SOURCE.md | the root README, `docs-geode/edu/yonder/`, `demos/`, `study/` |
| [api / **Rishi language reference**](../api/rishi-language-reference.md) | the first hour, `rishi/README.md`, the libraries index | `study/`, `docs-geode/edu/yonder/`, `tutorials/` |
| [libraries / **The Libraries**](../libraries/README.md) | every room holding Rye modules, counted on that page | `study/`, `api/`, `tutorials/` |
| [study / **How to read this tree**](../study/README.md) | reading a name, foundations, active-designing, session-logs, REDS, gratitude, the compass | this page |
| [study / **Reading a name**](../study/reading-a-name.md) | the clock-and-mark foundation, the stamp-and-name law, `demos/` | `study/`, this page |
| [demos / **Five checks you can run**](../demos/README.md) | the first hour, the resolver, the sha3 witness, the room bound, the fascia meter, the announcement scan, reading a name | `study/`, this page |
| [edu / **The teaching surfaces**](../edu/README.md) | the manual, `docs-geode/edu/yonder/` drafts, SOURCE.md, the api reference | this page |
| [press / **What has been said publicly**](../press/README.md) | the four announcements in `press/` | this page |
| [sangha / **the patterns**](../sangha/README.md) | descriptor exchange, fact fold, five primitives | this page |
| [sangha / **Pattern one -- the descriptor exchange**](../sangha/01-descriptor-exchange.md) | the four `comlink/discovery/` modules, the bounds brix, the pattern book | `sangha/`, pattern three |
| [sangha / **Pattern two -- the fact fold**](../sangha/02-fact-fold.md) | `mycelium/` fold, build_bounds, kumara and copy; the fact-fold brix; patterns one and three | `sangha/`, pattern three |
| [sangha / **Pattern three -- the five primitives**](../sangha/03-five-primitives.md) | patterns one and two, the six `mycelium/` modules it was written from, the bounds brix | `sangha/` |
| [tutorials / **recursion in Glow**](../tutorials/recursion-in-glow.md) | the Glow desk | `tutorials/` |
| [tutorials / **Shopping**](../tutorials/SHOPPING.md) | the first hour, Gauge Style, TAME Guidance | the root README, `tutorials/`, the first hour |
| [tutorials / **Running the fleet**](../tutorials/running-the-fleet.md) | the fleet roster, the baton, the live card, the first hour | `tutorials/`, the shelf front door |
| [blog / **Eighteen times, two agents did the same job**](../blog/20260908-081630_eighteen-times-two-agents-did-the-same-job.md) | the root README, the first hour, SOURCE.md | `blog/`, this page |

## Why the "reached from" column matters

A page finds its readers through the pages that link to it. The right-hand column above is the honest check: **every page on this shelf is reachable from at least one other**, and the two entry points -- the root README and `study/` -- reach the rest within two hops.

That is the whole discipline of a wiki here: a promise that following any thread gets you somewhere, and that somewhere leads back.

## What is missing, named plainly

`etc/` stands empty and its own README says so plainly. `templates/` carries a pointer crush. `blog/` opened with its first piece on `20260908` and now carries a row like any other room. When a page enters a room, it earns a row above -- **a row in this table is how the shelf finishes admitting a page.**

**The room doors are ways in rather than shipped pages.** `api/README.md`, `tutorials/README.md`, and the shelf's own [front door](../README.md) each stand behind the row that names their room, so this table lists what the shelf ships.

**Four pages joined this table on `20260906`.** [Shopping](../tutorials/SHOPPING.md) had stood in
`tutorials/` since `20260823`. Four other pages linked it, and it sat one hop from the first hour.
It was present everywhere except on the map that promises every shipped page.

The three sangha pattern pages stood outside for a subtler reason. This page links
`sangha/README.md`, and a link entering a room counted the whole room as listed. **A room's door is
a different promise from the pages behind it**, and a guard reading one floor reads the two as one.
So the walk that finds them reads a floor deeper now. This page declares itself a **crushed index of
every page under [`../`](../)** in its own header, and
[`../../tools/cr/crushed_index_witness.rish`](../../tools/cr/crushed_index_witness.rish) walks the
whole shelf against it each lap.

**And the three pattern pages lead somewhere now.** Each one cites the code that proved it. On
`20260906` those citations became links, clickable for a reader and readable by
[`../../tools/fixtures/t/tracked_link_scan.sh`](../../tools/fixtures/t/tracked_link_scan.sh), which
follows a link and reads past a backtick. Every page also carries a **Shelf** line home to the
pattern book, whose row stands three lines above. The column above held an honest *nothing yet*
until the day it could say what each page leads to. Today it says it, and the pattern book is a
place you can arrive at, read from, and leave by the same thread you came in on.

---

*May every thread you pull lead somewhere, and may somewhere lead back.*
