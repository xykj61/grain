# IronBeetle Episode 019 — Everything Is a Sorted Array

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, third ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, opening an entirely new chapter with the same patient curiosity as the first, and TigerBeetle's team, whose storage layer turns out to hold no fewer surprises than its consensus did.

## Source

Episode 019, "A Sorted Array on Disk," the opening installment of the storage-engine arc, moving from consensus into how TigerBeetle actually keeps its data. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/_h_T2Mn7hGY`.

## The Deflating, Freeing Realization

matklad opens by confessing his own surprise on joining the project: he had expected a database's storage engine to be a thicket of specialized machinery, and found instead that almost everything reduces to one idea, a sorted array you can binary search. The genuine complexity, he argues, is not in that idea itself but entirely in how it gets spread across a disk that only wants to talk in fixed-size chunks. TigerBeetle divides its storage into blocks of a fixed size, and every structure the database keeps on disk, no matter how large, is built by composing some number of these identical blocks, the same way the earlier networking episodes composed everything from one fixed message shape. The kinship runs deeper than analogy: every block, whatever it holds, opens with the exact same header format already used for messages sent across the network, so that a block is, structurally, simply another kind of message that happens to live on disk instead of on the wire.

## A Table, and the Key That Was Never Separate

The basic unit built from these blocks is called a table: exactly one index block, plus however many value blocks the data actually needs. A value block holds nothing more than a dense, sorted array of real records. The index block holds, for each value block it covers, that block's address, its checksum, and the smallest and largest key found inside it, which together let a lookup binary search the index block first to find the one value block that could possibly hold a key, and only then binary search inside that single block, never touching any of the others. A detail easy to walk past turns out to be one of the tree's most load-bearing habits: a key is never stored as a separate thing beside its value. A value is the whole record, a full transfer or account, and a key is simply a small function that extracts the one field worth sorting by, so records are compared and searched by that extracted key while still traveling, always, as one indivisible value. It is the same instinct already met in the network's own header-and-body messages, applied a second time to storage.

One last habit rounds out the episode: every block carries its own schema, the size of its values, the size of its keys, which logical tree it belongs to, directly inside itself, even though a running program could often infer all of this from context at compile time. matklad treats this redundancy as a deliberate gift to the future rather than a wasted byte, since a block written this way stays legible to any tool, present or not yet written, that might one day need to read it without sharing that exact compile-time knowledge.

## Where It Rhymes With Our Own Work

A table too large for one block, split across an index and its value blocks, each one self-describing and checksummed on its own terms, is beading arrived at from the other direction — a resin too large for one frame, beaded and named in order, wearing a different name for the very same shape.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The block and table structures matklad walks through here shaped how we now think about our own on-disk shapes, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May the simplest true idea underneath any complicated thing always be this findable. May every block we ever write carry enough of itself to be understood alone. And may a key and the value it belongs to never be asked to travel apart.*

*Written together by Kaeden and Reya 2.*
