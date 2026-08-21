#!/bin/sh
# caravan_ladder_spine_scan.sh -- how many lines of the Caravan ladder's own
# orchestration spine are a line the ladder has already written somewhere else.
#
# Every rung of the Caravan arc runs the whole correspondence in order --
# `close_the_quarrel`, which carries a position, hears a finding, answers it,
# takes a matter up again, walls it, calls a person, and books what is owed.
# Until fold D each rung wrote that order out by hand: a rung born from the rung
# beneath it copied its neighbor's whole function and inserted one step, so the
# spine grew about three lines a rung -- one `try`, one `// invariant:` line, one
# assert.
#
# The copy meter beside this one (caravan_ladder_copy_scan.sh) counts
# BYTE-IDENTICAL bodies, and by that measure the spine cost nothing at all --
# no two rungs held the same `close_the_quarrel`, because each was the rung
# below's plus three lines. The claim was always honest; the shape it cannot
# see is a NEAR copy, which is what a staircase is. So the spine rode free past
# a meter reading 47.
#
# Measured here on `20260820.204641` rather than recalled, that spine was 106
# distinct lines standing on disk 1,003 times across 21 rungs -- 897 of them
# lines the ladder had already written. Naming the number is what turned a hunch
# about duplication into a design call resting on a count (REDS %93: a tally
# repeated from memory drifts; REDS %97: a count that cannot see what it measures
# is a guess wearing a measurement's clothes).
#
# Fold D moved it. The spine lives in `caravan/ladder_checks.rye` now, one body
# taking the rung as a `comptime` parameter and running the steps that rung
# declares, so the staircase is a property the harness derives rather than
# twenty-one hand-copies of it. **The carry reads 0 across 101 modules**, and
# this scan's job changed with it: it stopped sizing a cost and became the wall
# that keeps the fold folded. What it counts is unchanged -- only the number did.
#
# The scan also reports, as an ADVISORY ratchet rather than a refusal, how many
# rungs hold a spine past TAME's seventy-line function bound. TAME names that a
# ratchet -- it prints and migrates on touch -- so this scan prints it and lets
# the ceiling below be the only wall.
#
# CARAVAN_SPINE_CEILING (default 40): how many carried spine lines the ladder
# may hold. Zero stand today. Fold D on `20260820.212419` lifted the spine into
# `ladder_checks.rye`, where one body serves every rung, so the ceiling stopped
# being headroom for growth and became a wall that keeps the fold folded. It is
# set to catch the SECOND rung that writes a spine of its own rather than the
# tenth -- roughly twice the length of the one spine now standing.
#
# CARAVAN_SPINE_FN (default close_the_quarrel): the orchestration function to
# read, so a corpus small enough to count by hand can prove the counter.
#
# CARAVAN_SPINE_BOUND (default 70): TAME's function-length ratchet, reported.
#
# CARAVAN_LADDER_DIR (default caravan): the directory of rung modules, so the
# PASS and FAIL fixtures prove both paths without touching the tree.
set -eu

CEILING=${CARAVAN_SPINE_CEILING:-40}
BOUND=${CARAVAN_SPINE_BOUND:-70}
FN=${CARAVAN_SPINE_FN:-close_the_quarrel}
DIR=${CARAVAN_LADDER_DIR:-caravan}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

modules=0
for f in "$DIR"/*.rye; do
  test -f "$f" || continue
  modules=$((modules + 1))
  mod=$(basename "$f" .rye)
  # A spine opens on `fn <name>(` or `pub fn <name>(` at column zero and closes
  # on the first bare `}` there -- the same shape the copy scan reads a check by.
  awk -v out="$work/spine@$mod" -v fn="$FN" '
    $0 ~ "^(pub )?fn " fn "\\(" { inb = 1 }
    inb { print > out }
    inb && /^}$/ { inb = 0 }
  ' "$f"
done

if [ "$modules" -eq 0 ]; then
  echo "SPINE_BAD no rung modules found under ${DIR}"
  echo "SPINE_FAIL reason=no_modules dir=${DIR}"
  exit 1
fi

holding=0
for s in "$work"/spine@*; do
  test -f "$s" || continue
  holding=$((holding + 1))
done

if [ "$holding" -eq 0 ]; then
  echo "SPINE_BAD ${modules} modules hold no ${FN} at all"
  echo "SPINE_FAIL reason=no_spine dir=${DIR} fn=${FN} modules=${modules}"
  exit 1
fi

# Total is every spine line the ladder writes; distinct is how many different
# lines those are. What stands between them is the carry: a line already written
# somewhere on this ladder and written again here.
total=$(cat "$work"/spine@* | wc -l | tr -d ' ')
distinct=$(cat "$work"/spine@* | sort -u | wc -l | tr -d ' ')
carried=$((total - distinct))

# The longest spine, and how many stand past TAME's function bound. Advisory:
# TAME names function length a ratchet that turns on touch, never a gate.
longest_name=""
longest=0
over=0
for s in "$work"/spine@*; do
  n=$(wc -l < "$s" | tr -d ' ')
  if [ "$n" -gt "$BOUND" ]; then over=$((over + 1)); fi
  if [ "$n" -gt "$longest" ]; then
    longest=$n
    longest_name=$(basename "$s" | sed 's/^spine@//')
  fi
done

# The second reading. The count above asks how many different lines the whole
# ladder holds; this one walks the ladder rung by rung and asks of each spine how
# many of its lines already stand in the spine directly beneath it. Two different
# questions, and a number that survives both is one a design call may rest on
# (REDS %93). The walk orders rungs by spine length, which IS the ladder order
# here: a rung's spine is the rung below's plus its own step, so the staircase
# only ever climbs.
for s in "$work"/spine@*; do
  printf '%s %s\n' "$(wc -l < "$s" | tr -d ' ')" "$s"
done | sort -n | cut -d' ' -f2 > "$work/order"

neighbor=0
prev=""
while read -r s; do
  if [ -n "$prev" ]; then
    sort "$prev" > "$work/a"
    sort "$s" > "$work/b"
    same=$(comm -12 "$work/a" "$work/b" | wc -l | tr -d ' ')
    neighbor=$((neighbor + same))
  fi
  prev=$s
done < "$work/order"

echo "SPINE_MODULES ${modules} holding=${holding} fn=${FN}"
echo "SPINE_LINES total=${total} distinct=${distinct} carried=${carried}"
echo "SPINE_NEIGHBOR carried=${neighbor}"
echo "SPINE_RATCHET over_bound=${over} bound=${BOUND} longest=${longest_name}:${longest}"

if [ "$carried" -gt "$CEILING" ]; then
  echo "SPINE_BAD carried=${carried} stands past ceiling=${CEILING}"
  echo "SPINE_FAIL reason=past_ceiling carried=${carried} ceiling=${CEILING}"
  exit 1
fi

echo "SPINE_OK carried=${carried} ceiling=${CEILING} modules=${modules} holding=${holding}"
