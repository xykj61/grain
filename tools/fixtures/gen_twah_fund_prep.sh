#!/bin/sh
# gen_twah_fund_prep.sh — POSIX helper for tools/gen_twah_fund_prep.rish (m5+)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain)
    echo "gen-twah REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

# --- m5 doors: seat · phone book · Comlink · edu page one stub ---
test -d comlink && test -f comlink/beading.rye
test -f mycelium/constellation/SPEC.md
test -f mycelium/constellation/sui/sources/constellation.move
grep -q 'mints nothing' mycelium/constellation/SPEC.md
grep -q 'mints nothing' mycelium/constellation/sui/sources/constellation.move
grep -q 'Twah (fund)' context/LEXICON.md
grep -q 'twah.fund' context/LEXICON.md
grep -q 'Taurus' context/LEXICON.md
test -f tools/prin.rish
test -f tools/fixtures/prin_dispatch.sh
test -f edu/funds/twah-creating-one-of-twelve.md
grep -q 'Twah' edu/funds/twah-creating-one-of-twelve.md
grep -q 'four-letter' edu/funds/twah-creating-one-of-twelve.md
grep -q 'twah.fund' edu/funds/twah-creating-one-of-twelve.md
grep -q 'no live deploy' edu/funds/twah-creating-one-of-twelve.md

echo "seat: fund=Twah order=2 sign_index=1 (Taurus) vane=%twah dns_prep=twah.fund"
echo "gift: edu-series tutorial for creating one of the twelve — under the fund seat"
echo "page: edu/funds/twah-creating-one-of-twelve.md (page one stub · m5)"
echo "path: prin → Comlink → constellation phone book (registry-only)"
echo "flags: twah.fund claim = Keaton's hand · no deploy · no wallet · no gas"
echo "GREEN: gen-twah — Twah prep; Comlink door; edu page one stub present; deploy RED by name."
