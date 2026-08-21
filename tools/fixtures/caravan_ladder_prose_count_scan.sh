#!/bin/sh
# caravan_ladder_prose_count_scan.sh -- a ladder meter recites no module count in the prose it prints.
#
# WHY THIS SCAN EXISTS. `tools/caravan_ladder_spine_witness.rish` closed every run by saying its spine stood
# "across 102 modules" while the scan it had just asserted printed 104, and then 105. The assert bound the
# SCAN OUTPUT and left the closing sentence entirely unguarded, so the sentence drifted twice without a single
# RED -- the exact shape REDS %105 named in the crypto suite, one family over. A reader who trusts a GREEN
# line is handed a number the witness's own measurement contradicts.
#
# THE RULE, AND WHY IT IS DRAWN HERE. A ladder meter's SUBJECT -- carried lines, spine lines, printing lines --
# is pinned in an assert immediately beside its prose, so moving one forces the other on the same lap. The
# MODULE COUNT is nobody's subject; it is context, and context numbers are precisely the ones no lap updates.
# So the rule is narrow and checkable: a `say` line in a ladder meter carries no "<number> modules" phrase.
# The measurement is already printed verbatim by the `living ladder -- ...` line, which cannot drift because it
# is the scan's own output. The fix is not a better number; it is no number.
#
# WHAT IS ADVISORY. Doc-comment headers in these witnesses record what a given lap measured, which is dated
# testimony rather than a claim a runner reads. Those are COUNTED AND REPORTED rather than refused, so the
# scan never quietly narrows its own subject (REDS %102's lesson) and never rewrites dated prose either.
#
# Usage: sh tools/fixtures/caravan_ladder_prose_count_scan.sh [meter-glob-dir]
# Prints: said=<n> comments=<n> verdict=ok|recited  (and one LADDER_PROSE_BAD line per offence)

set -eu

dir="${1:-tools}"

said=0
comments=0
status=0

for meter in "$dir"/caravan_ladder_*_witness.rish; do
    [ -f "$meter" ] || continue

    while IFS= read -r hit; do
        [ -n "$hit" ] || continue
        said=$((said + 1))
        status=1
        echo "LADDER_PROSE_BAD say $meter:$hit"
    done <<EOF
$(grep -n '^say .*[0-9] modules' "$meter" | cut -d: -f1 || true)
EOF

    n=$(grep -c '^#.*[0-9] modules' "$meter" || true)
    comments=$((comments + n))
done

if [ "$status" = "0" ]; then
    echo "LADDER_PROSE_COUNT_OK said=$said comments=$comments verdict=ok"
    exit 0
fi

echo "said=$said comments=$comments verdict=recited"
exit 1
