#!/usr/bin/env bash
# agent-jail.sh — run cursor-agent or claude inside ai-jail for this repo.
#
# Tracked bash elder. Preferred entries (Rish):
#   rishi/bin/rishi run tools/l/launch-claude.rish
#   rishi/bin/rishi run tools/l/launch-cursor-agent.rish
#
#   ./tools/ag/agent-jail.sh claude
#   ./tools/ag/agent-jail.sh cursor-agent -p "…"
#   ./tools/ag/agent-jail.sh agent --help          # alias → cursor-agent
#   ./tools/ag/agent-jail.sh agent --resume=CHAT_ID
#   ./tools/ag/agent-jail.sh --resume=CHAT_ID agent
#   ./tools/ag/agent-jail.sh --continue agent
#   ./tools/ag/agent-jail.sh --dry-run claude --version
#
# Keeper pier / Linux: ai-jail --private-home; auth under project-local state
# (.claude-state · .cursor-agent-state · .gh). See nixos-guide CLI-agents note
# and context/specs/enclosure-editors.md.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$REPO_ROOT"

DRY_RUN=false
SKIP_PERMS=false
# Forwarded to the agent binary (before trailing args). Lets --resume sit
# before the command name without looking like an unknown jail option.
AGENT_FORWARD=()

usage() {
  cat <<'EOF'
Usage: ./tools/ag/agent-jail.sh [jail-opts] <claude|cursor-agent|agent> [agent-args…]

  claude           Anthropic Claude Code CLI
  cursor-agent     Cursor Agent CLI (nixpkgs cursor-cli / agent)
  agent            Alias for cursor-agent

Jail options (before the command name):
  --dry-run              Pass --dry-run to ai-jail (print bwrap plan; do not exec)
  --resume[=CHAT_ID]     Forward to the agent (resume a chat; bare --resume lists)
  --resume CHAT_ID       Same, space-separated form
  --continue             Forward to the agent (continue previous session)
  --dangerously-skip-permissions
                         Forward to claude: skip every "Do you want to proceed?"
                         prompt for unattended runs. Safe inside ai-jail (the
                         sandbox this flag is for). Must run as a NON-ROOT user
                         (claude refuses it as root). Standing-config twin:
                         .claude/settings.local.json { "permissions":
                         { "defaultMode": "bypassPermissions" } } (gitignored).
  -h, --help             Show this help

Agent args after the command name pass through unchanged, so these are equal:

  ./tools/ag/agent-jail.sh agent --resume=83513e3f-ec89-4924-a12b-f11189b04927
  ./tools/ag/agent-jail.sh --resume=83513e3f-ec89-4924-a12b-f11189b04927 agent

Project-local state (gitignored, survives private-home tmpfs):
  .claude-state/                        → $HOME/.claude inside the jail
  .cursor-agent-state/                  → $HOME/.cursor inside the jail
  .cursor-agent-state/xdg-config/       → $HOME/.config/cursor (auth.json)
  .gh/                                  → GH_CONFIG_DIR for gh(1)

Examples:

  ./tools/ag/agent-jail.sh claude
  ./tools/ag/agent-jail.sh claude -p 'reply with exactly: pong'
  ./tools/ag/agent-jail.sh cursor-agent -p "what is the hostname"
  ./tools/ag/agent-jail.sh agent --resume=83513e3f-ec89-4924-a12b-f11189b04927
  ./tools/ag/agent-jail.sh --continue cursor-agent

Unattended season run (resume + skip permissions):

  ./tools/ag/agent-jail.sh --resume=RESUME_SESSION_ID --dangerously-skip-permissions claude
  ./tools/ag/agent-jail.sh --continue --dangerously-skip-permissions claude
  ./tools/ag/agent-jail.sh --dangerously-skip-permissions claude \
    -p 'Read construction/ITINERARY.md, then continue AHOY and WADE per Lindy-first, crux-first. kg the next rung, send each round, recur.'

  Rish preferred entry: rishi/bin/rishi run tools/l/launch-claude-season.rish
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
    --continue)
      AGENT_FORWARD+=(--continue)
      shift
      ;;
    --dangerously-skip-permissions)
      # Forward to the agent (claude): skip every permission prompt. Safe here
      # because ai-jail is the sandbox this flag is meant for. Claude refuses
      # this flag as root, so the jail must run the agent as a non-root user.
      AGENT_FORWARD+=(--dangerously-skip-permissions)
      SKIP_PERMS=true
      shift
      ;;
    --resume=*)
      AGENT_FORWARD+=("$1")
      shift
      ;;
    --resume)
      # Bare --resume (picker) or --resume CHAT_ID
      if [ $# -ge 2 ] && [[ "$2" != -* ]]; then
        AGENT_FORWARD+=(--resume "$2")
        shift 2
      else
        AGENT_FORWARD+=(--resume)
        shift
      fi
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

CONF="${ENCLOSURE_CONF:-$REPO_ROOT/tools/e/enclosure.conf}"
if [ -f "$CONF" ]; then
  # shellcheck source=/dev/null
  source "$CONF"
fi

REPO="${REPO:-$REPO_ROOT}"
CLAUDE_STATE="${CLAUDE_STATE:-$REPO/.claude-state}"
CURSOR_AGENT_STATE="${CURSOR_AGENT_STATE:-$REPO/.cursor-agent-state}"
# cursor-agent writes OAuth to ~/.config/cursor/auth.json (not ~/.cursor/).
CURSOR_CONFIG_STATE="${CURSOR_CONFIG_STATE:-$CURSOR_AGENT_STATE/xdg-config}"
GH_STATE="${GH_STATE:-$REPO/.gh}"
AIJAIL_FLAGS="${AIJAIL_FLAGS:---private-home --no-docker --no-gpu}"
ENCLOSURE="${ENCLOSURE:-ai-jail}"

EXIT_BRON="${REPO_ROOT}/bron-resins/pond-supersede-exit.bron"
if [ "$ENCLOSURE" = "pond" ]; then
  if ! bash "${REPO_ROOT}/tools/p/pond_exit_bron_master_seal.sh" --require; then
    exit 1
  fi
elif [ "$ENCLOSURE" != "ai-jail" ]; then
  echo "REFUSE: ENCLOSURE must be ai-jail or pond (got: ${ENCLOSURE})" >&2
  exit 1
fi

resolve_aijail() {
  local c
  if [ -n "${AIJAIL_BIN:-}" ]; then
    if [ -f "$AIJAIL_BIN" ] && [ -x "$AIJAIL_BIN" ]; then
      echo "$AIJAIL_BIN"
      return 0
    fi
    echo "agent-jail: AIJAIL_BIN is set but missing or not executable: $AIJAIL_BIN" >&2
    echo "agent-jail: on NixOS prefer: nix profile add github:akitaonrails/ai-jail" >&2
    return 1
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
Then set AIJAIL_BIN in tools/e/enclosure.conf to that binary.

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
    if [ "$SKIP_PERMS" = true ] && [ "$(id -u)" = "0" ]; then
      echo "agent-jail: NOTE — --dangerously-skip-permissions is running as root (uid 0)." >&2
      echo "agent-jail: claude refuses this flag as root; run the jail as a non-root user." >&2
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

mkdir -p "$CLAUDE_STATE" "$CURSOR_AGENT_STATE" "$CURSOR_CONFIG_STATE" "$GH_STATE"

# Host HOME path is the jail HOME path under --private-home (tmpfs + our binds).
HOST_HOME="${HOME}"

# One-time seed: host browser login lands in ~/.config/cursor; private-home
# would drop it unless we keep a durable copy under the repo state tree.
if [ ! -f "${CURSOR_CONFIG_STATE}/auth.json" ] && [ -f "${HOST_HOME}/.config/cursor/auth.json" ]; then
  cp -a "${HOST_HOME}/.config/cursor/." "${CURSOR_CONFIG_STATE}/"
fi

MAP_ARGS=(
  --rw-map "${CLAUDE_STATE}:${HOST_HOME}/.claude"
  --rw-map "${CURSOR_AGENT_STATE}:${HOST_HOME}/.cursor"
  --rw-map "${CURSOR_CONFIG_STATE}:${HOST_HOME}/.config/cursor"
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
  env "GH_CONFIG_DIR=$GH_STATE" "PATH=$JAIL_PATH" "$AGENT_BIN" "${AGENT_FORWARD[@]}" "$@"
