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
# (loops/claude - loops/cursor - loops/codex - .gh; the one room seated 20260827).
# See nixos-guide CLI-agents note and context/specs/enclosure-editors.md.

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
                   from loops/codex onto ~/.codex, so the account
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

Project-local state (gitignored, survives private-home tmpfs). One room, `loops/`,
seated 20260827; an elder directory at the root is adopted on the next launch:
  loops/claude/                         -> $HOME/.claude inside the jail
  loops/claude/dot-claude.json          -> $HOME/.claude.json (onboarding + theme)
  loops/cursor/                         -> $HOME/.cursor inside the jail
  loops/cursor/xdg-config/              -> $HOME/.config/cursor (auth.json)
  loops/codex/                          -> $HOME/.codex inside the jail (codex auth)
  .gh/                                  -> GH_CONFIG_DIR for gh(1)

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
  # `lap` runs tools/l/fleet_lap.sh inside the enclosure with NO flags in the jail's own argv.
  # ai-jail owns `-v, --verbose` and refuses it after the command even when `--` was passed, while
  # Claude Code requires it alongside `--output-format stream-json` -- so the flags move inside,
  # where only claude reads them (REDS %414).
  lap) AGENT_KIND=lap ;;
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
# v1.20.2 defaults network off (SECURITY.md). Without --network, cursor-agent
# dies with getaddrinfo EAI_AGAIN on api2.cursor.sh (Host pier 20260904.085119).
# Kept off the :- default so pond_policy_launcher_control's flag-sed still
# matches. A sourced enclosure.conf that omits it still gets the flag;
# --no-network wins.
case " $AIJAIL_FLAGS " in
*" --no-network "*) ;;
*" --network "*) ;;
*) AIJAIL_FLAGS="$AIJAIL_FLAGS --network" ;;
esac
# The one admission door: reads the ENCLOSURE selector, admits pond only behind
# the master seal, refuses anything else. This gate stood written here in full
# until 20260829; the shared body and its custody story live in the door itself.
ENCLOSURE="$(ENCLOSURE="${ENCLOSURE:-}" sh "${REPO_ROOT}/tools/e/enclosure_gate.sh")" || exit 1

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
  lap)
    AGENT_BIN=$(command -v sh) || { echo "agent-jail: sh not on PATH" >&2; exit 1; }
    if ! command -v claude >/dev/null 2>&1; then
      echo "agent-jail: claude not on PATH -- the lap script needs it inside" >&2
      exit 1
    fi
    AGENT_FORWARD=("$REPO_ROOT/tools/l/fleet_lap.sh")
    ;;
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

# ONE LOGIN PER PIER, NOT ONE PER TREE (REDS %415). `claude login` writes to the HOST's
# $HOME/.claude, and `--private-home` replaces $HOME inside the jail with a tmpfs -- so a login
# typed at the pier shell reaches no tree at all, whichever directory it was typed in. The fleet
# has six trees; without this, it has six logins, and each expires on its own clock.
#
# The rule is the cursor seed's above, plus a refresh clause the cursor one does not need. Copy
# when the tree has none, AND when the host's is strictly newer -- because a token refreshes. The
# jailed agent writes its own refreshed token into the tree's room, so the tree's copy is newer
# after a working lap and is never clobbered; a fresh `claude login` on the pier makes the host's
# newer, and every tree picks it up on its next launch. Whichever hand moved last wins, which is
# the only rule that stays true without a hand remembering it.
#
# WHAT THIS IS NOT: no credential leaves this machine, none is written anywhere tracked --
# `loops/` is gitignored and a closed stack -- and nothing here creates, holds or moves a custody
# key. It carries the maintainer's own already-granted session from one directory of his own pier
# to another, which is exactly what the cursor line above has done since it was written.
#
# A NEWER FILE IS NOT A BETTER CREDENTIAL, and reading only the mtime cost a night of laps
# (REDS %419). Signing out, or a session expiring, REWRITES the file with the same seven fields and
# EMPTY token strings -- `accessToken` and `refreshToken` at length zero, `expiresAt` at the Unix
# epoch. That file is valid JSON, correctly shaped, and the newest thing on disk, so the elder
# refresh clause copied it OUT of the tree it was in and INTO the host, and then into every other
# tree on their next launch. One logged-out checkout became three. Petrichor answered
# `Failed to authenticate: OAuth session expired and could not be refreshed` five laps running.
#
# So freshness is read only after USABILITY: a credential is worth copying when its access token is
# a non-empty string. That is the cheapest honest test -- it does not phone anywhere, and it
# separates the two states this file can be in that an mtime cannot tell apart.
claude_login_live() {
  # invariant: a credential with an empty access token is a logged-out one, whatever its mtime.
  [ -f "$1" ] || return 1
  LC_ALL=C grep -q '"accessToken"[[:space:]]*:[[:space:]]*"[^"]\{16,\}"' "$1" 2>/dev/null
}

