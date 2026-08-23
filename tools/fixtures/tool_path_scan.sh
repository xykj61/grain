#!/bin/sh
# tools/fixtures/tool_path_scan.sh -- measure a room's first-letter fold shape.
#
# WHY. The `tools/` fold rests on a claim about the room's own shape: that folding by first sprig
# letter leaves every resulting room under the 256-file bound, once the two letters that overflow
# split one letter deeper. That claim was measured once by hand on `20260823.124407`. A number
# measured once by hand is a number that starts drifting the next day, and this room gains files
# every lap -- it grew 1,891 to 1,915 in under an hour. So the claim is a program.
#
# WHAT IT MEASURES, on the flat entries of the named room only. Subdirectories are left alone,
# because the fold moves flat entries and nothing else.
#
#   flat_files          flat entries the room holds -- everything the fold moves
#   flat_regular        of those, ordinary files
#   flat_symlinks       of those, symbolic links
#   symlinks_up         symlinks whose target opens with `../` -- see the warning below
#   letters             distinct first letters among the flat entries
#   over_bound_letters  letters holding more than the bound -- these split one letter deeper
#   rooms               rooms the chosen shape produces, counting the deeper split
#   rooms_over_bound    rooms still over the bound after the split -- the gate, held at zero
#   max_room            the largest room the chosen shape produces
#   min_basename        the shortest flat basename
#   min_basename_safe   whether that minimum leaves two letters to slice -- the gate, held at yes
#   subdirs             subdirectories the room already holds
#   min_subdir_len      the shortest of their names
#   collisions          computed rooms whose name equals an existing subdirectory -- held at zero
#
# AND THE ROOM AS IT NOW STANDS, which is what the readings above stop describing the moment the
# fold lands. `tools/` folded on `20260823.144100`, so its flat count is zero and every flat
# reading with it. A gate resting on those alone would pass by having nothing left to measure.
#
#   standing_rooms            subdirectories whose name is one or two letters, or `rye` -- the
#                             rooms this fold makes, told apart from `bin`, `fixtures`, `gen`,
#                             `hooks`, and the two guest rooms, every one three characters or more
#   standing_max_room         the largest of them, by flat entries
#   standing_rooms_over_bound standing rooms over the bound -- the post-fold gate, held at zero
#   flat_shape_gate           one verdict for the flat readings: `ok` when the room has already
#                             folded and nothing flat remains, or when the three flat gates all
#                             pass; `red` otherwise. The comparison sits here, where the numbers
#                             live, so a witness reads a verdict rather than re-deriving arithmetic
#
# THE WARNING THIS SCAN EXISTS TO RAISE, and it was found by running the scan rather than by
# reading the plan. `symlinks_up` counts flat symlinks whose target opens with `../`, and a fold
# moves each of them one directory deeper. `tools/x25519.rye -> ../crypto/x25519.rye` resolves to
# `crypto/x25519.rye` today and to `tools/crypto/x25519.rye` from inside `tools/x/`, which is
# nowhere. Proven on metal `20260823.131241` by moving a planted copy of exactly that shape.
# Measured the same minute, `tools/` holds 24 of them, every one reaching into `crypto/` or
# `tally/`. `tools/tracked_link_witness.rish` gates dangling tracked symlinks at ZERO, so a fold
# that ignores this reading reds that guard the moment it lands. The fold round answers it by
# leaving these entries flat or by deepening each target one level; this scan only makes the
# number impossible to miss beforehand. It is reported rather than gated, because the entries
# stand correctly today.
#
# WHY THE COUNT IS TAKEN THIS WAY. A first pass counted with `find -type f` and read 1,892 against
# an `ls` reading of 1,916. The gap was those 24 symlinks, which `-type f` declines and a fold
# would move regardless. A scan that counts a different set than the fold moves is a scan that
# measures the wrong room, so `flat_files` counts every flat entry and the two kinds are reported
# beside it.
#
# WHY `collisions` IS A READING AND NOT AN ASSUMPTION. A fold that lands a letter room on top of
# an existing subdirectory would merge two unrelated things silently, and silence is the failure
# mode this tree pays for most often. `tools/` holds `bin`, `enrich`, `fixtures`, `gen`, `hooks`,
# and two `proven_seat_*` guests -- every one a word of three characters or more, so no one- or
# two-character room can land on one. That is true today and is checked on every run rather than
# trusted, because a subdirectory named `ca` could arrive tomorrow.
#
# USAGE
#   sh tools/fixtures/tool_path_scan.sh              # measure tools/ at the seated bound of 256
#   sh tools/fixtures/tool_path_scan.sh <room>       # measure another room
#   sh tools/fixtures/tool_path_scan.sh <room> <n>   # ... at another bound
#
# Prints `key=value` lines and nothing else, so a witness reads the scan's own output rather than
# reciting numbers from its own memory (REDS %108). Exit is non-zero only when the room is absent.
#
# Proven by tools/tool_path_witness.rish. Kin: tools/tool_path_resolve.rish (the resolver this
# shape feeds) and tools/room_bound_witness.rish (the guard that seats the 256 bound).
#
# Run from the repository root.

set -eu

room="${1:-tools}"
bound="${2:-256}"

[ -d "$room" ] || { echo "refused: no room at $room" >&2; exit 1; }

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# The flat entries of the room, basenames only. Ordinary files AND symlinks, because the fold
# moves both; counting only one kind would measure a different room than the one being folded.
find "$room" -maxdepth 1 -mindepth 1 \( -type f -o -type l \) -exec basename {} \; \
  | sort > "$work/flat"

