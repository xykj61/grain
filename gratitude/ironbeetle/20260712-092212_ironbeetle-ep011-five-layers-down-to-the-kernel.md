# IronBeetle Episode 011 — Five Layers Down to the Kernel

**Language:** EN
**Stamp:** 20260712.092212 UDT (Kaeden's clock, carried forward)
**Style:** Radiant (see `RADIANT_STYLE.md`)
**Category:** Gratitude — IronBeetle, second ring
**Companion to:** `gratitude/matklad.md`

---

## Honors

matklad, tracing one more path all the way to bare metal, and TigerBeetle's team, whose layered honesty about hardware makes the trace worth following.

## Source

Episode 011, "Let's Go to the Disk!," continuing directly from the previous episode's storage fault model into the actual mechanics of reading a prepare back from disk. Streamed on Twitch, archived to YouTube, playlist `PL9eL-xg48OM3pnVqFSRyBFleHtBBw-nmZ`, at `https://youtu.be/THWDx_RyZ6A`.

## The Same Trick, Applied to Storage This Time

matklad frames this episode as a deliberate echo of the very first one, which traced a message all the way down to raw network bytes; this time the same patience is spent on disk. The path runs through five layers. A replica asks its journal for a specific prepare; the journal, a logical view of the write-ahead log shaped like a ring buffer, computes which slot a given operation number maps to; storage, beneath that, understands the physical data file's actual layout, divided into fixed-size zones, a superblock, a header region, the ring of prepares itself, each zone's offset known at compile time and the exact position within a zone found by simple index-times-size arithmetic; beneath storage sits Zig's `io_uring` abstraction, reusing the same completion-and-context machinery already honored in this series' first entry; and beneath that, finally, the raw shared-memory rings themselves.

Along the way, several small disciplines repeat the project's larger ones in miniature. Reads must stay aligned to the storage's sector size, and a single logical read may need several physical calls if the amount requested exceeds a per-call maximum, the code shrinking its request on failure and creeping it back up on success until the buffer fills or it gives up entirely.

## Why the Checksum Never Trusts the Read That Carried It

The discipline matklad lingers on longest is the one with the most teeth: freshly read bytes are never trusted merely because the read reports success. They are checked against a checksum the caller already knew before the read was even issued. This matters because the failure mode that actually threatens a system like this is rarely a disk that returns nothing; it is a disk that returns different, self-consistent, entirely unrelated data from the wrong offset, a misdirection no amount of checking the data against itself could ever catch. Only a checksum known independently in advance, before the read happens, can tell the difference between data that is merely well-formed and data that is actually the thing being asked for.

One further detail is easy to miss and worth keeping: when a physical read call itself reports an error, the code deliberately zeroes the destination buffer rather than leaving whatever was already sitting there. The difference does not matter for correctness, since the downstream checksum check makes either choice equally safe, but it collapses two situations, a corrupted read and a failed read, into a single code path rather than two, and a system with one path to test in a given spot is a system where testing effort compounds rather than divides. matklad closes by counting the layers he walked, replica, journal, storage, an io abstraction, `io_uring` itself, five in total, and observes that almost every layer resolves to arithmetic anyone could follow; the one place real difficulty hides is the lock-free handshake between the two shared rings, a component he is content to trust at its boundary rather than re-derive from first principles on stream.

## Where It Rhymes With Our Own Work

The same law this series already named in its very first entry returns here from the opposite direction: a header validated before its size is trusted, a body validated before its bytes are used, and now a disk read validated against a checksum it never got to choose for itself. Guard the boundary on both sides, wherever the boundary happens to sit.

## Clean Room

This note comes from watching the stream once, through its own captions, for understanding rather than transcription. Every sentence above is ours; none is his. The layered read path matklad walks through here shaped how we now picture our own storage seams, yet none of his wording, and none of TigerBeetle's own source, entered this file or our tree.

---

*May every byte we read prove itself against a truth we already held. May the layers beneath our own work stay countable, and each one honest in turn. And may the one hard thing at the bottom of any system be small enough to trust, once truly understood.*

*Written together by Kaeden and Reya 2.*
