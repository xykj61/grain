#!/bin/sh
# tools/fixtures/t/tilak_root_count_scan.sh -- the tilak root-count pedestal and the engine
# that hardcodes those roots, read apart and compared.
#
# WHY THIS SHAPE. `foundations/20260703-202312_the-marked-value.md` states the tree's own claim
# about types that travel: every value crossing a seam wears a mark naming its type, and the
# engine hardcodes exactly TWO marks -- the plain-bytes mark and the manifest mark -- so the
# circle of who-validates-the-validators breaks somewhere a reader can point at. That claim is
# written down three times. The foundation argues it. `amphora/manifest_entry.rye` restates it in
# a doc comment above the pair. `src/shape/tilak-root-count.glow` displays it as a museum
# pedestal reading `example    2`.
#
# Nothing held it. Measured 20260910: the pedestal's own leg inside
# tools/gen/chapter/src_first_resident_witness.rish greps that file for the words `plain-bytes`,
# `manifest` and `%tile` -- three strings it already contains -- and never opens the engine at
# all. The number 2 was compared to nothing anywhere in the tree, so a third root wired into
# `mark_verdict` would have passed every guard standing.
#
# So this scan holds no value of its own. It reads what the pedestal displays, reads what the
# engine publishes and answers, and compares them. The pair may grow on Keaton's word; the
# question it answers does not.
#
# FIVE READINGS, EACH ABLE TO FAIL WHILE THE OTHER FOUR AGREE.
#
#   the desk agrees with ITSELF -- the number under `example` equals how many roots the desk
#   actually lists, so the count is a reading of its own list rather than a claim beside it;
#   the desk agrees with what the engine ANSWERS -- `mark_verdict` returns `.known` on exactly
#   that many marks;
#   the desk agrees with what the engine PUBLISHES -- `pub const mark_*` names exactly that many
#   roots. This fires apart from the one above: a root published and never wired into
#   `mark_verdict` moves the second count and leaves the first, and the engine then names a mark
#   it refuses;
#   the engine agrees with ITSELF -- the marks `mark_verdict` answers on are the roots the engine
#   publishes, so a copied literal cannot outlive the constant it copied;
#   the desk's NAMES agree with the arms' names. A count compared to a count agrees while the
#   pair underneath has changed -- rename one root and two is still two -- which is the lesson
#   `shape-tablecloth-error-paths.glow` already carries one pedestal over.
#
# A FIFTH READING WAS ARGUED AWAY AND THEN PUT BACK BY THE CONTROL, which is worth writing down
# because the argument was the right shape and the conclusion was wrong. It asks whether the marks
# the verdict ANSWERS on equal the roots the engine PUBLISHES. Reasoning alone said it could never
# fire while the other four agree: a published root with no arm moves a count, a substituted name
# moves the names. Then the pen showed the case reasoning had missed -- an arm spelled as a bare
# string literal, and the constant it copied later renamed. The engine then publishes `vessel`,
# answers on `manifest`, and every other reading agrees, because the desk was compared against the
# arms and the arms were compared against the desk. Two readings that always fire together are one
# reading wearing two names (.claude/rules/derived-spine.md); the pen is what tells you whether
# these two ever part, and here they do.
#
# THE DESK LISTS ITS ROOTS IN A DELIMITED REGION rather than in prose, because prose carries
# other lowercase hyphenated words and a guard that reads whichever ones happen to be there is a
# guard the next honest paragraph breaks. The region opens and closes on two fixed sentences the
# desk keeps, and the roots sit at a four-space indent inside it.
#
# WHAT IT READS
#   desk_placard_order   the pedestal's first six placard keywords, in seated order
#   desk_citation        whether the pedestal names the Rye file its roots come from
#   desk_example         the number the pedestal displays
#   desk_roots           the roots the pedestal lists, sorted
#   desk_root_count      how many that is
#   rye_const_roots      the values `pub const mark_*` publishes, sorted
#   rye_const_count      how many that is
#   rye_known_arms       how many marks `mark_verdict` answers `.known` on
#   rye_known_roots      the values those arms compare against, resolved and sorted
#   verdict              agree, or the one reading that refused
#
# WHAT IT DOES NOT READ. Whether two is the right number of roots, which is the marked value's
# own design question and Keaton's word; whether the pedestal lowers and runs, which
# tools/gen/chapter/src_first_resident_witness.rish drives the Zig toolchain for; and whether an
# unknown mark is actually refused at the seams, which tools/am/amphora_mark_wreck_witness.rish
# proves on metal. This stays a pure text reading so a control can run it many times in a pen for
# nothing.
#
# USAGE
#   sh tools/fixtures/t/tilak_root_count_scan.sh [<root>]
#
# Driven by tools/t/tilak_root_count_witness.rish. Run from the repository root.

set -eu

root=${1:-.}
desk="$root/src/shape/tilak-root-count.glow"
rye="$root/amphora/manifest_entry.rye"

expect_order='name shape invariant example readers nib'

