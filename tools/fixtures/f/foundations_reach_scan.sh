#!/bin/sh
# tools/fixtures/f/foundations_reach_scan.sh -- a foundation the front door never names is unheard.
#
# WHY. `tools/fixtures/f/foundations_link_scan.sh` proves every link a reader clicks OUT of this
# room lands. Nothing asked the other direction: whether a reader walking IN through
# `foundations/README.md` can reach the page at all. The two readings come apart, and this room is
# where they come apart hardest -- every foundation is stamp-named, so a page absent from the index
# has no other door: no directory listing a newcomer walks, no title a grep would guess.
#
# Measured `20260910.004858`, the aether lap: 34 of 85 foundations stand outside the room's own
# index, and 7 of them are seats of the council rota -- documents the fleet deep-reads every day,
# which the room's front door does not name. Air's fixed seat, both of Earth's, two of Water's,
# and two of Fire's. The room speaks fifteen documents a day and its door names eight of them.
#
# WHAT IS CHECKED, in two readings that are gated differently on purpose.
#   `rota_absent` -- a rota seat living in this room that `README.md` never names. Held at ZERO.
#     A document the council reads daily is the sharpest class and the smallest: the set is
#     DERIVED from the grid in `recursion-prompts/seed/autonomous-loop.seed.md` rather than typed
#     here, so a seat that changes hands is walled on the lap it moves.
#   `absent` -- every other foundation the index omits. A RATCHET under a ceiling that only falls,
#     because indexing 27 pages is a curation lap rather than a mechanical one, and a gate that
#     reds on ordinary work is a gate someone turns off.
#
# WHAT IS NOT CHECKED. Whether the index ROW says anything true, whether the page is any good, and
# whether a reader who reaches it understands it. This proves the door opens, no more.
#
# USAGE
#   sh tools/fixtures/f/foundations_reach_scan.sh [room] [index] [grid]
#
# Driven by tools/f/foundations_reach_witness.rish. Run from the repository root.

set -eu

room="${1:-foundations}"
index="${2:-$room/README.md}"
grid="${3:-recursion-prompts/seed/autonomous-loop.seed.md}"

# Bounds named at the edge: a why-room past these wants a fold rather than a bigger number.
max_files=512

# The ceiling only falls. Read `20260910.004858` at 27 -- the 34 absent, less the 7 the seating lap
# repaired. Lower it when a curation lap indexes more; never raise it.
absent_ceiling=27

if [ ! -f "$index" ]; then
  echo "room=$room"
  echo "verdict=no_index"
  exit 1
fi

# The pen is named at RUN time. Eight checkouts share one pier, so a constant name under a shared
# directory is a peer's file (REDS %549, %620).
pen=${TMPDIR:-/tmp}/frs-pen-$$
mkdir -p "$pen" || exit 2
trap 'rm -rf "$pen"' EXIT INT TERM
: > "$pen/absent"
: > "$pen/rota_absent"

files=$(find "$room" -maxdepth 1 -name '*.md' -type f | wc -l)
if [ "$files" -gt "$max_files" ]; then
  echo "room=$room"
  echo "files_read=$files"
  echo "verdict=too_many_files"
  exit 1
fi

# The rota seats, derived from the grid's own element rows rather than listed here. A seat that
# changes hands moves this set on the lap it moves, with no second copy to fall out of step.
if [ -f "$grid" ]; then
  grep -E '^\| \*\*(Aether|Air|Fire|Water|Earth) - ' "$grid" 2>/dev/null \
    | grep -oE "$room/[0-9]{8}-[0-9]{6}(_[a-z0-9-]+)?\.md" | sort -u > "$pen/seats" || : > "$pen/seats"
else
  : > "$pen/seats"
fi
seats=$(wc -l < "$pen/seats" | tr -d ' ')

read_count=0
absent=0
rota_absent=0

for f in $(find "$room" -maxdepth 1 -name '*.md' -type f | sort); do
  base=$(basename "$f")
  [ "$base" = "$(basename "$index")" ] && continue
  read_count=$((read_count + 1))
  grep -qF "$base" "$index" && continue
  if grep -qxF "$f" "$pen/seats"; then
    echo "$f" >> "$pen/rota_absent"
    rota_absent=$((rota_absent + 1))
  else
    echo "$f" >> "$pen/absent"
    absent=$((absent + 1))
  fi
done

echo "room=$room"
echo "index=$index"
echo "files_read=$read_count"
echo "rota_seats_in_room=$seats"
echo "rota_absent=$rota_absent"
echo "absent=$absent"
echo "absent_ceiling=$absent_ceiling"
if [ "$rota_absent" -gt 0 ]; then sed 's/^/rota_absent: /' "$pen/rota_absent"; fi
if [ "$absent" -gt 0 ]; then sed 's/^/absent: /' "$pen/absent"; fi

if [ "$seats" -eq 0 ]; then
  echo "verdict=no_seats_derived"
  exit 1
fi
if [ "$rota_absent" -gt 0 ]; then
  echo "verdict=rota_seat_unreachable"
  exit 1
fi
if [ "$absent" -gt "$absent_ceiling" ]; then
  echo "verdict=absent_over_ceiling"
  exit 1
fi
echo "absent_ceiling_ok=yes"
echo "verdict=ok"
exit 0
