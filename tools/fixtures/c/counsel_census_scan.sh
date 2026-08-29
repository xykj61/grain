#!/bin/sh
# tools/fixtures/c/counsel_census_scan.sh -- Phase 0 of the counsel campaign: who still leans on
# which counsel piece, measured rather than remembered.
#
# WHY. The counsel room closed on 20260821.174047 -- 764 pieces, kept whole, mined on touch. On
# 20260828 Keaton granted the campaign that molts its living insights into their right rooms and
# sheds the elders (deep debride declined). A campaign that big starts with a census, because the
# lift order is by VALUE: a piece cited by many living files carries insight the tree still leans
# on; an orphan is Class O's word-scope, already seated.
#
# WHAT IT PRINTS. One `piece <path> citers=<n>` line per counsel file -- citers counted as LIVING
# tracked files outside counsel/ that name the piece's basename (a file whose own basename carries
# a one-clock stamp is testimony and does not count; session-logs, waymarks, and bron-resins are
# testimony rooms and do not count). Then pieces=, cited=, orphans=, and verdict=ok -- a census
# gates nothing; the campaign reads it.
#
# COUNSEL_ROOT is a control's pen knob, never an override word.

set -eu

ROOT="${COUNSEL_ROOT:-.}"

pen=$(mktemp -d); trap 'rm -rf "$pen"' EXIT

( cd "$ROOT" && git ls-files 'counsel/*.md' 2>/dev/null ) > "$pen/pieces" || : > "$pen/pieces"
( cd "$ROOT" && git ls-files 2>/dev/null ) \
  | grep -v '^counsel/' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  | grep -vE '^(session-logs|waymarks|bron-resins|vendor|gratitude|seed)/' \
  > "$pen/living" || : > "$pen/living"

# One concatenated haystack, so 764 pieces cost one read of the living corpus rather than 764.
# `|| true`, never `|| : > file`: one dangling symlink among six thousand paths fails the cat,
# and a truncating fallback then erases the fifty-six megabytes that DID read (%323's redirect
# lesson, met again in this file's own first run).
( cd "$ROOT" && tr '\n' '\0' < "$pen/living" | xargs -0 cat 2>/dev/null ) > "$pen/haystack" || true

pieces=0; cited=0; orphans=0
while IFS= read -r p; do
  [ -n "$p" ] || continue
  pieces=$((pieces + 1))
  base=$(basename "$p")
  # A generic basename (README.md, CHAPTERS.md) names half the tree; those pieces are counted
  # by a path fragment instead, so the census reads leaning rather than lexical coincidence.
  case "$base" in
    README.md|CHAPTERS.md) needle="counsel/${base}"; case "$p" in counsel/replies/*) needle="counsel/replies/${base}";; esac ;;
    *) needle="$base" ;;
  esac
  n=$(grep -cF "$needle" "$pen/haystack" || true)
  echo "piece $p citers=$n"
  if [ "$n" -gt 0 ]; then cited=$((cited + 1)); else orphans=$((orphans + 1)); fi
done < "$pen/pieces"

echo "pieces=$pieces"
echo "cited=$cited"
echo "orphans=$orphans"
echo "verdict=ok"
