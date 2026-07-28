#!/bin/sh
# fascia_metric_v0.sh — Inner Scope i4: fascia metric v0 (measure only; no shred).
#
# Four clutter signals → difficulty-style fascia grade 0–100.
# Higher fascia = more knit; clutter lowers the grade.
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

# --- signal 1: superseded mentions (living design paths; pairs ripe for prune care) ---
superseded="$(rg -n --no-heading '\b[Ss]uperseded\b' \
  counsel active-designing expanding-prompts work-in-progress context \
  --glob '!**/quin-workshop/**' \
  --glob '!**/archive/**' \
  --glob '!**/yonder/**' \
  --glob '!**/session-logs/**' 2>/dev/null | wc -l | tr -d ' ')"
superseded="${superseded:-0}"

# --- signal 2: outstanding ratchet advisories (nonzero cheap categories) ---
# Roster matches tame_style_scan_advise / long_fn (not whole glow/).
ROSTER="mantra caravan linengrow comlink rishi/src tally aurora pond brushstroke rye/src"
ROSTER_GLOW="glow/tokens.rye glow/lower_named_cast.rye glow/lower_shape.rye glow/lower_bartis.rye glow/lower_barket.rye"
tools_py="$(find tools -name '*.py' -type f ! -path 'tools/.cache/*' ! -path 'tools/.build/*' 2>/dev/null | wc -l | tr -d ' ')"
tools_py="${tools_py:-0}"
memcpy_app="$(rg -n --no-heading '@memcpy\(' $ROSTER $ROSTER_GLOW \
  --glob '*.rye' 2>/dev/null | wc -l | tr -d ' ')"
memcpy_app="${memcpy_app:-0}"
# subtract 1 intentional canonical in tally/copy.rye when present
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
if [ "$parseint" -gt 0 ] && rg -q 'parseInt\(' tally/parse_int.rye 2>/dev/null; then
  parseint=$((parseint - 1))
fi
[ "$parseint" -lt 0 ] && parseint=0

ratchet_out=0
[ "$tools_py" -gt 0 ] && ratchet_out=$((ratchet_out + 1))
[ "$memcpy_app" -gt 0 ] && ratchet_out=$((ratchet_out + 1))
[ "$camel" -gt 0 ] && ratchet_out=$((ratchet_out + 1))
[ "$parseint" -gt 0 ] && ratchet_out=$((ratchet_out + 1))

# --- signal 3: target-class A hits (Seva Fund lineage residual) ---
# Meta census in the Fascia charter is excluded — it documents the classes.
class_a="$(rg -n --no-heading 'Seva Fund|%seva|seva\.fund' \
  --glob '!**/quin-workshop/**' \
  --glob '!**/archive/**' \
  --glob '!**/session-logs/**' \
  --glob '!**/20260728-011055_the-fascia-season-charter.md' \
  --glob '!**/fascia_metric_v0*' 2>/dev/null | wc -l | tr -d ' ')"
class_a="${class_a:-0}"

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

# --- normalize penalties (each signal caps at 25) → fascia = 100 - clutter ---
pen_super=$superseded
[ "$pen_super" -gt 25 ] && pen_super=25
pen_ratchet=$((ratchet_out * 5))
[ "$pen_ratchet" -gt 25 ] && pen_ratchet=25
pen_target=$((class_a * 3))
[ "$pen_target" -gt 25 ] && pen_target=25
pen_over70=$((over70 * 2))
[ "$pen_over70" -gt 25 ] && pen_over70=25

clutter=$((pen_super + pen_ratchet + pen_target + pen_over70))
[ "$clutter" -gt 100 ] && clutter=100
fascia=$((100 - clutter))

# Moving window v0: single prior reading in tools/.cache (gitignored).
mkdir -p tools/.cache
window_file=tools/.cache/fascia_metric_v0_window.tsv
stamp="$(TZ=America/New_York date '+%Y%m%d.%H%M%S' 2>/dev/null || date '+%Y%m%d.%H%M%S')"
baseline="none"
baseline_delta="n/a"
if [ -f "$window_file" ]; then
  baseline="$(tail -n 1 "$window_file" | cut -f2)"
  case "$baseline" in
    ''|none) baseline_delta="n/a" ;;
    *)
      if [ "$fascia" -ge "$baseline" ] 2>/dev/null; then
        baseline_delta="+$((fascia - baseline))"
      else
        baseline_delta="-$((baseline - fascia))"
      fi
      ;;
  esac
fi
printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
  "$stamp" "$fascia" "$superseded" "$ratchet_out" "$class_a" "$over70" "$clutter" \
  >>"$window_file"
# keep last 8 readings (v0 window size named below)
tmp="$(mktemp)"
tail -n 8 "$window_file" >"$tmp" && mv "$tmp" "$window_file"

echo "fascia-metric-v0: Language EN — connective-tissue grade (difficulty-style)."
echo "fascia-metric-v0: Style Radiant — measure clutter; refuse shred."
echo "fascia-metric-v0: Lens TAME — Amphora path; no breach from this tool."
echo "signal:superseded=${superseded} penalty=${pen_super}"
echo "signal:ratchet_outstanding=${ratchet_out} (py=${tools_py} memcpy_app=${memcpy_app} camel=${camel} parseint=${parseint}) penalty=${pen_ratchet}"
echo "signal:target_class_a=${class_a} penalty=${pen_target}"
echo "signal:over70=${over70} penalty=${pen_over70}"
echo "clutter=${clutter}"
echo "fascia=${fascia}"
echo "window_size=8 prior_baseline=${baseline} delta=${baseline_delta}"
echo "refuse: shred · breach · deploy · wallet · gas (measure only)"
echo "GREEN: fascia-metric-v0 — grade ${fascia}/100 · four signals · no shred"
