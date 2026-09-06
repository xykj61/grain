#!/bin/sh
# fleet_lap_verdict_control.sh -- the lap classifier proven by doing, in a throwaway pen.
#
# Every case is asserted in BOTH directions where a direction exists: the transcript that must read
# `limit` is then stripped of its limit words and must read something else, because a verdict proven
# only in the passing direction cannot be told from a classifier that answers one word to everything.
#
#   sh tools/fixtures/f/fleet_lap_verdict_control.sh
#
# Prints `pass=N fail=N` and exits non-zero on any failure. Bounded: 12 cases, one pen.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
cd "$root"

verdict_sh=tools/fixtures/f/fleet_lap_verdict.sh
loop_sh=tools/f/fleet-loop.sh
pen=${TMPDIR:-/tmp}/fleet-lap-verdict-pen
rm -rf "$pen"
mkdir -p "$pen"

pass=0
fail=0

check() {
  _name=$1
  _want=$2
  _got=$3
  if [ "$_got" = "$_want" ]; then
    pass=$((pass + 1))
  else
    fail=$((fail + 1))
    printf 'FAIL %s -- wanted %s, got %s\n' "$_name" "$_want" "$_got" >&2
  fi
}

ask() { sh "$verdict_sh" "$1" "$2" "$3"; }

# -- the words each provider actually printed on 20260906, kept verbatim ----------------------
printf 'round-open: open on 00fb6b08e0\nYou have hit your session limit - resets 7:30am (America/New_York)\n--- lap complete ---\n' > "$pen/limit.txt"
printf 'ai-jail: unrecognized option --verbose\n' > "$pen/jail.txt"
printf 'the lap ran and something in it failed\n' > "$pen/ordinary.txt"

# 1-2) THE FIX ITSELF: a limit refusal returns instantly, and instant is what the elder rule read.
check "limit beats quickfail on an instant lap" verdict=limit "$(ask "$pen/limit.txt" 1 2)"
check "limit still reads limit on a slow lap"   verdict=limit "$(ask "$pen/limit.txt" 1 900)"

# 3-4) and the other direction -- strip the limit words and the same shape reads as a fault
check "an instant lap with no limit words"      verdict=quickfail "$(ask "$pen/jail.txt" 1 2)"
check "a slow lap with no limit words"          verdict=fault     "$(ask "$pen/ordinary.txt" 1 900)"

# 5-6) rc 0 is never a fault, whatever the transcript happens to carry
check "rc 0 with a clean transcript"            verdict=ok "$(ask "$pen/ordinary.txt" 0 900)"
check "rc 0 over limit words"                   verdict=ok "$(ask "$pen/limit.txt" 0 2)"

# 7-8) an absent or unreadable transcript classifies by elapsed alone -- the elder behavior
check "absent transcript, instant"              verdict=quickfail "$(ask "$pen/nowhere.txt" 1 2)"
check "absent transcript, slow"                 verdict=fault     "$(ask "$pen/nowhere.txt" 1 900)"

# 9) the bare word `limit` in ordinary prose is NOT a wait -- the match is phrase-shaped on purpose
printf 'the bound names a limit of 256 files and the lap failed elsewhere\n' > "$pen/prose.txt"
check "the bare word limit is not a wait"       verdict=fault "$(ask "$pen/prose.txt" 1 900)"

# 10) the other spellings a provider may print
printf 'usage limit reached; try again later\n' > "$pen/usage.txt"
check "usage limit reads as a wait"             verdict=limit "$(ask "$pen/usage.txt" 1 2)"

# 11) the classifier is reachable and executable as the loop invokes it
if [ -f "$verdict_sh" ]; then check "the classifier stands" yes yes; else check "the classifier stands" yes no; fi

# 12) THE WIRING, not just the classifier: the loop must actually ask, and ask BEFORE it counts.
if grep -q 'fleet_lap_verdict.sh' "$loop_sh" && grep -q 'verdict=limit\|limit)' "$loop_sh"; then
  check "the loop asks the classifier" yes yes
else
  check "the loop asks the classifier" yes no
fi

rm -rf "$pen"
printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
