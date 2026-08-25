#!/bin/sh
# tools/d/dated_amendment_audit.sh -- the auditor beside the doorway (e239).
#
#   sh tools/d/dated_amendment_audit.sh [roof ...]      # default: counsel active-designing
#
# `tools/d/dated_guard.rish` is a DOORWAY: it inspects staged modifications only, so a
# landed amendment is invisible to it forever after (e236). This is the auditor the
# doorway cannot be -- a REPORT, never a gate. It exits 0 always; nothing here refuses,
# blocks, or deletes anything.
#
# MARK WINDOW (e241): marks are read from the HEAD-40 lines only. A whole-file scan
# finds the WORD 'erratum' in prose and counts it as a mark, which inflates the marked
# tally; measured against the head-scan's unmarked list, zero files carried a mark deeper
# in the body. The head window loses nothing and invents nothing.
#
# For every dated artifact (YYYYMMDD-HHMMSS_sprig) that git history shows was MODIFIED
# after its introducing commit, it asks whether the file carries one of the lawful marks
# the dated law names: a recorded `Radiant pass <stamp>`, an erratum or named correction,
# or a living-ledger header. Files with none are listed as UNMARKED -- which is a
# description of the record, not a task list (e236).
#
# Seated by Keaton's word 20260802 ("seat the recommendations").

set -e
cd "$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)"

ROOFS=${*:-"counsel active-designing"}
STAMP=$(TZ=America/New_York date '+%Y%m%d.%H%M%S')

echo "dated-amendment audit — of-the-hour ${STAMP}"
echo "mark window: head-40 lines (a mark belongs in the head; prose is not a mark — e241)"
echo "tip $(git rev-parse --short=10 HEAD)"
echo

total=0
marked=0
unmarked=0

for roof in $ROOFS; do
  [ -d "$roof" ] || continue
  r_total=0
  r_radiant=0
  r_erratum=0
  r_living=0
  r_unmarked=0

  git log --diff-filter=M --name-only --pretty=format: -- "$roof/*.md" 2>/dev/null \
    | grep -E "(^|/)[0-9]{8}-[0-9]{6}[_.]" \
    | sort -u > /tmp/.audit_$$ || true

  while read -r f; do
    [ -f "$f" ] || continue
    r_total=$((r_total + 1))
    head40=$(head -40 "$f")
    if printf '%s\n' "$head40" | grep -qi 'Radiant pass'; then
      r_radiant=$((r_radiant + 1))
    elif printf '%s\n' "$head40" | grep -qiE 'erratum|named correction|superseded|superseding seat'; then
      r_erratum=$((r_erratum + 1))
    elif printf '%s\n' "$head40" | grep -qi 'living ledger'; then
      r_living=$((r_living + 1))
    else
      r_unmarked=$((r_unmarked + 1))
      echo "UNMARKED  $f"
    fi
  done < /tmp/.audit_$$
  rm -f /tmp/.audit_$$

  echo
  echo "roof ${roof}: amended ${r_total} · radiant ${r_radiant} · erratum ${r_erratum} · living ${r_living} · unmarked ${r_unmarked}"
  echo

  total=$((total + r_total))
  marked=$((marked + r_radiant + r_erratum + r_living))
  unmarked=$((unmarked + r_unmarked))
done

echo "TOTAL amended ${total} · marked ${marked} · unmarked ${unmarked}"
echo "report only — the doorway refuses at the hour; this names what already crossed."
exit 0
