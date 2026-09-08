#!/bin/sh
# Prove ROUND MODE both ways: equal compare GREEN; deliberate new dangling RED
# even under LINK_WITNESS_ALLOW_BASELINE=1. Restore scratch afterward.
set -eu
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

# A PEN THE KERNEL NAMES, never a constant (REDS %549 and the wiping subset of
# `tools/fixtures/s/shared_pen_scan.sh`, the one that scan asks be driven to zero first). Eight
# ships run this guard from eight checkouts on one pier and therefore one TMPDIR, so
# `/tmp/link_witness_round_selfcheck_before.txt` was the SAME file on all of them. Two failures ride
# on that, and the second is the worse one. A peer's `rm -f` between the write at line 31 and the
# read at line 32 answers `FAIL: snapshot file missing`, which is loud. A peer's SNAPSHOT landing
# between this tree's snapshot and its compare is silent: the compare then asks whether this tree's
# dangling set grew against a set taken from SOMEBODY ELSE'S TREE, and a comparison of two different
# trees can read GREEN while a real new dangling link stands. `mktemp -d` cannot collide, and the
# three run logs below move into the same pen for the same reason.
PEN=$(mktemp -d)
SNAP="$PEN/before.txt"
SCRATCH=construction/_link_witness_round_mode_scratch.md
cleanup() {
  rm -f "$SCRATCH"
  rm -rf "$PEN"
}
trap cleanup EXIT INT TERM

# The scratch is a constant path inside THIS tree -- per-checkout, so no peer shares it -- and a
# killed prior run can leave one behind. The snapshot needs no wipe: a fresh pen holds nothing.
rm -f "$SCRATCH"

echo "round_selfcheck: SNAPSHOT clean tree…"
LINK_WITNESS_SNAPSHOT="$SNAP" sh tools/fixtures/l/link_witness_scan.sh >"$PEN/snap.out"
test -f "$SNAP" || { echo "FAIL: snapshot file missing"; exit 1; }

echo "round_selfcheck: COMPARE equal (must GREEN)…"
if ! LINK_WITNESS_COMPARE="$SNAP" sh tools/fixtures/l/link_witness_scan.sh >"$PEN/cmp_ok.out"; then
  echo "FAIL: equal compare went RED"
  cat "$PEN/cmp_ok.out"
  exit 1
fi
grep -Eq 'AFTER ⊆ BEFORE|no new missing targets' "$PEN/cmp_ok.out" || {
  echo "FAIL: missing subset OK line"
  cat "$PEN/cmp_ok.out"
  exit 1
}

echo "round_selfcheck: break one link in scratch…"
printf '%s\n' '# scratch' '' '[broken](./no-such-file-round-mode-proof.md)' >"$SCRATCH"

echo "round_selfcheck: COMPARE with ALLOW_BASELINE=1 (must RED — baseline ignored)…"
set +e
LINK_WITNESS_ALLOW_BASELINE=1 LINK_WITNESS_COMPARE="$SNAP" \
  sh tools/fixtures/l/link_witness_scan.sh >"$PEN/cmp_red.out" 2>&1
rc=$?
set -e
if [ "$rc" -eq 0 ]; then
  echo "FAIL: compare stayed GREEN under ALLOW_BASELINE — mode toothless; STOP"
  cat "$PEN/cmp_red.out"
  exit 1
fi
grep -Eq 'NEW dangling:|NEW missing_target:' "$PEN/cmp_red.out" || {
  echo "FAIL: compare RED without naming the addition"
  cat "$PEN/cmp_red.out"
  exit 1
}
grep -q '_link_witness_round_mode_scratch.md' "$PEN/cmp_red.out" || {
  echo "FAIL: addition not attributed to scratch file"
  cat "$PEN/cmp_red.out"
  exit 1
}

cleanup
trap - EXIT INT TERM
echo "OK   link_witness ROUND MODE self-check — equal GREEN · break RED · baseline ignored"
exit 0
