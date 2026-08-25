#!/bin/sh
# sundial.sh -- recursion-prompt confidence meter (0-100) with color bands.
#
# Checks living checkpoints against the Keeh (or SUNDIAL_PROMPT) recursion
# printout -- a few rounds back of seated truth vs what the prompt still says.
# High = green (prompt matches living seats); low = red (prompt drifted).
#
#   sh tools/fixtures/sundial.sh
#   sh tools/fixtures/sundial.sh shred   # RED refuse
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

verb="${1:-}"
case "$verb" in
  shred|breach|deploy|wallet|gas|yes|now|extend|return)
    echo "sundial REFUSE: verb '${verb}' — measure only; no shred · no deploy · no extend word" >&2
    exit 1
    ;;
esac

PROMPT="${SUNDIAL_PROMPT:-expanding-prompts/yonder/20260728-030310_keeh-season-q0-recursion-prompt.md}"
test -f "$PROMPT"

pass=0
total=0
misses=""

ok() {
  total=$((total + 1))
  pass=$((pass + 1))
  printf 'OK   %s\n' "$1"
}

miss() {
  total=$((total + 1))
  misses="${misses}
MISS $1"
  printf 'MISS %s\n' "$1"
}

# Living door (tree) -- always required for a healthy pier
if test -f counsel/date/20260728/20260728-030310_the-keeh-season-quint-charter.md; then
  ok "live: Keeh quint charter"
else
  miss "live: Keeh quint charter"
fi
if test -f tools/g/gen_keeh_fund_prep.rish; then ok "live: gen_keeh"; else miss "live: gen_keeh"; fi
if test -f tools/g/gen_shyu_fund_prep.rish; then ok "live: gen_shyu"; else miss "live: gen_shyu"; fi
if test -f tools/g/gen_linn_fund_prep.rish; then ok "live: gen_linn"; else miss "live: gen_linn"; fi
if test -f gratitude/kia.md; then ok "live: Kia gratitude"; else miss "live: Kia gratitude"; fi
if test -f gratitude/hyundai.md; then ok "live: Hyundai gratitude"; else miss "live: Hyundai gratitude"; fi
if test -f gratitude/helen-atthowe.md; then ok "live: Helen Atthowe gratitude"; else miss "live: Helen Atthowe gratitude"; fi
if test -f docs-geode/README.md; then ok "live: docs-geode root"; else miss "live: docs-geode root"; fi

# Prompt content -- recent-round checkpoints the printout must still carry
if grep -Eq 'outer.*paused|OUTER SCOPE \(paused' "$PROMPT"; then ok "prompt: outer paused"; else miss "prompt: outer paused"; fi
if grep -Eq 'i6 complete / i7 next|inner=paused\(i6/i7\)' "$PROMPT"; then ok "prompt: inner i6/i7"; else miss "prompt: inner i6/i7"; fi
if grep -Eq 'innermost.*u0|MUR Season held at u0|innermost=paused\(u0\)' "$PROMPT"; then ok "prompt: innermost u0"; else miss "prompt: innermost u0"; fi
if grep -Eq 'core.*g0|Gren Season held at g0|core=paused\(g0\)' "$PROMPT"; then ok "prompt: core g0"; else miss "prompt: core g0"; fi
if grep -Eq 'keeh_sponsor=Kia|Honor sponsor: Kia|Kia \(South Korea\)' "$PROMPT"; then ok "prompt: Keeh→Kia"; else miss "prompt: Keeh→Kia"; fi
if grep -Eq 'non-CVT|nonCVT|non_CVT' "$PROMPT"; then ok "prompt: used-mobility lean"; else miss "prompt: used-mobility lean"; fi
if grep -Eq 'Wayne_Hsiung|Wayne Hsiung|shyu_dedication=Wayne' "$PROMPT"; then ok "prompt: Shyu→Wayne"; else miss "prompt: Shyu→Wayne"; fi
if grep -Eq 'Hyundai|shyu_sponsor=Hyundai' "$PROMPT"; then ok "prompt: Shyu→Hyundai"; else miss "prompt: Shyu→Hyundai"; fi
if grep -Eq 'Linn|%linn|linn_fund' "$PROMPT"; then ok "prompt: Linn Capricorn"; else miss "prompt: Linn Capricorn"; fi
if grep -Eq 'Helen_Atthowe|Helen Atthowe|linn_dedication=Helen' "$PROMPT"; then ok "prompt: Linn→Helen"; else miss "prompt: Linn→Helen"; fi
if grep -Eq 'lean-16 CLOSED|lean16_closed|q0–q15 complete|q15 complete|handed back|return_gren_g0' "$PROMPT"; then ok "prompt: lean-16 closed/handback"; else miss "prompt: lean-16 closed/handback"; fi
if grep -Eq 'extend_or_return=' "$PROMPT"; then ok "prompt: extend_or_return slot"; else miss "prompt: extend_or_return slot"; fi
if grep -Eq 'year=wave|wave.*year' "$PROMPT"; then ok "prompt: year=wave"; else miss "prompt: year=wave"; fi
if grep -Eq 'crush=compile|crush.*compile' "$PROMPT"; then ok "prompt: crush=compile"; else miss "prompt: crush=compile"; fi
if grep -Eq 'docs-geode|geode=prep' "$PROMPT"; then ok "prompt: docs-geode/geode"; else miss "prompt: docs-geode/geode"; fi
if grep -Eq 'sundial' "$PROMPT"; then ok "prompt: sundial shortcut"; else miss "prompt: sundial shortcut"; fi
if grep -Eq 'gen_shyu' "$PROMPT"; then ok "prompt: gen_shyu named"; else miss "prompt: gen_shyu named"; fi
if grep -Eq 'gen_linn' "$PROMPT"; then ok "prompt: gen_linn named"; else miss "prompt: gen_linn named"; fi

if [ "$total" -eq 0 ]; then
  echo "sundial REFUSE: zero checks" >&2
  exit 1
fi

score=$((pass * 100 / total))
diff=$((total - pass))

# Bands: low red - orange nearer red - yellow nearer green - high green
band=red
if [ "$score" -ge 75 ]; then
  band=green
elif [ "$score" -ge 50 ]; then
  band=yellow
elif [ "$score" -ge 25 ]; then
  band=orange
else
  band=red
fi

echo "---"
echo "sundial: prompt=$PROMPT"
echo "sundial: pass=$pass total=$total miss=$diff"
echo "sundial=$score"
echo "band=$band"
echo "witness:sundial GREEN — measured · band named · refuse-walk separate"
echo "GREEN: sundial — confidence percent $score · band $band · deploy/shred RED by refuse"
