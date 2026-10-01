#!/bin/sh
# tools/fixtures/m/mantra_snapshot_projection_scan.sh -- what does a full export
# cost against a catalog's own live shape?
#
# WHAT THIS READS. `active-designing/date/20261001/20261001-122725_a-snapshot-that-cannot-shrink-buys-nothing.md`
# found that `mantra/snapshot_export.rye`'s `export_catalog` walks every leaf a
# `BoltCatalog` ever held -- `RevisionImmutable` keeps a later revision of a
# path as a NEW leaf beside the old one, so "current state" and "full history"
# stay one object, and a snapshot costs exactly what a cold replay costs. The
# paper names a first witness: count every leaf a real export writes against
# the catalog's own count, and show a read-only projected scan -- keeping one
# entry per `(peer, bolt, path)` tuple regardless of revision count -- answers
# strictly smaller whenever a tuple carries more than one revision.
#
# `mantra/snapshot_projection.rye` builds both readings: `count_exported_leaves`
# decodes a real snapshot's own batch frames (never trusting the header's
# `leaf_count` claim a second time) and sums their declared entry counts;
# `projected_leaf_count` walks the catalog directly and counts live tuples.
# Neither function mutates `recall_lap1.rye`'s `BoltCatalog`, calls
# `export_catalog` more than the export reading already does, or writes a new
# wire format -- this is two reports over one existing shape.
#
# READINGS PRINTED, one per line, each a fact rather than a verdict:
#   source=<path>              the module this reading is about
#   built=yes|no               the module compiled
#   selftest_exit=<n>          what the selftest left
#   flat_equal=yes|no          a catalog with no repeated revisions reads the same
#                              count both ways
#   layered_strictly_smaller=yes|no   a catalog with repeated revisions reads a
#                              strictly smaller projected count than exported count
#   verdict=ok|red
#
# Takes one optional argument: the `snapshot_projection.rye` to read, so a
# future control can point this scan at a mutated copy in a pen. Default is the
# tree's own.
#
# Driven by tools/m/mantra_snapshot_projection_witness.rish. Run from the root.

set -eu

root="$(pwd)"
src="${1:-$root/mantra/snapshot_projection.rye}"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
verdict=ok
note_red() { verdict=red; }

echo "source=$src"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
bin="$work/snapshot-projection"

if env RYE_ZIG="$zig" "$rye" build "$src" -femit-bin="$bin" >"$work/build.log" 2>&1; then
  echo "built=yes"
else
  echo "built=no"; note_red
  echo "flat_equal=no"
  echo "layered_strictly_smaller=no"
  echo "verdict=red"
  exit 0
fi

out=$( "$bin" selftest 2>&1 || true )
( "$bin" selftest >/dev/null 2>&1 ) && exit_code=0 || exit_code=$?
echo "selftest_exit=$exit_code"

case "$out" in
  *"flat catalog -- exported"*"equal GREEN"*) echo "flat_equal=yes" ;;
  *) echo "flat_equal=no"; note_red ;;
esac

case "$out" in
  *"a snapshot with repeated revisions costs strictly more than its live paths GREEN"*)
    echo "layered_strictly_smaller=yes" ;;
  *) echo "layered_strictly_smaller=no"; note_red ;;
esac

echo "verdict=$verdict"
