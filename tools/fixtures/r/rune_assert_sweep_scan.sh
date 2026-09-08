#!/bin/sh
# tools/fixtures/r/rune_assert_sweep_scan.sh -- assert coverage across the TAME rooms.
# Orchestrated by tools/r/rune_assert_sweep.rish.
#
#   sh tools/fixtures/r/rune_assert_sweep_scan.sh [rooms-file]
#
# WHAT THIS READS. Every authored `.rye` under the rooms named in
# `tools/fixtures/t/tame_style_rooms.txt` -- 1,127 files, measured `20260908` -- plus the twelve
# cores the elder hand list named, which are read by name whatever the roster holds. TAME root rule
# 2 asks a function-bearing file to state its invariants: at least one `assert(`, each preceded by
# a `// invariant:` comment. This scan counts both.
#
# WHY IT DERIVES. Until `20260908` this reading was twelve file paths typed into the witness beside
# it -- 1.1 percent of the population, with the rest passing by their author's care. It is the
# fifth reader to arrive at `tame_style_rooms.txt`, after the style scan's two halves,
# `opening_lines` and `tame_check`, so a room added once reaches all five.
#
# THE ELDER TWELVE ARE NOT A SUBSET, which is why they keep a leg of their own. Five of them --
# `mandate/store.rye`, `mandate/keyed.rye`, `kumara/tilak.rye`, `settlement/constellation.rye`,
# `sundial/sundial.rye` -- sit in four rooms the roster does not name at all. Deriving alone would
# have dropped five gated files while the printed population grew a hundredfold.
#
# WHAT IS A WALL and what is a ratchet. The elder twelve keep their asserts at a ceiling of zero,
# because that is the regression guard the hand list was drawn for. The derived population is two
# ratchets under ceilings that only fall, since a wall at zero there would ask for a hundred files
# to be repaired in one lap and a wall that reds on honest work is a wall somebody turns off.
#
# WHAT COUNTS AS AN ASSERT. Any `assert(` not preceded by a word character, so a qualified
# `std.debug.assert(` counts too: the question here is whether the file states an invariant, and
# `tame_check` separately holds the qualified spelling at zero. `xassert(` is a different function
# and is left alone.
#
# CEILINGS IN A PEN ARE ZERO. A control owns its own files, so any plant in a pen is over its
# ceiling; that is what lets both ratchets be shown from the failing side without planting a
# hundred files. Output convention: context/specs/20260729-215600_scan-seam-convention.md.
set -eu

default_rooms="tools/fixtures/t/tame_style_rooms.txt"
rooms_file="${1:-$default_rooms}"
if [ ! -f "$rooms_file" ]; then
  echo "detail: absent rooms file ($rooms_file)"
  echo "verdict=unread"
  exit 2
fi

rooms=$(grep -v '^#' "$rooms_file" | grep -v '^$')
# shellcheck disable=SC2086
files=$(find $rooms -name '*.rye' ! -type l ! -path '*/.cache/*' ! -path '*/bin/*' 2>/dev/null | sort)

# THREE LIST-WIDE READINGS, never three greps per file. The first draft spawned one `grep` per
# file per question -- 3,381 processes against 1,127 sources, 19.3s of a lap pass -- and each
# question is answerable in one pass over the whole list. Diffuser measured the tax on `20260908`:
# this pier makes 1,137 processes a second standing still, so a guard's cost is mostly its forks
# rather than its bytes. Set arithmetic over three sorted lists gives the same three counts for
# six processes.
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
printf '%s\n' "$files" | grep -v '^$' | sort > "$work/all"
authored=$(grep -c '' "$work/all" || true)

if [ "$authored" -eq 0 ]; then
  fn_bearing=0
  zero_assert=0
  invariant_gap=0
  : > "$work/zero"
  : > "$work/gap"
