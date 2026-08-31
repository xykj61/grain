#!/bin/sh
# tools/fixtures/p/pond_spool_cloth_glow_tend_scan.sh -- Pond's spool-cloth name pedestal and its
# Rye source, read apart and compared.
#
# WHY THIS SHAPE. A Glow Tend pedestal names a bound a Rye module already holds, so the pedestal
# earns its place only while the two agree. The elder Tend witnesses in this tree check that
# agreement by grepping for the LITERAL number twice -- `example    48` in the desk and
# `max_name: u32 = 48` in the Rye -- which writes the value a THIRD time, inside the guard. Raise
# such a bound honestly in both real rooms and the guard still reds, because the copy nobody
# thought of has not moved. A guard that reds on correct work is a guard someone turns off.
#
# So this scan holds no value of its own. It reads what the desk shows, reads what the Rye
# publishes, and compares them. The bound may move; the questions it answers do not.
#
# ONE PEDESTAL, FIVE READINGS, EACH ABLE TO FAIL ALONE.
#
#   the desk agrees with ITSELF -- a bound desk spells its number twice, once in the `shape` line
#   and once under `example`, and the two can part inside one file with nothing to say so;
#   the desk agrees with the RYE -- the number equals `max_name`;
#   the ALPHABET agrees -- the bytes the desk lists equal the bytes `name_is_one_field` refuses,
#   because a length bound and a grammar wall are different facts, and REDS %354 cost a round to
#   learn that the first was doing the second's job by arithmetic;
#   the STORE edge is wired -- `store_large` still consults that wall, because a function refusing
#   exactly the right bytes refuses nothing at all while no caller asks it;
#   the MANIFEST edge is wired -- `parse_manifest` still reads the same bound.
#
# WHY THE FIFTH READING EXISTS HERE AND NOT ON TABLECLOTH'S DESK. This module reads `max_name` at
# the two places a name enters, and only one of them is a policy refusal. A parsed entry's name
# lands in a fixed `[max_name]u8` field, so with that check gone a hand-authored manifest carrying
# a sixty-byte name is copied past the end of the array -- a refusal downgraded to a panic. The
# store edge and the manifest edge fire apart: delete either call and the other still stands, so
# they are two readings rather than one wearing two names (.claude/rules/derived-spine.md).
#
# The desk's alphabet is read from a delimited region rather than from prose, because prose carries
# other plain words and a guard reading whichever ones happen to be there is a guard the next
# honest paragraph breaks. The region opens and closes on two fixed sentences the desk keeps, and
# the words sit at a four-space indent inside it.
#
# The wall's bytes are read out of the function body and rendered as plain words, so a byte the
# name table does not know reads `unnamed:<literal>` and refuses rather than passing quietly.
#
# AND THE NIB'S VALUE IS READ, WHICH NO DESK IN THIS ROOM HAS HAD BEFORE. PLACARD.md seats six
# lines and says why the last one is there -- a pedestal always displays a value AT a nib. Every
# placard-order reading in the tree counts the `nib` KEYWORD and stops; across all 37 residents
# standing before this one, the stamp after it is compared to nothing. A module whose version moves
# while its desk keeps the elder nib is a desk saying, in its own words, that it shows a value from
# a release the module has left. So the stamp is compared against the version the Rye publishes,
# and an honest bump moves both -- proven as a welcome rather than assumed.
#
# WHAT IT READS
#   placard_order    the desk's first six placard keywords, in seated order
#   citation         whether the desk names the Rye file its number and wall come from
#   desk_example     the length the pedestal displays
#   desk_bound       the length the pedestal's own shape line spells
#   rye_max_name     the length pond/apps/spool_cloth.rye publishes
#   desk_bytes       the reserved bytes the pedestal lists, sorted and named
#   rye_wall_bytes   the bytes name_is_one_field refuses, sorted and named
#   store_wired      whether store_large still consults that wall
#   parse_wired      whether parse_manifest still reads that bound
#   desk_nib         the module version the pedestal says it displays at
#   rye_version      the version pond/apps/spool_cloth.rye publishes
#   verdict          agree, or the one reading that refused
#
# WHAT IT DOES NOT READ. Whether forty-eight is the right length -- that is Pond's design question
# -- and whether the desk lowers and runs, which the witness drives the toolchain for. This stays a
# pure text reading so a control can run it dozens of times in a pen for nothing.
#
# USAGE
#   sh tools/fixtures/p/pond_spool_cloth_glow_tend_scan.sh [<root>]
#
# Driven by tools/p/pond_spool_cloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root=${1:-.}
desk="$root/src/shape/shape-spool-cloth-name-bound.glow"
rye="$root/pond/apps/spool_cloth.rye"

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

echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
