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
# reading looks for is one of SIX spellings this tree already writes. Four are read anywhere in the
# file: a `prove-red` call, a `_control.sh` invocation, a planted case, or an `== false` assertion.
# Two more are read on an assertion line, and were added `20260915` after a hand read all
# fifty-three by eye and found two guards demonstrating a refusal in a spelling the four could not
# see:
#
#   THE ASSERTED REFUSAL VALUE -- an instrument called in this file is asserted to speak its
#   refusal digit, as `assert (side "gate-tally-garden-pair-bound-u32" "9" "8") == "0"` does in
#   tools/g/glow_vane_pair_mirrors_witness.rish. The over-bound argument IS the plant, and the
#   digit is the wall answering.
#
#   THE ASSERTED REFUSAL EXIT -- a child invoked here is asserted to exit non-zero, as
#   `assert stranger.code == 2` does in tools/co/comlink_rehearsal_wire_witness.rish. The stranger
#   role is the plant, and the exit code is the refusal.
#
# THE REFUSAL VALUE FORM READS PAST A CAPTURED STREAM, and that exclusion is the whole difference
# between a refusal and a census. tools/g/gen_home_witness.rish asserts `(trim flat.out) == "0"`,
# which reads a count of the live tree and plants nothing; the digit there is an answer about the
# tree rather than an instrument refusing. So a line naming `.out`, `.err`, or `.code` beside its
# `"0"` stays out of the value form -- the exit form reads `.code` on its own terms.
#
# A witness carrying any of the six demonstrates a refusal in its own body; a witness carrying none
# is counted here.
#
# Measured 20260909 over all 285 rostered guards: 285 read, every path present, every file
# asserting, and 53 carrying no marker. ALL FIFTY-THREE DELEGATE -- each asserts on the result of a
# real `run [...]`, so each reds when the child witness, scan, or suite beneath it reds. That is
# what a choir is, and gating this number would refuse every choir the tree owns, which is the gate
# somebody turns off.
#
# Re-read 20260915 over 375 rostered guards -- ninety more than the header above prices, which is
# what a free denominator does in four months. Still every path present and every file asserting;
# the marker-less count read 53 under the four elder spellings and reads 51 under the six, since
# the two named above were delegating in the meter's eyes and demonstrating in their own. The
# ceiling falls to 51 with them. RUN THIS SCAN rather than trusting either figure: the count is
# held by the ceiling, and the denominator beside it is held by nothing at all.
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
# The ceiling only falls. Read 20260915 over the live roster, after the marker set widened from
# four spellings to six; lower it when a repair lands.
CEILING=${REDLEG_CEILING:-51}

[ -f "$ROSTER" ] || { echo "refused: no roster at $ROSTER -- nothing to read" >&2; exit 2; }

work=$(mktemp -d "${TMPDIR:-/tmp}/redleg.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

# THE SIX MARKER SPELLINGS, read in one pass. Four are file-wide; two are read on an assertion
# line, because their meaning depends on what the line asserts ON. A file-wide grep for `== "0"`
# would count a census of the tree as a demonstrated refusal, which is the one distinction this
# reading exists to keep.
marker_present() {
  awk '
    /prove-red|prove_red|_control\.sh|plant|== false/ { found = 1 }
    /(^|[^_[:alnum:]])assert / {
      # the asserted refusal value: an instrument called here speaks its refusal digit. A captured
      # stream on the same line means a census rather than a refusal, so it is read past.
      if ($0 ~ /==[[:space:]]*"0"/ && $0 !~ /\.(out|err|code)/) { found = 1 }
      # the asserted refusal exit: a child invoked here is asserted to exit non-zero.
      if ($0 ~ /\.code[[:space:]]*==[[:space:]]*[1-9]/) { found = 1 }
    }
    END { exit (found ? 0 : 1) }
  ' "$1"
}

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
  if ! marker_present "$path"; then
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

# A RAISED CEILING NAMES THE GUARDS THAT RAISED IT. The count alone tells a lap that something
# arrived and nothing about what, so the lap that meets the red has to read this script's source to
# discover that `list` is an argument at all. Measured `20260909`: this ceiling was raised by one
# guard at 15:50 and three ships surfaced the red over the next two hours, each naming the count
# and none able to act on it, because acting means knowing WHICH. The tree already writes this
# sentence one family over -- the costliest-guard reading names its members for exactly this reason
# -- and the repairable question is which, never how many.
#
# ONLY WHEN THE CEILING IS RAISED, and bounded like every other list here. A green pass prints
# fifty-three names nobody asked for; a red pass prints the arrivals, and the newest rows sit at the
# roster's end, so the tail is where a fresh arrival is.
if [ "$ceiling_ok" = no ]; then
  over=$((no_marker - CEILING))
  [ "$over" -le "$MAX_REPORT" ] || over=$MAX_REPORT
  grep '^no-marker' "$work/report.txt" | tail -"$over" \
    | while IFS="$(printf '\t')" read -r kind name path; do
        printf 'over_ceiling: %s (%s) -- rostered with no refusal of its own\n' "$name" "$path"
      done
fi

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
