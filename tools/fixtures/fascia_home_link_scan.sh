#!/bin/sh
# tools/fixtures/fascia_home_link_scan.sh -- how many room READMEs offer no path back home.
#
# WHY. A reader arrives at a room's README from a search engine, a link, or a GitHub file listing,
# rather than by walking down from the root. If that page names no way back to `README.md`, the
# reader's only route home is editing the URL, and most will not. Measured `20260825.004500`:
# 109 of 115 room READMEs had no link home, including `rye/README.md` and `rishi/README.md` --
# the two pages the tree's own first-hour tutorial sends a newcomer to.
#
# WHAT COUNTS. A tracked `*/README.md` outside the vendored and projected rooms, which are somebody
# else's pages or a generated copy. A page has a path home when it links `../README.md` at whatever
# depth it sits -- `](../README.md)`, `](../../README.md)`, and so on. The root `README.md` is not
# counted, since it IS home.
#
# WHAT THIS DOES NOT READ. Whether the link is placed where a reader will find it, and whether the
# page is worth arriving at. A link in a header is worth more than one in a footnote, and no scan
# can tell them apart. This counts the edge and stops.
#
# USAGE
#   sh tools/fixtures/fascia_home_link_scan.sh          # count
#   sh tools/fixtures/fascia_home_link_scan.sh --list   # name every page with no path home
#
# Run from the repository root.

set -u

mode="${1:-count}"
total=0
orphan=0

for f in $(git ls-files "*/README.md" 2>/dev/null | grep -vE "^(vendor|gratitude|seed)/"); do
  total=$((total + 1))
  if grep -qE '\]\((\.\./)+README\.md\)' "$f"; then
    :
  else
    orphan=$((orphan + 1))
    [ "$mode" = "--list" ] && echo "no_path_home $f"
  fi
done

# The ceiling only falls. Lower it whenever a lap weaves a room home; never raise it.
# 108 measured `20260825.004500`, after rye/ and rishi/ were woven in the same lap.
CEILING=108
if [ "$orphan" -le "$CEILING" ]; then under=yes; else under=no; fi

echo "FASCIA_HOME total=$total with_path_home=$((total - orphan)) no_path_home=$orphan ceiling=$CEILING under_ceiling=$under"
