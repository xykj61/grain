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
# WHAT IS GATED, at zero:
#
#   1. a page standing above its own declared ceiling
#   2. a declaration a tool cannot read
#   3. a page whose declared byte bound names a different number than the seated law
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
# THE SECOND DECLARATION FORM, added `20260824.130807`. A living pin declares its size the same
# way, in bytes rather than lines:
#
#   **Bound:** under `living_pin_max_bytes` (24576)
#
# Thirteen living pages carry it, and until this lap the only guard that REFUSED on it read a
# hand-written roster of seven paths -- with `construction/ITINERARY.md`, the pin the unattended
# loop reads first, marked `advisory` on that roster, and `session-logs/README.md` absent from it
# altogether. `tools/l/living_docs_lint.rish` duty 6 discovers sixty pages and never blocks. So the
# law had two meters and no wall, and the card grew past its bound twice (REDS %197). This is the
# same class the `Ceiling:` reading was seated for one lap earlier -- a page declares its own limit
# and something measures it -- so it joins that roof rather than raising a third.
#
# A `**Bound:**` header that names `living_pin_max_bytes` is a byte declaration and is measured.
# One that does not -- `keep thin`, `listings stay sentence-cheap` -- is an honest human bound this
# guard does not reach, counted under a ceiling that only falls rather than called a fault.
#
# The number comes from the seated law at
# `context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md` rather than a fourth
# hardcoded copy, and a page spelling a DIFFERENT number is gated at zero: a declaration that
# disagrees with the law it cites is the drift this whole guard exists to catch.
#
# THE THIRD READING, reported rather than gated. One page declares its bound a different way --
# `docs/STOA.md` writes `<=80` into its own H1 title, in the grade notation the shelf index uses,
# and stands at 166 lines. Gating that would force a page split into the round that seated this
# guard, so it is counted instead, under a ceiling that only ever falls: the form may shrink and
# may not spread. It is reported at every roster pass rather than remembered, because a guard
# that reads 13 of 14 declarations and says nothing about the fourteenth is the roster-reaching-6-
# of-34 shape this tree has now booked three times (REDS %187, %190, %192).
#
# WHAT IT DOES NOT REACH. Whether the declared number is the RIGHT number, and any bound written
# in prose rather than in a form a parser reaches. A page may hold 300 short lines and 300,000
# bytes; each declaration is read in the unit the page itself wrote it in.
#
# EVERY READ IS `grep -a`, and the flag is cheap insurance rather than a fix for a live fault.
# Measured `20260824.130807`, both ways: GNU grep 3.12, which every script here runs, reads a file
# carrying an orphan UTF-8 lead byte correctly, so no guard was blinded by the four such files
# standing in the tree that morning. ugrep, which a hand at this bench runs interactively,
# classifies the same file binary and returns nothing with exit 1 -- byte for byte what "this page
# declares nothing" looks like. `-a` makes this scan's answer the same whichever is installed. The
# four files are repaired and `tools/l/living_card_ascii_witness.rish` now gates UTF-8 validity at
# zero across every tracked text file, which measures the corruption rather than one tool's
# reaction to it (REDS %198).
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

bounds_declaring=0
bounds_holding=0
bounds_over=0
bounds_prose=0
bounds_disagree=0
BOUNDS_OVER=""
BOUNDS_PROSE=""
BOUNDS_DISAGREE=""

# The title-grade form may shrink and may not spread. Measured 20260824.121500: one page.
grade_ceiling="${DECLARED_CEILING_GRADE_CEILING:-1}"

# A living pin past its declared byte bound. Measured 20260824.130807: one page,
# session-logs/README.md, whose rows fold when its logs fold and whose log fold runs on Keaton's
# word. A ceiling that only ever falls, rather than a gate that would refuse a word-gated remedy.
bound_over_ceiling="${DECLARED_BOUND_OVER_CEILING:-1}"

# A `**Bound:**` header naming no measurable limit -- `keep thin`, `listings stay sentence-cheap`.
# Honest human bounds this guard does not reach. Measured 20260824.130807: two pages.
bound_prose_ceiling="${DECLARED_BOUND_PROSE_CEILING:-2}"

