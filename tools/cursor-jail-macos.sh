#!/usr/bin/env bash
# cursor-jail-macos.sh — start Cursor (native macOS .app/CLI) inside a
# sandbox-exec (Seatbelt) enclosure, with project-local state, mirroring
# tools/cursor-jail.sh's ai-jail launcher on Linux as closely as macOS allows.
#
#   ./tools/cursor-jail-macos.sh
#   ./tools/cursor-jail-macos.sh --no-network
#   ./tools/cursor-jail-macos.sh --harden-home     # deny real ~/.ssh, ~/.gnupg, etc.
#   ./tools/cursor-jail-macos.sh --print-profile   # show the generated SBPL, don't launch
#
# --harden-home denies reads to the real credential stores under $HOME
# (~/.ssh, ~/.gnupg, ~/.aws, and the rest -- see the list below) rather
# than a blanket dotfile deny, because Seatbelt on this host resolves an
# overlapping allow/deny pair to deny regardless of order or specificity
# -- a blanket deny-dotfiles-then-allow-back-.gitconfig approach silently
# loses the allow-back. Generate and register dedicated jail-local keys
# first with tools/generate_jail_local_keys_macos.rish, run from an
# ordinary terminal outside any jail -- see the macOS guide.
#
# See: external-research/20260713-202929_macos-enclosure-and-qemu-vs-vz-study.md
# and SOURCE.md Step 6/9 (the Linux/NixOS path this mirrors).
#
# What this gives you, and what it does not:
#   - Writes are fenced to the project directory and its own state dirs.
#   - Reads stay open everywhere (enumerating every toolchain read path is a
#     maintenance trap this project's own study already named as the accepted
#     trade-off other sandbox-exec-based agent harnesses make too).
#   - Network is allowed by default; pass --no-network to deny it outright.
#     There is no partial/allow-list network filtering at this layer (Seatbelt
#     has no per-host filter); that would need a proxy in front, a separate,
#     later piece of work.
#   - There is no macOS equivalent of --private-home: this script does NOT
#     hide your real $HOME from the sandboxed process's *reads* (see above).
#     It only fences *writes*.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

CONF="${ENCLOSURE_CONF:-$REPO_ROOT/tools/enclosure.conf}"
if [ -f "$CONF" ]; then
  # shellcheck source=/dev/null
  source "$CONF"
fi

REPO="${REPO:-$REPO_ROOT}"
CURSOR_STATE="${CURSOR_STATE:-$REPO/.cursor-state}"
# The .app binary directly -- NOT the `cursor` CLI wrapper. The wrapper
# (ELECTRON_RUN_AS_NODE + cli.js) spawns the real app in a detached dance
# that dies silently under Seatbelt (bootstrap_check_in "Permission
# denied"), exits 0, and launches nothing. Confirmed on this host 20260714.
CURSOR_BIN="${CURSOR_BIN:-/Applications/Cursor.app/Contents/MacOS/Cursor}"
ALLOW_NETWORK=true
PRINT_ONLY=false
HARDEN_HOME=false
PRIVATE_HOME=false

usage() {
  cat <<'EOF'
Usage: ./tools/cursor-jail-macos.sh [options]

  --no-network      Deny all network access inside the sandbox
  --harden-home      Deny reads to real ~/.ssh, ~/.gnupg, and other
                      credential stores under $HOME
  --private-home     Deny reads to every real $HOME entry except this
                      project's own directory (enumerated fresh at launch)
  --print-profile    Print the generated SBPL profile and exit; do not launch
  -h, --help          Show this help
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --no-network)
      ALLOW_NETWORK=false
      shift
      ;;
    --harden-home)
      HARDEN_HOME=true
      shift
      ;;
    --private-home)
      PRIVATE_HOME=true
      shift
      ;;
    --print-profile)
      PRINT_ONLY=true
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "cursor-jail-macos: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

if ! command -v sandbox-exec >/dev/null 2>&1; then
  echo "cursor-jail-macos: sandbox-exec not found -- this script is macOS-only." >&2
  exit 1
fi

if [ ! -x "$CURSOR_BIN" ] && ! command -v "$CURSOR_BIN" >/dev/null 2>&1; then
  cat <<EOF >&2
cursor-jail-macos: '$CURSOR_BIN' not found.

Install Cursor.app to /Applications, or set CURSOR_BIN in
tools/enclosure.conf to the app's real binary
(.../Cursor.app/Contents/MacOS/Cursor -- not the CLI wrapper).
EOF
  exit 1
fi

mkdir -p "$CURSOR_STATE/user-data" "$CURSOR_STATE/extensions"

net_rule="(allow network*)"
if [ "$ALLOW_NETWORK" = false ]; then
  net_rule="(deny network*)"
fi

# --private-home: deny every top-level entry under the real $HOME except
# this project's own directory -- enumerated fresh at launch, so the
# deny-always-wins-an-overlap rule (proven under --harden-home) never has
# anything to win against, since the project's own path is simply never
# denied in the first place. The glob covers dotfiles too (.[!.]* skips
# just "." and ".."); a bare "$HOME"/* alone would miss ~/.ssh, ~/.gnupg,
# and the rest, defeating most of the point of this flag.
private_rules=""
if [ "$PRIVATE_HOME" = true ]; then
  repo_basename="$(basename "$REPO")"
  private_rules="; --private-home: deny every top-level entry under the real \$HOME
