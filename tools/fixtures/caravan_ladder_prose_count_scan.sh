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
# THE SECOND RULE, AND WHY IT HAD TO BE DRAWN (REDS %110). The rule above refuses one phrase -- a number
# followed by the word `modules` -- and the very next meter drifted on a word it does not name. The carry
# meter closed every run reciting "137,176 lines across 10,198 copied bodies of the 18,039 standing on it"
# while its own assert, four lines earlier, said 137,185, 10,199, and 18,055. A guard bounded by one context
# noun is a window too narrow to see its subject, which is REDS %102 arriving a second time at meter scale.
#
# So the second rule is bounded by a PROPERTY rather than by a vocabulary: every number a meter recites in
# any `say` line must appear in an `assert` line of the same file. Those lines are what a reader's trust
# lands on, and the property makes the two move together on the same lap -- a subject number
# is asserted and survives, a context number is unasserted and must either earn an assert or leave the
# sentence. Thousands separators are stripped before comparing, since `137,176` and `137185` are the same
# claim wearing different clothes, and that difference is precisely why the first drift went unseen.
#
# THE RULE READS EVERY `say`, NOT ONLY THE CLOSING ONE. It was drawn at the closing line first, and the line
# directly above one proved that boundary too narrow within the same lap: the carry meter's `three windows and
# the room` line recited the same stale 137,176 the close did. A printed number is a printed number.
#
# Usage: sh tools/fixtures/caravan_ladder_prose_count_scan.sh [meter-glob-dir]
# Prints: said=<n> comments=<n> printed=<n> verdict=ok|recited  (and one LADDER_PROSE_BAD line per offence)

set -eu

dir="${1:-tools}"

said=0
comments=0
printed=0
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

    # The second rule -- every number this meter prints stands asserted in this same file. The asserts
    # are read once per meter with separators stripped, so a prose `2,686` matches a pinned `carried=2686`.
    # Each assert padded with a space at both ends, so a number at a line edge still has a non-digit beside
    # it and one plain pattern serves. An `(^|[^0-9])` alternation was tried first and matched nothing at all
    # here -- this shell's grep reads a `^` inside a group as a literal caret -- so the padding is the honest
    # form rather than the clever one, and it was caught by the probe refusing a number the file does assert.
    pinned=$(grep '^assert' "$meter" | tr -d ',' | sed 's/^/ /; s/$/ /' || true)
    while IFS= read -r hit; do
        [ -n "$hit" ] || continue
        lineno=${hit%%:*}
        number=${hit#*:}
        printed=$((printed + 1))
        if ! printf '%s\n' "$pinned" | grep -qE "[^0-9]${number}[^0-9]"; then
            status=1
            echo "LADDER_PROSE_BAD printed $meter:$lineno recites $number with no assert holding it"
        fi
    done <<EOF
$(grep -n '^say ' "$meter" | while IFS= read -r line; do
    ln=${line%%:*}
    printf '%s\n' "${line#*:}" | tr -d ',' | grep -oE '[0-9]+' | sort -u | sed "s/^/${ln}:/"
done)
EOF
done

if [ "$status" = "0" ]; then
    echo "LADDER_PROSE_COUNT_OK said=$said comments=$comments printed=$printed verdict=ok"
    exit 0
fi

echo "said=$said comments=$comments printed=$printed verdict=recited"
exit 1
