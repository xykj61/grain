# The Wiki -- how the shelf connects, both ways

**Where this sits:** home is [`../../README.md`](../../README.md) - a first hour in your hands is
[`../tutorials/the-first-hour.md`](../tutorials/the-first-hour.md) - the whole
path from nothing to a signed, sandboxed home is [`../../SOURCE.md`](../../SOURCE.md)

*A wiki is not a pile of pages; it is the links between them. This is the geode's own crosslink map -- every shipped page, what it leads to, and what leads back.*

**Language:** EN - **Style:** Gauge (see `../../context/GAUGE_STYLE.md`)
**Written:** `20260821.190149` - **Status:** Living
**Kind:** the shelf's connective tissue -- a crushed index of every page under [`../`](../)

---

## The shipped pages

| Page | Leads to | Reached from |
|---|---|---|
| [tutorials / **The First Hour**](../tutorials/the-first-hour.md) | the api reference, the libraries index, the manual's welcome, SOURCE.md | the root README, `docs-geode/edu/yonder/`, `demos/`, `study/` |
| [api / **Rishi language reference**](../api/rishi-language-reference.md) | the first hour, `rishi/README.md`, the libraries index | `study/`, `docs-geode/edu/yonder/`, `tutorials/` |
| [libraries / **The Libraries**](../libraries/README.md) | 38 module READMEs | `study/`, `api/`, `tutorials/` |
| [study / **How to read this tree**](../study/README.md) | reading a name, foundations, active-designing, session-logs, REDS, gratitude, the compass | this page |
| [study / **Reading a name**](../study/reading-a-name.md) | the clock-and-mark foundation, the stamp-and-name law, `demos/` | `study/`, this page |
| [demos / **Four things you can run**](../demos/README.md) | the first hour, the resolver, the sha3 witness, the room bound, the fascia meter | `study/`, this page |
| [edu / **The teaching surfaces**](../../docs-geode/edu/yonder/README.md) | the manual, `docs-geode/edu/yonder/` drafts, SOURCE.md, the api reference | this page |
| [press / **What has been said publicly**](../press/README.md) | the four announcements in `press/` | this page |
| [sangha / **the patterns**](../sangha/README.md) | descriptor exchange, fact fold, five primitives | this page |
| [sangha / **Pattern one -- the descriptor exchange**](../sangha/01-descriptor-exchange.md) | the four `comlink/discovery/` modules, the bounds brix, the pattern book | `sangha/`, pattern three |
| [sangha / **Pattern two -- the fact fold**](../sangha/02-fact-fold.md) | `mycelium/` fold, build_bounds, kumara and copy; the fact-fold brix; patterns one and three | `sangha/`, pattern three |
| [sangha / **Pattern three -- the five primitives**](../sangha/03-five-primitives.md) | patterns one and two, the six `mycelium/` modules it was written from, the bounds brix | `sangha/` |
| [tutorials / **recursion in Glow**](../tutorials/recursion-in-glow.md) | the Glow desk | `tutorials/` |
| [tutorials / **Shopping**](../tutorials/SHOPPING.md) | the first hour, Gauge Style, TAME Guidance | the root README, `tutorials/`, the first hour |

## Why the "reached from" column matters

A page nobody links to is a page nobody finds, however good it is. The right-hand column above is the honest check: **every page on this shelf is reachable from at least one other**, and the two entry points -- the root README and `study/` -- reach the rest within two hops.

That is the whole discipline of a wiki here. Not a search box; a promise that following any thread gets you somewhere, and that somewhere leads back.

## What is missing, named plainly

`blog/` and `etc/` hold no pages, and their own READMEs say why rather than pretending. `templates/` carries a pointer crush. When a page enters any of them, it earns a row above -- **a page that is not in this table is a page the shelf has not finished admitting.**

**The room doors are ways in rather than shipped pages.** `api/README.md`, `tutorials/README.md`, and the shelf's own [front door](../README.md) each stand behind the row that names their room, so this table lists what the shelf ships.

**[Shopping](../tutorials/SHOPPING.md) joined the table on `20260906`, and three sangha pattern pages joined it the same day.** Shopping had stood in `tutorials/` since `20260823`, linked from four other pages and one hop from the first hour -- present everywhere except on the map that promises every shipped page. The reading that catches the next one now exists: this page declares itself a **crushed index of every page under [`../`](../)** in its own header, and [`../../tools/cr/crushed_index_witness.rish`](../../tools/cr/crushed_index_witness.rish) walks the whole shelf against it each lap.

**And the three pattern pages lead somewhere now.** Each one cites the code that proved it, and on
`20260906` those citations became links -- clickable for a reader, and readable by
[`../../tools/fixtures/t/tracked_link_scan.sh`](../../tools/fixtures/t/tracked_link_scan.sh), which
follows links and reads past a backtick. Every page also carries a **Shelf** line home to the
pattern book, whose row stands three lines above. The column above kept an honest *nothing yet* until
the day it could say what each page leads to, and today it says it: the pattern book is a place you
can arrive at, read from, and leave by the same thread you came in on.

**What the deeper walk found on its first run.** Three pattern pages -- [one](../sangha/01-descriptor-exchange.md), [two](../sangha/02-fact-fold.md), [three](../sangha/03-five-primitives.md) -- had never had a row here, and the one-level reading could not see them: this page links `sangha/README.md`, and a link entering a room counts the room as listed. So a map promising every shipped page was green over three pages it had never named, for the same reason it had been green over Shopping. **A room's door is not the same promise as the pages behind it**, and a guard reading one floor cannot tell the two apart.

---

*May every thread you pull lead somewhere, and may somewhere lead back.*
