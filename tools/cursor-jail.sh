#!/usr/bin/env bash
# cursor-jail.sh — start Cursor (AppImage) inside ai-jail with project-local state.
#
# Tracked in git (unlike tools/launch-cursor.sh, which remains a personal copy).
#
#   ./tools/cursor-jail.sh
#   ./tools/cursor-jail.sh --appimage squashfs-root/AppRun
#   ./tools/cursor-jail.sh --extract ./Cursor-3.9.16-x86_64.AppImage
#   ./tools/cursor-jail.sh --gpu
#
# From Rishi (default AppRun; edit apprun in the .rish file to override):
#   rishi/bin/rishi run tools/launch-cursor.rish
#
# See: SOURCE.md Step 9 and context/specs/enclosure-editors.md

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

APPRUN="$REPO_ROOT/squashfs-root/AppRun"
USE_GPU_CLI=false
EXTRACT=""

usage() {
  cat <<'EOF'
Usage: ./tools/cursor-jail.sh [options] [APPRUN]

  APPRUN            Path to Cursor AppRun (positional; default: squashfs-root/AppRun)
  --appimage PATH   Same as positional APPRUN (legacy; prefer rishi run launch-cursor.rish)
  --extract IMAGE   Extract an AppImage into squashfs-root/, then launch
  --gpu             Pass --gpu to ai-jail (GNOME Wayland / WebGPU)
  -h, --help        Show this help

Equivalent manual command (from the repository root):

  ai-jail --private-home --no-docker -- ./squashfs-root/AppRun --no-sandbox \
    --user-data-dir="$PWD/.cursor-state/user-data" \
    --extensions-dir="$PWD/.cursor-state/extensions" "$PWD"
EOF
}

while [ $# -gt 0 ]; do
  case "$1" in
    --appimage)
      APPRUN="${2:?cursor-jail: --appimage needs a path}"
      shift 2
      ;;
    --extract)
      EXTRACT="${2:?cursor-jail: --extract needs an AppImage path}"
      shift 2
      ;;
    --gpu)
      USE_GPU_CLI=true
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    --*)
      echo "cursor-jail: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
    *)
      APPRUN="$1"
      shift
      ;;
  esac
done

if [ -n "$EXTRACT" ]; then
  if [ ! -f "$EXTRACT" ]; then
    echo "cursor-jail: AppImage not found: $EXTRACT" >&2
    exit 1
  fi
  rm -rf "$REPO_ROOT/squashfs-root"
  (cd "$REPO_ROOT" && "$EXTRACT" --appimage-extract)
  APPRUN="$REPO_ROOT/squashfs-root/AppRun"
fi

if [ "${APPRUN#/}" = "$APPRUN" ]; then
  APPRUN="$REPO_ROOT/$APPRUN"
fi

CONF="${ENCLOSURE_CONF:-$REPO_ROOT/tools/enclosure.conf}"
if [ -f "$CONF" ]; then
  # shellcheck source=/dev/null
  source "$CONF"
fi

REPO="${REPO:-$REPO_ROOT}"
CURSOR_STATE="${CURSOR_STATE:-$REPO/.cursor-state}"
AIJAIL_FLAGS="${AIJAIL_FLAGS:---private-home --no-docker}"
LANE_KVM="${LANE_KVM:-false}"
ENCLOSURE="${ENCLOSURE:-ai-jail}"

# Retreat flag (Claude 212412) · master-seal (Claude 213600): pond only after
# exit bron present AND detached .asc verifies against master 0646 2132… alone.
EXIT_BRON="${REPO_ROOT}/bron-resins/pond-supersede-exit.bron"
if [ "$ENCLOSURE" = "pond" ]; then
  if ! bash "${REPO_ROOT}/tools/pond_exit_bron_master_seal.sh" --require; then
    exit 1
  fi
elif [ "$ENCLOSURE" != "ai-jail" ]; then
  echo "REFUSE: ENCLOSURE must be ai-jail or pond (got: ${ENCLOSURE})" >&2
  exit 1
fi

# A-narrow: LANE_KVM authorizes /dev/kvm via our gate, not via teacher ai-jail.
# ai-jail has no --kvm; keep the lane off for daily editor sessions. One-shot
# proven-seat boots use tools/run_with_lane_kvm.sh on a host that already has
# /dev/kvm. Pond customs graduate this fact at supersede.
if [ "$LANE_KVM" = "true" ]; then
  echo "cursor-jail: LANE_KVM=true — teacher ai-jail does not pass /dev/kvm." >&2
  echo "  Daily editors stay lane-off. One-shot: ./tools/run_with_lane_kvm.sh -- …" >&2
  echo "  Refuse floor: rishi/bin/rishi run tools/lane_kvm_refuse.rish" >&2
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

Install:
  cargo install ai-jail
  # or: nix profile install github:akitaonrails/ai-jail

Set AIJAIL_BIN in tools/enclosure.conf if needed.
EOF
  exit 1
fi

if [ ! -x "$APPRUN" ]; then
  echo "cursor-jail: AppRun not found or not executable: $APPRUN" >&2
  echo "Extract once: ./tools/cursor-jail.sh --extract ./Cursor-3.9.16-x86_64.AppImage" >&2
  exit 1
fi

mkdir -p "$CURSOR_STATE/user-data" "$CURSOR_STATE/extensions"

GPU_ARGS=()
if [ "$USE_GPU_CLI" = true ] || [ "${USE_GPU:-false}" = true ]; then
  GPU_ARGS=(--gpu)
fi

# --no-save-config: do not merge this run into .ai-jail (which may hold other defaults).
# shellcheck disable=SC2086
exec "$AIJAIL_ABS" --no-save-config $AIJAIL_FLAGS "${GPU_ARGS[@]}" -- \
  "$APPRUN" --no-sandbox \
  --user-data-dir="$CURSOR_STATE/user-data" \
  --extensions-dir="$CURSOR_STATE/extensions" \
  "$REPO"
