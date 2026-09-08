#!/bin/sh
# status_declared_scan.sh -- a lap that leaves no `status` cannot be told from one that was killed.
#
# WHY. `.claude/rules/session-log-provenance.md` asks every log to *finish with `scope` and `status`
# for this hand*, and the field answers a question nothing else in the record answers: did the lap
# consider itself green when it stopped? Measured `20260907.200326` across that day's shelf, **75 of
# 95 logs carried no `status` and 74 no `scope`** -- four laps in five leaving no such line.
#
# The gap surfaced through a real incident rather than an audit. An incense loop was cancelled by
# hand at the exact moment its lap completed; the work stood staged and whole, the log claimed no
# send, and NOTHING IN THE RECORD said whether it had been interrupted or had finished and declined
# to send. Those are different facts with different repairs, and they read identically.
#
#   sh tools/fixtures/s/status_declared_scan.sh          # counts for the open day
#   sh tools/fixtures/s/status_declared_scan.sh list     # one line per undeclared log
#   STATUS_DAY=YYYYMMDD sh tools/fixtures/s/status_declared_scan.sh
#
# REPORTED, NEVER GATED, and the incident is the argument. A lap killed mid-send cannot write a
# status by definition, so a gate would red hardest on exactly the laps that were interrupted --
# punishing the accident it exists to make visible. A gate that reds on what nobody chose is a gate
# somebody turns off.
#
# BOUNDS: one day shelf, at most 400 logs read, at most 200 reported.
set -eu

root=${STATUS_ROOT:-$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)}
cd "$root"

MODE=${1:-count}
DAY=${STATUS_DAY:-$(TZ=America/New_York date +%Y%m%d)}
MAX_LOGS=400
MAX_REPORT=200

shelf="session-logs/date/$DAY"
[ -d "$shelf" ] || { echo "refused: no day shelf at $shelf -- nothing to read" >&2; exit 2; }

work=$(mktemp -d "${TMPDIR:-/tmp}/status-declared.XXXXXX")
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files "$shelf/*.kyri" | head -"$MAX_LOGS" > "$work/logs.txt"
# A CORPUS OF ZERO IS A RED, NEVER A READING (REDS %170).
[ -s "$work/logs.txt" ] || { echo "refused: the day shelf holds no tracked logs -- every count below would read zero" >&2; exit 2; }

logs=$(wc -l < "$work/logs.txt" | tr -d ' ')
both=0; status_only=0; scope_only=0; neither=0
: > "$work/undeclared.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  has_st=no; has_sc=no
  grep -q '^status ' "$f" 2>/dev/null && has_st=yes
  grep -q '^scope ' "$f" 2>/dev/null && has_sc=yes
  if [ "$has_st" = yes ] && [ "$has_sc" = yes ]; then
    both=$((both + 1))
  elif [ "$has_st" = yes ]; then
    status_only=$((status_only + 1)); printf 'scope-missing\t%s\n' "$f" >> "$work/undeclared.txt"
  elif [ "$has_sc" = yes ]; then
    scope_only=$((scope_only + 1)); printf 'status-missing\t%s\n' "$f" >> "$work/undeclared.txt"
  else
    neither=$((neither + 1)); printf 'both-missing\t%s\n' "$f" >> "$work/undeclared.txt"
  fi
done < "$work/logs.txt"

if [ "$MODE" = list ]; then
  head -"$MAX_REPORT" "$work/undeclared.txt" | while IFS="$(printf '\t')" read -r kind f; do
    printf '%s: %s\n' "$kind" "$f"
  done
fi

echo "day=$DAY"
echo "logs=$logs"
echo "both=$both"
echo "status_only=$status_only"
echo "scope_only=$scope_only"
echo "neither=$neither"
