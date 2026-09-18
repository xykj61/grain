#!/bin/sh
# glow_rune_alphabet_worker.sh -- device-free G1 gate for STOA90+.
# Invoked by tools/g/glow_rune_alphabet_witness.rish.

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
TABLE="$ROOT/active-designing/date/20260719/20260719-220814_glow-rune-pronunciation-closed-table.md"
BARTIS_BRIEF="$ROOT/active-designing/date/20260720/20260720-033852_glow-bartis-g1-row.md"
BARKET_BRIEF="$ROOT/active-designing/date/20260720/20260720-151119_glow-barket-g1-row.md"
BARLUS_BRIEF="$ROOT/active-designing/date/20260822/20260822-221639_glow-barlus-g1-row.md"
TOKENS="$ROOT/glow/tokens.rye"

PAIRS=$(awk '/const pairs =/,/};/' "$TOKENS")
echo "$PAIRS" | grep -q 'const pairs' || {
  echo 'FAIL: match_rune2 pairs missing'
  exit 1
}

COUNT=$(echo "$PAIRS" | grep -oE '"[^"]{2}"' | wc -l | tr -d ' ')
test "$COUNT" = "30" || {
  echo "FAIL: expected 30 digraphs in match_rune2, got $COUNT"
  exit 1
}

echo "$PAIRS" | grep -F '"|^"' >/dev/null || {
  echo 'FAIL: |^ barket must tokenize (STOA111)'
  exit 1
}

# THE ROLL IS DERIVED FROM THE LEXER, never listed beside it (`20260909.155028`). The elder loop
# read its glyphs from the heredoc below and asked, of each, whether `match_rune2` carries it. That
# direction can only catch a pronunciation row whose lexer head has gone; it can never catch a lexer
# head that arrived with no pronunciation row, which is the direction the language actually grows in.
# Proven on metal in a throwaway pen the day this was written: `?&` deleted from `match_rune2` left
# the gate GREEN, because no roll row named it to be missed.
#
# TWO NUMBERS WORE ONE NAME, WHICH IS HOW THE DRIFT HID. `COUNT` above reads the LEXER table and was
# updated to 30 when `?&` and `?|` landed on `20260830`; `rune_heads` counts PRONUNCIATION ROWS and
# stayed at 28, and two peers bind that field by name, so it keeps its meaning here. The reading
# nobody could take is the difference between them, published now as `unnamed_heads` -- the glyphs
# the lexer accepts and the table cannot pronounce.
#
# A CEILING RATHER THAN A WALL, because naming a rune is a language custody ruling that stays
# Keaton's. `?&` and `?|` are the ancestor's own spellings, seated as peer names by
# `foundations/20260830-011530_a-rune-is-earned-by-a-law.md`, and what they are called in this
# tree's closed table is his word rather than this guard's. A wall at zero would red the fleet over
# a question no lap may answer; the ceiling holds the fault still and refuses a THIRD.
SPOKEN=$(mktemp "${TMPDIR:-/tmp}/rune-spoken.XXXXXX")
HEADS=$(mktemp "${TMPDIR:-/tmp}/rune-heads.XXXXXX")
trap 'rm -f "$SPOKEN" "$HEADS"' EXIT INT TERM

cat > "$SPOKEN" <<'EOF'
|+	barlus
|-	barhep
|%	barcen
|=	bartis
|^	barket
++	luslus
--	hephep
^-	kethep
=/	tisfas
=.	tisdot
=*	tistar
?:	wutcol
?-	wuthep
?~	wutsig
?>	wutgar
?<	wutgal
:-	colhep
:+	collus
:^	colket
:~	colsig
%-	cenhep
%+	cenlus
%^	cenket
%*	centar
+$	lusbuc
$:	buccol
$%	buccen
/+	faslus
EOF

# The lexer's own table, one glyph per line, is the population every reading below walks.
echo "$PAIRS" | grep -oE '"[^"]{2}"' | tr -d '"' > "$HEADS"

