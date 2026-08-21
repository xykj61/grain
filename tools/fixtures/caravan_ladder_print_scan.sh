#!/bin/sh
# caravan_ladder_print_scan.sh -- how many lines of the Caravan ladder's own
# printing are a line the ladder has already written somewhere else.
#
# Every rung of the Caravan arc reports what its run did, in words an operator
# reads: a `tell_` family that prints one line per tier of the correspondence,
# each naming what was carried, what was kept, and what a run left undone. A
# rung born from the rung beneath it copies that family whole and inserts its
# own tier, so the printing grows about three lines a rung -- one printed
# sentence, one field read off the report, one closing brace of the format.
#
# Two meters already stand beside this one, and neither can see that shape.
# `caravan_ladder_copy_scan.sh` reads `check_` bodies and counts BYTE-IDENTICAL
# copies; `caravan_ladder_spine_scan.sh` reads one named orchestration function,
# `close_the_quarrel`. Both claims are honest and both say so at the top. The
# printing family is simply outside the window of each: a different prefix than
# the first reads, a different function than the second names. So the printing
# rode free past both.
#
# Measured on `20260820.221349` rather than recalled, that printing was 2,468
# distinct lines standing on disk 9,317 times across 42 rungs -- 6,849 of them
# lines the ladder had already written. Naming the number is what turns a hunch
# about duplication into a design call resting on a count (REDS %93: a tally
# repeated from memory drifts; REDS %97: a count that cannot see what it
# measures is a guess wearing a measurement's clothes).
#
# The first fold off that number landed the same night. The note-writing pair --
# the path an answer is written to and the byte that tells a reader how their
# quarrel came out -- stood byte for byte in twenty-nine rungs, and both lifted
# into `caravan/ladder_checks.rye` the way a check lifts, each rung keeping a
# three-line call. The carry fell to 5,955 of 8,427, and the ceiling below fell
# with it, so the fold stays folded rather than quietly refilling.
#
# The scan reports the carry two ways on purpose, because they answer different
# questions and the answer decides what the fold should be:
#
#   PRINT_BODIES names how much of the carry is a WHOLE body standing
#   byte-for-byte in more than one rung. That part lifts into the harness
#   exactly the way a check body lifts -- 93 bodies over 3,164 lines when this
#   meter opened, and 93 bodies over 2,268 lines once the note-writing pair
#   folded, since the three-line calls a fold leaves behind are themselves a
#   body every rung writes identically.
#
#   PRINT_LINES names the carry at the line level, which also counts the
#   staircase: a body that is the rung below's plus three lines is a new body to
#   the first reading and 90-odd already-written lines to the second.
#
# CARAVAN_PRINT_CEILING (default 6900): how many carried printing lines the
# ladder may hold. 5,955 stand today, and a new rung adds roughly 450 -- so the
# ceiling still catches the SECOND rung written before the next fold lands
# rather than the tenth. It came down from 7,800 on the lap the note-writing
# pair lifted, because a ceiling left where a fold found it hands back exactly
# the room the fold just won.
#
# CARAVAN_PRINT_PREFIX (default tell_): the function-name prefix that opens the
# printing family, so a corpus small enough to count by hand can prove the
# counter.
#
# CARAVAN_PRINT_BOUND (default 70): TAME's function-length ratchet, reported.
# TAME names function length a ratchet -- it prints and migrates on touch,
# never a gate -- so this scan prints it and lets the ceiling be the only wall.
#
# CARAVAN_LADDER_DIR (default caravan): the directory of rung modules, so the
# PASS and FAIL fixtures prove both paths without touching the tree.
set -eu

CEILING=${CARAVAN_PRINT_CEILING:-6900}
BOUND=${CARAVAN_PRINT_BOUND:-70}
PREFIX=${CARAVAN_PRINT_PREFIX:-tell_}
DIR=${CARAVAN_LADDER_DIR:-caravan}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

modules=0
for f in "$DIR"/*.rye; do
  test -f "$f" || continue
  modules=$((modules + 1))
  mod=$(basename "$f" .rye)
  # A printing body opens on `fn <prefix>...(` or `pub fn <prefix>...(` at
  # column zero and closes on the first bare `}` there -- the same shape the
  # copy scan reads a check by, so the three meters agree on what a body is.
  awk -v dir="$work" -v mod="$mod" -v pre="$PREFIX" '
    $0 ~ "^(pub )?fn " pre "[a-z0-9_]*\\(" {
      name = ($1 == "pub") ? $3 : $2
      sub(/\(.*/, "", name); inb = 1; body = ""; n = 0
    }
    inb { body = body $0 "\n"; n++ }
    inb && /^}$/ {
      out = dir "/body@" mod "@" name
      printf "%s", body > out
      close(out)
      printf "%d\n", n > (dir "/len@" mod "@" name)
      close(dir "/len@" mod "@" name)
      printf "%s", body >> (dir "/rung@" mod)
      inb = 0
    }
  ' "$f"
