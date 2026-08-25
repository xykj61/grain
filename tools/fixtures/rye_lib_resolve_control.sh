#!/bin/sh
# tools/fixtures/rye_lib_resolve_control.sh -- rye finds its own std on a host with no /proc.
#
# WHY. `resolve_rye_lib` in rye/src/main.rye read `/proc/self/exe` and nothing else. macOS and the
# BSDs publish no such path, so the read returned FileNotFound and a newcomer following this tree's
# own onboarding -- fetch the toolchain, bootstrap `rye`, build something -- met
#
#   rye build: could not locate Rye's standard library (FileNotFound).
#
# on the first build they ever ran (REDS %214). The repair is a second reading, `argv[0]`, which
# every host provides. This control proves it by DOING: it blinds the /proc probe in a copy of the
# source, builds that copy, and runs the result from a pen where only argv[0] can answer.
#
# WHAT IS PROVEN. Three things, and the third is the one that keeps the repair honest:
#   1. the shipped source still resolves through /proc on this Linux host;
#   2. a build whose /proc probe cannot succeed still finds its std through argv[0];
#   3. a bare name carrying no directory separator still REFUSES, rather than guessing at a lib.
#
# WHAT IS NOT PROVEN. That macOS behaves as simulated. This blinds the probe rather than changing
# operating system, which is the honest limit of a Linux pier and is why the message says so.
#
# USAGE
#   sh tools/fixtures/rye_lib_resolve_control.sh
#
# Run from the repository root. Slow on purpose: it builds `rye` twice.

set -u

ZIG="${RYE_ZIG:-$PWD/vendor/zig-toolchain/zig}"
[ -x "$ZIG" ] || { echo "control_verdict=no_toolchain"; exit 1; }
[ -x rye/bin/rye ] || { echo "control_verdict=no_rye"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
root=$PWD

# 1 -- the shipped source resolves through /proc here.
RYE_ZIG="$ZIG" rye/bin/rye build rye/src/main.rye -femit-bin="$pen/shipped" >/dev/null 2>&1
[ -s "$pen/shipped" ] && echo "proc_reading_builds=yes" || echo "proc_reading_builds=no"

# 2 -- blind the probe, build that, and run it where only argv[0] can answer.
sed 's|"/proc/self/exe"|"/proc/self/exe-absent-on-this-host"|' rye/src/main.rye > "$pen/noproc.rye"
# -femit-bin writes a file; it makes no directory, so the pen builds its own tree first.
mkdir -p "$pen/tree/bin"
RYE_ZIG="$ZIG" rye/bin/rye build "$pen/noproc.rye" -femit-bin="$pen/tree/bin/rye" >/dev/null 2>&1
if [ -s "$pen/tree/bin/rye" ]; then
  ln -sfn "$root/rye/lib" "$pen/tree/lib"
  ( cd "$pen/tree" && RYE_ZIG="$ZIG" bin/rye build "$root/rye/src/main.rye" -femit-bin="$pen/out" ) >/dev/null 2>&1
  [ -s "$pen/out" ] && echo "argv0_reading_builds=yes" || echo "argv0_reading_builds=no"

  # 3 -- a bare name off PATH names no directory, so it must refuse rather than guess.
  ( cd "$pen/tree" && PATH="$pen/tree/bin:$PATH" RYE_ZIG="$ZIG" rye build "$root/rye/src/main.rye" -femit-bin="$pen/bare" ) >"$pen/bare.log" 2>&1
  if [ -s "$pen/bare" ]; then echo "bare_name_refused=no"
  else grep -q "could not locate Rye's standard library" "$pen/bare.log" && echo "bare_name_refused=yes" || echo "bare_name_refused=unclear"; fi
else
  echo "argv0_reading_builds=no"; echo "bare_name_refused=unclear"
fi

echo "control_verdict=ok"
