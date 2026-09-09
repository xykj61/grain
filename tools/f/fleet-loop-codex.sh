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

mkdir -p session-output loops/codex

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
probe=$(timeout 90 codex exec \
  --sandbox danger-full-access \
  --dangerously-bypass-approvals-and-sandbox \
  --skip-git-repo-check \
  -C "$root" \
  "Reply with exactly: CODEX_ALIVE" 2>&1 || true)
case "$probe" in
  *CODEX_ALIVE*) echo "fleet-loop-codex: auth live" ;;
  *401*|*Unauthorized*)
    echo "fleet-loop-codex: REFUSED -- codex is not authenticated (401)."
    echo "fleet-loop-codex: run  codex login  in a terminal, then start this loop again."
    exit 3 ;;
  *)
    echo "fleet-loop-codex: REFUSED -- the auth probe returned neither CODEX_ALIVE nor a 401:"
    printf '%s\n' "$probe" | tail -3
    echo "fleet-loop-codex: read that before looping, rather than looping past it."
    exit 3 ;;
esac

deadline=$(( $(date +%s) + hours * 3600 ))
laps=0
fails=0
fail_ceiling=${LOOP_FAIL_CEILING:-8}
backoff=${LOOP_BACKOFF:-30}

echo "fleet-loop-codex: seat $seat, bare, ${hours}h deadline, CODEX_HOME=$CODEX_HOME_DIR"

while [ "$(date +%s)" -lt "$deadline" ]; do
  # A HAND'S STOP IS READ BEFORE A LAP OPENS and is never removed by this loop -- the same law the
  # Claude loop carries. `.loop-gates-only` is the agent's own stop and clears at the top.
  if [ -f .loop-drain ]; then
    echo "DRAIN: $seat stopping before lap $((laps + 1)) -- remove .loop-drain to resume"
    break
  fi
  rm -f .loop-gates-only

  echo "fleet-loop-codex: lap $((laps + 1)) opens at $(TZ=America/New_York date +%H:%M:%S)"
  sh tools/f/fleet_round_open.sh || echo "fleet-loop-codex: round-open refused; the lap still runs"

  prompt_file="loops/codex/${seat}-prompt.txt"
  {
    cat tools/f/fleet_baton.txt
    echo
    echo "YOU ARE ${seat} -- Codex, running bare on the pier, in this tree."
    echo "Close every lap with a commit and a session log, and push xy then debrided."
  } > "$prompt_file"

  set +e
  timeout "${LOOP_LAP_SECONDS:-5400}" codex exec \
    --sandbox danger-full-access \
    --dangerously-bypass-approvals-and-sandbox \
    --skip-git-repo-check \
    -C "$root" \
    - < "$prompt_file" 2>&1 | tee "session-output/${seat}.txt"
  code=$?
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
  if [ -f .loop-drain ]; then
    echo "DRAIN: $seat stopped after lap $laps -- the lap finished whole"
    break
  fi
  if [ "$max_laps" -gt 0 ] && [ "$laps" -ge "$max_laps" ]; then
    echo "fleet-loop-codex: LOOP_LAPS=$max_laps reached"
    break
  fi
  sleep 20
done
echo "fleet-loop-codex: $seat ended after $laps lap(s) at $(TZ=America/New_York date)"
