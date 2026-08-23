#!/bin/sh
# Seat Zig caches under tools/.cache/zig/ (persistent, gitignored).
# Prints resolved paths; exports only affect this process and its children.
set -eu
root=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
local_dir="${ZIG_LOCAL_CACHE_DIR:-$root/tools/.cache/zig/local}"
global_dir="${ZIG_GLOBAL_CACHE_DIR:-$root/tools/.cache/zig/global}"
mkdir -p "$local_dir" "$global_dir"
export ZIG_LOCAL_CACHE_DIR="$local_dir"
export ZIG_GLOBAL_CACHE_DIR="$global_dir"
printf 'ZIG_LOCAL_CACHE_DIR=%s\n' "$ZIG_LOCAL_CACHE_DIR"
printf 'ZIG_GLOBAL_CACHE_DIR=%s\n' "$ZIG_GLOBAL_CACHE_DIR"
