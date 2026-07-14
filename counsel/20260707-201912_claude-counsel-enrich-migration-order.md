# Claude Counsel — the `enrich/` Remainder, Ordered by Its Own Dependency Graph

**Stamp:** `20260707.201912 UDT` (Kaeden's clock)
**Voice:** Rio 3
**Language:** EN
**Style:** Radiant (see `../context/RADIANT_STYLE.md`) · **Lens:** the collaboration rule — a rename's inbound references are promises
**Register:** A per-file order, built from the graph rather than guessed at, plus the one cross-cutting risk the graph alone would not show
**Ground:** every `@import` line across all fifteen remaining `enrich/` files, traced into a full dependency graph · every external caller of an `enrich/` function found by name, across every `.rye` file outside `enrich/`, including the three files this season already finished

*Written by Kaeden and Rio 3.*

---

## The Count, Confirmed, and the Shape Underneath It

Sixty-five functions, fifteen files, unchanged from the report — this bench re-measured rather than trusted the number forward. What the count alone does not show is which fifteen files can move safely on their own and which ones lean on others first. That graph is the actual answer to "per-file order," so this bench built it in full before writing anything down.

## The Graph, Read Into Five Tiers

**Tier 1 — true leaves, no `enrich/`-internal dependency at all, movable in any order relative to each other:** `buf.rye` (1), `scan_text.rye` (6), `zig_lookup.rye` (6), `root.rye` (1), `constants.rye` (5) — five files, nineteen functions, nothing inside `enrich/` needs to change when these rename.

**Tier 2 — depend only on Tier 1:** `surfaces.rye` (9, leans on `scan_text`), `witness.rye` (4, leans on `constants`), `sections.rye` (9, leans on `constants`) — three files, twenty-two functions.

**Tier 3 — depend on Tiers 1–2:** `blocks_surface.rye` (4), `blocks_audit.rye` (7), `extract.rye` (4) — each leaning on `surfaces` from Tier 2 plus various Tier 1 files — three files, fifteen functions.

**Tier 4 — depend on Tiers 1–3:** `enrich_file.rye` (1, leans on `blocks_surface`), `sync.rye` (4, the most connected file in the whole subsystem, leaning on `blocks_audit`, `blocks_surface`, `extract`, `sections`, `witness`, and three Tier 1 files at once) — two files, five functions.

**Tier 5 — depend on all four tiers before it:** `crosswalk.rye` (1) and `lexicon.rye` (3), each leaning on `sync` from Tier 4 among everything else — two files, four functions.

Nineteen plus twenty-two plus fifteen plus five plus four totals sixty-five, matching the count exactly — the graph and the census agree.

## The One Risk the Graph Alone Would Not Show

A dependency graph built only from `enrich/`'s own `@import` lines answers "what does this subsystem lean on internally." It does not answer "who outside this subsystem leans on it" — and that question turned up something worth naming precisely before any tier moves. `tools/enrich_strengthening_docs.rye`, the orchestrator this season already touched once without editing, calls eight `enrich/` functions by their current camelCase names in its own `main()`: `loadZigSources`, `listPassDocs`, `syncWidthAuditDocs`, `syncPassAuditWritings`, `completePendingWidthAudits`, `crosswalkRows`, `generateLexicon`, `enrichFile`. And three files this season already finished — `align_session_logs.rye`, `session_logs_archive.rye`, and `enrich_strengthening_docs.rye` itself — each call `root_mod.resolveRoot` by its current name too, since `root.rye` has not moved yet. This means `enrich_strengthening_docs.rye` is not a bystander to this migration; it is touched at every tier boundary where something it calls renames, and skipping it at any one of those points would leave a stale call site sitting exactly the way `device_wire.rye`'s `negotiateFeatures` sat for a full season — the same collaboration-rule failure this tree has already paid to learn from once.

## The Order, With the Cross-Cutting Touch Named at Each Point

**Tier 1:** rename all nineteen functions across the five leaf files. In the same step, repoint `resolveRoot`'s three external callers (`align_session_logs.rye`, `session_logs_archive.rye`, `enrich_strengthening_docs.rye`) and `loadZigSources`'s one external caller (`enrich_strengthening_docs.rye`) to `resolve_root` and `load_zig_sources`. Four external call sites, alongside the nineteen internal renames.

**Tier 2:** rename the twenty-two functions across `surfaces.rye`, `witness.rye`, `sections.rye`. No external callers outside `enrich/` reach these three directly — the only inbound references are from other `enrich/` files, all still ahead of this tier in the graph, so nothing outside this step needs touching.

**Tier 3:** rename the fifteen functions across `blocks_surface.rye`, `blocks_audit.rye`, `extract.rye`. Same shape as Tier 2 — no external callers outside `enrich/` reach these three by name.

**Tier 4:** rename the five functions across `enrich_file.rye` and `sync.rye`. In the same step, repoint `enrichFile`'s one external call site and `sync`'s four external call sites — `listPassDocs`, `syncWidthAuditDocs`, `syncPassAuditWritings`, `completePendingWidthAudits` — all in `enrich_strengthening_docs.rye`. Five internal renames, five external call sites, one file touched twice this season and once more here.

**Tier 5:** rename the four functions across `crosswalk.rye` and `lexicon.rye`. In the same step, repoint `crosswalkRows` and `generateLexicon`'s two remaining external call sites, both in `enrich_strengthening_docs.rye` one final time.

## What This Leaves

Five tiers, each independently buildable and witnessable before the next begins — `tools/enrich_strengthening_docs.rish` re-run after every tier that touches its own call sites (Tiers 1, 4, and 5), the other two tiers needing only the existing `tame_style_check` ratchet to confirm the count fell. No tier requires more than three files at once, and the file most at risk of a stale reference — the one this counsel exists to protect — is named at every point it needs a second look.

---

*May every tier leave the ground under it exactly as solid as it found it. May the file that calls the most things be watched the most closely, precisely because it asks for nothing extra to be remembered — only to be remembered every time. And may the sixty-five that remain arrive at zero five small steps at a time, rather than one large one that risks losing count of itself.*
