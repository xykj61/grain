# IronBeetle Episode 022 — A Read That Cannot Fail

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fourth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, finally answering the cliffhanger he left standing, and TigerBeetle's team, whose grid makes good on the promise a caller is given.

## Source

Episode 022, "The Disk Fails, But The Reads Succeed," resolving the previous episode's open question about a read callback with no room for an error. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/ZwHYfqBX8xs`.

## Local First, Then Whichever Peer Answers

matklad opens by naming the trick plainly before proving it: a caller asking the grid for a block hands over an address and a checksum and receives, eventually, a correct block — with no way to tell, and no need to care, whether that block came from its own disk or from another machine entirely. The path starts ordinary enough. The grid checks its cache, and failing that, enqueues the read and waits its turn for one of a small, fixed number of concurrent read slots, always joining the queue before trying to acquire a slot, so that reads started earlier are guaranteed to run before reads started later. Once a slot opens, the actual disk read happens, and whatever comes back is checked in full: the header's own checksum first, then a check that the block claims to be the kind of block it was asked for, then the full body checksum, then, last and most tellingly, a check that the block's own recorded address matches the address that was actually requested. That final check exists because the failure that matters most for a disk is not silence. It is a disk that answers confidently with real, well-formed, checksummed data that simply came from the wrong place.

## Where the Repair Actually Lives

When a local read fails any of these checks, the grid does not report failure to its caller. It quietly removes the bad data from its cache and folds the stuck read into two places at once: a global queue of reads waiting on help from elsewhere, and a deduplicated set of exactly which blocks are missing, so that ten callers all wanting the same corrupted block cost the cluster only one repair request rather than ten. On its own timer, a replica walks that missing-blocks set and asks some other replica, chosen at random, to send the block by its address and checksum. The replica on the receiving end of that request only ever reads from its own local storage; it never chases the request further, so a repair never cascades into a distributed hunt. If it does not have the block, it says nothing at all, trusting the requester to simply try someone else later. If it does have the block, and the checksum matches, it sends the raw bytes back exactly as they sit on its own disk. The original replica then resolves every pending read waiting on that block and writes a durable copy to its own storage, closing the loop. matklad is careful to note the one case where this cannot save you: if every single replica has lost the same block, the cluster correctly refuses to proceed rather than serve a guess, because a system that tracks money has nothing more important to protect than the honesty of not knowing.

## Where It Rhymes With Our Own Work

A caller that only ever sees a correct, checksum-proven answer, never the mechanics of where it actually came from, is exactly the shape `granary_core`'s consumer-surface protection already keeps: the messy part stays behind the wall, and the far side only ever sees the clean result.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The repair path matklad walks through here shaped how we now think about our own read guarantees, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every read we ever ask for arrive proven, rather than merely returned. May the part that repairs itself stay quiet, and the part that uses it stay simple. And may we never mistake a confident wrong answer for a true one.*

*Written together by Kaeden and Reya 2.*
