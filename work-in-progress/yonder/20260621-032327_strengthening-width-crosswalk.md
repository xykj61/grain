# 993 · Strengthening ↔ Width Crosswalk

**Stamp:** `20260623.033012`
**Parent:** `../20260620-212126_usize-width-baseline.md`
**Lexicon:** `../../strengthening-compiler/0000_STRENGTHENING_LEXICON.md`

---

## Summary

**116 witnesses.** All GREEN. All parity-confirmed.

Of these, **86 are Phase 4** (inherited Zig `std` seam — `usize` documented, not changed) and **4 are authored** (Tier A — Tally, Mantra, Rishi, Skate). The full per-function detail lives in each pass's own document under `strengthening-compiler/`. The lexicon carries the std-shaped tree with audit status.

## What this means for the width migration

The Phase 4 passes document the `usize` seam in inherited `std` — they record where `usize` lives so the future fork (F1–F5 in `992`) knows what to change. They do not introduce `usize` into authored code.

The four authored passes (9987–9990) follow the Tier A policy: `u32` for bounded counts, `usize` only at the slice edge where Zig requires it.

## When to update this document

After every strengthening pass, re-run the enricher (`tools/enrich_strengthening_docs.rye`) and update the counts above. The 97-line table that was here previously is retired — the lexicon is the authoritative per-function index.

---

*One hundred sixteen witnesses, each green. The seam is documented; the authored code stays narrow.*
