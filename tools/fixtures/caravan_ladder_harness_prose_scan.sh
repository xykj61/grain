#!/bin/sh
# caravan_ladder_harness_prose_scan.sh -- no lifted body carries the harness's
# own parameter name into prose a person reads.
#
# A check lifted into `caravan/ladder_checks.rye` reaches every helper through
# the rung handed to it, so lifting a body means prefixing each of that rung's
# symbols with `rung.`. That rewrite is mechanical, and a mechanical rewrite over
# a whole function reaches the parts a compiler never weighs: the operator lines
# a check prints, and the comments that say why it prints them. On
# `20260820.194000` one lift wrote `rung.standing`, `rung.read`, and
# `rung.carry` into fifteen printed sentences and comments. The module compiled,
# the self-test ran, and the line an operator reads had been quietly rewritten
# into nonsense -- caught only because one witness happened to assert on the
# exact sentence (REDS %99).
#
# So the rule is stated where a machine can check it: inside
# `ladder_checks.rye`, a `rung.` that *reaches a symbol* belongs in code and
# never in a string literal or a comment. A guard costs one grep and catches the
# next lift on the lap it enters, rather than months later when somebody reads
# the output.
#
# The reach is what the rule is about, so the reach is what the pattern names: a
# `rung.` followed by an identifier character. English keeps its own word freely,
# and a sentence closing on "every rung." reads clean -- a lift prefixes symbols
# and can only ever produce `rung.` with a name after it, so nothing the fault
# writes escapes through the gap this leaves open. Tightened `20260820.212419`
# after the fold D spine lift, when the elder pattern refused two hand-written
# sentences that end on the ordinary noun (REDS %100).
#
# CARAVAN_HARNESS (default caravan/ladder_checks.rye): the file to weigh, so the
# PASS and FAIL fixtures can prove both paths without touching the tree.
set -eu

FILE=${CARAVAN_HARNESS:-caravan/ladder_checks.rye}

test -f "$FILE" || { echo "HARNESS_PROSE_FAIL reason=no_file file=${FILE}"; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# A comment line first: anything from `//` onward is prose, whole.
awk '{ line=$0; sub(/^[ \t]+/, "", line)
       if (line ~ /^\/\//) print NR "\t" $0 }' "$FILE" > "$work/comments"

# Then string literals, read one line at a time: every run between an even and
# an odd double quote is a literal. Escaped quotes never open one, so they are
# masked out before the split.
awk '{ n = 0; s = $0; gsub(/\\"/, "__", s)
       split(s, parts, "\"")
       for (i = 2; i <= length(parts); i += 2) print NR "\t" parts[i] }' "$FILE" > "$work/literals"

bad=0
while IFS='	' read -r n text; do
  case "$text" in
    *rung.[A-Za-z_]*) echo "HARNESS_PROSE_BAD comment line ${n}: ${text}"; bad=$((bad + 1)) ;;
  esac
done < "$work/comments"

while IFS='	' read -r n text; do
  case "$text" in
    *rung.[A-Za-z_]*) echo "HARNESS_PROSE_BAD literal line ${n}: ${text}"; bad=$((bad + 1)) ;;
  esac
done < "$work/literals"

comments=$(wc -l < "$work/comments" | tr -d ' ')
literals=$(wc -l < "$work/literals" | tr -d ' ')

if [ "$bad" -ne 0 ]; then
  echo "HARNESS_PROSE_FAIL reason=rung_in_prose file=${FILE} found=${bad}"
  exit 1
fi

echo "HARNESS_PROSE_SCANNED file=${FILE} comments=${comments} literals=${literals}"
echo "HARNESS_PROSE_OK no lifted body carries the harness's parameter name into prose"
