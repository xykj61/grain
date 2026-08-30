#!/bin/sh
# tools/fixtures/t/tablecloth_glow_tend_control.sh -- the Tablecloth drift scan, proven both ways.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every reading
# here is shown from both sides: planted and refused, then removed and welcomed. Ten cases run in
# a throwaway pen holding just the two files the scan reads.
#
# The second case is the one this guard exists for. An elder Tend witness greps for the literal
# number in both rooms, so raising a bound honestly -- moving it in the Rye AND on the pedestal --
# still reds until a hand edits the guard. Here that raise walks free, because the scan compares
# the two rooms rather than remembering a value.
#
# EXPECTED: control_verdict=ok, with welcomes=2 and refusals=8.
#
# Driven by tools/t/tablecloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/t/tablecloth_glow_tend_scan.sh"
desk_src="$root/src/shape/shape-tablecloth-catalog-capacity.glow"
rye_src="$root/brushstroke/tablecloth.rye"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

welcomes=0
refusals=0
wrong=0

# pen -- a fresh copy of exactly the two files the scan reads, and nothing else.
pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/brushstroke"
  cp "$desk_src" "$work/pen/src/shape/shape-tablecloth-catalog-capacity.glow"
  cp "$rye_src" "$work/pen/brushstroke/tablecloth.rye"
}

# check <label> <want-verdict> <want refuse|welcome>
check() {
  label=$1
  want=$2
  side=$3
  code=0
  out=$(sh "$scan" "$work/pen" 2>/dev/null) || code=$?
  got=$(printf '%s\n' "$out" | sed -n 's/^verdict=//p' | head -1)
  if [ "$side" = refuse ]; then
    if [ "$got" = "$want" ] && [ "$code" -ne 0 ]; then
      refusals=$((refusals + 1))
      echo "  refused $label ($got)"
    else
      wrong=$((wrong + 1))
      echo "  WRONG   $label -- wanted $want and a refusal, got $got exit $code"
    fi
  else
    if [ "$got" = "$want" ] && [ "$code" -eq 0 ]; then
      welcomes=$((welcomes + 1))
      echo "  welcome $label ($got)"
    else
      wrong=$((wrong + 1))
      echo "  WRONG   $label -- wanted $want and a welcome, got $got exit $code"
    fi
  fi
}

deskf="$work/pen/src/shape/shape-tablecloth-catalog-capacity.glow"
ryef="$work/pen/brushstroke/tablecloth.rye"

# 1 -- the tree as it stands.
pen
check "the pedestal as written" agree welcome

# 2 -- the honest raise: the bound moves in BOTH rooms and the guard stays quiet.
pen
sed 's/^::  example    32$/::  example    64/' "$deskf" > "$deskf.t" && cat "$deskf.t" > "$deskf" && rm -f "$deskf.t"
sed 's/^pub const max_artifacts: u32 = 32;$/pub const max_artifacts: u32 = 64;/' "$ryef" > "$ryef.t" && cat "$ryef.t" > "$ryef" && rm -f "$ryef.t"
check "a bound raised in both rooms" agree welcome

# 3 -- the pedestal drifts ahead of the Rye.
pen
sed 's/^::  example    32$/::  example    33/' "$deskf" > "$deskf.t" && cat "$deskf.t" > "$deskf" && rm -f "$deskf.t"
check "the desk moved alone" disagree refuse

# 4 -- the Rye drifts ahead of the pedestal, which is the direction that actually happens.
pen
sed 's/^pub const max_artifacts: u32 = 32;$/pub const max_artifacts: u32 = 64;/' "$ryef" > "$ryef.t" && cat "$ryef.t" > "$ryef" && rm -f "$ryef.t"
check "the rye moved alone" disagree refuse

# 5 -- a placard line dropped.
pen
grep -v '^::  readers ' "$deskf" > "$deskf.t" && cat "$deskf.t" > "$deskf" && rm -f "$deskf.t"
check "a placard line dropped" placard_wrong refuse

# 6 -- the placard's seated order disturbed.
pen
awk '
  /^::  example / { ex = $0; next }
  /^::  readers / { print $0; print ex; next }
  { print }
' "$deskf" > "$deskf.t" && cat "$deskf.t" > "$deskf" && rm -f "$deskf.t"
check "the placard reordered" placard_wrong refuse

# 7 -- the source citation stripped, leaving a number with nowhere to be checked.
pen
sed 's|brushstroke/tablecloth.rye|the rye module|' "$deskf" > "$deskf.t" && cat "$deskf.t" > "$deskf" && rm -f "$deskf.t"
check "the citation stripped" citation_missing refuse

# 8 -- the pedestal gone.
pen
rm -f "$deskf"
check "the pedestal absent" desk_missing refuse

# 9 -- the Rye module gone.
pen
rm -f "$ryef"
check "the rye module absent" rye_missing refuse

# 10 -- the Rye module present and its bound no longer published.
pen
grep -v '^pub const max_artifacts: u32 = ' "$ryef" > "$ryef.t" && cat "$ryef.t" > "$ryef" && rm -f "$ryef.t"
check "the rye bound unpublished" rye_bound_missing refuse

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "wrong=$wrong"

if [ "$welcomes" -eq 2 ] && [ "$refusals" -eq 8 ] && [ "$wrong" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
