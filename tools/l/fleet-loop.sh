#!/bin/sh
# fleet-loop.sh -- one outer loop for every prompt-file seat.
#
# Earth ships (names seated 20260904 on Keaton's word): incense, pheromone,
# petrichor. Unattended laps run Claude Code (stream-json --verbose), Darwin
# directly and Linux inside agent-jail.sh, matching launch-claude-chapter and
# the hush/silence renderer. Elder seat names furrow and harvest remap to
# pheromone and petrichor, then refuse unless the tree basename matches.
# Elder aether seats: silence, hush (Claude Code), dream (Codex) -- kept.
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
#   FLEET_BARE=1 LOOP_LAPS=1 sh tools/l/fleet-loop.sh incense  # Linux, no ai-jail
#
# Transcripts land INSIDE the tree (session-output/<seat>.txt rendered, <seat>.jsonl raw
# for Claude seats), per the read-scope law's shared window -- /tmp is not durable in
# every enclosure. The gates-only sentinel is a file because the stream echoes the prompt,
# which contains the words GATES-ONLY, so a grep on the stream would false-stop. jq runs
# --unbuffered: with a tee behind it its stdout is a pipe rather than a tty, and a
# block-buffering jq shows a silent terminal until kilobytes accumulate (20260829).
# Plain --verbose does not stream through a pipe (claude-code issue 733);
# --output-format stream-json --verbose emits one JSON event per line.
#
# Earth ships on Linux wrap in agent-jail.sh with --dangerously-skip-permissions
# (launch-claude-chapter). Darwin and FLEET_BARE=1 run claude on the host.
# agent-jail.sh is Linux-only (GNU readlink -f). Claude refuses the skip-permissions
# flag as root -- run as a plain user. FLEET_BARE=1 skips the Linux jail (opt-in; a
# missing ai-jail is a host install, not a counted lap).
set -eu
# Honor pipeline status when the shell knows how (bash). dash has no pipefail;
# a missing jail is then caught by the preflight below rather than by tee.
(set -o pipefail) 2>/dev/null && set -o pipefail

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
  echo "usage: sh tools/l/fleet-loop.sh incense|pheromone|petrichor|silence|hush|dream   [LOOP_HOURS=18] [LOOP_LAPS=0] [FLEET_DRY=1] [FLEET_BARE=1]"
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
deadline=$(( $(date +%s) + hours * 3600 ))
laps=0
mkdir -p session-output

echo "fleet-loop: seat=$seat root=$root hours=$hours laps=${max_laps:-unbounded}"

# Print the command a lap would run. Linux Earth ships wrap in agent-jail; Darwin does not.
# The prompt stays a file -- never inlined here.
earth_claude_cmd() {
  if [ "$(uname -s)" = Linux ] && [ "${FLEET_BARE:-0}" != 1 ]; then
    printf '%s\n' "./tools/ag/agent-jail.sh --dangerously-skip-permissions claude --effort max --output-format stream-json --verbose -p <${prompt_file}>"
  else
    printf '%s\n' "claude --dangerously-skip-permissions --effort max --output-format stream-json --verbose -p <${prompt_file}>"
  fi
}

if [ "${FLEET_DRY:-0}" = 1 ]; then
  echo "fleet-loop: FLEET_DRY=1 -- command only, no round-open, no lap"
  case "$seat" in
  incense | pheromone | petrichor)
    earth_claude_cmd
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

# Linux jail presence -- the same doors agent-jail.sh resolve_aijail walks, plus
# the NixOS profile the not-found message names. A missing binary is a host
# install (jail authors; host installs), never a counted lap.
linux_jail_present() {
  if [ -f tools/e/enclosure.conf ]; then
    # Same file agent-jail.sh sources. AIJAIL_BIN is the pin.
    # shellcheck disable=SC1091
    . tools/e/enclosure.conf
  fi
  if [ -n "${AIJAIL_BIN:-}" ] && [ -f "$AIJAIL_BIN" ] && [ -x "$AIJAIL_BIN" ]; then
    return 0
  fi
  if command -v ai-jail >/dev/null 2>&1; then
    return 0
  fi
  for c in \
    "$root/tools/.cache/bin/ai-jail" \
    "$root/gratitude/ai-jail/target/release/ai-jail" \
    "$HOME/.local/bin/ai-jail" \
    "$HOME/.nix-profile/bin/ai-jail" \
    /usr/local/bin/ai-jail \
    /usr/bin/ai-jail; do
    if [ -x "$c" ]; then
      return 0
    fi
  done
  return 1
}

# Claude Code stream: NDJSON to session-output/<seat>.jsonl, rendered text to <seat>.txt.
# jq --unbuffered so a tee-pipe does not block-buffer (20260829). Without jq, both
# files take the raw stream (hush/silence no-jq fallback; pier_jq_install.sh).
stream_claude() {
  if command -v jq >/dev/null 2>&1; then
    tee "session-output/${seat}.jsonl" \
      | jq --unbuffered -Rrj -f tools/s/stream_render.jq \
      | tee "session-output/${seat}.txt"
  else
    echo "fleet-loop: jq not on PATH -- raw NDJSON (Darwin: brew install jq; NixOS: sudo sh tools/p/pier_jq_install.sh)"
    tee "session-output/${seat}.jsonl" \
      | tee "session-output/${seat}.txt"
  fi
}

# Earth ships: Linux jail wrap like launch-claude-chapter; Darwin/FLEET_BARE host claude.
run_earth_claude() {
  _prompt=$(cat "$prompt_file")
  echo "fleet-loop: invoking claude --output-format stream-json --verbose -- tool lines render live; silence after this line is the API, not round-open"
  if [ "$(uname -s)" = Linux ] && [ "${FLEET_BARE:-0}" != 1 ]; then
    if ! linux_jail_present; then
      echo "fleet-loop: ai-jail not on this host -- this attempt is not a counted lap"
      echo "fleet-loop: host install on NixOS: nix profile install github:akitaonrails/ai-jail"
      echo "fleet-loop: then pin AIJAIL_BIN in tools/e/enclosure.conf, or FLEET_BARE=1 LOOP_LAPS=1 for Darwin-style claude"
      return 4
    fi
    ./tools/ag/agent-jail.sh --dangerously-skip-permissions claude \
      --effort max --output-format stream-json --verbose \
      -p "$_prompt" \
      | stream_claude
  else
    claude --dangerously-skip-permissions --effort max --output-format stream-json --verbose \
      -p "$_prompt" \
      | stream_claude
  fi
}

run_lap() {
  case "$seat" in
  incense | pheromone | petrichor)
    run_earth_claude
    ;;
  dream)
    ./tools/ag/agent-jail.sh codex exec --sandbox danger-full-access "$(cat "$prompt_file")" 2>&1 \
      | tee "session-output/${seat}.txt"
    ;;
  *)
    claude --dangerously-skip-permissions --effort max --output-format stream-json --verbose \
      -p "$(cat "$prompt_file")" \
      | stream_claude
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
  if [ "$rc" -eq 130 ] || [ "$rc" -eq 143 ] || [ "$rc" -eq 4 ]; then
    echo "fleet-loop: interrupted or invoke refused (exit $rc) -- this attempt is not a counted lap"
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
