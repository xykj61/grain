#!/bin/sh
# gen_keeh_fund_prep.sh — Keeh fund prep (Aquarius · was Ketu · Kia sponsor)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"
PAGE=edu/funds/keeh-opening.md

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain|shred|breach|yes|now)
    echo "gen-keeh REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

grep -q 'Keeh (fund)' context/LEXICON.md
grep -q 'keeh.fund' context/LEXICON.md
grep -q '%keeh' context/LEXICON.md
grep -q 'Aquarius' context/LEXICON.md
grep -q 'Keaton Sealy Livermore' context/LEXICON.md
grep -q 'Ketu (fund) (retired name)' context/LEXICON.md
grep -q 'Honor sponsor' context/LEXICON.md
grep -q 'fund sponsor' context/LEXICON.md
grep -q 'Kia' context/LEXICON.md
grep -q 'Craigslist' context/LEXICON.md
grep -q 'non-CVT' context/LEXICON.md
grep -q 'quint' context/LEXICON.md
test -f context/CIVIC_STYLE.md
test -f gratitude/kia.md
test -f foundations/yonder/20260728-032134_keeh-and-kia.md
test -f counsel/date/20260728/20260728-032134_keeh-kia-sponsor.md
test -f "$PAGE"
grep -q 'Keeh' "$PAGE"
grep -q 'Aquarius' "$PAGE"
grep -q 'keeh.fund' "$PAGE"
grep -q 'Keaton Sealy Livermore' "$PAGE"
grep -q 'Kia' "$PAGE"
grep -q 'Craigslist' "$PAGE"
grep -q 'Facebook Marketplace' "$PAGE"
grep -q 'non-CVT\|not CVT' "$PAGE"
grep -q 'no live deploy' "$PAGE"
grep -q 'witness:keeh-open GREEN' "$PAGE"
test -f counsel/date/20260728/20260728-030310_the-keeh-season-quint-charter.md

name=Keeh
len=$(printf '%s' "$name" | wc -c)
test "$len" -eq 4

echo "seat: fund=Keeh order=11 sign_index=10 (Aquarius) vane=%keeh dns_prep=keeh.fund"
echo "executive: Keaton Sealy Livermore (unchanged from Ketu seat)"
echo "sponsor: Kia (South Korea) honor · design seat · not a paid buy"
echo "recommend: used 4-cyl hatch/SUV · non-CVT auto · light grey/beige cloth · Craigslist/FB Marketplace"
echo "season: Keeh Season quint · Kia sponsor seated 20260728.032134"
echo "page: edu/funds/keeh-opening.md"
echo "witness:keeh-open GREEN — seat · executive · Kia sponsor · used-mobility lean · hard lines · rename spine"
echo "refuse: deploy · wallet · gas · shred · breach"
echo "keeh_fund=prep"
echo "GREEN: gen-keeh — Aquarius seat 11 prep · Keeh rename · Kia sponsor · deploy RED"
