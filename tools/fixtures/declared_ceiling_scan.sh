#!/bin/sh
# tools/fixtures/declared_ceiling_scan.sh -- a page that declares its own ceiling is measured
# against it.
#
# WHY. Thirteen living pages on the docs shelf carry a `**Ceiling:** <=N lines` header, and it is
# the page's own promise about how long it will stay. Measured 20260824.121500, no guard anywhere
# in this tree read one of them. Two had drifted past their own number in silence: docs/README.md
# declared 40 lines and stood at 43, and docs/CRYPTO.md declared 300 and stood at 311 -- with its
# declaration rewritten into a paragraph of prose narrating the drift, so no tool could read the
# number at all (REDS %191 named this reading twice and left it open both times).
#
# A declared bound nobody measures is a promise waiting to break. This scan is the measurement,
# and after it the promise is either kept or loudly moved.
#
# WHAT IS GATED, at zero, both readings:
#
#   1. a page standing above its own declared ceiling
#   2. a declaration a tool cannot read
#
# The second matters as much as the first, and it is the half a line count alone misses. A
# `Ceiling:` header no parser can reach is indistinguishable from no ceiling at all, so a page
# could drift forever while appearing to declare a bound. That is how docs/CRYPTO.md drifted:
# its header was replaced with prose ABOUT the ceiling, which reads perfectly to a person and
# says nothing to a program.
#
# THE DECLARATION, spelled exactly so it stays checkable:
#
#   **Ceiling:** <=N lines
#
# ASCII `<=`, never the single-glyph form. That is the ascii-first law (`.claude/rules/ascii-first.md`)
# rather than a parser's convenience: a declaration meant for a tool is written in the bytes every
# tool reads the same way. Ten of the thirteen pages wrote the glyph and swept to `<=` on the lap
# this guard was seated.
#
# THE THIRD READING, reported rather than gated. One page declares its bound a different way --
# `docs/STOA.md` writes `<=80` into its own H1 title, in the grade notation the shelf index uses,
# and stands at 166 lines. Gating that would force a page split into the round that seated this
# guard, so it is counted instead, under a ceiling that only ever falls: the form may shrink and
# may not spread. It is reported at every roster pass rather than remembered, because a guard
# that reads 13 of 14 declarations and says nothing about the fourteenth is the roster-reaching-6-
# of-34 shape this tree has now booked three times (REDS %187, %190, %192).
#
# WHAT IT DOES NOT REACH. Whether the ceiling is the RIGHT number, and the separate 24,576-byte
# living-document bound, which `tools/l/living_docs_lint.rish` already measures over all 34 module
# front doors. A page may hold 300 short lines and 300,000 bytes; this reads the promise the page
# made, and that promise is counted in lines because that is what the pages say.
#
# THE CORPUS is discovered rather than listed -- `git ls-files` for every tracked `.md`, minus
# dated testimony, which keeps every word it ever wrote (`.claude/rules/stamp-and-name.md`). A
# hand-written roster is what REDS %187 was booked for: it reached 6 of 34 doors and nobody knew.
#
# USAGE
#   sh tools/fixtures/declared_ceiling_scan.sh          # census -- key=value lines
#   sh tools/fixtures/declared_ceiling_scan.sh list      # every page, its declaration, its length
#
# Driven by tools/d/declared_ceiling_witness.rish. Run from the repository root.
set -eu

MODE="${1:-census}"
ROOT="${DECLARED_CEILING_ROOT:-}"

# The corpus. A real run asks git; the control hands it a directory of its own so the pen never
# touches the tree.
if [ -n "$ROOT" ]; then
  FILES=$(find "$ROOT" -type f -name '*.md' | sort)
else
  FILES=$(git ls-files -- '*.md' | sort)
fi

declaring=0
holding=0
over=0
unparseable=0
grade_only=0
OVER=""
UNPARSEABLE=""
GRADE_ONLY=""

# The title-grade form may shrink and may not spread. Measured 20260824.121500: one page.
grade_ceiling="${DECLARED_CEILING_GRADE_CEILING:-1}"

