#!/bin/sh
# fascia_metric_v0.sh — fascia metric (i4–i8).
#
# Four clutter signals → difficulty-style fascia grade 0–100.
# Higher fascia = more knit; clutter lowers the grade.
# i5: softer weights · window mean · self-path excludes.
# i6: Amphora laps 1–3 stack named; weights unchanged (window stays like-to-like).
# i7: Class A honest-anchor excludes (trial) · fall-visibility baseline = window_min.
# i8: Class A HOLD disclosed (e104) — exclusion hides; holding discloses.
#     window_min baseline kept. A signal that cannot be honestly zeroed is held.
# u74: glow lower emit-string parseInt excluded from ratchet (not app sites).
set -eu
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$ROOT"

verb="${1:-}"
case "$verb" in
  shred|breach|deploy|wallet|gas|yes|now)
    echo "fascia-metric-v0 REFUSE: verb '${verb}' — measure only; no shred · no breach · no deploy" >&2
    exit 1
    ;;
esac

metric_rev=i8

# Self-path excludes — the meter must not grade its own Inner Scope seats.
EXCLUDE_SELF='!**/fascia_metric*'
EXCLUDE_I45='!**/inner-scope-i[4-9]*'
EXCLUDE_I4STAMP='!**/20260728-023240*'
EXCLUDE_I5STAMP='!**/20260728-023555*'
EXCLUDE_I6STAMP='!**/20260728-023941*'

# --- signal 1: superseded mentions (living design paths) ---
superseded="$(rg -n --no-heading '\b[Ss]uperseded\b' \
  counsel active-designing expanding-prompts work-in-progress context \
  --glob '!**/quin-workshop/**' \
  --glob '!**/archive/**' \
  --glob '!**/yonder/**' \
  --glob '!**/session-logs/**' \
  --glob "$EXCLUDE_SELF" \
  --glob "$EXCLUDE_I45" \
  --glob "$EXCLUDE_I4STAMP" \
  --glob "$EXCLUDE_I5STAMP" \
  --glob "$EXCLUDE_I6STAMP" 2>/dev/null | wc -l | tr -d ' ')"
superseded="${superseded:-0}"

# --- signal 2: outstanding ratchet advisories (nonzero cheap categories) ---
ROSTER="mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke rye/src"
ROSTER_GLOW="glow/tokens.rye glow/lower_named_cast.rye glow/lower_shape.rye glow/lower_bartis.rye glow/lower_barket.rye"
tools_py="$(find tools -name '*.py' -type f ! -path 'tools/.cache/*' ! -path 'tools/.build/*' 2>/dev/null | wc -l | tr -d ' ')"
tools_py="${tools_py:-0}"
memcpy_app="$(rg -n --no-heading '@memcpy\(' $ROSTER $ROSTER_GLOW \
  --glob '*.rye' 2>/dev/null | wc -l | tr -d ' ')"
memcpy_app="${memcpy_app:-0}"
if [ "$memcpy_app" -gt 0 ] && rg -q '@memcpy\(' tally/copy.rye 2>/dev/null; then
  memcpy_app=$((memcpy_app - 1))
fi
[ "$memcpy_app" -lt 0 ] && memcpy_app=0
camel="$(rg -n --no-heading '^( *)?(pub )?fn [a-z]+[A-Z]' $ROSTER $ROSTER_GLOW \
  --glob '*.rye' 2>/dev/null | wc -l | tr -d ' ')"
camel="${camel:-0}"
parseint="$(rg -n --no-heading 'parseInt\(' $ROSTER $ROSTER_GLOW \
  --glob '*.rye' 2>/dev/null | wc -l | tr -d ' ')"
parseint="${parseint:-0}"
# Prefer application-site lean: drop canonical home when present.
if [ -f tally/parse_int.rye ]; then
  parseint_canon="$(rg -n --no-heading 'parseInt\(' tally/parse_int.rye 2>/dev/null | wc -l | tr -d ' ')"
  parseint_canon="${parseint_canon:-0}"
  parseint=$((parseint - parseint_canon))
  [ "$parseint" -lt 0 ] && parseint=0
