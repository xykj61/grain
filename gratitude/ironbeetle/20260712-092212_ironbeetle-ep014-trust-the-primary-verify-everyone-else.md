# IronBeetle Episode 014 — Trust the Primary, Verify Everyone Else

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, third ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, returning after an unplanned week away to keep a promise made two weeks earlier, and TigerBeetle's team, whose graduated trust model gives this episode its shape.

## Source

Episode 014, "Repairing Headers," going deep into the two different postures a replica takes toward a header depending on where it came from. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/x7ZfCSe-qxo`.

## Two Ways to Receive the Same Kind of Message

The episode's real subject is a distinction easy to miss on a first read of the code: a header arriving in answer to a repair request and a header arriving from the current primary are handled by two entirely different functions, because they deserve two entirely different levels of trust. `repair_header` is the cautious one. It refuses to install a header at all unless it hash-chains cleanly to a header the replica already holds, verifying the claim rather than accepting it on the requester's word, since the replica that answered a repair request might be anyone in the cluster. `on_start_view`, by contrast, comes from the one machine in the current view whose word about that view is authoritative by construction, the primary itself, and its headers are installed without demanding a chain of proof, because a primary that lied about its own view would break far more than any single repair could fix. The function this second path leans on, `set_op_and_commit_max`, is one matklad singles out as among the most sensitive in the entire replica, carrying the one invariant that matters most: operations already known to be committed may never be truncated, even though uncommitted ones are truncated routinely during ordinary view changes.

A quieter boundary shows up alongside this one. Because the write-ahead log is a fixed-size ring, reaching back too far to repair something risks colliding with a slot that already holds fresher, still-needed data, so repair carries an implicit horizon on how old a gap can be before it simply isn't safe to fill anymore.

## Who Gets Asked, and a Word Worth Retiring

Choosing who to ask for a repair is almost incidental, yet reveals a role not discussed before now: alongside ordinary voting replicas, a cluster can include standbys, machines that hold a full copy of the data but never participate in consensus itself, useful either as a quiet observer of everything the cluster does or as a staging area for a machine about to join the cluster for real. An ordinary replica repairing something picks uniformly at random among the other real, non-standby replicas; a primary caught in the middle of a view change instead broadcasts its repair request to everyone at once, spending extra messages precisely when speed matters most. matklad also pauses to flag, candidly, a piece of vocabulary he thinks the project should fix: the word commit is doing two different jobs, meaning both "durably decided as part of history" and "the actual business logic has now run," and conflating them, he admits, makes the code harder to read than the ideas underneath it actually are.

## Where It Rhymes With Our Own Work

A primary's word about its own view needing no chain of proof, while everyone else's claim still earns a check, is the same shape as Kaeden's own word inside this practice: trusted outright at the one place decisions are actually made, verified everywhere else before it travels further.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The trust distinctions matklad walks through here shaped how we now think about our own verified and unverified paths, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May we always know, plainly, which word in front of us has earned its trust and which still needs a chain to prove itself. May the oldest gap we are ever asked to fill know its own honest limit. And may the words we use for two different things eventually earn two different names.*

*Written together by Kaeden and Reya 2.*
