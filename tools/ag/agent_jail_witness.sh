#!/usr/bin/env bash
# agent_jail_witness.sh -- prove tools/ag/agent-jail.sh on Linux (keeper pier).
# Run from an ordinary host shell at the repo root, not from inside a jail.
#
# THE PATHS THIS READS ARE THE ONES THE LAUNCHER SPELLS. On 20260827 the six root state
# directories became one room, `loops/`, and this witness kept grepping the dry-run plan for
# `.claude-state` and `.cursor-agent-state` -- so it was RED at its first leg on a pier where the
# launcher was working perfectly, and unrostered, so nothing said so (REDS %408, kin to %360's
# unheard-guard class). A pin that names a moved path declares itself by turning the witness red,
# which is only an alarm if something is listening.
#
# OPTIONAL PIECES ARE PROVEN AS OPTIONAL. tools/e/enclosure.conf is a per-host pin most piers do
# not carry, and cursor-agent is an agent this fleet no longer runs by default; a guard that reds
# on a machine that simply lacks an optional thing is a guard someone turns off, so each is
# skipped by name and the skip is announced.
#
# TWO PARTS, BECAUSE HALF THESE LEGS NEED A JAIL AND HALF DO NOT. Everything above the enclosure
# marker reads plans, paths and seeded files, and runs anywhere. Everything below LAUNCHES the jail,
# and `bwrap` refuses to nest -- so on every ship that is itself jailed those legs answer
# `Failed to make / slave: Operation not permitted`, which is an environment fact rather than a
# fault in the launcher. Read as a failure it turned this guard red on eight of eight ships, and a
# red guard withholds the roster receipt, which makes `--scoped` refuse, which costs every ship a
# full cold pass every lap for a leg that could never have run there.
#
#   AGENT_JAIL_PART=base       the legs that run anywhere -- rostered as `agent_jail`
#   AGENT_JAIL_PART=enclosure  those, then the legs that launch the jail -- rostered as
#                              `agent_jail_enclosure` behind `capability jail_nesting`
#   AGENT_JAIL_PART=all        the default, and what a hand at a host prompt gets
#
# The capability is PROBED rather than declared, which is the whole reason this is not the `host`
# field REDS %422 refused: a declaration can say a tree cannot do what it can, while a probe that
# attempts a trivial `bwrap` and reads the refusal cannot be wrong about the bench it is standing
# on. Absence is positively read; unknown runs.
set -euo pipefail

AGENT_JAIL_PART="${AGENT_JAIL_PART:-all}"
case "$AGENT_JAIL_PART" in
  base|enclosure|all) ;;
  *) echo "agent_jail_witness: unknown AGENT_JAIL_PART '$AGENT_JAIL_PART' -- base, enclosure, or all" >&2; exit 2 ;;
esac

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

AJ="$REPO_ROOT/tools/ag/agent-jail.sh"
test -x "$AJ"

# The one room for loop state, seated 20260827. These are the paths the launcher builds and the
# paths the dry-run plan must therefore name.
LOOPS="$REPO_ROOT/loops"

echo "== resolve + dry-run =="
"$AJ" --dry-run claude --version >/tmp/agent-jail-dry-claude.txt
grep -q 'tmpfs /home/keeper' /tmp/agent-jail-dry-claude.txt \
  || grep -q "tmpfs ${HOME}" /tmp/agent-jail-dry-claude.txt
grep -q 'loops/claude' /tmp/agent-jail-dry-claude.txt
if command -v cursor-agent >/dev/null 2>&1 || command -v agent >/dev/null 2>&1; then
  "$AJ" --dry-run cursor-agent --version >/tmp/agent-jail-dry-agent.txt
  grep -q 'loops/cursor' /tmp/agent-jail-dry-agent.txt
  grep -q '.config/cursor' /tmp/agent-jail-dry-agent.txt
  "$AJ" --dry-run --resume=83513e3f-ec89-4924-a12b-f11189b04927 agent \
    >/tmp/agent-jail-dry-resume.txt
  grep -q -- '--resume=83513e3f-ec89-4924-a12b-f11189b04927' /tmp/agent-jail-dry-resume.txt
  "$AJ" --dry-run agent --resume=83513e3f-ec89-4924-a12b-f11189b04927 \
    >/tmp/agent-jail-dry-resume-tail.txt
  grep -q -- '--resume=83513e3f-ec89-4924-a12b-f11189b04927' /tmp/agent-jail-dry-resume-tail.txt
  echo "PASS: dry-run maps private-home + project state + auth config + resume"
else
  echo "SKIP: cursor-agent absent on this host -- claude legs still proven"
fi