# The seated law, read from the spec that holds it rather than copied a fourth time. Three scripts
# already carry their own 24576; a number repeated is a number that can quietly disagree with
# itself, which is the fault this whole guard was written for.
LAW_SPEC="context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md"
LIVING_PIN_MAX_BYTES="${DECLARED_BOUND_MAX_BYTES:-}"
if [ -z "$LIVING_PIN_MAX_BYTES" ]; then
  if [ ! -f "$LAW_SPEC" ]; then
    echo "detail: the seated bound law is missing at $LAW_SPEC"
    echo "verdict=law_absent"
    exit 1
  fi
  LIVING_PIN_MAX_BYTES=$(grep -a -m1 '^living_pin_max_bytes' "$LAW_SPEC" \
    | sed -n 's/.*=[[:space:]]*\([0-9][0-9]*\).*/\1/p' | head -1)
  if [ -z "$LIVING_PIN_MAX_BYTES" ]; then
    echo "detail: $LAW_SPEC states no readable living_pin_max_bytes"
    echo "verdict=law_unreadable"
    exit 1
  fi
fi

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

  # The byte declaration a living pin makes about itself.
  bline=$(grep -a -m1 '^\*\*Bound:\*\*' "$f" 2>/dev/null || true)
  if [ -n "$bline" ]; then
    if printf '%s' "$bline" | grep -q 'living_pin_max_bytes'; then
      bounds_declaring=$((bounds_declaring + 1))
      spelled=$(printf '%s' "$bline" \
        | sed -n 's/.*living_pin_max_bytes[^0-9]*\([0-9][0-9]*\).*/\1/p' | head -1)
      bwant="$LIVING_PIN_MAX_BYTES"
      if [ -n "$spelled" ]; then
        bwant="$spelled"
        if [ "$spelled" -ne "$LIVING_PIN_MAX_BYTES" ]; then
          bounds_disagree=$((bounds_disagree + 1))
          BOUNDS_DISAGREE="$BOUNDS_DISAGREE $f:${spelled}_against_${LIVING_PIN_MAX_BYTES}"
        fi
      fi
      bhave=$(wc -c < "$f" | tr -d ' ')
      if [ "$bhave" -le "$bwant" ]; then
        bounds_holding=$((bounds_holding + 1))
        [ "$MODE" = list ] && echo "holds: $f -- $bhave bytes against a declared $bwant"
      else
        bounds_over=$((bounds_over + 1))
        BOUNDS_OVER="$BOUNDS_OVER $f:${bhave}_against_${bwant}"
        [ "$MODE" = list ] && echo "over: $f -- $bhave bytes against a declared $bwant"
      fi
    else
      bounds_prose=$((bounds_prose + 1))
      BOUNDS_PROSE="$BOUNDS_PROSE $f"
    fi
  fi

  line=$(grep -a -m1 '^\*\*Ceiling:\*\*' "$f" 2>/dev/null || true)

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

for b in $BOUNDS_OVER; do
  echo "bound-over: ${b%%:*} stands above the byte bound it declares (${b#*:})"
done
for b in $BOUNDS_PROSE; do
  echo "bound-prose: $b declares a bound in words rather than in a form a tool reads"
done

echo "pages_declaring=$declaring"
echo "pages_holding=$holding"
echo "pages_over=$over"
echo "pages_unreadable=$unparseable"
echo "pages_grade_only=$grade_only"
echo "grade_only_ceiling=$grade_ceiling"
echo "living_pin_max_bytes=$LIVING_PIN_MAX_BYTES"
echo "bounds_declaring=$bounds_declaring"
echo "bounds_holding=$bounds_holding"
echo "bounds_over=$bounds_over"
echo "bounds_over_ceiling=$bound_over_ceiling"
echo "bounds_prose=$bounds_prose"
echo "bounds_prose_ceiling=$bound_prose_ceiling"
echo "bounds_disagree=$bounds_disagree"

# A reading over no declarations finds no drift and would report clean while measuring nothing.
if [ "$declaring" -eq 0 ] && [ "$bounds_declaring" -eq 0 ]; then
  echo "verdict=empty_corpus"
  exit 1
fi

# A page citing the law and spelling a different number is the drift this guard exists for.
if [ "$bounds_disagree" -gt 0 ]; then
  for d in $BOUNDS_DISAGREE; do
    echo "detail: ${d%%:*} spells a bound the seated law does not (${d#*:})"
  done
  echo "verdict=bound_disagrees_with_law"
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

if [ "$bounds_over" -gt "$bound_over_ceiling" ]; then
  echo "detail: $bounds_over living pins stand above their declared byte bound against a ceiling of $bound_over_ceiling, which only ever falls"
  echo "verdict=over_declared_bound"
  exit 1
fi

if [ "$bounds_prose" -gt "$bound_prose_ceiling" ]; then
  echo "detail: the prose-bound form stands on $bounds_prose pages against a ceiling of $bound_prose_ceiling, which only ever falls"
  echo "verdict=bound_prose_spread"
  exit 1
fi

echo "verdict=ok"
