#!/bin/sh
# tools/fixtures/foundations_link_control.sh -- the why-room link check, proven both ways.
#
# A guard that has never refused is a guard nobody has tested, and two of this tree's newest guards
# were red the first time they were asked. So this builds a throwaway room whose answer is known by
# construction -- one link that lands, one anchored link that lands, one link into a folded
# subdirectory that lands, and one link to a file that was moved away -- and checks that the first
# three are accepted and the fourth is named and refused.
#
# It also proves the two exemptions the scan claims: an http link and a bare anchor are left alone,
# since neither is a claim about a path on disk.
#
# EXPECTED: broken_refused=yes, resolving_accepted=yes, http_ignored=yes, anchor_ignored=yes.
#
# Driven by tools/f/foundations_link_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

mkdir -p "$work/why/date/20260101"
echo 'the neighbour' > "$work/why/20260101-000001_neighbour.md"
echo 'the folded one' > "$work/why/date/20260101/20260101-000002_folded.md"

# Four clickable links, one of each kind the room actually holds, plus the two exemptions.
{
  printf 'A sibling that stands: [neighbour](20260101-000001_neighbour.md)\n'
  printf 'An anchored sibling: [a section](20260101-000001_neighbour.md#the-part)\n'
  printf 'A folded target: [folded](date/20260101/20260101-000002_folded.md)\n'
  printf 'A target that graduated away: [gone](../elsewhere/20260101-000003_moved.md)\n'
  printf 'The world outside: [a page](https://example.invalid/page)\n'
  printf 'A heading in this very file: [here](#the-part)\n'
} > "$work/why/20260101-000000_citer.md"

cd "$work"
code=0
out=$(sh "$root/tools/fixtures/foundations_link_scan.sh" why 2>/dev/null) || code=$?
printf '%s\n' "$out" | grep -E '^(room|files_read|links_read|links_broken|verdict)=|^broken: ' | sed 's/^/  /'

named=$(printf '%s\n' "$out" | grep -c 'broken: why -> \.\./elsewhere/20260101-000003_moved\.md' || true)
count=$(printf '%s\n' "$out" | sed -n 's/^links_broken=//p')
read_n=$(printf '%s\n' "$out" | sed -n 's/^links_read=//p')

echo "broken_refused=$([ "$code" -ne 0 ] && [ "$named" -eq 1 ] && echo yes || echo no)"
echo "resolving_accepted=$([ "$count" = 1 ] && echo yes || echo no)"

# Four path links were written; the http link and the bare anchor must never have been counted.
echo "http_ignored=$([ "$read_n" = 4 ] && echo yes || echo no)"
echo "anchor_ignored=$([ "$read_n" = 4 ] && echo yes || echo no)"

if [ "$code" -ne 0 ] && [ "$named" -eq 1 ] && [ "$count" = 1 ] && [ "$read_n" = 4 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
