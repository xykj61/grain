# Lap vocabulary seated — Rishi sweep, not Python

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3
**Stamp:** `20260704.020100`

## Thinking trace

Kaeden affirmed **lap** over **ring** with no forward-facing *ring* usage, and asked that maintenance scripts be **Rishi (`.rish`)**, not Python.

The prior turn had run an inline Python bulk-replace; it corrupted substrings (`render`→`rendelap`, `wearing`→`wealap`, and parity pointing at a nonexistent `amber_first_lap.rish`). Reverted all uncommitted changes with `git checkout -- .` before redoing.

Built house-pattern tooling:
- `tools/fixtures/lap_vocabulary_sweep.sh` — word-boundary `perl` replacements (thin edge, lap phrases, path slug updates); frozen witness basenames untouched in paths.
- `tools/fixtures/lap_vocabulary_audit.sh` — bash audit excluding session-logs and gratitude.
- `tools/lap_vocabulary_sweep.rish` — Rishi entry point (same shape as `chrono_version_sweep.rish`).

Renamed canonical files:
- `first-ring-goes-green.md` → `first-lap-goes-green.md`
- `the-happy-zone-and-the-thin-ring.md` → `the-happy-zone-and-the-thin-edge.md`

Ran sweep across context, foundations, WIP, active-designing (including yonder), external-research, tools comments, parity say-lines. LEXICON: **Lap** row, retired *ring* · *thin ring*. Audit **GREEN** on forward-facing tree.

## Files

| File | Why |
|------|-----|
| `tools/lap_vocabulary_sweep.rish` | Rishi witness for vocabulary hygiene |
| `tools/fixtures/lap_vocabulary_sweep.sh` | Word-boundary sweep (invoked by rish) |
| `tools/fixtures/lap_vocabulary_audit.sh` | Post-sweep audit |
| `external-research/20260703-033602_first-lap-goes-green.md` | Renamed + lap prose |
| `foundations/20260702-165412_the-happy-zone-and-the-thin-edge.md` | Renamed + thin edge |
| `context/LEXICON.md` | Lap seated; ring retired forward-facing |
| ~150 living docs | Lap / thin edge phrase deltas |

Frozen: `slc2a_ring*.rish`, `amber_first_ring.rish`, `slc1-ring-closed-handoff.md` filename — session logs keep historical *ring*.

## Next step

**Recommend: keep going to** seat **toll** + `one-word-one-gate` spec per gate-unify counsel §4 — mechanical LEXICON/spec deltas Kaeden already affirmed in spirit; then crossing manifest seed witness.
