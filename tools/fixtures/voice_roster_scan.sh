#!/bin/sh
# tools/fixtures/voice_roster_scan.sh -- the standing voice, declared once everywhere.
# Orchestrated by tools/gen/season/voice_roster_witness.rish.
#
# First resident: the voice-variant system proven on our own tree before it is
# claimed as a surface. Six authoritative sites declare the standing voice. A
# seventh place -- the 400-odd dated docs carrying a **Voice:** header -- is NOT
# checked here on purpose: those are Tier 2 testimony naming who actually wrote
# them, and a voice change must never falsify authorship.
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
set -eu
want="$1"
fail=0

check() {
  file="$1"; pattern="$2"; label="$3"
  if [ ! -f "$file" ]; then echo "detail: absent $label ($file)"; fail=$((fail + 1)); return; fi
  if grep -q "$pattern" "$file"; then
    echo "detail: ok $label"
  else
    echo "detail: drifted $label ($file) does not declare $want"
    fail=$((fail + 1))
  fi
}

check "CLAUDE.md"                              "You are \*\*$want\*\*"  "agent instruction"
check "GLOW_PROFILE.template.bron"             "^voice $want"           "profile default"
check "tools/gen/season/recursion_block.brix"  "^voice $want"           "recursion data"
check "context/README.md"                      "^\*\*Voice:\*\* $want"  "context home header"
upper=$(echo "$want" | tr 'a-z' 'A-Z')
check "context/$upper.md"                      "^# $want"               "living identity note"

if [ -f ".cursor/rules/$(echo "$want" | tr 'A-Z' 'a-z').mdc" ]; then
  echo "detail: ok cursor rule present"
else
  echo "detail: drifted cursor rule absent for $want"
  fail=$((fail + 1))
fi

echo "sites=6"
echo "drift=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=drift"; exit 1; fi
