#!/bin/sh
# tools/fixtures/g/glow_nib_census_control.sh -- the census counts -v0 and skips -v2.
#
# A throwaway tree holds one comlink -v0 nib and one comlink -v2 nib. The scan
# counts the first and leaves both files byte-identical.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
scan=tools/fixtures/g/glow_nib_census_scan.sh
pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

mkdir -p "$pen/src/gate" "$pen/src/shape"
printf '::  nib        equinox-e1-comlink-width-v0\n' > "$pen/src/gate/width.glow"
printf '::  nib        equinox-e2-comlink-r1-v2\n' > "$pen/src/shape/dual.glow"
before=$(cksum "$pen/src/gate/width.glow" "$pen/src/shape/dual.glow")

behaviors=0
failed=0
one() {
  behaviors=$((behaviors + 1))
  name=$1
  shift
  if "$@"; then
    echo "behavior=$name ok"
  else
    echo "behavior=$name FAIL"
    failed=$((failed + 1))
  fi
}

out=$(sh "$scan" --root "$pen")
printf '%s\n' "$out" > "$pen/out.txt"
one count grep -q 'files_v0=1' "$pen/out.txt"
one nibs grep -q 'nibs_v0=1' "$pen/out.txt"
one family grep -q 'family_comlink=1' "$pen/out.txt"
one named grep -q 'family_named=comlink' "$pen/out.txt"
one bytes test "$before" = "$(cksum "$pen/src/gate/width.glow" "$pen/src/shape/dual.glow")"

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=failed"
exit 1
