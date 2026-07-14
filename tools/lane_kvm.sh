#!/usr/bin/env bash
# lane_kvm — A-narrow gate for /dev/kvm (counsel 20260712.090512).
#
# Off by default. When on, authorizes use of exactly /dev/kvm — no D-Bus,
# no systemd host units, no session buses. Teacher ai-jail stays unmodified;
# this gate lives in our enclosure.conf + launch wrappers.
#
#   ./tools/lane_kvm.sh status
#   ./tools/lane_kvm.sh assert-off
#   ./tools/lane_kvm.sh assert-on
#   ./tools/lane_kvm.sh run -- <command...>
#   ./tools/lane_kvm.sh refuse-probe

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CONF="${ENCLOSURE_CONF:-$REPO_ROOT/tools/enclosure.conf}"

# Caller export wins over enclosure.conf — one-shot without editing the file:
#   LANE_KVM=true ./tools/run_with_lane_kvm.sh -- ./tools/proven_seat_g0c_lane_kvm.sh
# Daily editors keep LANE_KVM=false in conf; refuse-probe still reads conf when unset.
_CALLER_LANE_KVM="${LANE_KVM-}"

if [ -f "$CONF" ]; then
  # shellcheck source=/dev/null
  source "$CONF"
fi

if [ -n "${_CALLER_LANE_KVM}" ]; then
  LANE_KVM="${_CALLER_LANE_KVM}"
else
  LANE_KVM="${LANE_KVM:-false}"
fi

lane_on() {
  [ "$LANE_KVM" = "true" ]
}

usage() {
  cat <<'EOF'
Usage: ./tools/lane_kvm.sh <command>

  status         Print lane + /dev/kvm presence
  assert-off     Exit 0 only when LANE_KVM is off (default)
  assert-on      Exit 0 only when LANE_KVM=true and /dev/kvm exists
  run -- CMD…    Refuse when lane off; otherwise require /dev/kvm and exec CMD
  refuse-probe   Prove run refuses while lane is off (paired refuse floor)

Config: LANE_KVM in tools/enclosure.conf (see enclosure.conf.example).
  One-shot without editing conf: LANE_KVM=true ./tools/run_with_lane_kvm.sh -- <cmd>
  Full host sitting: rishi/bin/rishi run tools/lane_kvm_onpath_host.rish [--parity]
EOF
}

cmd="${1:-}"
case "$cmd" in
  ""|-h|--help)
    usage
    exit 0
    ;;
  status)
    if lane_on; then
      echo "LANE_KVM=on"
    else
      echo "LANE_KVM=off"
    fi
    if [ -e /dev/kvm ]; then
      echo "kvm=present"
    else
      echo "kvm=absent"
    fi
    ;;
  assert-off)
    if lane_on; then
      echo "REFUSE: LANE_KVM is on (want off for refuse witness)" >&2
      exit 1
    fi
    echo "OK: lane_kvm off"
    ;;
  assert-on)
    if ! lane_on; then
      echo "REFUSE: LANE_KVM is off — set LANE_KVM=true in tools/enclosure.conf" >&2
      exit 1
    fi
    if [ ! -e /dev/kvm ]; then
      echo "REFUSE: /dev/kvm absent — relaunch from host with KVM granted (Pond customs later; one-shot: tools/run_with_lane_kvm.sh)" >&2
      exit 1
    fi
    echo "OK: lane_kvm on + /dev/kvm present"
    ;;
  run)
    shift
    if [ "${1:-}" = "--" ]; then
      shift
    fi
    if [ "$#" -eq 0 ]; then
      echo "REFUSE: lane_kvm run needs a command" >&2
      exit 1
    fi
    if ! lane_on; then
      echo "REFUSE: lane_kvm off — will not grant KVM to: $*" >&2
      exit 2
    fi
    if [ ! -e /dev/kvm ]; then
      echo "REFUSE: /dev/kvm absent" >&2
      exit 3
    fi
    exec "$@"
    ;;
  refuse-probe)
    if lane_on; then
      echo "RED: LANE_KVM is on — refuse-probe expects lane off" >&2
      exit 1
    fi
    set +e
    out="$("$0" run -- /bin/true 2>&1)"
    rc=$?
    set -e
    if [ "$rc" -eq 0 ]; then
      echo "RED: lane_kvm run succeeded while lane off" >&2
      exit 1
    fi
    case "$out" in
      *REFUSE*)
        echo "OK: lane_kvm refused run while off"
        ;;
      *)
        echo "RED: refuse-probe missing REFUSE text: $out" >&2
        exit 1
        ;;
    esac
    ;;
  *)
    echo "lane_kvm: unknown command: $cmd" >&2
    usage >&2
    exit 1
    ;;
esac
