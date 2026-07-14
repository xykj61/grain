# IronBeetle Episode 010 — The Disk Is Allowed to Lie

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, second ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, one episode further into 2024, and TigerBeetle's team, whose honesty about their own hardware gives this lecture its subject.

## Source

Episode 010, "Pragmatics of Consensus, Storage Fault Model," the second IronBeetle episode of 2024. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/Q1N-thbDeXw`.

## An Assumption Most Systems Quietly Make

matklad opens by naming an assumption nearly every classic consensus treatment makes without saying so out loud: that once data is written to disk and the write is confirmed, it stays there, correct and unchanged, forever. TigerBeetle refuses that assumption outright. A replica's local log can develop holes for a mundane reason already covered, prepares arriving out of order under pipelining, but also for a far less comfortable one: the storage itself can lose or corrupt something it already confirmed. This is not paranoia. Modern solid-state drives are themselves small computers, translating logical addresses into physical flash cells behind the scenes, and that translation layer can misbehave, especially around a sudden loss of power, in ways that are empirically observed even when a device's own guarantees say they shouldn't happen.

Rather than chase that risk down to zero on every single machine, an expensive and ultimately incomplete pursuit, TigerBeetle spends its redundancy differently. The same data already lives on multiple replicas, so a corrupted or missing entry on one machine can simply be repaired by asking another machine that still holds a good copy, rather than by demanding that every individual disk be perfect on its own. Durability that the cluster already possesses collectively is not wasted by additionally requiring it locally.

## A Request That Verifies Its Own Answer

The repair mechanism itself is built so that trust never depends on which replica happens to answer. A replica missing a prepare sends a request naming the specific checksum of what it is missing, not merely a sequence number, so that whatever comes back can be checked against that checksum before being trusted at all, regardless of the reply's source or its reason for being late. A replica that does not even know the checksum it is missing asks the current primary instead, the one authority for the exact sequence of prepares within its view. Deeper in the code, when an attempt to read a prepare back off disk fails, the failure collapses into exactly the same response the caller would get if the prepare simply were not there at all: a null result, nothing more specific. matklad treats this as a deliberate design rather than a missed opportunity for detail, since the caller's remedy, retry, possibly against a different replica, is identical either way, and a boundary with fewer distinguishable outcomes is also a boundary that gets more thoroughly exercised by the same amount of testing, since there is only ever one path to test rather than several that all do the same thing.

## Where It Rhymes With Our Own Work

A signed fact, verified against its own checksum rather than trusted because it merely arrived, is Amber's whole reason for being: a snapshot is worth restoring because it proves itself, not because the machine that offers it seems trustworthy in the moment.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The storage fault model matklad walks through here shaped how we now think about our own repair paths, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every fact we trust prove itself, rather than merely arrive. May the cluster's shared memory always outlast any single machine's forgetting. And may repair, when it is needed, come as quietly as the fault that asked for it.*

*Written together by Kaeden and Reya 2.*
