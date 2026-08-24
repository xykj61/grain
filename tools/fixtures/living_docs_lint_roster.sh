#!/usr/bin/env sh
# tools/fixtures/living_docs_lint_roster.sh -- which living pages the docs meter reads.
#
# WHY IT DISCOVERS. This roster was a hand-written list of nine module READMEs. The tree held
# thirty-four module front doors, so the meter read six of them, and the four largest documents
# in the whole tree stood outside every meter it feeds: image/README.md at 400,042 bytes over 227
# .rye sources, lotus/README.md at 297,878 over 240, crypto/README.md at 88,205 over 87, and
# constel/README.md at 69,979 over 31 (REDS %187). A hand-written roster goes short quietly,
# because a list looks complete to whoever wrote it.
#
# THE RULE, in one line: a tracked README.md sitting in a directory that holds a tracked .rye
# source is a module front door, and belongs on the meter. It is asked of the tree with
# `git ls-files` rather than guessed, so a module written tomorrow is measured like every other.
# Fixture trees under tools/fixtures/ are the one exclusion -- they are planted corpora built to
# be read by a scan, never doors a person enters by.
#
# WHAT STAYS BY HAND, and why each earns it. The docs/ compression shelf is a whole room, so it
# is taken by glob. The four hammocks and the living pins carry no .rye beside them and are named
# because the pin-and-ledger law names them. rye/, rishi/ and aurora/ keep their sources one
# level down, so the rule cannot see them and the hand still can -- and a page dropping off a
# meter is a page whose pass nobody witnessed (REDS %170), so nothing already read is ever lost
# by a rule arriving.
#
# Held by tools/l/living_docs_roster_witness.rish, which asks the tree the same question
# independently and gates the answer at zero, so a roster that regresses to a hand list reds.
#
#   sh tools/fixtures/living_docs_lint_roster.sh        # one path per line
set -eu

# docs/ compression shelf -- a whole room, so the glob is the roster.
for f in docs/*.md; do
  [ -f "$f" ] || continue
  echo "$f"
done

# Module front doors, discovered: a tracked README.md beside a tracked .rye source.
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git ls-files '*.rye' \
    | sed 's:/[^/]*$::; s:^[^/]*\.rye$:.:' \
    | sort -u \
    | while read -r d; do
        case "$d" in tools/fixtures/*) continue ;; esac
        [ "$d" = "." ] && readme="README.md" || readme="$d/README.md"
        git ls-files --error-unmatch "$readme" >/dev/null 2>&1 && echo "$readme"
      done
fi

# Four living hammocks (product - suite - proven-seat - seam). Two of these folded to yonder/ on
# an earlier lap and the roster kept naming the flat path, so the meter read two absent files.
echo "active-designing/proven-seat-guest-hammock.md"
echo "active-designing/seam-season-hammock.md"
echo "active-designing/yonder/20260712-063558_receipt-verify-wasm-hammock.md"
echo "active-designing/yonder/20260712-063213_door3-consumer-edge-pass-hammock.md"

# Module front doors whose sources sit one level down, so the rule cannot reach them.
for f in rye/README.md rishi/README.md aurora/README.md; do
  [ -f "$f" ] && echo "$f"
done

# Living pins under the pin-and-ledger law (duty 6 size bound).
echo "session-logs/README.md"
echo "construction/TASKS.md"
echo "construction/ROADMAP.md"
echo "construction/ITINERARY.md"
