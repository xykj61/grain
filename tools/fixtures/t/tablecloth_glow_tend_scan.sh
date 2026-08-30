#!/bin/sh
# tools/fixtures/t/tablecloth_glow_tend_scan.sh -- Tablecloth's pedestals and their Rye sources,
# read apart and compared.
#
# WHY THIS SHAPE. A Glow Tend pedestal names a bound that a Rye module already holds, so the
# pedestal earns its place only while the two agree. Every elder Tend witness in this tree checks
# that agreement by grepping for the LITERAL number twice -- `example    48` in the desk and
# `max_name_len: u32 = 48` in the Rye -- which writes the value a THIRD time, inside the guard.
# Raise such a bound honestly in both real rooms and the guard still reds, because the copy nobody
# thought of has not moved. A guard that reds on correct work is a guard someone turns off.
#
# So this scan holds no value of its own. It reads the number each desk shows, reads the number the
# Rye publishes, and compares them. The bound may move; the question it answers does not.
#
# THREE PEDESTALS, AND WHY THE SECOND IS DIFFERENT. `max_artifacts` is a literal that
# brushstroke/tablecloth.rye spells for itself, so its desk is compared against that one file.
# `max_content_bytes` is a DERIVATION -- `= beading.max_resin_bytes` -- so tablecloth.rye names the
# bound and mantra/beading.rye decides it, and the desk's number has to be compared against the
# deciding room. That makes the derivation itself a reading: respell tablecloth's line as a literal
# and every number still agrees while the link is gone, so the next honest raise of
# `max_resin_bytes` would move one room and leave the other behind with nothing to say so.
#
# THE THIRD PEDESTAL COUNTS NAMES, SO ITS GUARD READS THE NAMES. `ClothError` is a SET, and its
# desk displays that set's size. A count compared to a count agrees while the set underneath has
# changed -- rename one path, or drop one and add another, and nine is still nine. So the error
# desk earns two readings that a bound's desk does not need:
#
#   the desk agrees with ITSELF -- the number under `example` equals how many names the desk
#   actually lists, so the count is a reading of the list rather than a claim beside it;
#   the desk agrees with the RYE -- the names it lists, sorted, equal the names ClothError
#   declares, sorted.
#
# Those two are enough, and a third would be a fourth copy of the same fact: if the desk's count
# equals its own list and its list equals the Rye's, then its count equals the Rye's count by
# arithmetic. Two readings that always fire together are one reading wearing two names
# (.claude/rules/derived-spine.md), so this scan holds the two that can fire apart.
#
# The desk's list is read from a delimited region rather than from prose, because prose carries
# other capitalized words -- `ClothError` and `BeadStore` among them -- and a guard that reads
# whichever ones happen to be there is a guard the next honest paragraph breaks. The region opens
# and closes on two fixed sentences the desk keeps, and the names sit at a four-space indent
# inside it.
#
# THE FOURTH PEDESTAL IS A NUMBER WITH AN ALPHABET STANDING BESIDE IT. `max_name` bounds how LONG
# an artifact's name may be, and the manifest grammar needs a second thing entirely: that a name
# carry neither of the two bytes the line is split on. REDS %354 cost a round to learn that those
# are different facts -- the length was doing the grammar's job by arithmetic, since at 48 no name
# is long enough to hold a forged 77-byte line, and raising it for longer human names would have
# put the forgery back in reach with nothing in the number's own comment to say so.
#
# So this desk shows the number AND lists the bytes, and three readings carry it, each able to fail
# while the other two agree: the number equals `max_name`; the bytes listed equal the bytes
# `name_is_one_field` actually refuses; and `store_artifact` still consults that wall, because a
# function refusing exactly the right bytes refuses nothing at all while no caller asks it.
#
# There is no self-agreement reading here, and the absence is deliberate. The error desk's number
# IS its list's size, so that desk can contradict itself. This one's number is a length and its
# list is an alphabet -- two facts, neither derivable from the other -- so each is read against the
# Rye rather than against its neighbor.
#
# The wall's bytes are read out of the function body and rendered as plain words, so a byte the
# name table does not know reads `unnamed:<literal>` and refuses rather than passing quietly.
#
# WHAT IT READS
#   placard_order              the catalog desk's first six placard keywords, in seated order
#   citation                   whether the catalog desk names the Rye file its number comes from
#   desk_example               the number the catalog pedestal displays
#   rye_max_artifacts          the number brushstroke/tablecloth.rye publishes
#   content_placard_order      the content desk's first six placard keywords, in seated order
#   content_citation           whether the content desk names BOTH the declaring and deciding files
#   content_desk_example       the number the content pedestal displays
#   beading_max_resin_bytes    the number mantra/beading.rye publishes
#   cloth_derives              whether tablecloth.rye still derives its budget from beading's
#   error_placard_order        the error desk's first six placard keywords, in seated order
#   error_citation             whether the error desk names the Rye file its names come from
#   error_desk_example         the count the error pedestal displays
#   error_desk_names           the names the error pedestal lists, sorted
#   error_desk_name_count      how many names that is
#   rye_error_names            the names ClothError declares, sorted
#   rye_error_path_count       how many names that is
#   name_placard_order         the name desk's first six placard keywords, in seated order
#   name_citation              whether the name desk names the Rye file its number and wall come from
#   name_desk_example          the length the name pedestal displays
#   rye_max_name               the length brushstroke/tablecloth.rye publishes
#   name_desk_bytes            the reserved bytes the name pedestal lists, sorted and named
#   rye_wall_bytes             the bytes name_is_one_field refuses, sorted and named
#   wall_wired                 whether store_artifact still consults that wall
#   desk_bound                 the bound the catalog desk's own shape line spells
#   content_desk_bound         the bound the content desk's own shape line spells
#   name_desk_bound            the bound the name desk's own shape line spells
#   verdict                    agree, or the one reading that refused
#
# The catalog readings are decided before the content readings, so a fault in the elder pedestal
# names itself rather than hiding behind a younger one.
#
# WHAT IT DOES NOT READ. Whether 32 is the right capacity, 512 the right budget, and 48 the right
# name length, and whether the desks lower and run -- the witness drives the Zig toolchain for that,
# and this stays a pure text reading so a control can run it forty-one times in a pen for nothing.
#
# USAGE
#   sh tools/fixtures/t/tablecloth_glow_tend_scan.sh [<root>]
#
# Driven by tools/t/tablecloth_glow_tend_witness.rish. Run from the repository root.

