#!/bin/sh
# fleet-loop.sh -- one outer loop for every prompt-file seat: silence, hush, dream.
#
# ANCHORED TO ITS OWN TREE (Keaton's word 20260829: a loop sources from its own folder
# only). The script cds to the tree that CONTAINS it -- never the caller's cwd -- so a
# bench holding sibling trees (~/grain-silence; the pier's ~/grain-dream and ~/grain-hush)
# can never run one seat's laps against another seat's checkout.
#
# THE PROMPT IS A FILE, tools/l/<seat>_seat_prompt.txt, never an inline shell string: an
# apostrophe inside a single-quoted one-liner strands the shell at its continuation prompt,
# which is how Silence's loop broke the night the claim-as-override sentence -- three
# honest apostrophes -- joined the seat text (20260829).
#
# THE DEADLINE IS EPOCH ARITHMETIC: now plus LOOP_HOURS * 3600 (default 18), because
# `date -v` is BSD-only and `date -d` GNU-only, and this fleet spans a Mac and a Linux
# pier. LOOP_LAPS bounds the lap count when set (0, the default, means unbounded); the
# one-round-once recipe is LOOP_LAPS=1.
#
#   sh tools/l/fleet-loop.sh silence
#   LOOP_LAPS=1 sh tools/l/fleet-loop.sh hush
#   LOOP_HOURS=6 sh tools/l/fleet-loop.sh dream
#
# Transcripts land INSIDE the tree (session-output/<seat>.txt rendered, <seat>.jsonl raw
# for the claude seats), per the read-scope law's shared window -- /tmp is not durable in
# every enclosure. The gates-only sentinel is a file because the stream echoes the prompt,
# which contains the words GATES-ONLY, so a grep on the stream would false-stop.
set -eu

seat=${1:-}
case "$seat" in
silence | hush | dream) ;;
*)
  echo "usage: sh tools/l/fleet-loop.sh silence|hush|dream   [LOOP_HOURS=18] [LOOP_LAPS=0]"
  exit 2
  ;;
esac

# invariant: the tree this script lives in is the tree it runs against.
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$root"
[ -f construction/ITINERARY.md ] || { echo "fleet-loop: $root is not a tree root (no construction/ITINERARY.md)"; exit 2; }

prompt_file=tools/l/${seat}_seat_prompt.txt
[ -f "$prompt_file" ] || { echo "fleet-loop: missing seat prompt $prompt_file"; exit 2; }

hours=${LOOP_HOURS:-18}
max_laps=${LOOP_LAPS:-0}
deadline=$(( $(date +%s) + hours * 3600 ))
laps=0
mkdir -p session-output

echo "fleet-loop: seat=$seat root=$root hours=$hours laps=${max_laps:-unbounded}"

run_lap() {
  case "$seat" in
  dream)
    # codex exec prints human-readable turns already; the tee is the whole tail.
    ./tools/ag/agent-jail.sh codex exec --sandbox danger-full-access "$(cat "$prompt_file")" 2>&1 \
      | tee "session-output/${seat}.txt"
    ;;
  *)
    claude --dangerously-skip-permissions --effort max --output-format stream-json --verbose \
      -p "$(cat "$prompt_file")" \
      | tee "session-output/${seat}.jsonl" \
      | jq -Rrj -f tools/s/stream_render.jq \
      | tee "session-output/${seat}.txt"
    ;;
  esac
}

while [ "$(date +%s)" -lt "$deadline" ]; do
  rm -f .loop-gates-only
  if ! sh tools/f/fleet_round_open.sh; then
    echo 'ROUND-OPEN: fetch refused; retrying in 60s'
    sleep 60
    continue
  fi
  run_lap || echo "fleet-loop: lap exited nonzero; the next round-open pull resumes the thread"
  laps=$((laps + 1))
  if [ -f .loop-gates-only ]; then
    echo 'GATES-ONLY: loop paused'
    break
  fi
  if [ "$max_laps" -gt 0 ] && [ "$laps" -ge "$max_laps" ]; then
    echo "fleet-loop: LOOP_LAPS=$max_laps reached"
    break
  fi
  sleep 20
done
echo "fleet-loop: $seat ended after $laps lap(s) at $(TZ=America/New_York date)"
