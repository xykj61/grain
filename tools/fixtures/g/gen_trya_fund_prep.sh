#!/bin/sh
# gen_trya_fund_prep.sh -- Trya fund prep grow (Virgo earth - seat 6)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"
PAGE=docs-geode/edu/yonder/funds/trya-opening.md

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain|shred|breach)
    echo "gen-trya REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

grep -q 'Trya (fund)' context/LEXICON.md
grep -q 'trya.fund' context/LEXICON.md
grep -q 'Virgo' context/LEXICON.md
grep -q '%trya' context/LEXICON.md
grep -q 'Ariana Grande' context/LEXICON.md
test -f context/TRYA.md
test -f context/CIVIC_STYLE.md
test -f "$PAGE"
grep -q 'Trya' "$PAGE"
grep -q 'Virgo' "$PAGE"
grep -q 'trya.fund' "$PAGE"
grep -q 'Ariana Grande' "$PAGE"
grep -q 'no live deploy' "$PAGE"
grep -q 'witness:trya-open GREEN' "$PAGE"
test -f gratitude/ariana-grande.md
test -f foundations/yonder/20260728-024417_trya-and-ariana-grande.md

name=Trya
len=$(printf '%s' "$name" | wc -c)
test "$len" -eq 4
printf '%s' "$name" | grep -Eq '^[A-Za-z]{4}$'

echo "seat: fund=Trya order=6 sign_index=5 (Virgo) vane=%trya dns_prep=trya.fund"
echo "dedication: Ariana Grande (honor)"
echo "voice: Trya sixth OS variant · nested craft voice (Quin stands)"
echo "page: docs-geode/edu/yonder/funds/trya-opening.md (prep grow · page one)"
echo "witness:trya-open GREEN — seat · dedication · hard lines"
echo "refuse: deploy · wallet · gas · claim-domain · shred · breach"
echo "trya_fund=prep"
echo "GREEN: gen-trya — Virgo earth seat 6 prep open · dedication seated · deploy RED"
