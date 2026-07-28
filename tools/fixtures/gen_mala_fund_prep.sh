#!/bin/sh
# gen_mala_fund_prep.sh — POSIX helper for tools/gen_mala_fund_prep.rish (m1–m4)
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
verb="${1:-}"

case "$verb" in
  deploy|mainnet|wallet|gas|multisig-live|aurora-deploy)
    echo "gen-mala REFUSE: ${verb} is Keaton's hand alone — never this generator" >&2
    exit 1
    ;;
esac

# --- m1 doors ---
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

# --- m2 Amphora door ---
test -d amphora
test -f amphora/README.md
test -f amphora/vessel_core.rye
test -f tools/amphora_lap1.rish
grep -q 'vessel' amphora/README.md

# --- m3 Glow door + maintainer / multisig-plan seats ---
test -d glow
test -f glow/gen/cast-u32.glow
test -f tools/glow_run.rish
grep -q 'Official maintainer of MALA' context/LEXICON.md
grep -q 'n-of-12 multisig (plan)' context/LEXICON.md
grep -q 'led by Mala' context/LEXICON.md

# --- m4 Aurora / AppImage host lane (Framework AMD x86_64) ---
test -d aurora
test -f aurora/README.md
test -f tools/launch-cursor.rish
grep -q 'Framework' tools/launch-cursor.rish
test -f context/specs/enclosure-editors.md
grep -q 'Framework' context/specs/enclosure-editors.md
grep -q 'AppImage' context/specs/enclosure-editors.md
test -x Cursor-3.13.10-x86_64.AppImage
arch="$(uname -m)"
test "$arch" = "x86_64"

echo "seat: fund=Mala order=1 sign_index=0 (Aries) vane=%mala dns_prep=mala.fund"
echo "duty: Mala fund = official maintainer of MALA module (by design) — distinct hats"
echo "plan: constellation of 12 deploy via n-of-12 multisig led by Mala — PLAN only"
echo "kinship: MALA module = mailable money; Mala fund = Aries fire seat 1 + maintainer"
echo "path: prin → Comlink → Amphora → Glow stdlib → Aurora host lane → constellation phone book"
echo "host: Framework AMD x86_64 · AppImage enclosure (Cursor-3.13.10) · launch-cursor.rish · BIOS/firmware metal floor"
echo "honest: Aurora seed (RISC-V freestanding) cannot yet carry constellation/Sui deploy — refuse aurora-deploy"
echo "flags: mala.fund claim = Keaton's hand · no deploy · no live multisig · no wallet · no gas"
echo "arc: Mala m1–m4 CLOSED at Aurora/AppImage readiness stub"
echo "GREEN: gen-mala — Mala prep complete; stack through Aurora host lane; deploy/aurora-deploy RED by name."
