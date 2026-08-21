# Drawn-terminal window size bump

**Editor:** Cursor · **Model:** Composer
**Stamp:** 20260703.135212

## Thinking trace

Kaeden confirmed live SLC-2b works (`rishi> hello` in window) and asked for a bigger window. Bumped Skate surface from 960×512 to **1280×768** (grid-aligned: 80×24 cells at 2× glyph scale). First try 1280×720 failed compile — height must divide evenly by 32.

## Observations

Rebuild via rishi build witness; live is the only check that matters for size.

## Files

| File | Why |
|------|-----|
| `brushstroke/wayland_seed.rye` | Default toplevel buffer 1280×768 |
