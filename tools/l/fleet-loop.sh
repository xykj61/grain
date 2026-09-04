#!/bin/sh
# fleet-loop.sh -- one outer loop for every prompt-file seat.
#
# Earth ships (Cursor Grok; names seated 20260904 on Keaton's word):
# incense, pheromone, petrichor. Elder seat names furrow and harvest remap
# to pheromone and petrichor, then refuse unless the tree basename matches.
# Elder aether seats (Claude Code / Codex): silence, hush, dream -- kept.
#
# ANCHORED TO ITS OWN TREE (Keaton's word 20260829: a loop sources from its own folder
# only). The script cds to the tree that CONTAINS it -- never the caller's cwd -- so a
# bench holding sibling trees can never run one seat's laps against another checkout.
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
#   sh tools/l/fleet-loop.sh incense
#   LOOP_LAPS=1 sh tools/l/fleet-loop.sh pheromone
#   LOOP_HOURS=6 sh tools/l/fleet-loop.sh petrichor
#   FLEET_DRY=1 sh tools/l/fleet-loop.sh incense   # print the command; run nothing
#
# Transcripts land INSIDE the tree (session-output/<seat>.txt rendered, <seat>.jsonl raw
# for the claude seats), per the read-scope law's shared window -- /tmp is not durable in
# every enclosure. The gates-only sentinel is a file because the stream echoes the prompt,
# which contains the words GATES-ONLY, so a grep on the stream would false-stop. jq runs
# --unbuffered: with a tee behind it its stdout is a pipe rather than a tty, and a
# block-buffering jq shows a silent terminal until kilobytes accumulate (20260829).
#
# Cursor print mode takes the prompt as an argv word after the flags (SOURCE.md).
# Linux wraps in agent-jail.sh with --trust --sandbox disabled. Darwin passes --force
# only (this Mac refused --trust/--sandbox on 20260903). Machines are doors: the same
# seat uses the host's wrap. CURSOR_MODEL defaults to cursor-grok-4.6-xhigh
# (unattended); a watched lap may set CURSOR_MODEL=cursor-grok-4.6-high.
# agent-jail.sh is Linux-only (GNU readlink -f).
set -eu

seat=${1:-}
case "$seat" in
furrow)
  echo "fleet-loop: furrow is now pheromone (Keaton's word 20260904)"
  seat=pheromone
  ;;
harvest)
  echo "fleet-loop: harvest is now petrichor (Keaton's word 20260904)"
  seat=petrichor
  ;;
esac
case "$seat" in
incense | pheromone | petrichor | silence | hush | dream) ;;
*)
  echo "usage: sh tools/l/fleet-loop.sh incense|pheromone|petrichor|silence|hush|dream   [LOOP_HOURS=18] [LOOP_LAPS=0] [FLEET_DRY=1] [CURSOR_MODEL=cursor-grok-4.6-xhigh]"
  exit 2
  ;;
esac

# invariant: the tree this script lives in is the tree it runs against.
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$root"
[ -f construction/ITINERARY.md ] || { echo "fleet-loop: $root is not a tree root (no construction/ITINERARY.md)"; exit 2; }

prompt_file=tools/l/${seat}_seat_prompt.txt
[ -f "$prompt_file" ] || { echo "fleet-loop: missing seat prompt $prompt_file"; exit 2; }

# invariant: a seat runs only in its own tree (%291). The field ~/grain is the
# captain's GUI sitting, not an unattended loop tree. Machines are doors.
want_tree=
case "$seat" in
incense) want_tree=grain-incense ;;
pheromone) want_tree=grain-pheromone ;;
petrichor) want_tree=grain-petrichor ;;
silence) want_tree=grain-silence ;;
hush) want_tree=grain-hush ;;
dream) want_tree=grain-dream ;;
esac
base=$(basename "$root")
if [ "$base" != "$want_tree" ]; then
  echo "fleet-loop: seat $seat belongs in $want_tree; this tree is $base -- refusing"
  exit 2
fi

hours=${LOOP_HOURS:-18}
max_laps=${LOOP_LAPS:-0}
cursor_model=${CURSOR_MODEL:-cursor-grok-4.6-xhigh}
deadline=$(( $(date +%s) + hours * 3600 ))
laps=0
mkdir -p session-output

echo "fleet-loop: seat=$seat root=$root hours=$hours laps=${max_laps:-unbounded}"

# Print the command a lap would run. Linux wraps in agent-jail; Darwin does not.
# The prompt stays a file -- never inlined here.
cursor_lap_cmd() {
  case "$seat" in
  incense | pheromone | petrichor)
    if [ "$(uname -s)" = Linux ]; then
      printf '%s\n' "./tools/ag/agent-jail.sh cursor-agent -p --force --trust --sandbox disabled --output-format text --model ${cursor_model} <${prompt_file} as argv"
    else
      printf '%s\n' "cursor-agent -p --force --output-format text --model ${cursor_model} <${prompt_file} as argv"
    fi
    ;;
  esac
}

if [ "${FLEET_DRY:-0}" = 1 ]; then
  echo "fleet-loop: FLEET_DRY=1 -- command only, no round-open, no lap"
  case "$seat" in
  incense | pheromone | petrichor)
    cursor_lap_cmd
    ;;
  dream)
    echo "./tools/ag/agent-jail.sh codex exec --sandbox danger-full-access <${prompt_file} as argv"
    ;;
  *)
    echo "claude --dangerously-skip-permissions --effort max --output-format stream-json --verbose -p <${prompt_file}>"
    ;;
  esac
  exit 0
fi

run_cursor() {
  _prompt=$(cat "$prompt_file")
  echo "fleet-loop: invoking cursor-agent model=$cursor_model -- Read/Grep lines come from the agent; silence after this line is the API, not round-open"
  if [ "$(uname -s)" = Linux ]; then
    ./tools/ag/agent-jail.sh cursor-agent -p --force --trust --sandbox disabled \
      --output-format text --model "$cursor_model" "$_prompt" 2>&1 \
      | tee "session-output/${seat}.txt"
  else
    cursor-agent -p --force --output-format text --model "$cursor_model" \
      "$_prompt" 2>&1 \
      | tee "session-output/${seat}.txt"
  fi
}

run_lap() {
  case "$seat" in
  incense | pheromone | petrichor)
    run_cursor
    ;;
  dream)
    ./tools/ag/agent-jail.sh codex exec --sandbox danger-full-access "$(cat "$prompt_file")" 2>&1 \
      | tee "session-output/${seat}.txt"
    ;;
  *)
    claude --dangerously-skip-permissions --effort max --output-format stream-json --verbose \
      -p "$(cat "$prompt_file")" \
      | tee "session-output/${seat}.jsonl" \
      | jq --unbuffered -Rrj -f tools/s/stream_render.jq \
      | tee "session-output/${seat}.txt"
    ;;
  esac
}

while [ "$(date +%s)" -lt "$deadline" ]; do
  rm -f .loop-gates-only
  echo "fleet-loop: lap $((laps + 1)) opens at $(TZ=America/New_York date +%H:%M:%S)"
  if ! sh tools/f/fleet_round_open.sh; then
    echo 'ROUND-OPEN: fetch refused; retrying in 60s'
    sleep 60
    continue
  fi
  rc=0
  run_lap || rc=$?
  if [ "$rc" -eq 130 ] || [ "$rc" -eq 143 ]; then
    echo "fleet-loop: interrupted (exit $rc) -- this attempt is not a counted lap"
    break
  fi
  if [ "$rc" -ne 0 ]; then
    echo "fleet-loop: lap exited $rc; the next round-open pull resumes the thread"
  fi
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
