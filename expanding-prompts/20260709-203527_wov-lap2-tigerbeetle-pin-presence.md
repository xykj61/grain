# Expanding Prompt — WOV Lap 2a: TigerBeetle Pin Presence

**Stamp:** `20260709.203527`
**Voice:** Rio 3
**Status:** **Landed** `20260709.203527` — pin presence GREEN; parity **203**; no TB client link
**Ground:** exit-honesty [`200443`](../context/specs/20260709-200443_wov-exit-honesty.md) · WOV lap 1 [`200729`](../linengrow/wov_core.rye) · night brief Q1 [`203139`](../external-research/20260709-203139_claude-review-brief-jul9-night-climb.md) · LEXICON pin `59f2b99`

---

## Why This Lap Before a Client Wrapper

Night brief asked whether the next WOV climb should be a TB pin wrapper or more soak. The honest middle: **prove the pin on metal** (rev, license, TIGER_STYLE, entry source) as a parity witness, while still forbidding any Rye `@import` or link of TigerBeetle into shipped binaries. That accretes the "pin, never fork" promise without opening the client-protocol seam Claude may still want to shape.

## DoD

1. `tools/wov_tb_pin.rish` GREEN — submodule HEAD matches pinned full SHA; `LICENSE` names Apache; `docs/TIGER_STYLE.md` and `src/tigerbeetle.zig` present.
2. Wired into `parity.rish` → **203**.
3. Expanding prompt + TASKS/LEXICON note: client wrapper waits Claude/Kaeden after this soak.

## Explicitly out of scope

- Building or running the TigerBeetle binary
- Rye overlay calling TB (client protocol)
- Dual monarch
- Changing the gitlink rev (pin stays `59f2b995b6db9116ed8b257a33e39705234b3a6e`)
