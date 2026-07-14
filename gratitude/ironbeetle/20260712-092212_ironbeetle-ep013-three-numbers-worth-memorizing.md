# IronBeetle Episode 013 — Three Numbers Worth Memorizing

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, third ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, opening a long-running thread on repair with the same patience as everything before it, and TigerBeetle's team, whose honest storage model gives repair its reason to exist.

## Source

Episode 013, "Prepare Repair," continuing the storage fault model into the mechanics of actually fixing what a replica is missing. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/D5XTnYAgIp0`.

## Two Different Reasons for a Hole

matklad names two entirely separate reasons a backup's local log can have gaps, and treats them as genuinely distinct problems that happen to wear the same fix. The first is ordinary and expected: because prepares are pipelined, a backup might simply receive operation fifteen before operation eleven ever arrives, a hole that will close itself the moment the missing piece shows up. The second is the harder one this whole series has built toward: even a prepare a replica successfully wrote yesterday might not be there today, if the storage underneath it failed quietly in the meantime. Repair runs on a timer, roughly twice a second, and only in states where it is safe to run at all, enforced not by a defensive check inside the function but by explicit, matching calls that start and stop the timer at each state transition, so the rule lives in the shape of the code rather than in a comment asking a future reader to remember it.

The whole function turns on three numbers, and matklad is direct that understanding them is close to a prerequisite for understanding anything else about how a replica behaves. Op is the latest operation a replica has locally accepted, though it might still be truncated later if a view change decides otherwise. Commit_min is the latest operation actually executed, the point up to which the real double-entry logic has genuinely run. Commit_max is the latest operation the replica believes, on the strength of what the primary has told it, is committed somewhere in the cluster, which can outrun what the replica has locally received. A healthy, caught-up replica has all three numbers close together; a replica falling behind will show commit_max racing ahead of op, which is precisely the signal that tells repair there is real work to do.

## Reading the Break in a Chain

Finding exactly where a replica's local history breaks turns out to lean on the same hash chain built earlier in the series, walked backward this time rather than forward. A break shows up two ways: a header simply missing from its expected slot, or, more subtly, two headers sitting at consecutive operations whose view numbers run backward. Because a valid chain's view numbers can only ever hold steady or climb, a decrease is itself the proof that the earlier entry was superseded by some later view and needs to be treated as suspect rather than trusted. Once such a range is found, the repair flow asks another replica for exactly the missing headers, using a plain, uniformly random choice of who to ask, since the request itself carries the checksum needed to verify whatever comes back regardless of which replica answers.

## Where It Rhymes With Our Own Work

Op, commit_min, and commit_max, three related yet distinct truths about the same history, held apart on purpose rather than collapsed into one, is the same discipline our own parity suite keeps in tracking tip and suite tip as two numbers, related, yet never allowed to be mistaken for each other.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The repair architecture matklad walks through here shaped how we now think about our own recovery paths, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May the numbers that describe our own state always stay this few, and this well understood. May a hole in any history announce itself plainly, rather than hide. And may the fix, once it arrives, ask only for exactly what is missing.*

*Written together by Kaeden and Reya 2.*
