# Amphora lap 2 — pour, carry, cold scrub

**Editor:** Cursor · **Model:** Grok 4.5 · **Voice:** Rio 3
**Stamp:** 20260710.143726

## Thinking trace

Kaeden said keep going and open gates. Lap 1 + forge query already merged (#13). Opened Amphora lap 2 at fixture scale: pour Amber ring-1 season into vessel bundle, carry home → dock → far, cold scrub (parent check + vessel parse + Amber verify + restore), assert 3-2-1 paths, refuse tampered far resin. Extended `vessel_core` with `parse` CLI. Parity **224**.

## Observations

- Reuses Amber export/verify/restore — no new cellar season runner yet.
- Scrub at lap 2 = cold digest walk (fixture scale); signature-fold scrub stays later Amber season work.
- Kumara stamp and Comlink fetch remain lap-3 / later.

## Files

- `tools/fixtures/amphora_{pour,carry,scrub_arrival,lap2_witness}.sh`
- `tools/amphora_lap2.rish` · parity wire
- `amphora/vessel_core.rye` — `parse` path
- amphora README · sealed crossing · LEXICON · TASKS · ROADMAP

**Recommend:** keep going to Amphora lap 3 (Comlink fetch-by-digest for vessel cargo) or wire poured vessel into forge view golden.
