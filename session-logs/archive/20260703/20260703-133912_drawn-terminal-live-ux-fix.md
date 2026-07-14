# Drawn terminal live UX — freeze, size, readability

**Editor:** Cursor · **Model:** Composer
**Stamp:** 20260703.133912

## Thinking trace

Kaeden reported live `pond/bin/drawn-terminal` froze GNOME ("Unknown is not responding"), opened tiny, and text was barely readable. Traced three causes: broken `dispatchOnce` (cancelled Wayland read before polling, never called `wl_display_read_events`), 400×240 buffer with 8×8 glyphs on HiDPI, and blocking `waitForKeymap` before first paint.

Fixed the Wayland event loop, doubled glyph scale (960×512 window, 2× raster), set app_id/title/min_size, non-blocking `updateFrame` during typing, continuous 16ms dispatch in live loop, and toplevel close handling.

## Observations

Old hung process held the binary (`FileBusy` on rebuild) — Kaeden should Force Quit then rebuild. Parity **145** still GREEN after changes.

## Files

| File | Why |
|------|-----|
| `brushstroke/wayland_seed.rye` | Wayland read fix, larger window, updateFrame, app_id, close |
| `brushstroke/skate_grid.rye` | Scaled rasterize |
| `brushstroke/skate_grid_test.rye` | scale=1 call |
| `pond/apps/drawn_terminal.rye` | Live loop dispatch, no keymap block |
