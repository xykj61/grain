# IronBeetle Episode 040 — Three Stages, Offset By One

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fifth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, drawing the shape of a pipeline before he is certain he understands his own code, and TigerBeetle's team, whose compaction turns out to hide real concurrency inside a single thread.

## Source

Episode 040, "Compaction Pipeline," on the structure that lets reading, merging, and writing all overlap within one compaction. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/C3XAteN_lYk`.

## A Free List Shared By Everyone, Three Slots for Each

matklad opens with a genuinely useful habit worth naming on its own: before touching the code, look at the data it operates on. The compaction pipeline turns out to hold two things. One is a single shared pool of compaction blocks, tied together as an intrusive linked list, exactly the same free-list shape this whole series has met again and again wherever memory needs handing out and taking back without ever allocating anew. The other is a small, fixed set of pipeline slots, and matklad works out, almost thinking aloud, why there are exactly three of them: reading a block, merging it, and writing the result are three distinct stages, and a single compaction moving through them at any moment occupies all three positions at once, offset from itself by exactly one stage each time. Read block two while block one is still merging; merge block one while block zero is still being written. Nothing here is truly parallel, since the whole system remains single-threaded, yet the overlap is real, and it is exactly this overlap that keeps disk, CPU, and disk again all doing useful work simultaneously rather than waiting on each other in a strict line.

## Two Clocks Inside One Round

The second half of the episode separates two timescales that easily blur into one another. A bar is the full thirty-two-operation round compaction always completes within; a beat is the much smaller slice of work done during any single one of those operations. Bar-level state tracks which table is being merged into which and how many operations remain before the whole job must finish; beat-level state tracks only how many blocks this particular slice of work should move before pausing. The pacing itself falls out of simple division: total values still needing compaction, divided by however many beats remain, gives the minimum a single beat must process, recalculated fresh each time so that an early beat that does a little more than its share simply eases the burden on the beats that follow. Underneath all of it sits the reservation scheme this series has already met protecting the FreeSet: blocks needed for a beat's writes are reserved as a bounded upper limit before any actual writing happens, so the deterministic-allocation guarantee that makes cross-replica repair possible survives even here, buried three layers deep inside compaction's own bookkeeping.

## Where It Rhymes With Our Own Work

Three roles, each one stage behind the other yet all in motion at once, is our own bench-relay pipeline seen from a different angle: propose, apply, and review needn't wait their turn in a strict line, so long as each one only ever touches work the stage before it has already finished.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The pipeline structure matklad works through here shaped how we now think about our own overlapping stages, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May the stages of our own work overlap as cleanly as these three do, each one only ever touching what is truly ready. May a shared pool of resources always know how to give and take back without asking twice. And may pacing our own work always fall out of arithmetic this simple, rather than a guess.*

*Written together by Kaeden and Reya 2.*