fi
# Glow lower emit strings print Zig source containing parseInt — not app call
# sites (door named u72; exclusion seated u74). Matches advise roster lean.
parseint_emit="$(rg -n --no-heading 'parseInt\(' \
  glow/lower_bartis.rye glow/lower_barket.rye 2>/dev/null | wc -l | tr -d ' ')"
parseint_emit="${parseint_emit:-0}"
parseint=$((parseint - parseint_emit))
[ "$parseint" -lt 0 ] && parseint=0

ratchet_out=0
[ "$tools_py" -gt 0 ] && ratchet_out=$((ratchet_out + 1))
[ "$memcpy_app" -gt 0 ] && ratchet_out=$((ratchet_out + 1))
[ "$camel" -gt 0 ] && ratchet_out=$((ratchet_out + 1))
[ "$parseint" -gt 0 ] && ratchet_out=$((ratchet_out + 1))

# --- signal 3: target-class A hits (Seva Fund lineage · held disclosed) ---
# yonder excluded (f2 · 20260730.093112) — same relocate kit as superseded
# i8: count the hits; name the honest anchors; do NOT exclude them into silence.
class_a="$(rg -n --no-heading 'Seva Fund|%seva|seva\.fund' \
  --glob '!**/quin-workshop/**' \
  --glob '!**/archive/**' \
  --glob '!**/yonder/**' \
  --glob '!**/session-logs/**' \
  --glob '!**/20260728-011055_the-fascia-season-charter.md' \
  --glob "$EXCLUDE_SELF" \
  --glob "$EXCLUDE_I45" \
  --glob "!**/20260728-023240*" \
  --glob "!**/20260728-023555*" \
  --glob "!**/20260728-023941*" \
  --glob "$EXCLUDE_I4STAMP" \
  --glob "$EXCLUDE_I5STAMP" \
  --glob "$EXCLUDE_I6STAMP" 2>/dev/null | wc -l | tr -d ' ')"
class_a="${class_a:-0}"
class_a_held="$(rg -n --no-heading 'Seva Fund|%seva|seva\.fund' \
  context/LEXICON.md \
  counsel/20260727-152801_the-siya-turn.md \
  mycelium/constellation/SPEC.md \
  2>/dev/null | wc -l | tr -d ' ')"
class_a_held="${class_a_held:-0}"

# --- signal 4: over-70-line functions (authored .rye roster) ---
over70=0
if [ -x tools/fixtures/tame_style_long_fn_roster.sh ] && [ -x tools/fixtures/tame_style_long_fn_one.sh ]; then
  over70="$(
    sh tools/fixtures/tame_style_long_fn_roster.sh 2>/dev/null | while IFS= read -r f; do
      [ -n "$f" ] || continue
      sh tools/fixtures/tame_style_long_fn_one.sh "$f"
    done | wc -l | tr -d ' '
  )"
  over70="${over70:-0}"
fi

# --- i5 softer weights (each signal still caps at 25) ---
# superseded: half-weight so prose history does not slam the ceiling alone
pen_super=$(( (superseded + 1) / 2 ))
[ "$pen_super" -gt 25 ] && pen_super=25
# ratchet: 4 pts per outstanding category (was 5)
pen_ratchet=$((ratchet_out * 4))
[ "$pen_ratchet" -gt 25 ] && pen_ratchet=25
# class A: 2 pts per hit (was 3)
pen_target=$((class_a * 2))
[ "$pen_target" -gt 25 ] && pen_target=25
# over-70: 1 pt per fn (was 2)
pen_over70=$over70
[ "$pen_over70" -gt 25 ] && pen_over70=25

clutter=$((pen_super + pen_ratchet + pen_target + pen_over70))
[ "$clutter" -gt 100 ] && clutter=100
fascia=$((100 - clutter))

# --- Amphora stack bits (folds proven in .rish; shell names presence) ---
amphora_ready=no
amphora_stack=missing
if [ -f tools/amphora_lap1.rish ] && [ -f tools/amphora_lap2.rish ] && [ -f tools/amphora_lap3.rish ] && [ -d amphora ]; then
  amphora_ready=yes
  amphora_stack=laps1-3
fi