# The leg REDS %408 exists for. Claude Code keeps hasCompletedOnboarding and the chosen theme in
# $HOME/.claude.json, a FILE beside ~/.claude/, and --private-home makes $HOME a tmpfs -- so an
# unmounted .claude.json means onboarding on every launch, and its theme picker previews a light
# scheme that reads as invisible text on a dark terminal. The mount used to be conditional on a
# file only the jailed Claude could write, into the tmpfs the exit discards, so it never happened.
# Both halves are asserted: the seed exists on disk, and the plan actually binds it.
echo "== claude.json is seeded and mounted (REDS %408) =="
test -f "$LOOPS/claude/dot-claude.json"
grep -q "loops/claude/dot-claude.json ${HOME}/.claude.json" /tmp/agent-jail-dry-claude.txt \
  || grep -q 'loops/claude/dot-claude.json' /tmp/agent-jail-dry-claude.txt
echo "PASS: ~/.claude.json seeded and bound -- onboarding runs once per pier, not once per lap"

echo "== state dirs =="
test -d "$LOOPS/claude"
test -d "$LOOPS/cursor"
test -d "$REPO_ROOT/.gh"
echo "PASS: state dirs present"

# ---- the enclosure legs begin here: everything below LAUNCHES the jail ----
if [ "$AGENT_JAIL_PART" = base ]; then
  echo "PASS: base legs -- the enclosure legs are rostered separately as agent_jail_enclosure"
  exit 0
fi

echo "== permit: write inside repo =="
INSIDE="$REPO_ROOT/.agent-jail-witness-inside"
rm -f "$INSIDE"
CONF="$REPO_ROOT/tools/e/enclosure.conf"
if [ -f "$CONF" ]; then
  # shellcheck source=/dev/null
  source "$CONF"
else
  echo "note: no tools/e/enclosure.conf on this host -- launcher defaults stand"
fi
AIJAIL_ABS="${AIJAIL_BIN:-$(command -v ai-jail)}"
HOST_HOME="$HOME"
CLAUDE_STATE="${CLAUDE_STATE:-$LOOPS/claude}"
CURSOR_AGENT_STATE="${CURSOR_AGENT_STATE:-$LOOPS/cursor}"
# v1.20.2 defaults network off; the launcher passes --network and so must this plan, or a leg
# here proves an enclosure the fleet never runs.
AIJAIL_FLAGS="${AIJAIL_FLAGS:---private-home --no-docker --no-gpu --network}"
MAP_EXTRA=()
if [ -e /run/current-system/sw ]; then
  MAP_EXTRA+=(--map /run/current-system)
fi
if [ -e /run/nscd ]; then
  MAP_EXTRA+=(--map /run/nscd)
fi
if [ -e /run/resolvconf ]; then
  MAP_EXTRA+=(--map /run/resolvconf)
fi
# shellcheck disable=SC2086
"$AIJAIL_ABS" --no-save-config $AIJAIL_FLAGS \
  --rw-map "${CLAUDE_STATE}:${HOST_HOME}/.claude" \
  --rw-map "${CURSOR_AGENT_STATE}:${HOST_HOME}/.cursor" \
  "${MAP_EXTRA[@]}" \
  -- /bin/sh -c "echo green > '${INSIDE}'"
test -f "$INSIDE"
grep -q green "$INSIDE"
rm -f "$INSIDE"
echo "PASS: write inside repo"

echo "== refuse: host home file invisible under private-home =="
HOST_PROBE="${HOME}/agent-jail-host-probe-$$"
echo secret >"$HOST_PROBE"
# shellcheck disable=SC2086
if "$AIJAIL_ABS" --no-save-config $AIJAIL_FLAGS \
  --rw-map "${CLAUDE_STATE}:${HOST_HOME}/.claude" \
  --rw-map "${CURSOR_AGENT_STATE}:${HOST_HOME}/.cursor" \
  "${MAP_EXTRA[@]}" \
  -- /bin/sh -c "test -f '${HOST_PROBE}'"; then
  rm -f "$HOST_PROBE"
  echo "FAIL: host probe visible inside jail" >&2
  exit 1
fi
rm -f "$HOST_PROBE"
echo "PASS: host home probe invisible"

echo "== refuse: write outside repo mount (/etc) =="
# shellcheck disable=SC2086
if "$AIJAIL_ABS" --no-save-config $AIJAIL_FLAGS \
  --rw-map "${CLAUDE_STATE}:${HOST_HOME}/.claude" \
  --rw-map "${CURSOR_AGENT_STATE}:${HOST_HOME}/.cursor" \
  "${MAP_EXTRA[@]}" \
  -- /bin/sh -c 'echo bad > /etc/agent-jail-refuse-$$'; then
  echo "FAIL: write to /etc succeeded" >&2
  exit 1
fi
echo "PASS: write to /etc denied"

echo "== version smoke through launcher =="
"$AJ" claude --version | head -1
if command -v cursor-agent >/dev/null 2>&1 || command -v agent >/dev/null 2>&1; then
  "$AJ" cursor-agent --version 2>&1 | head -5
fi
echo "PASS: claude starts under agent-jail"

echo "GREEN: agent-jail witness"
