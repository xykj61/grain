#!/bin/sh
# tools/fixtures/c/ceiling_pair_scan.sh -- a count ceiling standing in front of a byte ceiling
# says which of the two is the real one.
#
# WHY. A module writing items into a fixed buffer can name two maxima: how many items it carries,
# and how many bytes it has. Only one of those is the real one, and the encoder decides which --
# never the declaration. `mantra/recall_tablecloth_query_wire.rye` declares `max_wire_hits = 8`
# six lines above `max_wire_payload = 340`; one hit at maximum name lengths encodes to 119 bytes,
# so the attainable count is 2. `mantra/recall_sync_wire.rye` declares 8 entries against the same
# 340-byte payload where one worst-case entry costs 676 bytes, so its attainable count is zero.
# Both were found by hand, one lap apart, and the second firing is what turns a lantern into a
# loom (`.claude/rules/reds-first.md`). The census and the arithmetic are Diffuser's, in
# `external-research/20260910-001454_the-count-in-front-of-the-byte-ceiling.md`; this is the
# standing instrument that reading asked for.
#
# The class is quiet on purpose. A bound too SMALL refuses honest work and is found within a day.
# A count too LARGE refuses nothing, passes every test built from short names, and reports its
# wrong number to every reader who asks.
#
# WHAT THIS SCAN DOES NOT DO, AND WHY IT MATTERS MOST. It does not judge whether a pair is real.
# Four lexical discriminators were built and measured against the four cases the paper walked by
# hand, on `20260910`, and every one of them leaked:
#
#   the two names appear in one file          48 candidates, 2 real -- the paper's own reading
#   the two names appear in one function      admits `recall_lap1`, where two independent guards
#                                             sit three lines apart in `append_leaf`
#   the byte name is checked after a loop      admits `glow_storage_scope`, a per-item length
#                                             check inside a loop over entries
#   the byte name is checked against a         admits `glow_storage_scope` again; a partial name
#     variable incremented in that loop        match on a struct field is enough to fool it
#
# The real test is whether the loop ACCUMULATES into the buffer the byte ceiling bounds, and that
# is dataflow rather than text. A guard that guessed would red on honest work and be turned off,
# which is the failure this tree has booked repeatedly. So the loom stops guessing and asks the
# file to answer -- the same move `declared_ceiling` makes for a page and `tutorial_output` makes
# for a command, and the reason is the same in all three: where a judgment cannot be mechanized,
# mechanize the DECLARATION of it.
#
# THE DECLARATION, spelled exactly so it stays checkable. One line anywhere in the file:
#
#   // ceilings: independent -- max_bindings bounds catalog leaves, max_resin_bytes bounds a resin
#   // ceilings: derived -- max_wire_hits is a view of max_wire_payload
#   // ceilings: literal -- max_wire_hits stands in front of max_wire_payload, booked 20260909.213236
#
# `independent` says the two axes never meet and no arithmetic connects them -- the honest and
# common answer. `derived` says the count is computed from the byte ceiling, which is the repair
# the paper argues for and the shape `caravan/` already writes. `literal` says the pair is real
# and unrepaired, which books it.
#
# WHAT IS GATED, at zero:
#
#   1. a `// ceilings:` line naming none of the three verdicts
#
# A declaration a tool cannot read is indistinguishable from no declaration at all, and that is
# how `docs/CRYPTO.md` drifted past its own ceiling for months while appearing to declare one.
#
# WHAT RIDES A CEILING THAT ONLY EVER FALLS:
#
#   `pairs_undeclared` -- the population that has yet to answer. Every file falls off this reading
#     on the lap a hand next touches it, which is the ratchet form this tree uses everywhere
#     (`.claude/rules/tame-guidance.md`). A gate here would refuse the whole tree on seating.
#   `pairs_literal` -- the real, unrepaired class. It falls as a ceiling is derived and rises when
#     a new literal count is written in front of a byte ceiling, which is exactly the event worth
#     hearing about.
#
# THE CORPUS is discovered rather than listed -- `git ls-files` for every tracked `.rye`. A
# hand-written roster is what REDS %187 was booked for: it reached 6 of 34 doors and nobody knew.
#
# SYMLINKS ARE RESOLVED, and this is a real reading rather than a precaution. `comlink/` holds
# symlinks to `mantra/`, so the first census counted `recall_sync_wire.rye` twice and reported six
# instances where the tree holds four. A population counted through two names for one file
# over-reports its own subject.
#
# A LITERAL IS THE WHOLE RIGHT-HAND SIDE. `max_bytes: u32 = 8 * session.max_samples;` opens with a
# digit, and a pattern ending at `[0-9]+` reads it as a literal 8 -- which admitted nine derived
# ceilings, the precise shape this guard exists to reward. The pattern is anchored at the `;`.
#
# WHAT IT DOES NOT REACH. Whether a declared verdict is the TRUE one -- that is a judgment, and
# this is a count. A pair whose two ceilings are named rather than literal, since a derived
# ceiling is the repair and leaves the population by construction. And every language beside Rye.
#
# USAGE
#   sh tools/fixtures/c/ceiling_pair_scan.sh          # census -- key=value lines
#   sh tools/fixtures/c/ceiling_pair_scan.sh list     # every pair, its names, its declaration
#
# Driven by tools/c/ceiling_pair_witness.rish. Run from the repository root.
set -eu

