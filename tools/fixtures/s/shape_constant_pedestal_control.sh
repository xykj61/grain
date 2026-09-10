#!/bin/sh
# tools/fixtures/s/shape_constant_pedestal_control.sh -- the constant-pedestal scan, proven both ways.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every reading is
# shown from both sides: planted and refused, then removed or granted honestly and welcomed.
# Eighteen cases run in a throwaway pen holding just the five desks and the three Rye modules the
# scan reads.
#
# CASE 2 IS THE ONE THE PEDESTALS EXIST FOR. `max_brush_bytes` doubled in Rye, the desk unmoved --
# a museum displaying a bound the engine stopped keeping. It refuses here, and passes every guard
# standing on 20260910, since the pedestal's own leg greps the desk for `example    16384`, a
# string the desk still contains.
#
# CASE 3 IS ITS WELCOME, and the reason this scan spells no number of its own: the same doubling
# carried onto the desk walks free. The bound may move on Brushstroke's own word; a guard that reds
# on granted change is a guard somebody turns off.
#
# CASES 5 AND 7 ARE THE TWO NON-LITERAL FORMS. `brush_skate_rows` is an alias to
# `max_frame_lines`, so lowering the ceiling moves a desk whose own line never names it; and
# `max_brush_bytes` is `16 * 1024`, a product whose value appears nowhere a grep could find. Both
# resolve, and both refuse when they part from their desk.
#
# CASE 8 IS THE HONEST REFUSAL. A form the reading has never met -- `16 << 10` -- is NAMED as
# unresolved rather than read as zero, because a scan that treats what it cannot parse as agreement
# is quieter than one that says so and worth less.
#
# CASE 9 IS THE NAMES READING'S OWN. The constant renamed in Rye with its value untouched leaves
# every number equal on both sides, so a guard comparing only values stays perfectly quiet while
# the desk points at a name that is gone.
#
# CASE 15 IS THE FRAME CEILING'S OWN, and the finding this rung was written on. Eight is published
# once and written again as a private `max_lines` in two modules, each asserting against its own
# copy. Lower one and the others keep letting eight lines through in silence. CASE 17 is the repair
# that reading wants -- a private copy deleted in favour of the published constant -- and it walks
# free, because a guard that reds on the good direction points the wrong way.
#
# EXPECTED: control_verdict=ok, with welcomes=4 and refusals=14.
#
# Driven by tools/s/shape_constant_pedestal_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/s/shape_constant_pedestal_scan.sh"

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

welcomes=0
refusals=0
wrong=0

desks='shape-frame-max-lines shape-brush-skate-cols shape-brush-skate-rows shape-brush-max-bytes shape-brush-max-pin-bytes'
ryes='brush_parse.rye seed.rye wayland_seed.rye'

