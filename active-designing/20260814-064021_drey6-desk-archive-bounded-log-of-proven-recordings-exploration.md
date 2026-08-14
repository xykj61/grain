# DREY6 — the desk archive: a bounded log that keeps a sequence of proven recordings in order

**Stamp:** `20260814.064021` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Self-approved design round (Season A · waymark **DREY** · Mikrophone firmware journey · rung DREY6)
**Kin:** [`20260814-022831_drey4-inbox-far-side-accepts-verify-before-keep-exploration.md`](20260814-022831_drey4-inbox-far-side-accepts-verify-before-keep-exploration.md) · [`20260814-063000_drey5-carry-meets-device-loop-to-desk-inbox-exploration.md`](20260814-063000_drey5-carry-meets-device-loop-to-desk-inbox-exploration.md)

---

## Why this rung opens

The carry now meets end to end (DREY5): a committed run leaves the device and lands in the desk inbox byte-for-byte, and only such a run does. Yet the desk inbox keeps only the **last** accepted frame — `accept` overwrites its single slot each time. A field recorder is not one recording; a day of civic use is many, and a desk that forgets all but the newest is not yet the desk a keeper needs. The honest next durable shape is the one every real receiving hand grows into: a **bounded archive** that keeps a *sequence* of proven-whole recordings, in the order they arrived.

By Lindy-first, crux-first, this is the most durable next move within the module family — it grows the receiving hand from a single slot to a bounded log without inventing a new transport, and every recording still lands only once proven whole, exactly as DREY4 proved for one.

## The crux

**A sequence of carried frames lands in the desk archive in order, each kept only once proven whole, within a fixed bound that refuses by name rather than overrun.** The hardest still-tractable move is the bounded append held to verify-before-keep across many: a corrupt frame anywhere in the sequence is refused by name and leaves the whole archive exactly as it was (no partial write, no disturbed prior entry), and the archive's two bounds — a maximum entry count and a maximum total byte budget — each refuse `ArchiveFull` before a single byte is written past them.

## The shape

A new module `mikrophone/archive.rye`, standing on DREY1's `wire.deframe` (verify-before-trust) and inventing no transport:

- `Archive` — a fixed byte store (`max_bytes`, a named constant), a used length, and a bounded index of entries (`max_entries`), each an `(offset, len)` into the store. No heap outlives it.
- `deposit(archive, frame_bytes)` — deframe the frame **first**; on a clean deframe, refuse `ArchiveFull` if the entry index is full or the payload would exceed the byte budget, then append the proven payload to the store and record its entry. Any wire error (`BadMagic` · `BadVersion` · `LengthOverflow` · `FrameTruncated` · `DigestMismatch` · `FrameTooShort`) propagates by name and the archive is left exactly as it was — nothing lands, nothing prior is disturbed.
- `count_of(archive)` — how many recordings the archive holds.
- `entry_at(archive, i)` — the i-th kept recording as bytes, in arrival order; `i` bounded by the count.
- `clear(archive)` — forget the whole archive, zeroing the store so nothing once kept can be recovered.

## The invariants the witness proves

1. **The archive keeps a sequence in order.** Three framed recordings deposit; `count_of` reads three, and `entry_at(0..2)` returns each byte-for-byte in arrival order.
2. **Only proven-whole recordings land.** A frame with a flipped payload byte refuses `DigestMismatch` and the archive is unchanged — count and used stand, every prior entry intact (no residue of the rejected frame).
3. **The entry count is bounded.** A deposit past `max_entries` refuses `ArchiveFull` before it writes — never an entry past the index.
4. **The byte budget is bounded.** A deposit that would exceed `max_bytes` refuses `ArchiveFull` before it writes — never a byte past the store.
5. **Clear forgets whole.** After `clear`, the count is nothing and the store is entirely zero — no residue of any kept recording.

## Custody

The archive is a fixed buffer on the bench; a frame is still a byte slice handed function to function. Nothing is stored to disk, nothing reaches a network, no key signs, no funds move. A durable, content-addressed store on real flash (beading a recording into Tablecloth) is a later rung that composes this shape with the tree's existing artifact store; the real Mikrophone hardware, a real desk, a real disk stay **custody gate #2**.

*A desk that keeps many recordings owes each one the same proof it owed the first: kept only once whole, bounded so it can never overrun, and forgotten whole when the keeper is done.*
