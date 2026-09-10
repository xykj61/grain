#!/bin/sh
# tools/fixtures/s/shape_constant_pedestal_scan.sh -- the museum pedestals that display a
# NUMBER, and the Rye constants that number is supposed to be, read apart and compared.
#
# WHY THIS SHAPE. `src/shape/` is a structure museum: each pedestal is a Glow desk whose placard
# names a shape and displays one `example` value. Seventeen of them stand under the leg in
# tools/gen/chapter/src_first_resident_witness.rish. Measured 20260910: three read their number
# out of the Rye source and compare it (%358 bought those); one reads a fixture; and thirteen
# hold the number as a LITERAL inside the witness -- `grep -q 'example    8' <desk>` -- which
# proves the desk still says eight and asks the engine nothing at all. Change the constant in
# Rye and every one of those thirteen stays green over a desk that now displays a stale figure.
#
# This scan takes the five whose number is a plain published constant of one module,
# `brushstroke/brush_parse.rye`, and holds each pedestal against the constant it names. It
# carries no value of its own: raise `max_brush_bytes` and the scan wants the desk raised with
# it, rather than wanting either number to be anything in particular.
#
# TWO OF THE FIVE ARE NOT LITERALS, which is the whole reason a source read beats a grep here.
# `brush_skate_rows` is an alias -- `= max_frame_lines` -- so the desk's eight is the frame
# ceiling wearing a second name, and a change to the ceiling moves a pedestal whose own line
# never mentions it. `max_brush_bytes` is arithmetic, `16 * 1024`, so the desk's 16384 appears
# nowhere in the source a grep could find. A reading that only understood decimal literals
# would call both of them unresolved and pass, which is the failure this file exists to refuse:
# an unresolved form is NAMED and reds, never counted as zero.
#
# FOUR READINGS, EACH ABLE TO FAIL WHILE THE OTHERS AGREE.
#
#   the desk's placard is in seated order -- the six keywords of src/shape/PLACARD.md, so a desk
#   that has lost its shape is caught before its number is trusted;
#   the desk NAMES the constant it displays, in its own invariant or body, so a reader at the
#   pedestal can reach the source and this scan's pairing is checkable rather than private;
#   the constant RESOLVES in the Rye module -- published, and in a form this reading understands;
#   the desk's `example` equals the resolved value.
#
# The second fires apart from the fourth on the case that matters most: rename the constant in
# Rye, leave its value alone, and the number still agrees while the desk points at a name that
# is gone. That is the same lesson `shape-tablecloth-error-paths.glow` carries -- a count
# compared to a count agrees while the pair underneath has changed.
#
# WHAT IT READS, per pedestal
#   <key>_placard   the pedestal's first six placard keywords, in seated order
#   <key>_names     whether the desk names its Rye constant
#   <key>_example   the number the pedestal displays
#   <key>_rye       the value the constant resolves to, or an unresolved form named
# and once
#   pedestals       how many pairs were read
#   ceiling_sites   every module publishing a frame-height ceiling, and its value
#   ceiling_values  the distinct values among them
#   verdict         agree, or the first reading that refused, naming its pedestal
#
# THE FRAME CEILING IS WRITTEN FOUR TIMES, which the fifth reading exists for. Eight is
# published once as `brush_parse.rye:max_frame_lines`, and then written again as a PRIVATE
# `const max_lines: u32 = 8` in `seed.rye` and once more in `wayland_seed.rye` -- which also
# reaches for the published constant at three other sites, so one file holds both spellings side
# by side. The desk is the fourth copy. They agree today and nothing holds them there: lower the
# published ceiling and the two private copies keep letting eight lines through, silently, since
# each asserts against its own number. So the scan gathers every module-level ceiling in the
# three files and refuses when they part.
#
# WHAT IT DOES NOT READ. Whether the constants are the right sizes, which is Brushstroke's own
# design question; whether the pedestal lowers and runs, which
# tools/gen/chapter/src_first_resident_witness.rish drives the Zig toolchain for; and the other
# eight literal-held pedestals, whose numbers come from struct field counts, enum members and
# fixture lines rather than from a published constant -- each wants its own reading, and this
# one covers the class where the answer is a constant.
#
# USAGE
#   sh tools/fixtures/s/shape_constant_pedestal_scan.sh [<root>]
#
# Driven by tools/s/shape_constant_pedestal_witness.rish. Run from the repository root.

set -eu

root=${1:-.}
rye="$root/brushstroke/brush_parse.rye"

expect_order='name shape invariant example readers nib'

# key : desk basename : constant the desk displays
pairs='frame_max_lines:shape-frame-max-lines:max_frame_lines
skate_cols:shape-brush-skate-cols:brush_skate_cols
skate_rows:shape-brush-skate-rows:brush_skate_rows
brush_max_bytes:shape-brush-max-bytes:max_brush_bytes
pin_max_bytes:shape-brush-max-pin-bytes:max_pin_bytes'

