#!/bin/sh
# loom_trend_control.sh -- the loom reader proven on planted logs in a throwaway repository.
#
# The plants are the shapes the tree actually writes: a numeric key across days, a text key, a key
# that collides across two families, and a key nobody ever wrote.
#
#   sh tools/fixtures/l/loom_trend_control.sh
#
# Prints `pass=N fail=N`. Bounded: 13 cases, one pen holding a real git repository.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
tool="$root/tools/l/loom_trend.sh"
pen=${TMPDIR:-/tmp}/loom-trend-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

mkdir -p "$pen/session-logs/date/20260101" "$pen/session-logs/date/20260102" "$pen/tools/l"
cp "$tool" "$pen/tools/l/"
cd "$pen"; git init -q .; git config user.email pen@example.invalid; git config user.name pen

printf 'stamp 20260101.010000\nloom roster=a guards=10 seconds=100\n' > session-logs/date/20260101/20260101-010000_one.kyri
printf 'stamp 20260102.020000\nloom roster=a guards=30 seconds=80\n'  > session-logs/date/20260102/20260102-020000_two.kyri
# a DIFFERENT family writing the same key name, which is what makes a bare reading incomparable
printf 'stamp 20260102.030000\nloom probe=b seconds=2\n'              > session-logs/date/20260102/20260102-030000_three.kyri
git add -A >/dev/null; git commit -qm plant

run() { LOOM_ROOT="$pen" sh tools/l/loom_trend.sh "$@" 2>&1; }

out=$(run guards --summary)
check "a numeric key is summarised"      yes "$(has "$out" 'numeric=2')"
check "the first value is the oldest"    yes "$(has "$out" 'first=10 at 20260101-010000')"
check "the last value is the newest"     yes "$(has "$out" 'last=30 at 20260102-020000')"
check "and a rise is named a rise"       yes "$(has "$out" 'direction=rising')"

out=$(run seconds --summary)
check "a bare key reads every family"    yes "$(has "$out" 'values=3')"
check "so its minimum is the small one"  yes "$(has "$out" 'min=2')"

out=$(LOOM_FAMILY=roster run seconds --summary)
check "a family scopes the reading"      yes "$(has "$out" 'values=2')"
check "and the intruder is excluded"     yes "$(has "$out" 'min=80')"
check "a fall is named a fall"           yes "$(has "$out" 'direction=falling')"

out=$(run roster --summary)
check "a text key says it is not numeric" yes "$(has "$out" 'direction=not_numeric')"

out=$(run nosuchkey --summary)
check "an unwritten key says so"         yes "$(has "$out" 'verdict=key_never_written')"
check "rather than printing a flat line" no  "$(has "$out" 'direction=')"

out=$(run guards)
# THE LISTING CARRIES THE SOURCE LINE, so a reader sees the scope a value was measured in. A key is
# comparable only within one scope, and this reader once merged a single fast leg with a whole run.
check "a listing shows the loom line"    yes "$(has "$out" 'loom roster=a guards=10 seconds=100')"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