MODE="${1:-census}"
ROOT="${CEILING_PAIR_ROOT:-}"

# A name ending in one of these is shaped like a quantity of bytes; one ending in the count list
# is shaped like a quantity of items. Both require a bare decimal literal as the WHOLE right-hand
# side, so a ceiling derived from another never enters the population.
# The portable path resolver, sourced rather than spelled. `readlink -f` is GNU-only -- BSD readlink
# fails on a path whose last component does not exist, and the tree gates that flag under a ceiling
# that only falls (`shell_dialect`). The first draft of this scan reached for it and became the
# eighth site. Root by upward walk, git-free so a pen copy outside a repository still resolves.
_cp_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_cp_steps=0
while [ ! -d "$_cp_root/rishi/bin" ] || [ ! -d "$_cp_root/tools/fixtures" ]; do
  _cp_steps=$((_cp_steps + 1))
  if [ "$_cp_steps" -gt 8 ] || [ "$_cp_root" = "/" ] || [ -z "$_cp_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _cp_root=$(dirname "$_cp_root")
done
. "$_cp_root/tools/fixtures/s/shell_portable.sh"

BYTE_RE='^[[:space:]]*(pub )?const [a-z_]*(bytes|payload|len|size|message)[[:space:]]*:[[:space:]]*u[0-9]+[[:space:]]*=[[:space:]]*[0-9]+[[:space:]]*;'
COUNT_RE='^[[:space:]]*(pub )?const [a-z_]*(hits|count|entries|items|rows|slots|bindings|leaves|records|frames)[[:space:]]*:[[:space:]]*u[0-9]+[[:space:]]*=[[:space:]]*[0-9]+[[:space:]]*;'

# The population that has yet to declare. Measured 20260910: 29 distinct tracked sources. Falls on
# touch; a wall here would refuse every module at once. Fell 29 -> 25 on 20260910 as the four
# sources the paper walked by hand answered.
undeclared_ceiling="${CEILING_PAIR_UNDECLARED_CEILING:-25}"

# The real, unrepaired class. Measured 20260910: the two wire files the paper walked, both booked.
literal_ceiling="${CEILING_PAIR_LITERAL_CEILING:-2}"

if [ -n "$ROOT" ]; then
  ALL=$(find "$ROOT" -type f -name '*.rye' | sort)
else
  ALL=$(git ls-files -- '*.rye' | sort)
fi

# ONE BATCHED PASS PER PATTERN, rather than two greps per file. A per-file loop over the 1,964
# tracked Rye sources cost 26 seconds of the roster's wall clock, and 1,935 of those files leave
# the population on the first pattern. `declared_ceiling` booked this same arithmetic on
# 20260907: the skip is the common case, and paying a fork to reach it is what made it the
# slowest guard on the roster. The intersection of the two lists is the whole population, and
# only those files are read again.
PAIR_TMP=$(mktemp -d "${TMPDIR:-/tmp}/ceiling-pair.XXXXXX")
trap 'rm -rf "$PAIR_TMP"' EXIT INT TERM
printf '%s\n' "$ALL" > "$PAIR_TMP/all"
: > "$PAIR_TMP/byte"; : > "$PAIR_TMP/count"
if [ -s "$PAIR_TMP/all" ]; then
  xargs grep -alE "$BYTE_RE" < "$PAIR_TMP/all" 2>/dev/null | sort > "$PAIR_TMP/byte" || true
  xargs grep -alE "$COUNT_RE" < "$PAIR_TMP/all" 2>/dev/null | sort > "$PAIR_TMP/count" || true
fi
FILES=$(comm -12 "$PAIR_TMP/byte" "$PAIR_TMP/count")

declaring=0
independent=0
derived=0
literal=0
undeclared=0
unreadable=0
UNDECLARED=""
UNREADABLE=""
LITERAL=""
SEEN=""

for f in $FILES; do
  [ -f "$f" ] || continue

  # One file reached by two names is one file. `comlink/` symlinks into `mantra/`.
  real=$(resolve_path "$f" 2>/dev/null) || real=$f
  case " $SEEN " in *" $real "*) continue ;; esac
  SEEN="$SEEN $real"

  declaring=$((declaring + 1))

  bn=$(grep -ahE "$BYTE_RE" "$f" | sed -E 's/^[[:space:]]*(pub )?const ([a-z_]+)[[:space:]]*:.*/\2/' | sort -u | tr '\n' ',' | sed 's/,$//')
  cn=$(grep -ahE "$COUNT_RE" "$f" | sed -E 's/^[[:space:]]*(pub )?const ([a-z_]+)[[:space:]]*:.*/\2/' | sort -u | tr '\n' ',' | sed 's/,$//')

  line=$(grep -a -m1 '^[[:space:]]*//[[:space:]]*ceilings:' "$f" 2>/dev/null || true)
  if [ -z "$line" ]; then
    undeclared=$((undeclared + 1))
    UNDECLARED="$UNDECLARED $f"
    [ "$MODE" = list ] && echo "undeclared: $f -- count($cn) in front of bytes($bn), no verdict"
    continue
  fi

  verdict=$(printf '%s' "$line" | sed -n 's|.*//[[:space:]]*ceilings:[[:space:]]*\([a-z][a-z]*\).*|\1|p')
  case "$verdict" in
    independent)
      independent=$((independent + 1))
      [ "$MODE" = list ] && echo "independent: $f -- count($cn) and bytes($bn) name axes that never meet"
      ;;
    derived)
      derived=$((derived + 1))
      [ "$MODE" = list ] && echo "derived: $f -- count($cn) is a view of bytes($bn)"
      ;;
    literal)
      literal=$((literal + 1))
      LITERAL="$LITERAL $f"
      [ "$MODE" = list ] && echo "literal: $f -- count($cn) stands in front of bytes($bn), unrepaired"
      ;;
    *)
      unreadable=$((unreadable + 1))
      UNREADABLE="$UNREADABLE $f"
      [ "$MODE" = list ] && echo "unreadable: $f -- declares a verdict no tool can read; write independent, derived, or literal"
      ;;
  esac
