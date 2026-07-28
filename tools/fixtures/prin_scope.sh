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
  outer:  Constellation Season — PAUSED at m8 complete / m9 next
  inner:  Inner Scope Season — PAUSED at i6 complete / i7 next (fascia)
  innermost: MUR Season — PAUSED at u0 (Mala/MALA→Murr/MUR waits)
  core:   Gren Season — PAUSED at g0 (Djin→Gren waits while quint walks)
  quint:  Keeh Season — OPEN · q10 complete / q11 next (lean 16 · expand 32) · spot-check empty×3
  keeh_sponsor: Kia (South Korea) honor · design seat
  keeh_recommend: used 4-cyl hatch/SUV · non-CVT auto · light grey/beige cloth · CL/FB Marketplace
  geode:  Geode Season — PREP · d0 next (docs-geode · crush=compile · wave=year)
  year:   collection of seasons · all scopes (≠ civil calendar)
  wave:   fascial synonym of year
  crush:  compile (MUR · Tally · weave → docs-geode)
  docs-geode: root prod crystal (ship) · docs/ = compress (distinct)
  fund1:  Murr (was Mala) · Aries · dedication Kyler Murray · executive DJINN
  fund2:  Gren (was Djin · was Twah) · Taurus · executive Grain Energy PBC President (Keaton lean)
  fund3:  Siya · Gemini · executor Sara Sealy Livermore
  fund4:  Eyva · Cancer · executive + dedication Avanti (she/her)
  fund5:  Gwoh · Leo · dedicated to Sarah Guo / Conviction (honor)
  fund6:  Trya · Virgo · dedicated to Ariana Grande (honor) · trya_fund=prep
  fund7:  Shyu · Libra · dedicated to Wayne Hsiung (honor) · shyu_fund=prep
  fund11: Keeh (was Ketu) · Aquarius · seat 11 · executive Keaton · Kia sponsor
  L1:     MUR (was MALA) · WOV unify · retire WOV roadmap last
  voice:  six variants — Reya · Riyo · Trey · Triz · Quin · Trya (Quin stands)
  charter: counsel/20260728-030310_the-keeh-season-quint-charter.md
  geode_charter: counsel/20260728-031722_the-geode-season-charter.md
  seat:   counsel/20260728-030310_the-keeh-season-quint-charter.md
  warn:   q14/q15 extend 32 or return Gren g0 · d14/d15 extend 32|64|128 or handback
EOF
