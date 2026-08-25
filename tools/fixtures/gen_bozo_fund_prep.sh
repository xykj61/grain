#!/bin/sh
# gen_bozo_fund_prep.sh -- Bozo fund prep (Capricorn earth - seat 10 - was Linn - Helen - DJINN)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"
PAGE=edu/funds/bozo-opening.md

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain|shred|breach|yes|now)
    echo "gen-bozo REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

grep -q 'Bozo (fund)' context/LEXICON.md
grep -q 'bozo.fund' context/LEXICON.md
grep -q '%bozo' context/LEXICON.md
grep -q 'Capricorn' context/LEXICON.md
grep -q 'Helen Atthowe' context/LEXICON.md
grep -q 'DJINN' context/LEXICON.md
grep -q 'Linn (fund) (retired name)' context/LEXICON.md
test -f context/CIVIC_STYLE.md
test -f "$PAGE"
grep -q 'Bozo' "$PAGE"
grep -q 'Capricorn' "$PAGE"
grep -q 'bozo.fund' "$PAGE"
grep -q '%bozo' "$PAGE"
grep -q 'Helen Atthowe' "$PAGE"
grep -q 'DJINN' "$PAGE"
grep -q 'no live deploy' "$PAGE"
grep -q 'witness:bozo-open GREEN' "$PAGE"
test -f counsel/date/20260730/20260730-150702_pole-bozo-djinn-murr-keaton.md
test -f counsel/date/20260728/20260728-034317_linn-capricorn-seat.md
test -f gratitude/helen-atthowe.md
test -f foundations/yonder/20260728-035025_linn-and-helen-atthowe.md

name=Bozo
len=$(printf '%s' "$name" | wc -c)
test "$len" -eq 4
printf '%s' "$name" | grep -Eq '^[A-Za-z]{4}$'

echo "seat: fund=Bozo order=10 sign_index=9 (Capricorn) vane=%bozo dns_prep=bozo.fund"
echo "was: Linn / %linn / linn.fund (rename-forward 20260730.150702)"
echo "dedication: Helen Atthowe (honor · The Ecological Farm · kept)"
echo "executive: DJINN (from Murr · POLE)"
echo "hats: sponsor held (blank)"
echo "page: edu/funds/bozo-opening.md (prep grow · page one)"
echo "witness:bozo-open GREEN — seat · Helen dedication · DJINN executive · vane · hard lines"
echo "refuse: deploy · wallet · gas · claim-domain · shred · breach"
echo "bozo_fund=prep"
echo "GREEN: gen-bozo — Capricorn earth seat 10 · Helen · DJINN · deploy RED"
