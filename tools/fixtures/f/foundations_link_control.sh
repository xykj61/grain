#!/bin/sh
# tools/fixtures/f/foundations_link_control.sh -- the why-room link check, proven both ways.
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
out=$(sh "$root/tools/fixtures/f/foundations_link_scan.sh" why 2>/dev/null) || code=$?
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

# ---------------------------------------------------------------------------
# THE SHARED PEN, PROVEN IN BOTH DIRECTIONS.
#
# This scan wrote its link list to `/tmp/fls_links.txt` -- a name fixed when the file was written
# rather than when it runs. Eight ships run one roster from eight checkouts, and 146 guards run
# eight at a time inside each pass, so that one name belongs to every run of this scan anywhere on
# the pier. On `20260907.043200` this pier's cold endurance run refused here while the same scan read GREEN
# alone two minutes later: the witness's own control, running beside the pass, wrote its four-link
# list over the field pass's five hundred.
#
# `shared_pen` already counts the shape -- 308 constant-pen sites across 61 files -- and reads this
# one as `hold` rather than `wipe`, on the reasoning that a file which only writes a constant pen
# "may interleave with a peer and survive". A redirection truncates, so it does not; that is what
# this leg proves.
#
# BOTH DIRECTIONS, because only one of them announces itself. A false RED costs a pass and gets
# read. A false GREEN reports a room full of dead links as whole, and nothing anywhere notices.
#
# ORDERED RATHER THAN RACED. A control that must win a race is a control that sometimes loses one,
# so the elder copy carries a planted `sleep` between writing its list and reading it, and the
# interference lands inside that window. The sleep buys determinism; the shared name is what the
# leg is actually about.
_fd_root="$root"
. "$root/tools/fixtures/p/plant.sh"

shared="${TMPDIR:-/tmp}/fls-shared-pen-control-$$"
mkdir -p "$work/clean" "$work/dirty" "$work/bin"
echo 'a target that stands' > "$work/clean/20260101-000001_target.md"
printf 'It lands: [target](20260101-000001_target.md)\n' > "$work/clean/20260101-000000_citer.md"
printf 'It does not: [gone](20260101-999999_never_written.md)\n' > "$work/dirty/20260101-000000_citer.md"

# Two copies of the real scan: one with the pen name fixed at write time (the elder shape), one
# keeping the repair. Both gain the same sleep, so only the pen differs between them.
_fls_copy() {
  awk -v shared="$2" '
    /^pen=/      { if (shared != "") { print "pen=" shared; next } }
    { print }
    /^done > "\$pen\/links"$/ { print "sleep 3" }
  ' "$root/tools/fixtures/f/foundations_link_scan.sh" > "$1"
}
_fls_copy "$work/bin/elder.sh" "$shared"
_fls_copy "$work/bin/repaired.sh" ""

plant_landed "$root/tools/fixtures/f/foundations_link_scan.sh" "$work/bin/elder.sh" elder_shared_pen || exit 1
plant_landed "$root/tools/fixtures/f/foundations_link_scan.sh" "$work/bin/repaired.sh" repaired_sleep || exit 1

# A poisoner that cannot see the room, only the pen's name.
_fls_poison() {
  sleep 1
  mkdir -p "$shared"
  case "$1" in
    break) printf '%s\t%s\n' "$work/clean" "20260101-999999_never_written.md" > "$shared/links" ;;
    empty) : > "$shared/links" ;;
  esac
}

cd "$work"

# Direction one -- a clean room made to read broken.
sh "$work/bin/elder.sh" clean > "$work/e1.out" 2>/dev/null & e1=$!
_fls_poison break
wait $e1 || true
e1_broken=$(sed -n 's/^links_broken=//p' "$work/e1.out")

# Direction two, the dangerous one -- a broken room made to read whole.
sh "$work/bin/elder.sh" dirty > "$work/e2.out" 2>/dev/null & e2=$!
_fls_poison empty
e2_code=0; wait $e2 || e2_code=$?
e2_verdict=$(sed -n 's/^verdict=//p' "$work/e2.out")

# The repair, given the identical interference: the poisoner cannot name a pen chosen at run time.
sh "$work/bin/repaired.sh" clean > "$work/r1.out" 2>/dev/null & r1=$!
_fls_poison break
wait $r1 || true
r1_broken=$(sed -n 's/^links_broken=//p' "$work/r1.out")

sh "$work/bin/repaired.sh" dirty > "$work/r2.out" 2>/dev/null & r2=$!
_fls_poison empty
r2_code=0; wait $r2 || r2_code=$?
r2_verdict=$(sed -n 's/^verdict=//p' "$work/r2.out")
rm -rf "$shared"

echo "elder_false_red=$([ "$e1_broken" = 1 ] && echo yes || echo no)"
echo "elder_false_green=$([ "$e2_code" -eq 0 ] && [ "$e2_verdict" = ok ] && echo yes || echo no)"
echo "repaired_clean_reads_clean=$([ "$r1_broken" = 0 ] && echo yes || echo no)"
echo "repaired_broken_still_refuses=$([ "$r2_code" -ne 0 ] && [ "$r2_verdict" = broken_link ] && echo yes || echo no)"

if [ "$e1_broken" = 1 ] && [ "$e2_code" -eq 0 ] && [ "$e2_verdict" = ok ] \
   && [ "$r1_broken" = 0 ] && [ "$r2_code" -ne 0 ] && [ "$r2_verdict" = broken_link ]; then
  echo "shared_pen_verdict=ok"
else
  echo "shared_pen_verdict=wrong"
  exit 1
fi
