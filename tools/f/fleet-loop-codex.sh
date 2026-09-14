#!/bin/sh
# fleet-loop-codex.sh -- the fleet loop, molted for Codex, and BARE by construction.
#
#   sh tools/f/fleet-loop-codex.sh <seat> [LOOP_HOURS=18] [LOOP_LAPS=0]
#
# A MUTANT OF `fleet-loop.sh`, not a replacement: that file keeps the Claude seats and this one
# carries the Codex seats, so neither has a branch the other must read past. Seated `20260909` on
# Keaton's word, with two clauses he named: **bare**, and **loose**.
#
# BARE BY CONSTRUCTION. This pier runs without jails (Keaton's word `20260906`), so there is no
# enclosure branch here at all -- not a flag defaulting to bare, which is a flag somebody can flip
# at 3am. `codex` runs on the host, in this tree, full stop.
#
# LOOSE ON PURPOSE, and this is the trade said out loud. The paid Codex account has weeks left and
# the point of the night is that laps KEEP GOING while a hand sleeps. So: no `--strict-config`,
# approvals bypassed, and every failure short of a spent deadline is a HOLD rather than a stop.
#
# THE CUSTODY GATES ARE THE ONE THING NOT LOOSENED. `.loop-gates-only` and `.loop-drain` still stop
# this loop, because those are how an agent and a hand say stop, and a loop that cannot be stopped
# is worse than a loop that stopped early.
#
# WHAT THE ARCHIVED CODEX RUN TAUGHT (`tools/c/chatgpt-mind.sh`, the MIND lane):
#   - Codex needs its own CODEX_HOME kept inside this repository, so a lap cannot write into a host
#     home nobody is watching.
#   - Its logs grow unbounded unless a bound is named.
#   - A failure ceiling with backoff beats an immediate exit, since most Codex failures are
#     transport and clear on their own.
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
  echo "fleet-loop-codex: $seat belongs in $want_tree; refusing $root"
  exit 2
}
prompt_room=$(printf '%s' "$seat" | cut -c1)
seat_prompt="tools/$prompt_room/${seat}_seat_prompt.txt"
[ -r "$seat_prompt" ] || { echo "fleet-loop-codex: missing $seat_prompt"; exit 2; }

mkdir -p session-output loops/codex
# A kernel lock releases on exit, including an interrupted launch.
exec 9>loops/codex/writer.lock
flock -n 9 || { echo "fleet-loop-codex: another loop owns this checkout"; exit 2; }
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
  case "$value" in ''|*[!0-9]*) echo 'fleet-loop-codex: counts must be nonnegative integers'; exit 2 ;; esac
done

# CODEX_HOME IS INHERITED, NOT OVERRIDDEN, and this cost the first real lap (`20260909.003009`).
# The elder shape pointed it at `loops/codex/home` inside the tree, following the MIND lane's rule
# that a lap must not write into a host home nobody watches. That directory holds no AUTH -- `codex
# login` writes to `~/.codex` -- so the lap answered `401 Unauthorized` while the probe above had
# already printed `auth live`.
#
# THE PROBE PASSED AND THE LAP FAILED, which is the part worth keeping. Both ran under the same
# CODEX_HOME, so the probe was not measuring what the lap needed: a `read-only` call and a
# full-access call reach credentials by different paths, and a check that does not exercise the
# path the WORK takes certifies the wrong thing. The probe now runs with the same flags the lap
# does, below.
#
# The trade is named rather than hidden: a lap can write into the host's `~/.codex`. That is
# acceptable here because this pier runs bare by Keaton's word, so the enclosure question is
# already settled that way -- and an unauthenticated loop is worth nothing at all.

# THE AUTH CHECK RUNS ONCE, BEFORE THE FIRST LAP. An unauthenticated Codex answers 401 in about a
# second, so an unchecked loop burns a whole night at three laps a minute doing nothing and reports
# a full night's work. Measured `20260909`: this pier answered `401 Unauthorized: Missing bearer or
# basic authentication` until a hand ran `codex login`.
# THE MODEL IS NAMED HERE, once, and both the probe and the lap read the same name -- a probe on a
# different model proves nothing about the model the work runs on. GPT-6-Astra became the bundled
# default in codex 0.153.4 and could not be reached at all from 0.150.1, which answered
# `400 invalid_request`; the pier was rebuilt to 0.153.4 on `20260909` for exactly this.
# Fleet default selected by Keaton on 20260912. Explicit CODEX_MODEL overrides remain supported.
CODEX_MODEL=${CODEX_MODEL:-gpt-5.6-sol}

# Read the final response, never the transcript that also echoes the request.
probe_reply="loops/codex/${seat}-probe-reply.txt"
rm -f "$probe_reply"
if timeout 90 codex exec -m "$CODEX_MODEL" \
  --dangerously-bypass-approvals-and-sandbox \
  --dangerously-bypass-hook-trust \
  --skip-git-repo-check -C "$root" -o "$probe_reply" \
  "Reply with exactly: CODEX_ALIVE" > "loops/codex/${seat}-probe.txt" 2>&1 \
  && [ "$(cat "$probe_reply" 2>/dev/null)" = CODEX_ALIVE ]; then
  echo "fleet-loop-codex: auth live"