else
  # shellcheck disable=SC2046
  grep -lE '^[[:space:]]*(pub )?fn ' $(cat "$work/all") 2>/dev/null | sort > "$work/fn" || true
  # shellcheck disable=SC2046
  grep -lE '(^|[^A-Za-z0-9_])assert\(' $(cat "$work/all") 2>/dev/null | sort > "$work/as" || true
  # shellcheck disable=SC2046
  grep -lF '// invariant:' $(cat "$work/all") 2>/dev/null | sort > "$work/inv" || true
  fn_bearing=$(grep -c '' "$work/fn" || true)
  # A function-bearing file with no assert anywhere: it states no invariant at all.
  comm -23 "$work/fn" "$work/as" > "$work/zero"
  zero_assert=$(grep -c '' "$work/zero" || true)
  # A function-bearing file that asserts and names no `// invariant:` reason above any of them.
  comm -12 "$work/fn" "$work/as" > "$work/loud"
  comm -23 "$work/loud" "$work/inv" > "$work/gap"
  invariant_gap=$(grep -c '' "$work/gap" || true)
fi

if [ "$rooms_file" = "$default_rooms" ]; then
  zero_ceiling=100
  gap_ceiling=101
else
  zero_ceiling=0
  gap_ceiling=0
fi

echo "rooms_file=$rooms_file"
echo "authored=$authored"
echo "fn_bearing=$fn_bearing"
echo "zero_assert=$zero_assert ceiling=$zero_ceiling"
echo "invariant_gap=$invariant_gap ceiling=$gap_ceiling"

# THE ELDER TWELVE, read by name. These are the cores the hand list gated, and each prints its own
# line so a regression names the file rather than moving a number. The block reads real tree paths,
# so it runs on the default roster alone; a pen run reports it absent rather than reading a tree the
# pen does not own.
elder="mandate/store.rye mandate/keyed.rye tally/seed.rye tally/gardens.rye tally/kumara.rye caravan/seed.rye caravan/bounded.rye comlink/topology.rye kumara/tilak.rye settlement/constellation.rye sundial/sundial.rye glow/expr.rye"
elder_faults=0
if [ "$rooms_file" != "$default_rooms" ]; then
  echo "elder_roster=absent -- a pen roster reads its own files"
else
  n=0
  for f in $elder; do n=$((n + 1)); done
  echo "elder_roster=$n"
  for f in $elder; do
    if [ ! -f "$f" ]; then
      echo "FAIL $f absent"
      elder_faults=$((elder_faults + 1))
      continue
    fi
    fns=$(grep -cE '^[[:space:]]*(pub )?fn ' "$f" || true)
    asserts=$(grep -cE '(^|[^A-Za-z0-9_])assert\(' "$f" || true)
    invs=$(grep -cE '// invariant:' "$f" || true)
    if [ "$fns" -gt 0 ] && [ "$asserts" -eq 0 ]; then
      echo "FAIL $f fns=$fns asserts=0"
      elder_faults=$((elder_faults + 1))
    else
      echo "OK   $f fns=$fns asserts=$asserts invariants=$invs"
    fi
  done
  echo "elder_faults=$elder_faults ceiling=0"
fi

# EVERY GUARD HERE IS AN `if`, never a `&&` tail. Under `set -e` a failing `[ ... ] && x=1` is a
# failing statement, so the scan would exit silently the first time a ratchet read UNDER its
# ceiling -- the passing case, which is the one nobody would have watched.
over=0
if [ "$zero_assert" -gt "$zero_ceiling" ]; then over=$((over + 1)); fi
if [ "$invariant_gap" -gt "$gap_ceiling" ]; then over=$((over + 1)); fi
if [ "$over" -gt 0 ]; then
  while read -r f; do echo "detail: zero_assert $f"; done < "$work/zero"
  while read -r f; do echo "detail: invariant_gap $f"; done < "$work/gap"
fi
echo "ratchets_over_ceiling=$over"
echo "verdict=read"
