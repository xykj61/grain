#!/bin/sh
# Prove ROUND MODE both ways: equal compare GREEN; deliberate new dangling RED
# even under LINK_WITNESS_ALLOW_BASELINE=1. Restore scratch afterward.
set -eu
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

SNAP=/tmp/link_witness_round_selfcheck_before.txt
SCRATCH=construction/_link_witness_round_mode_scratch.md
cleanup() {
  rm -f "$SCRATCH"
}
trap cleanup EXIT INT TERM

rm -f "$SNAP" "$SCRATCH"

echo "round_selfcheck: SNAPSHOT clean tree…"
LINK_WITNESS_SNAPSHOT="$SNAP" sh tools/fixtures/link_witness_scan.sh >/tmp/lw_snap.out
test -f "$SNAP" || { echo "FAIL: snapshot file missing"; exit 1; }

echo "round_selfcheck: COMPARE equal (must GREEN)…"
if ! LINK_WITNESS_COMPARE="$SNAP" sh tools/fixtures/link_witness_scan.sh >/tmp/lw_cmp_ok.out; then
  echo "FAIL: equal compare went RED"
  cat /tmp/lw_cmp_ok.out
  exit 1
fi
grep -Eq 'AFTER ⊆ BEFORE|no new missing targets' /tmp/lw_cmp_ok.out || {
  echo "FAIL: missing subset OK line"
  cat /tmp/lw_cmp_ok.out
  exit 1
}

echo "round_selfcheck: break one link in scratch…"
printf '%s\n' '# scratch' '' '[broken](./no-such-file-round-mode-proof.md)' >"$SCRATCH"

echo "round_selfcheck: COMPARE with ALLOW_BASELINE=1 (must RED — baseline ignored)…"
set +e
LINK_WITNESS_ALLOW_BASELINE=1 LINK_WITNESS_COMPARE="$SNAP" \
  sh tools/fixtures/link_witness_scan.sh >/tmp/lw_cmp_red.out 2>&1
rc=$?
set -e
if [ "$rc" -eq 0 ]; then
  echo "FAIL: compare stayed GREEN under ALLOW_BASELINE — mode toothless; STOP"
  cat /tmp/lw_cmp_red.out
  exit 1
fi
grep -Eq 'NEW dangling:|NEW missing_target:' /tmp/lw_cmp_red.out || {
  echo "FAIL: compare RED without naming the addition"
  cat /tmp/lw_cmp_red.out
  exit 1
}
grep -q '_link_witness_round_mode_scratch.md' /tmp/lw_cmp_red.out || {
  echo "FAIL: addition not attributed to scratch file"
  cat /tmp/lw_cmp_red.out
  exit 1
}

cleanup
trap - EXIT INT TERM
echo "OK   link_witness ROUND MODE self-check — equal GREEN · break RED · baseline ignored"
exit 0
