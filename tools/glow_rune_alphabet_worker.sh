#!/bin/sh
# glow_rune_alphabet_worker.sh — device-free G1 gate for STOA90+.
# Invoked by tools/glow_rune_alphabet_witness.rish.

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TABLE="$ROOT/active-designing/20260719-220814_glow-rune-pronunciation-closed-table.md"
BARTIS_BRIEF="$ROOT/active-designing/20260720-033852_glow-bartis-g1-row.md"
BARKET_BRIEF="$ROOT/active-designing/20260720-151119_glow-barket-g1-row.md"
TOKENS="$ROOT/glow/tokens.rye"

PAIRS=$(awk '/const pairs =/,/};/' "$TOKENS")
echo "$PAIRS" | grep -q 'const pairs' || {
  echo 'FAIL: match_rune2 pairs missing'
  exit 1
}

COUNT=$(echo "$PAIRS" | grep -oE '"[^"]{2}"' | wc -l | tr -d ' ')
test "$COUNT" = "27" || {
  echo "FAIL: expected 27 digraphs in match_rune2, got $COUNT"
  exit 1
}

echo "$PAIRS" | grep -F '"|^"' >/dev/null || {
  echo 'FAIL: |^ barket must tokenize (STOA111)'
  exit 1
}

n=0
while IFS="$(printf '\t')" read -r glyph spoken; do
  n=$((n + 1))
  echo "$PAIRS" | grep -F "\"$glyph\"" >/dev/null || {
    echo "FAIL: tokens missing $glyph"
    exit 1
  }
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
  else
    grep -F "| $spoken |" "$TABLE" >/dev/null || {
      echo "FAIL: table missing spoken $spoken"
      exit 1
    }
  fi
done <<'EOF'
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

test "$n" = "27" || {
  echo "FAIL: expected 27 head rows, got $n"
  exit 1
}

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
