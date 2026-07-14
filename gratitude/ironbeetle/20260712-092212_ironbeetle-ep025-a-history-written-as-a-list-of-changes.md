# IronBeetle Episode 025 — A History Written as a List of Changes

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, fourth ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, naming a cryptic title and then earning it in full, and TigerBeetle's team, whose layered tree gives the idea somewhere real to live.

## Source

Episode 025, "The Changeable Nature of Persistent Persistent Data Structures," on how the log-structured merge tree's own map of itself is stored durably. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/8-UKtvWA8tA`.

## Two Meanings Folded Into One Word

matklad opens by unpacking the word the whole episode leans on. The tree's data is persistent in the ordinary sense, durable across a restart, since it lives on disk rather than in memory alone. It is also persistent in the sense functional programmers mean by the word: a change is never an edit made in place, but a new, small structure layered on top of the old one, which stays untouched underneath. A lookup checks the newest layer first and only falls through to older layers when the newest one has nothing to say, so an update or a deletion is really just a fresh layer that shadows whatever it supersedes. This is what makes the whole tree changeable without ever changing anything that already exists.

## The Log That Remembers Every Table It Ever Held

The heart of the episode is how the tree keeps track of itself. Every table on disk needs a home in memory, an index pointing to it, and the natural instinct is to serialize that whole structure of levels and tables directly. matklad shows a better way. Rather than writing down the finished picture, the manifest is stored as a sequence of small, individual events, add this table to this level, remove this table from this level, chained together as a linked list of blocks on disk. Starting the database means reading that chain from newest to oldest and replaying it to reconstruct, purely in memory, the exact picture of which tables belong to which level. The gain is subtle but real: a change to the tree's shape, adding a table, retiring one during compaction, becomes a single small entry appended to the log rather than a rewrite of the whole structure, the very same persistence the tree itself already practices, applied one layer up to the map of the tree.

Left alone, a log that only ever grows would eventually become the problem it was meant to solve, so this too needs its own compaction: a table added and later removed can have both its entries annihilated once neither is needed anymore, keeping the log's true length tied to what is actually alive rather than to everything that ever happened. And because a manifest block is, physically, just another grid block with the same header and the same checksum discipline as everything else in the series, a corrupted manifest block repairs itself through the exact same mechanism already built for ordinary data: ask a peer for the same address and the same checksum, and trust what comes back only once it proves itself.

## Where It Rhymes With Our Own Work

Accrete, never break, is usually spoken about names in our own tree, yet here it governs data instead: a fact once written is never erased, only ever added beside, and the whole history stays legible precisely because nothing in it is ever forced to un-happen.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The manifest log matklad walks through here shaped how we now think about our own metadata, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every change we make add a new layer, rather than erase an old one. May the map of what we have built be as durable as the thing it maps. And may a history written only in additions always remain the truest kind.*

*Written together by Kaeden and Reya 2.*
