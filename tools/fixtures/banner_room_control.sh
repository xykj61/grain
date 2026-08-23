#!/bin/sh
# tools/fixtures/banner_room_control.sh -- the banner-drift check, proven both ways.
#
# A guard that has never refused is a guard nobody has tested. This builds a throwaway repository
# holding four documents and checks that the scan tells them apart:
#
#   a Register naming the shelf the file sits on            -> counted, agreeing
#   a Register naming a shelf the file has left             -> counted, REFUSED
#   a Register naming a Two Rooms voice rather than a shelf -> free, never counted
#   a Status naming a kind of piece rather than a shelf     -> free, never counted
#
# The last two are the honest exemptions, and they are proven rather than asserted: a scan that
# refused `**Register:** Checkable` or `**Status:** Counsel -- recommendations only` would red on
# most of the tree's own headers, and a witness the bench routes around is worse than none.
#
# EXPECTED: drift_refused=yes, agreeing_free=yes, voice_free=yes, status_free=yes.
#
# Driven by tools/banner_room_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cd "$work"
git init -q
mkdir -p foundations active-designing

printf '# Home\n\n**Register:** foundations -- the shelf this file sits on.\n' \
  > foundations/20260101-000001_at-home.md
printf '# Moved\n\n**Register:** active-designing -- a shelf this file has left.\n' \
  > foundations/20260101-000002_moved-on.md
printf '# Voice\n\n**Register:** Checkable -- a Two Rooms register, never a room.\n' \
  > foundations/20260101-000003_a-voice.md
printf '# Kind\n\n**Status:** Counsel -- recommendations only, and no claim about a shelf.\n' \
  > active-designing/20260101-000004_a-kind.md
git add -A >/dev/null 2>&1

code=0
out=$(sh "$root/tools/fixtures/banner_room_scan.sh" 2>/dev/null) || code=$?
printf '%s\n' "$out" | sed 's/^/  /'

named=$(printf '%s\n' "$out" | sed -n 's/^banners_naming_a_shelf=//p')
agreeing=$(printf '%s\n' "$out" | sed -n 's/^banners_agreeing=//p')
drifted=$(printf '%s\n' "$out" | sed -n 's/^banners_drifted=//p')
moved=$(printf '%s\n' "$out" | grep -c 'moved-on.md claims active-designing' || true)

echo "drift_refused=$([ "$code" -ne 0 ] && [ "$moved" -eq 1 ] && echo yes || echo no)"
echo "agreeing_free=$([ "$agreeing" -eq 1 ] && echo yes || echo no)"
echo "voice_free=$([ "$named" -eq 2 ] && echo yes || echo no)"
echo "status_free=$([ "$named" -eq 2 ] && echo yes || echo no)"

if [ "$code" -ne 0 ] && [ "$named" -eq 2 ] && [ "$agreeing" -eq 1 ] && [ "$drifted" -eq 1 ] && [ "$moved" -eq 1 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
