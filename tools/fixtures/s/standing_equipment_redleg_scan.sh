#!/bin/sh
# tools/fixtures/s/standing_equipment_redleg_scan.sh -- the roster claims every guard on it can
# red, and this scan is what reads that claim back.
#
# WHY THIS METER EXISTS. construction/standing-equipment.kyri says it in its own eleventh line:
# "the grain says a guard that cannot red guards nothing (REDS row 59), and every guard here can
# red." That sentence governs 285 files and stood for months on its own word.
#
# Its sibling half already stands behind a gate. tools/s/standing_equipment_witness.rish holds
# `guards_path_missing` at zero, so a rostered path always names a real file, and it reports how
# many rostered guards have run here at all -- the strand that a guard which is never run guards
# nothing either. That witness names its own scope plainly: it proves the mechanics beneath the
# roster's choice. So the row-149 half had a wall and the row-59 half had a sentence.
#
# WHAT IS GATED, hard, at zero. `guards_no_assert` -- a rostered witness whose whole body is
# printing. Such a file exits clean whatever the tree does, which is the vacuum REDS row 59 was
# booked for: five custody bars of the enclosure witness passed for their whole lives with literal
# quote characters standing where tests belonged. A file that asserts nothing stays silent whatever
# happens beneath it, and that has exactly one right answer, so a wall may refuse it outright.
#
# WHAT IS REPORTED UNDER A CEILING THAT ONLY FALLS. `guards_no_refusal_marker` -- a rostered
# witness that asserts and leaves the demonstration of a refusal to something else. The marker this
# reading looks for is one of four this tree already writes: a `prove-red` call, a `_control.sh`
# invocation, a planted case, or an `== false` assertion. A witness carrying any of them
# demonstrates a refusal in its own body; a witness carrying none is counted here.
#
# Measured 20260909 over all 285 rostered guards: 285 read, every path present, every file
# asserting, and 53 carrying no marker. ALL FIFTY-THREE DELEGATE -- each asserts on the result of a
# real `run [...]`, so each reds when the child witness, scan, or suite beneath it reds. That is
# what a choir is, and gating this number would refuse every choir the tree owns, which is the gate
# somebody turns off.
#
# What the number is good for is the DIRECTION it moves. A guard whose refusal is demonstrated in
# its own body stays out of this count, so the reading rises exactly when a guard arrives with
# neither a marker nor a child to red for it -- audible on the lap it lands rather than months
# later.
#
# WHAT THIS READING REACHES, and where it stops. It answers whether a refusal was demonstrated in
# the file. Whether that refusal covers the class the guard claims stays a reading a person does,
# against the standard the grain already sets: a plant the toothed form bites and the vacuous form
# would have waved through. Honest and incomplete is a different thing from wrong.
#
#   sh tools/fixtures/s/standing_equipment_redleg_scan.sh          # the counts
#   sh tools/fixtures/s/standing_equipment_redleg_scan.sh list     # one line per guard with no marker
#
# BOUNDS: at most 512 guard rows read, at most 200 reported. A roster reading zero guards refuses
# rather than reporting a clean sweep, because a corpus of zero is a red and never a reading
# (REDS %170).
set -eu

root=${REDLEG_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
ROSTER=${REDLEG_ROSTER:-construction/standing-equipment.kyri}
MAX_GUARDS=512
MAX_REPORT=200
# The ceiling only falls. Read 20260909 over the live roster; lower it when a repair lands.
CEILING=${REDLEG_CEILING:-53}

[ -f "$ROSTER" ] || { echo "refused: no roster at $ROSTER -- nothing to read" >&2; exit 2; }

work=$(mktemp -d "${TMPDIR:-/tmp}/redleg.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

# A `guard` line opens a record and the `path` line beneath it names the file. Reading the pair
# rather than every `path` line keeps a stray field in another record out of the count.
awk '/^guard /{n=$2} /^path /{if (n != "") {print n"\t"$2; n=""}}' "$ROSTER" \
  | head -"$MAX_GUARDS" > "$work/guards.txt"

guards=$(wc -l < "$work/guards.txt" | tr -d ' ')
[ "$guards" -gt 0 ] || { echo "refused: the roster names no guards -- every count below would read zero" >&2; exit 2; }

absent=0; no_assert=0; no_marker=0
: > "$work/report.txt"
while IFS="$(printf '\t')" read -r name path; do
  if [ ! -f "$path" ]; then
    absent=$((absent + 1))
    printf 'absent\t%s\t%s\n' "$name" "$path" >> "$work/report.txt"
    continue
  fi
  # invariant: an assert must be a call rather than a word inside an identifier, so the match
  # requires a non-identifier character before it.
  if ! grep -qE '(^|[^_[:alnum:]])assert ' "$path"; then
    no_assert=$((no_assert + 1))
    printf 'no-assert\t%s\t%s\n' "$name" "$path" >> "$work/report.txt"
    continue
  fi
  if ! grep -qE 'prove-red|prove_red|_control\.sh|plant|== false' "$path"; then
    no_marker=$((no_marker + 1))
    printf 'no-marker\t%s\t%s\n' "$name" "$path" >> "$work/report.txt"
  fi
done < "$work/guards.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/report.txt" | while IFS="$(printf '\t')" read -r kind name path; do
    case "$kind" in
      absent)    printf 'absent: %s names %s, which is not on disk\n' "$name" "$path" ;;
      no-assert) printf 'no-assert: %s (%s) carries no assertion -- it cannot refuse on its own reading\n' "$name" "$path" ;;
      no-marker) printf 'no-marker: %s (%s) asserts, and demonstrates no refusal\n' "$name" "$path" ;;
    esac
  done
fi

ceiling_ok=yes
[ "$no_marker" -le "$CEILING" ] || ceiling_ok=no

verdict=ok
[ "$no_assert" -eq 0 ] || verdict=vacuous_guard
[ "$ceiling_ok" = yes ] || verdict=ceiling_raised

echo "roster=$ROSTER"
echo "guards=$guards"
echo "guards_absent=$absent"
echo "guards_no_assert=$no_assert"
echo "guards_no_refusal_marker=$no_marker"
echo "no_refusal_marker_ceiling=$CEILING"
echo "ceiling_ok=$ceiling_ok"
echo "verdict=$verdict"
