#!/bin/sh
# fleet-loop-opencode.sh -- the fleet loop, molted for OpenCode + DeepSeek, BARE by construction.
#
#   sh tools/f/fleet-loop-opencode.sh <seat> [LOOP_HOURS=18] [LOOP_LAPS=0]
#
# A MUTANT OF `fleet-loop.sh`, not a replacement: that file keeps the Claude seats,
# `fleet-loop-codex.sh` keeps the Codex seats, and this one carries the OpenCode seats. Seated
# `20260921` on Keaton's word, with the same two clauses the Codex molt carried: **bare**, and
# **loose**.
#
# BARE BY CONSTRUCTION. This pier runs without jails (Keaton's word `20260906`), so there is no
# enclosure branch here at all -- not a flag defaulting to bare, which is a flag somebody can flip
# at 3am. `opencode` runs on the host, in this tree, full stop.
#
# LOOSE ON PURPOSE, and this is the trade said out loud. The point of the night is that laps KEEP
# GOING while a hand sleeps. So approvals are bypassed (`--dangerously-skip-permissions`) and every
# failure short of a spent deadline is a HOLD rather than a stop.
#
# THE CUSTODY GATES ARE THE ONE THING NOT LOOSENED. `.loop-gates-only` and `.loop-drain` still stop
# this loop, because those are how an agent and a hand say stop, and a loop that cannot be stopped
# is worse than a loop that stopped early.
#
# THE MODEL IS NAMED ONCE. OpenCode reaches DeepSeek V4 Pro through Together AI -- the same provider
# and model `open/HARNESS_SETUP.md` proved live on this pier -- and both the probe and the lap read
# the same name, so a probe on a different model proves nothing about the model the work runs on.
set -eu

seat=${1:-incense}
hours=${LOOP_HOURS:-18}
max_laps=${LOOP_LAPS:-0}
hold=${LOOP_LIMIT_WAIT:-300}
root=$(cd "$(dirname "$0")/../.." && pwd -P)
cd "$root"

roster_scan=tools/fixtures/f/fleet_roster_scan.sh
want_tree=$(sh "$roster_scan" --tree "$seat")
[ "$(basename "$root")" = "$want_tree" ] || {
  echo "fleet-loop-opencode: $seat belongs in $want_tree; refusing $root"
  exit 2
}
prompt_room=$(printf '%s' "$seat" | cut -c1)
seat_prompt="tools/$prompt_room/${seat}_seat_prompt.txt"
[ -r "$seat_prompt" ] || { echo "fleet-loop-opencode: missing $seat_prompt"; exit 2; }

mkdir -p session-output loops/opencode
# A kernel lock releases on exit, including an interrupted launch.
exec 9>loops/opencode/writer.lock
flock -n 9 || { echo "fleet-loop-opencode: another loop owns this checkout"; exit 2; }
stop_requested() {
  for marker in .loop-clockout .loop-drain .mind-state/CUSTODY .mind-state/TRANSACTION; do
    if [ -f "$marker" ]; then
      echo "CLOCKOUT: $seat held by $marker"
      return 0
    fi
  done
  return 1
}
stop_requested && exit 0
for value in "$hours" "$max_laps" "$hold" "${LOOP_FAIL_CEILING:-8}" "${LOOP_BACKOFF:-30}"; do
  case "$value" in ''|*[!0-9]*) echo 'fleet-loop-opencode: counts must be nonnegative integers'; exit 2 ;; esac
done

# THE MODEL IS NAMED HERE, once, and both the probe and the lap read the same name. DeepSeek V4 Pro
# through Together AI is the model `open/HARNESS_SETUP.md` proved live on this pier. Explicit
# OPENCODE_MODEL overrides remain supported.
OPENCODE_MODEL=${OPENCODE_MODEL:-together/deepseek-ai/DeepSeek-V4-Pro-0813}

# THE AUTH CHECK RUNS ONCE, BEFORE THE FIRST LAP. An unauthenticated OpenCode answers in about a
# second, so an unchecked loop burns a whole night doing nothing and reports a full night's work.
# The probe runs with the same model the lap does, so it certifies the path the work takes.
probe_reply="loops/opencode/${seat}-probe.txt"
rm -f "$probe_reply"
if timeout 90 opencode run -m "$OPENCODE_MODEL" \
  "Reply with exactly: OPENCODE_ALIVE" > "$probe_reply" 2>&1 \
  && grep -q OPENCODE_ALIVE "$probe_reply"; then
  echo "fleet-loop-opencode: auth live"
else
  echo "fleet-loop-opencode: REFUSED -- probe failed; read $probe_reply"
  tail -5 "$probe_reply"
  exit 3
fi

