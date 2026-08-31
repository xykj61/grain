#!/bin/sh
# tools/fixtures/p/pond_spool_cloth_glow_tend_scan.sh -- Pond's two spool-cloth pedestals, read
# against the rooms that decide them.
#
# A pedestal in src/shape/ names a bound a Rye module holds. It earns its place while the two
# agree, so this reads both sides and compares them.
#
# THE SCAN HOLDS NO VALUE OF ITS OWN. Elder Tend guards grep for the literal number twice, which
# writes it a third time inside the guard; raise the bound honestly in both rooms and such a guard
# still reds, because the copy nobody thought of has not moved. A guard that reds on correct work
# is a guard someone turns off. So the bound may move here and the questions stay the same.
#
# TWO PEDESTALS, ONE SCAN, the way Tablecloth's four desks share one. One verdict line names the
# first reading that refused across both. The desks carry the arguments; this file carries the
# readings.
#
#   shape-spool-cloth-name-bound.glow       max_name, and the bytes its manifest wall removes.
#   shape-spool-cloth-catalog-capacity.glow max_large_artifacts, and the artifacts the store pays for.
#
# Two regions are read from fixed opening and closing sentences the desks keep, rather than from
# prose: the name desk's alphabet, and the capacity desk's list of constants. Prose carries other
# plain words, and a guard reading whichever ones happen to be there is a guard the next honest
# paragraph breaks.
#
# WHAT IT READS, for the name pedestal
#   placard_order    the desk's first six placard keywords, in seated order.
#   citation         whether the desk names the Rye file its number and wall come from.
#   desk_example     the length the pedestal displays.
#   desk_bound       the length the pedestal's own shape line spells.
#   rye_max_name     the length pond/apps/spool_cloth.rye publishes.
#   desk_bytes       the reserved bytes the pedestal lists, sorted and named.
#   rye_wall_bytes   the bytes name_is_one_field refuses, sorted and named; a byte the table does.
#                    not know reads `unnamed:<literal>` and refuses rather than passing quietly.
#   store_wired      whether store_large still consults that wall.
#   parse_wired      whether parse_manifest still reads that bound.
#   desk_nib         the module version the pedestal says it displays at.
#   rye_version      the version pond/apps/spool_cloth.rye publishes.
#
# and for the capacity pedestal, whose companion number is DERIVED rather than published
#   capacity_placard_order, capacity_citation, capacity_desk_example, capacity_desk_bound.
#                    the same four questions, asked of the second desk.
#   rye_max_large_artifacts   the seat count pond/apps/spool_cloth.rye publishes.
#   capacity_desk_inputs      the four constants the desk lists, sorted `name=value`.
#   mantra_inputs             the same four, read from the rooms that publish them.
#   rye_guarantee             those four RECOMPUTED, in the order the module composes them.
#   capacity_desk_guarantee   the guarantee the desk states in words.
#   capacity_derivation_wired whether the module still derives it rather than spelling it.
#   capacity_store_wired      whether store_large still refuses a full catalog.
#   capacity_parse_wired      whether parse_manifest still refuses an overlong manifest.
#   capacity_keyed_wired      whether pond/apps/spool_keyed.rye still sizes owners by this bound.
#   capacity_desk_nib         the version the capacity pedestal says it displays at.
#   verdict          agree, or the one reading that refused.
#
# Each reading can fail while the others agree, which the control proves by reading a survivor by
# name while its neighbour refuses. Two readings that always fire together would be one reading
# wearing two names (.claude/rules/derived-spine.md).
#
# WHAT IT DOES NOT READ. Whether the numbers are the right numbers, which is Pond's design
# question, and whether a desk lowers and runs, which the witness drives the toolchain for. This
# stays a pure text reading so a control can run it dozens of times in a pen for nothing.
#
# USAGE
#   sh tools/fixtures/p/pond_spool_cloth_glow_tend_scan.sh [<root>].
#
# Driven by tools/p/pond_spool_cloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root=${1:-.}
desk="$root/src/shape/shape-spool-cloth-name-bound.glow"
capacity_desk="$root/src/shape/shape-spool-cloth-catalog-capacity.glow"
rye="$root/pond/apps/spool_cloth.rye"
keyed="$root/pond/apps/spool_keyed.rye"
beading="$root/mantra/beading.rye"
spool_rye="$root/mantra/spool.rye"

