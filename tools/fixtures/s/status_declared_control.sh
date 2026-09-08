#!/bin/sh
# status_declared_control.sh -- the status census proven on planted logs in a throwaway repository.
#
# A census sorting into four buckets is proven only when a member is shown MOVING between them, so
# the plants here are promoted one field at a time rather than counted once where they sit.
#
#   sh tools/fixtures/s/status_declared_control.sh
#
# Prints `pass=N fail=N`. Bounded: 11 cases, one pen holding a real git repository.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
scan="$root/tools/fixtures/s/status_declared_scan.sh"
pen=${TMPDIR:-/tmp}/status-declared-pen-$$
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
ask() { STATUS_ROOT="$pen" STATUS_DAY=20260101 sh "$scan" "${1:-count}" 2>&1; }

printf 'stamp 20260101.010000\nscope a full lap\nstatus GREEN -- all witnesses green\n' > "$shelf/20260101-010000_both.kyri"
printf 'stamp 20260101.020000\nthink it ran and then it stopped\n' > "$shelf/20260101-020000_neither.kyri"
printf 'stamp 20260101.030000\nscope a lap with a scope alone\n' > "$shelf/20260101-030000_scope.kyri"
git add -A >/dev/null; git commit -qm seed

out=$(ask)
check "a full log counts as both"     yes "$(has "$out" 'both=1')"
check "a bare log counts as neither"  yes "$(has "$out" 'neither=1')"
check "scope alone is its own bucket" yes "$(has "$out" 'scope_only=1')"
check "and status alone reads zero"   yes "$(has "$out" 'status_only=0')"
check "the day is named"              yes "$(has "$out" 'day=20260101')"

out=$(ask list)
check "a bare log is named"           yes "$(has "$out" 'both-missing: session-logs/date/20260101/20260101-020000_neither.kyri')"
check "a scope-only log is named"     yes "$(has "$out" 'status-missing: session-logs/date/20260101/20260101-030000_scope.kyri')"

# PROMOTION, which is what proves a sort is a sort: the scope-only log gains a status and must move.
printf 'stamp 20260101.030000\nscope a lap with a scope alone\nstatus GREEN -- now it says so\n' > "$shelf/20260101-030000_scope.kyri"
git add -A >/dev/null; git commit -qm promote
out=$(ask)
check "adding status moves it"        yes "$(has "$out" 'both=2')"
check "and scope_only falls to zero"  yes "$(has "$out" 'scope_only=0')"
check "while neither is untouched"    yes "$(has "$out" 'neither=1')"

# An absent shelf refuses rather than reporting four zeros (REDS %170).
if STATUS_ROOT="$pen" STATUS_DAY=19990101 sh "$scan" >/dev/null 2>&1; then
  check "an absent shelf refuses" refused accepted
else
  check "an absent shelf refuses" refused refused
fi

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
