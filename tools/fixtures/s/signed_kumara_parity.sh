#!/usr/bin/env bash
# signed_kumara_parity.sh -- parity ch02 tail: fetch gates; build+serial when bench staged.
# Jail-safe: exits 0 with ADVISE when genode bench absent (fetch still proved).
set -euo pipefail

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT"
RISHI="${RISHI:-rishi/bin/rishi}"
CACHE="tools/.cache/proven-seat"
GUEST="${CACHE}/signed-kumara-verify"
BENCH="${CACHE}/genode-build-x86_64/build.conf"

echo "signed-Kumara parity: fetch (pin · red-avoid · fixture)…"
"$RISHI" run tools/p/proven_seat_signed_kumara_fetch.rish

if [[ ! -f "$BENCH" && ! -f "$GUEST" ]]; then
  echo "ADVISE: signed-Kumara build+serial skipped — genode bench not staged; fetch proved (host: build_guest then serial)"
  echo "GREEN: signed-Kumara parity — fetch only (jail-safe)."
  exit 0
fi

echo "signed-Kumara parity: build guest…"
"$RISHI" run tools/p/proven_seat_signed_kumara_build_guest.rish

echo "signed-Kumara parity: jailed TCG serial…"
"$RISHI" run tools/p/proven_seat_signed_kumara.rish

echo "GREEN: signed-Kumara parity — fetch · build · serial (no KVM)."
