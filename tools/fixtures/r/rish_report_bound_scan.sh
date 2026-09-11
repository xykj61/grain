#!/bin/sh
# rish_report_bound_scan.sh -- which guards compose a verdict-bearing report through a bounded buffer.
#
#   sh tools/fixtures/r/rish_report_bound_scan.sh [--sites]
#
# WHY THIS GUARD EXISTS. Rishi composes an interpolated string literal through `StrBuf` in
# rishi/src/main.rye -- a bounded 4,096-byte buffer, bounded on purpose -- and refuses
# `StringTooLong` past it. A bare `say <value>` writes the value straight out under no such
# ceiling. So `say "label ${scan.out}"` and `say scan.out` differ in exactly one property: the
# first has a ceiling and the second does not.
#
# ON `20260907` that difference reddened eight ships every lap. `reds_spine_derive_witness.rish`
# read the tree, passed BOTH of its gates -- `verdict=ok`, `rebindings=0` -- and then died at
# `say "reds-spine-derive: the reading on this tree --\n${scan.out}"`, because the reading had
# grown to 4,250 bytes as the ledger grew and the seven-word label wrapped around it put the
# composition over 4,096. The fleet paid a red for a green reading, and the error named the
# guard's own reporting line rather than anything about the tree.
#
# THE ASYMMETRY IS THE FINDING, and it is deliberate on Rishi's side. An `assert ... else` message
# that overflows falls back to its raw literal -- `interpolate(...) catch return text`, main.rye --
# so a REFUSAL degrades to unexpanded text rather than ending the run. A `say` has no fallback and
# propagates the error. Rishi already protects the path that fires when something is wrong; the
# unprotected path is the one that fires when everything is right, and a success report is exactly
# what grows without bound as the tree it reads grows.
#
# WHAT COUNTS AS A SITE. A `say` line, outside a comment, whose string literal holds a `${VAR.out}`
# or `${VAR.err}` hole, where the same file also reads `VAR.out contains` -- which is what makes
# VAR a verdict-bearing REPORT rather than a probe's one line. That second test is the whole
# narrowing: 504 `say` sites across 467 tracked files interpolate some captured output, and almost
# all of them hold a single grep's answer that will never approach the ceiling. Counting those
# would push the tree toward worse prose in 466 files to reach the 26 that carry the hazard.
#
# WHAT DOES NOT COUNT, each proven from both sides in the control:
#
#   * a comment line -- a line whose first non-blank character is `#`. This header and the
#     witness beside it DISCUSS the shape at length; a guard that read a mention as a promise
#     would red hardest on the pages teaching the law.
#   * an `assert ... else` message, however long -- Rishi's fallback above means it degrades
#     rather than fails, so it carries no ceiling to cross.
#   * a `say` of a bare value -- `say scan.out` -- which is the repair, and must read as clean the
#     moment a hand applies it, or the ratchet could never fall.
#   * a probe whose output the file never reads with `contains` -- a one-line answer.
#
# THE REPAIR IS TWO LINES AND MAKES THE OUTPUT BETTER: the label on its own `say`, the reading on
# a bare one. The alternative -- giving `say` the assert's own fallback in main.rye -- is DECLINED
# and named here so the door is not merely forgotten: for an assert the message is secondary to
# the refusal, so degrading it loses little, while a `say` IS its content, and a fallback would
# print a literal `${scan.out}` where a reading belongs. A loud failure is better than a quietly
# wrong report; what is wrong is only that the failure lands on the guard rather than on the hand.
#
# Ratchet, never a gate: every site is correct today and fails only when its own reading grows, so
# a gate would refuse ordinary work. The ceiling only falls.

set -u
root=$(cd "$(dirname "$0")/../../.." && pwd)
cd "$root" || exit 2

ceiling=38
list=no
[ "${1:-}" = "--sites" ] && list=yes

# The buffer the composition runs through, read from Rishi's own source rather than spelled here.
# A number pinned in a second place is a stale pin waiting for a tree that moved.
buf=$(sed -n 's/^ *bytes: \[\([0-9]*\)\]u8 = undefined,$/\1/p' rishi/src/main.rye | head -1)
[ -n "$buf" ] || buf=unknown

sites=0
files=0
tmp=$(mktemp) || exit 2
trap 'rm -f "$tmp"' EXIT

for f in $(git ls-files '*.rish'); do
    [ -f "$f" ] || continue
    hit=no
    # A say line, not a comment, holding a ${VAR.out} or ${VAR.err} hole.
    for v in $(grep -v '^[[:space:]]*#' "$f" 2>/dev/null \
               | grep -o 'say "[^"]*\${[a-z_][a-z_0-9]*\.\(out\|err\)}' \
               | sed 's/.*${\([a-z_][a-z_0-9]*\)\..*/\1/' | sort -u); do
        # The narrowing: the file reads this same capture as a verdict-bearing report.
        grep -q "$v\.out contains" "$f" || continue
        sites=$((sites + 1))
        hit=yes
        echo "site: $f -- \$\{$v.out\} composed into a say" >> "$tmp"
    done
    [ "$hit" = yes ] && files=$((files + 1))
done

[ "$list" = yes ] && [ -s "$tmp" ] && cat "$tmp"

echo "strbuf_bytes=$buf"
echo "sites=$sites"
echo "files=$files"
echo "ceiling=$ceiling"

if [ "$sites" -le "$ceiling" ]; then
    echo "verdict=under_ceiling"
    exit 0
fi
# A REFUSAL NAMES ITS MEMBERS. The two lines below say what the class is and how to repair one,
# and until `20260911` they said it over a bare total: a reader met `sites=39 ceiling=38` and had
# to discover `--sites` for themselves before they could touch a single file. That is the shape
# GRASS booked one room over for `late_say` -- a total naming no member makes a stray unlocatable
# -- and `session_roster_agree` took the same repair the same day. The list is already gathered in
# `$tmp` whether or not `--sites` was passed, so printing it on a refusal costs one line and the
# flag keeps its job of showing the roster on a GREEN reading.
[ "$list" = yes ] || { [ -s "$tmp" ] && cat "$tmp"; }
echo "detail: a guard composes a report that may outgrow ${buf} bytes and end the run on a GREEN reading"
echo "detail: repair -- put the label on its own say and the reading on a bare one, as reds_spine_derive does"
echo "verdict=over_ceiling"
exit 1
