#!/bin/sh
# tools/fixtures/documented_room_control.sh -- the invisible-room check, proven both ways.
#
# A guard that has never refused is a guard nobody has tested. This builds a throwaway repository
# with a filing guide naming two rooms -- one absent and live, one absent and named as departed --
# and checks that the first is refused and the second allowed.
#
# EXPECTED: invisible_refused=yes, departed_allowed=yes.
#
# Driven by tools/d/documented_room_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cd "$work"
git init -q
mkdir -p kept
echo kept > kept/README.md
git add -A >/dev/null 2>&1

# A guide naming a live room that is absent from git, and a departed one that is also absent.
printf '**`kept/`** -- a room that is tracked.\n\n**`ghost/`** -- a room that was never added.\n\n**`gone-room/`** -- **gone `20260101`**, and named so the absence is legible.\n' > ORGANIZING.md
git add ORGANIZING.md >/dev/null 2>&1

code=0
out=$(sh "$root/tools/fixtures/documented_room_scan.sh" 2>/dev/null) || code=$?
printf '%s\n' "$out" | grep -E '^(rooms_named|rooms_invisible|verdict)=|^invisible: ' | sed 's/^/  /'

refused=$([ "$code" -ne 0 ] && echo yes || echo no)
ghost=$(printf '%s\n' "$out" | grep -c '^invisible: ghost$' || true)
departed=$(printf '%s\n' "$out" | grep -c '^invisible: gone-room$' || true)

echo "invisible_refused=$refused"
echo "departed_allowed=$([ "$departed" -eq 0 ] && echo yes || echo no)"

if [ "$refused" = yes ] && [ "$ghost" -eq 1 ] && [ "$departed" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