expect_order='name shape invariant example readers nib'

# The placard's six lines come before any rune, in one seated order (src/shape/PLACARD.md). A
# continuation line under `shape` carries no keyword at column five, so it is read past rather
# than counted -- which is why the keywords are gathered and then cut at six.
placard_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  \([a-z][a-z]*\)  .*/\1/p' "$1" | head -6 | tr '\n' ' ' | sed 's/ *$//')
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

# The single literal a pedestal displays under `example`.
example_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  example  *\([0-9][0-9]*\) *$/\1/p' "$1" | head -1)
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

# The bound a pedestal spells in its own `shape` line -- the second copy of the number, inside the
# same file, which until 20260830 no guard in this room read.
bound_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  shape .*bound \([0-9][0-9]*\).*$/\1/p' "$1" | head -1)
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

# The version stamp a pedestal's nib line says it displays at.
nib_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  nib  *.* at \([0-9][0-9.]*\) *$/\1/p' "$1" | head -1)
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

# The bytes a wall refuses, read from the function's own body and rendered as the plain words a
# placard can print. Each name is ONE word, because a desk lists them separated by ` - ` and a
# hyphenated name would split in two. A byte this table does not know reads `unnamed:<literal>`,
# which no desk word can match -- so the guard reds and the next hand teaches the table rather
# than quietly widening the desk.
wall_bytes_of() {
  if [ -f "$1" ]; then
    sed -n "/^fn $2(/,/^}/p" "$1" \
      | grep -o "== '[^']*'" \
      | sed "s/^== '//; s/'$//" \
      | while IFS= read -r lit; do
          case "$lit" in
            ' ')  printf 'space\n' ;;
            '\n') printf 'newline\n' ;;
            '\t') printf 'tab\n' ;;
            '\r') printf 'return\n' ;;
            *)    printf 'unnamed:%s\n' "$lit" ;;
          esac
        done \
      | sort -u | tr '\n' ' ' | sed 's/ *$//'
  fi
}

# The reserved bytes a pedestal lists, sorted and space-joined. Read from the delimited region
# only, for the reason the header names: prose carries other plain words, and a guard reading
# whichever ones happen to be there is a guard the next honest paragraph breaks.
desk_bytes_of() {
  if [ -f "$1" ]; then
    sed -n '/^::  the bytes the manifest grammar reserves, as name_is_one_field refuses them:$/,/^::  that is the whole alphabet the wall removes\.$/p' "$1" \
      | sed -n 's/^::    //p' \
      | tr ' -' '\n\n' \
      | sed -n 's/^\([a-z][a-z]*\)$/\1/p' \
      | sort -u | tr '\n' ' ' | sed 's/ *$//'
  fi
}

# The guarantee a capacity pedestal states in words, so a derived number is DISPLAYED rather than
# left for a reader to work out. Read as a literal, then checked against the arithmetic below.
guarantee_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  the guarantee is \([0-9][0-9]*\) ceiling artifacts.*$/\1/p' "$1" | head -1)
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

# The constants a capacity pedestal lists, as sorted `name=value` pairs. Read from the delimited
# region only, for the reason the alphabet region above is: prose carries other plain words, and a
# guard reading whichever ones happen to be there is a guard the next honest paragraph breaks.
# `LC_ALL=C sort` because these names carry underscores, and a locale that files `_` after a letter
# would order the desk's list and the modules' list differently while both said the same thing.
desk_inputs_of() {
  if [ -f "$1" ]; then
    sed -n '/^::  the constants that decide it, each published one room away:$/,/^::  that is the whole budget behind the guarantee\.$/p' "$1" \
      | sed -n 's/^::    \([a-z_][a-z_]*\) \([0-9][0-9]*\)$/\1=\2/p' \
      | LC_ALL=C sort | tr '\n' ' ' | sed 's/ *$//'
  fi
}

