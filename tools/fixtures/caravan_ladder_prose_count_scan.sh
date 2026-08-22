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
# A `%`-SIGILLED ROW IS A NAME, NOT A COUNT (REDS %131). The rule above reads every digit run in a `say`
# line, and a citation of this tree's own ledger -- `REDS %130` -- is a digit run wearing no measurement at
# all. `%` is the sigil this tree assigns to a number it names itself, and `.claude/rules/git-signing.md`
# says exactly why: in Glow, as in the Hoon it descends from, `%` marks a CONSTANT TERM, a value that is
# exactly itself and never varies. A ledger row is immutable by the ledger's own first law, so it can never
# drift, which is the one and only fault this whole scan exists to catch. Requiring an assert to hold it
# would ask a meter to pin a number that measures nothing.
#
# A ONE-CLOCK STAMP IS A NAME TOO (REDS %135). The same lantern fired a second time, one shape over. A
# meter citing the design read behind it -- `active-designing/20260822-101058_what-a-widening-costs...` --
# put two digit runs in a `say` line, and both were refused as recited counts. Neither is a count. A
# one-clock stamp is fixed by `context/specs/20260627-102012_one-clock-naming-law.md` at the moment a file
# is named and can never drift, which is the only fault this scan exists to catch. So the two shapes the
# naming law defines -- `YYYYMMDD-HHMMSS_` in a filename and `YYYYMMDD.HHMMSS` in a body field -- come off
# the line before any number is read, on exactly the reasoning the sigil already carries. The bound stays
# tight the same way: only a full stamp is exempt, and a bare eight-digit number beside it is still a count
# named at its own value.
#
# So a `%<digits>` token is read as a name and comes off the line before any number is extracted. The bound
# is deliberately tight: only a digit run wearing the sigil is exempt, and a bare `130` beside it is still
# refused, so the exemption cannot be reached by a count that merely stands near a citation. Both directions
# are proven on a generated control in `../caravan_ladder_copy_witness.rish` rather than reasoned here.
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
    # A `%`-sigilled row is this tree's own name for an immutable record, never a count, and a one-clock
    # stamp is the same kind of name, fixed when the file was named. Both come off the line before any
    # number is read. Only the full shapes are exempt; a bare number beside them stays a count.
    printf '%s\n' "${line#*:}" | tr -d ',' |
        sed 's/%[0-9][0-9]*/ /g; s/[0-9]\{8\}-[0-9]\{6\}_/ /g; s/[0-9]\{8\}\.[0-9]\{6\}/ /g' |
        grep -oE '[0-9]+' | sort -u | sed "s/^/${ln}:/"
done)
EOF
done

if [ "$status" = "0" ]; then
    echo "LADDER_PROSE_COUNT_OK said=$said comments=$comments printed=$printed verdict=ok"
    exit 0
fi

echo "said=$said comments=$comments printed=$printed verdict=recited"
exit 1
