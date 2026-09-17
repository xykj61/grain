#!/bin/sh
# tools/fixtures/a/alloc_bound_reach_scan.sh -- does an allocation SITE reach a named bound?
#
# TAME root rule 1 is the first reflex the core states: every allocation, collection,
# loop and pipeline names a max. Rules 2, 3 and 5 each have a corpus reader --
# tools/r/rune_assert_sweep.rish over the asserts, tools/w/width-check.rish over the
# widths, tools/t/tame-check.rish over the tidy bans. Rule 1 has
# tools/fixtures/b/bound_kind_census.sh, which reads the bound DECLARATIONS and sorts
# them by dimension, and it has nothing at all at the CALL SITE. This scan reads that
# half: the count argument of every allocation in tracked Rye.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#
# THE DECLARED LIMIT, stated before the numbers, because it decides what may be gated.
# Boundedness is a DATAFLOW property. `garden.alloc(u8, cap)` is bounded exactly when
# `cap` was bounded upstream, and following that is parsing rather than scanning. So
# the classification is a reading of the EXPRESSION rather than a verdict on the
# allocation, `derived` and `opaque` are REPORTED and gated nowhere, and the one wall
# is the decidable half named below.
#
# THE CLASSES, in the order the count is tested against them -- first match wins, which
# is what makes them a partition rather than overlapping tags:
#   named    -- the count spells a max_ or min_ identifier, or an ALL-CAPS MAX. The
#               bound is at the site, by name, which is what rule 1 asks for.
#   literal  -- an integer literal, or arithmetic over integer literals alone. Bounded,
#               and naming no reason; this is the class TAME's "say why" would rather
#               see as a named const.
#   derived  -- the count reads a `.len` or a `.count`. Bounded exactly when its source
#               was, which this scan cannot see.
#   opaque   -- the remainder: a local, a parameter, a cast, an arithmetic product. The
#               population a hand must read, and the honest name for it.
#
# THE ONE WALL: `unresolved`, a count naming a max_/min_ identifier that resolves to no
# such declaration anywhere in tracked Rye. That is decidable by text and it is the
# fence post rotted at the base -- a site that LOOKS bounded to every reader and to
# every grep, and names a bound that is not there. Held at zero.
#
# THE SECOND READING, and it is the one that decides what the first one MEANS. A count
# that names no bound may still sit in a function that presses one, and a site reading
# alone would book that as a gap. So each ALLOCATING FUNCTION is classified by what its
# own body holds: a max_/min_ name, an `assert(`, both, or neither. The falsifier was
# stated ahead of the run -- if most non-named sites sit in functions that assert, the
# low named count measures a STYLE rather than a gap -- and the run partly confirmed it:
# 802 of 1,046 allocating functions assert (`20260917`, this scan). What survives that
# widening is `fn_neither`, the functions naming no bound and asserting nothing at all.
#
# GATES NOTHING BEYOND `unresolved`. `fn_neither` is a reading of a GROWING population,
# and bakery's own `20260917` lap named the cost in one line -- a ratchet over a growing
# population is a wall with a delay. A ceiling here would red on a peer's ordinary new
# function, and a gate that reds on ordinary work is a gate somebody turns off.
#
# WHAT IT CANNOT READ, counted rather than hidden: an allocation whose closing paren
# sits on a later line. `spans_lines` prints that population every run, because a
# blind spot nobody prints cannot be told from an empty one. The function walk counts
# braces, so a brace inside a string literal or a comment mis-closes a function; that
# population is `fn_unclosed` and it is printed for the same reason.
set -eu

[ -d .git ] || { echo "verdict=not_a_repo"; exit 2; }

list=false
[ "${1:-}" = "--list" ] && list=true

sites_file=$(mktemp 2>/dev/null || echo "./.alloc_sites.$$")
decl_file=$(mktemp 2>/dev/null || echo "./.alloc_decl.$$")
trap 'rm -f "$sites_file" "$decl_file"' EXIT INT TERM

