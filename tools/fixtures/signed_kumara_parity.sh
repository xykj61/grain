#!/usr/bin/env bash
# signed_kumara_parity.sh — parity ch02 tail: fetch gates; build+serial when bench staged.
# Jail-safe: exits 0 with ADVISE when genode bench absent (fetch still proved).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
RISHI="${RISHI:-rishi/bin/rishi}"
CACHE="tools/.cache/proven-seat"
GUEST="${CACHE}/signed-kumara-verify"
BENCH="${CACHE}/genode-build-x86_64/build.conf"

echo "signed-Kumara parity: fetch (pin · red-avoid · fixture)…"
"$RISHI" run tools/proven_seat_signed_kumara_fetch.rish

if [[ ! -f "$BENCH" && ! -f "$GUEST" ]]; then
  echo "ADVISE: signed-Kumara build+serial skipped — genode bench not staged; fetch proved (host: build_guest then serial)"
  echo "GREEN: signed-Kumara parity — fetch only (jail-safe)."
  exit 0
fi

echo "signed-Kumara parity: build guest…"
"$RISHI" run tools/proven_seat_signed_kumara_build_guest.rish

echo "signed-Kumara parity: jailed TCG serial…"
"$RISHI" run tools/proven_seat_signed_kumara.rish

echo "GREEN: signed-Kumara parity — fetch · build · serial (no KVM)."
