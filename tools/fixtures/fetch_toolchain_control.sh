#!/bin/sh
# tools/fixtures/fetch_toolchain_control.sh -- the refusal proven, without a 55 MB download.
#
# WHY. tools/fixtures/fetch_toolchain_scan.sh decides, on one comparison, whether 55 megabytes of
# downloaded binary become the compiler that builds everything in this tree. That comparison is
# the single most consequential `if` in the beginner path, and a check that has never refused is a
# check nobody has tested.
#
# So the trust decision is exercised here on small local files whose answers are known before the
# tool runs -- the network is not the thing under test, the REFUSAL is.
#
# THREE CASES
#   matching  -- bytes whose hash is the expected one            -> verdict=verified, exit 0
#   corrupted -- the same bytes with one flipped                 -> verdict=REFUSED,  exit non-zero
#   absent    -- a file that is not there at all                 -> verdict=missing,  exit non-zero
#
# Driven by tools/fetch_toolchain_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

printf 'a pinned toolchain, byte for byte' > "$work/good.bin"
printf 'a pinned toolchain, byte for bytE' > "$work/bad.bin"

if command -v sha256sum >/dev/null 2>&1; then
  expect=$(sha256sum "$work/good.bin" | cut -d' ' -f1)
else
  expect=$(shasum -a 256 "$work/good.bin" | cut -d' ' -f1)
fi

run_verify() {
  code=0
  out=$(sh "$root/tools/fixtures/fetch_toolchain_scan.sh" verify "$1" "$2" 2>/dev/null) || code=$?
  printf '%s\n' "$out" | sed -n 's/^verdict=/verdict=/p'
  echo "exit_nonzero=$([ "$code" -ne 0 ] && echo yes || echo no)"
}

echo "case=matching"
run_verify "$work/good.bin" "$expect" | sed 's/^/  /'

echo "case=corrupted"
run_verify "$work/bad.bin" "$expect" | sed 's/^/  /'

echo "case=absent"
run_verify "$work/nothing-here.bin" "$expect" | sed 's/^/  /'

good_ok=$(sh "$root/tools/fixtures/fetch_toolchain_scan.sh" verify "$work/good.bin" "$expect" >/dev/null 2>&1 && echo yes || echo no)
bad_ok=$(sh "$root/tools/fixtures/fetch_toolchain_scan.sh" verify "$work/bad.bin" "$expect" >/dev/null 2>&1 && echo yes || echo no)
absent_ok=$(sh "$root/tools/fixtures/fetch_toolchain_scan.sh" verify "$work/nothing-here.bin" "$expect" >/dev/null 2>&1 && echo yes || echo no)

echo "matching_accepted=$good_ok"
echo "corrupted_accepted=$bad_ok"
echo "absent_accepted=$absent_ok"

if [ "$good_ok" = yes ] && [ "$bad_ok" = no ] && [ "$absent_ok" = no ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
