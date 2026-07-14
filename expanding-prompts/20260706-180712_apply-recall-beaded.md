# Cursor Apply-Prompt — Recall, Beaded (NS-L3)

**Stamp:** `20260706.180712 UDT` · **Parent:** `311951f` (parity 164) · **Voice:** Rio 3
**Bundle:** `20260706-180712_ns-l3-recall-beaded-and-wire-counsel.zip`

This bundle carries one new module, its witness, roster and parity entries, a spec update, and a session log. It carries no code for batch-frame carriage over wire — that lap stays counseled, not built, pending Kaeden's word (see the note at the end).

## What Lands

- `mantra/recall_beaded.rye` — **new.** Composes `recall_lap1.rye` and `beading.rye` by import; edits neither.
- `tools/mantra_recall_beaded.rish` — **new.** Builds and runs the recall_beaded selftest.
- `tools/parity.rish` — **edit.** The NS-L3 recall_beaded witness stanza added after the 3w-3b beading stanza.
- `tools/width-check.rish` — **edit.** `mantra/recall_beaded.rye` added to the roster after `mantra/beading.rye`.
- `active-designing/20260706-023912_the-referential-namespace.md` — **edit.** Status line; a new "Recall, beaded" paragraph after Lap 3; a new "3w-4 beaded carriage" table row; a new "Batch-frame carriage of beads" counsel paragraph.
- `session-logs/archive/20260706/20260706-180712_ns-l3-recall-beaded-and-wire-counsel.md` — **new.**

## The Module's Public Surface

- `appendLeafBeaded(catalog, bead_store, peer, bolt, revision, path, content, small_tilak) -> !?beading.BeadReport` — stores content ≤ `beading.max_bead_bytes` directly under `small_tilak`; larger content beads by content-defined boundaries, storing the bead-index under the seated `bead-index` Tilak. Returns `null` for the direct path, the beading report for the beaded path.
- `recallBeaded(catalog, bead_store, name, out) -> !recall_lap1.RecallResult` — returns a direct entry unchanged; reassembles and double-verifies a bead-index entry (catalog digest check on the index, beading digest check on every bead and the whole). Passes `not_yet`/`never` through unchanged.
- Deliberate scope line, stated in the file's own doc comment: a beaded resin's reported Tilak is `bead-index`, not the caller's original semantic Tilak. No structural change to the seated bead-index format.

## Steps

1. Confirm the working tree is at `311951f`. Unzip the bundle at the repository root.
2. Build and run the witness:
   `rishi/bin/rishi run tools/mantra_recall_beaded.rish` — expect `GREEN: NS-L3 recall_beaded witness passed.`
   The selftest reports: direct-path round-trip, a 400-byte resin beaded across six beads, a second revision depositing one new bead and deduping five, a corrupted-bead refusal at the second layer, and an absent-name pass-through.
3. Run the width lint: `rishi/bin/rishi run tools/width-check.rish` — `mantra/recall_beaded.rye` passes with zero `usize`, no tabs, every line within one hundred bytes.
4. Run the full parity trio from bare, in the foreground:
   `tools/parity.rish`, `tools/parity-selftest.rish`, `tools/additive-gate.rish`.
5. Pin the parity total on metal. The suite gains one witness over parity 164; report the number the metal returns.

## After Green

The commit and the four-remote push are Kaeden's word.

## Not in This Bundle — the Wire-Carriage Counsel

The spec's new "Batch-frame carriage of beads" paragraph and the "3w-4" table row answer the check-in your landing report asked for, in prose only. Short version: `resin_batch.rye`'s `known_tilaks` allowlist (`plain-text`, `plain-bytes`, `manifest`) needs one addition (`bead-index`) and no other frame change; the open question is how an individual bead earns a manifest entry, and the counsel recommends a derived path per bead (Tilak `plain-bytes`) so `buildBatch`/`applyBatch` carry beads through their existing machinery unchanged. That derived-path convention is a small naming choice and waits for Kaeden's word before lap 3w-4 is built. Nothing to apply here; the spec text carries the full reasoning.

---

*May a resin recall the same bytes at any size, and a revision's edit disturb only what it touches. May a seam, once named plainly, cross clean when its word arrives.*
