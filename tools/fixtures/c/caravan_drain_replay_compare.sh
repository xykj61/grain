#!/bin/sh
# tools/fixtures/c/caravan_drain_replay_compare.sh -- two region snapshots, compared byte for byte.
#
# The replayable-drain law's comparator (the optimization spine, move three, from
# active-designing/20260826-021136_caravan-rearchitected-the-optimization-spine.md): the same
# submissions in the same order leave the same dependents in the same state. State here is the
# region store files a queue run leaves on disk -- head and tail indices plus every slot's
# addressed, sequence-numbered bytes. This fixture holds the whole comparison in one body so the
# witness's honest pass and its tampered refusal read the same code, and a bypass cannot hide
# between two spellings of the check.
#
# Three readings, in order: the two snapshot sets hold the same file names (a state file present
# in one run and absent in the other is a difference before any byte is read); the sets are
# non-empty (a comparison over nothing proves nothing); and every pair is byte-identical by cmp.
#
# Portable on purpose: POSIX sh, no GNU-only flags (the BSD dialect family, REDS %249, %250, %275).
#
#   sh tools/fixtures/c/caravan_drain_replay_compare.sh DIR_A DIR_B
#
# Prints regions_compared and verdict=identical (exit 0) or verdict=differs plus the first
# difference by name (exit 1); a misuse exits 2 so a typo never reads as a clean replay.

a=$1
b=$2
if [ -z "$a" ] || [ -z "$b" ] || [ ! -d "$a" ] || [ ! -d "$b" ]; then
  echo "usage: sh tools/fixtures/c/caravan_drain_replay_compare.sh DIR_A DIR_B (both existing)"
  exit 2
fi

work=$(mktemp -d) || exit 2
trap 'rm -rf "$work"' EXIT

( cd "$a" && ls ) | sort > "$work/set_a"
( cd "$b" && ls ) | sort > "$work/set_b"

if ! cmp -s "$work/set_a" "$work/set_b"; then
  echo "regions_compared=0"
  echo "detail: the two runs left different state-file sets"
  echo "verdict=differs"
  exit 1
fi

count=$(wc -l < "$work/set_a" | tr -d ' ')
if [ "$count" -eq 0 ]; then
  echo "regions_compared=0"
  echo "detail: no state files to compare -- an empty comparison proves nothing"
  echo "verdict=differs"
  exit 1
fi

while IFS= read -r name; do
  if ! cmp -s "$a/$name" "$b/$name"; then
    echo "regions_compared=$count"
    echo "detail: $name differs between the two runs"
    echo "verdict=differs"
    exit 1
  fi
done < "$work/set_a"

echo "regions_compared=$count"
echo "verdict=identical"
exit 0
