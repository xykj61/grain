#!/bin/sh
# rye/bootstrap.sh -- build the `rye` command for the first time, from Rye source.
#
# Rye is written in Rye (`src/main.rye`). Once any `rye` binary exists, Rye builds
# itself with `rye build`; this script is the cold start, for when none does yet.
# It bridges the `.rye` source to `.zig` exactly as `rye build` does -- because the
# toolchain's front-end reads only the `.zig` extension -- and hands that to the
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
# Zig 0.16 requires -lc for getpid (build_lock_acquire). Linux glibc hosts
# refuse without it; Darwin accepts it. NixOS without FHS libc keeps the musl
# recipe in docs-geode/tutorials/the-first-hour.md.
# ReleaseSafe: two builds at one path give identical bytes (measured 20260918:
# sha256 a771f33cea173eca twice), where the default Debug mode differs build to
# build. ReleaseSmall is also reproducible and 20x smaller, yet strips runtime
# safety checks; TAME puts safety first, so ReleaseSafe is the mode.
# The binary still embeds this tree's absolute path, so two ships at two paths
# produce two hashes -- reproducible per tree, not yet shared across trees.
"$zig" build-exe "$bridge" -O ReleaseSafe -femit-bin=bin/rye --zig-lib-dir lib -lc

echo "bootstrapped: $here/bin/rye"
./bin/rye version
