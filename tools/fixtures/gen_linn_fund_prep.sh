#!/bin/sh
# gen_linn_fund_prep.sh — Linn fund prep (Capricorn earth · seat 10 · Helen)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"
PAGE=edu/funds/linn-opening.md

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain|shred|breach|yes|now)
    echo "gen-linn REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

grep -q 'Linn (fund)' context/LEXICON.md
grep -q 'linn.fund' context/LEXICON.md
grep -q '%linn' context/LEXICON.md
grep -q 'Capricorn' context/LEXICON.md
grep -q 'Helen Atthowe' context/LEXICON.md
grep -q 'sundial' context/LEXICON.md
test -f context/CIVIC_STYLE.md
test -f "$PAGE"
grep -q 'Linn' "$PAGE"
grep -q 'Capricorn' "$PAGE"
grep -q 'linn.fund' "$PAGE"
grep -q '%linn' "$PAGE"
grep -q 'Helen Atthowe' "$PAGE"
grep -q 'no live deploy' "$PAGE"
grep -q 'witness:linn-open GREEN' "$PAGE"
test -f counsel/date/20260728/20260728-034317_linn-capricorn-seat.md
test -f counsel/date/20260728/20260728-035025_linn-helen-atthowe-dedication.md
test -f gratitude/helen-atthowe.md
test -f foundations/yonder/20260728-035025_linn-and-helen-atthowe.md
test -f tools/s/sundial.rish

name=Linn
len=$(printf '%s' "$name" | wc -c)
test "$len" -eq 4
printf '%s' "$name" | grep -Eq '^[A-Za-z]{4}$'

echo "seat: fund=Linn order=10 sign_index=9 (Capricorn) vane=%linn dns_prep=linn.fund"
echo "dedication: Helen Atthowe (honor · The Ecological Farm)"
echo "hats: sponsor·executive held (blank)"
echo "page: edu/funds/linn-opening.md (prep grow · page one)"
echo "witness:linn-open GREEN — seat · Helen dedication · vane · hard lines"
echo "refuse: deploy · wallet · gas · claim-domain · shred · breach"
echo "linn_fund=prep"
echo "GREEN: gen-linn — Capricorn earth seat 10 · Helen dedication · deploy RED"
