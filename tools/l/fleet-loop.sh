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

# invariant: the tree this script lives in is the tree it runs against. The cd comes BEFORE the
# seat is checked, because the seat table now lives in the tree rather than in this file.
root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
cd "$root"
[ -f construction/ITINERARY.md ] || { echo "fleet-loop: $root is not a tree root (no construction/ITINERARY.md)"; exit 2; }

# ONE SEAT TABLE, READ RATHER THAN SPELLED (REDS %409). This file used to carry four independent
# seat tables -- the allow-list, want_tree, and the two engine cases -- and fleet_rearm.sh carried
# two more, six in all with nothing comparing them. Two had already drifted by `20260904`: this
# loop admitted six seat names while the re-arm reported nine, and the elder-name remap seated on
# Keaton's word lived here and not there. All six are lookups into construction/fleet-roster.kyri
# now, so a ship joins, retires, or is renamed in one row.
roster_scan=tools/fixtures/f/fleet_roster_scan.sh
[ -f "$roster_scan" ] || { echo "fleet-loop: missing $roster_scan -- the seat table is unreadable"; exit 2; }

# An elder name answers with its living seat and says so; anything else answers with itself.
resolved=$(sh "$roster_scan" --resolve "$seat" 2>/dev/null || true)
if [ -n "$resolved" ] && [ "$resolved" != "$seat" ]; then
  echo "fleet-loop: $seat is now $resolved (construction/fleet-roster.kyri)"
  seat=$resolved
fi
if ! sh "$roster_scan" --seats | grep -qx "$seat"; then
  echo "usage: sh tools/l/fleet-loop.sh <seat>   [LOOP_HOURS=18] [LOOP_LAPS=0] [FLEET_DRY=1] [FLEET_BARE=1]"
  echo "seats: $(sh "$roster_scan" --live | tr '\n' ' ')(live)  $(sh "$roster_scan" --seats | tr '\n' ' ')(all)"
  exit 2
fi
engine=$(sh "$roster_scan" --engine "$seat")

prompt_file=tools/l/${seat}_seat_prompt.txt
[ -f "$prompt_file" ] || { echo "fleet-loop: missing seat prompt $prompt_file"; exit 2; }

# THE BATON IS PREPENDED, NOT COPIED INTO EVERY SEAT (REDS %409's lesson, one room over). Every
# ship shares one opening -- voice, card, rota, thread, fleet, claim, send, log, pins, custody,
# close -- and it used to be restated in each seat prompt, which is the same rule written six times
# and the same drift waiting. tools/l/fleet_baton.txt holds it once; a seat prompt is now its LANE
# STANZA alone. A directive seated on the baton reaches every ship on its next lap with no per-seat
# edit, which is the token economy the split was always for.
#
# Read into a variable rather than concatenated to a temporary file, because the prompt reaches the
# agent as one argv string and a file on disk would be a second thing to keep in step.
baton_file=tools/l/fleet_baton.txt
seat_prompt() {
  if [ -f "$baton_file" ]; then
    cat "$baton_file"
    printf '\n'
  fi
  cat "$prompt_file"
}

# invariant: a seat runs only in its own tree (%291). The field ~/grain is the
# captain's GUI sitting, not an unattended loop tree. Machines are doors.
want_tree=$(sh "$roster_scan" --tree "$seat")
base=$(basename "$root")
if [ "$base" != "$want_tree" ]; then
  echo "fleet-loop: seat $seat belongs in $want_tree; this tree is $base -- refusing"
  exit 2
fi

hours=${LOOP_HOURS:-18}
max_laps=${LOOP_LAPS:-0}
deadline=$(( $(date +%s) + hours * 3600 ))
laps=0
quickfail=0
lap_open=0
# A SPENT SESSION LIMIT IS A WAIT, NOT A FAULT, and it needs its own bounded counter (REDS %471).
# LOOP_LIMIT_WAIT is how long to hold between checks; LOOP_LIMIT_WAIT_MAX is how many holds before
# the loop stops and asks for a hand. 300s x 72 is six hours -- longer than any window this fleet
# has met, and short of an overnight spin nobody is watching. The deadline still bounds it.
limit_waits=0
limit_wait_seconds=${LOOP_LIMIT_WAIT:-300}
limit_wait_max=${LOOP_LIMIT_WAIT_MAX:-72}
mkdir -p session-output