deadline=$(( $(date +%s) + hours * 3600 ))
laps=0
fails=0
fail_ceiling=${LOOP_FAIL_CEILING:-8}
backoff=${LOOP_BACKOFF:-30}

echo "fleet-loop-opencode: seat $seat, bare, ${hours}h deadline, model $OPENCODE_MODEL"

while [ "$(date +%s)" -lt "$deadline" ]; do
  # A HAND'S STOP IS READ BEFORE A LAP OPENS and is never removed by this loop -- the same law the
  # Claude and Codex loops carry. `.loop-gates-only` is the agent's own stop and clears at the top.
  if stop_requested; then
    echo "CLOCKOUT: $seat stopping before lap $((laps + 1)) -- remove .loop-clockout to clock in again"
    break
  fi
  rm -f .loop-gates-only

  echo "fleet-loop-opencode: lap $((laps + 1)) opens at $(TZ=America/New_York date +%H:%M:%S)"
  if ! sh tools/f/fleet_round_open.sh; then
    echo "fleet-loop-opencode: round-open refused; holding before retry"
    sleep "$hold"
    continue
  fi
  stop_requested && break
  [ -r "$seat_prompt" ] && [ -r tools/f/fleet_baton.txt ] || {
    echo "fleet-loop-opencode: prompt missing after round-open"; exit 2;
  }

  prompt_file="loops/opencode/${seat}-prompt.txt"
  {
    cat tools/f/fleet_baton.txt
    echo
    cat "$seat_prompt"
    echo
    echo "YOU ARE ${seat} -- OpenCode, running bare on the pier, in this tree."
    echo "Log configured_model $OPENCODE_MODEL and configured_status explicit fleet CLI selection; evidence: fleet-loop-opencode.sh passes -m $OPENCODE_MODEL. Verify the active model separately from runtime evidence."
    echo "The seat stanza's Claude attribution is historical; this lap uses OpenCode + DeepSeek. Keep its lane."
    echo "Read open/HARNESS_SETUP.md and open/README.md for the harness and provider this lap runs on."
    echo "Follow the handoff to expanding-prompts/20260908-160500_fifteen-asks-sorted-for-the-fleet.md and expanding-prompts/20260908-155715_the-scrub-that-remembers.md. Honor their remaining gates."
    echo "Recover unfinished work and session logs from this seat's stashes before new work; inspect git stash list and the newest seat transcript. Never discard a parked lap."
    echo "At the send, preserve the lap-open head and xy/main before the second fetch; run sh tools/f/fleet_moved_proof.sh LAP_OPEN_HEAD XY_BEFORE xy/main. A full verdict owes the full hot roster; scoped is lawful only on an independent mapped closure."
    echo "Close every lap with a commit and a session log, and push xy then debrided."
  } > "$prompt_file"

  set +e
  # Keep the producer's exit status across tee on POSIX shells without pipefail.
  status_file="loops/opencode/${seat}-exit-status"
  rm -f "$status_file"
  (
  timeout "${LOOP_LAP_SECONDS:-5400}" opencode run -m "$OPENCODE_MODEL" \
    --dangerously-skip-permissions \
    "$(cat "$prompt_file")" 2>&1
  printf '%s\n' "$?" > "$status_file"
  ) | tee "session-output/${seat}.txt"
  tee_code=$?
  code=$(cat "$status_file" 2>/dev/null) || code=125
  [ "$tee_code" -eq 0 ] || code=$tee_code
  set -e

  laps=$((laps + 1))

  if [ "$code" -ne 0 ]; then
    fails=$((fails + 1))
    echo "fleet-loop-opencode: lap $laps exited $code (failure $fails of $fail_ceiling)"
    if [ "$fails" -ge "$fail_ceiling" ]; then
      # A HOLD, NEVER A STOP. Most OpenCode failures are transport and clear on their own, and a
      # night that ends at 2am because a handful of requests failed is the outcome this loop prevents.
      echo "fleet-loop-opencode: holding ${hold}s and continuing -- failures reset after a clean lap"
      sleep "$hold"
      fails=0
    else
      sleep "$backoff"
    fi
  else
    fails=0
  fi

  if [ -f .loop-gates-only ]; then echo 'GATES-ONLY: loop paused'; break; fi
  if stop_requested; then
    echo "CLOCKOUT: $seat stopped after lap $laps -- the lap finished whole"
    break
  fi
  if [ "$max_laps" -gt 0 ] && [ "$laps" -ge "$max_laps" ]; then
    echo "fleet-loop-opencode: LOOP_LAPS=$max_laps reached"
    break
  fi
  sleep 20
done
echo "fleet-loop-opencode: $seat ended after $laps lap(s) at $(TZ=America/New_York date)"
