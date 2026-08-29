#!/bin/sh
# tools/fixtures/w/waymark_table_registry_completeness.sh -- every mark the rule table seats has a
# registry row.
#
# WHY THIS EXISTS. `.claude/rules/waymark-ladders.md` calls
# `construction/waymark-registry.bron` "the sealed, self-verifying canonical record of every
# waymark ever drawn" and "the authority", with its own table as "its readable face". The registry
# witness proves two things and neither of them is this one: the SHA3-512 seal proves no row was
# EDITED, and the re-derivation proves every row PRESENT is honest. A row that is simply ABSENT is
# well-formed, so both readings stay green while the authority is missing a name -- which is
# exactly what happened to AHOY, seated in the table and in 24 living files with no row here, for
# the whole life of the front-door chapter (REDS %298's class, found 20260827).
#
# WHAT IT READS. The four-letter marks in the rule table's seated rows (the `| **XXXX** |` column),
# against `^mark XXXX ` in the registry. A name in one and not the other means one of them is
# lying.
set -eu

RULE=".claude/rules/waymark-ladders.md"
REG="construction/waymark-registry.bron"

[ -f "$RULE" ] || { echo "verdict=rule_absent"; exit 1; }
[ -f "$REG" ]  || { echo "verdict=registry_absent"; exit 1; }

absent=""
count=0
for m in $(grep -oE '^\| \*\*[A-Z]{4}\*\*' "$RULE" | grep -oE '[A-Z]{4}' | sort -u); do
  count=$((count + 1))
  grep -q "^mark $m " "$REG" || absent="$absent $m"
done

echo "table_marks=$count"
echo "absent_from_registry=$(echo "$absent" | sed 's/^ *//')"
if [ -z "$absent" ]; then
  echo "verdict=ok"
else
  echo "detail: a mark the rule table seats has no row in the registry the rule calls the authority"
  echo "verdict=incomplete"
  exit 1
fi