# One published constant, read from whichever module declares it. Searched rather than tabled: three
# of these live in mantra/beading.rye and one in mantra/spool.rye, and a guard holding a table of
# which room owns which name would red the day Mantra moved one honestly. A name no module publishes
# reads `none`, which no comparison can match.
const_of() {
  _name=$1
  shift
  for _f in "$@"; do
    [ -f "$_f" ] || continue
    _got=$(sed -n "s/^pub const $_name: u32 = \([0-9][0-9]*\);\$/\1/p" "$_f" | head -1)
    if [ -n "$_got" ]; then
      printf '%s\n' "$_got"
      return 0
    fi
  done
  printf 'none\n'
}

placard_order=$(placard_of "$desk")
echo "placard_order=$placard_order"

# A pedestal that names no source is a number with nowhere to be checked against.
citation=no
if [ -f "$desk" ] && grep -q 'pond/apps/spool_cloth.rye' "$desk"; then
  citation=yes
fi
echo "citation=$citation"

desk_example=$(example_of "$desk")
echo "desk_example=$desk_example"
desk_bound=$(bound_of "$desk")
echo "desk_bound=$desk_bound"

rye_max_name=none
if [ -f "$rye" ]; then
  found=$(sed -n 's/^pub const max_name: u32 = \([0-9][0-9]*\);$/\1/p' "$rye" | head -1)
  [ -z "$found" ] || rye_max_name=$found
fi
echo "rye_max_name=$rye_max_name"

desk_bytes=$(desk_bytes_of "$desk")
echo "desk_bytes=$desk_bytes"

rye_wall_bytes=$(wall_bytes_of "$rye" name_is_one_field)
echo "rye_wall_bytes=$rye_wall_bytes"

# The store edge, read rather than inferred.
store_wired=no
if [ -f "$rye" ] \
  && grep -q 'if (!name_is_one_field(name)) return error\.NameHasSeparator;' "$rye"; then
  store_wired=yes
fi
echo "store_wired=$store_wired"

# The manifest edge, read rather than inferred. This one guards an array's end rather than a
# policy, so its absence is a panic rather than a wrong answer.
parse_wired=no
if [ -f "$rye" ] \
  && grep -q 'if (name.len > max_name) return error\.BadManifest;' "$rye"; then
  parse_wired=yes
fi
echo "parse_wired=$parse_wired"

desk_nib=$(nib_of "$desk")
echo "desk_nib=$desk_nib"

rye_version=none
if [ -f "$rye" ]; then
  found=$(sed -n 's/^pub const spool_cloth_version = "\([^"]*\)";$/\1/p' "$rye" | head -1)
  [ -z "$found" ] || rye_version=$found
fi
echo "rye_version=$rye_version"

# ---- the capacity pedestal: seats, and the bytes behind them ----------------------------------

capacity_placard_order=$(placard_of "$capacity_desk")
echo "capacity_placard_order=$capacity_placard_order"

# This desk names four rooms rather than one, and it is read as ONE citation because a desk citing
# three of the four leaves a reader unable to check the arithmetic at all -- the same fault, however
# many lines it takes. The number is decided in pond/apps/spool_cloth.rye, the guarantee in
# mantra/beading.rye and mantra/spool.rye, and the third array it sizes in pond/apps/spool_keyed.rye.
capacity_citation=no
if [ -f "$capacity_desk" ] \
  && grep -q 'pond/apps/spool_cloth.rye' "$capacity_desk" \
  && grep -q 'pond/apps/spool_keyed.rye' "$capacity_desk" \
  && grep -q 'mantra/beading.rye' "$capacity_desk" \
  && grep -q 'mantra/spool.rye' "$capacity_desk"; then
  capacity_citation=yes
fi
echo "capacity_citation=$capacity_citation"

capacity_desk_example=$(example_of "$capacity_desk")
echo "capacity_desk_example=$capacity_desk_example"
capacity_desk_bound=$(bound_of "$capacity_desk")
echo "capacity_desk_bound=$capacity_desk_bound"

rye_max_large_artifacts=none
if [ -f "$rye" ]; then
  found=$(sed -n 's/^pub const max_large_artifacts: u32 = \([0-9][0-9]*\);$/\1/p' "$rye" | head -1)
  [ -z "$found" ] || rye_max_large_artifacts=$found
