#!/bin/sh
# gen_twah_fund_prep.sh — POSIX helper for tools/gen_twah_fund_prep.rish (m5–m6+)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"
PAGE=edu/funds/twah-creating-one-of-twelve.md

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain)
    echo "gen-twah REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

# --- m5 doors: seat · phone book · Comlink · edu page ---
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
test -f "$PAGE"
grep -q 'Twah' "$PAGE"
grep -q 'four-letter' "$PAGE"
grep -q 'twah.fund' "$PAGE"
grep -q 'no live deploy' "$PAGE"
test -f context/CIVIC_STYLE.md

# --- m6: witness steps 1–3 ---
# step 1 — four-letter name + Civic Style
name=Twah
len=$(printf '%s' "$name" | wc -c)
test "$len" -eq 4
printf '%s' "$name" | grep -Eq '^[A-Za-z]{4}$'
grep -q 'Civic Style' "$PAGE"
grep -q 'witness:step1' "$PAGE"
# step 2 — .fund anchor · claim his
grep -q '\.fund' "$PAGE"
grep -q "Keaton's hand alone" "$PAGE"
grep -q 'witness:step2' "$PAGE"
# step 3 — tropical seat Taurus index 1 order 2
grep -q 'Sign index' "$PAGE"
grep -q 'Taurus' "$PAGE"
grep -q 'witness:step3' "$PAGE"
grep -q '| \*\*1\*\* |' "$PAGE"

echo "seat: fund=Twah order=2 sign_index=1 (Taurus) vane=%twah dns_prep=twah.fund"
echo "gift: edu-series tutorial for creating one of the twelve — under the fund seat"
echo "page: edu/funds/twah-creating-one-of-twelve.md (steps 1–3 taught · m6)"
echo "witness:step1 GREEN — four-letter Twah + Civic Style"
echo "witness:step2 GREEN — .fund anchor · claim Keaton's hand alone"
echo "witness:step3 GREEN — Taurus · fund-order 2 · sign_index 1"
echo "path: prin → Comlink → constellation phone book (registry-only)"
echo "flags: twah.fund claim = Keaton's hand · no deploy · no wallet · no gas"
echo "GREEN: gen-twah — Twah prep; steps 1–3 witnessed; deploy RED by name."
