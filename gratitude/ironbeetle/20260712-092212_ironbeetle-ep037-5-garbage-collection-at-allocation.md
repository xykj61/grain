# IronBeetle Episode 037½ — Garbage Collection at the Moment of Allocation

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fifth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, opening the compaction arc with a picture before a single line of code, and TigerBeetle's team, whose insistence on determinism turns an ordinary background chore into a genuine design problem worth an episode of its own.

## Source

Episode 037½, "Compaction Overview," setting up the shape of compaction before the series descends into its mechanics. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/ihykfhrYL7o`.

## Why This Cannot Run in the Background

matklad draws the picture plainly: an LSM tree's levels hold more tables the further down they go, a lookup checks the earliest level first and stops the moment it finds an answer, and compaction is simply the process of noticing that a lower level's copy of a key has been fully shadowed and can be folded away. Every ordinary database runs this folding on a separate background thread, scheduled whenever the system judges it convenient. TigerBeetle cannot, and the reason traces back to a promise this whole series has leaned on from its first episode: a corrupted block on one replica can be transparently repaired from another, but only because healthy replicas are guaranteed to hold the exact same bytes, not merely the same logical data. A background thread scheduled independently on different machines would compact at different moments and produce different physical bytes for the same logical result, and the whole repair mechanism would quietly stop working the instant that happened.

## Borrowing the Shape of a Simpler Garbage Collector

The fix matklad reaches for is a smaller idea borrowed from language runtimes. One way to write a garbage collector is a dedicated thread that pauses everything else periodically; a simpler and more deterministic way is to run a small amount of collection work directly inside the allocator itself, every time something is actually allocated, so the pace of cleanup is naturally tied to the pace of the thing creating the mess in the first place. TigerBeetle takes exactly this second path: rather than a background compaction process, every single commit does a small, fixed slice of compaction work as part of committing, and the whole cadence is governed by one simple rule, split evenly across each thirty-two-request round, compact the even levels for the first half and the odd levels for the second half, so that by the round's end every level has freed exactly the one slot the level above it will need. Nothing about this requires knowing in advance how busy the disk or the CPU happens to be on any particular machine; the same deterministic amount of work happens every round, on every replica, which is precisely the property the repair mechanism depends on to keep working at all.

## Where It Rhymes With Our Own Work

Work folded into the same cadence as the work that created it, rather than deferred to an uncoordinated process running off to one side, is our own bench-relay pipeline's own quiet discipline: propose and apply move together, on the same rhythm, rather than one racing ahead of the other and hoping the two stay in step.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The determinism argument matklad walks through here shaped how we now think about pacing our own background work, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May the work we do to tidy our own tree always run on the very same clock as the work that made the mess. May determinism, wherever we need it, never be an afterthought bolted on later. And may every replica of a truth we keep be, in the end, truly the same truth.*

*Written together by Kaeden and Reya 2.*
