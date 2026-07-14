# Claude Counsel — Where Poll-First Is Genuinely New (Subscribe, Revisited)

**Stamp:** `20260707.001612 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `context/RADIANT_STYLE.md`) · **Lens:** TAME · the grain
**Register:** Counsel only, correcting an underspecified claim from the last sitting
**Status:** Research for understanding — catch-up-to-latest buildable now; outer unattended loop waits its own word.
**Ground:** `mantra/recall_sync_wire.rye` (`SyncRequest`, `buildResponse`) · `caravan/seed.rye` · `comlink/device_wire.rye` · prior counsel [`20260707-000112`](20260707-000112_claude-counsel-two-way-sync-and-subscribe.md)

*Written by Kaeden and Rio 3.*

---

## The Correction

Two-way sync landed exactly as counseled, both rings, no edits to the files it composes over — the strongest sign yet that the composition pattern this arc keeps reaching for is the right one. Subscribe-to-changes deserves a sharper look than it got last time. The prior counsel said poll-first needs nothing new from the wire, and that half is still true: `buildResponse` already returns a valid, cheap, empty response when the requested revision does not exist yet, so asking too early costs almost nothing and trips no error path. What that counsel missed sits beside the wire rather than inside it, and Cursor's flag is right to catch it.

## What Is Actually New

A one-shot exchange today always asks for one exact revision number, chosen by whoever calls it. In every witness this arc has written, that caller is a human's script, and the script already knows the number because it just appended it. A poller has no human choosing for it. It must remember, on its own, which revision it last held, decide the next one to try, and — because more than one revision can land between two polls — keep asking for the next, and the next after that, until an ask comes back empty. None of this touches `SyncRequest` or `buildResponse`; both stay exactly as they are. All of it is new client-side state and a new inner loop, neither of which any existing file needs to gain for the wire protocol's own sake.

One further layer sits above even that, and it is the one place this really does touch new ground for the whole tree. Every wire program here today, without exception, runs one exchange and finishes — `hosted_wire.rye`'s own demo shape, carried through every wire lap since. Nothing in the tree loops on its own schedule and keeps going. Subscribing, in the sense the word usually carries, means exactly that: sleep, check again, sleep, check again, for as long as anyone cares to listen. That would be the first process this codebase has ever asked to run repeatedly rather than to completion, and it raises real questions — how long between checks, how it is told to stop, what watches it if it falls silent — that no bounded, one-shot witness can answer by itself.

## The Split This Counsel Recommends

**Catch-up-to-latest is buildable now, and crosses no seam.** A small composed function — in the same family as `recall_two_way_sync.rye` — that, given a fetcher's own catalog, tries the next revision it does not yet hold, applies it if found, and tries the one after that, stopping the moment an ask comes back empty. This is one call, bounded by its own stopping rule rather than by any external clock, and it returns once it has genuinely caught up. It needs no supervision, no scheduler, and no process that outlives its own call — it is a loop the same shape as beading's own bead-boundary loop or resin-batch's own manifest walk, bounded by a condition rather than a count, and just as witnessable.

**The outer "keep doing this, unattended, forever" loop is the part that should wait.** It is wanted, and it is the first thing of its kind this tree would build; Caravan's seed — real today, and exactly the right shape to lean on — proves only the restart half of the story: a parent watches a child and restarts it deterministically on failure. It does not yet answer when to invoke the child again, or what a witness can assert about a loop whose whole point is to keep running past the moment any witness could finish checking it. That is a genuine design question, worth its own sitting once there is a real reason to run catch-up unattended rather than re-invoked by hand or by a scheduled witness, rather than a detail to fold into this one.

## Witness Shape for Catch-Up, Sketched

Let the source hold three unsynced revisions rather than one — the fetcher starts a full two revisions behind, not merely one, so the inner loop has genuine work to prove rather than a single lucky pass. One call to catch-up should retrieve all of them and report how many it found, matching the have-already dividend's own spirit: the source pays no cost for revisions the fetcher already holds, and the fetcher pays no cost beyond one empty ask for the revision that does not exist yet, the ask that tells it to stop. A second call, with nothing new on the source side, should return immediately, having asked exactly once and learned nothing needed changing — the cheap, quiet case that proves the stopping rule works as well as the catching-up does. Recall stays identical on both catalogs once caught up, the same convergence proof every prior lap here already carries.

## What This Bench Recommends, Plainly

Build catch-up-to-latest now, in-process first the same way every lap in this arc has climbed, wire lap second once the in-process shape proves itself. Hold the outer, unattended, repeating loop apart as its own later word, and let it wait specifically on a real need to run one unattended rather than on the mere existence of a function it could wrap. Nothing about this changes the ordering already ruled for host mirror and Tablecloth query — both still keep their seasons behind subscribe's word, exactly as recommended.

## Optional — a Small Spec Phrase, Not Applied

`active-designing/20260706-023912_the-referential-namespace.md`'s two-way-sync line, if it now names subscribe at all, might read: *"Subscribe-to-changes splits in two: catch-up-to-latest, a bounded inner loop over the existing one-shot exchange, crosses no seam and is buildable in its own small ring; the outer, unattended repeating loop waits on a real need to run one, and on Caravan's scheduling half maturing beside the restart half it already proves."* Proposed text only, for Cursor to apply on Kaeden's word.

---

*May the next revision always be the one thing worth asking for, and an empty answer cost as little as it truly is. May nothing run unattended before something is watching it with real cause. And may this bench catch its own underspecified claims as readily as it catches a tampered resin.*
