#!/usr/bin/env bash
# run_with_lane_kvm.sh — authorize a one-shot command under lane_kvm (A-narrow).
#
# Host-side / in-jail: requires LANE_KVM=true and /dev/kvm. Teacher ai-jail is
# never modified; this wrapper is our gate. Prefer for proven-seat witnesses.
# Daily editor sessions keep LANE_KVM=false until Pond customs graduate the lane.
#
#   ./tools/run_with_lane_kvm.sh -- tools/proven_seat_g0c_lane_kvm.sh
#   ./tools/run_with_lane_kvm.sh -- qemu-system-x86_64 …

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

if [ "${1:-}" = "--" ]; then
  shift
fi
if [ "$#" -eq 0 ]; then
  echo "Usage: ./tools/run_with_lane_kvm.sh -- <command...>" >&2
  exit 1
fi

exec "$REPO_ROOT/tools/lane_kvm.sh" run -- "$@"