; except this project's own directory -- enumerated fresh at launch,
; so the deny-always-wins-an-overlap rule never has anything to win
; against (the project's path is simply never denied)."
  for e in "$HOME"/* "$HOME"/.[!.]*; do
    [ -e "$e" ] || continue
    n="$(basename "$e")"
    [ "$n" = "$repo_basename" ] && continue
    private_rules="$private_rules
(deny file-read* (subpath \"$e\"))"
  done
fi

harden_rules=""
if [ "$HARDEN_HOME" = true ]; then
  harden_rules="$(cat <<HARDEN
; --harden-home: deny reads on the specific real credential stores
; under \$HOME -- SSH/GPG private keys, cloud and forge tokens. Deny
; always wins an overlap on this host, so the list stays a deny-only,
; named set rather than a blanket dotfile deny with an allow-back.
(deny file-read* (subpath "$HOME/.ssh"))
(deny file-read* (subpath "$HOME/.gnupg"))
(deny file-read* (subpath "$HOME/.aws"))
(deny file-read* (subpath "$HOME/.config/gh"))
(deny file-read* (subpath "$HOME/.terraform.d"))
(deny file-read* (subpath "$HOME/.docker"))
(deny file-read* (subpath "$HOME/.kube"))
(deny file-read* (subpath "$HOME/.azure"))
(deny file-read* (subpath "$HOME/.gcloud"))
(deny file-read* (literal "$HOME/.codeberg-token"))
(deny file-read* (literal "$HOME/.netrc"))
(deny file-read* (literal "$HOME/.git-credentials"))
(deny file-read* (literal "$HOME/.npmrc"))
HARDEN
)"
fi

PROFILE="$(cat <<SBPL
(version 1)
(deny default)

; Reads stay open everywhere -- enumerating every toolchain read path
; (git, node, python, cargo, and their transitive dependencies) is a
; maintenance trap; the write fence below is the real boundary.
(allow file-read*)
$harden_rules
$private_rules

; Writes fenced to the project directory and its own state.
(allow file-write*
  (subpath "$REPO")
  (subpath "/tmp")
  (subpath "/private/tmp")
  (subpath "/private/var/folders"))

; /dev/null is not a path under the write fence above, and the deny-default
; denies it too -- but Electron writes to it constantly from startup on.
; A write-only discard device; nothing to read back or escalate through,
; so allowing it plainly does not weaken the fence above.
(allow file-write* (literal "/dev/null"))

; Process exec/fork -- Cursor spawns helper processes, extension hosts,
; language servers, and shells; all of that stays inside this same profile
; since a child inherits its parent's sandbox on macOS.
(allow process-exec)
(allow process-fork)
(allow process-info* (target same-sandbox))
(allow signal)
(allow sysctl-read)

; Mach and POSIX IPC -- Electron registers a MachPortRendezvousServer at
; startup (bootstrap_check_in), aborting outright without mach-register;
; mach-task-name covers its codesign self-check (task_name_for_pid); the
; rest follows upstream ai-jail's own proven macOS static section (see
; gratitude/ai-jail/).
(allow mach-lookup)
(allow mach-register)
(allow mach-host*)
(allow mach-task-name)
(allow ipc-posix-shm-read-data)
(allow ipc-posix-shm-write-data)
(allow ipc-posix-shm-read-metadata)
(allow ipc-posix-shm-write-create)
(allow ipc-posix-sem)

; Pseudo-terminals (integrated terminal) and standard devices.
(allow pseudo-tty)
(allow file-ioctl)
(allow file-read* file-write* (literal "/dev/ptmx"))
(allow file-read* file-write* (regex #"^/dev/ttys[0-9]+"))
(allow file-write* (literal "/dev/zero"))
(allow file-write* (literal "/dev/random"))
(allow file-write* (literal "/dev/urandom"))

(allow iokit-open)

$net_rule
SBPL
)"

if [ "$PRINT_ONLY" = true ]; then
  printf '%s\n' "$PROFILE"
  exit 0
fi

PROFILE_FILE="$(mktemp -t cursor-jail-macos)"
trap 'rm -f "$PROFILE_FILE"' EXIT
printf '%s\n' "$PROFILE" > "$PROFILE_FILE"

# --no-sandbox: Chromium's own internal sandbox cannot nest inside
# Seatbelt -- its GPU and network helpers abort and take the whole app
# down ("GPU process isn't usable. Goodbye."). Same law SOURCE.md Step 9
# names for Linux (Chromium's sandbox cannot nest inside bwrap either);
# the real boundary here is Seatbelt. Confirmed on this host 20260714.
#
# --new-window as belt-and-suspenders: with a distinct user-data-dir the
# app is its own instance anyway, but this guards against any forwarding
# to an already-running unsandboxed Cursor.
exec sandbox-exec -f "$PROFILE_FILE" -- "$CURSOR_BIN" \
  --no-sandbox \
  --user-data-dir="$CURSOR_STATE/user-data" \
  --extensions-dir="$CURSOR_STATE/extensions" \
  --new-window \
  "$REPO"