fi
echo "rye_max_large_artifacts=$rye_max_large_artifacts"

capacity_desk_inputs=$(desk_inputs_of "$capacity_desk")
echo "capacity_desk_inputs=$capacity_desk_inputs"

# The same four names, read from the rooms that publish them. Listed in LC_ALL=C sorted order here
# so the two sides are built the same way rather than sorted the same way by luck.
mantra_max_bead_bytes=$(const_of max_bead_bytes "$beading" "$spool_rye")
mantra_max_resin_bytes=$(const_of max_resin_bytes "$beading" "$spool_rye")
mantra_max_resins=$(const_of max_resins "$beading" "$spool_rye")
mantra_max_store_beads=$(const_of max_store_beads "$beading" "$spool_rye")
mantra_inputs="max_bead_bytes=$mantra_max_bead_bytes max_resin_bytes=$mantra_max_resin_bytes max_resins=$mantra_max_resins max_store_beads=$mantra_max_store_beads"
echo "mantra_inputs=$mantra_inputs"

# The guarantee, RECOMPUTED from what those rooms publish rather than read from a copy. Two floor
# divisions, which is what u32 division does in the Rye, in the same order the module writes them:
# a full resin becomes max_resin_bytes / max_bead_bytes beads, a ceiling artifact fills max_resins
# of those, and the store pays for max_store_beads of them. A zero or an absent constant refuses
# rather than dividing, since a guard that divides by nothing reports a crash as a disagreement.
rye_guarantee=none
case "$mantra_max_bead_bytes:$mantra_max_resin_bytes:$mantra_max_resins:$mantra_max_store_beads" in
  *none*) rye_guarantee=none ;;
  *)
    if [ "$mantra_max_bead_bytes" -gt 0 ]; then
      full_beads=$(( mantra_max_resins * (mantra_max_resin_bytes / mantra_max_bead_bytes) ))
      if [ "$full_beads" -gt 0 ]; then
        rye_guarantee=$(( mantra_max_store_beads / full_beads ))
      fi
    fi
    ;;
esac
echo "rye_guarantee=$rye_guarantee"

capacity_desk_guarantee=$(guarantee_of "$capacity_desk")
echo "capacity_desk_guarantee=$capacity_desk_guarantee"

# The module still DERIVES the guarantee rather than spelling it. Respell it as a literal and every
# number above still agrees while the desk's sentence has gone false, so this is a fact of its own.
capacity_derivation_wired=no
if [ -f "$rye" ] \
  && grep -q 'const full_artifact_beads: u32 = spool.max_resins \* (beading.max_resin_bytes / beading.max_bead_bytes);' "$rye" \
  && grep -q 'pub const guaranteed_full_artifacts: u32 = beading.max_store_beads / full_artifact_beads;' "$rye"; then
  capacity_derivation_wired=yes
fi
echo "capacity_derivation_wired=$capacity_derivation_wired"

# The catalog edge, read rather than inferred: store_large refuses a full catalog.
capacity_store_wired=no
if [ -f "$rye" ] \
  && grep -q 'if (cat.count >= max_large_artifacts) return error\.CatalogFull;' "$rye"; then
  capacity_store_wired=yes
fi
echo "capacity_store_wired=$capacity_store_wired"

# The manifest edge: parse_manifest refuses a manifest carrying more lines than the bound.
capacity_parse_wired=no
if [ -f "$rye" ] \
  && grep -q 'if (man.count >= max_large_artifacts) return error\.CatalogFull;' "$rye"; then
  capacity_parse_wired=yes
fi
echo "capacity_parse_wired=$capacity_parse_wired"

# The third array, one module over, and the reading no desk in this room has carried before.
# pond/apps/spool_keyed.rye sizes its owners array by THIS bound. Give that array a literal of its
# own and a raise here leaves it short, so store_owned_large writes owners[before] past the end.
capacity_keyed_wired=no
if [ -f "$keyed" ] \
  && grep -q 'owners: \[cloth\.max_large_artifacts\]u32,' "$keyed"; then
  capacity_keyed_wired=yes