done

for u in $UNREADABLE; do
  echo "unreadable: $u names a ceiling verdict that is none of independent, derived, literal"
done
for l in $LITERAL; do
  echo "literal: $l carries a count ceiling standing in front of a byte ceiling"
done

echo "pairs_declaring=$declaring"
echo "pairs_independent=$independent"
echo "pairs_derived=$derived"
echo "pairs_literal=$literal"
echo "pairs_literal_ceiling=$literal_ceiling"
echo "pairs_undeclared=$undeclared"
echo "pairs_undeclared_ceiling=$undeclared_ceiling"
echo "pairs_unreadable=$unreadable"

# A reading over no pairs finds no drift and would report clean while measuring nothing.
if [ "$declaring" -eq 0 ]; then
  echo "verdict=empty_corpus"
  exit 1
fi

if [ "$unreadable" -gt 0 ]; then
  for u in $UNREADABLE; do echo "detail: $u declares a verdict no tool can read"; done
  echo "verdict=unreadable_verdict"
  exit 1
fi

if [ "$literal" -gt "$literal_ceiling" ]; then
  echo "detail: $literal source(s) carry a literal count in front of a byte ceiling against a ceiling of $literal_ceiling, which only ever falls"
  echo "verdict=literal_pair_spread"
  exit 1
fi

if [ "$undeclared" -gt "$undeclared_ceiling" ]; then
  echo "detail: $undeclared source(s) declare both ceilings and answer for neither, against a ceiling of $undeclared_ceiling, which only ever falls"
  echo "verdict=undeclared_spread"
  exit 1
fi

echo "verdict=ok"
