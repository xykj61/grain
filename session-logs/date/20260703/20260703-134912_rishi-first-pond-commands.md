# Rishi-first — Pond build and witness commands

**Editor:** Cursor · **Model:** Composer
**Stamp:** 20260703.134912

## Thinking trace

Kaeden confirmed the staged build witness GREEN and asked to prioritize rishi commands. Updated `pond/README.md` so every hosted step (build, Ring 3, SLC-2b, metalsmoke, preflight) leads with `rishi/bin/rishi run`; live mode remains the sole direct binary invocation. Manual `rye build` and direct `.sh` moved to a collapsed escape-hatch section. Header comments in `drawn_terminal.rye` and build fixtures now point at the rish entry.

## Observations

Rishi buffers subprocess output until exit — the `.sh` path stays documented only for watching compile heartbeats stream.

## Files

| File | Why |
|------|-----|
| `pond/README.md` | Rishi-first command table |
| `pond/apps/drawn_terminal.rye` | Build header → rish |
| `tools/fixtures/pond_build_drawn_terminal.rish` | Canonical entry in header |
| `tools/fixtures/pond_build_drawn_terminal.sh` | Hosted script; rish is canonical |
