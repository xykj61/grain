#!/bin/sh
# glow_rune_alphabet_worker.sh — device-free G1 gate for STOA90.
# Invoked by tools/glow_rune_alphabet_witness.rish.

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)
TABLE="$ROOT/active-designing/20260719-220814_glow-rune-pronunciation-closed-table.md"
TOKENS="$ROOT/glow/tokens.rye"

PAIRS=$(awk '/const pairs =/,/};/' "$TOKENS")
echo "$PAIRS" | grep -q 'const pairs' || {
  echo 'FAIL: match_rune2 pairs missing'
  exit 1
}

COUNT=$(echo "$PAIRS" | grep -oE '"[^"]{2}"' | wc -l | tr -d ' ')
test "$COUNT" = "25" || {
  echo "FAIL: expected 25 digraphs in match_rune2, got $COUNT"
  exit 1
}

if echo "$PAIRS" | grep -F '"|="' >/dev/null; then
  echo 'FAIL: |= bartis must stay horizon'
  exit 1
fi
if echo "$PAIRS" | grep -F '"|^"' >/dev/null; then
  echo 'FAIL: |^ barket must stay horizon'
  exit 1
fi

n=0
while IFS="$(printf '\t')" read -r glyph spoken; do
  n=$((n + 1))
  echo "$PAIRS" | grep -F "\"$glyph\"" >/dev/null || {
    echo "FAIL: tokens missing $glyph"
    exit 1
  }
  grep -F "| $spoken |" "$TABLE" >/dev/null || {
    echo "FAIL: table missing spoken $spoken"
    exit 1
  }
done <<'EOF'
|-	barhep
|%	barcen
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

test "$n" = "25" || {
  echo "FAIL: expected 25 head rows, got $n"
  exit 1
}

grep -F '**25**' "$TABLE" >/dev/null || {
  echo 'FAIL: table must claim **25**'
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

echo OK
