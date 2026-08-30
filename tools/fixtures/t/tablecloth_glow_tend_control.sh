#!/bin/sh
# tools/fixtures/t/tablecloth_glow_tend_control.sh -- the Tablecloth drift scan, proven both ways.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every reading
# here is shown from both sides: planted and refused, then removed and welcomed. Nineteen cases run
# in a throwaway pen holding just the four files the scan reads.
#
# The second case is the one this guard exists for. An elder Tend witness greps for the literal
# number in both rooms, so raising a bound honestly -- moving it in the Rye AND on the pedestal --
# still reds until a hand edits the guard. Here that raise walks free, because the scan compares
# the two rooms rather than remembering a value.
#
# The eleventh and fourteenth carry the same argument one room further, for the DERIVED bound.
# `max_content_bytes` is `= beading.max_resin_bytes`, so an honest raise moves mantra/beading.rye
# and the pedestal -- and walks free (case 11). Respelling tablecloth's derivation as a literal
# leaves every number in agreement and the link gone, and that refuses on its own reading (case
# 14), because values agreeing prove nothing about whether the two budgets are still one budget.
#
# EXPECTED: control_verdict=ok, with welcomes=3 and refusals=16.
#
# Driven by tools/t/tablecloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/t/tablecloth_glow_tend_scan.sh"
desk_src="$root/src/shape/shape-tablecloth-catalog-capacity.glow"
content_src="$root/src/shape/shape-tablecloth-content-budget.glow"
rye_src="$root/brushstroke/tablecloth.rye"
beading_src="$root/mantra/beading.rye"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

welcomes=0
refusals=0
wrong=0

# pen -- a fresh copy of exactly the four files the scan reads, and nothing else.
pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/brushstroke" "$work/pen/mantra"
  cp "$desk_src" "$work/pen/src/shape/shape-tablecloth-catalog-capacity.glow"
  cp "$content_src" "$work/pen/src/shape/shape-tablecloth-content-budget.glow"
  cp "$rye_src" "$work/pen/brushstroke/tablecloth.rye"
  cp "$beading_src" "$work/pen/mantra/beading.rye"
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

# edit <file> <sed-script> -- rewrite in place through the original inode, so a pen file keeps the
# mode it was copied with (.claude/rules/exec-bit.md).
edit() {
  f=$1
  sed "$2" "$f" > "$f.t" && cat "$f.t" > "$f" && rm -f "$f.t"
}

deskf="$work/pen/src/shape/shape-tablecloth-catalog-capacity.glow"
contentf="$work/pen/src/shape/shape-tablecloth-content-budget.glow"
ryef="$work/pen/brushstroke/tablecloth.rye"
beadingf="$work/pen/mantra/beading.rye"

# 1 -- the tree as it stands.
pen
check "the pedestals as written" agree welcome

# 2 -- the honest raise: the literal bound moves in BOTH rooms and the guard stays quiet.
pen
edit "$deskf" 's/^::  example    32$/::  example    64/'
edit "$ryef" 's/^pub const max_artifacts: u32 = 32;$/pub const max_artifacts: u32 = 64;/'
check "a literal bound raised in both rooms" agree welcome

# 3 -- the pedestal drifts ahead of the Rye.
pen
edit "$deskf" 's/^::  example    32$/::  example    33/'
check "the desk moved alone" disagree refuse

# 4 -- the Rye drifts ahead of the pedestal, which is the direction that actually happens.
pen
edit "$ryef" 's/^pub const max_artifacts: u32 = 32;$/pub const max_artifacts: u32 = 64;/'
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
edit "$deskf" 's|brushstroke/tablecloth.rye|the rye module|'
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

# 11 -- the honest raise of a DERIVED bound: the number moves where it is decided, the pedestal
# follows, and tablecloth.rye is not touched at all because it never held the value.
pen
edit "$beadingf" 's/^pub const max_resin_bytes: u32 = 512;$/pub const max_resin_bytes: u32 = 1024;/'
edit "$contentf" 's/^::  example    512$/::  example    1024/'
check "a derived bound raised where it is decided" agree welcome

# 12 -- the content pedestal drifts ahead of beading.
pen
edit "$contentf" 's/^::  example    512$/::  example    1024/'
check "the content desk moved alone" content_disagree refuse

# 13 -- beading drifts ahead of the content pedestal.
pen
edit "$beadingf" 's/^pub const max_resin_bytes: u32 = 512;$/pub const max_resin_bytes: u32 = 1024;/'
check "beading moved alone" content_disagree refuse

# 14 -- the derivation respelled as a literal. Every number still agrees; the link is gone, and
# the next raise of max_resin_bytes would move one room and leave the other behind.
pen
edit "$ryef" 's/^pub const max_content_bytes: u32 = beading\.max_resin_bytes;$/pub const max_content_bytes: u32 = 512;/'
check "the derivation respelled as a literal" derivation_broken refuse

# 15 -- the deciding room's address dropped from the content pedestal.
pen
edit "$contentf" 's|mantra/beading.rye|the beading module|g'
check "the deciding citation stripped" content_citation_missing refuse

# 16 -- a placard line dropped from the content pedestal.
pen
grep -v '^::  invariant ' "$contentf" > "$contentf.t" && cat "$contentf.t" > "$contentf" && rm -f "$contentf.t"
check "a content placard line dropped" content_placard_wrong refuse

# 17 -- the content pedestal gone.
pen
rm -f "$contentf"
check "the content pedestal absent" content_desk_missing refuse

# 18 -- the deciding module gone.
pen
rm -f "$beadingf"
check "the beading module absent" beading_missing refuse

# 19 -- beading present and its bound no longer published.
pen
grep -v '^pub const max_resin_bytes: u32 = ' "$beadingf" > "$beadingf.t" && cat "$beadingf.t" > "$beadingf" && rm -f "$beadingf.t"
check "the beading bound unpublished" beading_bound_missing refuse

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "wrong=$wrong"

if [ "$welcomes" -eq 3 ] && [ "$refusals" -eq 16 ] && [ "$wrong" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
