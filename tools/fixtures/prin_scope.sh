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
  innermost: MUR Chapter — OPEN · u52 complete / u53 next (seva/glow choir GREEN · rename overwrite)
  core:   Gren Chapter — CLOSED · handed back · lean-16 complete
  fund_triad: Murr · Gren · Siya (living)
  quint:  Keeh Chapter — CLOSED · handed back
  extend_or_return: return_mur_u0 (seated 20260728.043220) · prior Keeh return_gren_g0
  keeh_sponsor: Kia (South Korea) honor · design seat
  keeh_recommend: used 4-cyl hatch/SUV · non-CVT auto · light grey/beige cloth · CL/FB Marketplace
  shyu_sponsor: Hyundai (South Korea) honor · design seat
  shyu_recommend: used 4-cyl hatch/SUV · non-CVT auto · light grey/beige cloth · CL/FB Marketplace (same as Keeh)
  geode:  Geode Chapter — PREP · d0 next (docs-geode · crush=compile · wave=year)
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
  fund7:  Shyu · Libra · dedication Wayne Hsiung · sponsor Hyundai · shyu_fund=prep
  fund10: Linn · Capricorn · earth · dedication Helen Atthowe · linn_fund=prep
  fund11: Keeh (was Ketu) · Aquarius · seat 11 · executive Keaton · Kia sponsor
  sundial: prin sundial · tools/sundial.rish — recursion confidence 0–100 (red→green)
  L1:     MUR (was MALA) · WOV unify · retire WOV roadmap last
  voice:  six variants — Reya · Riyo · Trey · Triz · Quin · Trya (Quin stands)
  charter: counsel/20260728-025220_the-mur-season-innermost-charter.md
  geode_charter: counsel/20260728-031722_the-geode-season-charter.md
  seat:   counsel/20260728-055351_mur-season-u52-seva-glow-cluster-choir.md
  warn:   u126/u127 extend innermost · return inner i7 · or other · d14/d15 extend 32|64|128 or handback
EOF
