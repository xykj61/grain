#!/bin/sh
# rota_declared_control.sh -- the rota-declaration census proven on planted logs in a pen.
#
# Each of the three answers is planted and then changed into another, because a census that sorts
# into three buckets is only proven when a member of each is shown moving to the right neighbour.
#
# The last seven cases prove the day the census reads, which is a separate claim from what it counts:
# an open day with no corpus falls back to the newest shelf that has one and says so, a day a caller
# NAMED still refuses, and the walk back stops at seven shelves.
#
#   sh tools/fixtures/r/rota_declared_control.sh
#
# Prints `pass=N fail=N`. Bounded: 18 cases, one pen holding a throwaway git repository.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
scan="$root/tools/fixtures/r/rota_declared_scan.sh"
pen=${TMPDIR:-/tmp}/rota-declared-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
shelf="$pen/session-logs/date/20260101"
mkdir -p "$shelf"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

cd "$pen"
git init -q .
git config user.email pen@example.invalid
git config user.name pen

ask() { ROTA_ROOT="$pen" ROTA_DAY=20260101 sh "$scan" "${1:-count}" 2>&1; }

printf 'stamp 20260101.010000\nrota lap 100, row 2 -- Fire, the row that sees\n' > "$shelf/20260101-010000_declared.kyri"
printf 'stamp 20260101.020000\nthink I read row 3 this lap and it taught me something.\n' > "$shelf/20260101-020000_prose.kyri"
printf 'stamp 20260101.030000\nthink Pure repair; no rota this lap.\n' > "$shelf/20260101-030000_silent.kyri"
git add -A >/dev/null; git commit -qm seed

out=$(ask)
check "the field is counted"        yes "$(has "$out" 'rota_field=1')"
check "prose alone is counted"      yes "$(has "$out" 'prose_only=1')"
check "silence is counted"          yes "$(has "$out" 'silent=1')"
check "and the day is named"        yes "$(has "$out" 'day=20260101')"

out=$(ask list)
check "a prose-only log is named"   yes "$(has "$out" 'prose-only: session-logs/date/20260101/20260101-020000_prose.kyri')"
check "a silent log is named"       yes "$(has "$out" 'silent: session-logs/date/20260101/20260101-030000_silent.kyri')"

# A prose-only log that gains the field moves buckets, which is the whole repair this census invites.
printf 'stamp 20260101.020000\nrota lap 101, row 3 -- Water\nthink I read row 3 this lap.\n' > "$shelf/20260101-020000_prose.kyri"
git add -A >/dev/null; git commit -qm promote
out=$(ask)
check "adding the field moves it"   yes "$(has "$out" 'rota_field=2')"
check "and prose-only falls"        yes "$(has "$out" 'prose_only=0')"

# An honest absence declared in the field counts as declared, which is what gives a pure-repair lap
# a way to tell the truth that a reader can count.
printf 'stamp 20260101.040000\nrota none -- pure repair, no rota this lap\n' > "$shelf/20260101-040000_honest.kyri"
git add -A >/dev/null; git commit -qm honest
out=$(ask)
check "an honest absence counts declared" yes "$(has "$out" 'rota_field=3')"
check "and it is not counted silent"      yes "$(has "$out" 'silent=1')"

# A day shelf that does not exist refuses rather than reporting three zeros (REDS %170).
if ROTA_ROOT="$pen" ROTA_DAY=19990101 sh "$scan" >/dev/null 2>&1; then
  check "an absent shelf refuses" refused accepted
else
  check "an absent shelf refuses" refused refused
fi

# THE MIDNIGHT LEG. With no ROTA_DAY the subject is the open day, and the pen holds no shelf for
# today at all -- which is exactly the state every real tree is in between 00:00 and its first
# committed log. The scan answers from the newest shelf that holds a corpus and says which.
open_out=$(ROTA_ROOT="$pen" sh "$scan" 2>&1)
check "an empty open day falls back"      yes "$(has "$open_out" 'day_source=fallback')"
check "and names the shelf it read"       yes "$(has "$open_out" 'day=20260101')"
check "and counts that shelf's corpus"    yes "$(has "$open_out" 'rota_field=3')"

# The same fallback covers the second half of the midnight state: a shelf that EXISTS while its
# logs are still untracked. `git ls-files` reads the index, so an uncommitted log is invisible and
# the count would read zero over a directory that plainly has files in it.
today=$(TZ=America/New_York date +%Y%m%d)
mkdir -p "$pen/session-logs/date/$today"
printf 'stamp %s.000100\nrota lap 1, row 0\n' "$today" > "$pen/session-logs/date/$today/${today}-000100_untracked.kyri"
untracked_out=$(ROTA_ROOT="$pen" sh "$scan" 2>&1)
check "an untracked open day falls back"  yes "$(has "$untracked_out" 'day_source=fallback')"
check "and still reads the older shelf"   yes "$(has "$untracked_out" 'day=20260101')"

# A NAMED DAY IS NOT RESCUED. A caller who writes ROTA_DAY asked about that day; answering from
# another one would report a census under a heading nobody asked for.
if ROTA_ROOT="$pen" ROTA_DAY="$today" sh "$scan" >/dev/null 2>&1; then
  check "a named empty day still refuses" refused accepted
else
  check "a named empty day still refuses" refused refused
fi

# AND THE WALK IS BOUNDED. Seven empty shelves stand between the open day and the corpus, so the
# eighth step is never taken and the scan refuses rather than reporting a stale census as today's.
for d in 20260102 20260103 20260104 20260105 20260106 20260107 20260108; do mkdir -p "$pen/session-logs/date/$d"; done
if ROTA_ROOT="$pen" sh "$scan" >/dev/null 2>&1; then
  check "the walk back is bounded" refused accepted
else
  check "the walk back is bounded" refused refused
fi

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