n=0
unnamed=0
unnamed_glyphs=
while read -r glyph; do
  [ -n "$glyph" ] || continue
  spoken=$(awk -F'\t' -v g="$glyph" '$1 == g { print $2; exit }' "$SPOKEN")
  if [ -z "$spoken" ]; then
    unnamed=$((unnamed + 1))
    unnamed_glyphs="$unnamed_glyphs $glyph"
    continue
  fi
  n=$((n + 1))
  if [ "$glyph" = "|=" ]; then
    grep -F "bartis" "$BARTIS_BRIEF" >/dev/null || {
      echo "FAIL: bartis G1 brief missing spoken bartis"
      exit 1
    }
  elif [ "$glyph" = "|^" ]; then
    grep -F "barket" "$BARKET_BRIEF" >/dev/null || {
      echo "FAIL: barket G1 brief missing spoken barket"
      exit 1
    }
  elif [ "$glyph" = "|+" ]; then
    grep -F "barlus" "$BARLUS_BRIEF" >/dev/null || {
      echo "FAIL: barlus G1 brief missing spoken barlus"
      exit 1
    }
  else
    grep -F "| $spoken |" "$TABLE" >/dev/null || {
      echo "FAIL: table missing spoken $spoken"
      exit 1
    }
  fi
done < "$HEADS"

# The elder direction, kept: a pronunciation row whose lexer head has gone is a table describing a
# language this one no longer speaks.
while IFS="$(printf '\t')" read -r glyph spoken; do
  [ -n "$glyph" ] || continue
  grep -Fxq -e "$glyph" "$HEADS" || {
    echo "FAIL: tokens missing $glyph ($spoken has a pronunciation row and no lexer head)"
    exit 1
  }
done < "$SPOKEN"

# BOUNDED BY NAME RATHER THAN BY COUNT, for the reason the vendored-licence clause already gives
# one room over: a ceiling of two cannot tell `?&` from a head somebody swapped in beside it, and a
# swap that keeps the count leaves the gate silent -- proven in the pen, where deleting `?&` and
# adding `!!` read `unnamed_heads=2` and passed. Named, a third unnamed head reds on the lap it
# arrives WHEREVER it arrives, and the day Keaton names these two the list empties and the gate
# tightens to zero by deletion.
UNNAMED_EXEMPT='?& ?|'
for glyph in $unnamed_glyphs; do
  case " $UNNAMED_EXEMPT " in
    *" $glyph "*) ;;
    *)
      echo "FAIL: lexer head $glyph carries no pronunciation row and stands on no exemption"
      echo "detail=exempt is '$UNNAMED_EXEMPT'; a rune is earned by a law, and a name by Keaton's word"
      exit 1
      ;;
  esac
done


# THE FOURTH BINDING -- THE PAGE THAT TEACHES THE RUNE, seated `20260911.202958`. Every binding
# above holds the lexer table against a NAME: the closed pronunciation roll, the three G1 briefs,
# and the TAME family index. None of them asks whether the reference a beginner opens teaches the
# rune at all, and a rune slipped through that hole and stood in it for twenty days. `|+` barlus
# was named on `20260822`, carries STOA332-336, and is folded by seven gate sources under
# `src/gate/` -- and `active-designing/docs/glow/runes.md`, whose own audience line reads *a
# careful beginner writing their first Glow, and any LLM asked to help them*, named it nowhere.
# Neither did the primer, the inventory, or any other page of the Book.
#
# The reading is the same shape as the roll's, one document over: walk the lexer's own heads and
# ask the page about each. A glyph is taught when the page writes it backticked, which is how every
# entry above spells its own digraph.
BOOK="$ROOT/active-designing/docs/glow/runes.md"
test -f "$BOOK" || {
  echo 'FAIL: the rune reference is missing at active-designing/docs/glow/runes.md'
  exit 1
}

book_named=0
book_unnamed=0
book_unnamed_glyphs=
while read -r glyph; do
  [ -n "$glyph" ] || continue
  if grep -qF "\`$glyph\`" "$BOOK"; then
    book_named=$((book_named + 1))
    continue
  fi
  book_unnamed=$((book_unnamed + 1))
  book_unnamed_glyphs="$book_unnamed_glyphs $glyph"
done < "$HEADS"

