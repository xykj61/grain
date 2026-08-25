#!/bin/sh
# tools/fixtures/comment_citation_scan.sh -- every path a program cites in a comment still resolves.
#
# WHY THIS EXISTS. A citation is a promise, and this tree already keeps that promise for documents:
# tools/fixtures/tracked_link_scan.sh reads relative links inside `.md` files and refuses a broken
# one. A `.rye` module makes the same promise in its doc comments -- `//! Ground: [`spec`](../x.md)`
# -- and nothing read those at all.
#
# So when the `tools/` fold of 20260823.144100 carried 1,917 entries into 35 rooms,
# tools/rye/session_logs_archive.rye went one directory deeper and its two comment citations kept
# the depth they were written at. Both pointed at `tools/ORGANIZING.md` and `tools/.claude/`, which
# have never existed. Two repointers ran that day and one link guard stands: the repointers move
# path literals in living code, the link guard reads links inside `.md`, and a Markdown link inside
# a `.rye` comment falls between all three. It stood for two days and was found by a meter looking
# at something else.
#
# WHAT IS CHECKED. Every tracked non-prose file, for link targets on COMMENT lines only, using
# tools/fixtures/qa_report_card.sh as the one reading -- CITED rather than copied, so the rule that
# decides what a citation is lives in exactly one place. That card already knows the four things
# this check would otherwise get wrong, each learned from a real case on 20260825:
#
#   a placeholder shape is an illustration    `](date/YYYYMMDD/name)`, `](date/<day>/name)`
#   a backticked span illustrates syntax      `](./x)` inside backticks in exec_bit_scan.sh
#   a target must look like a path            `x[1](32000)` is array-index-then-value arithmetic
#   a symlink's citations belong to its body  pond/apps/granary/wov_core.rye is mode 120000
#
# The last of those is the one that would have done damage. Six symlinked doors read as eleven
# broken citations, and repairing them would have written through the links into six correct bodies.
#
# WHAT IS GATED. Zero. This is a small, closed population -- 4 broken across 9,101 files when it was
# first measured -- and every one of them is a promise a reader can already follow. A ratchet would
# be the wrong shape here, because there is nothing to migrate.
#
# WHAT IS NOT CHECKED. Whether the cited document still SAYS what the comment claims. That is
# .claude/rules/docs-implementation-sync.md's job and only a reader can do it.
#
# USAGE
#   sh tools/fixtures/comment_citation_scan.sh
#
# Driven by tools/co/comment_citation_witness.rish. Run from the repository root.

set -u

root=${COMMENT_CITATION_ROOT:-.}
card="$root/tools/fixtures/qa_report_card.sh"
[ -f "$card" ] || { echo "verdict=card_missing"; exit 1; }

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# One git pass for the candidates rather than a grep per file: at 9,101 tracked non-prose files the
# difference is minutes, and a guard nobody waits for is a guard somebody skips.
( cd "$root" && git grep -l -- '](' -- ':!*.md' ':!*.mdc' ':!*.markdown' ':!vendor' ':!gratitude' ':!seed' 2>/dev/null ) > "$work/candidates.txt" || :

files=0
broken=0
: > "$work/broken.txt"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$root/$f" ] || continue
  files=$((files + 1))
  out=$(COMMENT_CITATION_ROOT="$root" QA_CARD_ROOT="$root" sh "$card" "$f" --setting meter --service 100 2>/dev/null | grep '^unresolved:') || :
  [ -n "$out" ] || continue
  n=$(printf '%s\n' "$out" | wc -l | tr -d ' ')
  broken=$((broken + n))
  printf '%s\n' "$out" | sed "s|^unresolved: |broken: $f -> |" >> "$work/broken.txt"
done < "$work/candidates.txt"

[ -s "$work/broken.txt" ] && cat "$work/broken.txt"
echo "programs_scanned=$files"
echo "broken_citations=$broken"

if [ "$broken" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=broken_citation"
echo "refused: a program cites a path that does not resolve -- read the lines above" >&2
exit 1
