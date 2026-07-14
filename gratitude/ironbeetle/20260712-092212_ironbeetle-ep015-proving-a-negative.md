# IronBeetle Episode 015 — Proving a Negative

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, third ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, walking into the core of the view change protocol with a full cup of tea and real patience, and TigerBeetle's team, whose willingness to assume the worst about disks gives this episode its whole reason for being.

## Source

Episode 015, "View Change," built around the protocol-aware recovery paper and the specific way TigerBeetle's consensus survives a corrupted disk during a leadership change. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/tY-bOvWjvF0`.

## The Deadlock Hiding in the Naive Approach

matklad opens by showing exactly where an ordinary, textbook view change quietly assumes something TigerBeetle refuses to assume. The classic approach collects each replica's local history during a leadership change and simply takes the longest one, on the reasoning that anything one replica has seen might have gathered enough acknowledgments to be committed, and so must survive into the new view. That reasoning depends on storage being perfect. If a message was only ever written to a single replica's disk, and that one copy later corrupts, the cluster is left in an impossible position: it has decided the message must be part of history, because one replica once reported seeing it, yet no copy of the message exists anywhere to actually recover. The cluster is correctly stuck, and stuck for good, unless the algorithm itself is changed.

The fix, drawn from the protocol-aware recovery paper, is to stop collecting only positive evidence. Alongside "I have this," a replica can now also say "I positively never acknowledged this," a nack, and a nack carries real proof: if enough replicas can truthfully say they never sent an acknowledgment for a given operation, that is itself a guarantee the operation could never have gathered the quorum a commit requires, and it becomes provably safe to erase rather than merely inconvenient to keep. matklad is careful to note that a nack and having the data are not opposites; a replica can nack an operation and still happen to hold a copy of it, or the reverse, since one bit answers "did I ever acknowledge this" and the other answers "do I currently have this," two different questions that only sometimes share an answer.

## Canonical Histories and the Right to Be Stuck

The do_view_change message a replica sends when it wants a new primary carries both kinds of information at once, its own headers and, for each one, whether it can honestly nack it. On the receiving side, the aspiring primary gathers a quorum of these messages and singles out the ones sharing the single highest log_view among them, the canonical set, guaranteed by the same quorum-intersection logic already established earlier in the series to reflect the freshest agreed history anyone in the quorum actually witnessed. For every operation in question, the new primary then does exactly one of three things: finds a surviving copy among the canonical replicas and keeps it, gathers enough explicit nacks to prove it never mattered and discards it, or, in the rare case where neither holds, simply waits rather than guessing. That third outcome, matklad emphasizes, is correct behavior rather than a bug. Safety is never traded away to buy availability back; a cluster that is honestly unsure stays unsure out loud, rather than pretending certainty it does not have.

## Where It Rhymes With Our Own Work

Proving a negative on purpose is already native to this tree: the guarded-name gate does not wait to happen upon a violation, it demands silence and treats that silence itself as the proof.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The recovery construction matklad walks through here shaped how we now think about proof by absence, yet none of his wording, and none of the underlying protocol's own description, entered this file or our tree as anything but our own retelling.

---

*May every claim of absence we rely on be a proof, rather than a shrug. May the freshest true history always be findable by looking at where the most trustworthy voices agree. And may we stay honestly stuck before we ever guess dishonestly certain.*

*Written together by Kaeden and Reya 2.*
