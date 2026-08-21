# TH-2b — Mantra bare assert compliance

**Editor:** Cursor · **Model:** Composer

**Stamp:** `20260629.093012`

**Prompt:** Kaeden's TH-2b ruling — Mantra-only; 38 sites; import-once; witness gates module; TH-2c deferred.

## Thinking trace

Applied pure rename across four `mantra/src/*` files: `const assert = std.debug.assert;` after std import, every `std.debug.assert(` → `assert(` (26+7+3+2 = 38). Aurora untouched.

Added `tools/fixtures/tame_check_mantra.sh` and `tools/tame_check_th2b.rish` — gates Mantra zero unqualified asserts with import-once present. Registered in parity (123 witnesses). Updated `tame_check_th2.rish` — no longer expects Mantra FAIL after TH-2b.

Metal: mantra build green with `RYE_ZIG`; parity green; global tame-check shows four Mantra files OK, 9/16 still assert debt elsewhere (TH-2c).

## Observations

Rename only — no logic change. Next mechanical pass: TH-2c on Tally/Caravan/Rishi/Comlink/Brushstroke. True Claude pause: TH-3 width migration at slice seams.

## Files

| File | Why |
|------|-----|
| `mantra/src/main.rye` | import-once + 26 bare asserts |
| `mantra/src/weave.rye` | import-once + 7 bare asserts |
| `mantra/src/store.rye` | import-once + 3 bare asserts |
| `mantra/src/diff.rye` | import-once + 2 bare asserts |
| `tools/fixtures/tame_check_mantra.sh` | Module-clean scan |
| `tools/tame_check_th2b.rish` | TH-2b witness |
| `tools/tame_check_th2.rish` | Updated post-Mantra-clean |
| `tools/parity.rish` | Register TH-2b witness |
| `work-in-progress/TASKS.md` | TH-2b done; TH-2c queued |
| `work-in-progress/ROADMAP.md` | Bench order updated |
| `expanding-prompts/20260629-090912_cursor-th2b-mantra-bare-assert.md` | Prompt archived |
