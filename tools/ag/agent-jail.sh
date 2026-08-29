#!/usr/bin/env bash
# agent-jail.sh -- run cursor-agent or claude inside ai-jail for this repo.
#
# Tracked bash elder. Preferred entries (Rish):
#   rishi/bin/rishi run tools/l/launch-claude.rish
#   rishi/bin/rishi run tools/l/launch-cursor-agent.rish
#
#   ./tools/ag/agent-jail.sh claude
#   ./tools/ag/agent-jail.sh cursor-agent -p "..."
#   ./tools/ag/agent-jail.sh agent --help          # alias -> cursor-agent
#   ./tools/ag/agent-jail.sh agent --resume=CHAT_ID
#   ./tools/ag/agent-jail.sh --resume=CHAT_ID agent
#   ./tools/ag/agent-jail.sh --continue agent
#   ./tools/ag/agent-jail.sh --dry-run claude --version
#
# Keeper pier / Linux: ai-jail --private-home; auth under project-local state
# (.claude-state - .cursor-agent-state - .gh). See nixos-guide CLI-agents note
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
Usage: ./tools/ag/agent-jail.sh [jail-opts] <claude|cursor-agent|agent|codex> [agent-args...]

  claude           Anthropic Claude Code CLI
  cursor-agent     Cursor Agent CLI (nixpkgs cursor-cli / agent)
  agent            Alias for cursor-agent
  codex            OpenAI Codex CLI -- DREAM's seat. Its login state is mapped
                   from .dream-state/codex-home onto ~/.codex, so the account
                   auth survives --private-home, which resets the jail's HOME on
                   exit. Pass codex's own args straight through, e.g.
                     ./tools/ag/agent-jail.sh codex login
                     ./tools/ag/agent-jail.sh codex exec --sandbox danger-full-access 'PROMPT'

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
  .claude-state/                        -> $HOME/.claude inside the jail
  .cursor-agent-state/                  -> $HOME/.cursor inside the jail
  .cursor-agent-state/xdg-config/       -> $HOME/.config/cursor (auth.json)
  .gh/                                  -> GH_CONFIG_DIR for gh(1)
  .dream-state/codex-home/              -> $HOME/.codex inside the jail (codex auth)

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

  Rish preferred entry: rishi/bin/rishi run tools/l/launch-claude-chapter.rish
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
  echo "agent-jail: missing command (claude | cursor-agent | agent | codex)" >&2
  usage >&2
  exit 2
fi

CMD_NAME="$1"
shift
case "$CMD_NAME" in
  claude) AGENT_KIND=claude ;;
  cursor-agent | agent) AGENT_KIND=cursor-agent ;;
  codex) AGENT_KIND=codex ;;
  *)
    echo "agent-jail: unknown command: $CMD_NAME (want claude | cursor-agent | agent | codex)" >&2
    exit 2
    ;;
esac

CONF="${ENCLOSURE_CONF:-$REPO_ROOT/tools/e/enclosure.conf}"
if [ -f "$CONF" ]; then
  # shellcheck source=/dev/null
  source "$CONF"
fi

REPO="${REPO:-$REPO_ROOT}"

# ONE ROOM FOR LOOP STATE (seated 20260827 on Keaton's word, `approve all doors`).
# Six gitignored directories used to sit at the tree root -- .claude-state,
# .cursor-agent-state, .dream-state, .mind-state, .cursor-state, .zed-state -- six of
# the 97 doors that face a lap opening the root, each named for the tool that filled
# it rather than for what it is. They are one room now, `loops/`, and each
# subdirectory is named plainly for what it holds. read-scope.md seats `loops/` as a
# closed stack: a lap fetches its own file by path and leaves the other five alone.
#
# adopt_state_dir <elder-path> <new-path> -- move an elder directory into the new room
# once, and only when the new one is absent. Auth lives in these directories: the pier
# holds a codex login that took a hand at a keyboard, so a rename that simply changed
# the default would ask for that login again on every machine that had one. This
# migrates instead, so a clone heals itself on its next launch and the login is done
# once per pier, as it always was. `mv` is deliberate over `cp` -- two copies of a
# credential is one more than anyone wants.
adopt_state_dir() {
  _elder=$1
  _new=$2
  if [ -d "$_elder" ] && [ ! -e "$_new" ]; then
    mkdir -p "$(dirname "$_new")"
    mv "$_elder" "$_new" && echo "agent-jail: adopted $_elder -> $_new" >&2
  fi
}

