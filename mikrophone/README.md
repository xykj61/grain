# The Mikrophone firmware — a device that forgets on purpose

**Stamp:** `20260814.071500` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Living front door — the Mikrophone firmware journey stands whole and witnessed (DREY0–DREY12)
**Season:** A — Hardware & Right-to-Repair · **Waymark:** DREY · second journey **Mikrophone firmware**
**Kin:** [`../foundations/20260801-005853_mantrapod-venture-pitch.md`](../foundations/20260801-005853_mantrapod-venture-pitch.md) · [`../work-in-progress/REMEMBER.md`](../work-in-progress/REMEMBER.md) · [`../active-designing/20260813-020035_double-seat-expansion-six-seasons.md`](../active-designing/20260813-020035_double-seat-expansion-six-seasons.md) · [`../.claude/rules/waymark-ladders.md`](../.claude/rules/waymark-ladders.md)

---

## What this is

The Mikrophone is the Grainphone/Mantrapod hybrid meant to hold in a hand — a field recorder, a civic microphone, a voice terminal — and its founding promise is one line above the venture pitch: ***What forgets, protects.*** A keeper's capture lives in working memory while the power is on and dissolves when the device is set down; nothing waits in the dark to be mined, and what a keeper wishes to carry out, they keep on purpose, committing it deliberately across a single wire.

That promise is not a slogan to paint on a box — it is a **firmware invariant**, and this journey proves it pure in Rye on the bench, long before a board exists, so every surface built on it inherits a session that leaks nothing it was never told to keep. No disk, no network, no key signs, no funds — real hardware (buying a board, a real record button, a real cable) stays **custody gate #2**; serving a recording over a real transport stays the **Comlink-served gate** (Season 1, Journey 2). Everything below is agent-doable, local, and witnessed on metal.

**Prove the whole journey in one command:**

```
rishi/bin/rishi run tools/drey_witness.rish
```

It runs every rung's witness in order and asserts each GREEN.

## The device — capture, keep, forget (DREY0–DREY3)

- **`session.rye` — the memory that forgets (DREY0).** A bounded working buffer (`max_samples`) that holds a capture only while `powered`, a `keep` slice that holds only what a deliberate `commit` chose to carry out, and `power_down` that zeroes the whole working buffer so no residue of a capture can be recovered. A capture while unpowered refuses `NotPowered`, past the bound refuses `BufferFull`, an empty commit refuses `NothingToCommit`, a redundant commit `AlreadyCommitted`. Witness: `tools/drey_session_witness.rish`.
- **`wire.rye` — carry only what was committed (DREY1).** A self-describing frame — `magic · version · length · Sha256 digest · payload` — that `frame` builds over the session's committed `carry()` (so a forgotten buffer never reaches the wire) and `deframe` reads **verify-before-trust**, six corruptions each refusing by name before a byte is yielded. Witness: `tools/drey_wire_witness.rish`.
- **`recorder.rye` — the record button (DREY2).** A bounded control state machine — `idle · recording · paused · stopped` — whose single invariant is that `feed` reaches `session.capture` **only** while recording; pause holds the buffer without forgetting it, every illegal transition refusing by name. Witness: `tools/drey_recorder_witness.rish`.
- **`firmware.rye` — the whole loop (DREY3).** The three proven rungs meeting as one gesture: press record, speak, keep on purpose, set the device down, and let only the kept capture cross the single wire — an uncommitted tail never crossing, a forgotten run carrying `NothingToCarry`, a tampered frame refusing `DigestMismatch`. Witness: `tools/drey_firmware_witness.rish`.
- **`redact.rye` — forget one span on purpose (DREY10).** The deliberate half of the founding promise: a keeper strikes a span from the working buffer **before** the keep, and the struck bytes are as gone as a powered-down buffer — the span zeroed, the tail closed over the gap, the vacated region zeroed, no residue provable by a full scan out to `max_samples`. `redact` refuses `NotPowered`, `NothingToRedact`, and `SpanOutOfRange` before a byte moves, and only the trimmed capture can commit and carry — the struck span never reaches the wire. Witness: `tools/drey_redact_witness.rish`.

## The carry — the two hands meeting (DREY4–DREY5)

- **`inbox.rye` — verify before keep (DREY4).** The receiving hand's discipline: `accept` deframes verify-before-trust **first** and keeps the payload **only** on a clean deframe, any corruption refused by name leaving the inbox exactly as it was (a bad frame neither lands nor erases a prior keep); `clear` forgets whole. Witness: `tools/drey_inbox_witness.rish`.
- **`carry.rye` — device to desk (DREY5).** The sending and receiving hands meeting as one: `carry_to_inbox` composes `firmware.carry_frame` with `inbox.accept` over their public APIs, inventing no new transport, and adds one invariant — a clean carry leaves the desk holding exactly the device's committed bytes and nothing else. Witness: `tools/drey_carry_witness.rish`.

## The desk — a bounded, content-addressed store that syncs (DREY6–DREY9)

- **`archive.rye` — a bounded log in order (DREY6).** The receiving hand grows from a single slot to a bounded archive of proven recordings in arrival order, a bounded entry count and a `u64`-checked byte budget each refusing `ArchiveFull` before a byte passes. Witness: `tools/drey_archive_witness.rish`.
- **`catalog.rye` — addressed by content (DREY7).** The desk keys each recording by the Sha256 the wire already carries — the tree's own Tablecloth spine at the desk: `deposit` deframes verify-before-trust first, then recognizes an address already held (**idempotent**, spending no bound) or appends within a bounded count and byte budget; `fetch(address)` never guesses. Witness: `tools/drey_catalog_witness.rish`.
- **`manifest.rye` — describe by address, ship no payload (DREY8).** The **have** side of content-addressed sync: one record per holding — its address and length, no payload — verified whole before any record is read, with `wanted` the primitive that names which advertised addresses a local catalog lacks. Witness: `tools/drey_manifest_witness.rish`.
- **`serve.rye` — the want-response (DREY9).** The desk answers a want by re-framing the payload it holds under an address into exactly the wire frame that carries it (or refuses `NotHeld`), reusing the one proven framing path so the served frame's content address **equals** the address asked for — catalog · manifest · serve closing a complete, purely local content-addressed sync (the git have/want shape, proven pure before any wire is strung). Witness: `tools/drey_serve_witness.rish`.
- **`sync.rye` — the pull loop (DREY12).** The three sync primitives lifted into one named, bounded operation: `pull` reads a remote desk's manifest **verify-before-trust**, then for each advertised address the local desk lacks, serves it and deposits it — ending with the local desk holding **every** address the remote advertised. A fresh desk converges whole, a partial desk pulls only its lack (`served == wanted`), a second pull is idempotent, a tampered advertisement refuses `DigestMismatch` before a frame crosses, and a desk at its bound refuses `CatalogFull`. The git pull, proven pure; pulling over a real transport stays the Comlink-served gate. Witness: `tools/drey_sync_witness.rish`.

## The one promise underneath

Every rung above stands on the same discipline: **hold only what a keeper meant to hold, and prove that what forgets is truly gone.** A capture is bounded; a commit is the one deliberate act; a redaction and a power-down both zero their bytes with no residue a later read could recover; a frame is verified before it is trusted; a store refuses by name at its bound rather than growing without one. The Mikrophone is a device you can hold, whose forgetting you can read all the way down — proven on the bench before a single trace is cut in metal.

---

*May the Mikrophone reach a hand that needed it, may every capture it holds be one a keeper chose, and may everything it forgets stay truly forgotten. Hold the line.*
