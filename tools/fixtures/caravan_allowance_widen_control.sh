#!/bin/sh
# caravan_allowance_widen_control.sh -- prove the finding in caravan/allowances.rye is load-bearing.
#
# WHY. The module asserts that every Caravan bound with a Microkit counterpart sits inside the
# framework's number. An assert nobody has ever seen fail is a sentence, not a check. So this control
# widens one of those Caravan bounds past its counterpart in a throwaway pen, builds the module
# against the widened copy, and requires the module's own self-test to REFUSE -- and to refuse with
# an assertion failure rather than for any other reason.
#
# WHY IT BUILDS INSIDE tools/.build RATHER THAN IN /tmp. `rye build` resolves a module's bare-name
# imports against the repository it is run from, so a pen outside the tree fails to find them and the
# check would pass on a missing binary instead of on a refused invariant. That is exactly the vacuous
# plant this tree has now caught three times in one season, so the pen lives in the tree and the
# whole import closure is copied into it, `tally_copy.rye` symlink included.
#
# WHY IT ALSO PROVES THE UNWIDENED BUILD. A refusal only means something beside a welcome: the same
# pen, with the bound left alone, must build and pass. Otherwise a broken pen reads as a proof.
#
# Usage: sh tools/fixtures/caravan_allowance_widen_control.sh <zig> <pen-dir>
# Prints: baseline=<ok|failed> widened=<refused|passed|build_failed> assertion_named=<yes|no> verdict=ok|drift

set -u

zig="$1"
pen="$2"

rm -rf "$pen"
mkdir -p "$pen/caravan" "$pen/tally"
cp caravan/allowances.rye caravan/channels.rye caravan/capabilities.rye \
   caravan/derivation.rye caravan/refusals.rye "$pen/caravan/" 2>/dev/null || {
  echo "baseline=failed widened=build_failed assertion_named=no verdict=drift"; exit 0; }
cp tally/copy.rye "$pen/tally/copy.rye" 2>/dev/null || {
  echo "baseline=failed widened=build_failed assertion_named=no verdict=drift"; exit 0; }
( cd "$pen/caravan" && ln -sf ../tally/copy.rye tally_copy.rye )

# The welcome: the pen builds and passes with every bound left as the tree keeps it.
baseline=failed
if env RYE_ZIG="$zig" rye/bin/rye build "$pen/caravan/allowances.rye" -femit-bin="$pen/baseline" >/dev/null 2>&1; then
  if "$pen/baseline" selftest >/dev/null 2>&1; then baseline=ok; fi
fi

# The refusal: one Caravan bound widened past its Microkit counterpart, 16 channels to 64 against 62.
sed -i 's|^pub const max_channels: u32 = 16;|pub const max_channels: u32 = 64;|' "$pen/caravan/channels.rye"

widened=build_failed
assertion_named=no
if env RYE_ZIG="$zig" rye/bin/rye build "$pen/caravan/allowances.rye" -femit-bin="$pen/widened" >/dev/null 2>&1; then
  # The abort message is the shell reporting a signal, and the signal IS the proof, so it is
  # kept out of the report rather than printed as though something had gone wrong.
  if sh -c '"$1" selftest > "$2" 2>&1' _ "$pen/widened" "$pen/out.txt" 2>/dev/null; then
    widened=passed
  else
    widened=refused
    grep -q 'assertion failure' "$pen/out.txt" && assertion_named=yes
  fi
fi

echo "baseline=$baseline"
echo "widened=$widened"
echo "assertion_named=$assertion_named"
if [ "$baseline" = ok ] && [ "$widened" = refused ] && [ "$assertion_named" = yes ]; then
  echo "verdict=ok"
else
  echo "verdict=drift"
fi
