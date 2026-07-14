#!/usr/bin/env bash
# glow_host_run_witness.sh — proves tools/glow_host_run.sh actually closes the
# RYE_ZIG/RYE_LIB PATH-fallback footgun, on this host, fresh every run.
#
# Permit witness: correct GLOW_HOST.bron builds cleanly with no pre-set env.
# Refuse witness: a GLOW_HOST.bron declaring the wrong os is rejected.
#
# Run: ./tools/glow_host_run_witness.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

if [ ! -f "GLOW_HOST.bron" ]; then
  echo "SKIP: no GLOW_HOST.bron on this host yet -- copy GLOW_HOST.template.bron and fill it in first." >&2
  exit 0
fi

echo "== permit witness: build rishi with no RYE_ZIG/RYE_LIB pre-set =="
if env -u RYE_ZIG -u RYE_LIB ./tools/glow_host_run.sh -- \
    rye/bin/rye version >/tmp/glow_host_witness_permit.out 2>&1; then
  echo "PASS: rye version ran using GLOW_HOST.bron's declared toolchain"
  cat /tmp/glow_host_witness_permit.out
else
  echo "FAIL: permit run did not succeed" >&2
  cat /tmp/glow_host_witness_permit.out >&2
  rm -f /tmp/glow_host_witness_permit.out
  exit 1
fi
rm -f /tmp/glow_host_witness_permit.out

echo "== refuse witness: wrong declared os is rejected =="
WRONG_CONF="$(mktemp -t glow_host_witness_wrong)"
sed 's/^os .*/os the-wrong-os/' GLOW_HOST.bron > "$WRONG_CONF"
if GLOW_HOST_CONF="$WRONG_CONF" ./tools/glow_host_run.sh -- rye/bin/rye version \
    >/tmp/glow_host_witness_refuse.out 2>&1; then
  echo "FAIL: a mismatched os was not refused" >&2
  cat /tmp/glow_host_witness_refuse.out >&2
  rm -f "$WRONG_CONF" /tmp/glow_host_witness_refuse.out
  exit 1
else
  echo "PASS: mismatched os was refused"
fi
rm -f "$WRONG_CONF" /tmp/glow_host_witness_refuse.out

echo "== both witnesses green =="
