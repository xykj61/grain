#!/usr/bin/env bash
# glow_host_run.sh — run a command with THIS host's pinned toolchain, never
# a silent PATH fallback.
#
#   ./tools/glow_host_run.sh -- rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi
#   ./tools/glow_host_run.sh -- rishi/bin/rishi run tools/parity.rish
#
# Reads GLOW_HOST.bron (copy from GLOW_HOST.template.bron and fill in your
# own paths), sets RYE_ZIG and RYE_LIB from it, refuses to run if the file's
# declared os/arch does not match this actual host (`uname -s`/`uname -m`),
# and only then execs the given command.
#
# Why this exists: rye's own build command resolves its Zig backend as
# RYE_ZIG if set, else whatever `zig` happens to be on PATH — which silently
# mismatches the pinned std on any host with a different Zig installed. See
# external-research/20260714-005658_native-arm64-parity-witness-run.md for
# the exact failure this caused, once, on this project's own Mac.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

CONF="${GLOW_HOST_CONF:-$REPO_ROOT/GLOW_HOST.bron}"

if [ "${1:-}" = "--" ]; then
  shift
fi
if [ "$#" -eq 0 ]; then
  echo "Usage: ./tools/glow_host_run.sh -- <command...>" >&2
  exit 1
fi

if [ ! -f "$CONF" ]; then
  cat <<EOF >&2
glow_host_run: $CONF not found.

Copy the template and fill in your own paths:
  cp GLOW_HOST.template.bron GLOW_HOST.bron
EOF
  exit 1
fi

# Bron is plain key-value, one field per line, space-separated, # comments.
bron_get() {
  awk -v k="$1" '$1 == k { $1=""; sub(/^ /, ""); print; exit }' "$CONF"
}

declared_os="$(bron_get os)"
declared_arch="$(bron_get arch)"
rye_zig="$(bron_get rye_zig)"
rye_lib="$(bron_get rye_lib)"

actual_os="$(uname -s | tr '[:upper:]' '[:lower:]')"
case "$actual_os" in
  darwin*) actual_os="macos" ;;
esac
actual_arch="$(uname -m)"
case "$actual_arch" in
  arm64) actual_arch="aarch64" ;;
esac

if [ "$declared_os" != "$actual_os" ] || [ "$declared_arch" != "$actual_arch" ]; then
  cat <<EOF >&2
glow_host_run: REFUSE — GLOW_HOST.bron declares os=$declared_os arch=$declared_arch,
but this host is actually os=$actual_os arch=$actual_arch.

GLOW_HOST.bron is personal and machine-specific. Re-copy the template on
this host and fill in this host's own toolchain paths, rather than reusing
a config written for a different machine.
EOF
  exit 1
fi

if [ -z "$rye_zig" ] || [ ! -x "$rye_zig" ]; then
  echo "glow_host_run: REFUSE — rye_zig '$rye_zig' is not an executable file." >&2
  exit 1
fi
if [ -z "$rye_lib" ] || [ ! -d "$rye_lib" ]; then
  echo "glow_host_run: REFUSE — rye_lib '$rye_lib' is not a directory." >&2
  exit 1
fi

export RYE_ZIG="$rye_zig"
export RYE_LIB="$rye_lib"

exec "$@"
