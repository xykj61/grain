# TH-3 — Mantra width and seam policy

**Editor:** Cursor · **Model:** Composer  
**Stamp:** 20260629.175044

## Thinking trace

Applied Claude's TH-3 ruling on the verified surface: seven authored `usize` in `diff.rye` (2) and `main.rye` (5). Migrated backtrack indices to `u32` with `@intCast` at slice and table index sites; `added`, `depth`, and `max_log_depth` to `u32`. Left `store.rye` and `weave.rye` untouched.

Wrote the canonical seam policy into `TAME_GUIDANCE` — three widths, two seam moves, `bufLenU32` reuse, Mantra as worked example, gate timing note (global `width-check` stays RED and outside parity until Rishi/Comlink). Added `tools/width_check_th3.rish`; registered in `parity.rish` (125 witnesses). Added `mantra/src/diff.rye` to `width-check.rish` scan list.

Metal: TH-3 witness green; parity green; global width-check RED at 3/12 (rishi, comlink, aurora) — expected. Codified next-step recommendation into session-log rules (Cursor + Claude).

## Observations

Width refinement only — behavior-identical casts. Comlink and Rishi inherit the written policy in their own passes without another strategy stop unless a site the policy does not place appears.

**Recommend: keep going to TH-4** — `.brix` dead-path mend is mechanical and single-file; no Claude pause needed unless stale paths reveal an unmade ruling.

## Files

| File | Why |
|------|-----|
| `mantra/src/diff.rye`, `mantra/src/main.rye` | seven `usize` → `u32` + seam casts |
| `context/TAME_GUIDANCE.md` | canonical seam policy |
| `tools/width_check_th3.rish`, `tools/width-check.rish`, `tools/parity.rish` | module witness; diff in scan; parity 125 |
| `work-in-progress/TASKS.md`, `ROADMAP.md` | TH-3 done; TH-4 next |
| `.cursor/rules/session-logs.mdc`, `.claude/rules/session-logs.md` | next-step recommendation convention |
