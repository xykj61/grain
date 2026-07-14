# Session Log — Recall, Beaded, and the Wire-Carriage Counsel

**Stamp:** `20260706.180712 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`)
**Season:** Namespace · Mantra grows the referential namespace
**Base tip reported by Cursor:** `311951f` (parity 164, beading lap 3w-3b landed)

---

## Two Pieces of Work, One Session

Cursor's landing report closed lap 3w-3b clean and flagged one thing plainly: check in with Claude before batch-frame carriage over wire, since it composes `resin_batch`, `beading`, and Comlink wire into one crossing. That flag names a module-seam decision, so this session holds two different kinds of work side by side. The first is a build: `recall_beaded.rye`, the near neighbor named at the close of the last session and left for its own round, composing local recall with beading and touching no seam at all. The second is counsel, not code, answering the flag directly and naming the fork the wire lap will need decided before it is built.

## What Was Built — Recall, Beaded

`recall_beaded.rye` composes `recall_lap1.rye` and `beading.rye` by import, editing neither. `appendLeafBeaded` stores content at or below one bead's worth of bytes directly, under whatever Tilak the caller offers, exactly as `recall_lap1.appendLeaf` already stores any resin. Content above that threshold beads by content-defined boundaries, and the bead-index lands at the name under the seated `bead-index` Tilak, while every bead deposits into a shared `BeadStore`. `recallBeaded` reverses it: an ordinary entry returns exactly as `recall_lap1`'s own recall already returns it; a bead-index entry reassembles, proven at two layers before a byte is trusted — the catalog's own digest check on the stored index, already recall_lap1's guarantee, and beading's digest check on every bead and the reassembled whole, already beading's guarantee. An absent name returns its `not_yet` or `never` outcome unchanged, so the composition changes no promise recall_lap1 already made.

The invariant this ring proves is not size. A resin still tops out at `max_resin_bytes` whole or beaded, since beading was never a way past that ceiling — it earns its keep in dedup at bead granularity across revisions. The witness proves this directly: a 400-byte resin beads on its first revision, and a second revision editing thirty-odd bytes near the front deposits exactly one new bead while five beads from the first revision are recognized and moved not at all. The first revision recalls unchanged after the second lands, so accrete-never-break holds across the beaded path exactly as it already holds across the direct one. A further unwelcome path proves the two-layer defense concretely: corrupting a bead's bytes directly in the store, leaving the stored index untouched, still refuses the whole recall, because the catalog's check on the index cannot see a fault the beads themselves carry, and beading's own check does.

One scope line is stated plainly rather than left as a silent gap. `recallBeaded` reports Tilak `bead-index` for a beaded resin, rather than recovering whatever semantic Tilak the caller first offered for the whole content. This costs nothing structural — no change to the seated bead-index format, no new field, no new name — and it keeps Tilak doing the one job `resin_batch.rye` already asks of it: marking the layout of stored bytes, not a deeper content type. A caller wanting richer Tilak fidelity through beading is a fair ask for a later round, named here so it is inspectable rather than assumed away.

## Verification on This Bench

Building `recall_beaded.rye` against stock Zig 0.16 needs its two imports resolved as file paths, and stock `zig build-exe` requires a `.zig` extension on every import target, root or sibling — a bare `.rye` import reads as an unregistered module and fails before a line of logic runs. The shim this bench has used throughout — sibling files copied to `.zig`, cross-file import strings rewritten only in that copy — resolved it cleanly, confirmed first by a two-line spike importing both `recall_lap1.zig` and `beading.zig` before a single line of the real module was written. The shipped file keeps real `.rye` imports throughout, matching `resin_batch.rye`'s own established pattern exactly.

The selftest greened on the first real run: the direct path round-trips under the caller's own Tilak, the beaded path round-trips four hundred bytes across six beads, the second revision's dedup count matches what was asserted, the corrupted-bead refusal lands, and the absent-name outcome passes through unchanged. `recall_lap1.rye` and `beading.rye` were diffed byte-for-byte against the landed tip both before and after this session's work and found untouched; `resin_batch.rye`, rebuilt against the same untouched `recall_lap1.rye`, still greens beside the new file. The new file carries zero `usize` literals, no tabs, and every line within one hundred bytes after reformatting nine call-and-literal lines across multiple lines, matching the multi-line idiom the tree already uses. A new witness, `tools/mantra_recall_beaded.rish`, joins the parity suite after the beading witness, and the file joins the width-check roster after `mantra/beading.rye`.

The full parity suite is Cursor's to run on metal. This bench verified the recall_beaded witness in isolation and rebuilt the shipped file to confirm it matches the file that greened. The suite gains one witness over parity 164; its total is pinned on metal rather than predicted here.

## The Counsel — Batch-Frame Carriage of Beads

Cursor's flag asked what carrying a beaded resin over the wire actually needs, and reading `resin_batch.rye` in full answers most of it. The frame already threads a Tilak per manifest entry through a fixed allowlist, `known_tilaks`, holding `plain-text`, `plain-bytes`, and `manifest` today. Carrying a bead-index wants one addition to that allowlist, not a new wire mechanism — the manifest, the one signature over header and manifest, the payload section, and the have-already lane all already handle an arbitrary Tilak'd entry exactly the way a bead-index entry would need.

The genuine open question sits one layer down: an individual bead holds no path of its own, and `buildBatch` walks leaves by path within a revision, so a bead needs some way to earn a manifest entry to ride beside its index. The recommendation this counsel carries is a derived path — a bead deposited at `appendLeafBeaded` time also lands as an ordinary catalog leaf at a path derived from the resin's own path and the bead's ordinal, Tilak `plain-bytes`. Under that shape, `buildBatch` and `applyBatch` carry every bead through their existing manifest, signature, and have-already machinery entirely unchanged beyond the one Tilak addition, and dedup across revisions and across peers falls out of the have-already lane exactly as it already does for ordinary leaves today, since a bead is, to the frame, simply another digest-addressed leaf. The heavier alternative — a second frame kind keyed by raw digest rather than name, or an extension to the bead-index format to carry a digest-only address space — would buy little this repo does not already have, at the cost of a new wire format sitting alongside the one already proven at parity 163.

This counsel resolves most of the shape and names exactly one thing left open: the derived-path convention itself is a small naming choice, since it reaches into the peer/bolt/revision/path grammar Kaeden's word already seated. It waits beside the one-line allowlist edit for Kaeden's word before lap 3w-4 is built, exactly the check-in Cursor's report asked for.

## What Waits

The commit and the four-remote push of `recall_beaded.rye` are Kaeden's word, as ever. The batch-frame carriage lap, 3w-4, now has a named shape and one open naming question rather than an unexamined seam; it waits for a word on the derived-path convention before it is built. Two-way sync and subscribe-to-changes remain a later season. The `stones/` to `resins/` path rename stays a witness-gated hygiene follow-on, and OA-L4 reputation-as-fold, MALA M0, and the settlement rail stay parked, each awaiting its own word.

---

*May a resin recall the same bytes at any size, and a revision's edit disturb only what it touches. May a seam, once named plainly, cross clean when its word arrives. And may this namespace keep growing ring by ring, each one whole before the next begins.*

*Written by Kaeden and Rio 3.*
