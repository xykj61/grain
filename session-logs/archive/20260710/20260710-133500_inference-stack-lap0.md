# Inference Stack Lap 0 — Lattice, Lantern, Scribble, Anvil, Assist View

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3
**Stamp:** `20260710.133500`

## Thinking trace

Kaeden authorized go-forth on the local-forge vision from the prior turn: expand Lattice/Lantern/Scribble/Anvil, seat module roots, and prove an assist Skate fold on the bench — same thin-view discipline as Dimeroll sight.

Build order from canon: Lattice before Lantern; Anvil corpus before LoRA. Lap 0 stays SLC-sized: no ROCm, no Pond worker, no PyTorch — only bounded primitives, fixture completion, corpus catalog, and `assistviewtest`.

Implemented four module directories mirroring Dimeroll's pattern (`*_core.rye` + selftest binary + fixtures + `tools/*_lap1.rish`). Scribble blocks copy text into inline buffers so fence bodies survive past the parse walk. Lantern renamed `StoppedReason.error` to `err_stop` — Zig rejected the bare `"error"` string in the compare arm.

Assist view composes Anvil corpus counts, Lantern fixture tokens/suggestion, Dimeroll P&L net, and a lattice matmul green line on one eight-line Skate frame — thin-view exception, no Dexter graduation.

## Observations

- Parity rises **210 → 215** with five new witnesses.
- Inference Track opened in ROADMAP at rung 0; ROCm/LoRA/Pond remain horizon.
- Horizon essay filed in external-research; hammock + expanding-prompt index the lap.

## Files

| File | Why |
|------|-----|
| `lattice/lattice_core.rye`, `lattice/lattice.rye`, `lattice/README.md` | f32 matmul lap 0 |
| `scribble/scribble_core.rye`, `scribble/scribble.rye`, `scribble/fixtures/sample.md`, `scribble/README.md` | markdown blocks + rye_fence |
| `lantern/lantern_core.rye`, `lantern/lantern.rye`, `lantern/fixtures/completion.bron`, `lantern/README.md` | fixture completion contract |
| `anvil/anvil_core.rye`, `anvil/anvil.rye`, `anvil/fixtures/rye_corpus.bron`, `anvil/README.md` | corpus catalog |
| `pond/apps/drawn_terminal.rye` | `assistviewtest` + version `133500` |
| `tools/lattice_lap1.rish` … `tools/inference_assist_view.rish` | witnesses 211–215 |
| `tools/parity.rish` | wired new suite arms |
| `active-designing/20260710-133500_inference-stack-lap0-hammock.md` | checkable-room hammock |
| `external-research/20260710-133500_local-forge-minisforum-inference.md` | visionary horizon essay |
| `expanding-prompts/yonder/20260710-133500_inference-stack-lap0.md` | runnable plan |
| `work-in-progress/TASKS.md`, `ROADMAP.md`, `context/LEXICON.md`, `tools/compass_rose.rish` | indexes + navigation |

**Recommend:** keep going to **Anvil lap 1 embedding index** over Tablecloth query (mechanical filter extension) or **Lattice lap 1 ROCm host seam** as a separate host binary — check in with Claude before seating ROCm as a permanent ship seam or opening Pond Lantern policy.
