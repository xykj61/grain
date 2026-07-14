# Snapshot export lap 3 — hosted Comlink crossing

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3

**Stamp:** 20260707.043012

## Thinking trace

Kaeden confirmed both counsel candidates before saying "go ahead": snapshot lap 3 is counsel-numbered (hosted Comlink crossing), and Caravan hardening is a menu with no single spec yet. The handoff from the prior turn left lap 3 implemented but uncommitted; this pass closed the ring.

Parity **185** ran full suite (~136s) — all GREEN including the new `mantra_snapshot_wire.rish` witness. Docs caught up: `mantra/README.md` family table and parity arc line, lap 2 spec horizon note, TASKS Caravan hardening menu from counsel, ROADMAP/TASKS stamps at **185**.

Continuity placeholder honored: lap 3 calls `importCatalogHorizon` unchanged — epoch ≠ 0 and identity match only; no liveness or double-boot reach.

## Observations

Lap 3 reuses `recall_batch_delivery.rye`'s per-revision batch exchange via `snapshot_export_delivery.rye` (ports **38490**/**38491**). Assembly and import paths match lap 2 in-process export — wire is transport only. Demo: three revision batches, import + replay GREEN.

Caravan hardening remains counsel-only; four unchecked items filed in TASKS for Kaeden's pick.

## Files

- `mantra/snapshot_export_delivery.rye` — new hosted delivery (source-loop + fetcher)
- `mantra/snapshot_export.rye` — revision collection, assembly helpers, witness catalog init
- `tools/mantra_snapshot_wire.rish` — lap 3 witness
- `tools/parity.rish` — slot for lap 3 witness
- `context/specs/20260707-042512_snapshot-export-lap3.md` — lap 3 spec
- `counsel/20260707-042512_claude-proposal-snapshot-lap3-and-caravan-hardening.md` — counsel filing
- `context/specs/20260707-024712_snapshot-export-lap2.md` — horizon note lap 3 landed
- `mantra/README.md` — family table + parity arc
- `work-in-progress/TASKS.md` — lap 3 done; Caravan menu
- `work-in-progress/ROADMAP.md` — parity **185**

**Recommend:** keep going to Kaeden's pick from the Caravan hardening menu when word lands — each candidate is mechanical and module-local; check in with Claude before device wire for snapshot export or any ring that changes supervision policy.