# Resolve one `pub const <name>: <type> = <expr>;` to a number. Three forms are understood --
# a decimal literal, an alias naming another published constant, and a product of two decimal
# literals -- and one alias hop is followed, which is the depth the module actually uses. Any
# other form answers `unresolved:<expr>` so the verdict names it rather than reading zero.
resolve() {
  rn=$1
  [ -f "$rye" ] || { echo "no_source"; return; }
  ex=$(sed -n "s/^pub const $rn *:[^=]*= *\([^;]*\);.*/\1/p" "$rye" | head -1)
  [ -n "$ex" ] || { echo "unpublished"; return; }
  ex=$(printf '%s' "$ex" | sed 's/^ *//; s/ *$//')
  case "$ex" in
    *[!0-9]*) : ;;
    *) echo "$ex"; return ;;
  esac
  # a product of two decimal literals
  a=$(printf '%s' "$ex" | sed -n 's/^\([0-9][0-9]*\) *\* *\([0-9][0-9]*\)$/\1/p')
  b=$(printf '%s' "$ex" | sed -n 's/^\([0-9][0-9]*\) *\* *\([0-9][0-9]*\)$/\2/p')
  if [ -n "$a" ] && [ -n "$b" ]; then echo $((a * b)); return; fi
  # a bare alias, followed exactly one hop
  case "$ex" in
    [a-z_]*)
      inner=$(sed -n "s/^pub const $ex *:[^=]*= *\([^;]*\);.*/\1/p" "$rye" | head -1 \
        | sed 's/^ *//; s/ *$//')
      case "$inner" in
        '') echo "unresolved:$ex"; return ;;
        *[!0-9]*) echo "unresolved:$ex"; return ;;
        *) echo "$inner"; return ;;
      esac ;;
  esac
  echo "unresolved:$ex"
}

pedestals=0
verdict=agree
for row in $pairs; do
  key=$(printf '%s' "$row" | cut -d: -f1)
  base=$(printf '%s' "$row" | cut -d: -f2)
  cname=$(printf '%s' "$row" | cut -d: -f3)
  desk="$root/src/shape/$base.glow"

  placard=none
  names=no
  example=none
  if [ -f "$desk" ]; then
    got=$(sed -n 's/^::  \([a-z][a-z]*\)  .*/\1/p' "$desk" | head -6 | tr '\n' ' ' | sed 's/ *$//')
    [ -n "$got" ] && placard=$got
    grep -q "$cname" "$desk" && names=yes
    v=$(sed -n 's/^::  example  *\([^ ]*\).*/\1/p' "$desk" | head -1)
    [ -n "$v" ] && example=$v
  fi
  ryeval=$(resolve "$cname")

  echo "${key}_placard=$placard"
  echo "${key}_names=$names"
  echo "${key}_example=$example"
  echo "${key}_rye=$ryeval"
  pedestals=$((pedestals + 1))

  [ "$verdict" = agree ] || continue
  if [ ! -f "$desk" ]; then verdict="desk_missing:$key"
  elif [ "$placard" != "$expect_order" ]; then verdict="placard_wrong:$key"
  elif [ "$example" = none ]; then verdict="example_missing:$key"
  elif [ "$names" != yes ]; then verdict="constant_unnamed:$key"
  else
    case "$ryeval" in
      no_source) verdict="rye_missing:$key" ;;
      unpublished) verdict="constant_unpublished:$key" ;;
      unresolved:*) verdict="constant_unresolved:$key" ;;
      *) [ "$example" = "$ryeval" ] || verdict="value_disagree:$key" ;;
    esac
  fi
done

# The frame ceiling, read at every site rather than at the published one. A private `max_lines`
# in a module that also imports the published constant is a second source of truth wearing a
# shorter name, so it is gathered by value and the set is required to be a single number.
ceiling_sites=''
ceiling_values=''
for f in brush_parse.rye seed.rye wayland_seed.rye; do
  src="$root/brushstroke/$f"
  [ -f "$src" ] || { ceiling_sites="$ceiling_sites $f:absent"; continue; }
  v=$(sed -n 's/^\(pub \)\{0,1\}const max_\(frame_\)\{0,1\}lines *:[^=]*= *\([0-9][0-9]*\);.*/\3/p' "$src" | head -1)
  [ -n "$v" ] || v=none
  ceiling_sites="$ceiling_sites $f:$v"
done
ceiling_sites=$(printf '%s' "$ceiling_sites" | sed 's/^ *//')
# A site with no ceiling is dropped from the comparison rather than counted as a value. Deleting
# a private copy and reaching for the published constant instead is the repair this reading wants,
# so a guard that reds on it is a guard pointed the wrong way.
ceiling_values=$(printf '%s\n' "$ceiling_sites" | tr ' ' '\n' | cut -d: -f2 \
  | grep -v '^none$' | grep -v '^absent$' | sort -u | tr '\n' ' ' | sed 's/ *$//')

echo "pedestals=$pedestals"
echo "ceiling_sites=$ceiling_sites"
echo "ceiling_values=$ceiling_values"
# Only the split is judged here. An EMPTY set carries no verdict of its own, because it cannot be
# reached: the frame-max-lines pedestal is read first and its constant is the published ceiling, so
# every tree with no ceiling anywhere has already refused above. A branch a control cannot plant is
# a branch nobody has proven.
if [ "$verdict" = agree ]; then
  case "$ceiling_values" in
    *' '*) verdict=frame_ceiling_split ;;
  esac
fi
echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
