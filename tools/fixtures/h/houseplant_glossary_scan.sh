#!/bin/sh
# tools/fixtures/h/houseplant_glossary_scan.sh -- the houseplant Lexicon row, read once.
# Orchestrated by tools/gen/chapter/houseplant_glossary_witness.rish and its negative sibling.
#
#   sh tools/fixtures/h/houseplant_glossary_scan.sh [lexicon-path]
#
# Why this exists: houseplant_glossary_witness.rish's own checks -- the row's three defining
# words, its seated stamp, its two distinctions (pier, verse), and the fund-star-ship ladder's
# own accretion -- were five separate inline `grep` calls with no way to prove any one of them
# bites short of breaking a row in a live Lexicon. Pulled out here with a path argument, the
# positive leg reads the live context/LEXICON.md and the negative leg reads a standing fixture
# at context/fixtures/houseplant_glossary_missing/LEXICON.md that carries a houseplant row with
# the distinctions and the ladder accretion both stripped out, so each refusal is observed on a
# planted case and no tracked Lexicon row is ever made to hold the fault.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
set -eu
lexicon="${1:-context/LEXICON.md}"
[ -f "$lexicon" ] || { echo "lexicon=$lexicon"; echo "verdict=missing_file"; exit 2; }

row=$(grep -F '| **houseplant** |' "$lexicon" || true)
missing=0

if [ -z "$row" ]; then
  echo "detail: no houseplant row"
  missing=$((missing + 1))
else
  for word in ship repository "project tree"; do
    case "$row" in
      *"$word"*) : ;;
      *) echo "detail: row missing word -- $word"; missing=$((missing + 1)) ;;
    esac
  done
  case "$row" in
    *20260730.120643*) : ;;
    *) echo "detail: row missing seated stamp"; missing=$((missing + 1)) ;;
  esac
  case "$row" in
    *pier*) : ;;
    *) echo "detail: row missing pier distinction"; missing=$((missing + 1)) ;;
  esac
  case "$row" in
    *verse*) : ;;
    *) echo "detail: row missing verse distinction"; missing=$((missing + 1)) ;;
  esac
fi

ladder=$(grep -F '| **fund - star - ship** |' "$lexicon" || true)
case "$ladder" in
  *houseplant*) : ;;
  *) echo "detail: ladder row missing houseplant accretion"; missing=$((missing + 1)) ;;
esac

echo "lexicon=$lexicon"
echo "missing_count=$missing"
if [ "$missing" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
else
  echo "verdict=missing"
  exit 1
fi
