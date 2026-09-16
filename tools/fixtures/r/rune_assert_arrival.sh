#!/bin/sh
# tools/fixtures/r/rune_assert_arrival.sh -- which commit raised the unnamed-assert population.
# Orchestrated by tools/r/rune_assert_arrival_witness.rish.
#
#   sh tools/fixtures/r/rune_assert_arrival.sh <old-ref> [<new-ref>]
#
# WHY THIS EXISTS. `rune_assert_sweep_scan.sh` holds three ratchets over a population of eight
# hundred files. When one stands over its ceiling the refusal names a number and no arrival: the
# red lists the heaviest twenty files by STANDING count, and a file that arrived carrying one
# unnamed assert is never among them. REDS %752 is that shape, and closing it honestly took a hand
# thirty-two tree extractions and a reimplementation of the scan's own awk. This turns that into
# one command, and it reads through the scan rather than beside it.
#
# ONE RULER, ON PURPOSE. Every historical tree is measured with THIS checkout's scan rather than
# with the scan each commit carried. A predicate that changed mid-window would otherwise show up as
# an arrival in every file at once, which is a reading about the instrument wearing the clothes of
# a reading about the tree. When the predicate itself is what moved, that is the answer a hand
# wants stated plainly rather than spread across the population.
#
# WHAT IT SKIPS, and why that is the whole speed. A commit touching no `.rye` source under the
# roster cannot move any of the three counts, so it is never extracted. Measured on the %752
# window `20260916`: 32 commits, 2 of them touching Rye, so 30 extractions never happen and the
# walk finishes in seconds rather than minutes.
#
# BOUNDED. At most `max_commits` commits between the two refs, refused by name rather than walked;
# a window wider than that is a question for `git log` rather than for this. The pen is released on
# every exit path by trap, including a refusal -- REDS %745 is what nineteen witnesses without one
# cost the pier.
#
# WHAT IS NOT PROVEN. That an arrival is WRONG. A lane may add an assert it means to name on the
# next touch, and a ratchet is a ratchet on purpose. This says which commit and which file, and
# stops. Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu

max_commits=256
scan="tools/fixtures/r/rune_assert_sweep_scan.sh"
rooms_file="tools/fixtures/t/tame_style_rooms.txt"

if [ $# -lt 1 ]; then
  echo "detail: usage -- sh $0 <old-ref> [<new-ref>]"
  echo "verdict=unread"
  exit 2
fi
old_ref="$1"
new_ref="${2:-HEAD}"

for f in "$scan" "$rooms_file"; do
  if [ ! -f "$f" ]; then
    echo "detail: absent instrument ($f)"
    echo "verdict=unread"
    exit 2
  fi
done

for r in "$old_ref" "$new_ref"; do
  if ! git rev-parse --verify --quiet "$r^{commit}" > /dev/null; then
    echo "detail: unresolvable ref ($r)"
    echo "verdict=unread"
    exit 2
  fi
done

pen=$(mktemp -d "${TMPDIR:-/tmp}/rune_assert_arrival.XXXXXX")
trap 'rm -rf "$pen"' EXIT INT HUP TERM

rooms=$(grep -v '^#' "$rooms_file" | grep -v '^$')

commits=$(git rev-list --reverse "$old_ref".."$new_ref")
total=$(printf '%s\n' "$commits" | grep -c '[0-9a-f]' || true)
if [ "$total" -gt "$max_commits" ]; then
  echo "detail: window of $total commits over max_commits=$max_commits -- name a nearer old-ref"
  echo "verdict=unread"
  exit 2
fi

# A commit that touched no roster `.rye` cannot move the reading, so it is never extracted.
: > "$pen/touching"
for c in $commits; do
  if git diff-tree --no-commit-id --name-only -r "$c" | grep -qE '\.rye$'; then
    echo "$c" >> "$pen/touching"
  fi
done
touching=$(grep -c '' "$pen/touching" || true)

read_map() {
  # $1 ref, $2 output path. The tree is extracted to the roster's rooms alone; the scan and the
  # roster come from THIS checkout, so one ruler measures every tree.
  d="$pen/t"
  rm -rf "$d"
  mkdir -p "$d"
  # shellcheck disable=SC2086
  git archive "$1" -- $rooms 2>/dev/null | tar -x -C "$d" 2>/dev/null || true
  mkdir -p "$d/tools/fixtures/r" "$d/tools/fixtures/t"
  cp "$scan" "$d/$scan"
  cp "$rooms_file" "$d/$rooms_file"
  ( cd "$d" && sh "$scan" --map 2>/dev/null ) | grep -v '^map_\|^verdict' | sort > "$2"
}

echo "old_ref=$(git rev-parse --short=10 "$old_ref")"
echo "new_ref=$(git rev-parse --short=10 "$new_ref")"
echo "commits=$total touching_rye=$touching"

read_map "$old_ref" "$pen/prev"
prev_total=$(awk '{s += $2} END { print s + 0 }' "$pen/prev")
echo "old_unnamed=$prev_total"

arrivals=0
prev_ref="$old_ref"
while read -r c; do
  [ -n "$c" ] || continue
  read_map "$c" "$pen/cur"
  cur_total=$(awk '{s += $2} END { print s + 0 }' "$pen/cur")
  if [ "$cur_total" -ne "$prev_total" ]; then
    arrivals=$((arrivals + 1))
    echo "detail: arrival $(git rev-parse --short=10 "$c") $prev_total -> $cur_total -- $(git log -1 --format=%s "$c")"
    # Name every file whose own count moved, rise or fall, so a repair reads beside an arrival.
    join -a1 -a2 -e0 -o 0,1.2,2.2 "$pen/prev" "$pen/cur" \
      | awk '$2 != $3 { printf "detail:   %s %d -> %d\n", $1, $2, $3 }'
  fi
  cp "$pen/cur" "$pen/prev"
  prev_total="$cur_total"
  prev_ref="$c"
done < "$pen/touching"

echo "new_unnamed=$prev_total"
echo "arrivals=$arrivals"
echo "verdict=read"
