#!/bin/sh
# shared_bound_scan.sh -- one bound, one value, however many modules of a room publish it.
#
#   sh tools/fixtures/s/shared_bound_scan.sh [--room <dir>] [--names]
#   sh tools/fixtures/s/shared_bound_scan.sh --all
#
# WHY THIS GUARD EXISTS. A module room publishes numeric bounds, and some of those names stand in
# more than one module. `glow/` publishes 197 across 134 sources and shares seven names --
# `max_name_len` fourteen times, each spelling 64 on its own line. `mantra/` publishes 29 names
# across 41 sources and shares two: `max_resin_bytes` at 512 in `beading.rye` and `recall_lap1.rye`,
# and `max_wire_payload` at 340 in `recall_sync_wire.rye` and `recall_tablecloth_query_wire.rye`.
# Nothing compared any of them. One agreement is stated in a comment -- `beading.rye` says its
# resin ceiling matches `recall_lap1.max_resin_bytes` -- and a comment is a wish rather than a wall:
# raise one copy and the beader accepts a resin the catalog refuses, both files reading correct
# alone. The other, `max_wire_payload`, is the sealed datagram's own body budget and carries no
# comment at all, so its agreement was held by nothing whatsoever.
#
# A NAME WITH AN OWNER LEAVES THIS CENSUS (`20260910.083221`, one room over). `glow/tokens.rye`
# declares `max_name_len` and thirteen modules now write `pub const max_name_len: u32 =
# tokens.max_name_len;`, which this scan never reads, because an alias carries no number to disagree
# about. That is the better repair wherever one module OWNS the rule. Where no module owns it -- two
# peers, `max_resin_bytes` in `mantra/beading.rye` and `mantra/recall_lap1.rye` -- an alias would
# invent an arbitrary dependency between equals, and this wall is the mechanism instead. An alias
# needs an owner; where there is none, the comparison is the owner.
#
# WHERE THE PREMISE HOLDS, AND WHERE IT DOES NOT. This reads a shared NAME and calls it a shared
# RULE, and those two are different claims. Measured `20260910.093000` with `--all` over the 44
# top-level rooms holding tracked `.rye`: **17 rooms share a name at all, six of them carry zero
# divergence, and the other eleven carry 59 name groups standing at more than one value.** Reading
# those groups shows why the premise stops where it stops -- `crypto/sha256.rye` says
# `digest_len = 32` where `crypto/sha512.rye` says 64, `crypto/mldsa_ring.rye` says `q = 8380417`
# where `mlkem_ring.rye` says 3329, and `image/font5x7_nordic.rye` says `mid_row = 4` where
# `font5x7_greek_upper.rye` says 3. Each is one sibling implementing one interface and naming its
# own constant correctly. A room of siblings shares names it must NOT share values for, so a
# tree-wide gate at zero would demand that SHA-256 and SHA-512 agree on a digest length.
#
# So the wall is rostered PER ROOM by a room's own witness, on the room's own evidence. Two of the
# six clean rooms are walled today -- `glow/` by `tools/g/glow_shared_bound_witness.rish` and
# `mantra/` by `tools/m/mantra_shared_bound_witness.rish` -- and `amphora/`, `brushstroke/`,
# `constel/` and `mikrophone/` stand clean and unwalled, each its own hand's lap. The eleven are
# named here so the next hand to reach for a tree-wide gate meets this measurement rather than the
# temptation. Every figure in this paragraph is FREE, held by no gate: RUN `--all` rather than
# reading it, since it moves with every room that publishes a bound.
#
# WHAT COUNTS. A line in a tracked `<room>/*.rye` matching, at column one:
#
#     pub const <name>: u8|u16|u32|u64|usize = <numeric expression>;
#
# and each exclusion below is proven from both sides in the control:
#
#   * NOT `pub` -- a file-private constant is bounded by its own file, which is the boundary being
#     respected rather than a seam that can drift. Only a published name reaches another module.
#   * NOT at column one -- a `pub const` indented inside a struct or a function is that scope's,
#     and two structs may lawfully carry one field name at two values.
#   * NOT a non-numeric value -- a type, a string, an enum. This reads bounds, and a bound is a
#     number.
#   * NOT a mention in a comment or a use site. The declaration is the promise.
#
# THE SIBLING READING, so neither is mistaken for the other. `tools/fixtures/c/ceiling_pair_scan.sh`
# reads two DIFFERENT bounds standing in ONE file -- a count ceiling in front of a byte ceiling --
# and asks which of the two is real. This reads ONE bound published by MANY files and asks whether
# they still say the same number. Same law, two axes: that one is depth, this one is breadth.
#
# WHAT IT READS. Tracked paths, at their working-tree bytes, so an edit is seen before it is
# staged. That is the direction a lap wants at its open: the tree it stands on rather than the tree
# it last committed. A room glob crosses `/`, so a room's nested sources -- `mantra/src/` -- are
# read with the flat ones, which is what makes the room the unit rather than the directory.
#
# WHAT IT COMPARES, and the honest limit. Two declarations agree when their value text agrees after
# every space is removed, so `64 * 1024` and `65536` would read as a divergence though they are one
# number. That direction is the safe one: a false divergence costs one line of repair -- spell the
# two the same way -- and it can never call a real divergence an agreement. No pair in a rostered
# room carries this shape today; the limit is written down so the first one to meet it knows why.
#
# WHY `--all` PRINTS NO VERDICT. A census over every room is a reading rather than a gate, and a
# line reading `verdict=` is what a witness reaches for. Withholding the word is what keeps a
# reported number from being mistaken for a walled one.
#
# Bounded: 512 files, 1024 declarations per room, 64 rooms. All three stand well above the 134
# files, 197 declarations and 44 rooms read on the widening lap, and a scan past any of
# them refuses rather than truncating in silence.
set -u