fi
echo "capacity_keyed_wired=$capacity_keyed_wired"

capacity_desk_nib=$(nib_of "$capacity_desk")
echo "capacity_desk_nib=$capacity_desk_nib"

verdict=agree
if [ ! -f "$desk" ]; then
  verdict=desk_missing
elif [ ! -f "$rye" ]; then
  verdict=rye_missing
elif [ "$placard_order" != "$expect_order" ]; then
  verdict=placard_wrong
elif [ "$citation" != yes ]; then
  verdict=citation_missing
elif [ "$desk_example" = none ]; then
  verdict=desk_example_missing
elif [ "$rye_max_name" = none ]; then
  verdict=rye_bound_missing
elif [ "$desk_bound" != "$desk_example" ]; then
  verdict=desk_self_disagree
elif [ "$desk_example" != "$rye_max_name" ]; then
  verdict=disagree
elif [ -z "$desk_bytes" ]; then
  verdict=alphabet_missing
elif [ -z "$rye_wall_bytes" ]; then
  verdict=rye_wall_missing
elif [ "$desk_bytes" != "$rye_wall_bytes" ]; then
  verdict=bytes_disagree
elif [ "$store_wired" != yes ]; then
  verdict=store_unwired
elif [ "$parse_wired" != yes ]; then
  verdict=parse_unwired
elif [ "$desk_nib" = none ]; then
  verdict=desk_nib_missing
elif [ "$rye_version" = none ]; then
  verdict=rye_version_missing
elif [ "$desk_nib" != "$rye_version" ]; then
  verdict=nib_disagree
fi

# The capacity pedestal's chain, run only once the name pedestal agrees, so one verdict line names
# the first reading that refused across both desks rather than two competing for it.
if [ "$verdict" = agree ]; then
  if [ ! -f "$capacity_desk" ]; then
    verdict=capacity_desk_missing
  elif [ ! -f "$beading" ]; then
    verdict=beading_missing
  elif [ ! -f "$spool_rye" ]; then
    verdict=spool_missing
  elif [ ! -f "$keyed" ]; then
    verdict=keyed_missing
  elif [ "$capacity_placard_order" != "$expect_order" ]; then
    verdict=capacity_placard_wrong
  elif [ "$capacity_citation" != yes ]; then
    verdict=capacity_citation_missing
  elif [ "$capacity_desk_example" = none ]; then
    verdict=capacity_desk_example_missing
  elif [ "$rye_max_large_artifacts" = none ]; then
    verdict=rye_seats_missing
  elif [ "$capacity_desk_bound" != "$capacity_desk_example" ]; then
    verdict=capacity_desk_self_disagree
  elif [ "$capacity_desk_example" != "$rye_max_large_artifacts" ]; then
    verdict=capacity_disagree
  elif [ -z "$capacity_desk_inputs" ]; then
    verdict=capacity_inputs_missing
  elif [ "$capacity_desk_inputs" != "$mantra_inputs" ]; then
    verdict=capacity_inputs_disagree
  elif [ "$capacity_desk_guarantee" = none ]; then
    verdict=capacity_guarantee_missing
  elif [ "$rye_guarantee" = none ]; then
    verdict=mantra_guarantee_unreadable
  elif [ "$capacity_desk_guarantee" != "$rye_guarantee" ]; then
    verdict=capacity_guarantee_disagree
  elif [ "$capacity_derivation_wired" != yes ]; then
    verdict=capacity_derivation_unwired
  elif [ "$capacity_store_wired" != yes ]; then
    verdict=capacity_store_unwired
  elif [ "$capacity_parse_wired" != yes ]; then
    verdict=capacity_parse_unwired
  elif [ "$capacity_keyed_wired" != yes ]; then
    verdict=capacity_keyed_unwired
  elif [ "$rye_max_large_artifacts" -lt "$rye_guarantee" ]; then
    verdict=capacity_order_wrong
  elif [ "$capacity_desk_nib" = none ]; then
    verdict=capacity_nib_missing
  elif [ "$capacity_desk_nib" != "$rye_version" ]; then
    verdict=capacity_nib_disagree
  fi
fi

echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
