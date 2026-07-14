# IronBeetle Episode 034 — A Callback That Must Never Choose

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fourth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, finishing what the previous episode's clock cut short, and TigerBeetle's team, whose worker pool makes a thousand parallel lookups feel like one honest queue.

## Source

Episode 034, "Prefetching From Disk," completing the trace of a batch prefetch by following the accounts that were not already in memory. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/MWy_mrmE4gs`.

## Many Lookups, One Bounded Pool

matklad picks up exactly where the last session left off, with a batch of accounts that neither cache could answer and now genuinely need a trip to disk. A small, fixed pool of workers carries this out, each one walking the manifest's levels from wherever the earlier in-memory check left off, reading an index block and then the one relevant data block whenever a level's table is not already cache-resident, checksum-first exactly as this entire series has practiced from its very first episode. The pool's own size is bounded the same way every concurrent resource in this project is bounded, and a counter tracks outstanding work so the caller's own callback fires exactly once, at the true end, regardless of how many individual lookups happened to finish first.

## The Rule Behind the Rule

The real weight of the episode lands on a single, absolute discipline: an asynchronous function must never sometimes call its callback synchronously and sometimes asynchronously. matklad earns this rule twice, from two different directions, rather than asserting it once. The first is mechanical: if enough lookups happen to resolve instantly and each one calls straight back into the loop that started it, the call stack simply grows with no floor beneath it, a straightforward, traceable overflow. The second is subtler and, in his own telling, the more important of the two: code that is midway through changing an object, having deliberately broken some invariant for a moment in order to restore it properly a few lines later, can be reentered by a callback firing on the same stack before that repair finishes, and whatever runs inside that callback now sees a half-changed object that was never meant to be visible to anyone. matklad names this exact shape as the cause behind a well-known real-world memory-safety vulnerability in the Rust ecosystem, a strong claim about the size of the idea, offered plainly rather than as a passing aside. The fix throughout is the same one already used elsewhere in the series: force even an instantly-available result through the event loop's own next tick, so a caller can trust, without exception, that "asynchronous" always means asynchronous.

The episode closes by drawing a hard line between two neighboring pieces of the system that must never blur into one another: prefetch, fully parallel and free to complete in whatever order the disk allows, and commit, which follows immediately after and must run in one strict, unbroken, sequential order, because correctness for financial transfers has no other honest shape.

## Where It Rhymes With Our Own Work

A boundary that must be crossed all the way or not at all, never half-crossed and never revisited midway, is our own stop-and-park instinct in miniature: some moments genuinely do not admit of "mostly done."

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The async discipline matklad walks through here shaped how we now think about our own callback boundaries, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every promise of asynchrony we make hold true without exception. May the moments we deliberately leave unfinished always be repaired before anyone else can see them. And may parallel work and sequential work in our own tree stay as clearly divided as they are here.*

*Written together by Kaeden and Reya 2.*