# claude_refresh_dead <credential> -- is this credential beyond any automatic repair?
#
# A PRESENT TOKEN IS NOT A WORKING ONE, and the difference is what a fleet-wide outage looks like
# from here (REDS %456). The access token above expires roughly every eight hours BY DESIGN and is
# renewed without a hand, so its expiry says nothing. The REFRESH token is the one that cannot be
# renewed: when it is spent or past its own date, no lap can recover, and copying such a credential
# into a tree guarantees `Failed to authenticate: OAuth session expired and could not be refreshed`
# at the next invocation -- which is exactly how seven ships each died three laps inside ten seconds
# on 20260906 while every transcript said only that the session had expired.
#
# READ, NEVER PHONED. This compares a timestamp already in the file against the clock. It cannot
# tell a spent-by-rotation token from a live one -- nothing local can -- so it is the cheap half of
# an honest answer and says so rather than implying it covers both.
claude_refresh_dead() {
  [ -f "$1" ] || return 1
  _rexp=$(LC_ALL=C sed -n 's/.*"refreshTokenExpiresAt"[[:space:]]*:[[:space:]]*\([0-9]\{10,\}\).*/\1/p' "$1" 2>/dev/null | head -1)
  [ -n "${_rexp:-}" ] || return 1          # no field to read is not a death sentence
  [ "$_rexp" -le "$(( $(date +%s) * 1000 ))" ]
}
if claude_refresh_dead "${HOST_HOME}/.claude/.credentials.json"; then
  # NAMED RATHER THAN COPIED. The pier's refresh token is past its date, so every ship seeding from
  # it would fail at its first API call and the loop would read as three dead laps rather than as
  # one logged-out pier. One line at the top of the lap costs nothing and answers the question the
  # transcripts could not (REDS %456).
  echo "agent-jail: the pier's claude REFRESH token has expired -- every ship seeds from this one" >&2
  echo "agent-jail: credential, so every ship is out. Run claude on the HOST and /login; the ships" >&2
  echo "agent-jail: heal on their next round-open. Reading: sh tools/fixtures/f/fleet_login_scan.sh" >&2
elif claude_login_live "${HOST_HOME}/.claude/.credentials.json"; then
  if ! claude_login_live "${CLAUDE_STATE}/.credentials.json"; then
    cp -p "${HOST_HOME}/.claude/.credentials.json" "${CLAUDE_STATE}/.credentials.json" \
      && echo "agent-jail: seeded this tree's claude login from the host (one login per pier)" >&2
  elif [ "${HOST_HOME}/.claude/.credentials.json" -nt "${CLAUDE_STATE}/.credentials.json" ]; then
    cp -p "${HOST_HOME}/.claude/.credentials.json" "${CLAUDE_STATE}/.credentials.json" \
      && echo "agent-jail: refreshed this tree's claude login from a newer host login" >&2
  fi
elif [ -f "${HOST_HOME}/.claude/.credentials.json" ]; then
  # The host is logged out. Say so once rather than copying emptiness onward: a tree holding a live
  # credential keeps it, and a `claude login` at the pier shell repairs every tree on its next lap.
  echo "agent-jail: the host's claude login is empty (signed out) -- leaving this tree's own credential alone" >&2
fi

MAP_ARGS=(
  --rw-map "${CLAUDE_STATE}:${HOST_HOME}/.claude"
  --rw-map "${CURSOR_AGENT_STATE}:${HOST_HOME}/.cursor"
  --rw-map "${CURSOR_CONFIG_STATE}:${HOST_HOME}/.config/cursor"
  --rw-map "${CODEX_STATE}:${HOST_HOME}/.codex"
)

# Claude Code keeps hasCompletedOnboarding, the chosen theme, and per-project trust in
# $HOME/.claude.json -- a FILE beside ~/.claude/, never inside it. --private-home makes $HOME a
# tmpfs, so that file is absent in the jail and the exit discards whatever Claude writes there.
#
# This mount was conditional on loops/claude/dot-claude.json ALREADY existing, and the only
# process that ever writes it is the jailed Claude -- into the tmpfs the exit throws away. So on
# a fresh pier the condition could never come true, and the failing direction is silent: an
# absent bind source is skipped rather than refused. Onboarding therefore ran on every jailed
# launch, and its first screen is the theme picker, which previews a light scheme that reads as
# invisible text on a dark terminal (REDS %408). The three sibling state directories above take
# the opposite shape and are correct -- each is mkdir -p'd and then mounted unconditionally --
# so the rule was already written and applied to three of the four things it governs.
#
# The file is SEEDED rather than the mount skipped, and the onboarding markers are CARRIED ACROSS
# from the host's own file rather than written by hand.
#
# The elder form seeded `{}` and argued the point well: a hand-written `hasCompletedOnboarding`
# would be a guess at another program's config schema, and Claude would write its own record on the
# first jailed run. Measured `20260905`, that second half is false. The jailed file had grown to 28
# top-level keys -- every one of them a cache -- and carried no onboarding marker at all, while the
# host's file held 50 keys including `hasCompletedOnboarding` and `lastOnboardingVersion`. So every
# jailed launch re-ran onboarding, which is where the unreadable dark-mode text lives (REDS %408 was
# the mount; this is the content).
#
# COPYING IS NOT GUESSING. The values come from `$HOME/.claude.json`, which Claude itself wrote on
# this pier, so the schema is observed rather than invented -- and only the two onboarding keys are
# carried, leaving theme, auth, and every cache to the jailed session's own record. When the host
# file is absent or unreadable the elder behaviour stands and `{}` is written, since a pier with no
# host record has nothing to copy and nothing is lost by asking once.
if [ ! -f "${CLAUDE_STATE}/dot-claude.json" ]; then
  printf '%s\n' '{}' >"${CLAUDE_STATE}/dot-claude.json"