flat_files=$(wc -l < "$work/flat" | tr -d ' ')
flat_regular=$(find "$room" -maxdepth 1 -mindepth 1 -type f | wc -l | tr -d ' ')
flat_symlinks=$(find "$room" -maxdepth 1 -mindepth 1 -type l | wc -l | tr -d ' ')

# A symlink whose target opens with `../` reaches out of the room, so moving it one level deeper
# leaves it dangling. This is the reading the fold round must answer before it moves anything.
symlinks_up=0
for link in $(find "$room" -maxdepth 1 -mindepth 1 -type l); do
  target=$(readlink "$link")
  case "$target" in
    ../*) symlinks_up=$((symlinks_up + 1)) ;;
    *) ;;
  esac
done

# One line per letter: "<count> <letter>", so the over-bound letters read straight off.
cut -c1 "$work/flat" | sort | uniq -c | awk '{print $1, $2}' > "$work/letters"
letters=$(wc -l < "$work/letters" | tr -d ' ')

over_bound_letters=0
: > "$work/rooms"

while read -r count letter; do
  if [ "$count" -gt "$bound" ]; then
    # This letter overflows, so it splits one letter deeper and each two-letter room is its own.
    over_bound_letters=$((over_bound_letters + 1))
    grep "^$letter" "$work/flat" | cut -c1-2 | sort | uniq -c \
      | awk '{print $1, $2}' >> "$work/rooms"
  else
    printf '%s %s\n' "$count" "$letter" >> "$work/rooms"
  fi
done < "$work/letters"

rooms=$(wc -l < "$work/rooms" | tr -d ' ')
rooms_over_bound=$(awk -v b="$bound" '$1 > b' "$work/rooms" | wc -l | tr -d ' ')
max_room=$(awk '{print $1}' "$work/rooms" | sort -n | tail -1)
[ -n "$max_room" ] || max_room=0

min_basename=$(awk '{print length($0)}' "$work/flat" | sort -n | head -1)
[ -n "$min_basename" ] || min_basename=0

# The two-letter slice is safe only when every basename has two letters to give. The comparison
# happens here, where the number lives, so a witness gates on a verdict rather than re-deriving
# the arithmetic -- and so the gate holds at any future minimum rather than pinning today's.
min_basename_safe=no
[ "$min_basename" -ge 2 ] && min_basename_safe=yes

# The subdirectories already standing, and whether any computed room lands on one.
find "$room" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; | sort > "$work/subdirs"
subdirs=$(wc -l < "$work/subdirs" | tr -d ' ')
min_subdir_len=$(awk '{print length($0)}' "$work/subdirs" | sort -n | head -1)
[ -n "$min_subdir_len" ] || min_subdir_len=0

awk '{print $2}' "$work/rooms" | sort > "$work/room_names"
collisions=$(comm -12 "$work/room_names" "$work/subdirs" | wc -l | tr -d ' ')

# THE ROOM AS IT NOW STANDS, which is what the readings above stop describing the moment the fold
# lands. A folded room has no flat entries, so every flat reading falls to zero and a witness
# asserting on them would pass by having nothing left to measure -- vacuous truth, the exact shape
# REDS %161 named. So the standing fold rooms are measured in their own right: a subdirectory whose
# name is one or two letters, or `rye`, is a room this fold made, and its own count is gated.
find "$room" -maxdepth 1 -mindepth 1 -type d -exec basename {} \; \
  | grep -E '^([a-z]|[a-z][a-z]|rye)$' | sort > "$work/standing" || true
standing_rooms=$(wc -l < "$work/standing" | tr -d ' ')

standing_max_room=0
standing_rooms_over_bound=0
while read -r name; do
  [ -n "$name" ] || continue
  n=$(find "$room/$name" -maxdepth 1 -mindepth 1 \( -type f -o -type l \) | wc -l | tr -d ' ')
  [ "$n" -gt "$standing_max_room" ] && standing_max_room=$n
  [ "$n" -gt "$bound" ] && standing_rooms_over_bound=$((standing_rooms_over_bound + 1))
done < "$work/standing"

# ONE VERDICT FOR THE FLAT SHAPE, decided here where the numbers live rather than re-derived by
# every caller. A room with nothing flat left has already folded, so its flat readings describe a
# question that is answered; a room that still holds flat entries must pass all three.
flat_shape_gate=red
if [ "$flat_files" -eq 0 ]; then
  flat_shape_gate=ok
elif [ "$rooms_over_bound" -eq 0 ] && [ "$collisions" -eq 0 ] && [ "$min_basename_safe" = yes ]; then
  flat_shape_gate=ok
fi

echo "room=$room"
echo "bound=$bound"
echo "flat_files=$flat_files"
echo "flat_regular=$flat_regular"
echo "flat_symlinks=$flat_symlinks"
echo "symlinks_up=$symlinks_up"
echo "letters=$letters"
echo "over_bound_letters=$over_bound_letters"
echo "rooms=$rooms"
echo "rooms_over_bound=$rooms_over_bound"
echo "max_room=$max_room"
echo "min_basename=$min_basename"
echo "min_basename_safe=$min_basename_safe"
echo "subdirs=$subdirs"
echo "min_subdir_len=$min_subdir_len"
echo "collisions=$collisions"
echo "standing_rooms=$standing_rooms"
echo "standing_max_room=$standing_max_room"
echo "standing_rooms_over_bound=$standing_rooms_over_bound"
echo "flat_shape_gate=$flat_shape_gate"
