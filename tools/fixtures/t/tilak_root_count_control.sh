#!/bin/sh
# tools/fixtures/t/tilak_root_count_control.sh -- the tilak root-count drift scan, proven both ways.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every reading here
# is shown from both sides: planted and refused, then removed and welcomed. Twenty cases run in a
# throwaway pen holding just the two files the scan reads.
#
# CASE 2 IS THE ONE THIS GUARD EXISTS FOR. A third root wired into `mark_verdict` -- the engine now
# answering `.known` on a mark the marked value's foundation never granted -- refuses here, and
# passed every guard standing in the tree on 20260910, including the pedestal's own leg inside
# tools/gen/chapter/src_first_resident_witness.rish, which greps that pedestal for three words it
# already contains and never opens the engine.
#
# CASE 3 IS ITS WELCOME, and the reason this scan spells no number of its own: a third root granted
# honestly -- published in the engine, wired into the verdict, and displayed on the pedestal -- walks
# free. The pair may grow on Keaton's word; a guard that reds on the granted growth is a guard
# somebody turns off.
#
# CASE 6 IS THE NAMES READING'S OWN. One root's VALUE renamed in the engine and in the arm together
# leaves both counts at two on both sides, so a guard comparing counts stays perfectly quiet while
# the pair underneath it has changed -- which is the lesson `shape-tablecloth-error-paths.glow`
# carries one pedestal over, arriving here as a wire-visible fault: a mark's value is what a vessel
# writes on its shoulder line, so renaming it renames the cargo class every reader sorts by.
#
# CASE 8 IS THE SECOND COUNT'S OWN. A root published as a `pub const` and never wired into
# `mark_verdict` leaves the arms at two, so the engine names a mark it then refuses -- and the arms
# reading alone cannot see it.
#
# CASES 9 AND 10 ARE WHY THIS CONTROL EXISTS AT ALL. The scan's header argued a fifth reading
# away as one that could never fire alone, and case 10 is the case that argument missed -- so the
# reading went back in. Read from both sides: An arm spelled as a bare literal
# rather than through the published constant is WELCOMED, because a mark's value is what a vessel
# writes on its shoulder line and the two spellings answer identically. The moment that copy
# DIVERGES from the constant it copied, the names reading refuses. A guard earns its quiet by
# saying where it is quiet.
#
# EXPECTED: control_verdict=ok, with welcomes=5 and refusals=16.
#
# Driven by tools/t/tilak_root_count_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/t/tilak_root_count_scan.sh"
desk_src="$root/src/shape/tilak-root-count.glow"
rye_src="$root/amphora/manifest_entry.rye"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

welcomes=0
refusals=0
wrong=0

# pen -- a fresh copy of exactly the two files the scan reads, and nothing else.
pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/amphora"
  cp "$desk_src" "$work/pen/src/shape/tilak-root-count.glow"
  cp "$rye_src" "$work/pen/amphora/manifest_entry.rye"
}

# check <label> <want-verdict> <refuse|welcome>
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

deskf="$work/pen/src/shape/tilak-root-count.glow"
ryef="$work/pen/amphora/manifest_entry.rye"

arm_manifest='    if (std.mem.eql(u8, mark, mark_manifest)) return .known;'

# 1 -- the tree as it stands.
pen
check "the pedestal and the engine as written" agree welcome

# 2 -- a third root wired into the verdict and shown nowhere.
pen
edit "$ryef" "s|^$arm_manifest\$|&\\n    if (std.mem.eql(u8, mark, \"tile\")) return .known;|"
check "a third root answered by the engine alone" known_count_disagree refuse

# 3 -- the same root granted honestly in all three places, and welcomed.
pen
edit "$ryef" 's|^pub const mark_manifest = "manifest";$|&\npub const mark_tile = "tile";|'
edit "$ryef" "s|^$arm_manifest\$|&\\n    if (std.mem.eql(u8, mark, mark_tile)) return .known;|"
edit "$deskf" 's/^::  example    2$/::  example    3/'
edit "$deskf" 's/^::    manifest$/&\n::    tile/'
check "a third root granted in engine, verdict, and pedestal" agree welcome

# 4 -- the engine loses an arm, so it answers on one root while naming two.
pen
edit "$ryef" "s|^$arm_manifest\$||"
check "a root published and no longer answered" known_count_disagree refuse

# 5 -- the pedestal alone claims a third root.
pen
edit "$deskf" 's/^::  example    2$/::  example    3/'
edit "$deskf" 's/^::    manifest$/&\n::    tile/'
check "a third root shown by the pedestal alone" known_count_disagree refuse