fi
if command -v python3 >/dev/null 2>&1; then
  python3 - "${HOST_HOME}/.claude.json" "${CLAUDE_STATE}/dot-claude.json" <<'SEED_PY' || true
import json, sys
host, jail = sys.argv[1], sys.argv[2]
try:
    h = json.load(open(host))
except Exception:
    sys.exit(0)
try:
    j = json.load(open(jail))
except Exception:
    j = {}
carried = False
for k in ("hasCompletedOnboarding", "lastOnboardingVersion"):
    if k in h and k not in j:
        j[k] = h[k]; carried = True
if carried:
    json.dump(j, open(jail, "w"))
    print("agent-jail: carried the host's onboarding markers into the jailed state", file=sys.stderr)
SEED_PY
fi
MAP_ARGS+=(--rw-map "${CLAUDE_STATE}/dot-claude.json:${HOST_HOME}/.claude.json")

# THE CAPTAIN'S VIEW -- peer trees mounted READ-ONLY, credentials denied outright.
#
# Seated `20260905` on Keaton's word. The captain holds law and review, and review wants to read a
# peer's working tree -- including what it has not committed, which is the one thing `xy` cannot
# show. The enclosure binds ONE tree by design (REDS %291: a shared checkout bit four times in a
# day), and this does not loosen that: every peer arrives with `--map`, which is read-only, so the
# captain can read a peer's work and cannot become a second writer in it.
#
# WHAT IS DENIED, and why denial rather than masking. Three paths inside every peer tree hold
# credentials rather than work: `.gnupg-rye` is that ship's signing key, `.ssh` its deploy key, and
# `loops/` its agent auth. `--deny-path` answers a permission error; `--mask` would answer an empty
# directory, and an empty directory reads like a ship that has no keys rather than one whose keys
# are none of the captain's business. A wall should say it is a wall.
#
# OPT-IN PER LAUNCH, and refused from any tree but the captain's. An unattended lap never sets the
# variable, so the fleet's ordinary shape is unchanged; a hand asking to review sets it and says so.
if [ "${FLEET_CAPTAIN_VIEW:-0}" = 1 ]; then
  _cap_tree="$(basename "$REPO_ROOT")"
  if [ "$_cap_tree" != grain-incense ]; then
    echo "agent-jail: FLEET_CAPTAIN_VIEW is the captain's, and this is $_cap_tree -- refusing" >&2
    exit 2
  fi
  _cap_pier="$(dirname "$REPO_ROOT")"
  _cap_scan="$REPO_ROOT/tools/fixtures/f/fleet_roster_scan.sh"
  if [ ! -f "$_cap_scan" ]; then
    echo "agent-jail: FLEET_CAPTAIN_VIEW needs the roster scan at $_cap_scan -- refusing" >&2
    exit 2
  fi
  _cap_n=0
  for _cap_seat in $(sh "$_cap_scan" --live 2>/dev/null); do
    _cap_name="$(sh "$_cap_scan" --tree "$_cap_seat" 2>/dev/null)"
    [ -n "$_cap_name" ] || continue
    [ "$_cap_name" = "$_cap_tree" ] && continue          # the captain's own tree is already rw
    [ -d "$_cap_pier/$_cap_name" ] || continue           # a seat with no tree on this pier is skipped
    MAP_ARGS+=(--map "$_cap_pier/$_cap_name")
    MAP_ARGS+=(--deny-path "$_cap_pier/$_cap_name/.gnupg-rye")
    MAP_ARGS+=(--deny-path "$_cap_pier/$_cap_name/.ssh")
    MAP_ARGS+=(--deny-path "$_cap_pier/$_cap_name/loops")
    _cap_n=$((_cap_n + 1))
  done
  echo "agent-jail: captain's view -- $_cap_n peer tree(s) read-only, keys and loops denied" >&2
fi

# NixOS: ai-jail tmpfs-replaces /run. Map back the pieces the agent needs:
# current-system for PATH, nscd for glibc getaddrinfo, resolvconf when
# /etc/resolv.conf is a symlink into /run. Without nscd, cursor-agent dies
# with getaddrinfo EAI_AGAIN on api2.cursor.sh (Host pier 20260904.083936).
# Do not map all of /run -- that would expose /run/user sockets.
if [ -e /run/current-system/sw ]; then
  MAP_ARGS+=(--map /run/current-system)
fi
if [ -e /run/nscd ]; then
  MAP_ARGS+=(--map /run/nscd)
fi
if [ -e /run/resolvconf ]; then
  MAP_ARGS+=(--map /run/resolvconf)
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
