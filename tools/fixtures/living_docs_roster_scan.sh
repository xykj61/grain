#!/bin/sh
# tools/fixtures/living_docs_roster_scan.sh -- the meter's own roster is a roster.
#
# WHY. tools/fixtures/living_docs_lint_roster.sh names which living pages the docs meter reads,
# and it was a hand-written list of nine module READMEs. The tree held thirty-four module front
# doors, so the meter read six of them and reported green over the rest for as long as it has
# run. The four largest documents in the whole tree were among the unread: image/README.md at
# 400,042 bytes over 227 .rye sources, lotus/README.md at 297,878 over 240, crypto/README.md at
# 88,205 over 87, and constel/README.md at 69,979 over 31 -- every one of them past the 24,576
# the pin-and-ledger law declares, and none of them ever measured. Two rostered hammocks named
# files that had folded to yonder/ and were never repointed (REDS %187).
#
# This is the third firing of one lantern. A ladder table named 73 of 110 rungs (REDS %184); a
# map's suffix rule reached 95 of 98 modules and the page itself stood off the register meter
# (REDS %185); and here the meter's roster reaches 6 of 34. The transferable form each time:
# WHEREVER A LIST NAMES WHAT IS ON DISK, IT IS A ROSTER AND WANTS THE SAME BIJECTION THE
# PROGRAM'S OWN ROSTER ALREADY HAS -- and a roster that decides what a meter reads wants it
# most, because everything downstream inherits its blind spot.
#
# WHAT IT READS. The tree is asked directly, with git ls-files rather than a glob, for every
# directory holding a tracked .rye source; a tracked README.md in such a directory is a module
# front door. That set is compared against what the roster script prints.
#
#   front_doors  -- module front doors discovered in the tree. Published, so a reading over an
#                   empty tree can never report clean.
#   unrostered   -- front doors the roster misses. HELD AT ZERO.
#   phantom      -- rostered paths naming no file on disk. HELD AT ZERO.
#   over_bound   -- rostered pages past living_pin_max_bytes, under a ceiling that only falls.
#
# WHY over_bound RATCHETS RATHER THAN GATES. Splitting a 400,042-byte front door is a round of
# its own -- caravan's took one whole lap and found a red beneath it. Four such pages stand
# today, and refusing the tree until all four are carried would stop every unrelated lap. The
# ceiling only falls, so each repair is kept and none of them can quietly come back.
#
# THE HONEST COST, said plainly. glow/README.md sits at 23,647 of 24,576 -- 96% -- so ordinary
# growth will carry it over and raise the ratchet. That is the pin law doing exactly what it
# says: "fold when the pin nears its bound." The repair is the fold the law already names, and
# the lint has been advising it at 90% for a month without anything turning the advice into a
# bound (REDS %182).
#
# WHAT PASSES FREE. A README with no .rye beside it, which is a room's index rather than a
# module's door. A fixture corpus under tools/fixtures/, planted to be read by a scan. A .rye
# directory carrying no README yet. A rostered page held by hand for a reason the rule cannot
# see -- rye/, rishi/ and aurora/ keep their sources one level down.
#
# WHAT IT DOES NOT REACH. Whether a front door is any good, whether its prose reads at its
# register (tools/p/prose_register_witness.rish measures that), and whether its links resolve
# (living_docs_lint duty 2). This guard proves only that the meter can see the page.
#
# USAGE
#   sh tools/fixtures/living_docs_roster_scan.sh              # census -- key=value lines
#   sh tools/fixtures/living_docs_roster_scan.sh list         # every unrostered and phantom path
#   sh tools/fixtures/living_docs_roster_scan.sh census DIR   # read DIR as the root (the pen)
#
# Driven by tools/l/living_docs_roster_witness.rish. Proven both ways by
# living_docs_roster_control.sh, which builds real git repositories in a throwaway pen.
# Run from the repository root.
set -eu

MODE="${1:-census}"
ROOT="${2:-.}"
MAX_BYTES=24576

