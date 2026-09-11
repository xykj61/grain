#!/bin/sh
# tools/fixtures/s/shape_member_pedestal_control.sh -- the member-pedestal scan, proven both ways.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every reading is
# shown from both sides: planted and refused, then granted honestly and welcomed. Nineteen cases
# run in a throwaway pen holding just the six desks and the nine sources the scan reads.
#
# CASE 2 IS WHAT THE PEDESTALS EXIST FOR. A fourth field added to `ManifestEntry`, the desk
# unmoved -- a museum displaying a count the engine stopped keeping. It refuses here, and passes
# every guard standing on 20260910, since the desk's own leg greps for `example    3`, a string the
# desk still holds.
#
# CASE 3 IS ITS WELCOME, and the reason this scan spells no number of its own: the same field
# carried onto the desk walks free. A mold grows on Amphora's word, and a guard that reds on
# granted change is a guard somebody turns off.
#
# CASE 9 IS THE SIBLING-MODULE READING'S OWN. A grant family's WITNESS added to the room leaves the
# family count alone, because a witness is a proof of a mold rather than a mold. A reading counting
# every file in the room would refuse the ordinary act of proving something.
#
# CASES 4, 7, 12, 14 AND 18 ARE THE UNRESOLVED SIDE. A renamed struct, a renamed function, a
# renamed fixture pin, an absent source -- each is NAMED rather than read as zero, because a scan
# answering zero for what it cannot find agrees with an empty desk and looks green doing it.
#
# CASE 5 IS THE NAMES READING'S OWN, and the repair this scan opened with. Four of the six desks
# named no source at all when it was written: the number stood on the placard and a visitor had no
# declaration to reach. Strip the Source line back off and the scan refuses, so the citation cannot
# quietly leave again.
#
# EXPECTED: control_verdict=ok, with welcomes=4 and refusals=15.
#
# Driven by tools/s/shape_member_pedestal_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/s/shape_member_pedestal_scan.sh"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

welcomes=0
refusals=0
wrong=0

desks='shape-manifest-field-count shape-tube-manifest-field-count shape-grant-family-count shape-mand-ring-count shape-brush-pin-key-count shape-frame-seed-line-count'

# pen -- a fresh copy of exactly the files the scan reads, and nothing else.
pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/amphora" "$work/pen/linengrow" \
    "$work/pen/mand" "$work/pen/brushstroke"
  for d in $desks; do cp "$root/src/shape/$d.glow" "$work/pen/src/shape/$d.glow"; done
  cp "$root/amphora/manifest_entry.rye" "$work/pen/amphora/"
  cp "$root/linengrow/tube_manifest.rye" "$work/pen/linengrow/"
  for g in glow_storage_scope glow_network_grant glow_sensors_grant; do
    cp "$root/linengrow/$g.rye" "$work/pen/linengrow/"
  done
  for r in 1 2 3; do cp "$root/mand/mand_ring$r.rye" "$work/pen/mand/"; done
  cp "$root/brushstroke/brush_parse.rye" "$work/pen/brushstroke/"
  cp "$root/brushstroke/seed-frame.brush" "$work/pen/brushstroke/"
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

# edit <file> <sed-script> -- rewrite through the original inode, so a pen file keeps the mode it
# was copied with (.claude/rules/exec-bit.md).
edit() {
  f=$1
  sed "$2" "$f" > "$f.t" && cat "$f.t" > "$f" && rm -f "$f.t"
}

me="$work/pen/amphora/manifest_entry.rye"
tm="$work/pen/linengrow/tube_manifest.rye"
bp="$work/pen/brushstroke/brush_parse.rye"
fx="$work/pen/brushstroke/seed-frame.brush"
me_desk="$work/pen/src/shape/shape-manifest-field-count.glow"
tm_desk="$work/pen/src/shape/shape-tube-manifest-field-count.glow"
gr_desk="$work/pen/src/shape/shape-grant-family-count.glow"
mr_desk="$work/pen/src/shape/shape-mand-ring-count.glow"
pk_desk="$work/pen/src/shape/shape-brush-pin-key-count.glow"
sl_desk="$work/pen/src/shape/shape-frame-seed-line-count.glow"

# 1 -- the tree as it stands.
pen
check "six pedestals and their declarations as written" agree welcome

# 2 -- a fourth field in the mold, the museum unmoved.
pen
edit "$me" 's/^    name: \[\]const u8,$/    name: []const u8,\n    season: []const u8,/'
check "a mold field added in Rye and left off the desk" value_disagree:manifest_fields refuse

# 3 -- the same field carried onto the desk, and welcomed.
pen
edit "$me" 's/^    name: \[\]const u8,$/    name: []const u8,\n    season: []const u8,/'
edit "$me_desk" 's/^::  example    3$/::  example    4/'
check "a mold grown in both rooms" agree welcome