here=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd -P) || exit 1
cd "$here" || exit 1

max_files=512    # bound: glow/ holds 134 tracked .rye sources, the largest rostered room; 512 is the next power of two with room
max_decls=1024   # bound: 197 published numeric bounds stand in that room today; 1024 leaves five times the room
max_rooms=64     # bound: 44 top-level rooms hold tracked .rye today; 64 is the next power of two above it

room=glow
want_names=no
want_all=no
while [ $# -gt 0 ]; do
  case "$1" in
    --room) shift; [ $# -gt 0 ] || { echo "shared_bound: REFUSED -- --room takes a directory" >&2; exit 2; }; room=$1 ;;
    --names) want_names=yes ;;
    --all) want_all=yes ;;
    *) echo "shared_bound: REFUSED -- unknown argument $1" >&2; exit 2 ;;
  esac
  shift
done

pen=$(mktemp -d) || { echo "shared_bound: REFUSED -- no pen" >&2; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

# invariant: one extraction rule, reached by both readings, so the census and the gate can never
# come to disagree about what a published bound is.
declare_room() {
  _room=$1
  _out=$2
  : > "$_out"
  git ls-files "$_room/*.rye" 2>/dev/null | while IFS= read -r f; do
    [ -f "$f" ] || continue
    grep -oE '^pub const [a-z][a-z0-9_]*: *u(8|16|32|64|size) *= *[0-9][0-9 *+]*;' "$f" 2>/dev/null |
      sed 's|^pub const ||; s|: *u[a-z0-9]* *= *|\t|; s|;$||' |
      while IFS="$(printf '\t')" read -r name value; do
        # invariant: spaces leave the value here and nowhere else, so the comparison below is over
        # one spelling of each expression rather than over whitespace.
        printf '%s\t%s\t%s\n' "$name" "$(printf '%s' "$value" | tr -d ' ')" "$f" >> "$_out"
      done
  done
}

if [ "$want_all" = yes ]; then
  rooms=$(git ls-files '*.rye' 2>/dev/null | awk -F/ 'NF>1{print $1}' | sort -u)
  [ -n "$rooms" ] || { echo "shared_bound: REFUSED -- no tracked .rye sources found" >&2; exit 2; }
  nrooms=$(printf '%s\n' "$rooms" | grep -c .)
  [ "$nrooms" -le "$max_rooms" ] || {
    echo "shared_bound: REFUSED -- $nrooms rooms over the bound of $max_rooms" >&2; exit 2; }
  sharing=0
  clean=0
  dirty=0
  for r in $rooms; do
    declare_room "$r" "$pen/decls"
    line=$(awk -F'\t' '{c[$1]++; if(!($1 in f)) f[$1]=$2; else if($2!=f[$1]) bad[$1]=1}
      END{s=0; d=0; for(k in c) if(c[k]>1) s++; for(k in bad) d++; print s" "d}' "$pen/decls")
    s=${line% *}; d=${line#* }
    [ "$s" -gt 0 ] || continue
    sharing=$((sharing + 1))
    if [ "$d" -eq 0 ]; then clean=$((clean + 1)); else dirty=$((dirty + 1)); fi
    echo "room $r shared_names=$s divergent_names=$d"
  done
  echo "rooms_read=$nrooms"
  echo "rooms_sharing=$sharing"
  echo "rooms_premise_holds=$clean"
  echo "rooms_premise_fails=$dirty"
  exit 0
fi

files=$(git ls-files "$room/*.rye" 2>/dev/null) || {
  echo "shared_bound: REFUSED -- git ls-files did not answer" >&2; exit 2; }
[ -n "$files" ] || {
  echo "shared_bound: REFUSED -- no tracked $room/*.rye sources found" >&2; exit 2; }

nfiles=$(printf '%s\n' "$files" | grep -c .)
[ "$nfiles" -le "$max_files" ] || {
  echo "shared_bound: REFUSED -- $nfiles files over the bound of $max_files" >&2; exit 2; }

declare_room "$room" "$pen/decls"

ndecls=$(grep -c . "$pen/decls" 2>/dev/null || true)
[ -n "$ndecls" ] || ndecls=0
[ "$ndecls" -le "$max_decls" ] || {
  echo "shared_bound: REFUSED -- $ndecls declarations over the bound of $max_decls" >&2; exit 2; }

# invariant: a room this guard walls publishes at least one bound. Reading zero means the pattern has
# stopped matching -- a renamed keyword, a reformatted declaration -- and a pattern that matches
# nothing reports zero shared names and zero divergences, which is exactly what a clean room reports.
# Refusing here is what tells a wall from a silence; a witness naming one specimen instead pins the
# room's own shape in a second place and goes stale the day a name finds an owner, which is what
# happened to `max_name_len` one room over. `--all` is exempt by construction: it censuses every
# room, and a room publishing no bound at all is an ordinary reading there rather than a fault.
[ "$ndecls" -gt 0 ] || {
  echo "shared_bound: REFUSED -- $nfiles tracked $room sources publish no numeric bound at all; the pattern has stopped matching" >&2; exit 2; }

shared=0
divergent=0
if [ "$ndecls" -gt 0 ]; then
  shared=$(awk -F'\t' '{c[$1]++} END{n=0; for(k in c) if(c[k]>1) n++; print n}' "$pen/decls")
  divergent=$(awk -F'\t' '{c[$1]++; if(!($1 in first)) first[$1]=$2; else if($2!=first[$1]) bad[$1]=1}
    END{n=0; for(k in bad) n++; print n}' "$pen/decls")
fi

if [ "$want_names" = yes ]; then
  awk -F'\t' '{c[$1]++; where[$1]=where[$1]" "$3"="$2; if(!($1 in first)) first[$1]=$2; else if($2!=first[$1]) bad[$1]=1}
    END{for(k in c) if(c[k]>1) printf "name %s %s --%s\n", (k in bad ? "DIVERGENT" : "agreed"), k, where[k]}' \
    "$pen/decls" | sort
fi

echo "room_read=$room"
echo "files_read=$nfiles"
echo "declarations=$ndecls"
echo "shared_names=$shared"
echo "divergent_names=$divergent"
# invariant: the gate is zero rather than a ceiling. Every shared name in a rostered room agrees
# today, so there is no residue to ratchet down -- a ceiling above zero would buy room for the
# first break.
if [ "$divergent" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=divergent"; fi
