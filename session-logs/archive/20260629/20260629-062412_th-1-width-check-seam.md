# TH-1 — seam-aware width-check lands

**Editor:** Cursor · **Model:** Composer

**Stamp:** `20260629.062412`

**Prompt:** Fresh session at the keystone — `20260629-032712_cursor-fresh-session-start-at-th1.md`, with Kaeden's processed confirmation that TH-0/TH-0b are closed and TH-1 is next.

## Thinking trace

Read the fresh-session prompt and Kaeden's processed text. Confirmed the tree: TH-0 rename and TH-0b rules/baseline already landed; the bench pointed honestly at TH-1 as the width-check keystone.

Inspected `tools/width-check.rish` — still a blunt `grep -c usize` gate that flagged Tally's own `@intCast` seam lines. Read `tally/seed.rye` for the exemplar pattern and tested a shell pipeline: grep `usize`, then exclude lines carrying `@intCast` or `@as(usize`.

Implemented the refined lint in Rishi using `map`/`where` over that pipeline per file. Hit one Rishi quirk: binding name `file` in a map body triggered `UndefinedName` — renamed to `path`.

Added `tools/width_check_th1.rish` witness (Tally passes, authored fixture fails), a minimal fixture at `tools/fixtures/width_check_authored_usize.rye`, and registered the witness in `tools/parity.rish`.

Ran on metal with `HOME=.build-home`: witness GREEN; full `width-check.rish` now 7/11 clean (Tally, Caravan quartet, brushstroke) and 4/11 RED (mantra, rishi, comlink, aurora) — expected until TH-3/TH-5. Parity suite green including the new witness.

Updated `TASKS.md`, `ROADMAP.md`, width baseline table, and `context/TAME_GUIDANCE.md` lint wording to match seam-aware policy.

## Observations

The keystone does exactly what ruling #1 promised: the gate blesses correct Tiger seam code rather than asking us to delete casts. TH-3's mantra migration is now a well-defined next step against a lint that agrees with the supplement.

Full corpus width-check still exits RED — by design — until migrations land; only the directional witness is in parity today.

## Files

| File | Why |
|------|-----|
| `tools/width-check.rish` | Seam-aware authored-`usize` lint; gate asserts on RED |
| `tools/width_check_th1.rish` | TH-1 witness — both directions |
| `tools/fixtures/width_check_authored_usize.rye` | Authored-debt fixture for the witness |
| `tools/parity.rish` | Register TH-1 witness in the suite |
| `work-in-progress/TASKS.md` | TH-1 checked; TH-2 next |
| `work-in-progress/ROADMAP.md` | TH-1 done on the map |
| `work-in-progress/20260620-212126_usize-width-baseline.md` | Tooling table reflects refined lint |
| `context/TAME_GUIDANCE.md` | Lint table and prose match seam policy |
