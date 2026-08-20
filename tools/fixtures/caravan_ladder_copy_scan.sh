#!/bin/sh
# caravan_ladder_copy_scan.sh -- how many lines of the Caravan ladder are a
# byte-identical copy of a check that already stands in a rung below it.
#
# Every rung of the Caravan arc imports the implementation of the rung beneath
# it and then carries a fresh copy of that rung's self-test. The imports are
# real reuse; the checks are not. A rung's `fn check_heed()` is the same bytes
# in `suffice.rye`, `apprise.rye`, and `reopen.rye`, because the check functions
# are private and a later rung has no way to call them.
#
# That is honest accumulated self-test rather than duplicated logic, and the
# suite already sings every rung. It is also a real, compounding cost: about
# 500 lines a rung, and the ladder is 82 rungs deep. The growth was surfaced as
# a recollection in a session log (`20260820.130722`); this scan makes it a
# number anybody can re-run, so the design call rests on measurement.
#
# Measurement beats memory: a count carried forward drifts (REDS %93), and a
# count that cannot see what it measures is a guess wearing a measurement's
# clothes (REDS %97). Both failure shapes are refused by name below.
#
# CARAVAN_LADDER_COPY_CEILING (default 60000): the named headroom. The arc may
# keep climbing while the answer is designed; past this line the growth stops
# being a ratchet and becomes a red that must be decided rather than carried.
#
# CARAVAN_LADDER_DIR (default caravan): the directory of rung modules, so the
# PASS and FAIL fixtures can prove both paths without touching the tree.
set -eu

CEILING=${CARAVAN_LADDER_COPY_CEILING:-60000}
DIR=${CARAVAN_LADDER_DIR:-caravan}

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

modules=0
for f in "$DIR"/*.rye; do
  test -f "$f" || continue
  modules=$((modules + 1))
  mod=$(basename "$f" .rye)
  # A check body opens on `fn check_<name>(` at column zero and closes on the
  # first bare `}` at column zero -- the file's own formatting, not a guess.
  awk -v dir="$work" -v mod="$mod" '
    /^fn check_[a-z0-9_]*\(/ { name = $2; sub(/\(.*/, "", name); inb = 1; body = ""; n = 0 }
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