# prefer_adopted_room <var-name> <room-path> -- let the adopted room outrank an emptied pin.
#
# tools/e/enclosure.conf is sourced ABOVE these defaults, so a pier whose conf still names an
# elder path keeps naming it after adopt_state_dir has moved that directory's contents into
# `loops/`. The `mkdir -p` further down then recreates the elder empty, the jail binds an empty
# directory over the agent's HOME, and the login the comment above promises is done once per pier
# is asked for again -- silently, because an empty state directory and a fresh one look alike.
# Measured on the Framework pier 20260828: loops/claude held 5,229 files including
# .credentials.json while .claude-state held none (REDS %327).
#
# The room outranks the pin only when the pinned path holds NO file at all. A directory somebody
# is actually writing to keeps its place, so a deliberate third path is never overridden; a
# directory holding nothing cannot be a destination anyone is using. The swap is announced on
# stderr, because a silent correction is the same class of quiet as the fault it repairs.
prefer_adopted_room() {
  local var=$1 room=$2 cur room_files cur_files
  cur=${!var}
  [ "$cur" = "$room" ] && return 0
  [ -d "$room" ] || return 0
  room_files=$(find "$room" -type f 2>/dev/null | wc -l)
  # invariant: an empty room has nothing to offer and never outranks a pin.
  [ "$room_files" -gt 0 ] || return 0
  cur_files=0
  [ -d "$cur" ] && cur_files=$(find "$cur" -type f 2>/dev/null | wc -l)
  # invariant: only a pin holding no file at all yields, so live state is never overridden.
  [ "$cur_files" -eq 0 ] || return 0
  echo "agent-jail: $var pins $cur, which holds no file; using the adopted room $room ($room_files files)" >&2
  printf -v "$var" '%s' "$room"
}

LOOPS="${LOOPS:-$REPO/loops}"
adopt_state_dir "$REPO/.claude-state"        "$LOOPS/claude"
adopt_state_dir "$REPO/.cursor-agent-state"  "$LOOPS/cursor"
adopt_state_dir "$REPO/.dream-state/codex-home" "$LOOPS/codex"

CLAUDE_STATE="${CLAUDE_STATE:-$LOOPS/claude}"
CURSOR_AGENT_STATE="${CURSOR_AGENT_STATE:-$LOOPS/cursor}"
# The conf sourced above may still pin an elder these adoptions have already emptied.
prefer_adopted_room CLAUDE_STATE "$LOOPS/claude"
prefer_adopted_room CURSOR_AGENT_STATE "$LOOPS/cursor"
# cursor-agent writes OAuth to ~/.config/cursor/auth.json (not ~/.cursor/).
CURSOR_CONFIG_STATE="${CURSOR_CONFIG_STATE:-$CURSOR_AGENT_STATE/xdg-config}"
GH_STATE="${GH_STATE:-$REPO/.gh}"
# codex reads its auth and config from $CODEX_HOME, defaulting to ~/.codex. The
# jail runs --private-home, so that directory is a tmpfs the exit discards --
# hence a repo-local durable dir, mapped onto ~/.codex below, so login is done
# once per pier rather than once per lap.
CODEX_STATE="${CODEX_STATE:-$LOOPS/codex}"
prefer_adopted_room CODEX_STATE "$LOOPS/codex"
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
      echo "agent-jail: NOTE -- --dangerously-skip-permissions is running as root (uid 0)." >&2
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
  codex)
    if ! AGENT_BIN="$(command -v codex 2>/dev/null)"; then
      echo "agent-jail: codex not on PATH" >&2
      echo "agent-jail: nixos/configuration.nix declares it; switch the pier from" >&2
      echo "agent-jail:   bash /home/keeper/grain/nixos/rebuild-outer.sh" >&2
      echo "agent-jail: run OUTSIDE this jail -- no-new-privileges blocks sudo here." >&2
      exit 1
    fi
    ;;
esac

# NixOS: ai-jail tmpfs-replaces /run, so /run/current-system/sw/bin/* vanishes.
# Exec the resolved /nix/store path (still ro-bound via /nix).
#
# HOST-BOUND ON PURPOSE, so `readlink -f` stays. This script runs the agent inside ai-jail, which is
# bubblewrap over a Linux kernel and a /nix store; there is no bench where it runs and GNU readlink
# is absent. The portable `resolve_path` in tools/fixtures/s/shell_portable.sh exists for the guards
# that DO cross to the second pier, and reaching for it here would spend a line implying this script
# travels. It does not, and the law says to gate where the requirement is known.
AGENT_BIN="$(readlink -f "$AGENT_BIN")"
if [ ! -x "$AGENT_BIN" ]; then
  echo "agent-jail: resolved agent binary not executable: $AGENT_BIN" >&2
  exit 1
fi

mkdir -p "$CLAUDE_STATE" "$CURSOR_AGENT_STATE" "$CURSOR_CONFIG_STATE" "$GH_STATE"
mkdir -p "$CODEX_STATE"

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
  --rw-map "${CODEX_STATE}:${HOST_HOME}/.codex"
)

# Claude Code also reads $HOME/.claude.json (beside ~/.claude/).
if [ -f "${CLAUDE_STATE}/dot-claude.json" ]; then
  MAP_ARGS+=(--rw-map "${CLAUDE_STATE}/dot-claude.json:${HOST_HOME}/.claude.json")
fi

# NixOS: ai-jail tmpfs-replaces /run -- re-map the system profile so PATH tools resolve.
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
