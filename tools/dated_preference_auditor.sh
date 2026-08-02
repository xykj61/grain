#!/bin/sh
# dated_preference_auditor.sh — REPORT only (e238). Not a gate. Never exits red.
#
# Lists dated counsel/ paths that were modified after introduction and whose
# head lacks Radiant pass, erratum/named correction, or Superseded marker —
# so Keaton can see whether the superseding-seat preference is practised.
#
#   sh tools/dated_preference_auditor.sh
# Spec: context/specs/living-vs-dated.md · seat counsel/20260802-184602_e238-auditor-seated.md

set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
cd "$ROOT"

echo "dated-preference-auditor: REPORT only — not a gate (e238)."
echo "scope: counsel/ dated leaves modified after introduction"
echo "---"

tmp=$(mktemp)
trap 'rm -f "$tmp" "$tmp.mod" "$tmp.unmarked"' EXIT

git ls-files 'counsel/*.md' 'counsel/**/*.md' 2>/dev/null \
  | grep -E '(^|/)2026[0-9]{4}-[0-9]{6}_' >"$tmp" || true

mod=0
unmarked=0
radiant=0
erratum=0
superseded=0

: >"$tmp.unmarked"

while IFS= read -r path; do
  [ -n "$path" ] || continue
  [ -f "$path" ] || continue
  # modified after introducing commit?
  n=$(git rev-list --count "$(git log --diff-filter=A --format=%H -1 -- "$path")"..HEAD -- "$path" 2>/dev/null || echo 0)
  [ "$n" -gt 0 ] 2>/dev/null || continue
  mod=$((mod + 1))
  head40=$(head -40 "$path" 2>/dev/null || true)
  if printf '%s\n' "$head40" | grep -Eqi 'Radiant pass[:\*[:space:]]+`?[0-9]{8}[.]?[0-9]{6}`?'; then
    radiant=$((radiant + 1))
  elif printf '%s\n' "$head40" | grep -Eqi 'erratum|named correction|\*Erratum'; then
    erratum=$((erratum + 1))
  elif printf '%s\n' "$head40" | grep -Eqi 'Superseded|superseding seat'; then
    superseded=$((superseded + 1))
  else
    unmarked=$((unmarked + 1))
    printf '%s\n' "$path" >>"$tmp.unmarked"
  fi
done <"$tmp"

echo "modified_after_intro=$mod"
echo "radiant_pass=$radiant"
echo "erratum_or_named=$erratum"
echo "superseded_marker=$superseded"
echo "unmarked=$unmarked"
echo "---"
echo "unmarked paths (preference gap — report only):"
if [ "$unmarked" -eq 0 ]; then
  echo "(none)"
else
  head -40 "$tmp.unmarked"
  if [ "$unmarked" -gt 40 ]; then
    echo "... ($((unmarked - 40)) more)"
  fi
fi
echo "---"
echo "GREEN: dated-preference-auditor — report complete (never a gate)."
exit 0
