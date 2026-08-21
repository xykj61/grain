#!/bin/sh
# fascia_metric_v0.sh — fascia metric (i4–i9).
#
# Four clutter signals → difficulty-style fascia grade 0–100.
# Higher fascia = more knit; clutter lowers the grade.
# i5: softer weights · window mean · self-path excludes.
# i6: Amphora laps 1–3 stack named; weights unchanged (window stays like-to-like).
# i7: Class A honest-anchor excludes (trial) · fall-visibility baseline = window_min.
# i8: Class A HOLD disclosed (e104) — exclusion hides; holding discloses.
# i9: window carry across revisions — never clear history on a rev bump;
#     seed the equinox arc 100/85/92 so the −15 fall stays visible.
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

metric_rev=i9

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
  counsel/date/20260727/20260727-152801_the-siya-turn.md \
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

# --- The Amphora presence bits were removed `20260821.180613`, closing REDS %112 ---
# They printed `amphora_ready=yes` while testing only that three FILES existed, so the line said
# "ready" and measured "present" -- a claim strictly weaker than its own name, and wrong on this
# pier, where lap 2 cannot run at all for want of `openssl`. They were never a fascia signal
# either: nothing downstream read them, and connective-tissue health does not depend on one
# module's stack. Amphora is proven by the eight `tools/amphora_*_witness.rish` rungs, which is
# where a claim about Amphora belongs.

# --- Moving window: fall-visibility baseline = window_min (i7+) ---
# i9 carry law: a metric revision carries its window forward, marked by
# metric_rev. Never archive-away the living window on a rev bump.
mkdir -p tools/.cache
window_file=tools/.cache/fascia_metric_v0_window.tsv
window_carry=honored
window_seeded=0
# Seed missing arc extremes (85 fall · 100 peak · 92 hold) without wiping history.
# stamp · fascia · superseded · ratchet · class_a · over70 · clutter · metric_rev
seed_tmp="$(mktemp)"
: >"$seed_tmp"
has85=0
has100=0
has92seed=0
if [ -f "$window_file" ] && [ -s "$window_file" ]; then
  awk -F'\t' 'NF >= 2 && $2 == 85 { found = 1 } END { exit !found }' "$window_file" 2>/dev/null && has85=1 || true
  awk -F'\t' 'NF >= 2 && $2 == 100 { found = 1 } END { exit !found }' "$window_file" 2>/dev/null && has100=1 || true
  awk -F'\t' 'NF >= 8 && $2 == 92 && $8 ~ /_seed$/ { found = 1 } END { exit !found }' "$window_file" 2>/dev/null && has92seed=1 || true
fi
if [ "$has85" -eq 0 ]; then
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "20260731.133943" "85" "5" "1" "4" "0" "15" "i6_seed" >>"$seed_tmp"
  window_seeded=1
fi
if [ "$has100" -eq 0 ]; then
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "20260731.135015" "100" "0" "0" "0" "0" "0" "i7_seed" >>"$seed_tmp"
  window_seeded=1
fi
if [ "$has92seed" -eq 0 ] && [ "$has85" -eq 0 ] && [ "$has100" -eq 0 ]; then
  # First hydration only — avoid duplicating 92 once the arc is present.
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "20260731.135742" "92" "0" "0" "4" "0" "8" "i8_seed" >>"$seed_tmp"
  window_seeded=1
fi
if [ "$window_seeded" -eq 1 ]; then
  if [ -f "$window_file" ] && [ -s "$window_file" ]; then
    cat "$window_file" >>"$seed_tmp"
  fi
  mv "$seed_tmp" "$window_file"
  echo "window: carry=seed_arc_100_85_92 (remembered fall -15 restored)" >&2
else
  rm -f "$seed_tmp"
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
  # i7+: prior_baseline is window_min so a fall stays visible until answered.
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
# Keep last 8, pinning remembered arc extremes (85 fall · 100 peak) when present.
awk -F'\t' '
  { rows[NR] = $0; n = NR }
  END {
    start = n - 7; if (start < 1) start = 1
    has85 = 0; has100 = 0
    for (i = start; i <= n; i++) {
      split(rows[i], a, "\t")
      if (a[2] == "85") has85 = 1
      if (a[2] == "100") has100 = 1
    }
    pin85 = ""; pin100 = ""
    if (!has85) {
      for (i = 1; i < start; i++) {
        split(rows[i], a, "\t")
        if (a[2] == "85") { pin85 = rows[i]; break }
      }
    }
    if (!has100) {
      for (i = 1; i < start; i++) {
        split(rows[i], a, "\t")
        if (a[2] == "100") { pin100 = rows[i]; break }
      }
    }
    pins = 0
    if (pin85 != "") { print pin85; pins++ }
    if (pin100 != "") { print pin100; pins++ }
    keep = 8 - pins
    if (keep < 1) keep = 1
    start2 = n - keep + 1; if (start2 < 1) start2 = 1
    for (i = start2; i <= n; i++) print rows[i]
  }
' "$window_file" >"$tmp" && mv "$tmp" "$window_file"

echo "fascia-metric-v0: Language EN — connective-tissue grade (difficulty-style)."
echo "fascia-metric-v0: Style Radiant — measure clutter; refuse shred."
echo "fascia-metric-v0: Lens TAME -- measure only; no breach from this tool, and no gate on any other module."
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
echo "window_carry=${window_carry} window_seeded=${window_seeded} window_arc_seed=100,85,92 window_arc_fall=-15"
echo "refuse: shred · breach · deploy · wallet · gas (measure only)"
echo "GREEN: fascia-metric-v0 -- grade ${fascia}/100 - four signals - ${metric_rev} - no shred"