echo "fleet-loop: seat=$seat engine=$engine root=$root hours=$hours laps=${max_laps:-unbounded}"


# Print the command a lap would run. Linux Earth ships wrap in agent-jail; Darwin does not.
# The prompt stays a file -- never inlined here.
earth_claude_cmd() {
  if [ "$(uname -s)" = Linux ] && [ "${FLEET_BARE:-0}" != 1 ]; then
    printf '%s\n' "./tools/ag/agent-jail.sh lap ${seat}   # flags live in tools/l/fleet_lap.sh (%414)"
  else
    printf '%s\n' "claude --dangerously-skip-permissions --effort max --output-format stream-json --verbose -p <${prompt_file}>"
  fi
}

if [ "${FLEET_DRY:-0}" = 1 ]; then
  echo "fleet-loop: FLEET_DRY=1 -- command only, no round-open, no lap"
  case "$engine" in
  claude) earth_claude_cmd ;;
  codex)  echo "./tools/ag/agent-jail.sh codex exec --sandbox danger-full-access <${prompt_file} as argv" ;;
  *)      echo "fleet-loop: seat $seat carries engine '$engine' -- no unattended loop for it"; exit 2 ;;
  esac
  exit 0
fi

# The stagger sits AFTER the dry-run exit on purpose: `FLEET_DRY=1` promises to print a command
# and run nothing, and a sleep is something. An elder draft placed it above and would have held
# a dry run for the seat's full offset.
# THE STAGGER -- a launch offset so ships' expensive phases interleave rather than collide.
#
# WHY AN OFFSET RATHER THAN A LOCK. The standing roster is the expensive phase, it is
# single-threaded, and it runs INSIDE the jail. Each jail binds exactly one tree and gets its own
# tmpfs `/tmp`, so no writable path is shared between ships and a cross-ship lock cannot be built
# on this pier at all. What the host CAN do is choose when each loop starts.
#
# WHAT IT BUYS, measured `20260905` on this 4-core pier: the same four guards take 7,980ms alone,
# 11,240ms with two competing cores (1.41x), and 22,451ms with five (2.81x). An offset helps only
# while the expensive phase is under 1/N of a lap -- with six ships and a roster near a quarter of
# each lap, overlap is arithmetic rather than luck, and no offset avoids it. So this is real relief
# at three or four ships and no answer at six. Say so rather than let a knob imply otherwise.
#
# The seat's own position in the live roster picks its slot, so adding a ship re-spaces the fleet
# with no per-seat number to keep in step.
stagger=${FLEET_STAGGER:-0}
if [ "$stagger" -gt 0 ] 2>/dev/null; then
  slot=$(sh "$roster_scan" --live 2>/dev/null | grep -nx "$seat" | cut -d: -f1)
  slot=${slot:-1}
  wait_s=$(( (slot - 1) * stagger ))
  if [ "$wait_s" -gt 0 ]; then
    echo "fleet-loop: stagger -- $seat is slot $slot, holding ${wait_s}s so laps interleave"
    sleep "$wait_s"
  fi
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
  _prompt=$(seat_prompt)
  echo "fleet-loop: invoking claude --output-format stream-json --verbose -- tool lines render live; silence after this line is the API, not round-open"
  if [ "$(uname -s)" = Linux ] && [ "${FLEET_BARE:-0}" != 1 ]; then
    if ! linux_jail_present; then
      echo "fleet-loop: ai-jail not on this host -- this attempt is not a counted lap"
      echo "fleet-loop: host install on NixOS: nix profile install github:akitaonrails/ai-jail"
      echo "fleet-loop: then pin AIJAIL_BIN in tools/e/enclosure.conf, or FLEET_BARE=1 LOOP_LAPS=1 for Darwin-style claude"
      return 4
    fi
    # THE FLAGS LIVE INSIDE THE JAIL (REDS %414). ai-jail owns `-v, --verbose` and refuses it after
    # the command even when `--` was passed, while Claude Code requires it beside
    # `--output-format stream-json`. `lap` runs tools/l/fleet_lap.sh with no flag in the jail's own
    # argv, and every flag claude needs is spelled in there.
    ./tools/ag/agent-jail.sh lap "$seat" | stream_claude
  else
    claude --dangerously-skip-permissions --effort max --output-format stream-json --verbose \
      -p "$_prompt" \
      | stream_claude
  fi
}

