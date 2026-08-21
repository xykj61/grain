# zig-wayland — Zig scanner + libwayland bindings (Isaac Freund)

**License:** MIT (Expat) — same family as libwayland-client  
**Role for us:** Study lodestar for how a Zig project generates typed Wayland bindings and links `wayland-client` on a host. **Not vendored this stamp.**  
**Upstream:** <https://codeberg.org/ifreund/zig-wayland> (mirrors on SourceHut · GitHub)  
**Author:** Isaac Freund (also River) — River's *compositor* is GPLv3; this binding crate is MIT.

**Clean room:** Study public design and docs; never copy source into our modules until a gratitude pin + LICENSE_WORD path says otherwise. Hosted Brushstroke today already links `libwayland-client` via `@cImport` in `brushstroke/wayland_seed.rye` — zig-wayland is an alternate *Zig-native binding style* to compare, not a required dependency.

## What we study

- Protocol scanner integrated with `build.zig` (system + custom XML → typed module)
- Explicit `scanner.generate(interface, version)` for forward compatibility
- Client module shape: `wayland.client.wl` after import
- Still links system `wayland-client` — not a freestanding Wayland stack

## What we decline (this season)

- Vendoring or linking zig-wayland into Grain before a seated gratitude clone word  
- Treating it as a path to absorb River (GPL) code  
- Replacing our Glow/Rye Frame → SHM path with a Zig-only GUI stack

Surface Season p4 ledger: `counsel/date/20260728/20260728-195228_surface-season-p4-river-zig-wayland-study-ledger.md`
