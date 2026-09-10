#!/bin/sh
# glow_shared_bound_scan.sh -- one bound, one value, however many modules publish it.
#
#   sh tools/fixtures/g/glow_shared_bound_scan.sh [--names]
#
# WHY THIS GUARD EXISTS. The Glow front end publishes numeric bounds across its modules, and several
# of those names are declared in more than one module. `max_name_len` stood fourteen times, once
# each in `tokens.rye`, `rune_shape.rye`, `expr.rye` and eleven rune modules, every one of them
# spelling 64 independently. Nothing compared them. Three of the agreements were stated in a `///`
# comment -- `tokens.rye` said its ident ceiling "matches rune_shape.max_name_len" -- and a comment
# is a wish rather than a wall: the day one module raises its own copy, the lexer accepts a name the
# shape parser refuses, or the reverse, and both files read correct alone.
#
# THAT NAME HAS AN OWNER NOW (`20260910.083221`), so it has left this census. The lexer declares it
# and thirteen modules write `pub const max_name_len: u32 = tokens.max_name_len;`, which this scan
# never reads, because an alias carries no number to disagree about. What remains shared is six
# names, every one a pair of PEERS -- `max_test_len` in two rune modules, `max_subject_len` in two
# more -- where no module owns the name and an alias would invent an arbitrary dependency between
# equals. An alias needs an owner; where there is none, this wall is the mechanism.
#
# The fault this refuses is the one a repeated rule always carries. A rule written fourteen times is
# a rule fourteen files may quietly come to disagree about, and a lexer and a parser disagreeing
# about how long a name may be is a boundary that has stopped being a boundary. Measured
# `20260910.065315`: all seven names agree, so this wall is placed under a standing agreement rather
# than over a break, and the first drift reds on the lap it arrives.
#
# WHAT COUNTS. A line in a tracked `glow/*.rye` matching, at column one:
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
# it last committed.
#
# WHAT IT COMPARES, and the honest limit. Two declarations agree when their value text agrees after
# every space is removed, so `64 * 1024` and `65536` would read as a divergence though they are one
# number. That direction is the safe one: a false divergence costs one line of repair -- spell the
# two the same way -- and it can never call a real divergence an agreement. No pair in the tree
# carries this shape today; the limit is written down so the first one to meet it knows why.
#
# Bounded: 512 files, 1024 declarations. Both stand well above the 127 files and 195 declarations
# read on the seating lap, and a scan past either refuses rather than truncating in silence.
set -u

here=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd -P) || exit 1
cd "$here" || exit 1

max_files=512    # bound: glow/ holds 127 tracked .rye sources; 512 is the next power of two with room
max_decls=1024   # bound: 195 published numeric bounds stand today; 1024 leaves five times the room

want_names=no
[ "${1:-}" = "--names" ] && want_names=yes

files=$(git ls-files 'glow/*.rye' 2>/dev/null) || {
  echo "glow_shared_bound: REFUSED -- git ls-files did not answer" >&2; exit 2; }
[ -n "$files" ] || {
  echo "glow_shared_bound: REFUSED -- no tracked glow/*.rye sources found" >&2; exit 2; }

nfiles=$(printf '%s\n' "$files" | grep -c .)
[ "$nfiles" -le "$max_files" ] || {
  echo "glow_shared_bound: REFUSED -- $nfiles files over the bound of $max_files" >&2; exit 2; }

pen=$(mktemp -d) || { echo "glow_shared_bound: REFUSED -- no pen" >&2; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM
: > "$pen/decls"

printf '%s\n' "$files" | while IFS= read -r f; do
  [ -f "$f" ] || continue
  grep -oE '^pub const [a-z][a-z0-9_]*: *u(8|16|32|64|size) *= *[0-9][0-9 *+]*;' "$f" 2>/dev/null |
    sed 's|^pub const ||; s|: *u[a-z0-9]* *= *|\t|; s|;$||' |
    while IFS="$(printf '\t')" read -r name value; do
      # invariant: spaces leave the value here and nowhere else, so the comparison below is over
      # one spelling of each expression rather than over whitespace.
      printf '%s\t%s\t%s\n' "$name" "$(printf '%s' "$value" | tr -d ' ')" "$f" >> "$pen/decls"
    done
done

ndecls=$(grep -c . "$pen/decls" 2>/dev/null || true)
[ -n "$ndecls" ] || ndecls=0
[ "$ndecls" -le "$max_decls" ] || {
  echo "glow_shared_bound: REFUSED -- $ndecls declarations over the bound of $max_decls" >&2; exit 2; }

# invariant: a room of tracked sources publishes at least one bound. Reading zero means the pattern
# has stopped matching -- a renamed keyword, a reformatted declaration -- and a pattern that matches
# nothing reports zero shared names and zero divergences, which is exactly what a clean tree reports.
# Refusing here is what tells a wall from a silence; the witness used to name one specimen instead,
# which pinned the tree's own shape in a second place and went stale the day a name found an owner.
[ "$ndecls" -gt 0 ] || {
  echo "glow_shared_bound: REFUSED -- $nfiles tracked sources publish no numeric bound at all; the pattern has stopped matching" >&2; exit 2; }

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

echo "files_read=$nfiles"
echo "declarations=$ndecls"
echo "shared_names=$shared"
echo "divergent_names=$divergent"
# invariant: the gate is zero rather than a ceiling. Every shared name in the tree agrees today, so
# there is no residue to ratchet down -- a ceiling above zero would buy room for the first break.
if [ "$divergent" -eq 0 ]; then echo "verdict=ok"; else echo "verdict=divergent"; fi
