#!/bin/sh
# radiant_pass_outcome.sh -- classify changed vs clean for a Radiant pass row.
# clean = only Radiant-pass metadata added (plus optional blank line before ---).
# changed = any other body diff vs BASE ref.
#
#   CLAIM_PRESERVE_BASE=HEAD sh tools/fixtures/radiant_pass_outcome.sh <path>
set -eu

path=${1:?"usage: radiant_pass_outcome.sh <path>"}
BASE=${CLAIM_PRESERVE_BASE:-HEAD}

if ! git cat-file -e "${BASE}:${path}" 2>/dev/null; then
  echo "changed"
  exit 0
fi

if ! git diff --quiet "${BASE}" -- "$path" 2>/dev/null; then
  :
else
  echo "clean"
  exit 0
fi

# Any diff line that is not a Radiant-pass stamp or a lone blank addition -> changed.
non_meta=$(
  git diff -U0 "${BASE}" -- "$path" \
    | grep -E '^\+[^+]' \
    | grep -viE '^\+Radiant pass' \
    | grep -v '^+$' \
    || true
)

if [ -n "$non_meta" ]; then
  echo "changed"
else
  echo "clean"
fi
