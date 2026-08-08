#!/usr/bin/env bash
# agent_jail_witness.sh — prove tools/agent-jail.sh on Linux (keeper pier).
# Run from an ordinary host shell at the repo root, not from inside a jail.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

AJ="$REPO_ROOT/tools/agent-jail.sh"
test -x "$AJ"

echo "== resolve + dry-run =="
"$AJ" --dry-run claude --version >/tmp/agent-jail-dry-claude.txt
grep -q 'tmpfs /home/keeper' /tmp/agent-jail-dry-claude.txt \
  || grep -q "tmpfs ${HOME}" /tmp/agent-jail-dry-claude.txt
grep -q '.claude-state' /tmp/agent-jail-dry-claude.txt
"$AJ" --dry-run cursor-agent --version >/tmp/agent-jail-dry-agent.txt
grep -q '.cursor-agent-state' /tmp/agent-jail-dry-agent.txt
"$AJ" --dry-run --resume=83513e3f-ec89-4924-a12b-f11189b04927 agent \
  >/tmp/agent-jail-dry-resume.txt
grep -q -- '--resume=83513e3f-ec89-4924-a12b-f11189b04927' /tmp/agent-jail-dry-resume.txt
"$AJ" --dry-run agent --resume=83513e3f-ec89-4924-a12b-f11189b04927 \
  >/tmp/agent-jail-dry-resume-tail.txt
grep -q -- '--resume=83513e3f-ec89-4924-a12b-f11189b04927' /tmp/agent-jail-dry-resume-tail.txt
echo "PASS: dry-run maps private-home + project state + resume forward"

echo "== state dirs =="
test -d "$REPO_ROOT/.claude-state"
test -d "$REPO_ROOT/.cursor-agent-state"
test -d "$REPO_ROOT/.gh"
echo "PASS: state dirs present"

echo "== permit: write inside repo =="
INSIDE="$REPO_ROOT/.agent-jail-witness-inside"
rm -f "$INSIDE"
CONF="$REPO_ROOT/tools/enclosure.conf"
# shellcheck source=/dev/null
source "$CONF"
AIJAIL_ABS="${AIJAIL_BIN:-$(command -v ai-jail)}"
HOST_HOME="$HOME"
CLAUDE_STATE="${CLAUDE_STATE:-$REPO_ROOT/.claude-state}"
CURSOR_AGENT_STATE="${CURSOR_AGENT_STATE:-$REPO_ROOT/.cursor-agent-state}"
MAP_EXTRA=()
if [ -e /run/current-system/sw ]; then
  MAP_EXTRA+=(--map /run/current-system)
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
"$AJ" cursor-agent --version 2>&1 | head -5
echo "PASS: claude and cursor-agent start under agent-jail"

echo "GREEN: agent-jail witness"
