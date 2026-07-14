# TH-2 — tame-check informational lint lands

**Editor:** Cursor · **Model:** Composer

**Stamp:** `20260629.092512`

**Prompt:** Kaeden asked to continue the bench and when to check in with Claude for strategy.

## Thinking trace

Pulled tip `81988f0`; TH-2 still open (no `tame-check.rish`). Built informational lint per TAME Guidance: unqualified `std.debug.assert(`, `Self = @This()`, tabs, trailing whitespace. Rishi string interpolation fought nested shell `$` — moved scan to `tools/fixtures/tame_check_scan.sh` (Step 2 witness pattern). Fixed grep `-c` double-zero bug with `|| true` and `${var:-0}`.

Added `tools/tame_check_th2.rish` witness (runs lint, expects Mantra assert debt before TH-2b); registered in `tools/parity.rish`. Metal: 13/16 files report assert debt, 2/16 clean (aurora freestanding); informational exit 0. Parity green.

Left TH-2b (Mantra bare assert migration) for next pass — mechanical but touches SLC-1 path; good Claude strategy checkpoint before bulk assert rewrites.

## Observations

TH-2 is lint-only; TH-2b is the first code migration on the hardening ring. RS-1 and TH-3 wait behind TH-2b per bench order.

## Files

| File | Why |
|------|-----|
| `tools/tame-check.rish` | Informational TAME lint entry point |
| `tools/fixtures/tame_check_scan.sh` | Scan corpus for three textual rules |
| `tools/tame_check_th2.rish` | TH-2 witness |
| `tools/parity.rish` | Register TH-2 witness |
| `work-in-progress/TASKS.md` | TH-2 checked; TH-2b next |
| `work-in-progress/ROADMAP.md` | TH-2 done on map |
| `context/TAME_GUIDANCE.md` | Lint table points at tame-check |
