#!/usr/bin/env bash
# lap_vocabulary_audit.sh — report forward-facing \bring\b still present after sweep.
# Frozen witness basenames and session-logs are excluded.
set -euo pipefail

fail=0

audit_file() {
  local f="$1"
  local hits
  hits=$(grep -nE '\bring\b|\bRing\b' "$f" 2>/dev/null \
    | grep -vE 'slc2a_ring|amber_first_ring|slc1-ring-closed|first-ring-goes-green|thin-ring|additive-gate|ring→lap|ring still' \
    || true)
  if [ -n "$hits" ]; then
    echo "FAIL $f"
    echo "$hits" | sed 's/^/      /'
    fail=1
  fi
}

while IFS= read -r -d '' f; do
  audit_file "$f"
done < <(find context foundations work-in-progress active-designing external-research amber pond rishi manual linengrow brushstroke tools \
  -type f \( -name '*.md' -o -name '*.rye' -o -name '*.rish' -o -name '*.mdc' \) \
  ! -path '*/session-logs/*' ! -path '*/gratitude/*' ! -path '*/archive/*' \
  -print0 2>/dev/null)

for f in ORGANIZING.md CLAUDE.md SIMPLE_LOVABLE_COMPLETE.md; do
  [ -f "$f" ] && audit_file "$f"
done

if [ "$fail" -eq 0 ]; then
  echo "LAP_VOCAB_AUDIT GREEN: no stray ring in forward-facing prose."
else
  echo "LAP_VOCAB_AUDIT RED: ring still present (see above)."
  exit 1
fi
