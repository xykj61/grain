# Cursor Apply-Prompt — NS-L3 Lap 3w-3b Beading (Three Rings, One Bundle)

**Stamp:** `20260706.175412 UDT` · **Parent:** `0f145b4` (parity 163) · **Voice:** Rio 3
**Bundle:** `20260706-175412_ns-l3-3w-3b-beading.zip`

This one bundle carries the whole beading lap, grown over three bench rounds and never sent until now. It is a stacking superset pinned to the last committed tip `0f145b4`; apply it once to land the entire lap. Nothing earlier reached the tree, so this supersedes the two earlier beading bundles (`171812`, `173212`) entirely — apply this bundle alone.

## The Three Rounds, in One Place

- **Round 1 — fixed-size beading (`20260706.171812`).** A resin splits into fixed-size, content-addressed beads; a bead-index records the whole digest, the length, and the bead digests in order; reassembly proves each bead and the whole before returning. Earns dedup where beads align.
- **Round 2 — content-defined beading (`20260706.173212`).** A gear-hash chunker (FastCDC form; casync's idea, both named in the source) cuts beads at content-defined boundaries, so an edit shifts only nearby beads and the rest re-sync and dedup. Same bead-index format, same reassembly.
- **Round 3 — bounded-memory verify and name-invariance (`20260706.175412`).** A shared `parseIndexHeader` gate; `verifyBeadIndex` confirms a beaded resin is whole in the space of a single bead, holding no output buffer; and the selftest proves a resin's name is its content digest, identical across both rings and unbeaded.

## What Lands

- `mantra/beading.rye` — **new.** The whole module: `bead` (fixed-size), `beadContentDefined` (content-defined), `reassemble`, `verifyBeadIndex`, the content-addressed `BeadStore`, and one selftest exercising all three rings.
- `tools/mantra_beading.rish` — **new.** The beading witness; builds `mantra/beading.rye` and runs its selftest.
- `tools/parity.rish` — **edit.** The NS-L3 3w-3b beading stanza added after the 3w-3a resin-batch stanza.
- `tools/width-check.rish` — **edit.** `mantra/beading.rye` added to the roster after `mantra/resin_batch.rye`.
- `active-designing/20260706-023912_the-referential-namespace.md` — **edit.** Status line and 3w-3b row recording all three rings.
- `session-logs/archive/20260706/20260706-175412_ns-l3-3w-3b-beading.md` — **new.** One consolidated log for the whole lap.

No `.zig` shims, no `bin/` artifacts.

## The Module's Public Surface

- `BeadStore` — content-addressed, dedups on deposit, bounded to `max_store_beads` (64). Methods `empty`, `has`, `get`.
- `bead(store, content, bead_size, index_out) -> { len, report, whole_digest }` — fixed-size split.
- `beadContentDefined(store, content, index_out) -> { len, report, whole_digest }` — content-defined split.
- `reassemble(store, index_tilak, index_bytes, out) -> { len, whole_digest }` — Tilak-gated, per-bead and whole proofs.
- `verifyBeadIndex(store, index_tilak, index_bytes) -> { len, whole_digest }` — same proofs, one-bead memory, no output buffer.
- Bead-index bytes: `[whole_digest: 32][whole_len: u16 LE][bead_count: u16 LE][bead_digests: count × 32]`. Header 36 bytes; the index is itself a valid resin (at most `max_beads` = 8 beads, 292 bytes, within `max_resin_bytes` = 512).
- Tilak: `bead-index` (seated `20260706.163312`) marks the index; beads wear `plain-bytes`.
- Bounds: `max_bead_bytes` 256, content-defined beads between 64 and 256 bytes.

## Steps

1. Confirm the working tree is at `0f145b4`. Unzip the bundle at the repository root; the six files land at their paths.
2. Build and run the beading witness:
   `rishi/bin/rishi run tools/mantra_beading.rish` — expect `GREEN: NS-L3 3w-3b beading witness passed.`
3. Run the width lint: `rishi/bin/rishi run tools/width-check.rish` — `mantra/beading.rye` passes with zero `usize`, no tabs, every line within one hundred bytes.
4. Run the full parity trio from bare, in the foreground:
   `tools/parity.rish`, `tools/parity-selftest.rish`, `tools/additive-gate.rish`.
5. Pin the parity total on metal. The suite gains one witness over parity 163 (the beading witness, covering all three rings); report the number the metal returns rather than predicting it here.

## After Green

The commit and the four-remote push are Kaeden's word. On his word, GPG-sign with the sandbox signing key and push to `origin` (Codeberg), `github`, `gp36-codeberg`, and `gp36-github`.

## Bench Verification Already Done

This bench built `mantra/beading.rye` against the pinned Zig 0.16 toolchain and stock `std`. The selftest greened across all three rings and every welcome and unwelcome assertion, and printed the dividends: a fixed-size resin round-trips to the byte and dedups an aligned shared bead; a content-defined resin re-syncs five of six beads across a three-byte insertion and five across a three-byte deletion, where fixed-size re-syncs none; bounded-memory verify confirms the whole in one-bead space and agrees with reassembly; the name is identical across both rings and unbeaded; and every refusal lands whole. The resin-batch frame reran green beside it, so accrete-never-break holds in fact. The shipped file was rebuilt to confirm it matches the file that greened.

---

*May the bundle land whole, and the suite green on honest metal. May an edit disturb only what it touches, and a beaded resin prove itself whole in the smallest space. And may these three rings stand together, ready for the wire to grow from them.*
