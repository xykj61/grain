#!/bin/sh
# living_docs_lint_scan.sh — body for living_docs_lint_scan.rish (seven duties).
# Missing Rishi verb: accumulate · filter chained · read bounded — harvest ledger (counsel 20260725.040247)
#
# Port of living_docs_lint_scan.py. Size and pattern duties lean on the run seam
# (wc -c · grep -nE) rather than in-pipeline line maps — Rish's map-transform
# ceiling refuses files past 256 lines; roster living docs are larger.
#
# Always exits 0 — ratchet advisory.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

LIVING_PIN_MAX_BYTES=24576
KEEPS="tools/fixtures/living_docs_lint_keeps.txt"
TMP=$(mktemp -d "${TMPDIR:-/tmp}/living-docs-scan.XXXXXX")
trap 'rm -rf "$TMP"' EXIT

ROSTER="$TMP/roster"
sh tools/fixtures/living_docs_lint_roster.sh >"$ROSTER"
roster_n=$(wc -l <"$ROSTER" | tr -d ' ')
if [ "$roster_n" -eq 0 ]; then
  echo "ADVISE living-docs lint — empty roster"
  exit 0
fi
echo "living-docs lint: roster ${roster_n} paths"

RETIRED='corpus|footgun|dead-peer|sanity check|empty plate|ungated diet|thin ring|product tip|suite tip|git tip|product_tip|suite_tip|git_tip'