# The placard's six lines come before any rune, in one seated order (src/shape/PLACARD.md). A
# continuation line under `shape` carries no keyword at column five, so the keywords are
# gathered and then cut at six.
desk_placard_order=none
desk_citation=no
desk_example=none
desk_roots=''
desk_root_count=0
if [ -f "$desk" ]; then
  got=$(sed -n 's/^::  \([a-z][a-z]*\)  .*/\1/p' "$desk" | head -6 | tr '\n' ' ' | sed 's/ *$//')
  [ -n "$got" ] && desk_placard_order=$got
  grep -q 'amphora/manifest_entry\.rye' "$desk" && desk_citation=yes
  ex=$(sed -n 's/^::  example  *\([^ ]*\).*/\1/p' "$desk" | head -1)
  [ -n "$ex" ] && desk_example=$ex
  # The region is read only when BOTH its sentences stand. An opening with no close runs to
  # the end of the file, which would gather whatever four-space lines happen to follow and
  # report a healthy pair over a desk that has lost its list's end.
  if grep -q '^::  the roots the engine hardcodes' "$desk" && grep -q '^::  that is the whole pair\.$' "$desk"; then
    desk_roots=$(sed -n '/^::  the roots the engine hardcodes/,/^::  that is the whole pair\./p' "$desk" \
      | sed -n "s/^::    \([a-z][a-z-]*\) *$/\1/p" | sort | tr '\n' ' ' | sed 's/ *$//')
  fi
  [ -n "$desk_roots" ] && desk_root_count=$(printf '%s\n' "$desk_roots" | tr ' ' '\n' | grep -c .)
fi

# Every root the engine publishes, as a VALUE rather than as a constant name: a rename of the
# constant is the engine's own business, and a rename of the string is a new mark on the wire.
rye_const_roots=''
rye_const_count=0
rye_known_arms=0
rye_known_roots=''
if [ -f "$rye" ]; then
  consts=$(sed -n 's/^pub const \(mark_[a-z_]*\) *= *"\([^"]*\)";.*/\1 \2/p' "$rye")
  rye_const_roots=$(printf '%s\n' "$consts" | awk 'NF{print $2}' | sort | tr '\n' ' ' | sed 's/ *$//')
  [ -n "$rye_const_roots" ] && rye_const_count=$(printf '%s\n' "$rye_const_roots" | tr ' ' '\n' | grep -c .)
  body=$(sed -n '/^pub fn mark_verdict(/,/^}/p' "$rye")
  arms=$(printf '%s\n' "$body" | sed -n 's/.*std\.mem\.eql(u8, mark, \([^)]*\)).*return \.known;.*/\1/p')
  rye_known_arms=$(printf '%s\n' "$arms" | grep -c . || true)
  # An arm naming a published constant is resolved to that constant's value; an arm comparing a
  # bare string literal is taken as written; anything else is named rather than passed over, so a
  # form this reading has never met refuses instead of counting as zero.
  resolved=''
  for a in $arms; do
    case "$a" in
      \"*\") v=$(printf '%s\n' "$a" | sed 's/^"//; s/"$//') ;;
      *) v=$(printf '%s\n' "$consts" | awk -v n="$a" '$1==n{print $2; exit}')
         [ -n "$v" ] || v="unnamed:$a" ;;
    esac
    resolved="$resolved$v
"
  done
  rye_known_roots=$(printf '%s' "$resolved" | sort | tr '\n' ' ' | sed 's/ *$//')
fi

echo "desk_placard_order=$desk_placard_order"
echo "desk_citation=$desk_citation"
echo "desk_example=$desk_example"
echo "desk_roots=$desk_roots"
echo "desk_root_count=$desk_root_count"
echo "rye_const_roots=$rye_const_roots"
echo "rye_const_count=$rye_const_count"
echo "rye_known_arms=$rye_known_arms"
echo "rye_known_roots=$rye_known_roots"

verdict=agree
if [ ! -f "$desk" ]; then
  verdict=desk_missing
elif [ "$desk_placard_order" != "$expect_order" ]; then
  verdict=desk_placard_wrong
elif [ "$desk_citation" != yes ]; then
  verdict=desk_citation_missing
elif [ "$desk_example" = none ]; then
  verdict=desk_example_missing
elif [ "$desk_root_count" -eq 0 ]; then
  verdict=desk_roots_missing
elif [ "$desk_example" != "$desk_root_count" ]; then
  verdict=desk_self_disagree
elif [ ! -f "$rye" ]; then
  verdict=rye_missing
elif [ "$rye_const_count" -eq 0 ]; then
  verdict=rye_consts_missing
elif [ "$rye_known_arms" -eq 0 ]; then
  verdict=rye_arms_missing
elif [ "$desk_example" != "$rye_known_arms" ]; then
  verdict=known_count_disagree
elif [ "$desk_example" != "$rye_const_count" ]; then
  verdict=const_count_disagree
elif [ "$desk_roots" != "$rye_known_roots" ]; then
  verdict=root_names_disagree
elif [ "$rye_known_roots" != "$rye_const_roots" ]; then
  verdict=rye_internal_disagree
fi

echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
