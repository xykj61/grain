#!/bin/sh
# rye/bootstrap.sh — build the `rye` command for the first time, from Rye source.
#
# Rye is written in Rye (`src/main.rye`). Once any `rye` binary exists, Rye builds
# itself with `rye build`; this script is the cold start, for when none does yet.
# It bridges the `.rye` source to `.zig` exactly as `rye build` does — because the
# toolchain's front-end reads only the `.zig` extension — and hands that to the
# pinned toolchain, pointed at Rye's own standard library with --zig-lib-dir.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
cd "$here"

# The toolchain: honor a pre-set RYE_ZIG, else the vendored Zig 0.16.0 beside us.
zig="${RYE_ZIG:-../vendor/zig-toolchain/zig}"

# Bridge the source, and clear the bridge away on the way out whatever happens.
bridge="src/main.rye.zig"
cp src/main.rye "$bridge"
trap 'rm -f "$bridge"' EXIT

mkdir -p bin
"$zig" build-exe "$bridge" -femit-bin=bin/rye --zig-lib-dir lib

echo "bootstrapped: $here/bin/rye"
./bin/rye version
