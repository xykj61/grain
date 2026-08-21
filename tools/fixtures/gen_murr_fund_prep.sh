#!/bin/sh
# gen_murr_fund_prep.sh — Murr / MUR fund prep (Aries · was Mala / MALA)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"
PAGE=edu/funds/murr-opening.md

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain|shred|breach|yes|now)
    echo "gen-murr REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

grep -q 'Murr (fund)' context/LEXICON.md
grep -q 'murr.fund' context/LEXICON.md
grep -q '%murr' context/LEXICON.md
grep -q 'MUR' context/LEXICON.md
grep -q 'Kyler Murray' context/LEXICON.md
grep -q 'Keaton Sealy Livermore' context/LEXICON.md
grep -q 'innermost' context/LEXICON.md
grep -q 'Mala (fund) (retired name)' context/LEXICON.md
grep -q 'MALA (retired name)' context/LEXICON.md
grep -q 'Bozo (fund)' context/LEXICON.md
test -f context/CIVIC_STYLE.md
test -f "$PAGE"
grep -q 'Murr' "$PAGE"
grep -q 'MUR' "$PAGE"
grep -q 'Kyler Murray' "$PAGE"
grep -q 'Keaton Sealy Livermore' "$PAGE"
grep -q 'no live deploy' "$PAGE"
grep -q 'witness:murr-open GREEN' "$PAGE"
grep -q 'roadmap last' "$PAGE"
test -f gratitude/kyler-murray.md
test -f gratitude/mur-movement-aesthetics.md
test -f foundations/yonder/20260728-025220_murr-and-kyler-murray.md
test -f counsel/date/20260728/20260728-025220_the-mur-season-innermost-charter.md
test -f counsel/date/20260730/20260730-150702_pole-bozo-djinn-murr-keaton.md

name=Murr
len=$(printf '%s' "$name" | wc -c)
test "$len" -eq 4

echo "seat: fund=Murr order=1 sign_index=0 (Aries) vane=%murr dns_prep=murr.fund"
echo "module: MUR (was MALA) · L1 currency lean"
echo "dedication: Kyler Murray (honor) · Minnesota Vikings QB as of 2026 public reporting"
echo "executive: Keaton Sealy Livermore (from DJINN · POLE 20260730.150702)"
echo "season: MUR Season innermost u0-u127 · massive rename approved as waves"
echo "wov: unify into MUR · retire WOV roadmap last"
echo "page: edu/funds/murr-opening.md"
echo "witness:murr-open GREEN — seat · dedication · hard lines · rename spine"
echo "refuse: deploy · wallet · gas · shred · breach"
echo "murr_fund=prep"
echo "GREEN: gen-murr — Aries seat 1 prep · MUR rename spine · deploy RED"
