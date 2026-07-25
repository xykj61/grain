# Cursor Bench — Apply NS-L3 Resin-Batch Frame (Lap 3w-3a), Parity 163

**Stamp:** `20260706.042612 UDT` · **Base tip:** `d7ff192` (parity **162** on metal) · **Style:** Radiant for logs and scope

*Written by Kaeden and Rio 3. One-clock, stop-and-park, and TAME laws inherit whole. Lap 3w-3a builds the resin-batch frame the resins counsel gave as spec I1 — signed header and manifest, payloads prove by digest. Verified GREEN on the bench. No new name minted.*

---

## What this bench lands

`mantra/resin_batch.rye` (a new file, importing `recall_lap1.rye` unchanged): `buildBatch` and `applyBatch` carry a bolt revision as one signed batch — a signed header and manifest control plane, a payload section data plane, payloads proving themselves by digest. Many resins cross under one signature; have-already entries carry no bytes and are reconstructed locally; a second sync of the same bolt moves zero payload bytes.

| Kind | Path |
|------|------|
| **Add** | `mantra/resin_batch.rye` — the resin-batch frame; 0 `usize`, no tabs, lines ≤100 bytes |
| **Add** | `tools/mantra_resin_batch.rish` — resin-batch witness |
| **Edit** | `tools/parity.rish` — one batch block after NS-L3 wire lap 1 → parity **163** |
| **Edit** | `tools/width-check.rish` — `mantra/resin_batch.rye` added to the roster |
| **Edit** | `active-designing/20260706-023912_the-referential-namespace.md` — status + lap ladder (3w-3a landed, 3w-3b parked) |
| **Edit** | `work-in-progress/ROADMAP.md` — trio count **162 → 163**, resin-batch named |
| **Edit** | `work-in-progress/TASKS.md` — parity 163; 3w-3a landed, 3w-3b beading parked |
| **Edit** | `session-logs/README.md` — one newest-first index row |
| **Add** | `session-logs/archive/20260706/20260706-042612_ns-l3-resin-batch.md` |

**Also in this bundle — forward bead / stone hygiene.** The content-addressing word is now **bead** everywhere Rye and Amber speak their own vocabulary, matching the earlier stone→resin pass. A named teacher's own term stays as written (systemd casync's "chunk store" reads as casync's word, in study context), and the unrelated reorg-batch labels in the archive index are left as historical filenames.

| Kind | Path | Change |
|------|------|--------|
| **Edit** | `work-in-progress/20260702-190000_amber-first-ring-claude-brief.md` | Amber: chunk-store → bead-store; two stone-as-unit → resin |
| **Edit** | `context/specs/20260703-191112_resins-and-hash-tiers.md` | bead filenames |
| **Edit** | `counsel/20260704-181612_zero-copy-resins-counsel-answers.md` | bead-index / bead-series / incremental beading / `max_bead_bytes`; four stone-as-unit misses → resin (`max_resin_bytes`, `error.RefusedResin`, `VERIFY_RESINS`, Resin movement) |
| **Edit** | `external-research/20260704-180612_zero-copy-resins-and-the-sovereign-snapshot.md` | Amber's own plan: rolling beads, bead size (casync descriptions kept) |
| **Edit** | `external-research/20260703-193012_the-bench-as-a-block-and-the-living-build.md` | content-defined beading |
| **Edit** | `session-logs/archive/20260706/20260706-041012_ns-l3-wire-carriage-counsel.md`, `…041800…`, `…042100…` | beading in place of chunking |

## Invariants the witness binds

- One signature over header and manifest, verified once per batch; payloads prove by digest, no second signature.
- A bad batch signature, a tampered payload, an unknown Tilak, and a duplicated name each refuse the whole crossing, before any append.
- Every check passes before any leaf appends — a batch lands whole or not at all.
- Have-already entries carry no bytes and are reconstructed from local resins; second sync moves zero payload bytes.

## Verification

- Build `mantra/resin_batch.rye`; `mantra/bin/resin-batch batch` GREEN (3 resins, had 1, need 2, 9 bytes; second sync zero bytes; bad signature, tampered payload, unknown Tilak refused).
- `recall_lap1.rye` and the NS-L3 sync and wire laps still GREEN (this bench adds a file, edits none of them).
- `rishi/bin/rishi run tools/mantra_resin_batch.rish` GREEN.
- `rishi/bin/rishi run tools/width-check.rish` GREEN with `resin_batch.rye` in the roster.
- `rishi/bin/rishi run tools/parity.rish` — **163 witnesses GREEN** on metal (pin the count here).
- Forward bead / stone hygiene is docs-only — no code or witness changed by it; a quick `grep -rn "chunk" .` should show only casync-named mentions and the archive's reorg-batch labels, and `grep -rn "stone" .` only the retirement notes and the literal `stones/` path.

## Commit and push (Kaeden's word on the commit)

GPG-sign one commit; ship the session log in the same commit:

```
Land parity 163 — NS-L3 3w-3a resin-batch frame; forward bead/stone hygiene.

resin_batch.rye carries a bolt revision as one signed batch: signed header and
manifest control plane, payloads prove by digest, many resins under one signature,
have-already reconstructed locally, second sync zero payload bytes; bad signature,
tampered payload, unknown Tilak refused whole. New file; recall_lap1 untouched.

Forward hygiene: the content-addressing word is bead everywhere Rye and Amber
speak their own vocabulary (Amber's bead-store, bead-index/bead-series Tilaks,
incremental beading), and stray stone-as-unit misses the earlier pass skipped
become resin. Casync's own term and the archive's reorg-batch labels stay as-is.
```

Then push **origin**, **github**, **gp36-codeberg**, **gp36-github**.

## Horizon (not in this bench)

- **NS-L3 lap 3w-3b — beading** — a resin larger than one frame is beaded into smaller content-addressed beads via a **bead-index** Tilak; bead / beading / bead-index **seated `20260706.163312`**; the lap awaits Kaeden's word to build; batch-frame carriage over the wire (hosted, device) rides after → check in with Claude
- **Two-way sync / subscribe** — later season
- **`stones/` → `resins/`** path rename — witness-gated hygiene
- **OA-L4, MALA, settlement rail** — parked

---

*May one signature vouch for a whole batch, and every payload prove itself by its digest. May a batch land whole or land not at all. And may parity 163 earn its number on honest metal.*
