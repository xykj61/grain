#!/bin/sh
# tools/fixtures/foundations_link_scan.sh -- every link a reader clicks in the why-room lands.
#
# WHY. `foundations/` is the most Lindy-exposed room this tree owns after the front door: it is
# read first, cited most, and meant to still read true years from now. It is also the room whose
# files are ALL stamp-named -- and the tree's own living/dated test reads a stamp-named basename as
# testimony, which is exactly right for a session log and exactly wrong for a living foundation.
#
# So when five rooms folded to `date/YYYYMMDD/` and six essays graduated into `foundations/` on
# `20260821`, the repointer walked past this whole room by rule, and no meter saw it: the resolver's
# census counts a stale reference as RECOVERABLE (an agent can find it), and `living_docs_lint`'s
# link duty never walks `foundations/` at all. Thirty-eight links broke across twenty-four living
# files, including step 2 of the compass rose itself -- the tree's own navigation hub pointing at a
# path that no longer existed (REDS %124).
#
# A reader clicking a link has no resolver. So the check is the reader's click, asked mechanically.
#
# WHAT IS CHECKED. Every relative Markdown link target `](path)` in every `.md` under the room
# resolves to something that exists on disk, from the citing file's own directory. An anchor is
# trimmed before the check, since `file.md#section` is a claim about `file.md`.
#
# WHAT IS NOT CHECKED. Whether the anchor names a real heading, whether an http link answers, and
# whether a backticked path in prose is current -- this proves the clickable surface, no more.
#
# USAGE
#   sh tools/fixtures/foundations_link_scan.sh [room]      # room defaults to foundations
#
# Driven by tools/foundations_link_witness.rish. Run from the repository root.

set -eu

room="${1:-foundations}"

# Bounds, named at the edge: a why-room that outgrows these wants a fold, not a bigger number.
max_files=512
max_links=8192

links=0
broken=0
: > /tmp/fls_bad.txt

# The file bound is checked before the walk, never inside it: the walk's own output is redirected
# to a file, so a refusal printed from within it would land in the temp file and never reach a
# reader. A refusal nobody can see is worse than an absent one.
files=$(find "$room" -name '*.md' -type f | wc -l)
if [ "$files" -gt "$max_files" ]; then
  echo "room=$room"
  echo "files_read=$files"
  echo "verdict=too_many_files"
  exit 1
fi

for f in $(find "$room" -name '*.md' -type f | sort); do
  dir=$(dirname "$f")

  # Markdown link targets only -- what a reader can actually click.
  grep -oE '\]\([^)]+\)' "$f" 2>/dev/null | sed -E 's/^\]\(//; s/\)$//' | while read -r target; do
    case "$target" in
      http:*|https:*|mailto:*|'#'*|'') continue ;;
    esac
    printf '%s\t%s\n' "$dir" "${target%%#*}"
  done
done > /tmp/fls_links.txt

while IFS="$(printf '\t')" read -r dir target; do
  [ -n "$target" ] || continue
  links=$((links + 1))
  if [ "$links" -gt "$max_links" ]; then
    echo "verdict=too_many_links"
    exit 1
  fi
  if [ ! -e "$dir/$target" ]; then
    echo "$dir -> $target" >> /tmp/fls_bad.txt
    broken=$((broken + 1))
  fi
done < /tmp/fls_links.txt

echo "room=$room"
echo "files_read=$files"
echo "links_read=$links"
echo "links_broken=$broken"
if [ "$broken" -gt 0 ]; then sed 's/^/broken: /' /tmp/fls_bad.txt; fi
rm -f /tmp/fls_bad.txt /tmp/fls_links.txt

if [ "$broken" -eq 0 ]; then echo "verdict=ok"; exit 0; fi
echo "verdict=broken_link"
exit 1