# `git ls-files` IS the boundary, the same one bound_kind_census.sh draws: vendored and
# submodule sources are untracked here, so no exclusion roster can drift out of step.
git ls-files '*.rye' -z 2>/dev/null \
  | xargs -0 grep -hoE '^[[:space:]]*(pub )?const (max|min)_[a-z0-9_]+' 2>/dev/null \
  | sed -E 's/^[[:space:]]*(pub )?const //' | sort -u > "$decl_file"

# EACH EXTRACTION CHECKS ITS OWN RESULT, per the instrument-refusal law: a broken
# pipeline and a clean tree print the same number, and a `sed` closing a failed
# `git ls-files` exits zero over empty input.
declared=$(wc -l < "$decl_file" | tr -d ' ')
[ "$declared" -gt 0 ] || { echo "verdict=no_bounds_found"; exit 2; }

# THE WALK IS DEPTH-AWARE AND STRING-AWARE, and both halves are load-bearing. A comma
# inside `@as(usize, @intCast(total))` is not a top-level one, and a first draft
# splitting on every comma read 146 sites as the count expression `@as(usize,
# @intCast(total`. A comma inside a string literal is not an argument separator either.
git ls-files '*.rye' -z 2>/dev/null | xargs -0 awk '
function classify(c,   t) {
  t = c
  gsub(/^[ \t]+|[ \t]+$/, "", t)
  if (t ~ /(^|[^a-z_])(max|min)_[a-z0-9_]+/ || t ~ /(^|[^A-Z_])MAX([^A-Z_]|$)/) return "named"
  if (t ~ /^[0-9]+([ \t]*[*+][ \t]*[0-9]+)*$/) return "literal"
  if (t ~ /\.len|\.count/) return "derived"
  return "opaque"
}
{
  line = $0
  # A comment line carries no call this scan may read; the marker is the first
  # non-blank, so a trailing comment beside real code stays readable.
  probe = line
  sub(/^[ \t]+/, "", probe)
  if (probe ~ /^\/\//) next

  pos = 1
  while (1) {
    idx = index(substr(line, pos), ".alloc(")
    idx2 = index(substr(line, pos), ".dupe(")
    if (idx == 0 && idx2 == 0) break
    if (idx != 0 && (idx2 == 0 || idx < idx2)) { kind = "alloc"; start = pos + idx - 1 + length(".alloc(") }
    else                                       { kind = "dupe";  start = pos + idx2 - 1 + length(".dupe(") }

    depth = 1; instr = 0; arg = 1; count = ""; closed = 0
    for (i = start; i <= length(line); i++) {
      ch = substr(line, i, 1)
      prev = (i > 1) ? substr(line, i - 1, 1) : ""
      if (instr) { if (ch == "\"" && prev != "\\") instr = 0; if (arg == 2) count = count ch; continue }
      if (ch == "\"") { instr = 1; if (arg == 2) count = count ch; continue }
      if (ch == "(") depth++
      else if (ch == ")") { depth--; if (depth == 0) { closed = 1; break } }
      else if (ch == "," && depth == 1) { arg++; continue }
      if (arg == 2) count = count ch
    }
    if (!closed) { print "spans\t" kind "\t" FILENAME "\t" FNR; pos = start; continue }
    if (arg < 2)  { print "nocount\t" kind "\t" FILENAME "\t" FNR; pos = start; continue }
    if (kind == "dupe") print "dupe\t" classify(count) "\t" FILENAME "\t" FNR "\t" count
    else                print "site\t" classify(count) "\t" FILENAME "\t" FNR "\t" count
    pos = start
  }
}' > "$sites_file" 2>/dev/null

# `grep -c` prints 0 AND exits 1 over an empty match, so a `|| echo 0` fallback yields
# TWO lines and every arithmetic reading downstream fails. `awk` counts in one value.
count_tag() { awk -F'\t' -v t="$1" '$1==t{n++} END{print n+0}' "$2"; }

sites=$(count_tag site "$sites_file")
records=$(awk 'END{print NR+0}' "$sites_file")
# The refusal reads the WHOLE walk rather than the classified part of it. A tree whose
# only allocations span lines has 0 sites and is not an empty tree, and refusing there
# would hide `spans_lines` -- the one reading this scan keeps to name its own blindness.
[ "$records" -gt 0 ] || { echo "verdict=no_sites_found"; exit 2; }

named=$(awk -F'\t' '$1=="site" && $2=="named"' "$sites_file" | wc -l | tr -d ' ')
literal=$(awk -F'\t' '$1=="site" && $2=="literal"' "$sites_file" | wc -l | tr -d ' ')
derived=$(awk -F'\t' '$1=="site" && $2=="derived"' "$sites_file" | wc -l | tr -d ' ')
opaque=$(awk -F'\t' '$1=="site" && $2=="opaque"' "$sites_file" | wc -l | tr -d ' ')
dupes=$(count_tag dupe "$sites_file")
spans=$(count_tag spans "$sites_file")
nocount=$(count_tag nocount "$sites_file")

# THE HEADLINE RATIO. Every bound name spelled at a count, against every bound name the
# tree declares. A declaration is a fence post; a site is where a hand meets it.
awk -F'\t' '$1=="site"{print $5}' "$sites_file" \
  | grep -oE '\b(max|min)_[a-z0-9_]+' | sort -u > "$sites_file.names" || true
at_sites=$(wc -l < "$sites_file.names" 2>/dev/null | tr -d ' ')
[ -n "$at_sites" ] || at_sites=0
unresolved=$(comm -23 "$sites_file.names" "$decl_file" 2>/dev/null | wc -l | tr -d ' ')
rm -f "$sites_file.names"

# THE FUNCTION-SCOPE PASS. One awk per file, because a function's extent is a
# brace balance within ONE file and a concatenated stream would run them together.
: > "$decl_file.fn"
for f in $(git ls-files '*.rye'); do
  awk '
  /^[ \t]*(pub )?fn |^[ \t]*fn / { if (infn) { print "unclosed" }; infn=1; depth=0; body="" }
  infn {
    body = body "\n" $0
    n = gsub(/{/, "{"); depth += n
    m = gsub(/}/, "}"); depth -= m
    if (depth <= 0 && body ~ /{/) {
      if (body ~ /\.alloc\(/) {
        hasmax = (body ~ /(max|min)_[a-z0-9_]+/)
        hasassert = (body ~ /assert\(/)
        if (hasmax && hasassert) print "both"
        else if (hasassert)      print "assert_only"
        else if (hasmax)         print "max_only"
        else                     print "neither"
      }
      infn = 0
    }
  }
  END { if (infn) print "unclosed" }
  ' "$f" >> "$decl_file.fn"
done

fn_both=$(awk -v t=both '$1==t{n++} END{print n+0}' "$decl_file.fn")
fn_assert_only=$(awk -v t=assert_only '$1==t{n++} END{print n+0}' "$decl_file.fn")
fn_max_only=$(awk -v t=max_only '$1==t{n++} END{print n+0}' "$decl_file.fn")
fn_neither=$(awk -v t=neither '$1==t{n++} END{print n+0}' "$decl_file.fn")
fn_unclosed=$(awk -v t=unclosed '$1==t{n++} END{print n+0}' "$decl_file.fn")
fn_allocating=$((fn_both + fn_assert_only + fn_max_only + fn_neither))
rm -f "$decl_file.fn"

if [ "$list" = true ]; then
  awk -F'\t' '$1=="site"{printf "detail: site class=%s %s:%s count=%s\n", $2, $3, $4, $5}' "$sites_file"
  awk -F'\t' '$1=="spans"{printf "detail: spans %s %s:%s\n", $2, $3, $4}' "$sites_file"
fi

echo "bound_names_declared=$declared"
echo "bound_names_at_sites=$at_sites"
echo "alloc_sites=$sites"
echo "named=$named"
echo "literal=$literal"
echo "derived=$derived"
echo "opaque=$opaque"
echo "dupe_sites=$dupes"
echo "spans_lines=$spans"
echo "nocount=$nocount"
echo "fn_allocating=$fn_allocating"
echo "fn_both=$fn_both"
echo "fn_assert_only=$fn_assert_only"
echo "fn_max_only=$fn_max_only"
echo "fn_neither=$fn_neither"
echo "fn_unclosed=$fn_unclosed"
echo "unresolved=$unresolved"

if [ "$unresolved" -gt 0 ]; then
  echo "verdict=unresolved_bound"
  exit 1
fi
echo "verdict=ok"
