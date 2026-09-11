#!/bin/sh
# tools/fixtures/s/shape_member_pedestal_scan.sh -- the museum pedestals whose number is a COUNT
# OF MEMBERS, and the declarations those members live in, read apart and compared.
#
# WHY THIS SHAPE. `src/shape/` is a structure museum: each pedestal is a Glow desk whose placard
# names a shape and displays one `example` value. Seventeen stand under the leg in
# tools/gen/chapter/src_first_resident_witness.rish. Three read the engine there and compare
# (%358 bought those); five read a published constant of brushstroke/brush_parse.rye, which
# tools/fixtures/s/shape_constant_pedestal_scan.sh holds. This file takes the SIX that remain
# with a number on the placard -- and each one's number is a count of things rather than a
# constant: struct fields, function parameters, sibling modules, refusal sites, fixture lines.
#
# A COUNT LIVES IN ITS MEMBERS, which is what sets these six apart from the constant class. The
# three fields of `ManifestEntry` are the whole fact, and the pedestal's `3` is a reading of
# them, so the source to read is a declaration rather than a published name. This scan therefore
# names, per pedestal, the KIND of member and the declaration holding it, and each kind is one
# reading a visitor can rerun by hand at the source. It carries its own value nowhere: add a
# fourth field to `ManifestEntry` and the scan wants the desk raised to four, leaving what either
# number should be to Amphora.
#
# FIVE KINDS, because six pedestals genuinely count five different things
#
#   struct_fields    the named `pub const <T> = struct { ... }` fields
#   fn_params        the parameters of a named `pub fn <f>(` -- the manifest's four fields as
#                    its own constructor names them, where the struct holds seven with the
#                    length companions a fixed buffer needs
#   sibling_modules  the modules of one family in one directory, witnesses excluded -- named by
#                    the family's SHAPE (`glow_*_grant.rye`, `mand_ring<n>.rye`) rather than by a
#                    list of the three or the three that stand today, since a selector enumerating
#                    what it counts can only ever answer its own length
#   refusals         the distinct `error.Missing*` sites of one function -- a fifth required
#                    pin would add a fifth refusal, so the refusals ARE the required keys
#   fixture_lines    the content lines under one pin of a `.brush` fixture
#
# FOUR READINGS PER PEDESTAL, each able to fail while the others agree.
#
#   the desk's placard is in seated order -- the six keywords of src/shape/PLACARD.md;
#   the desk NAMES its source, so a reader at the pedestal can reach the declaration and this
#   scan's pairing is checkable rather than private;
#   the members RESOLVE -- the declaration stands, in a form this reading understands;
#   the desk's `example` equals the count.
#
# THE SECOND READING IS WHY THIS SCAN OPENED WITH A REPAIR. Measured 20260910: of the six, two
# named a source -- `brush-pin-key-count` and `frame-seed-line-count` -- so four pedestals showed
# a figure and left a visitor to take it on trust. Citing the declaration is the pedestal's own
# job, and all six do it now.
#
# AN UNRESOLVED FORM IS NAMED, AND THE NAMING REDS. A renamed struct, a moved module family, a
# fixture whose pin has moved on -- each answers `unresolved:<what>`, and the verdict carries that
# word out loud, since a reading answering zero would agree with an empty desk and look green.
#
# WHAT IT READS
#   <key>_placard   the pedestal's first six placard keywords, in seated order
#   <key>_names     whether the desk names its source
#   <key>_example   the number the pedestal displays
#   <key>_members   the count the declaration resolves to, or the unresolved form, named
# and once
#   pedestals       how many pairs were read
#   verdict         agree, or the first reading that refused, naming its pedestal
#
# WHAT LIES OUTSIDE IT. Whether the counts are the right sizes, which each module answers for
# itself; whether the pedestal lowers and runs, which
# tools/gen/chapter/src_first_resident_witness.rish drives the Zig toolchain for; and the three
# desks left over, each for its own reason. `tilak-root-count` displays `2` and already stands on
# its engine under tools/t/tilak_root_count_witness.rish, which reads the two hardcoded marks of
# amphora/manifest_entry.rye. `shape-surface-count` shows `21` and `shape-pool-agent-slot` shows
# `1`, and both are SAMPLES rather than facts -- an illustrative value for a one-field `@u32`
# shape, and the one slot that opens the Pool room -- so each has a placard to keep and no engine
# to be held against.
#
# USAGE
#   sh tools/fixtures/s/shape_member_pedestal_scan.sh [<root>]
#
# Driven by tools/s/shape_member_pedestal_witness.rish. Run from the repository root.

set -eu

root=${1:-.}

expect_order='name shape invariant example readers nib'

