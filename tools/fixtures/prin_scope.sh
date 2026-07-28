#!/usr/bin/env bash
# prin_scope.sh — print seated outer/inner/innermost season scope for Prin / Tally vocabulary
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
  innermost: MUR Chapter — OPEN · rounds u0–u127 (Mala/MALA→Murr/MUR)
  fund1:  Murr (was Mala) · Aries · dedicated to Kyler Murray (honor) · murr_fund=prep
  fund2:  Djin (was Twah) · Taurus · executive DJINN
  fund3:  Siya · Gemini · executor Sara Sealy Livermore
  fund4:  Eyva · Cancer · executive + dedication Avanti (she/her)
  fund5:  Gwoh · Leo · dedicated to Sarah Guo / Conviction (honor)
  fund6:  Trya · Virgo · dedicated to Ariana Grande (honor) · trya_fund=prep
  fund11: Ketu · Aquarius · seat 11 · executive Keaton
  L1:     MUR (was MALA) · WOV unify · retire WOV roadmap last
  voice:  six variants — Reya · Riyo · Trey · Triz · Quin · Trya (Quin stands)
  charter: counsel/20260728-025220_the-mur-season-innermost-charter.md
  seat:   counsel/20260728-025220_the-mur-season-innermost-charter.md
  warn:   u126/u127 handback · i14/i15 extend-or-return when inner resumes
EOF
