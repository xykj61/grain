# Pond build progress lines — opening-lines spirit for compile

**Editor:** Cursor · **Model:** Composer
**Stamp:** `20260703.030712`

## Thinking trace

Kaeden Ctrl+C preflight during silent Zig compile. Rishi buffers subprocess output until exit; nested `rishi run` made it worse. Added `pond_build_drawn_terminal.sh` with Language/Style/Lens staged lines and 15s heartbeat during compile; preflight and metalsmoke call `.sh` directly; preflight prints three header says before build starts.

## Files

| File | Why |
|------|-----|
| `tools/fixtures/pond_build_drawn_terminal.sh` | Staged progress + heartbeat |
| `tools/fixtures/pond_build_drawn_terminal.rish` | Thin wrapper |
| `tools/fixtures/pond_metal_close_preflight.rish` | Header says; calls .sh |
| `tools/slc2a_ring3_metal.rish` | Calls .sh with say |