# 6 -- one root's value renamed in the engine, both counts unmoved.
pen
edit "$ryef" 's|^pub const mark_manifest = "manifest";$|pub const mark_manifest = "vessel";|'
check "a root renamed in the engine, the counts unmoved" root_names_disagree refuse

# 7 -- the same rename carried onto the pedestal, and welcomed.
pen
edit "$ryef" 's|^pub const mark_manifest = "manifest";$|pub const mark_manifest = "vessel";|'
edit "$deskf" 's/^::    manifest$/::    vessel/'
check "a root renamed in both rooms" agree welcome

# 8 -- a root published and never wired, which the arms reading alone cannot see.
pen
edit "$ryef" 's|^pub const mark_manifest = "manifest";$|&\npub const mark_tile = "tile";|'
edit "$deskf" 's/^::  example    2$/::  example    3/'
edit "$deskf" 's/^::    manifest$/&\n::    tile/'
check "a root published and never wired into the verdict" known_count_disagree refuse

# 9 -- an arm spelled as a bare literal rather than through the published constant, and WELCOMED.
# This is the scan's own blind spot, kept here as a case rather than described in prose. A mark's
# value is what a vessel writes on its shoulder line, so an arm comparing "manifest" and one
# comparing `mark_manifest` answer identically and the wire cannot tell them apart. The spelling is
# a single-source concern rather than a root-set fault, and the reading declines to call it one.
pen
edit "$ryef" "s|^$arm_manifest\$|    if (std.mem.eql(u8, mark, \"manifest\")) return .known;|"
check "an arm spelled as a bare literal, still the published value" agree welcome

# 10 -- and the moment that spelling becomes a DIVERGENCE, the names reading bites. The constant
# moves and the literal stays, so the engine answers on a mark it no longer publishes.
pen
edit "$ryef" "s|^$arm_manifest\$|    if (std.mem.eql(u8, mark, \"manifest\")) return .known;|"
edit "$ryef" 's|^pub const mark_manifest = "manifest";$|pub const mark_manifest = "vessel";|'
check "a bare-literal arm diverged from the constant it copied" rye_internal_disagree refuse

# 11 -- the pedestal's count drifts above its own list.
pen
edit "$deskf" 's/^::  example    2$/::  example    3/'
check "the pedestal's count above its own list" desk_self_disagree refuse

# 12 -- and below it.
pen
edit "$deskf" 's/^::    manifest$/&\n::    tile/'
check "the pedestal's list above its own count" desk_self_disagree refuse

# 13 -- the pedestal stops naming the file its roots come from.
pen
edit "$deskf" 's|amphora/manifest_entry\.rye|the engine|'
check "the pedestal naming no source file" desk_citation_missing refuse

# 14 -- the placard's six lines fall out of their seated order.
pen
edit "$deskf" 's/^::  example    2$/::  zample    2/'
check "the placard out of its seated order" desk_placard_wrong refuse

# 15 -- the region's closing sentence goes, so the list has no end.
pen
edit "$deskf" 's/^::  that is the whole pair\.$/::  and so on./'
check "the root region left unclosed" desk_roots_missing refuse

# 16 -- the pedestal is gone.
pen
rm -f "$deskf"
check "the pedestal absent" desk_missing refuse

# 17 -- the engine is gone.
pen
rm -f "$ryef"
check "the engine absent" rye_missing refuse

# 18 -- the engine publishes no roots at all.
pen
edit "$ryef" 's|^pub const mark_plain_bytes = "plain-bytes";$||'
edit "$ryef" 's|^pub const mark_manifest = "manifest";$||'
check "an engine publishing no roots" rye_consts_missing refuse

# 19 -- the verdict answers on nothing.
pen
edit "$ryef" 's|^    if (std.mem.eql(u8, mark, mark_plain_bytes)) return .known;$||'
edit "$ryef" "s|^$arm_manifest\$||"
check "a verdict answering known on nothing" rye_arms_missing refuse

# 20 -- an arm naming a constant the engine never published, which is named rather than passed over.
pen
edit "$ryef" "s|^$arm_manifest\$|    if (std.mem.eql(u8, mark, mark_absent)) return .known;|"
check "an arm naming an unpublished constant" root_names_disagree refuse

# 21 -- the pedestal's own prose grows, and the reading stays quiet.
pen
edit "$deskf" 's/^::  that is the whole pair\.$/&\n::\n::  A later paragraph naming plain-bytes and manifest again, in prose./'
check "prose beyond the region naming the roots again" agree welcome

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "wrong=$wrong"

if [ "$welcomes" -eq 5 ] && [ "$refusals" -eq 16 ] && [ "$wrong" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
