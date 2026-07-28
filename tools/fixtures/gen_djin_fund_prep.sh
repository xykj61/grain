#!/bin/sh
# gen_djin_fund_prep.sh — POSIX helper for tools/gen_djin_fund_prep.rish (m5–m8 (rename-forward Djin))
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"
PAGE=edu/funds/djin-creating-one-of-twelve.md
SPEC=mycelium/constellation/SPEC.md
MOVE=mycelium/constellation/sui/sources/constellation.move

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy|claim-domain)
    echo "gen-djin REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

# --- m5 doors: seat · phone book · Comlink · edu page ---
test -d comlink && test -f comlink/beading.rye
test -f "$SPEC"
test -f "$MOVE"
grep -q 'mints nothing' "$SPEC"
grep -q 'mints nothing' "$MOVE"
grep -q 'Djin (fund)' context/LEXICON.md
grep -q 'djin.fund' context/LEXICON.md
grep -q 'Taurus' context/LEXICON.md
test -f tools/prin.rish
test -f tools/fixtures/prin_dispatch.sh
test -f "$PAGE"
grep -q 'Djin' "$PAGE"
grep -q 'four-letter' "$PAGE"
grep -q 'djin.fund' "$PAGE"
grep -q 'no live deploy' "$PAGE"
test -f context/CIVIC_STYLE.md

# --- m6: witness steps 1–3 ---
name=Djin
len=$(printf '%s' "$name" | wc -c)
test "$len" -eq 4
printf '%s' "$name" | grep -Eq '^[A-Za-z]{4}$'
grep -q 'Civic Style' "$PAGE"
grep -q 'witness:step1' "$PAGE"
grep -q '\.fund' "$PAGE"
grep -q "Keaton's hand alone" "$PAGE"
grep -q 'witness:step2' "$PAGE"
grep -q 'Sign index' "$PAGE"
grep -q 'Taurus' "$PAGE"
grep -q 'witness:step3' "$PAGE"
grep -q '| \*\*1\*\* |' "$PAGE"

# --- m7: witness steps 4–5 ---
grep -q 'witness:step4' "$PAGE"
grep -q 'phone book' "$PAGE"
grep -q 'mints nothing' "$PAGE"
grep -q 'registry' "$PAGE"
grep -q 'add_seat' "$PAGE"
grep -q 'AdminCap' "$PAGE"
grep -q 'witness:step5' "$PAGE"
grep -q 'Knock Comlink' "$PAGE" || grep -q 'knock Comlink' "$PAGE"
grep -q 'beading.rye' "$PAGE"
grep -q 'prin → Comlink' "$PAGE"
grep -q 'not sent' "$PAGE"
test -f comlink/beading.rye

# --- m8: witness step 6 + arc close ---
grep -q 'witness:step6' "$PAGE"
grep -q 'refuse-walk' "$PAGE"
grep -q 'REFUSE' "$PAGE"
grep -q 'Djin m5–m8 CLOSED' "$PAGE"
grep -q 'multisig-live' "$PAGE"
grep -q 'claim-domain' "$PAGE"

echo "seat: fund=Djin order=2 sign_index=1 (Taurus) vane=%djin dns_prep=djin.fund"
echo "gift: edu-series tutorial for creating one of the twelve — under the fund seat"
echo "page: edu/funds/djin-creating-one-of-twelve.md (steps 1–6 taught · m8 close)"
echo "witness:step1 GREEN — four-letter Djin + Civic Style"
echo "witness:step2 GREEN — .fund anchor · claim Keaton's hand alone"
echo "witness:step3 GREEN — Taurus · fund-order 2 · sign_index 1"
echo "witness:step4 GREEN — phone book · mints nothing · registry-only"
echo "witness:step5 GREEN — Comlink knock · beading · no seating byte"
echo "witness:step6 GREEN — refuse-walk taught · deploy RED proven in post-fold"
echo "arc: Djin m5–m8 CLOSED at refuse-walk"
echo "path: prin → Comlink → constellation phone book (registry-only)"
echo "flags: djin.fund claim = Keaton's hand · no deploy · no wallet · no gas"
echo "GREEN: gen-djin — Djin prep complete; steps 1–6 witnessed; deploy RED by name."