# pen -- a fresh copy of exactly the eight files the scan reads, and nothing else.
pen() {
  rm -rf "$work/pen"
  mkdir -p "$work/pen/src/shape" "$work/pen/brushstroke"
  for d in $desks; do cp "$root/src/shape/$d.glow" "$work/pen/src/shape/$d.glow"; done
  for r in $ryes; do cp "$root/brushstroke/$r" "$work/pen/brushstroke/$r"; done
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

bp="$work/pen/brushstroke/brush_parse.rye"
seed="$work/pen/brushstroke/seed.rye"
wl="$work/pen/brushstroke/wayland_seed.rye"
bytes_desk="$work/pen/src/shape/shape-brush-max-bytes.glow"
rows_desk="$work/pen/src/shape/shape-brush-skate-rows.glow"
lines_desk="$work/pen/src/shape/shape-frame-max-lines.glow"
pin_desk="$work/pen/src/shape/shape-brush-max-pin-bytes.glow"
cols_desk="$work/pen/src/shape/shape-brush-skate-cols.glow"

# 1 -- the tree as it stands.
pen
check "five pedestals and their constants as written" agree welcome

# 2 -- the source bound doubled, the museum unmoved.
pen
edit "$bp" 's|^pub const max_brush_bytes: u32 = 16 \* 1024;$|pub const max_brush_bytes: u32 = 32 * 1024;|'
check "a bound doubled in Rye and left standing on the desk" value_disagree:brush_max_bytes refuse

# 3 -- the same doubling carried onto the desk, and welcomed.
pen
edit "$bp" 's|^pub const max_brush_bytes: u32 = 16 \* 1024;$|pub const max_brush_bytes: u32 = 32 * 1024;|'
edit "$bytes_desk" 's/^::  example    16384$/::  example    32768/'
check "a bound moved in both rooms" agree welcome

# 4 -- the desk alone claims a different number.
pen
edit "$pin_desk" 's/^::  example    128$/::  example    256/'
check "a desk raising a bound the engine never raised" value_disagree:pin_max_bytes refuse

# 5 -- the alias broken: skate rows given its own literal, away from the frame ceiling.
pen
edit "$bp" 's|^pub const brush_skate_rows: u32 = max_frame_lines;$|pub const brush_skate_rows: u32 = 12;|'
check "an alias replaced by a literal that has drifted" value_disagree:skate_rows refuse

# 6 -- the frame ceiling lowered at its published site alone.
pen
edit "$bp" 's|^pub const max_frame_lines: u32 = 8;$|pub const max_frame_lines: u32 = 6;|'
check "the published ceiling lowered under two desks" value_disagree:frame_max_lines refuse

# 7 -- the product's factors changed, the desk unmoved.
pen
edit "$bp" 's|^pub const max_brush_bytes: u32 = 16 \* 1024;$|pub const max_brush_bytes: u32 = 8 * 1024;|'
check "a product rewritten under a desk that never saw it" value_disagree:brush_max_bytes refuse

# 8 -- a form the reading has never met, named rather than passed over.
pen
edit "$bp" 's|^pub const max_brush_bytes: u32 = 16 \* 1024;$|pub const max_brush_bytes: u32 = 16 << 10;|'
check "a constant in a form the reading cannot evaluate" constant_unresolved:brush_max_bytes refuse

# 9 -- the constant renamed in Rye, every number unmoved.
pen
edit "$bp" 's|^pub const max_pin_bytes: u32 = 128;$|pub const pin_ceiling: u32 = 128;|'
check "a constant renamed under a desk still naming the old one" constant_unpublished:pin_max_bytes refuse

# 10 -- the desk stops naming the constant it displays.
pen
edit "$cols_desk" 's/brush_skate_cols/the proof grid width/g'
check "a desk displaying a number and naming no source" constant_unnamed:skate_cols refuse

# 11 -- the placard's seated order broken.
pen
edit "$rows_desk" 's/^::  name       brush skate rows$/::  nib        surface-p37-v0/'
check "a placard out of its seated order" placard_wrong:skate_rows refuse

# 12 -- the example line kept, its value gone. Deleting the whole line breaks the placard's six
# and refuses one reading earlier, so the number is emptied in place to reach this one.
pen
edit "$pin_desk" 's/^::  example    128$/::  example    /'
check "a pedestal displaying no number at all" example_missing:pin_max_bytes refuse

# 13 -- a desk removed from the museum.
pen
rm -f "$cols_desk"
check "a pedestal missing from the museum" desk_missing:skate_cols refuse

# 14 -- the Rye module gone.
pen
rm -f "$bp"
check "the module publishing the constants absent" rye_missing:frame_max_lines refuse

# 15 -- the frame ceiling split: one private copy left behind.
pen
edit "$seed" 's|^const max_lines: u32 = 8;.*$|const max_lines: u32 = 12;|'
check "a private ceiling copy drifting from the published one" frame_ceiling_split refuse

# 16 -- the ceiling lowered at every site and on both desks, and welcomed.
pen
edit "$bp" 's|^pub const max_frame_lines: u32 = 8;$|pub const max_frame_lines: u32 = 6;|'
edit "$seed" 's|^const max_lines: u32 = 8;.*$|const max_lines: u32 = 6;|'
edit "$wl" 's|^const max_lines: u32 = 8;$|const max_lines: u32 = 6;|'
edit "$lines_desk" 's/^::  example    8$/::  example    6/'
edit "$rows_desk" 's/^::  example    8$/::  example    6/'
check "the ceiling moved at all four sites together" agree welcome

# 17 -- a private copy deleted in favour of the published constant, which is the repair.
pen
edit "$seed" 's|^const max_lines: u32 = 8;.*$||'
check "a private copy dropped for the published constant" agree welcome

# 18 -- the published ceiling gone, which is where the empty-set branch would have been if the
# pedestal reading did not already refuse first. It does, and that is why the scan carries no
# `frame_ceiling_missing` verdict: an unplantable branch is an unproven one.
pen
edit "$bp" 's|^pub const max_frame_lines: u32 = 8;$||'
edit "$seed" 's|^const max_lines: u32 = 8;.*$||'
edit "$wl" 's|^const max_lines: u32 = 8;$||'
check "no frame ceiling published anywhere" constant_unpublished:frame_max_lines refuse

echo "welcomes=$welcomes"
echo "refusals=$refusals"
echo "wrong=$wrong"

if [ "$welcomes" -eq 4 ] && [ "$refusals" -eq 14 ] && [ "$wrong" -eq 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
