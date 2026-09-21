#!/bin/sh
# tools/fixtures/v/voice_roster_scan.sh -- the standing voice, declared once everywhere.
# Orchestrated by tools/gen/chapter/voice_roster_witness.rish.
#
# First resident: the voice-variant system proven on our own tree before it is
# claimed as a surface. Five authoritative sites declare the standing voice,
# down from six -- the mirrored `.cursor/rules/<voice>.mdc` site retired
# `20260920.135100` alongside the whole Cursor family. A further place -- the
# 400-odd dated docs carrying a **Voice:** header -- is NOT checked here on
# purpose: those are Tier 2 testimony naming who actually wrote them, and a
# voice change must never falsify authorship.
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
check "GLOW_PROFILE.template.kyri"             "^voice $want"           "profile default"
check "tools/gen/chapter/recursion_block.brix"  "^voice $want"           "recursion data"
check "context/README.md"                      "^\*\*Voice:\*\* $want"  "context home header"
upper=$(echo "$want" | tr 'a-z' 'A-Z')
check "context/$upper.md"                      "^# $want"               "living identity note"

# The sixth site, a mirrored `.cursor/rules/<voice>.mdc` declaration, retired
# `20260920.135100` on Keaton's word alongside the whole Cursor family -- see
# `.claude/rules/collaboration.md`'s Editor section. This bench no longer
# maintains a second declaration to keep in sync, so the site is retired from
# the roster rather than checked against the frozen archive at
# `.cursor-archive/rules/`, which would misreport a retired duty as a live one.
echo "detail: ok cursor rule retired 20260920.135100, no longer a declaration site"

echo "sites=5"
echo "drift=$fail"
if [ "$fail" -eq 0 ]; then echo "verdict=ok"; exit 0; else echo "verdict=drift"; exit 1; fi
