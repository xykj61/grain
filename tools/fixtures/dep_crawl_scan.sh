#!/bin/sh
# tools/fixtures/dep_crawl_scan.sh -- bounded dependency BFS body.
# Orchestrated by tools/gen/season/dep_crawl.rish (tame_style_scan shape:
# Rishi holds the asserts, this seam holds the shell variables).
#
# Bounds, named before the walk:
#   MAXN 256 nodes - MAXD 16 depth -- one journey deep.
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
set -eu
root="$1"
# Bounds default to the named values and may be overridden ONLY by the negative
# fixture, so the refusal paths can be observed to fire. dep_crawl.rish asserts
# the defaults on every ordinary run, so an override cannot become the norm.
MAXN="${2:-256}"
MAXD="${3:-16}"
seen=$(mktemp); front=$(mktemp); next=$(mktemp)
trap 'rm -f "$seen" "$front" "$next"' EXIT
printf '%s\n' "$root" > "$front"
: > "$seen"
depth=0
while [ -s "$front" ]; do
  if [ "$depth" -gt "$MAXD" ]; then echo "maxd=$MAXD"; echo "verdict=bound_depth"; exit 1; fi
  : > "$next"
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    if grep -qxF "$f" "$seen" 2>/dev/null; then continue; fi
    printf '%s\n' "$f" >> "$seen"
    n=$(wc -l < "$seen" | tr -d ' ')
    if [ "$n" -gt "$MAXN" ]; then echo "maxn=$MAXN"; echo "verdict=bound_nodes"; exit 1; fi
    d=$(dirname "$f")
    grep -oE '@import\("[^"]+\.(rye|rish)"\)' "$f" 2>/dev/null \
      | sed -E 's/@import\("//; s/"\)//' \
      | while IFS= read -r imp; do printf '%s\n' "$d/$imp"; done >> "$next" || true
  done < "$front"
  sort -u "$next" > "$front"
  depth=$((depth + 1))
done
echo "maxn=$MAXN"
echo "maxd=$MAXD"
echo "verdict=ok"
echo "nodes=$(wc -l < "$seen" | tr -d ' ')"
echo "depth=$depth"
sed 's|^|detail: node |' "$seen"
