# Drawn terminal runLive — 70-line split

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.162712

## Prompt

Keep going.

## Thinking trace

Split `runLive` (78 lines) in `pond/apps/drawn_terminal.rye` at natural loop seams: `liveBootApp` (surface boot + banner), `liveDrainKeyboard` (key-action round), `liveReadStdinSubmit` (stdin line round), thin `runLive` poll loop. Fixed compile error: `editor` in `liveBootApp` is `const` until returned into the live struct the loop mutates.

Witnesses GREEN: `pond_build_drawn_terminal`, `slc2a_ring3_session`, `slc2b_keyboard`, `rw2_app_collab`, `tame_style_check`. The >70-line ratchet ledger is empty for authored `.rye`.

**Uncommitted bundle (four turns):** OA-L5 wire-verify (`open_asks_lap5_delivery.rye`), caravan `runSupervisor` split, mantra subscribe-poll selftest split, this file.

## Files

| File | Why |
|------|-----|
| `pond/apps/drawn_terminal.rye` | `runLive` split — keyboard/stdin rounds extracted |

**Recommend:** say **go** to commit and push the four-file 70-line bundle to all remotes; optional full parity re-run at new tip.
