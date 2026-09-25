#!/bin/sh
# tools/fixtures/g/glow_refusal_mutation_control.sh -- the Glow refusal record's witness, shown
# refusing.
#
# WHY. `tools/g/glow_refusal_witness.rish` proves sixteen legs of `glow/refusal_witness.rye`, and
# every one of them proves the record is BUILT. None showed the witness refusing, so
# `standing_equipment_redleg` counted that guard among those rostered with no refusal of their own
# -- and it is right to: a guard proven only in the passing direction cannot be told from a guard
# that has stopped reading.
#
# THE PLANT, and why this one. `glow/tokens.rye` hands `scan_ident_span` its kind word from the
# caller, because ONE scanner serves the `%tag` path and the bare ident path and they differ only
# in what they were reading. Swapping "tag" for "ident" at the `%tag` call site leaves a tree that
# compiles, lexes every source identically, and lies in exactly one field of one refusal record.
# Nothing but the record's own leg can see it, which is what makes it the sharp plant rather than a
# convenient one.
#
# THE PEN copies Glow source and `tally/` together: `glow/tally_copy.rye` is a symlink into the
# second. Compiled binaries are excluded before copying, so the pen fits when the disk is tight.
#
# USAGE
#   sh tools/fixtures/g/glow_refusal_mutation_control.sh
#
# Run from the repository root. Prints `plant_found=`, `mutant_refuses=` and a verdict.

set -u

zig="vendor/zig-toolchain/zig"
root=$(pwd)

if [ ! -f glow/tokens.rye ] || [ ! -f glow/refusal_witness.rye ]; then
  echo "detail: glow/tokens.rye or glow/refusal_witness.rye is absent -- this is not the tree's root"
  echo "verdict=not_at_root"
  exit 2
fi

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM HUP

mkdir -p "$pen/glow"
if ! rsync -a --exclude='/bin/' --exclude='/.cache/' glow/ "$pen/glow/"; then
  echo "detail: the Glow source could not be copied into the pen"
  echo "verdict=pen_copy_failed"
  exit 4
fi
if ! cp -a tally "$pen/tally"; then
  echo "detail: Tally could not be copied into the pen"
  echo "verdict=pen_copy_failed"
  exit 4
fi

# The plant is named by the exact call site rather than by a line number, so a moved line reads as
# found and a REMOVED kind word reads as absent -- which is the one state that must refuse loudly.
plant='scan_ident_span(src, i + 1, "tag", slot)'
found=$(grep -c -F "$plant" "$pen/glow/tokens.rye" 2>/dev/null || true)
echo "plant_found=$found"
if [ "$found" != "1" ]; then
  echo "detail: the tag-kind call site stands $found times rather than once -- the plant names a line that has moved"
  echo "verdict=plant_absent"
  exit 3
fi

# `sed -i` is spelled differently on each pier, so the tree's own helper carries the dialect.
. tools/fixtures/s/shell_portable.sh
sed_inplace 's/scan_ident_span(src, i + 1, "tag", slot)/scan_ident_span(src, i + 1, "ident", slot)/' \
  "$pen/glow/tokens.rye"

if ! env RYE_ZIG="$root/$zig" sh tools/fixtures/r/rye_build.sh \
    "$pen/glow/refusal_witness.rye" -femit-bin="$pen/w" >/dev/null 2>&1; then
  echo "detail: the mutated witness did not compile, so the run below would prove nothing"
  echo "verdict=mutant_unbuilt"
  exit 4
fi

if "$pen/w" >/dev/null 2>&1; then
  echo "mutant_refuses=no"
  echo "detail: a lexer naming every long name 'ident' passed every leg -- the kind word is not load-bearing and the tag leg proves nothing"
  echo "verdict=mutation_survived"
  exit 1
fi

echo "mutant_refuses=yes"
echo "verdict=ok"
