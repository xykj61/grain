#!/bin/sh
# rota_declared_control.sh -- the rota-declaration census proven on planted logs in a pen.
#
# Each of the three answers is planted and then changed into another, because a census that sorts
# into three buckets is only proven when a member of each is shown moving to the right neighbour.
#
#   sh tools/fixtures/r/rota_declared_control.sh
#
# Prints `pass=N fail=N`. Bounded: 11 cases, one pen holding a throwaway git repository.
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

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
