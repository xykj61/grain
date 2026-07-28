#!/usr/bin/env bash
# prin_scope.sh — print seated outer/inner season scope for Prin / Tally vocabulary
set -euo pipefail
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"
nib="$(git rev-parse --short=10 HEAD 2>/dev/null || echo unknown)"

cat <<EOF
Prin scope — seasons · Tally · rish vocabulary
  nib:    $nib
  scope:  named bound of work (season · Tally garden · Prin/rish view)
  outer:  Constellation Season — PAUSED at m8 complete / m9 next
  inner:  Inner Scope Season — OPEN · rounds i0–i15 (fascia redaction shredding · Djin)
  fund1:  Mala · Aries · dedicated to Kamala Harris (honor)
  fund2:  Djin (was Twah) · Taurus · executive DJINN
  fund3:  Siya · Gemini · executor Sara Sealy Livermore
  fund4:  Eyva · Cancer · executive + dedication Avanti (she/her)
  fund5:  Gwoh · Leo · dedicated to Sarah Guo / Conviction (honor)
  fund11: Ketu · Aquarius · seat 11 · executive Keaton
  charter: counsel/20260728-015541_the-inner-scope-season-charter.md
  seat:   counsel/20260728-021508_eyva-avanti-dedication.md
  warn:   i14 and i15 must ask — extend 16 · extend 32 · or return outer m9
EOF