set -eu

root=${1:-.}
desk="$root/src/shape/shape-tablecloth-catalog-capacity.glow"
content_desk="$root/src/shape/shape-tablecloth-content-budget.glow"
error_desk="$root/src/shape/shape-tablecloth-error-paths.glow"
name_desk="$root/src/shape/shape-tablecloth-name-bound.glow"
rye="$root/brushstroke/tablecloth.rye"
beading="$root/mantra/beading.rye"

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

# The bound a pedestal spells in its own `shape` line. A bound desk writes its number TWICE -- once
# in the shape line and once under `example` -- and until 20260830 only the second was read, so the
# two could part inside one file with nothing to say so. The error desk is never asked: its number
# is a set's SIZE, and its shape line says that in words rather than naming a bound.
bound_of() {
  if [ -f "$1" ]; then
    got=$(sed -n 's/^::  shape .*bound \([0-9][0-9]*\).*$/\1/p' "$1" | head -1)
    [ -n "$got" ] || got=none
    printf '%s\n' "$got"
  else
    printf 'none\n'
  fi
}

# The names a pedestal lists, sorted and space-joined. Read from the delimited region only, so a
# capitalized word anywhere else in the placard's prose can never be mistaken for a refusal path.
desk_names_of() {
  if [ -f "$1" ]; then
    sed -n '/^::  the refusal paths, as ClothError declares them:$/,/^::  that is the whole set\.$/p' "$1" \
      | sed -n 's/^::    //p' \
      | tr ' -' '\n\n' \
      | sed -n 's/^\([A-Z][A-Za-z]*\)$/\1/p' \
      | sort -u | tr '\n' ' ' | sed 's/ *$//'
  fi
}

