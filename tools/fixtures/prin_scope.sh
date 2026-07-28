#!/usr/bin/env bash
# prin_scope.sh — print seated outer/inner/innermost/core/quint season scope
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
  core:   Gren Chapter — PAUSED at g0 (Djin→Gren waits while quint walks)
  quint:  Keeh Chapter — OPEN · rounds q0–q15 lean (expand 32)
  fund1:  Murr (was Mala) · Aries · dedication Kyler Murray · executive DJINN
  fund2:  Gren (was Djin · was Twah) · Taurus · executive Grain Energy PBC President (Keaton lean)
  fund3:  Siya · Gemini · executor Sara Sealy Livermore
  fund4:  Eyva · Cancer · executive + dedication Avanti (she/her)
  fund5:  Gwoh · Leo · dedicated to Sarah Guo / Conviction (honor)
  fund6:  Trya · Virgo · dedicated to Ariana Grande (honor) · trya_fund=prep
  fund11: Keeh (was Ketu) · Aquarius · seat 11 · executive Keaton
  L1:     MUR (was MALA) · WOV unify · retire WOV roadmap last
  voice:  six variants — Reya · Riyo · Trey · Triz · Quin · Trya (Quin stands)
  charter: counsel/20260728-030310_the-keeh-season-quint-charter.md
  seat:   counsel/20260728-030310_the-keeh-season-quint-charter.md
  warn:   q14/q15 extend 32 or return Gren g0
EOF
