#!/bin/sh
# tools/fixtures/d/dayshelf_real_shelf_scan.sh -- run the day-shelf merge driver over a REAL shelf.
#
# WHY. tools/fixtures/d/dayshelf_merge_control.sh builds miniature shelves in a pen, so its header
# prose, column widths and row counts are this scan's own invention. The live shelves are the
# shape the driver actually meets: a real header, a real table, and up to a hundred and thirty rows
# in one day. This reads the newest live shelf, merges it with itself in a throwaway pen, and asks
# whether it comes back byte for byte -- the idempotence a merge armed on every pull has to have.
#
# USAGE
#   sh tools/fixtures/d/dayshelf_real_shelf_scan.sh
#
# Driven by tools/d/dayshelf_merge_witness.rish. Run from the repository root. Reads the tree and
# writes only inside its own pen.

set -u

driver=tools/d/dayshelf_merge.sh
[ -f "$driver" ] || { echo "verdict=driver_missing"; exit 1; }

live=$(ls session-logs/date/README-index-2*.md 2>/dev/null | LC_ALL=C sort | tail -1)
[ -n "${live:-}" ] && [ -f "$live" ] || { echo "verdict=no_live_shelf"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

cp "$live" "$pen/A"; cp "$live" "$pen/B"; cp "$live" "$pen/O"
sh "$driver" "$pen/O" "$pen/A" "$pen/B" "$live" >/dev/null 2>&1 || { echo "verdict=driver_refused"; exit 1; }

echo "shelf=$live"
echo "rows=$(grep -c '^| `2' "$pen/A")"
if cmp -s "$pen/A" "$live"; then
  echo "real_shelf_unchanged=yes"
  echo "verdict=ok"
else
  echo "real_shelf_unchanged=no"
  echo "verdict=real_shelf_moved"
  exit 1
fi