# The names a Zig error set declares, sorted and space-joined -- read from the block itself, so
# the guard carries no roster of its own and an honest new path moves only two real rooms.
error_set_of() {
  if [ -f "$1" ]; then
    sed -n "/^pub const $2 = error{/,/^};/p" "$1" \
      | sed -n 's/^ *\([A-Z][A-Za-z]*\),$/\1/p' \
      | sort -u | tr '\n' ' ' | sed 's/ *$//'
  fi
}

# How many names are in a space-joined list. An empty list counts zero rather than one.
count_of() {
  if [ -z "$1" ]; then
    printf '0\n'
  else
    printf '%s\n' "$1" | tr ' ' '\n' | grep -c .
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
# only, for the same reason the error desk's names are: prose carries other plain words, and a
# guard reading whichever ones happen to be there is a guard the next honest paragraph breaks.
name_bytes_of() {
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
if [ -f "$desk" ] && grep -q 'brushstroke/tablecloth.rye' "$desk"; then
  citation=yes
fi
echo "citation=$citation"

desk_example=$(example_of "$desk")
echo "desk_example=$desk_example"
desk_bound=$(bound_of "$desk")
echo "desk_bound=$desk_bound"

rye_max_artifacts=none
if [ -f "$rye" ]; then
  found=$(sed -n 's/^pub const max_artifacts: u32 = \([0-9][0-9]*\);$/\1/p' "$rye" | head -1)
  [ -z "$found" ] || rye_max_artifacts=$found
fi
echo "rye_max_artifacts=$rye_max_artifacts"

content_placard_order=$(placard_of "$content_desk")
echo "content_placard_order=$content_placard_order"

# A derived bound is decided in one room and declared in another, so its pedestal owes a reader
# both addresses -- the file that names the bound, and the file that holds the number.
content_citation=no
if [ -f "$content_desk" ] \
  && grep -q 'brushstroke/tablecloth.rye' "$content_desk" \
  && grep -q 'mantra/beading.rye' "$content_desk"; then
  content_citation=yes
fi
echo "content_citation=$content_citation"

content_desk_example=$(example_of "$content_desk")
echo "content_desk_example=$content_desk_example"
content_desk_bound=$(bound_of "$content_desk")
echo "content_desk_bound=$content_desk_bound"

beading_max_resin_bytes=none
if [ -f "$beading" ]; then
  found=$(sed -n 's/^pub const max_resin_bytes: u32 = \([0-9][0-9]*\);$/\1/p' "$beading" | head -1)
  [ -z "$found" ] || beading_max_resin_bytes=$found
fi
echo "beading_max_resin_bytes=$beading_max_resin_bytes"

# The link itself, read rather than inferred: values agreeing proves nothing about whether the
# artifact budget still follows the resin budget.
cloth_derives=no
if [ -f "$rye" ] \
  && grep -q '^pub const max_content_bytes: u32 = beading\.max_resin_bytes;$' "$rye"; then
  cloth_derives=yes
fi
echo "cloth_derives=$cloth_derives"

error_placard_order=$(placard_of "$error_desk")
echo "error_placard_order=$error_placard_order"

# The error desk names one room only: the file that declares ClothError decides it too.
error_citation=no
if [ -f "$error_desk" ] && grep -q 'brushstroke/tablecloth.rye' "$error_desk"; then
  error_citation=yes
fi
echo "error_citation=$error_citation"

error_desk_example=$(example_of "$error_desk")
echo "error_desk_example=$error_desk_example"

error_desk_names=$(desk_names_of "$error_desk")
echo "error_desk_names=$error_desk_names"
error_desk_name_count=$(count_of "$error_desk_names")
echo "error_desk_name_count=$error_desk_name_count"

rye_error_names=$(error_set_of "$rye" ClothError)
echo "rye_error_names=$rye_error_names"
rye_error_path_count=$(count_of "$rye_error_names")
echo "rye_error_path_count=$rye_error_path_count"

name_placard_order=$(placard_of "$name_desk")
echo "name_placard_order=$name_placard_order"

# The fourth pedestal names one room: the file declaring max_name holds the wall beside it.
name_citation=no
if [ -f "$name_desk" ] && grep -q 'brushstroke/tablecloth.rye' "$name_desk"; then
  name_citation=yes
fi
echo "name_citation=$name_citation"

name_desk_example=$(example_of "$name_desk")
echo "name_desk_example=$name_desk_example"
name_desk_bound=$(bound_of "$name_desk")
echo "name_desk_bound=$name_desk_bound"

rye_max_name=none
if [ -f "$rye" ]; then
  found=$(sed -n 's/^pub const max_name: u32 = \([0-9][0-9]*\);$/\1/p' "$rye" | head -1)
  [ -z "$found" ] || rye_max_name=$found
fi
echo "rye_max_name=$rye_max_name"

name_desk_bytes=$(name_bytes_of "$name_desk")
echo "name_desk_bytes=$name_desk_bytes"

rye_wall_bytes=$(wall_bytes_of "$rye" name_is_one_field)
echo "rye_wall_bytes=$rye_wall_bytes"

# The wall consulted, read rather than inferred: a function refusing exactly the right bytes
# refuses nothing at all while no caller asks it.
wall_wired=no
if [ -f "$rye" ] \
  && grep -q 'if (!name_is_one_field(name)) return error\.NameHasSeparator;' "$rye"; then
  wall_wired=yes
fi
echo "wall_wired=$wall_wired"

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
elif [ "$rye_max_artifacts" = none ]; then
  verdict=rye_bound_missing
elif [ "$desk_bound" != "$desk_example" ]; then
  verdict=desk_self_disagree
elif [ "$desk_example" != "$rye_max_artifacts" ]; then
  verdict=disagree
elif [ ! -f "$content_desk" ]; then
  verdict=content_desk_missing
elif [ ! -f "$beading" ]; then
  verdict=beading_missing
elif [ "$content_placard_order" != "$expect_order" ]; then
  verdict=content_placard_wrong
elif [ "$content_citation" != yes ]; then
  verdict=content_citation_missing
elif [ "$content_desk_example" = none ]; then
  verdict=content_example_missing
elif [ "$beading_max_resin_bytes" = none ]; then
  verdict=beading_bound_missing
elif [ "$cloth_derives" != yes ]; then
  verdict=derivation_broken
elif [ "$content_desk_bound" != "$content_desk_example" ]; then
  verdict=content_desk_self_disagree
elif [ "$content_desk_example" != "$beading_max_resin_bytes" ]; then
  verdict=content_disagree
elif [ ! -f "$error_desk" ]; then
  verdict=error_desk_missing
elif [ "$error_placard_order" != "$expect_order" ]; then
  verdict=error_placard_wrong
elif [ "$error_citation" != yes ]; then
  verdict=error_citation_missing
elif [ "$error_desk_example" = none ]; then
  verdict=error_example_missing
elif [ "$error_desk_name_count" -eq 0 ]; then
  verdict=error_enumeration_missing
elif [ "$rye_error_path_count" -eq 0 ]; then
  verdict=rye_error_paths_missing
elif [ "$error_desk_example" != "$error_desk_name_count" ]; then
  verdict=error_desk_self_disagree
elif [ "$error_desk_names" != "$rye_error_names" ]; then
  verdict=error_names_disagree
elif [ ! -f "$name_desk" ]; then
  verdict=name_desk_missing
elif [ "$name_placard_order" != "$expect_order" ]; then
  verdict=name_placard_wrong
elif [ "$name_citation" != yes ]; then
  verdict=name_citation_missing
elif [ "$name_desk_example" = none ]; then
  verdict=name_example_missing
elif [ "$rye_max_name" = none ]; then
  verdict=rye_name_bound_missing
elif [ "$name_desk_bound" != "$name_desk_example" ]; then
  verdict=name_desk_self_disagree
elif [ "$name_desk_example" != "$rye_max_name" ]; then
  verdict=name_disagree
elif [ -z "$name_desk_bytes" ]; then
  verdict=name_alphabet_missing
elif [ -z "$rye_wall_bytes" ]; then
  verdict=rye_wall_missing
elif [ "$name_desk_bytes" != "$rye_wall_bytes" ]; then
  verdict=name_bytes_disagree
elif [ "$wall_wired" != yes ]; then
  verdict=wall_unwired
fi

echo "verdict=$verdict"
[ "$verdict" = agree ] || exit 1