# 4 -- the struct renamed, its fields untouched.
pen
edit "$me" 's/^pub const ManifestEntry = struct {$/pub const ManifestRow = struct {/'
check "a struct renamed under a desk still naming the elder" members_unresolved:manifest_fields refuse

# 5 -- the desk's source citation stripped back off.
pen
edit "$me_desk" '/^::  Source: amphora\/manifest_entry.rye/,+1d'
check "a pedestal displaying a number and citing no declaration" source_unnamed:manifest_fields refuse

# 6 -- a fifth parameter on the manifest constructor.
pen
edit "$tm" 's/^    iteration_bound_max: u32,$/    iteration_bound_max: u32,\n    season_mark: u32,/'
check "a manifest field added at the constructor, the desk unmoved" value_disagree:tube_fields refuse

# 7 -- the constructor renamed.
pen
edit "$tm" 's/^pub fn build($/pub fn assemble(/'
check "a constructor renamed under a desk counting its parameters" members_unresolved:tube_fields refuse

# 8 -- a fourth grant family molded. THIS CASE REWROTE THE SCAN. The selector first enumerated
# the three family modules by name, so a fourth could never be counted and this planting walked
# free -- a reading that can only answer its own length. It names the family's shape now,
# `glow_*_grant.rye` and `glow_*_scope.rye`, and the fourth mold is seen the lap it lands.
pen
cp "$work/pen/linengrow/glow_sensors_grant.rye" "$work/pen/linengrow/glow_camera_grant.rye"
check "a fourth grant mold in the room, the desk still saying three" value_disagree:grant_families refuse

# 9 -- a grant family's witness, which is a proof rather than a mold.
pen
cp "$work/pen/linengrow/glow_sensors_grant.rye" "$work/pen/linengrow/glow_network_grant_witness.rye"
check "a grant witness added beside its mold" agree welcome

# 10 -- a ring module gone from the family.
pen
rm -f "$work/pen/mand/mand_ring3.rye"
check "a ring dropped from mand/ with the desk still counting three" value_disagree:mand_rings refuse

# 11 -- a fifth required pin, which is a fifth refusal.
pen
edit "$bp" 's/^    if (!pins.saw_lines_header) return error.MissingLines;$/    if (!pins.saw_lines_header) return error.MissingStyle;\n    if (!pins.saw_lines_header) return error.MissingLines;/'
check "a fifth required pin refused in Rye, the desk still saying four" value_disagree:pin_keys refuse

# 12 -- the finishing function renamed.
pen
edit "$bp" 's/^fn finish_brush_surface(pins: BrushPins) ParseError!BrushSurface {$/fn seal_brush_surface(pins: BrushPins) ParseError!BrushSurface {/'
check "the pin-checking function renamed under its desk" members_unresolved:pin_keys refuse

# 13 -- a fourth line in the seed fixture.
pen
edit "$fx" 's/^::    (seed version string)$/::    (seed version string)\n::    one line more/'
check "a fixture line added with the desk still counting three" value_disagree:seed_lines refuse

# 14 -- the fixture's own pin renamed.
pen
edit "$fx" 's/^::  lines:$/::  rows:/'
check "a fixture pin renamed under a desk counting its lines" members_unresolved:seed_lines refuse

# 15 -- the same fixture line carried onto the desk.
pen
edit "$fx" 's/^::    (seed version string)$/::    (seed version string)\n::    one line more/'
edit "$sl_desk" 's/^::  example    3$/::  example    4/'
check "a fixture and its desk grown together" agree welcome

# 16 -- a placard out of seated order.
pen
edit "$mr_desk" 's/^::  shape      rings - int (@u32)$/::  rings      shape - int (@u32)/'
check "a placard whose keywords have left their seated order" placard_wrong:mand_rings refuse

# 17 -- a desk displaying no number at all. The example line is EMPTIED rather than deleted,
# because deleting it takes the `example` keyword out of the placard too and the order reading
# refuses first -- one planting would then prove the wrong branch.
pen
edit "$pk_desk" 's/^::  example    4$/::  example  /'
check "a pedestal with its example line gone" example_missing:pin_keys refuse

# 18 -- the source file absent.
pen
rm -f "$me"
check "a declaration whose file has left the tree" members_unresolved:manifest_fields refuse

# 19 -- the desk itself absent.
pen
rm -f "$tm_desk"
check "a pedestal gone from the museum" desk_missing:tube_fields refuse

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "wrong=$wrong"
if [ "$wrong" -eq 0 ] && [ "$welcomes" -eq 4 ] && [ "$refusals" -eq 15 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=failed"
  exit 1
fi
