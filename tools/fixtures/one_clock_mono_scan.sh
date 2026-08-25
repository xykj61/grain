#!/bin/sh
# one_clock_mono_scan.sh -- false-future gate (monotonic true head).
#
# true_head = max(living stamps not listed in the drift erratum).
# Any living stamp greater than true_head must be on the erratum list
# (the four UTC-window files). Unlisted false-futures -> MONO_BAD.
set -eu
erratum=tools/fixtures/one_clock_drift_erratum.txt
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT

for d in session-logs waymarks counsel foundations counsel/replies; do
  test -d "$d" || continue
  for f in "$d"/[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-*; do
    test -e "$f" || continue
    base=$(basename "$f")
    stamp=$(printf '%s' "$base" | sed -n 's/^\([0-9]\{8\}\)-\([0-9]\{6\}\)_.*$/\1.\2/p')
    test -n "$stamp" || continue
    printf '%s\n' "$stamp"
  done
done | sort -u >"$tmp"

true_head=""
while IFS= read -r stamp; do
  test -n "$stamp" || continue
  if grep -qx "$stamp" "$erratum" 2>/dev/null; then
    continue
  fi
  if test -z "$true_head" || [ "$stamp" \> "$true_head" ]; then
    true_head=$stamp
  fi
done <"$tmp"

if test -z "$true_head"; then
  echo "MONO_BAD no non-erratum living stamp"
  exit 0
fi

echo "TRUE_HEAD $true_head"
bad=0
while IFS= read -r stamp; do
  test -n "$stamp" || continue
  if [ "$stamp" \> "$true_head" ]; then
    if grep -qx "$stamp" "$erratum" 2>/dev/null; then
      echo "ERRATUM_OK $stamp"
    else
      echo "MONO_BAD $stamp > true_head $true_head (unlisted false-future)"
      bad=1
    fi
  fi
done <"$tmp"

# Erratum integrity: each listed stamp must still exist in the tree -- as a living
# file, or (accrete-never-break) as a folded log under session-logs/date/, since a
# day's logs fold there by stamp and leave the top-level living glob unchanged in name.
# The fold destination molted archive/ -> date/ on 20260821.161758 with the mark law; the
# elder name is still searched so this guard reads a tree folded either way rather than
# going quietly weaker on a clone that has not moved yet.
while IFS= read -r line; do
  case "$line" in
    ''|\#*) continue ;;
  esac
  if grep -qx "$line" "$tmp"; then
    continue
  fi
  d="${line%.*}"
  t="${line#*.}"
  if find session-logs/date session-logs/archive -name "${d}-${t}_*" 2>/dev/null | grep -q .; then
    echo "ERRATUM_ARCHIVED $line"
    continue
  fi
  echo "MONO_BAD erratum stamp missing from the tree (living or archived): $line"
  bad=1
done <"$erratum"

if test "$bad" = "0"; then
  echo MONO_OK
fi
exit 0
