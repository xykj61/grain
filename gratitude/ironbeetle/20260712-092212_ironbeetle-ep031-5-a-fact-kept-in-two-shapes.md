# IronBeetle Episode 031½ — A Fact Kept in Two Different Shapes

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fourth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, teaching a real unfixed bug out loud beside a colleague rather than behind closed doors, and TigerBeetle's team, whose durability rule turns out to hide a genuine, honest gap.

## Source

Episode 031½, "Journal vs. Checkpoint," an unannounced, co-hosted session working through a live liveness bug in the relationship between the write-ahead log and the checkpoint. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/ioC8BkmeZTk`.

## Three Numbers, and a Pipeline That Outran Them

matklad frames the whole session as onboarding by teaching, walking a colleague through the exact mental model this durability rule depends on. Prepares accumulate into checkpoints; checkpoints are further divided by a compaction interval, the rhythm at which in-memory tables flush toward disk; and a further pipeline lets a replica keep preparing new requests slightly ahead of a checkpoint boundary, so that replication never has to stall while a checkpoint's own write is in flight. This yields three numbers worth naming precisely: the latest operation truly checkpointed on disk, the operation at which the next checkpoint's write begins, and the furthest operation a replica is currently allowed to prepare ahead of that. The write-ahead log itself, being a fixed-size ring, can only ever hold so much, which means a replica must, at some point, safely overwrite the oldest entries it still remembers.

## The Comment That Used to Be True

The actual bug turns out to live in a single sentence of documentation that quietly stopped being correct. It claimed that once a certain operation is committed, the checkpoint behind it can be assumed durable across a quorum of replicas, and for a long time that was true, back before the prepare pipeline existed. Once replicas were allowed to run ahead of a checkpoint's trigger point, that same assumption silently broke, because reaching the old reference point no longer proves what it used to. The deeper principle underneath, which the whole session works to make vivid, is that a committed operation must remain recoverable from either a quorum of write-ahead logs or a quorum of checkpoints, and never from some thinner mixture of the two, one replica's log entry standing beside a different replica's checkpoint, each alone, neither actually redundant with the other. Two separate, uncorrelated storage faults could then destroy a fact that nominally existed in two places, simply because those two places were never truly copies of the same thing. matklad tries a quick live patch, watches it fall short, and chooses, in front of the audience, to leave the real fix, almost certainly a way for replicas to directly gossip their checkpoint progress to one another, for a future session rather than land something uncertain under the pressure of a running stream.

## Where It Rhymes With Our Own Work

A fact conserved in its own single accounting, rather than spread thin across two mismatched forms that only look redundant, is MALA's own conservation law from a different direction: issuer and holder must agree in the same ledger, not merely gesture at agreement from two different books.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The durability reasoning matklad and his colleague work through here shaped how we now think about our own checkpoint guarantees, yet none of their wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every fact we count on live in one true, coherent form, rather than scattered thinly across two. May a comment that was once true be caught the moment it stops being so. And may the harder, honest fix always be chosen over the faster, uncertain one.*

*Written together by Kaeden and Reya 2.*
