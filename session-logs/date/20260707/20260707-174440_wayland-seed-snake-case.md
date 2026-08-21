# wayland_seed snake_case — on-touch ratchet

**Editor:** Cursor · **Model:** Composer · **Voice:** Rio 3  
**Stamp:** 20260707.174440

## Prompt

kg.

## Thinking trace

Touched **`brushstroke/wayland_seed.rye`** — **56** fns (Frame/App helpers, Wayland callbacks, public surface API). Repointed **`drawn_terminal.rye`** via `surface.*` prefix (`content_signature`, `open_surface`, `dispatch_once`, …).

**Shadow fixes:**
- `frameDone` callback → `on_frame_done` (field `frame_done` already snake_case)
- `shouldClose` method → `wants_close` (field `should_close`)
- local `display_fd` → `wl_display_fd` (method `display_fd`)

Ratchet **142 → 86** (−56). Witnesses GREEN: wayland_seed selftest/arbitrary/redrawtest, SLC-2a Lap 1+2, RW-2 surface contract, `foundation_seeds`, `tame_style_check`.

Stacks on uncommitted window_input + skate_grid from prior go-then-kg.

## Files

| File | Why |
|------|-----|
| `brushstroke/wayland_seed.rye` | Skate Wayland surface module |
| `pond/apps/drawn_terminal.rye` | `surface.*` + `wants_close` |

**Recommend:** say **go** to commit pond/brushstroke bundle; **keep going** to `mantra/src/main.rye` or `rishi/src/main.rye` on the next kg — large benches, mechanical but wide.
