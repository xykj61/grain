#!/usr/bin/env bash
# agent-jail.sh — run cursor-agent or claude inside ai-jail for this repo.
#
# Tracked bash elder. Preferred entries (Rish):
#   rishi/bin/rishi run tools/launch-claude.rish
#   rishi/bin/rishi run tools/launch-cursor-agent.rish
#
#   ./tools/agent-jail.sh claude
#   ./tools/agent-jail.sh cursor-agent -p "…"
#   ./tools/agent-jail.sh agent --help          # alias → cursor-agent
#   ./tools/agent-jail.sh --dry-run claude --version
#
# Keeper pier / Linux: ai-jail --private-home; auth under project-local state
# (.claude-state · .cursor-agent-state · .gh). See nixos-guide CLI-agents note
# and context/specs/enclosure-editors.md.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

DRY_RUN=false

usage() {
  cat <<'EOF'
Usage: ./tools/agent-jail.sh [--dry-run] <claude|cursor-agent|agent> [args…]

  claude           Anthropic Claude Code CLI
  cursor-agent     Cursor Agent CLI (nixpkgs cursor-cli / agent)
  agent            Alias for cursor-agent
  --dry-run        Pass --dry-run to ai-jail (print bwrap plan; do not exec)
  -h, --help       Show this help

Project-local state (gitignored, survives private-home tmpfs):
  .claude-state/          → $HOME/.claude inside the jail
  .cursor-agent-state/    → $HOME/.cursor inside the jail
  .gh/                    → GH_CONFIG_DIR for gh(1)

Examples:

  ./tools/agent-jail.sh claude
  ./tools/agent-jail.sh claude -p 'reply with exactly: pong'
  ./tools/agent-jail.sh cursor-agent -p "what is the hostname"
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    -h | --help)
      usage
      exit 0
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "agent-jail: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      break
      ;;
  esac
done

if [ $# -lt 1 ]; then
  echo "agent-jail: missing command (claude | cursor-agent | agent)" >&2
  usage >&2
  exit 2
fi

CMD_NAME="$1"
shift
case "$CMD_NAME" in
  claude) AGENT_KIND=claude ;;
  cursor-agent | agent) AGENT_KIND=cursor-agent ;;
  *)
    echo "agent-jail: unknown command: $CMD_NAME (want claude | cursor-agent | agent)" >&2
    exit 2
    ;;
esac

CONF="${ENCLOSURE_CONF:-$REPO_ROOT/tools/enclosure.conf}"
if [ -f "$CONF" ]; then
  # shellcheck source=/dev/null
  source "$CONF"
fi

REPO="${REPO:-$REPO_ROOT}"
CLAUDE_STATE="${CLAUDE_STATE:-$REPO/.claude-state}"
CURSOR_AGENT_STATE="${CURSOR_AGENT_STATE:-$REPO/.cursor-agent-state}"
GH_STATE="${GH_STATE:-$REPO/.gh}"
AIJAIL_FLAGS="${AIJAIL_FLAGS:---private-home --no-docker --no-gpu}"
ENCLOSURE="${ENCLOSURE:-ai-jail}"

EXIT_BRON="${REPO_ROOT}/bron-resins/pond-supersede-exit.bron"
if [ "$ENCLOSURE" = "pond" ]; then
  if ! bash "${REPO_ROOT}/tools/pond_exit_bron_master_seal.sh" --require; then
    exit 1
  fi
elif [ "$ENCLOSURE" != "ai-jail" ]; then
  echo "REFUSE: ENCLOSURE must be ai-jail or pond (got: ${ENCLOSURE})" >&2
  exit 1
fi

resolve_aijail() {
  local c
  if [ -n "${AIJAIL_BIN:-}" ] && [ -f "$AIJAIL_BIN" ] && [ -x "$AIJAIL_BIN" ]; then
    echo "$AIJAIL_BIN"
    return 0
  fi
  if c="$(command -v ai-jail 2>/dev/null)" && [ -f "$c" ] && [ -x "$c" ]; then
    echo "$c"
    return 0
  fi
  for c in \
    "$REPO/tools/.cache/bin/ai-jail" \
    "$REPO/gratitude/ai-jail/target/release/ai-jail" \
    "$HOME/.local/bin/ai-jail" \
    /usr/local/bin/ai-jail \
    /usr/bin/ai-jail; do
    if [ -x "$c" ]; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

if ! AIJAIL_ABS="$(resolve_aijail)"; then
  cat <<'EOF' >&2
ai-jail not found.

On NixOS (keeper pier): release tarballs hit stub-ld. Prefer:
  nix profile install github:akitaonrails/ai-jail
Then set AIJAIL_BIN in tools/enclosure.conf to that binary.

Elsewhere:
  cargo install ai-jail
  # or the v1.12.0 tools/.cache/bin pin in enclosure.conf.example
EOF
  exit 1
fi

case "$AGENT_KIND" in
  claude)
    if ! AGENT_BIN="$(command -v claude 2>/dev/null)"; then
      echo "agent-jail: claude not on PATH" >&2
      exit 1
    fi
    ;;
  cursor-agent)
    if AGENT_BIN="$(command -v cursor-agent 2>/dev/null)"; then
      :
    elif AGENT_BIN="$(command -v agent 2>/dev/null)"; then
      :
    else
      echo "agent-jail: cursor-agent (or agent) not on PATH" >&2
      exit 1
    fi
    ;;
esac

# NixOS: ai-jail tmpfs-replaces /run, so /run/current-system/sw/bin/* vanishes.
# Exec the resolved /nix/store path (still ro-bound via /nix).
AGENT_BIN="$(readlink -f "$AGENT_BIN")"
if [ ! -x "$AGENT_BIN" ]; then
  echo "agent-jail: resolved agent binary not executable: $AGENT_BIN" >&2
  exit 1
fi

mkdir -p "$CLAUDE_STATE" "$CURSOR_AGENT_STATE" "$GH_STATE"

# Host HOME path is the jail HOME path under --private-home (tmpfs + our binds).
HOST_HOME="${HOME}"
MAP_ARGS=(
  --rw-map "${CLAUDE_STATE}:${HOST_HOME}/.claude"
  --rw-map "${CURSOR_AGENT_STATE}:${HOST_HOME}/.cursor"
)

# Claude Code also reads $HOME/.claude.json (beside ~/.claude/).
if [ -f "${CLAUDE_STATE}/dot-claude.json" ]; then
  MAP_ARGS+=(--rw-map "${CLAUDE_STATE}/dot-claude.json:${HOST_HOME}/.claude.json")
fi

# NixOS: ai-jail tmpfs-replaces /run — re-map the system profile so PATH tools resolve.
if [ -e /run/current-system/sw ]; then
  MAP_ARGS+=(--map /run/current-system)
fi

DRY_ARGS=()
if [ "$DRY_RUN" = true ]; then
  DRY_ARGS=(--dry-run)
fi

# Jail PATH: system profile (if mapped) + /bin + common nix profile.
JAIL_PATH="/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:${HOST_HOME}/.nix-profile/bin:/bin"

# --no-save-config: do not merge this run into .ai-jail
# shellcheck disable=SC2086
exec "$AIJAIL_ABS" --no-save-config $AIJAIL_FLAGS "${DRY_ARGS[@]}" "${MAP_ARGS[@]}" -- \
  env "GH_CONFIG_DIR=$GH_STATE" "PATH=$JAIL_PATH" "$AGENT_BIN" "$@"
