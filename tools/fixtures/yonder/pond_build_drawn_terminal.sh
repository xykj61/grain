#!/usr/bin/env sh
# pond_build_drawn_terminal.sh -- build pond/bin/drawn-terminal from repo root.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$root"
mkdir -p pond/bin
export RYE_ZIG="${RYE_ZIG:-$root/vendor/zig-toolchain/zig}"
exec sh tools/fixtures/r/rye_build.sh pond/apps/drawn_terminal.rye brushstroke/xdg-shell-protocol.c \
  -Ibrushstroke -lc -lwayland-client -lxkbcommon -lrt \
  -femit-bin=pond/bin/drawn-terminal
