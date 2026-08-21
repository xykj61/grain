# SLC-2b — Dexter keyboard from the window

**Editor:** Cursor · **Model:** Composer
**Stamp:** 20260703.132845

## Thinking trace

Kaeden's nod placed keyboard input in `pond/apps/` as a Dexter aspect extending Ring 3's poll loop. The build needed three seams: Wayland seat + keyboard + xkbcommon in Brushstroke's surface app, a pure line editor in Pond for headless replay, and a live loop in the drawn terminal that drains key actions into `runOneInput` and redraws.

Extended `brushstroke/wayland_seed.rye` with `wl_seat`, `wl_keyboard`, and xkbcommon keymap handling; exposed `enableKeyboard`, `popKeyAction`, and `keyboardReady`. Added `pond/apps/window_input.rye` as the LineEditor. Rewired `pond/apps/drawn_terminal.rye` so live mode types in the window (stdin remains for dev), shows `rishi> partial` in the status row while composing, and submits on Enter including `:quit`.

Headless witness `keyboardtest` replays the editor path without a compositor. Wired `tools/slc2b_keyboard.rish` into parity after Amber — **145 GREEN** on metal. Updated Ring 1/2 build scripts to link `-lxkbcommon` after the surface seed gained keyboard imports.

## Observations

- `formatPromptStatus` must dupe into the arena — returning a stack `bufPrint` slice through `boundStatus` failed the typing-line assert in the witness.
- Interactive window typing on GNOME remains Kaeden's hand; the headless witness proves the Rishi → redraw path Dexter owns.

## Files

| File | Why |
|------|-----|
| `brushstroke/wayland_seed.rye` | Wayland keyboard seam + xkbcommon |
| `pond/apps/window_input.rye` | Dexter line editor (new) |
| `pond/apps/drawn_terminal.rye` | Live keyboard loop + `keyboardtest` witness |
| `tools/slc2b_keyboard.rish` | Parity witness (new) |
| `tools/parity.rish` | Append SLC-2b block |
| `tools/slc2a_ring{1,2,3}_*.rish`, `tools/fixtures/pond_build_drawn_terminal.sh` | `-lxkbcommon` on all drawn-terminal / wayland-seed builds |
| `pond/README.md`, `work-in-progress/TASKS.md`, `ROADMAP.md`, RTAC, expanding prompt, SLC-2a scope note | Parity **145** refresh |
