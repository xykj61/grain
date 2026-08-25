#!/bin/sh
# caravan_address_space_join_control.sh -- prove the join in caravan/address_space.rye is load-bearing.
#
# WHY. The module asserts that every size the policy ring can declare, rounded to pages, is a size the
# geometry ring can plan. An assert nobody has ever seen fail is a sentence, not a check. So this
# control widens `regions.max_region_bytes` past `mapping.max_plan_bytes` in a throwaway pen, builds
# the module against the widened copy, and requires the module's own self-test to REFUSE -- and to
# refuse with an assertion failure rather than for any other reason.
#
# WHY IT BUILDS INSIDE tools/.build RATHER THAN IN /tmp. `rye build` resolves a module's bare-name
# imports against the repository it is run from, so a pen outside the tree fails to find them and the
# check would pass on a missing binary instead of on a refused invariant -- the vacuous plant this
# tree caught three times in one season. The pen lives in the tree and the whole import closure is
# copied into it, `tally_copy.rye` symlink included.
#
# WHY IT ALSO PROVES THE UNWIDENED BUILD. A refusal only means something beside a welcome: the same
# pen, with the bound left alone, must build and pass. Otherwise a broken pen reads as a proof.
#
# WHY IT PROVES THE ROUNDING TOO. The join is two claims, and widening a bound tests only the first.
# The second -- that rounding up never loses a byte and never moves a size already on a page -- is
# proven by narrowing the page a declaration is rounded to, which makes an already-paged size round
# to something larger than itself and reds the idempotence assert.
#
# Usage: sh tools/fixtures/caravan_address_space_join_control.sh <zig> <pen-dir>
# Prints: baseline=<ok|failed> widened=<refused|passed|build_failed> rounding=<refused|passed|build_failed>
#         assertion_named=<yes|no> verdict=ok|drift

set -u

zig="$1"
pen="$2"

fail_out() {
  echo "baseline=failed"
  echo "widened=build_failed"
  echo "rounding=build_failed"
  echo "assertion_named=no"
  echo "verdict=drift"
  exit 0
}

rm -rf "$pen"
mkdir -p "$pen/caravan" "$pen/tally"
cp caravan/address_space.rye caravan/regions.rye caravan/mapping.rye "$pen/caravan/" 2>/dev/null || fail_out
cp tally/copy.rye "$pen/tally/copy.rye" 2>/dev/null || fail_out
( cd "$pen/caravan" && ln -sf ../tally/copy.rye tally_copy.rye ) || fail_out

# The welcome: the pen builds and passes with every bound left as the tree keeps it.
baseline=failed
if env RYE_ZIG="$zig" rye/bin/rye build "$pen/caravan/address_space.rye" -femit-bin="$pen/baseline" >/dev/null 2>&1; then
  if "$pen/baseline" selftest >/dev/null 2>&1; then baseline=ok; fi
fi

# Keep a clean copy of each module, so the two refusals are independent rather than cumulative.
cp "$pen/caravan/regions.rye" "$pen/regions.clean"
cp "$pen/caravan/mapping.rye" "$pen/mapping.clean"

run_refusal() {
  # $1 the binary name, $2 the output file. Prints refused|passed|build_failed on stdout.
  if env RYE_ZIG="$zig" rye/bin/rye build "$pen/caravan/address_space.rye" -femit-bin="$pen/$1" >/dev/null 2>&1; then
    # The abort message is the shell reporting a signal, and the signal IS the proof, so it is kept
    # out of the report rather than printed as though something had gone wrong.
    if sh -c '"$1" selftest > "$2" 2>&1' _ "$pen/$1" "$pen/$2" 2>/dev/null; then
      echo passed
    else
      echo refused
    fi
  else
    echo build_failed
  fi
}

# 1. THE BOUND. The policy ring widened past what the geometry ring can plan: 16 MiB to 1 TiB,
#    against an Sv39 address space of 512 GiB.
sed -i 's|^pub const max_region_bytes: u64 = 16 \* 1024 \* 1024;|pub const max_region_bytes: u64 = 1024 * 1024 * 1024 * 1024;|' "$pen/caravan/regions.rye"
widened=$(run_refusal widened out_widened.txt)

assertion_named=no
[ -f "$pen/out_widened.txt" ] && grep -q 'assertion failure' "$pen/out_widened.txt" && assertion_named=yes

# 2. THE ROUNDING. Restore the bound, then narrow the page a declaration rounds to, so a size already
#    on a page no longer is and the idempotence assert reds.
cp "$pen/regions.clean" "$pen/caravan/regions.rye"
sed -i 's|^pub const page_bits: u6 = 12;|pub const page_bits: u6 = 13;|' "$pen/caravan/mapping.rye"
rounding=$(run_refusal rounding out_rounding.txt)
cp "$pen/mapping.clean" "$pen/caravan/mapping.rye"

echo "baseline=$baseline"
echo "widened=$widened"
echo "rounding=$rounding"
echo "assertion_named=$assertion_named"
if [ "$baseline" = ok ] && [ "$widened" = refused ] && [ "$rounding" = refused ] && [ "$assertion_named" = yes ]; then
  echo "verdict=ok"
else
  echo "verdict=drift"
fi
