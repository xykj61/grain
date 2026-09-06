#!/bin/sh
# fleet_lap_verdict.sh -- classify one finished lap, so the loop can tell a WAIT from a FAULT.
#
# WHY THIS EXISTS. tools/f/fleet-loop.sh stops itself after three laps that each died in under ten
# seconds, on the reasoning that "the fault is upstream of the agent and no number of retries will
# reach past it." That reasoning is exactly right for an ai-jail flag refusal (REDS %414, the wound
# it was written for) and exactly wrong for a spent session limit, which is upstream of the agent
# AND clears on a clock. On `20260906` six of the eight ships met the limit between 07:21 and 07:28,
# each burned three instant laps against it, and each stopped itself. The limit reset at 07:30. The
# fleet then sat dark until a hand read the panes, because the one state that answers "wait nine
# minutes" was being read as the one state that answers "stop and fetch a person."
#
# THE ORDER IS THE WHOLE FIX: `limit` is asked BEFORE `quickfail`, because a limit refusal returns
# instantly and would otherwise be counted as an invocation fault by elapsed time alone.
#
#   sh tools/fixtures/f/fleet_lap_verdict.sh <transcript> <rc> <elapsed_seconds>
#
# Prints one line: `verdict=ok|limit|quickfail|fault`.
#   ok        -- the lap returned zero; nothing to decide
#   limit     -- the agent answered, and its answer was "the window is spent"; WAIT, do not count
#   quickfail -- the lap died in under ten seconds and said nothing about a limit; the agent was
#                never reached, and three of these still stop the loop
#   fault     -- the lap ran and failed; the next round-open pull resumes the thread
#
# BOUNDS: the transcript is read from its last 40 lines and at most 8,000 bytes -- enough to hold a
# refusal, too little to walk a lap's whole stream on every iteration. A transcript that is absent
# or unreadable classifies by elapsed time alone, which is the elder behavior and the safe default.
set -eu

transcript=${1:-}
rc=${2:-0}
elapsed=${3:-0}

quickfail_seconds=10   # the elder threshold, unchanged -- this file only asks a question first

if [ "$rc" = 0 ]; then
  echo "verdict=ok"
  exit 0
fi

# The words each provider prints when the window is spent. Matched case-insensitively and as
# phrases, so an ordinary sentence carrying the bare word "limit" does not read as a wait.
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  if tail -40 "$transcript" 2>/dev/null | tail -c 8000 \
     | grep -qiE 'session limit|usage limit|rate limit|limit . resets|limit will reset'; then
    echo "verdict=limit"
    exit 0
  fi
fi

if [ "$elapsed" -lt "$quickfail_seconds" ] 2>/dev/null; then
  echo "verdict=quickfail"
  exit 0
fi

echo "verdict=fault"