# Rostered pages past the bound, allowed only to fall. Seven at 20260824.075500; six from
# 20260824.082436, when image/README.md split four ways and fell from 400,042 bytes to under
# the bound. The ceiling follows each repair down and never back up.
OVER_BOUND_CEILING=6

cd "$ROOT"

if [ -f tools/fixtures/living_docs_lint_roster.sh ]; then
  ROSTER_SH=tools/fixtures/living_docs_lint_roster.sh
else
  ROSTER_SH=roster.sh
fi

TMP=$(mktemp -d "${TMPDIR:-/tmp}/living-docs-roster.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

# The tree's own answer, asked of git rather than of a glob, so an untracked scratch file and a
# generated corpus are both invisible to it (REDS %172 -- ask the system rather than guess).
git ls-files '*.rye' \
  | sed 's:/[^/]*$::; s:^[^/]*\.rye$:.:' \
  | sort -u \
  | while read -r d; do
      case "$d" in tools/fixtures/*) continue ;; esac
      if [ "$d" = "." ]; then readme="README.md"; else readme="$d/README.md"; fi
      git ls-files --error-unmatch "$readme" >/dev/null 2>&1 && echo "$readme"
    done | sort -u >"$TMP/doors"

sh "$ROSTER_SH" | sort -u >"$TMP/roster"

comm -23 "$TMP/doors" "$TMP/roster" >"$TMP/unrostered"
: >"$TMP/phantom"
: >"$TMP/over"
while read -r f; do
  [ -n "$f" ] || continue
  if [ -f "$f" ]; then
    bytes=$(wc -c <"$f" | tr -d ' ')
    [ "$bytes" -gt "$MAX_BYTES" ] && printf '%s\t%s\n' "$bytes" "$f" >>"$TMP/over"
  else
    echo "$f" >>"$TMP/phantom"
  fi
done <"$TMP/roster"

doors=$(wc -l <"$TMP/doors" | tr -d ' ')
rostered=$(wc -l <"$TMP/roster" | tr -d ' ')
unrostered=$(wc -l <"$TMP/unrostered" | tr -d ' ')
phantom=$(wc -l <"$TMP/phantom" | tr -d ' ')
over=$(wc -l <"$TMP/over" | tr -d ' ')

if [ "$MODE" = list ]; then
  sed 's/^/unrostered /' "$TMP/unrostered"
  sed 's/^/phantom /' "$TMP/phantom"
  sort -rn "$TMP/over" | awk -F'\t' '{ print "over_bound " $2 " bytes=" $1 }'
  exit 0
fi

echo "front_doors=$doors"
echo "rostered=$rostered"
sort -rn "$TMP/over" | awk -F'\t' -v m="$MAX_BYTES" '{ print "page_over_bound=" $2 " bytes=" $1 " max=" m }'
echo "living_pin_max_bytes=$MAX_BYTES"
echo "unrostered=$unrostered"
echo "phantom=$phantom"
echo "over_bound=$over"
echo "over_bound_ceiling=$OVER_BOUND_CEILING"
if [ "$over" -le "$OVER_BOUND_CEILING" ]; then
  echo "ratchet_under_ceiling=yes"
else
  echo "ratchet_under_ceiling=no"
fi
if [ "$unrostered" -eq 0 ] && [ "$phantom" -eq 0 ]; then
  echo "roster_reaches_tree=yes"
else
  echo "roster_reaches_tree=no"
fi
if [ "$unrostered" -eq 0 ] && [ "$phantom" -eq 0 ] && [ "$over" -le "$OVER_BOUND_CEILING" ]; then
  echo "verdict=ok"
  exit 0
fi
if [ "$unrostered" -gt 0 ]; then
  echo "verdict=front_door_off_the_meter"
elif [ "$phantom" -gt 0 ]; then
  echo "verdict=roster_names_an_absent_file"
else
  echo "verdict=over_bound_ratchet_rose"
fi
exit 1
