#!/bin/sh
# tools/fixtures/t/tablecloth_glow_tend_control.sh -- the Tablecloth drift scan, proven both ways.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every reading
# here is shown from both sides: planted and refused, then removed and welcomed. Twenty-eight cases
# run in a throwaway pen holding just the five files the scan reads.
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
# Cases 20 through 28 hold the third pedestal, whose number counts NAMES. Case 21 is the one that
# reading exists for: a path renamed in the Rye alone leaves the count at nine on both sides, so a
# guard comparing counts stays perfectly quiet while the set underneath it has changed. Here the
# names are compared as sets and it refuses. Case 20 is its welcome -- a tenth path added honestly
# in all three places walks free, because the scan carries no roster of its own.
#
# EXPECTED: control_verdict=ok, with welcomes=4 and refusals=24.
#
# Driven by tools/t/tablecloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/t/tablecloth_glow_tend_scan.sh"
desk_src="$root/src/shape/shape-tablecloth-catalog-capacity.glow"
content_src="$root/src/shape/shape-tablecloth-content-budget.glow"
error_src="$root/src/shape/shape-tablecloth-error-paths.glow"
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
  cp "$error_src" "$work/pen/src/shape/shape-tablecloth-error-paths.glow"
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
errorf="$work/pen/src/shape/shape-tablecloth-error-paths.glow"
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

# 20 -- the honest growth of an error SET: a tenth path declared in the Rye, listed on the desk,
# and counted by the desk's own example. Three real rooms move and the guard stays quiet, because
# it holds no roster of its own.
pen
edit "$ryef" 's/^    BadManifest,$/    BadManifest,\n    NameFrozen,/'
edit "$errorf" 's/^::    CatalogFull - ContentTooLarge - Overflow - BadManifest$/::    CatalogFull - ContentTooLarge - Overflow - BadManifest - NameFrozen/'
edit "$errorf" 's/^::  example    9$/::  example    10/'
check "a tenth refusal path added in all three places" agree welcome

# 21 -- THE case this reading exists for. One path renamed in the Rye alone. The count is nine on
# both sides and stays nine, so a guard comparing counts sees nothing at all; the sets differ.
pen
edit "$ryef" 's/^    NameTaken,$/    NameHeld,/'
check "a path renamed under an unchanged count" error_names_disagree refuse

# 22 -- the desk's example moved alone, so the pedestal contradicts its own list.
pen
edit "$errorf" 's/^::  example    9$/::  example    10/'
check "the error desk disagrees with itself" error_desk_self_disagree refuse

# 23 -- a name added to the desk and counted there, and never declared in the Rye.
pen
edit "$errorf" 's/^::    CatalogFull - ContentTooLarge - Overflow - BadManifest$/::    CatalogFull - ContentTooLarge - Overflow - BadManifest - NameFrozen/'
edit "$errorf" 's/^::  example    9$/::  example    10/'
check "the error desk names a path the rye does not" error_names_disagree refuse

# 24 -- a placard line dropped from the error pedestal.
pen
grep -v '^::  readers ' "$errorf" > "$errorf.t" && cat "$errorf.t" > "$errorf" && rm -f "$errorf.t"
check "an error placard line dropped" error_placard_wrong refuse

# 25 -- the source citation stripped, leaving nine names with nowhere to be checked against.
pen
edit "$errorf" 's|brushstroke/tablecloth.rye|the rye module|g'
check "the error citation stripped" error_citation_missing refuse

# 26 -- the error pedestal gone.
pen
rm -f "$errorf"
check "the error pedestal absent" error_desk_missing refuse

# 27 -- the Rye present and its error set no longer published.
pen
edit "$ryef" 's/^pub const ClothError = error{$/pub const ClothError = struct{/'
check "the rye error set unpublished" rye_error_paths_missing refuse

# 28 -- the enumeration's opening sentence reworded, so the region no longer reads. The desk's
# names become unreadable rather than wrong, and the verdict says so rather than blaming the set.
pen
edit "$errorf" 's/^::  the refusal paths, as ClothError declares them:$/::  the refusal paths ClothError declares:/'
check "the enumeration region unreadable" error_enumeration_missing refuse

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "wrong=$wrong"

if [ "$welcomes" -eq 4 ] && [ "$refusals" -eq 24 ] && [ "$wrong" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
