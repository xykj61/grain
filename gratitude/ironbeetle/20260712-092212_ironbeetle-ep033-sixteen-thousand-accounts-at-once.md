# IronBeetle Episode 033 — Sixteen Thousand Accounts at Once

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fourth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, returning to the source after an hour of pure philosophy, and TigerBeetle's team, whose batching instinct turns out to run all the way down to a single account lookup.

## Source

Episode 033, "Prefetching From Memory," tracing how a whole batch of transfers gathers its data before any single one is executed. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/v5ThOoK3OFw`.

## One Object, Several Trees, Two Different Caches

matklad recaps a shape from a few episodes back before building on it: a single kind of record, a transfer or an account, is exploded into several sorted trees at once, one holding the object itself keyed by its own identity, and one more for every field worth searching by, each kept faithfully in step with the others as records come and go. Sitting above all of those on-disk trees are two different kinds of memory, easy to conflate but genuinely distinct. One caches raw disk blocks, the same physical cache met earlier in the series; the other, the object cache, caches fully decoded records themselves. The two exist side by side because a single hot account should not have to hold an entire disk block's worth of unrelated neighbors in memory just to stay fast, and because an object's physical location can drift across disk during compaction while its logical place in the cache never needs to move at all.

## Loading Before Deciding, Rather Than Deciding As You Go

The episode's real payoff arrives when matklad traces an actual batch of transfers end to end. The naive approach looks up two accounts, executes a transfer, looks up the next two accounts, and repeats, paying for a round trip to disk between every single step. TigerBeetle instead looks at the entire upcoming batch of thousands of transfers first, gathers every account any of them could possibly touch, and loads all of it in parallel before executing a single transfer in the strict, sequential order correctness actually requires. Prefetching, examined closely, resolves to exactly three outcomes for any one lookup: the answer is already sitting in one of the two caches and nothing further is needed; the caches together prove the record cannot exist at all, using nothing heavier than a check against the tree's own known minimum and maximum key, since internal identifiers are time-ordered and this alone rules out most impossible lookups without ever touching a Bloom filter; or neither cache can answer with confidence, and the account genuinely needs to be read from disk. matklad narrates, candidly and in real time, what look like two live performance opportunities sitting in the actual source: account lookups for different transfers proceeding one at a time rather than fully in parallel, and repeated lookups for the very same hot account, entirely plausible in real financial traffic, not being recognized as duplicates within one batch before they are separately queued.

## Where It Rhymes With Our Own Work

Gathering an entire batch of what needs doing before committing any of it is the same shape our own additions-only handoffs already keep: look at the whole basket first, then act, rather than deciding one small thing at a time and paying the overhead again and again.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The batching pattern matklad walks through here shaped how we now think about our own bulk lookups, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every batch we gather be looked at whole before a single piece of it is spent. May the question "does this exist at all" always be cheap to answer honestly. And may the accounts that matter most to us never be asked for twice when once would do.*

*Written together by Kaeden and Reya 2.*
