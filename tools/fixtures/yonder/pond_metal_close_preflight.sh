#!/usr/bin/env sh
# pond_metal_close_preflight.sh — automated checks before Kaeden's interactive metal close.
# Run from the repository root. Interactive steps (type, idle, ceiling, :quit) remain manual on GNOME.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$root"

echo "preflight: building drawn-terminal..."
sh tools/fixtures/pond_build_drawn_terminal.sh

echo "preflight: headless session witness..."
pond/bin/drawn-terminal sessiontest

if [ -n "${WAYLAND_DISPLAY:-}" ]; then
  echo "preflight: Wayland metalsmoke..."
  rishi/bin/rishi run tools/slc2a_ring3_metal.rish
else
  echo "preflight: WAYLAND_DISPLAY unset — skip metalsmoke; run preflight again on GNOME before live close."
fi

echo ""
echo "PREFLIGHT GREEN: build and headless witness passed."
echo "Next (Kaeden, on GNOME): pond/bin/drawn-terminal — type, idle ~1 min, fill past ceiling, :quit."
echo "See pond/README.md for the five-step checklist."