# EXEMPT BY NAME, AND BY THE SAME CAUSE the pronunciation exemption already stands on. Every entry
# in the reference leads with its spoken name, so a glyph the closed table cannot pronounce is a
# glyph the reference cannot head an entry with: one custody question holding two pages, rather
# than two questions. `?&` and `?|` are the ancestor's own spellings, seated as peer names by
# `foundations/20260830-011530_a-rune-is-earned-by-a-law.md`, and naming them stays Keaton's word.
# A head absent from BOTH lists reds on the lap it arrives, wherever it arrives.
BOOK_EXEMPT='?& ?|'
for glyph in $book_unnamed_glyphs; do
  case " $BOOK_EXEMPT " in
    *" $glyph "*) ;;
    *)
      echo "FAIL: lexer head $glyph is taught nowhere in the rune reference and stands on no exemption"
      echo "detail=exempt is '$BOOK_EXEMPT'; active-designing/docs/glow/runes.md is the page a beginner and an LLM read first"
      exit 1
      ;;
  esac
done

# THE FIFTH READING -- THE HEADS THE LEXER MATCHES ABOVE THE TABLE (`20260915.225111`).
# Every binding above walks `$HEADS`, and `$HEADS` is the `const pairs` constant declared inside
# `match_rune2`. The `lex_one` function calls `match_rune2` only after two branches of its own,
# each matching a rune-shaped two-byte head with a direct `starts_with` call: `::` routed to
# `skip_comment_line`, and `==` pushed as the `.double_equals` token kind. So the four bindings
# read thirty heads where the lexer accepts thirty-two, and the two it cannot see are invisible
# for a structural reason rather than an oversight -- no plant inside the pairs table can reach
# them, and no reading derived from that table can count them.
#
# `==` IS THE ONE THAT SHOWS WHAT THE HOLE COSTS. It is consumed by `glow/rune_shape.rye` at two
# call sites as the tall-form terminator, it stands in 105 tracked `.glow` sources, and it is
# named in none of the three documents this worker binds -- while its structural partner `--`,
# which sits one line below it in the same lexer and closes the same kind of form, is named in
# all three. One head of a matched pair taught and the other silent is exactly the shape the
# fourth binding was seated to catch, and the fourth binding could not see it.
#
# DERIVED FROM `lex_one`, never listed beside it, for the reason the roll's own derivation gives:
# a list can only catch a head that has gone, and the language grows in the other direction.
#
# THE SPAN IS THE FUNCTION RATHER THAN THE FILE, and the two readings agree today by accident. The
# subject is what `lex_one` DISPATCHES on, and `starts_with` is a general predicate called from
# elsewhere: `skip_comment_line` asserts `starts_with(src, i, "::")` as its own precondition, which
# a whole-file read would count as a head. That one costs nothing today, since `sort -u` folds a
# repeat of a glyph `lex_one` already matches -- yet the next such call carrying a literal
# `lex_one` never dispatches on would be counted as an accepted head and refused as an unnamed
# one, which is a red against a guard rather than against the tree. The control plants exactly
# that literal outside `lex_one` and requires this reading to walk past it.
OUTSIDE=$(awk '/^fn lex_one/,/^}/' "$TOKENS" | grep -oE 'starts_with\(src, i, "[^"]{2}"\)' | sed 's/.*"\(..\)".*/\1/' | sort -u)
outside_heads=0
outside_roll_named=0
outside_book_named=0
outside_unnamed_glyphs=
for glyph in $OUTSIDE; do
  outside_heads=$((outside_heads + 1))
  spoken=$(awk -F'\t' -v g="$glyph" '$1 == g { print $2; exit }' "$SPOKEN")
  taught=no
  grep -qF "\`$glyph\`" "$BOOK" && taught=yes
  [ -n "$spoken" ] && outside_roll_named=$((outside_roll_named + 1))
  [ "$taught" = yes ] && outside_book_named=$((outside_book_named + 1))
  if [ -z "$spoken" ] && [ "$taught" = no ]; then
    outside_unnamed_glyphs="$outside_unnamed_glyphs $glyph"
  fi
done

# EXEMPT BY NAME, AND FOR THE SAME CAUSE AS THE TWO ABOVE. Whether a terminator and a comment head
# are runes wanting a pronunciation row is a language custody ruling, and a rune is earned by a law
# (`foundations/20260830-011530_a-rune-is-earned-by-a-law.md`); this guard reports the gap and
# refuses a THIRD. A wall at zero would red the fleet over a question no lap may answer, and a
# ceiling of two cannot tell `==` from a head somebody swapped in beside it.
OUTSIDE_EXEMPT=':: =='
for glyph in $OUTSIDE; do
  case " $OUTSIDE_EXEMPT " in
    *" $glyph "*) ;;
    *)
      echo "FAIL: lexer head $glyph is matched in lex_one above the pairs table and stands on no exemption"
      echo "detail=exempt is '$OUTSIDE_EXEMPT'; a head outside match_rune2 is read by none of the four bindings above, so it is named here or it is named nowhere"
      exit 1
      ;;
  esac
