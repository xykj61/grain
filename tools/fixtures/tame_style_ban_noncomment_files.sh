#!/bin/sh
# tame_style_ban_noncomment_files.sh — fixed-string ban grep that skips // lines.
#
# Usage (from repository root):
#   sh tools/fixtures/tame_style_ban_noncomment_files.sh 'PATTERN' file.rye...
#
# Prints unique matching file paths (one per line) where PATTERN appears on a
# non-comment line. Lines whose first non-space is // (covers // · /// · //!)
# are skipped — a doc comment that *names* a ban is not a violation.
# Exit 0 always; empty stdout means clean. Caller asserts emptiness.
#
# Always pass -H so a single-file grep still prefixes the path (GNU grep
# otherwise prints bare line:content and cut -f1 yields the line number).
set -eu

if [ "$#" -lt 1 ]; then
  echo "tame_style_ban_noncomment_files: need PATTERN" >&2
  exit 2
fi
pat=$1
shift
if [ "$#" -eq 0 ]; then
  exit 0
fi

# grep -n exits 1 on no match — do not fail the shell under set -e.
grep -HnF "$pat" "$@" 2>/dev/null \
  | grep -Ev '^[^:]+:[0-9]+:[[:space:]]*//' \
  | cut -d: -f1 \
  | sort -u \
  || true
