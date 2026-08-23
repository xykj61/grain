#!/bin/sh
# tools/fixtures/vendored_license_scan.sh -- the per-file SPDX census over the vendored microkernel trees, printed as plain key=value
# lines for tools/s/sel4_userlevel_license_witness.rish to assert on. Measurement, never memory: every number here is counted from the
# files on disk at run time.
#
# Why per-file rather than per-project: seL4 splits its licensing at the kernel boundary -- GPL-2.0 kernel, BSD-2-Clause userlevel -- so
# a project-level verdict is not a licence. The obligation recorded with the license read
# (external-research/20260821-041056) was a per-file sweep at fetch time, and this is it, turned into something that runs every lap.
set -eu
cd "$(dirname "$0")/../.."

count_tag() { grep -rhoE 'SPDX-License-Identifier:[[:space:]]*[A-Za-z0-9._+-]+' "$1" 2>/dev/null | sed 's/.*: *//' | grep -cx "$2" || true; }

# --- the linkable userlevel: must be wholly permissive, and wholly tagged ---
LIBSEL4=vendor/sel4/libsel4
echo "libsel4_files=$(find $LIBSEL4 -type f 2>/dev/null | wc -l | tr -d ' ')"
echo "libsel4_tagged=$(grep -rlE 'SPDX-License-Identifier' $LIBSEL4 2>/dev/null | wc -l | tr -d ' ')"
echo "libsel4_bsd2=$(count_tag $LIBSEL4 BSD-2-Clause)"
echo "libsel4_gpl=$(grep -rhoE 'SPDX-License-Identifier:[[:space:]]*GPL[A-Za-z0-9._+-]*' $LIBSEL4 2>/dev/null | wc -l | tr -d ' ')"

# --- the kernel: the copyleft side of the boundary, counted so the split is proven to exist rather than asserted ---
echo "kernel_gpl=$(grep -rhoE 'SPDX-License-Identifier:[[:space:]]*GPL[A-Za-z0-9._+-]*' vendor/sel4/src vendor/sel4/include 2>/dev/null | wc -l | tr -d ' ')"

# --- microkit: permissive except a known, bounded set of board device-tree overlays ---
echo "microkit_bsd2=$(count_tag vendor/microkit BSD-2-Clause)"
# Every GPL-tagged path in microkit, so a NEW one outside the allowlisted overlay directory cannot hide in a count.
echo "microkit_gpl_paths=$(grep -rlE 'SPDX-License-Identifier:[[:space:]]*GPL' vendor/microkit 2>/dev/null | sed 's|^\./||' | sort | tr '\n' ',' )"
echo "microkit_gpl_outside_dts=$(grep -rlE 'SPDX-License-Identifier:[[:space:]]*GPL' vendor/microkit 2>/dev/null | sed 's|^\./||' | grep -cv '^vendor/microkit/custom_dts/' || true)"
