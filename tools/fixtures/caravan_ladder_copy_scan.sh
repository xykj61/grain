#!/bin/sh
# caravan_ladder_copy_scan.sh -- how many lines of the Caravan ladder are still a
# byte-identical copy of a check that already stands in a rung below it.
#
# Every rung of the Caravan arc imports the implementation of the rung beneath it.
# For eighty-odd rungs it also carried a fresh copy of that rung's self-test,
# because a check function was private and a later rung had no way to call the one
# below it. Measured rather than recalled, that reached 779 copied bodies over
# 54,612 lines, growing about 4,383 lines a rung.
#
# On Keaton's word the ladder folded (the 20260820.131713 design call, option A):
# every check is public now, and a rung whose check is byte-for-byte the rung
# below's runs it there. 523 bodies folded that way and the carry fell to 12,035.
#
# Three rungs later the carry stood at 17,997, and Keaton's word opened option B:
# caravan/ladder_checks.rye, the harness a rung hands itself to. A lifted check
# takes the rung as a comptime parameter and reaches every helper through it, so
# one body runs against whichever rung handed itself in -- its own report, its own
# helpers, its own wire. That answers both residues option A had to leave home:
# a check reaching the wire now measures the wire of the rung that called it, and
# a chain re-enters the rung at every link rather than ending in the rung below.
# 57 bodies lift, and the carry falls to 1,952 -- a ninth of what stood before it.
#
# Measurement beats memory: a count carried forward drifts (REDS %93), and a
# count that cannot see what it measures is a guess wearing a measurement's
# clothes (REDS %97). Both failure shapes are refused by name below.
#
# CARAVAN_LADDER_COPY_CEILING (default 4000): how many carried lines the ladder
# may hold. What remains carried is the three-line call each rung keeps where a
# hundred lines of copy stood, so a new rung adds roughly four lines per lifted
# check it climbs to, plus whatever its own new checks carry until they are
# lifted in turn -- call it five hundred a rung until the next rung measures it.
# 4,000 is about four rungs of headroom above the standing of 1,952, close enough
# that the number still means something on the lap it moves.
#
# CARAVAN_LADDER_DIR (default caravan): the directory of rung modules, so the
# PASS and FAIL fixtures can prove both paths without touching the tree.
set -eu

CEILING=${CARAVAN_LADDER_COPY_CEILING:-4000}
DIR=${CARAVAN_LADDER_DIR:-caravan}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

modules=0
for f in "$DIR"/*.rye; do
  test -f "$f" || continue
  modules=$((modules + 1))
  mod=$(basename "$f" .rye)
  # A check body opens on `fn check_<name>(` or `pub fn check_<name>(` at column
  # zero -- public since the fold -- and closes on the first bare `}` there.
  awk -v dir="$work" -v mod="$mod" '
    /^(pub )?fn check_[a-z0-9_]*\(/ {
      name = ($1 == "pub") ? $3 : $2
      sub(/\(.*/, "", name); inb = 1; body = ""; n = 0
    }
    inb { body = body $0 "\n"; n++ }
    inb && /^}$/ {
      out = dir "/" mod "@" name
      printf "%s", body > out
      close(out)
      printf "%s\n", n > (dir "/lines@" mod "@" name)
      close(dir "/lines@" mod "@" name)
      inb = 0
    }
  ' "$f"
done

if [ "$modules" -eq 0 ]; then
  echo "LADDER_COPY_BAD no rung modules found under ${DIR}"
  echo "LADDER_COPY_FAIL reason=no_modules dir=${DIR}"
  exit 1
fi

checks=0
for b in "$work"/*@*; do
  case "$b" in
    "$work"/lines@*) continue ;;
    "$work"/'*@*') break ;;
  esac
  checks=$((checks + 1))
done

if [ "$checks" -eq 0 ]; then
  echo "LADDER_COPY_BAD ${modules} modules hold no check functions at all"
  echo "LADDER_COPY_FAIL reason=no_checks dir=${DIR} modules=${modules}"
  exit 1
fi

# Hash every body, then count each body past the first as a copy. The first
# occurrence is the check earning its keep; every one after it is a line the
# ladder carries because a private function cannot be called from above.
for b in "$work"/*@*; do
  case "$b" in "$work"/lines@*) continue ;; esac
  name=$(basename "$b")
  n=$(cat "$work/lines@$name")
  printf '%s %s %s\n' "$(md5sum < "$b" | cut -d' ' -f1)" "$n" "$name"
done | sort > "$work/hashed"

summary=$(awk '
  { seen[$1]++; total += $2
    if (seen[$1] > 1) { copies++; copied += $2 } }
  END { printf "%d %d %d %d %d", NR, total, copies + 0, copied + 0, NR - (copies + 0) }
' "$work/hashed")

bodies=$(echo "$summary" | cut -d' ' -f1)
body_lines=$(echo "$summary" | cut -d' ' -f2)
copies=$(echo "$summary" | cut -d' ' -f3)
copied_lines=$(echo "$summary" | cut -d' ' -f4)
distinct=$(echo "$summary" | cut -d' ' -f5)

echo "LADDER_MODULES ${modules}"
echo "LADDER_CHECKS ${bodies} distinct=${distinct} copies=${copies}"
echo "LADDER_LINES check_lines=${body_lines} copied_lines=${copied_lines}"

if [ "$copied_lines" -gt "$CEILING" ]; then
  echo "LADDER_COPY_BAD copied_lines=${copied_lines} stands past ceiling=${CEILING}"
  echo "LADDER_COPY_FAIL reason=past_ceiling copied_lines=${copied_lines} ceiling=${CEILING}"
  exit 1
fi

echo "LADDER_COPY_OK copied_lines=${copied_lines} ceiling=${CEILING} modules=${modules} checks=${bodies}"