run_lap() {
  # The engine word comes off the roster, so `field` -- the interactive bench, which runs no
  # unattended loop -- refuses here by name rather than falling into a claude branch that would
  # start one. A seat with no engine would read as a row somebody forgot to finish; `field` is
  # finished, and this is what it means.
  case "$engine" in
  claude)
    run_earth_claude
    ;;
  codex)
    ./tools/ag/agent-jail.sh codex exec --sandbox danger-full-access "$(seat_prompt)" 2>&1 \
      | tee "session-output/${seat}.txt"
    ;;
  *)
    echo "fleet-loop: seat $seat carries engine '$engine' -- no unattended loop for it"
    return 4
    ;;
  esac
}

while [ "$(date +%s)" -lt "$deadline" ]; do
  rm -f .loop-gates-only
  lap_open=$(date +%s)
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
  # A LAP THAT DIES IN UNDER TEN SECONDS NEVER REACHED THE AGENT (REDS %414). Eight pheromone and
  # petrichor laps failed on an ai-jail flag refusal inside a second each, and the loop counted
  # every one and slept twenty seconds between them -- an eighteen-hour deadline of nothing at all.
  # Three consecutive instant failures stop the loop and say why, because the fault is upstream of
  # the agent and no number of retries will reach past it.
  #
  # AND THAT REASONING HAS ONE EXCEPTION, WHICH COST THE FLEET A MORNING (REDS %471). A spent
  # session limit is also upstream of the agent, returns just as instantly, and clears ON A CLOCK.
  # On `20260906` six ships met the limit between 07:21 and 07:28, burned three instant laps each,
  # and stopped themselves; the window reset at 07:30 and they sat dark until a hand read the panes.
  # So the lap is CLASSIFIED before it is counted, and the classifier asks about the limit first --
  # tools/fixtures/f/fleet_lap_verdict.sh, which a control proves on planted transcripts.
  elapsed=$(( $(date +%s) - lap_open ))
  verdict=$(sh tools/fixtures/f/fleet_lap_verdict.sh "session-output/${seat}.txt" "$rc" "$elapsed" 2>/dev/null || echo verdict=fault)
  verdict=${verdict#verdict=}
  case "$verdict" in
  ok)
    quickfail=0
    limit_waits=0
    ;;
  limit)
    # invariant: a wait is not a lap -- `laps` is untouched and `quickfail` is cleared, because the
    # agent answered. What it answered was "not yet".
    quickfail=0
    limit_waits=$((limit_waits + 1))
    if [ "$limit_waits" -ge "$limit_wait_max" ]; then
      echo "fleet-loop: the session limit has stood for $limit_waits holds -- stopping rather than circling; a hand is needed."
      break
    fi
    echo "fleet-loop: the session limit is spent -- a WAIT, not a fault; holding ${limit_wait_seconds}s (hold $limit_waits of $limit_wait_max) at $(TZ=America/New_York date +%H:%M:%S)"
    sleep "$limit_wait_seconds"
    continue
    ;;
  quickfail)
    limit_waits=0
    echo "fleet-loop: lap exited $rc in ${elapsed}s; the next round-open pull resumes the thread"
    quickfail=$((quickfail + 1))
    if [ "$quickfail" -ge 3 ]; then
      echo "fleet-loop: three laps died in under ten seconds each -- the agent was never reached."
      echo "fleet-loop: read the lines above; this is an invocation fault, not a lap that failed."
      echo "fleet-loop: try  ./tools/ag/agent-jail.sh lap $seat  by hand, or FLEET_BARE=1 to skip the jail."
      break
    fi
    ;;
  *)
    quickfail=0
    limit_waits=0
    echo "fleet-loop: lap exited $rc; the next round-open pull resumes the thread"
    ;;
  esac
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
