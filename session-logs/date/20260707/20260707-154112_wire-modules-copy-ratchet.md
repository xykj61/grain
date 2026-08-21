# Shared wire modules — copy_disjoint ratchet turn

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.154112

## Prompt

Keep going — shared wire modules (`recall_sync_wire`, `wire_format`, etc.).

## Thinking trace

Four canonical modules carry every Comlink wire crossing: `comlink/wire_format.rye` (mantra symlinks here), `mantra/recall_sync_wire.rye`, `mantra/recall_batch_wire.rye`, and `mantra/recall_lap1.rye` (comlink symlinks to mantra for the latter three). Thirty-two `@memcpy` sites became `copy_disjoint` — seal layout, sync encode/decode, batch chunk assembler, and catalog `appendLeaf`/`recall`.

Witnesses GREEN: hosted wire, NS-L1, NS-L3 logic + wire, batch wire. `@memcpy` ratchet **78 → 46**. Cumulative from `053212`: **121 → 46** (uncommitted with prior ratchet turns).

## Files

| File | Sites |
|------|-------|
| `comlink/wire_format.rye` | 7 |
| `mantra/recall_sync_wire.rye` | 14 |
| `mantra/recall_batch_wire.rye` | 5 |
| `mantra/recall_lap1.rye` | 6 |

**Recommend:** keep going to `beading.rye` / `recall_beaded.rye` next, or say **go** to commit the full ratchet arc (**121→46**) in one pass.