kept_line() {
  rel=$1
  line_body=$2
  [ -f "$KEEPS" ] || return 1
  while IFS= read -r kline; do
    case "$kline" in ''|\#*) continue ;; esac
    kpath=${kline%%	*}
    kpat=${kline#*	}
    [ "$kpath" = "$rel" ] || continue
    if printf '%s\n' "$line_body" | grep -Eq "$kpat"; then
      return 0
    fi
  done <"$KEEPS"
  return 1
}

resolve_cand() {
  src=$1
  target=$2
  case "$target" in
    ''|http://*|https://*|mailto:*|\#*) return 1 ;;
  esac
  frag=${target%%#*}
  [ -n "$frag" ] || return 1
  case "$frag" in
    /*) raw="${ROOT}${frag}" ;;
    *) raw="$(CDPATH= cd -- "$(dirname "$src")" && pwd)/${frag}" ;;
  esac
  # Normalize .. and . so inbound keys match roster relpaths (Python Path.resolve).
  cand=$(realpath -m "$raw" 2>/dev/null || python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$raw")
  case "$cand" in
    "$ROOT"/*|"$ROOT") printf '%s' "$cand"; return 0 ;;
    *) return 1 ;;
  esac
}

# --- duty 1 ---
: >"$TMP/d1"
while IFS= read -r rel; do
  [ -n "$rel" ] && [ -f "$rel" ] || continue
  awk '/^```/ { fence = !fence; next } !fence { print NR ":" $0 }' "$rel" \
    | grep -Ei "\\b(${RETIRED})\\b" \
    | while IFS= read -r hit; do
        line_no=${hit%%:*}
        line_body=${hit#*:}
        if kept_line "$rel" "$line_body"; then
          continue
        fi
        snippet=$(printf '%s' "$line_body" | cut -c1-100)
        echo "ADVISE duty1 retired-word ${rel}:${line_no}: ${snippet}"
      done >>"$TMP/d1" || true
done <"$ROSTER"
if [ -s "$TMP/d1" ]; then
  cat "$TMP/d1"
  echo "ADVISE duty1 count=$(wc -l <"$TMP/d1" | tr -d ' ')"
else
  echo "OK   duty1 retired LEXICON words — none on roster"
fi

# --- duty 2 ---
: >"$TMP/d2"
while IFS= read -r rel; do
  [ -n "$rel" ] && [ -f "$rel" ] || continue
  grep -oE '\]\([^)]+\)' "$rel" 2>/dev/null | sed 's/^](//;s/)$//' | while IFS= read -r target; do
    cand=$(resolve_cand "$rel" "$target") || continue
    if [ ! -e "$cand" ]; then
      echo "ADVISE duty2 broken-link ${rel} -> ${target}"
    fi
  done >>"$TMP/d2" || true
done <"$ROSTER"
if [ -s "$TMP/d2" ]; then
  cat "$TMP/d2"
  echo "ADVISE duty2 count=$(wc -l <"$TMP/d2" | tr -d ' ')"
else
  echo "OK   duty2 relative links — roster clean"
fi

# --- duty 3 ---
: >"$TMP/hits"
{
  cat "$ROSTER"
  [ -f docs/README.md ] && echo docs/README.md
  [ -f ORGANIZING.md ] && echo ORGANIZING.md
} | sort -u >"$TMP/sources"
while IFS= read -r src; do
  [ -n "$src" ] && [ -f "$src" ] || continue
  grep -oE '\]\([^)]+\)' "$src" 2>/dev/null | sed 's/^](//;s/)$//' | while IFS= read -r target; do
    cand=$(resolve_cand "$src" "$target") || continue
    [ -e "$cand" ] || continue
    printf '%s\n' "$cand" | sed "s|^${ROOT}/||"
  done >>"$TMP/hits" || true
done <"$TMP/sources"
sort "$TMP/hits" | uniq -c >"$TMP/inbound"
: >"$TMP/d3"
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  [ "$rel" = "docs/README.md" ] && continue
  count=$(awk -v p="$rel" '$2 == p { print $1; found=1 } END { if (!found) print 0 }' "$TMP/inbound")
  if [ "$count" -eq 0 ]; then
    echo "ADVISE duty3 orphan ${rel} — no inbound link from roster or docs/README" >>"$TMP/d3"
  fi
done <"$ROSTER"
if [ -s "$TMP/d3" ]; then
  cat "$TMP/d3"
  echo "ADVISE duty3 count=$(wc -l <"$TMP/d3" | tr -d ' ')"
else
  echo "OK   duty3 orphans — none on roster"
fi

# --- duty 4 ---
: >"$TMP/d4"
while IFS= read -r rel; do
  [ -n "$rel" ] && [ -f "$rel" ] || continue
  status_lines=$(head -30 "$rel" | grep '^\*\*Status:\*\*' || true)
  if [ -z "$status_lines" ]; then
    echo "ADVISE duty4 status-missing ${rel}" >>"$TMP/d4"
    continue
  fi
  if ! printf '%s\n' "$status_lines" | grep -qiE 'checkable|vision|mixed|research for understanding|\bliving\b'; then
    first=$(printf '%s\n' "$status_lines" | head -1 | cut -c1-80)
    echo "ADVISE duty4 status-room ${rel}: ${first}" >>"$TMP/d4"
  fi
done <"$ROSTER"
if [ -s "$TMP/d4" ]; then
  cat "$TMP/d4"
  echo "ADVISE duty4 count=$(wc -l <"$TMP/d4" | tr -d ' ')"
else
  echo "OK   duty4 Status rooms — roster names Checkable or companion registers"
fi

# --- duty 5 ---
: >"$TMP/canon"
for rel in \
  context/PUBKEYS.md \
  tools/pond_exit_bron_master_seal.sh \
  context/keys/gpg_signing_06462132.pub.asc \
  active-designing/date/20260712/20260712-210800_pond-supersede-exit-criteria.md \
  active-designing/date/20260712/20260712-213600_pond-freeze-affirm-master-seal.md
do
  [ -f "$rel" ] && cat "$rel" >>"$TMP/canon"
done
: >"$TMP/d5"
if [ -d docs ]; then
  for p in docs/*.md; do
    [ -f "$p" ] || continue
    pins=$(grep -oE '\b[0-9a-f]{40}\b|\b[0-9a-f]{64}\b|\b[0-9A-F]{8}[0-9A-F]{24}\b' "$p" || true)
    [ -n "$pins" ] || continue
    printf '%s\n' "$pins" | while IFS= read -r pin; do
      [ -n "$pin" ] || continue
      if grep -Fq "$pin" "$TMP/canon"; then
        continue
      fi
      if grep -Fiq "$pin" "$TMP/canon"; then
        continue
      fi
      echo "ADVISE duty5 docs-pin ${p}: ${pin} not in canon"
    done >>"$TMP/d5" || true
  done
fi
if [ -s "$TMP/d5" ]; then
  sort -u "$TMP/d5"
  echo "ADVISE duty5 count=$(sort -u "$TMP/d5" | wc -l | tr -d ' ')"
else
  echo "OK   duty5 docs pins — none outside canon (or absent)"
fi

# --- duty 6 (wc -c) — past bound + near-bound fold advisory ---
# Near = 90% of living_pin_max_bytes. Remedy: fold closed season → seasons roster.
LIVING_PIN_NEAR_BYTES=$((LIVING_PIN_MAX_BYTES * 90 / 100))
: >"$TMP/d6"
: >"$TMP/d6near"
while IFS= read -r rel; do
  [ -n "$rel" ] && [ -f "$rel" ] || continue
  size=$(wc -c <"$rel" | tr -d ' ')
  if [ "$size" -gt "$LIVING_PIN_MAX_BYTES" ]; then
    echo "ADVISE duty6 living-pin-bytes ${rel}: ${size} > living_pin_max_bytes=${LIVING_PIN_MAX_BYTES}" >>"$TMP/d6"
  elif [ "$size" -ge "$LIVING_PIN_NEAR_BYTES" ]; then
    dir=$(dirname "$rel")
    roster="${dir}/SEASONS.md"
    if [ -f "$roster" ]; then
      echo "ADVISE duty6 living-pin-near ${rel}: ${size} ≥ 90% of ${LIVING_PIN_MAX_BYTES} — fold closed season into archive/; roster ${roster}" >>"$TMP/d6near"
    else
      echo "ADVISE duty6 living-pin-near ${rel}: ${size} ≥ 90% of ${LIVING_PIN_MAX_BYTES} — fold closed season; seat ${dir}/SEASONS.md (append-only-growth-law)" >>"$TMP/d6near"
    fi
  fi
done <"$ROSTER"
if [ -s "$TMP/d6" ]; then
  cat "$TMP/d6"
  echo "ADVISE duty6 count=$(wc -l <"$TMP/d6" | tr -d ' ')"
elif [ -s "$TMP/d6near" ]; then
  cat "$TMP/d6near"
  echo "ADVISE duty6 near-count=$(wc -l <"$TMP/d6near" | tr -d ' ') — fold remedy named; never blocking"
else
  echo "OK   duty6 living pin bytes — all roster paths ≤ ${LIVING_PIN_MAX_BYTES} (near threshold ${LIVING_PIN_NEAR_BYTES})"
fi

# --- duty 7 ---
py_list=$(find tools -name '*.py' -type f 2>/dev/null | sort || true)
py_n=$(printf '%s\n' "$py_list" | sed '/^$/d' | wc -l | tr -d ' ')
if [ "$py_n" -eq 0 ]; then
  echo "OK   duty7 tools/*.py count — zero (target met)"
elif [ "$py_n" -le 2 ]; then
  names=$(printf '%s\n' "$py_list" | sed '/^$/d' | awk 'NR>1{printf ", "}{printf "%s",$0} END{print ""}')
  echo "ADVISE duty7 tools/*.py count=${py_n} (target zero; migrate-on-touch): ${names}"
else
  names=$(printf '%s\n' "$py_list" | sed '/^$/d' | awk 'NR>1{printf ", "}{printf "%s",$0} END{print ""}')
  echo "ADVISE duty7 tools/*.py count=${py_n} above target two: ${names}"
fi

# --- duty 8 — shell bodies (>40 lines) beneath .rish wrappers (harvest ratchet) ---
# Count .sh files invoked from tools/**/*.rish that themselves exceed 40 lines.
# Genuine exemptions (bootstrap · external interpreters · interactive stdin) stay .sh by design
# and are not wrapper bodies. Ratchet should only fall as Rishi earns the missing verbs.
: >"$TMP/d8"
SHELL_BODY_LINE_FLOOR=40
find tools -name '*.rish' -type f 2>/dev/null | while IFS= read -r rish; do
  # Extract quoted .sh paths from run / sh invocations
  grep -Eo '"[^"]+\.sh"' "$rish" 2>/dev/null | tr -d '"' || true
done | sort -u >"$TMP/d8_candidates"
while IFS= read -r shpath; do
  [ -n "$shpath" ] && [ -f "$shpath" ] || continue
  # Skip permanent entry-point exemptions by path name
  case "$shpath" in
    rye/bootstrap.sh|tools/cursor-jail.sh|tools/cursor-jail-macos.sh|tools/fetch_gratitude_web.sh|*slc1_accept.sh|*slc1_version_step2.sh|*cast_a_chart*) continue ;;
  esac
  n=$(wc -l <"$shpath" | tr -d ' ')
  if [ "$n" -gt "$SHELL_BODY_LINE_FLOOR" ]; then
    echo "$n	$shpath" >>"$TMP/d8"
  fi
done <"$TMP/d8_candidates"
if [ -s "$TMP/d8" ]; then
  d8_n=$(wc -l <"$TMP/d8" | tr -d ' ')
  echo "ADVISE duty8 shell-body-under-rish count=${d8_n} (lines>${SHELL_BODY_LINE_FLOOR}; harvest ratchet — only falls)"
  sort -n "$TMP/d8" | awk -F'	' '{printf "ADVISE duty8 shell-body %s (%s lines)\n", $2, $1}'
else
  echo "OK   duty8 shell-body-under-rish count — zero above ${SHELL_BODY_LINE_FLOOR} lines"
fi

echo "ADVISE: living-docs lint complete — ratchet advisory; link-breaks may earn a gate once the shelf proves stable"
exit 0