done

test "$n" = "28" || {
  echo "FAIL: expected 28 head rows, got $n"
  exit 1
}

# THE COUNT IS PUBLISHED, so a reader downstream reads a field rather than grepping this
# witness's prose. Two witnesses grepped that sentence for a bare number: one pinned 28 and one
# pinned 27, and when the table grew the sentence was updated and the second grep was not, so five
# witnesses in the barket chain went red and stayed red because no roster runs them (REDS %283). A
# bare number in prose is a loose match too -- "contains 28" answers yes to a STOA128 in the same
# line -- so the field is named as well as counted (scan-seam convention).
echo "rune_heads=$n"
echo "lexer_heads=$COUNT"
echo "unnamed_heads=$unnamed"
echo "unnamed_glyphs=${unnamed_glyphs# }"
echo "book_named=$book_named"
echo "book_unnamed=$book_unnamed"
echo "outside_heads=$outside_heads"
echo "outside_roll_named=$outside_roll_named"
echo "outside_book_named=$outside_book_named"
# The value of the field below can itself begin with `=`, since `==` is one of the glyphs it
# reports; a reader splits it at the FIRST `=` as every other field on this seam is split.
echo "outside_unnamed_glyphs=${outside_unnamed_glyphs# }"
echo "book_unnamed_glyphs=${book_unnamed_glyphs# }"

# Old closed table stays at 25 (dated artifact, STOA90).
grep -F '**25**' "$TABLE" >/dev/null || {
  echo 'FAIL: closed table must still claim **25** (sealed at STOA90)'
  exit 1
}
grep -F '**26**' "$BARTIS_BRIEF" >/dev/null || {
  echo 'FAIL: bartis G1 brief must still claim **26**'
  exit 1
}
grep -F '**27**' "$BARKET_BRIEF" >/dev/null || {
  echo 'FAIL: barket G1 brief must claim **27** (barket as 27th digraph)'
  exit 1
}
grep -F '**28**' "$BARLUS_BRIEF" >/dev/null || {
  echo 'FAIL: barlus G1 brief must claim **28** (barlus as 28th digraph)'
  exit 1
}
grep -F 'glow_rune_alphabet_witness.rish' "$TABLE" >/dev/null || {
  echo 'FAIL: table must name witness'
  exit 1
}
grep -F 'STOA90' "$TABLE" >/dev/null || {
  echo 'FAIL: table must name STOA90'
  exit 1
}

# --- G2: TAME_GUIDANCE Glow pin carries alphabet + family index ---
TAME="$ROOT/context/TAME_GUIDANCE.md"
grep -F 'Family index (GREEN heads only)' "$TAME" >/dev/null || {
  echo 'FAIL: TAME_GUIDANCE missing Family index (G2)'
  exit 1
}
grep -F 'Glyph alphabet (compact)' "$TAME" >/dev/null || {
  echo 'FAIL: TAME_GUIDANCE missing Glyph alphabet (G2)'
  exit 1
}
grep -F 'STOA91' "$TAME" >/dev/null || {
  echo 'FAIL: TAME_GUIDANCE must name STOA91'
  exit 1
}
grep -F '20260719-220814_glow-rune-pronunciation-closed-table.md' "$TAME" >/dev/null || {
  echo 'FAIL: TAME_GUIDANCE must link G1 closed table'
  exit 1
}
for spoken in barhep wutgar faslus kethep barcen bartis barket; do
  grep -F "$spoken" "$TAME" >/dev/null || {
    echo "FAIL: TAME family index missing $spoken"
    exit 1
  }
done
grep -F 'bartis' "$TAME" >/dev/null || {
  echo 'FAIL: TAME pin must name bartis'
  exit 1
}
grep -F 'barket' "$TAME" >/dev/null || {
  echo 'FAIL: TAME pin must name barket'
  exit 1
}

echo OK