# --- Moving window: fall-visibility baseline = window_min (i7+, kept in i8) ---
mkdir -p tools/.cache
window_file=tools/.cache/fascia_metric_v0_window.tsv
# Rebaseline once — archive rows that lack an i8+ metric_rev (pre-hold-disclosed).
if [ -f "$window_file" ] && [ -s "$window_file" ]; then
  if ! awk -F'\t' 'NF >= 8 && $8 ~ /^i([8-9]|[1-9][0-9]+)$/ { found = 1 } END { exit !found }' "$window_file"; then
    mv "$window_file" "${window_file}.pre_i8"
    echo "window: rebaseline=i8+ (archived pre-hold-disclosed readings)" >&2
  fi
fi
stamp="$(TZ=America/New_York date '+%Y%m%d.%H%M%S' 2>/dev/null || date '+%Y%m%d.%H%M%S')"
window_n=0
window_mean=none
window_min=none
window_max=none
baseline=none
baseline_delta=n/a
prior_mean=none
delta_vs_mean=n/a
if [ -f "$window_file" ] && [ -s "$window_file" ]; then
  stats="$(awk -F'\t' '
    NF >= 2 && $2 ~ /^[0-9]+$/ {
      n++; s += $2
      if (n == 1 || $2 < mn) mn = $2
      if (n == 1 || $2 > mx) mx = $2
    }
    END {
      if (n < 1) { print "0 none none none"; exit }
      printf "%d %d %d %d\n", n, int(s / n), mn, mx
    }
  ' "$window_file")"
  window_n="$(echo "$stats" | awk '{print $1}')"
  window_mean="$(echo "$stats" | awk '{print $2}')"
  window_min="$(echo "$stats" | awk '{print $3}')"
  window_max="$(echo "$stats" | awk '{print $4}')"
  # i7: prior_baseline is window_min so a fall stays visible until answered.
  if [ "$window_n" -gt 0 ] && [ "$window_min" != "none" ]; then
    baseline="$window_min"
    if [ "$fascia" -ge "$baseline" ]; then
      baseline_delta="+$((fascia - baseline))"
    else
      baseline_delta="-$((baseline - fascia))"
    fi
  fi
  if [ "$window_n" -gt 0 ] && [ "$window_mean" != "none" ]; then
    prior_mean="$window_mean"
    if [ "$fascia" -ge "$prior_mean" ]; then
      delta_vs_mean="+$((fascia - prior_mean))"
    else
      delta_vs_mean="-$((prior_mean - fascia))"
    fi
  fi
fi

printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  "$stamp" "$fascia" "$superseded" "$ratchet_out" "$class_a" "$over70" "$clutter" "$metric_rev" \
  >>"$window_file"
tmp="$(mktemp)"
tail -n 8 "$window_file" >"$tmp" && mv "$tmp" "$window_file"

echo "fascia-metric-v0: Language EN — connective-tissue grade (difficulty-style)."
echo "fascia-metric-v0: Style Radiant — measure clutter; refuse shred."
echo "fascia-metric-v0: Lens TAME — Amphora path; no breach from this tool."
echo "metric_rev=${metric_rev}"
echo "signal:superseded=${superseded} penalty=${pen_super} weight=half"
echo "signal:ratchet_outstanding=${ratchet_out} (py=${tools_py} memcpy_app=${memcpy_app} camel=${camel} parseint=${parseint}) penalty=${pen_ratchet} weight=4"
echo "signal:target_class_a=${class_a} penalty=${pen_target} weight=2"
echo "signal:class_a_held_disclosed=${class_a_held} law=hold_not_exclude paths=LEXICON+siya-turn+constellation-SPEC"
echo "signal:over70=${over70} penalty=${pen_over70} weight=1"
echo "clutter=${clutter}"
echo "fascia=${fascia}"
echo "window_size=8 window_n=${window_n} window_mean=${window_mean} window_min=${window_min} window_max=${window_max}"
echo "prior_baseline=${baseline} delta=${baseline_delta} baseline_kind=window_min"
echo "prior_mean=${prior_mean} delta_vs_mean=${delta_vs_mean}"
echo "amphora_ready=${amphora_ready}"
echo "amphora_stack=${amphora_stack}"
echo "refuse: shred · breach · deploy · wallet · gas (measure only)"
echo "GREEN: fascia-metric-v0 — grade ${fascia}/100 · four signals · ${metric_rev} · amphora_stack=${amphora_stack} · no shred"
