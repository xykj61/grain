#!/bin/sh
# gen_shyu_fund_prep.sh — Shyu fund prep (Libra · Wayne dedication · Hyundai sponsor)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"
PAGE=edu/funds/shyu-opening.md

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain|shred|breach|yes|now)
    echo "gen-shyu REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

grep -q 'Shyu (fund)' context/LEXICON.md
grep -q 'shyu.fund' context/LEXICON.md
grep -q '%shyu' context/LEXICON.md
grep -q 'Libra' context/LEXICON.md
grep -q 'Wayne Hsiung' context/LEXICON.md
grep -q 'Hyundai' context/LEXICON.md
grep -q 'Honor sponsor' context/LEXICON.md
grep -q 'Craigslist' context/LEXICON.md
grep -q 'non-CVT' context/LEXICON.md
grep -q 'fund sponsor' context/LEXICON.md
test -f context/CIVIC_STYLE.md
test -f gratitude/hyundai.md
test -f gratitude/wayne-hsiung.md
test -f foundations/yonder/20260728-033820_shyu-and-hyundai.md
test -f counsel/date/20260728/20260728-033820_shyu-hyundai-sponsor.md
test -f "$PAGE"
grep -q 'Shyu' "$PAGE"
grep -q 'Libra' "$PAGE"
grep -q 'shyu.fund' "$PAGE"
grep -q 'Wayne Hsiung' "$PAGE"
grep -q 'Hyundai' "$PAGE"
grep -q 'Craigslist' "$PAGE"
grep -q 'Facebook Marketplace' "$PAGE"
grep -q 'not CVT\|non-CVT' "$PAGE"
grep -q 'no live deploy' "$PAGE"
grep -q 'witness:shyu-open GREEN' "$PAGE"

name=Shyu
len=$(printf '%s' "$name" | wc -c)
test "$len" -eq 4

echo "seat: fund=Shyu order=7 sign_index=6 (Libra) vane=%shyu dns_prep=shyu.fund"
echo "dedication: Wayne Hsiung (honor · held)"
echo "sponsor: Hyundai (South Korea) honor · design seat · not a paid buy"
echo "recommend: used 4-cyl hatch/SUV · non-CVT auto · light grey/beige cloth · Craigslist/FB Marketplace"
echo "sibling: Keeh→Kia same filters · distinct chairs"
echo "page: edu/funds/shyu-opening.md"
echo "witness:shyu-open GREEN — seat · Wayne · Hyundai sponsor · used-mobility lean · hard lines"
echo "refuse: deploy · wallet · gas · shred · breach"
echo "shyu_fund=prep"
echo "GREEN: gen-shyu — Libra seat 7 prep · Wayne dedication · Hyundai sponsor · deploy RED"
