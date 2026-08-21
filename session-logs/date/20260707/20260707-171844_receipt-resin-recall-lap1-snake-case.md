# receipt + resin_batch + recall_lap1 snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.171844

## Prompt

kg (after handoff mid–recall_lap1).

## Thinking trace

Completed the interrupted `recall_lap1` migration: first pass renamed only top-level `pub fn` (regex `^pub fn`); **BoltCatalog** struct methods (`appendLeaf`, `revisionLeafCount`, …) stayed camelCase and broke nothing until dot-callers mixed.

1. Renamed **8** remaining methods + **2** private helpers in `mantra/recall_lap1.rye` (`find_leaf`, `max_revision_for_path`, …).
2. Repointed **25** caller files via `.append_leaf` / `.init_witness` / … dot replacements.
3. Caught partial rename `append_leafBeaded` from overlapping `appendLeaf` → `append_leaf` substitution; finished **`recall_beaded.rye`** (**8** fns) and **3** `rbd.*` callers.

Bundled with prior uncommitted **receipt** (`run_selftest`) and **resin_batch** (**14** fns, **6** `rb.*` callers).

Ratchet **462 → 421** (−41). Witnesses GREEN: SLC-L1, `mantra_resin_batch`, `mantra_recall_lap1`, lap2/3, catch-up (+ wire), subscribe poll, two-way (+ wire), beaded, **batch_wire** (after beaded fix), `tame_style_check`.

## Files

| Cluster | Why |
|---------|-----|
| `linengrow/receipt.rye` | `run_selftest` |
| `mantra/resin_batch.rye` + 6 callers | `rb.*` batch frame API |
| `mantra/recall_lap1.rye` + 25 callers | catalog API + module fns |
| `mantra/recall_beaded.rye` + 3 callers | beaded append/recall/hydrate |

## Observations

Scoped rename discipline holds: struct methods need the same pass as top-level `fn`; substring replacement on `appendLeaf` can corrupt `appendLeafBeaded` — rename longer identifiers first or finish sibling modules in the same touch.

**Recommend:** say **go** to commit this bundle; **keep going** to `recall_sync_wire.rye` or `recall_catch_up.rye` module-level camelCase on the next kg.