# The single-glyph form of `<=`, built from its bytes so this script stays plain ASCII itself
# (`.claude/rules/ascii-first.md`). A guard that had to be written in the character it discourages
# would be teaching one thing and doing another.
LE_GLYPH=$(printf '\342\211\244')

for f in $FILES; do
  [ -f "$f" ] || continue

  # Dated testimony keeps every word it wrote. A basename carrying a one-clock stamp is
  # testimony; the settled spelling accepts a sprig or no sprig (REDS %175, %178).
  b=$(basename "$f")
  case "$b" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*) continue ;;
  esac

  line=$(grep -m1 '^\*\*Ceiling:\*\*' "$f" 2>/dev/null || true)

  # A bound written into the H1 title in the shelf's grade notation, rather than the header form.
  if [ -z "$line" ]; then
    raw=$(head -1 "$f")
    case "$raw" in
      '#'*)
        title=$(printf '%s' "$raw" | sed "s/$LE_GLYPH/<=/g")
        if printf '%s' "$title" | grep -qE '<=[[:space:]]*[0-9]+'; then
          grade_only=$((grade_only + 1))
          want_g=$(printf '%s' "$title" | sed -n 's/.*<=[[:space:]]*\([0-9][0-9]*\).*/\1/p' | head -1)
          have_g=$(wc -l < "$f" | tr -d ' ')
          if [ -n "$want_g" ] && [ "$have_g" -gt "$want_g" ]; then
            GRADE_ONLY="$GRADE_ONLY $f:${have_g}_lines_against_${want_g}"
          else
            GRADE_ONLY="$GRADE_ONLY $f:${have_g}_lines"
          fi
        fi
        ;;
    esac
  fi

  [ -n "$line" ] || continue
  declaring=$((declaring + 1))

  want=$(printf '%s\n' "$line" | sed -n 's/.*<=[[:space:]]*\([0-9][0-9]*\)[[:space:]]*lines.*/\1/p' | head -1)
  if [ -z "$want" ]; then
    unparseable=$((unparseable + 1))
    UNPARSEABLE="$UNPARSEABLE $f"
    continue
  fi

  have=$(wc -l < "$f" | tr -d ' ')
  if [ "$have" -le "$want" ]; then
    holding=$((holding + 1))
    [ "$MODE" = list ] && echo "holds: $f -- $have lines against a declared $want"
  else
    over=$((over + 1))
    OVER="$OVER $f"
    [ "$MODE" = list ] && echo "over: $f -- $have lines against a declared $want, by $((have - want))"
  fi
done

if [ "$MODE" = list ]; then
  for u in $UNPARSEABLE; do
    echo "unreadable: $u -- declares a ceiling no tool can read; write it '**Ceiling:** <=N lines'"
  done
fi

for g in $GRADE_ONLY; do
  echo "grade-only: ${g%%:*} declares its bound in its title rather than a Ceiling header (${g#*:})"
done

echo "pages_declaring=$declaring"
echo "pages_holding=$holding"
echo "pages_over=$over"
echo "pages_unreadable=$unparseable"
echo "pages_grade_only=$grade_only"
echo "grade_only_ceiling=$grade_ceiling"

# A reading over no declarations finds no drift and would report clean while measuring nothing.
if [ "$declaring" -eq 0 ]; then
  echo "verdict=empty_corpus"
  exit 1
fi

if [ "$over" -gt 0 ]; then
  for o in $OVER; do echo "detail: $o stands above the ceiling it declares"; done
  echo "verdict=over_declared_ceiling"
  exit 1
fi

if [ "$unparseable" -gt 0 ]; then
  for u in $UNPARSEABLE; do echo "detail: $u declares a ceiling no tool can read"; done
  echo "verdict=unreadable_declaration"
  exit 1
fi

if [ "$grade_only" -gt "$grade_ceiling" ]; then
  echo "detail: the title-grade form stands on $grade_only pages against a ceiling of $grade_ceiling, which only ever falls"
  echo "verdict=grade_form_spread"
  exit 1
fi

echo "verdict=ok"