done

if [ "$modules" -eq 0 ]; then
  echo "PRINT_BAD no rung modules found under ${DIR}"
  echo "PRINT_FAIL reason=no_modules dir=${DIR}"
  exit 1
fi

holding=0
for r in "$work"/rung@*; do
  test -f "$r" || continue
  holding=$((holding + 1))
done

if [ "$holding" -eq 0 ]; then
  echo "PRINT_BAD ${modules} modules hold no ${PREFIX} printing at all"
  echo "PRINT_FAIL reason=no_printing dir=${DIR} prefix=${PREFIX} modules=${modules}"
  exit 1
fi

# The first reading -- whole bodies. Hash each one and count each past the first
# as a copy. This is the part that lifts into the harness the way a check does.
for b in "$work"/body@*; do
  test -f "$b" || continue
  name=$(basename "$b" | sed 's/^body@//')
  printf '%s %s %s\n' "$(md5sum < "$b" | cut -d' ' -f1)" "$(cat "$work/len@$name")" "$name"
done | sort > "$work/hashed"

summary=$(awk '
  { seen[$1]++
    if (seen[$1] > 1) { copies++; copied += $2 } }
  END { printf "%d %d %d", NR, copies + 0, copied + 0 }
' "$work/hashed")

bodies=$(echo "$summary" | cut -d' ' -f1)
identical=$(echo "$summary" | cut -d' ' -f2)
identical_lines=$(echo "$summary" | cut -d' ' -f3)
body_distinct=$((bodies - identical))

# The second reading -- lines. Total is every printing line the ladder writes;
# distinct is how many different lines those are. What stands between them is
# the carry, which counts the staircase the whole-body reading cannot.
total=$(cat "$work"/rung@* | wc -l | tr -d ' ')
distinct=$(cat "$work"/rung@* | sort -u | wc -l | tr -d ' ')
carried=$((total - distinct))

# The longest printing body, and how many stand past TAME's function bound.
longest_name=""
longest=0
over=0
for b in "$work"/body@*; do
  test -f "$b" || continue
  n=$(wc -l < "$b" | tr -d ' ')
  if [ "$n" -gt "$BOUND" ]; then over=$((over + 1)); fi
  if [ "$n" -gt "$longest" ]; then
    longest=$n
    longest_name=$(basename "$b" | sed 's/^body@//')
  fi
done

# The third reading. The line count above asks how many different lines the
# whole ladder holds; this one walks the ladder rung by rung and asks of each
# rung's printing how many of its lines already stand in the printing of the
# rung directly beneath it. Two questions over one extraction, and a number that
# survives both is one a design call may rest on (REDS %93). The walk orders
# rungs by printing size, which IS the ladder order here: a rung's printing is
# the rung below's plus its own tier, so the staircase only ever climbs.
for r in "$work"/rung@*; do
  printf '%s %s\n' "$(wc -l < "$r" | tr -d ' ')" "$r"
done | sort -n | cut -d' ' -f2 > "$work/order"

neighbor=0
prev=""
while read -r r; do
  if [ -n "$prev" ]; then
    sort "$prev" > "$work/a"
    sort "$r" > "$work/b"
    same=$(comm -12 "$work/a" "$work/b" | wc -l | tr -d ' ')
    neighbor=$((neighbor + same))
  fi
  prev=$r
done < "$work/order"

echo "PRINT_MODULES ${modules} holding=${holding} prefix=${PREFIX}"
echo "PRINT_BODIES ${bodies} distinct=${body_distinct} identical=${identical} identical_lines=${identical_lines}"
echo "PRINT_LINES total=${total} distinct=${distinct} carried=${carried}"
echo "PRINT_NEIGHBOR carried=${neighbor}"
echo "PRINT_RATCHET over_bound=${over} bound=${BOUND} longest=${longest_name}:${longest}"

if [ "$carried" -gt "$CEILING" ]; then
  echo "PRINT_BAD carried=${carried} stands past ceiling=${CEILING}"
  echo "PRINT_FAIL reason=past_ceiling carried=${carried} ceiling=${CEILING}"
  exit 1
fi

echo "PRINT_OK carried=${carried} ceiling=${CEILING} modules=${modules} holding=${holding}"