else
  echo "fleet-loop-codex: REFUSED -- probe failed; read loops/codex/${seat}-probe.txt"
  tail -5 "loops/codex/${seat}-probe.txt"
  exit 3
fi

deadline=$(( $(date +%s) + hours * 3600 ))
laps=0
fails=0
fail_ceiling=${LOOP_FAIL_CEILING:-8}
backoff=${LOOP_BACKOFF:-30}

echo "fleet-loop-codex: seat $seat, bare, ${hours}h deadline, model $CODEX_MODEL, CODEX_HOME inherited"

while [ "$(date +%s)" -lt "$deadline" ]; do
  # A HAND'S STOP IS READ BEFORE A LAP OPENS and is never removed by this loop -- the same law the
  # Claude loop carries. `.loop-gates-only` is the agent's own stop and clears at the top.
  # CLOCKOUT (molted from `drain`, `20260909`). The elder name is still read while loops run it.
  if stop_requested; then
    echo "CLOCKOUT: $seat stopping before lap $((laps + 1)) -- remove .loop-clockout to clock in again"
    break
  fi
  rm -f .loop-gates-only

  echo "fleet-loop-codex: lap $((laps + 1)) opens at $(TZ=America/New_York date +%H:%M:%S)"
  if ! sh tools/f/fleet_round_open.sh; then
    echo "fleet-loop-codex: round-open refused; holding before retry"
    sleep "$hold"
    continue
  fi
  stop_requested && break
  [ -r "$seat_prompt" ] && [ -r tools/f/fleet_baton.txt ] || {
    echo "fleet-loop-codex: prompt missing after round-open"; exit 2;
  }

  prompt_file="loops/codex/${seat}-prompt.txt"
  {
    cat tools/f/fleet_baton.txt
    echo
    cat "$seat_prompt"
    echo
    echo "YOU ARE ${seat} -- Codex, running bare on the pier, in this tree."
    echo "Log configured_model $CODEX_MODEL and configured_status explicit fleet CLI selection; evidence: fleet-loop-codex.sh passes -m $CODEX_MODEL. Verify the active model separately from runtime evidence."
    echo "The seat stanza's Claude attribution is historical; this lap uses Codex. Keep its lane."
    echo "Read expanding-prompts/20260909-003000_the-codex-fleet-molt-and-the-401.md and expanding-prompts/20260908-161500_incense-handoff-a-fresh-window.md."
    echo "Follow the handoff to expanding-prompts/20260908-160500_fifteen-asks-sorted-for-the-fleet.md and expanding-prompts/20260908-155715_the-scrub-that-remembers.md. Honor their remaining gates."
    echo "Recover unfinished work and session logs from this seat's stashes before new work; inspect git stash list and the newest seat transcript. Never discard a parked lap."
    echo "At the send, preserve the lap-open head and xy/main before the second fetch; run sh tools/f/fleet_moved_proof.sh LAP_OPEN_HEAD XY_BEFORE xy/main. A full verdict owes the full hot roster; scoped is lawful only on an independent mapped closure."
    echo "Close every lap with a commit and a session log, and push xy then gp405."
  } > "$prompt_file"

  set +e
  # Keep the producer's exit status across tee on POSIX shells without pipefail.
  status_file="loops/codex/${seat}-exit-status"
  rm -f "$status_file"
  (
  timeout "${LOOP_LAP_SECONDS:-5400}" codex exec -m "$CODEX_MODEL" \
    --sandbox danger-full-access \
    --dangerously-bypass-approvals-and-sandbox \
    --dangerously-bypass-hook-trust \
    --skip-git-repo-check \
    -C "$root" \
    - < "$prompt_file" 2>&1
  printf '%s\n' "$?" > "$status_file"
  ) | tee "session-output/${seat}.txt"
  tee_code=$?
  code=$(cat "$status_file" 2>/dev/null) || code=125
  [ "$tee_code" -eq 0 ] || code=$tee_code
  set -e

  laps=$((laps + 1))

  if [ "$code" -ne 0 ]; then
    fails=$((fails + 1))
    echo "fleet-loop-codex: lap $laps exited $code (failure $fails of $fail_ceiling)"
    if [ "$fails" -ge "$fail_ceiling" ]; then
      # A HOLD, NEVER A STOP. Most Codex failures are transport and clear on their own, and a night
      # that ends at 2am because a handful of requests failed is the outcome this loop prevents.
      echo "fleet-loop-codex: holding ${hold}s and continuing -- failures reset after a clean lap"
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
    echo "fleet-loop-codex: LOOP_LAPS=$max_laps reached"
    break
  fi
  sleep 20
done
echo "fleet-loop-codex: $seat ended after $laps lap(s) at $(TZ=America/New_York date)"
