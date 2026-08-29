#!/bin/sh
# tools/fixtures/m/mind_source_adaptation_control.sh -- prove MIND adaptation gates both ways.
set -eu

pass=0
fail=0

check() {
  label=$1
  want=$2
  shift 2
  out=$(sh tools/fixtures/m/mind_source_adaptation_scan.sh --decide "$@" 2>&1 || true)
  case "$out" in
    *"adaptation_verdict=$want"*) pass=$((pass + 1)); echo "$label -- ok" ;;
    *) fail=$((fail + 1)); echo "$label -- FAIL (wanted $want)" ;;
  esac
}

good_tail='authored mind new recorded proven clear tracked booked'

# shellcheck disable=SC2086 -- the tail is deliberately eight positional policy fields.
check '1 free: shell may accrete as Rishi' welcome .sh .rish $good_tail
# shellcheck disable=SC2086
check '2 free: Bash may accrete as Rishi' welcome .bash .rish $good_tail
# shellcheck disable=SC2086
check '3 free: HTML may accrete as Brush' welcome .html .brush $good_tail
# shellcheck disable=SC2086
check '4 free: Python may accrete as Glow when booked' welcome .py .glow $good_tail

check '5 bitten: Rye input refuses' refused .rye .rish authored mind new recorded proven clear tracked booked
check '6 bitten: vendor input refuses' refused .sh .rish vendor mind new recorded proven clear tracked booked
check '7 bitten: submodule input refuses' refused .html .brush submodule mind new recorded proven clear tracked booked
check '8 bitten: generated input refuses' refused .py .glow generated mind new recorded proven clear tracked booked
check '9 bitten: fixture input refuses' refused .sh .rish fixture mind new recorded proven clear tracked booked
check '10 bitten: sibling ownership refuses' refused .py .glow authored dream new recorded proven clear tracked booked
check '11 bitten: overwrite refuses' refused .html .brush authored neutral existing recorded proven clear tracked booked
check '12 bitten: missing provenance refuses' refused .sh .rish authored mind new missing proven clear tracked booked
check '13 bitten: unproven equivalence refuses' refused .bash .rish authored mind new recorded unproven clear tracked booked
check '14 bitten: unclear license refuses' refused .html .brush authored mind new recorded proven unclear tracked booked
check '15 bitten: untracked source refuses' refused .py .glow authored mind new recorded proven clear untracked booked
check '16 bitten: unbooked source refuses' refused .sh .rish authored mind new recorded proven clear tracked unbooked
check '17 bitten: an analogized mapping refuses' refused .js .brush authored mind new recorded proven clear tracked booked

echo "control_cases=$((pass + fail))"
echo "control_fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=refused"
  exit 1
fi
