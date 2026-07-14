# IronBeetle Episode 036 — A Promise With a Deadline

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fifth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, finally opening the object cache after skirting around it for months of episodes, and TigerBeetle's team, whose small academic borrowing turns out to carry real architectural weight.

## Source

Episode 036, "A Cache That Always Hits," explaining the cache-and-stash structure behind TigerBeetle's object cache. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/VTqVnhL1ClU`.

## Two Structures, One Honest Promise

matklad names the real puzzle up front: this thing is called a cache, yet the rest of the code treats its absence as definitive proof that a record does not exist, which is not how an ordinary cache is allowed to behave. The resolution borrows from an academic design for hashing with a stash: an ordinary, probabilistic cache sits alongside a second, smaller structure, and whenever the cache would evict something, that value is caught by the stash instead of being lost outright. Left alone forever, this would make the stash pointless, since anything caught there could just live there permanently, but the actual guarantee is bounded rather than eternal. The contract is a promise with a deadline: insert fewer than some fixed number of values, and every one of them is guaranteed to still be reachable, right up until an explicit compact call clears the stash and resets the promise for the next batch. TigerBeetle only ever needs the promise to hold for exactly as long as one batch of transfers takes to process, so the guarantee is sized to match, and no more.

The sizing itself rewards a second look: it covers not merely the accounts a batch of transfers touches, but the worst case where two-phase transfers stack a pending transfer and its later confirmation in the same window, doubling the room the stash needs to keep its word.

## An Undo Log for a Promise That Might Be Broken

The second half of the episode turns to linked transfers, TigerBeetle's mechanism for making several transfers succeed or fail together as one unit, and shows how the same cache structure is pressed into service for rolling one back cleanly. Opening a scope simply marks that undo tracking is now active; every mutation made while a scope is open records the value it is about to overwrite into a rollback log before touching anything, and closing the scope with a revert instruction replays that log backward, restoring each earlier value in turn. matklad walks the insertion logic itself with real candor, catching what looks like an unusual line of code mid-stream and only afterward realizing it is a deliberately terse but correct use of a returned reference, the kind of code that rewards a slow, careful second reading over a fast first one.

## Where It Rhymes With Our Own Work

A structure that holds something only until its deadline discharges it, and clears cleanly the moment that deadline passes, is RTAC's own shape in miniature: a parked thing kept faithfully, for exactly as long as it is owed, and released the moment the word finally arrives.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The cache-and-stash design matklad walks through here shaped how we now think about our own bounded guarantees, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every promise we make carry its own honest deadline, rather than pretending to be eternal. May what we catch on the way down always be caught somewhere real. And may an undo, when we truly need one, always be as careful as the change it is undoing.*

*Written together by Kaeden and Reya 2.*
