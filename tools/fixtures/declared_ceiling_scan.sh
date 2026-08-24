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

# Tool sources that write the bound down without deciding with it -- a comment, a witness assert
# that pins the law's value on purpose, a control's planted pen page. Measured 20260824.140523:
# six lines across six files. A ceiling that only ever falls, so the habit may shrink and may not
# spread.
law_recite_ceiling="${DECLARED_LAW_RECITE_CEILING:-6}"

# The seated law, read from the one script that reads it. This block held its own copy of the
# reading idiom until `20260824.140523`, and its comment said three scripts carried their own
# number where the tree held five -- so the reading moved into
# tools/fixtures/living_pin_max_bytes.sh and every meter now calls it (REDS %199).
# The helper names its own reason on stderr -- law missing, or law stating no readable number --
# so the refusal carries the reason rather than a generic verdict.
LIVING_PIN_MAX_BYTES="${DECLARED_BOUND_MAX_BYTES:-}"
if [ -z "$LIVING_PIN_MAX_BYTES" ]; then
  if ! LIVING_PIN_MAX_BYTES=$(sh "$(dirname "$0")/living_pin_max_bytes.sh" 2>&1); then
    echo "detail: $LIVING_PIN_MAX_BYTES"
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

# THE FOURTH READING, seated `20260824.140523`. A page declaring the bound is one half of the law;
# the other half is the meters that measure against it, and until this lap five of them spelled the
# number themselves. `tools/fixtures/living_pin_max_bytes.sh` is the one reading now, and this
# reading is the wall that keeps it one.
#
# TWO FORMS, because they carry different weight. A meter that ASSIGNS the number to a variable or
# COMPARES against it as a literal is DECIDING with a copy, and a copy that decides is a guard that
# can disagree with the law while reporting green -- gated at zero. A file that merely writes the
# number down in a comment, an assert string, or planted pen data is RECITING it, which is honest
# where the number is the subject; those ride a ceiling that only ever falls.
#
# A WITNESS ASSERTS AND A CONTROL PLANTS; A SCAN DECIDES. So `*_witness.rish` and `*_control.sh` sit
# outside the gated reading by their file role rather than by name -- `declared_ceiling_witness.rish`
# pins the law's own value in an assert deliberately, and that assert is the check that the law
# has not moved without anyone noticing. Naming the two roles is what keeps this from becoming a remembered
# exemption list, which is the shape this tree has now booked five times (REDS %187, %190, %192,
# %197, %199).
#
# SCOPE IS `tools/`, asked of git rather than of a glob. The law's meters all live there. Three
# `.rye` sources elsewhere reach the same value as ordinary arithmetic -- an image dimension
# ceiling times three, a filter coefficient -- and they are a different subject entirely.
decide_re="(^|[^A-Za-z0-9_])[A-Za-z_][A-Za-z0-9_]*=$LIVING_PIN_MAX_BYTES([^0-9]|$)"
decide_re="$decide_re|-(gt|ge|lt|le|eq|ne)[[:space:]]+\"?$LIVING_PIN_MAX_BYTES"
recite_re="(^|[^0-9])$LIVING_PIN_MAX_BYTES([^0-9]|$)"

# ONE PASS, rather than two greps per file. A per-file loop over the 2,046 tracked sources under
# tools/ cost 39 seconds of the roster's wall clock; batched through xargs it costs under two.
# Every deciding line also spells the number, so the deciding set is a filter over the reciting
# set rather than a second walk of the tree.
LAW_TMP=$(mktemp -d "${TMPDIR:-/tmp}/declared-ceiling-law.XXXXXX")
trap 'rm -rf "$LAW_TMP"' EXIT INT TERM

# DECLARED_LAW_ROOT lets the control point this reading at a real git repository in a throwaway
# pen, so both refusals are proven every roster pass rather than once by a hand.
LAW_ROOT="${DECLARED_LAW_ROOT:-.}"
( cd "$LAW_ROOT" && git ls-files 'tools/*' 2>/dev/null ) > "$LAW_TMP/files" || : > "$LAW_TMP/files"
: > "$LAW_TMP/recite"
if [ -s "$LAW_TMP/files" ]; then
  ( cd "$LAW_ROOT" && xargs grep -aHnE "$recite_re" < "$LAW_TMP/files" ) > "$LAW_TMP/recite" 2>/dev/null || true
fi
law_recite=$(wc -l < "$LAW_TMP/recite" | tr -d ' ')

# A witness asserts and a control plants, so both sit outside the gated reading; a comment recites,
# so only a live line decides.
grep -vE '^[^:]*(_witness\.rish|_control\.sh):' "$LAW_TMP/recite" 2>/dev/null \
  | grep -vE '^[^:]*:[0-9]+:[[:space:]]*#' 2>/dev/null \
  | grep -E "$decide_re" > "$LAW_TMP/decide" 2>/dev/null || : > "$LAW_TMP/decide"
law_decide=$(wc -l < "$LAW_TMP/decide" | tr -d ' ')
LAW_DECIDE_SITES=$(cut -d: -f1 < "$LAW_TMP/decide" | sort | uniq -c | awk '{print $2 ":" $1}')

for d in $LAW_DECIDE_SITES; do
  echo "law-copy: ${d%%:*} decides with its own copy of the bound on ${d#*:} line(s)"
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
echo "law_copies_deciding=$law_decide"
echo "law_copies_reciting=$law_recite"
echo "law_recite_ceiling=$law_recite_ceiling"

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

# A meter deciding with its own copy of the bound is the fault this whole guard was written for,
# arriving one layer down: the pages are measured, and the thing measuring them held the number
# five ways (REDS %199). Held at zero.
if [ "$law_decide" -gt 0 ]; then
  echo "detail: $law_decide tool line(s) decide with a copy of the bound rather than reading tools/fixtures/living_pin_max_bytes.sh"
  echo "verdict=law_number_copied"
  exit 1
fi

if [ "$law_recite" -gt "$law_recite_ceiling" ]; then
  echo "detail: the bound is written down in $law_recite tool line(s) against a ceiling of $law_recite_ceiling, which only ever falls"
  echo "verdict=law_recitation_spread"
  exit 1
fi

echo "verdict=ok"