# key ~ desk basename ~ kind ~ source ~ selector ~ token the desk must name
# The field separator is `~` rather than `|`, because one selector is an alternation regex and a
# pipe inside a field would split the row into pieces no reader intended.
pairs='manifest_fields~shape-manifest-field-count~struct_fields~amphora/manifest_entry.rye~ManifestEntry~manifest_entry.rye
tube_fields~shape-tube-manifest-field-count~fn_params~linengrow/tube_manifest.rye~build~tube_manifest.rye
grant_families~shape-grant-family-count~sibling_modules~linengrow~^glow_[a-z_]*(grant|scope)[.]rye$~glow_sensors_grant.rye
mand_rings~shape-mand-ring-count~sibling_modules~mand~^mand_ring[0-9]+[.]rye$~mand_ring1.rye
pin_keys~shape-brush-pin-key-count~refusals~brushstroke/brush_parse.rye~finish_brush_surface~brush_parse.rye
seed_lines~shape-frame-seed-line-count~fixture_lines~brushstroke/seed-frame.brush~lines~seed-frame.brush'

# Count the members of one declaration. Answers a number, or `unresolved:<what>` naming the form
# it met and left unread -- zero stays out of it, since a comparison would take zero as a value.
members() {
  kind=$1
  src=$2
  sel=$3
  case "$kind" in
    struct_fields)
      [ -f "$src" ] || { echo "unresolved:source_absent"; return; }
      body=$(sed -n "/^pub const $sel = struct {/,/^};/p" "$src")
      [ -n "$body" ] || { echo "unresolved:struct_$sel"; return; }
      n=$(printf '%s\n' "$body" | grep -cE '^[ ]+[a-z_]+:') || n=0
      [ "$n" -gt 0 ] || { echo "unresolved:no_fields"; return; }
      echo "$n" ;;
    fn_params)
      [ -f "$src" ] || { echo "unresolved:source_absent"; return; }
      body=$(sed -n "/^pub fn $sel($/,/^) /p" "$src")
      [ -n "$body" ] || { echo "unresolved:fn_$sel"; return; }
      n=$(printf '%s\n' "$body" | grep -cE '^    [a-z_]+: ') || n=0
      [ "$n" -gt 0 ] || { echo "unresolved:no_params"; return; }
      echo "$n" ;;
    sibling_modules)
      [ -d "$src" ] || { echo "unresolved:room_absent"; return; }
      n=$(ls "$src" | grep -E "$sel" | grep -v '_witness[.]rye$' | wc -l | tr -d ' ')
      [ "$n" -gt 0 ] || { echo "unresolved:no_modules"; return; }
      echo "$n" ;;
    refusals)
      [ -f "$src" ] || { echo "unresolved:source_absent"; return; }
      body=$(sed -n "/^fn $sel(/,/^}/p" "$src")
      [ -n "$body" ] || { echo "unresolved:fn_$sel"; return; }
      n=$(printf '%s\n' "$body" | grep -oE 'error[.]Missing[A-Za-z]+' | sort -u | wc -l | tr -d ' ')
      [ "$n" -gt 0 ] || { echo "unresolved:no_refusals"; return; }
      echo "$n" ;;
    fixture_lines)
      [ -f "$src" ] || { echo "unresolved:source_absent"; return; }
      grep -q "^::  $sel:" "$src" || { echo "unresolved:pin_$sel"; return; }
      # from the pin's own line to the next pin, counting only the indented content lines
      n=$(sed -n "/^::  $sel:/,\$p" "$src" | sed -n '2,$p' \
        | sed -n '/^::  [a-z][a-z-]*:/q;p' | grep -cE '^::    [^ ]') || n=0
      [ "$n" -gt 0 ] || { echo "unresolved:no_lines"; return; }
      echo "$n" ;;
    *) echo "unresolved:kind_$kind" ;;
  esac
}

pedestals=0
verdict=agree
old_ifs=$IFS
IFS='
'
for row in $pairs; do
  IFS='~'
  # shellcheck disable=SC2086
  set -- $row
  IFS=$old_ifs
  key=$1
  base=$2
  kind=$3
  src=$4
  sel=$5
  token=$6
  desk="$root/src/shape/$base.glow"

  placard=none
  names=no
  example=none
  if [ -f "$desk" ]; then
    got=$(sed -n 's/^::  \([a-z][a-z]*\)  .*/\1/p' "$desk" | head -6 | tr '\n' ' ' | sed 's/ *$//')
    [ -n "$got" ] && placard=$got
    grep -qF "$token" "$desk" && names=yes
    v=$(sed -n 's/^::  example  *\([^ ]*\).*/\1/p' "$desk" | head -1)
    [ -n "$v" ] && example=$v
  fi
  count=$(members "$kind" "$root/$src" "$sel")

  echo "${key}_placard=$placard"
  echo "${key}_names=$names"
  echo "${key}_example=$example"
  echo "${key}_members=$count"
  pedestals=$((pedestals + 1))

  IFS='
'
  [ "$verdict" = agree ] || continue
  if [ ! -f "$desk" ]; then verdict="desk_missing:$key"
  elif [ "$placard" != "$expect_order" ]; then verdict="placard_wrong:$key"
  elif [ "$example" = none ]; then verdict="example_missing:$key"
  elif [ "$names" != yes ]; then verdict="source_unnamed:$key"
  else
    case "$count" in
      unresolved:*) verdict="members_unresolved:$key" ;;
      *) [ "$example" = "$count" ] || verdict="value_disagree:$key" ;;
    esac
  fi
done
IFS=$old_ifs

echo "pedestals=$pedestals"
echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
