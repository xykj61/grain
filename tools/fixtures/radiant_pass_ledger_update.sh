#!/bin/sh
# radiant_pass_ledger_update.sh -- set or refresh a file's pass stamp in the ledger.
# Usage: sh tools/fixtures/radiant_pass_ledger_update.sh <relpath> <stamp>
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"
LEDGER=tools/fixtures/radiant_pass_ledger.txt
path=${1:?"usage: radiant_pass_ledger_update.sh <relpath> <stamp>"}
stamp=${2:?"usage: radiant_pass_ledger_update.sh <relpath> <stamp>"}
TMP=$(mktemp)
trap 'rm -f "$TMP"' EXIT
: >"$TMP"
found=0
while IFS= read -r line || [ -n "$line" ]; do
  case "$line" in
    ''|\#*) printf '%s\n' "$line" >>"$TMP"; continue ;;
  esac
  p=${line%%	*}
  if [ "$p" = "$path" ]; then
    printf '%s\t%s\n' "$path" "$stamp" >>"$TMP"
    found=1
  else
    printf '%s\n' "$line" >>"$TMP"
  fi
done <"$LEDGER"
if [ "$found" -eq 0 ]; then
  printf '%s\t%s\n' "$path" "$stamp" >>"$TMP"
fi
mv "$TMP" "$LEDGER"
echo "OK   ledger ${path} → ${stamp}"
