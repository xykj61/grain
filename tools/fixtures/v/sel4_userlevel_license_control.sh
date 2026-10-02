#!/bin/sh
# tools/fixtures/v/sel4_userlevel_license_control.sh -- prove the SPDX census actually counts a
# planted violation, both directions, in a pen that never touches the real vendored trees.
#
# WHAT THIS DOES. tools/s/sel4_userlevel_license_witness.rish asserts four literal counts read
# from tools/fixtures/v/vendored_license_scan.sh's own output against the real vendor/sel4 and
# vendor/microkit gitlinks -- 185 libsel4 files, 618 kernel GPL tags, 303 Microkit BSD-2-Clause
# files, zero Microkit GPL tags outside custom_dts. Those numbers are real and cannot be planted
# against without mutating a vendored submodule, which this control refuses to do. What it proves
# instead is that the SCAN's own counting logic -- the grep walk every one of those four asserts
# depends on -- actually flags a GPL-tagged file where the witness expects a clean read, and stays
# quiet where the real tree already is. The redleg scan counts this witness as demonstrating no
# refusal of its own, because its asserts compare the scan's output to a fixed number rather than
# to a planted case; this control supplies the planted case the field withholds.
#
# THE PEN IS ENTERED, never addressed from outside. The scan finds its own root by walking upward
# from its own path looking for rishi/bin and tools/fixtures, so copying the tracked scan into a
# pen that also carries those two directories makes the pen its own root -- the real tree is never
# read, and no real vendor/ byte moves.
#
# USAGE
#   sh tools/fixtures/v/sel4_userlevel_license_control.sh
#
# Run from the repository root.
set -eu

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/v/vendored_license_scan.sh"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/sel4_userlevel_license_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT

behaviors=0
failed=0

check() { # check <name> <expected> <actual>
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then
    echo "  ok   $1"
  else
    echo "  FAIL $1 -- wanted [$2] got [$3]"
    failed=$((failed + 1))
  fi
}

field() { # field <key> <scan-output> ; echoes the value after key=
  printf '%s\n' "$2" | grep "^$1=" | head -1 | sed "s/^$1=//"
}

mkpen() {
  rm -rf "$PEN"
  mkdir -p "$PEN/rishi/bin" "$PEN/tools/fixtures/v"
  cp "$SCAN" "$PEN/tools/fixtures/v/vendored_license_scan.sh"
  chmod +x "$PEN/tools/fixtures/v/vendored_license_scan.sh"
  mkdir -p "$PEN/vendor/sel4/libsel4" "$PEN/vendor/sel4/src" "$PEN/vendor/sel4/include" \
           "$PEN/vendor/microkit/custom_dts"
  printf '/* SPDX-License-Identifier: BSD-2-Clause */\n' > "$PEN/vendor/sel4/libsel4/clean.h"
  printf '/* SPDX-License-Identifier: GPL-2.0 */\n' > "$PEN/vendor/sel4/src/kernel.c"
  printf '/* SPDX-License-Identifier: BSD-2-Clause */\n' > "$PEN/vendor/microkit/clean.c"
  printf '/* SPDX-License-Identifier: GPL-2.0 */\n' > "$PEN/vendor/microkit/custom_dts/overlay.dts"
}

run_scan() { ( cd "$PEN" && sh tools/fixtures/v/vendored_license_scan.sh ); }

echo "sel4_userlevel_license_control: planted violation"

# -- 1. a clean pen reads exactly the shape the witness expects ---------------------------------
mkpen
out=$(run_scan)
check "clean libsel4_files" "1" "$(field libsel4_files "$out")"
check "clean libsel4_tagged" "1" "$(field libsel4_tagged "$out")"
check "clean libsel4_bsd2" "1" "$(field libsel4_bsd2 "$out")"
check "clean libsel4_gpl" "0" "$(field libsel4_gpl "$out")"
check "clean kernel_gpl" "1" "$(field kernel_gpl "$out")"
check "clean microkit_bsd2" "1" "$(field microkit_bsd2 "$out")"
check "clean microkit_gpl_outside_dts" "0" "$(field microkit_gpl_outside_dts "$out")"

# -- 2. a GPL file planted inside libsel4 must flip the claim the witness asserts on -------------
printf '/* SPDX-License-Identifier: GPL-2.0 */\n' > "$PEN/vendor/sel4/libsel4/leaked.c"
out=$(run_scan)
check "planted libsel4 GPL flips libsel4_gpl" "1" "$(field libsel4_gpl "$out")"
rm -f "$PEN/vendor/sel4/libsel4/leaked.c"

# -- 3. a GPL file planted outside custom_dts in Microkit must flip the path-bounded claim -------
printf '/* SPDX-License-Identifier: GPL-2.0 */\n' > "$PEN/vendor/microkit/stray.c"
out=$(run_scan)
check "planted Microkit GPL outside dts flips microkit_gpl_outside_dts" "1" "$(field microkit_gpl_outside_dts "$out")"
rm -f "$PEN/vendor/microkit/stray.c"

# -- 4. removing both plants returns the scan to the clean reading -- the pen is proven innocent -
out=$(run_scan)
check "innocence: libsel4_gpl returns to clean" "0" "$(field libsel4_gpl "$out")"
check "innocence: microkit_gpl_outside_dts returns to clean" "0" "$(field microkit_gpl_outside_dts "$out")"

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "verdict=control_failed"
  exit 1
fi
echo "verdict=ok"
