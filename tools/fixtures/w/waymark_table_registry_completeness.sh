#!/bin/sh
# tools/fixtures/w/waymark_table_registry_completeness.sh -- the rule table and the sealed registry
# hold the same set of seated marks, read in BOTH directions.
#
# WHY THIS EXISTS. `.claude/rules/waymark-ladders.md` calls
# `construction/waymark-registry.bron` "the sealed, self-verifying canonical record of every
# waymark ever drawn" and "the authority", with its own table as "its readable face". The registry
# witness proves two other things: the SHA3-512 seal proves every row stands as written, and the
# re-derivation proves every row present is honest. Both readings stay green while a name is simply
# ABSENT, since an absent row is well-formed -- which is how AHOY stood in the rule table and in 24
# living files with its registry row still to be written, for the whole life of the front-door
# chapter (REDS %298's class, found 20260827). This scan reads the set, where those two read the
# rows.
#
# WHY IT READS TWO DIRECTIONS. From `20260907`. An absence is well-formed on BOTH sides, and the
# first draft read table -> registry alone. A mark drawn into the registry and written into the
# readable face later is the same shape with its ends swapped, and it is the likelier of the two:
# the registry re-seals itself as part of the draw, where the table waits on a hand. A face holding
# a shorter roster than the authority sends its reader to a shorter roster, which is how a name
# already drawn comes to be drawn twice. The operator card carried exactly that on the day this
# leg landed, naming 13 of 30 (REDS %548).
#
# WHAT IT READS. The four-letter marks in the rule table's seated rows (the `| **XXXX** |` column),
# against `^mark XXXX ` in the registry. A name held by one side alone means the two disagree, and
# the verdict says which side is short.
#
# WHAT IT LEAVES ALONE, and this leg is load-bearing. The reverse reading takes ONLY `status
# living` rows. The registry deliberately records marks the table leaves out: four `abandoned`
# draws (COIF, DOCS, MAIR, QUIZ) redrawn before use, and the hand-seated NAMES that name something
# other than a ladder -- SEVA the viewer, MAND the M vane, MONA its prior spelling -- which the
# rule keeps on its exclude roster in its own words. The two hand-seated LADDERS, SETU and POLE,
# belong in the table; `status` alone cannot tell those two from the three names, so a hand-seated
# row is reported by name and left ungated. Gating the whole registry would refuse the tree for
# telling the truth about a draw it declined.
set -eu

RULE=".claude/rules/waymark-ladders.md"
REG="construction/waymark-registry.bron"

[ -f "$RULE" ] || { echo "verdict=rule_absent"; exit 1; }
[ -f "$REG" ]  || { echo "verdict=registry_absent"; exit 1; }

table_marks=$(grep -oE '^\| \*\*[A-Z]{4}\*\*' "$RULE" | grep -oE '[A-Z]{4}' | sort -u)
living_marks=$(grep -E '^mark [A-Z]{4} .*\| status living( \||$)' "$REG" | awk '{print $2}' | sort -u)
hand_marks=$(grep -E '^mark [A-Z]{4} .*\| status hand-seated( \||$)' "$REG" | awk '{print $2}' | sort -u)

absent_from_registry=""
count=0
for m in $table_marks; do
  count=$((count + 1))
  grep -q "^mark $m " "$REG" || absent_from_registry="$absent_from_registry $m"
done

absent_from_table=""
living_count=0
for m in $living_marks; do
  living_count=$((living_count + 1))
  echo "$table_marks" | grep -qx "$m" || absent_from_table="$absent_from_table $m"
done

hand_absent=""
for m in $hand_marks; do
  echo "$table_marks" | grep -qx "$m" || hand_absent="$hand_absent $m"
done

echo "table_marks=$count"
echo "registry_living=$living_count"
echo "absent_from_registry=$(echo "$absent_from_registry" | sed 's/^ *//')"
echo "absent_from_table=$(echo "$absent_from_table" | sed 's/^ *//')"
echo "hand_seated_absent_from_table=$(echo "$hand_absent" | sed 's/^ *//')"

if [ -n "$absent_from_registry" ]; then
  echo "detail: a mark the rule table seats has no row in the registry the rule calls the authority"
  echo "verdict=incomplete"
  exit 1
fi
if [ -n "$absent_from_table" ]; then
  echo "detail: a living mark in the sealed registry is missing from the readable face, so the face names a shorter roster than the authority holds"
  echo "verdict=face_short"
  exit 1
fi
echo "verdict=ok"
