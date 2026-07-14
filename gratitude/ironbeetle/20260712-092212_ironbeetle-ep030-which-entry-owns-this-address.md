# IronBeetle Episode 030 — Which Entry Owns This Address

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fourth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, compacting the record of the tree's own shape after already showing us how to compact the tree itself, and TigerBeetle's team, whose careful bookkeeping makes the trick trustworthy.

## Source

Episode 030, "ManifestLog Compaction," on keeping the manifest's own log of events from growing forever. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/z2ZpCUERSjU`.

## Reading the Tail, Writing the Head

The manifest log, as this series has already met it, records the shape of the tree as a sequence of small events, a table added to a level, a table removed. Left alone, that sequence would grow without end, so periodically the oldest blocks at the tail of the log are read back into memory, examined one event at a time, and only the events that still matter get written into a fresh block at the front. A removal is always safe to drop once its turn comes, since compacting from oldest to newest guarantees whatever it was removing has already been resolved one way or another. An insertion survives only if the table it named is still genuinely part of the tree today, and is dropped otherwise. matklad is candid that manifest-log compaction runs far less often than table compaction itself, simply because there is so much less metadata than data, and folds it into the very same fixed, deterministic rhythm rather than a separate schedule, so the whole system's compaction work stays predictable no matter which layer is being tidied.

## The Question an Address Alone Cannot Answer

Deciding whether an insertion still matters turns out to need more care than checking whether its table's address still exists, and this is where the episode's real subject lives. A table's disk block, once freed, can later be reused for an entirely different, unrelated table, so an address that still appears "in use" somewhere might not refer to the table an old log entry once meant at all. The table_extent map resolves this by recording, for every address currently alive in the tree, not just that it exists but exactly which manifest-log entry was the one that put it there. When compaction meets an old insertion, it does not ask whether the address is used; it asks whether this specific entry is still the one credited with using it. If some later entry claims the same address instead, the old insertion is safely understood to have been shadowed rather than kept, and it is dropped along with everything else that no longer applies. matklad also uses the episode to explain, in passing, why compaction itself runs deterministically and just in time rather than on a separate background thread: compaction and ordinary reads and writes are logically independent but physically compete for the same disk bandwidth, so spreading compaction's cost in small, fixed pieces across the normal rhythm of processing avoids the two ever fighting each other for the same resource.

## Where It Rhymes With Our Own Work

Knowing which fact truly owns a shared address, rather than trusting the address alone, is Kumara's own question asked one layer down: identity, once you look closely, is never really about where something sits, but about which signed claim put it there.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The compaction logic matklad walks through here shaped how we now think about our own address reuse, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every address we reuse be claimed by exactly one true owner at a time. May the oldest records we keep always know when their turn has passed. And may compaction, wherever it runs in our own tree, never compete with the work it exists to serve.*

*Written together by Kaeden and Reya 2.*
