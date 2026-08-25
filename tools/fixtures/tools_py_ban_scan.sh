#!/bin/sh
# tools_py_ban_scan.sh -- blocking tools/*.py count (Python-at-seam law).
#
# Exit 0 + TOOLS_PY_OK when every tools/*.py under SCAN_ROOT is either absent
# or listed in tools/fixtures/tools_py_exempt.txt.
# Exit 1 + TOOLS_PY_BAD listing offenders otherwise.
#
# TOOLS_PY_SCAN_ROOT -- override root (default: repository root). The negative
# selftest points this at context/fixtures/tools_py_ban_tree so a planted .py
# FAILS without polluting the living tools/*.py census.
set -eu

HERE=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
SCAN_ROOT=${TOOLS_PY_SCAN_ROOT:-$HERE}
cd "$SCAN_ROOT"

EXEMPT="$HERE/tools/fixtures/tools_py_exempt.txt"
TMP=$(mktemp)
trap 'rm -f "$TMP" "$TMP.all"' EXIT

# Prune host caches -- tools/.cache (HAWM Android SDK) and tools/.build stay
# gitignored; counting them would false-RED the living tree on Framework.
find tools \( -path 'tools/.cache' -o -path 'tools/.build' \) -prune -o \
  -name '*.py' -type f -print 2>/dev/null | sort >"$TMP.all" || : >"$TMP.all"
: >"$TMP"

while IFS= read -r path; do
  [ -n "$path" ] || continue
  skip=0
  if [ -f "$EXEMPT" ]; then
    while IFS= read -r line; do
      case "$line" in ''|\#*) continue ;; esac
      if [ "$line" = "$path" ]; then
        skip=1
        break
      fi
    done <"$EXEMPT"
  fi
  if [ "$skip" -eq 0 ]; then
    echo "$path" >>"$TMP"
  fi
done <"$TMP.all"

if [ -s "$TMP" ]; then
  echo "TOOLS_PY_BAD"
  cat "$TMP"
  exit 1
fi
echo "TOOLS_PY_OK"
exit 0
