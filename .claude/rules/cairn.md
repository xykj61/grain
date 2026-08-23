# Cairn — mark the way back before you debride

**Seated:** `20260809.024851` on Keaton's word · **Status:** Living
**Ledger:** [`../../construction/CAIRNS.md`](../../construction/CAIRNS.md)
**Kin:** [`debride.md`](debride.md) — debride removes; a cairn marks the way back first.
**Cursor twin:** [`../../.cursor/rules/cairn.mdc`](../../.cursor/rules/cairn.mdc)

A **cairn** is a stacked-stone trail marker. Before any **seated debride** that rewrites a living card — REMEMBER, THREADS, TASKS, ROADMAP, or any work-in-progress file whose old body may hold ideas worth recalling — record one row in `construction/CAIRNS.md` so the departing card stays one `git show` away.

## What a cairn always records

1. **Walk-back nib** — `git rev-parse --short=10 HEAD` **before** the debride's own commit. The old files live at that nib and every commit before it.
2. **Live stamp** — `TZ=America/New_York date +%Y%m%d.%H%M%S`. One clock; never fabricated.
3. **Swept** — which living cards the debride rewrites, and roughly how much fell away.
4. **What waits there, worth recalling** — one honest line naming the good ideas or detail folded into the old body, so a future reader knows whether the walk-back is worth taking.

## Discipline

- **A cairn precedes the debride, never trails it.** For a *deep* debride (history rewrite + force-push), the cairn is mandatory and must land first — after the rewrite the walk-back commit is unreachable on the shared remotes. The Haunted Mound deep debride taught this by losing its own walk-back; that loss is why this pattern exists.
- **Append-only.** Cairns are never edited or removed — the whole point is a durable pointer. Newest first in the ledger.
- **A cairn is not a session log and not a remember.** `remember` reprints the *current* card; a cairn pins the *departing* one. Both may ride in the same send.

## Why the word exists

Debride is a clean, sanctioned break of accrete-never-break — yet a card that reads well often carried a stray good idea in a row we swept. A cairn costs one line and keeps every old card recoverable at a named commit, so the tree can cut freely without ever truly losing a thought.
