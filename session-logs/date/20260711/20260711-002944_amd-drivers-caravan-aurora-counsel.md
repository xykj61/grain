# Counsel — AMD drivers for Caravan and Aurora?

**Stamp:** 20260711.002944  
**Editor:** Cursor · **Model:** Cursor Grok 4.5 · **Voice:** Rio 3  
**Prompt:** have we thought enough about AMD drivers for Caravan and Aurora?

## Thinking

Kaeden asked whether AMD driver thinking is enough for Caravan and Aurora. Re-read Minisforum forge essay, ROCm rung 2, Caravan microkernel (user-space drivers, `gpu0` capability), Aurora RISC-V boot, sovereign-framebuffer wait gate.

## Observations

- **Enough for Inference host seam:** ROCm named as rung **2**; RX 7900 / Strix Halo as host compute; "host seam, not Rye link."
- **Thin for Caravan:** display/`gpu0` is capability vocabulary only — no amdgpu/DRM/KMS strategy, no user-space driver lap.
- **Thin for Aurora:** RISC-V-first freestanding stages; no x86_64 AMD firmware/GOP bring-up story.
- Three seams stay distinct: (1) host ROCm for Lattice, (2) Caravan user-space GPU/display later, (3) Aurora early graphics — only (1) has a named gate.

## Files

- this log · session-logs README index row

## Recommend

Recommend: keep going to a short visionary brief that separates those three AMD seams before any driver code — or hold and climb RW-5 / tip **418**; do not open Caravan amdgpu without that brief.
