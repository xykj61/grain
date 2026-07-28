#!/usr/bin/env bash
# prin_scope.sh — print seated outer/inner/innermost/core season scope
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
nib="$(git rev-parse --short=10 HEAD 2>/dev/null || echo unknown)"

cat <<EOF
Prin scope — seasons · Tally · rish vocabulary
  nib:    $nib
  scope:  named bound of work (season · Tally garden · Prin/rish view)
  outer:  Constellation Chapter — PAUSED at m8 complete / m9 next
  inner:  Inner Scope Chapter — PAUSED at i6 complete / i7 next (fascia)
  innermost: MUR Chapter — PAUSED at u0 (Mala/MALA→Murr/MUR waits)
  core:   Gren Chapter — OPEN · rounds g0–g15 lean (expand 32|64)
  fund1:  Murr (was Mala) · Aries · dedication Kyler Murray · executive DJINN
  fund2:  Gren (was Djin · was Twah) · Taurus · executive Grain Energy PBC President (Keaton lean)
  fund3:  Siya · Gemini · executor Sara Sealy Livermore
  fund4:  Eyva · Cancer · executive + dedication Avanti (she/her)
  fund5:  Gwoh · Leo · dedicated to Sarah Guo / Conviction (honor)
  fund6:  Trya · Virgo · dedicated to Ariana Grande (honor) · trya_fund=prep
  fund11: Ketu · Aquarius · seat 11 · executive Keaton
  L1:     MUR (was MALA) · WOV unify · retire WOV roadmap last
  voice:  six variants — Reya · Riyo · Trey · Triz · Quin · Trya (Quin stands)
  charter: counsel/20260728-025634_the-gren-season-core-charter.md
  seat:   counsel/20260728-025634_the-gren-season-core-charter.md
  warn:   g14/g15 extend 32|64 or return MUR u0
EOF
