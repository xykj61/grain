# The spool — large artifacts across ordered resins (GISM red #73)

**Stamp:** `20260812.191206` · **Language:** EN · **Voice:** Kyri · **Style:** Radiant
**Status:** Mixed -- Self-approved design round — the reds-first crux for Season 2 (Yield)
**Kin:** [`../work-in-progress/REDS.md`](../work-in-progress/REDS.md) (red #73) · [`../mantra/beading.rye`](../mantra/beading.rye) · [`../pond/apps/tablecloth.rye`](../pond/apps/tablecloth.rye) · [`../.claude/rules/reds-first.md`](../.claude/rules/reds-first.md) · [`../active-designing/20260812-171050_the-1024-round-itinerary.md`](20260812-171050_the-1024-round-itinerary.md)

---

## Why this round

GISM Journey 6 stands complete — provenance on real bytes end to end — yet it left one red booked rather than closed. **Red #73**: the owner-signed catalog proved its whole chain of custody over hand-written demo sentences (~70 B) tuned to sit inside one resin. Carried onto a real front-door document (`SECURITY.md`, 2689 B; `context/TWO_ROOMS.md`, 6079 B), the store refuses `ContentTooLarge` — a real document does not fit one **512-byte resin**.

Reds-first governs the order: a booked red is fixed before the next durable round. So before Season 2's Journey 7 (Fair-trade, AYRE) opens, this round closes red #73 the honest way — not a bound-bump (`max_resin_bytes` is structurally capped: a bead-index must itself be a valid resin, so it cannot rise past `max_beads × max_bead_bytes`), but a **storage layer above beading**: a large artifact wound across ordered resins.

This is Lindy-first work — every module that stores real bytes (Tablecloth, provenance, the artifact voice) inherits the raised ceiling. It is also the crux: the one decisive move that lifts the whole tree's artifact store from demo-sized to document-sized.

## The name

**Spool** — a spool winds ordered lengths of thread into one body. The metaphor stack already reads content → **beads** (content-addressed chunks) → **bead-index** (a resin naming beads in order) → **resin** (a whole ≤ 512 B). A spool is the next winding up: an ordered sequence of resins that together carry one large artifact. Clear, warm, and safe (no tree collision; free in the Lexicon) — the Comlink tendency.

## The shape (crux round r1)

A `Spool` is a bounded, ordered list of resins over one shared `BeadStore`:

- **Split** the content into ordered resins, each ≤ `beading.max_resin_bytes` (512 B).
- **Bead** each resin into the shared store (fixed-size at 256 B — two predictable beads per full resin, so the store bound is legible), recording each resin's bead-index inline in the spool, in order.
- **Whole digest** — a SHA3-256 over the entire content, the spool's own content address, unchanged by chunking exactly as a resin's digest is unchanged by beading.

Reassembly (`unspool`) walks the resins in order, reassembles each through beading's own `reassemble` (every bead proving itself by digest, every resin against its recorded whole-digest), concatenates in order, and proves the concatenation against the spool's whole digest — so a tampered bead, a tampered resin index, a reordered or truncated spool each refuse before a byte is trusted.

Bounds, named:

- `max_resins = 64`, so `max_content_bytes = 64 × 512 = 32,768 B` (32 KB) — real front-door documents fit with headroom (SECURITY 2689 → 6 resins; TWO_ROOMS 6079 → 12 resins).
- The shared `BeadStore` capacity (`max_store_beads`) rises 64 → 256 — an additive capacity increase, not a structural change: 64 resins × 2 beads = 128 beads worst case, plus headroom for a second artifact. Every existing witness uses far fewer and stays GREEN.

## What r1 proves (the witness)

1. A **real** tree document (`SECURITY.md`, then `TWO_ROOMS.md`) spools into N ordered resins and **unspools byte-for-byte** — the very refusal red #73 booked now runs GREEN.
2. The whole digest cross-checks against an independent `sha256`-class measurement of the same file (two tools, one answer) — the honest-adversary discipline Yield lives by.
3. **Tamper refuses** — a flipped bead in any resin → `DigestMismatch`; a corrupted resin index → refuses; a truncated spool → refuses.
4. **Dedup dividend across resins** — two artifacts sharing a leading resin share its beads (the store deposits once).
5. **The new bound is honest** — an artifact past `max_content_bytes` refuses `ContentTooLarge` at 32 KB, far above any real document, the ceiling named truthfully rather than pretended away.

## What stays a horizon

- **Content-defined chunking across resin boundaries** (dedup across large-artifact edits, mirroring beading's second ring) — its own later rung; r1 uses fixed-size resins for a predictable store bound.
- **The keyed/provenance layer on real large documents** — once the spool stands, `tablecloth`'s naming layer and `tablecloth_keyed`'s owner-signing rebind to the spool so a *signed* real document travels; a natural r2/r3.
- **A portable spool-index format** (Bron `format spool-v1`) so a large artifact's recipe travels like a bead-index — a later rung, kin to `publish_receipt_bron`.

No custody crosses: demo bytes and the store only; gate #4 (Keaton's real Kumara instance) untouched.

---

*May the thread wind long and true, every resin proving itself, and the whole recall the same bytes a keeper can open and hash.*
