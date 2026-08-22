#!/bin/sh
# The wall and the meter must read ONE mechanism vocabulary.
#
# `tools/hooks/commit-msg` refuses a thin commit body at write time;
# `tools/fixtures/mechanism_sentence_scan.sh` reports the trailing window against a ceiling.
# Each carries the word list between MECHANISM-WORDS-BEGIN and MECHANISM-WORDS-END, and a wall
# that counts different words from its own meter would refuse a body the meter calls clean.
# The dated-path tools paid three rounds to learn this exact lesson: one shape, checked the
# same way everywhere.
#
# Read-only.
set -eu

extract() {
  sed -n '/MECHANISM-WORDS-BEGIN/,/MECHANISM-WORDS-END/p' "$1" | grep '^MECH_WORDS=' | head -1
}

hook=$(extract tools/hooks/commit-msg)
scan=$(extract tools/fixtures/mechanism_sentence_scan.sh)

test -n "$hook" || { echo "vocabulary_agrees=0 reason=hook_line_missing"; exit 1; }
test -n "$scan" || { echo "vocabulary_agrees=0 reason=scan_line_missing"; exit 1; }

if test "$hook" = "$scan"; then
  echo "vocabulary_agrees=1"
  echo "vocabulary=$(printf '%s' "$hook" | sed "s/^MECH_WORDS='//; s/'$//" | wc -w | tr -d ' ')"
  exit 0
fi
echo "vocabulary_agrees=0 reason=lines_differ"
echo "hook: $hook"
echo "scan: $scan"
exit 1
