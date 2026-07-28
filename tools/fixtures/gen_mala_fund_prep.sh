#!/bin/sh
# gen_mala_fund_prep.sh — POSIX helper for tools/gen_mala_fund_prep.rish
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"

case "$verb" in
  deploy|mainnet|wallet|gas)
    echo "gen-mala REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

test -d comlink && test -f comlink/beading.rye
test -f mycelium/constellation/SPEC.md
test -f mycelium/constellation/sui/sources/constellation.move
grep -q 'mints nothing' mycelium/constellation/SPEC.md
grep -q 'mints nothing' mycelium/constellation/sui/sources/constellation.move
grep -q 'Mala (fund)' context/LEXICON.md
grep -q 'mala.fund' context/LEXICON.md
test -f active-designing/20260702-031312_modules-aspects-and-mailable-money.md
grep -q 'MALA' active-designing/20260702-031312_modules-aspects-and-mailable-money.md
test -f tools/prin.rish
test -f tools/fixtures/prin_dispatch.sh

echo "seat: fund=Mala order=1 sign_index=0 (Aries) vane=%mala dns_prep=mala.fund"
echo "kinship: MALA module = mailable money; Mala fund = Aries fire seat 1 — distinct hats"
echo "path: prin rish generator → Comlink (present) → constellation phone book (registry-only)"
echo "flags: mala.fund claim = Keaton's hand · no deploy · no wallet · no gas"
echo "GREEN: gen-mala — Mala fund prep stub; Comlink door open; phone book mints nothing."
