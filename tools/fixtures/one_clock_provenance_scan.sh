#!/bin/sh
# one_clock_provenance_scan.sh -- duty 4: stamp not ahead of live host clock.
#
# Monotonicity can never catch a forward jump -- every zone we might drift into
# runs ahead of ours. Only a comparison against the live clock can.
#
# ONE_CLOCK_PROVENANCE_TOLERANCE_SECONDS (default 900): fifteen minutes covers
# witness runtime, commit, and push without forbidding honest same-minute stamps.
set -eu

TOLERANCE=${ONE_CLOCK_PROVENANCE_TOLERANCE_SECONDS:-900}
ZONE=${ONE_CLOCK_CANONICAL_ZONE:-America/New_York}

host_dot=$(TZ="$ZONE" date +%Y%m%d.%H%M%S)
host_epoch=$(TZ="$ZONE" date +%s)

stamp_to_epoch() {
  dot=$1
  ymd=${dot%%.*}
  hms=${dot#*.}
  yyyy=${ymd%????}
  mm=${ymd#????}; mm=${mm%??}
  dd=${ymd#??????}
  hh=${hms%????}
  mi=${hms#??}; mi=${mi%??}
  ss=${hms#????}
  TZ="$ZONE" date -d "${yyyy}-${mm}-${dd} ${hh}:${mi}:${ss}" +%s 2>/dev/null || return 1
}

check_stamp() {
  stamp=$1
  label=$2
  st_epoch=$(stamp_to_epoch "$stamp") || {
    echo "PROV_BAD ${label} unparsable stamp ${stamp}"
    return 1
  }
  delta=$((st_epoch - host_epoch))
  if [ "$delta" -gt "$TOLERANCE" ]; then
    echo "PROV_BAD ${label} stamp ${stamp} is ${delta}s ahead of host ${host_dot} (tolerance ${TOLERANCE}s)"
    return 1
  fi
  echo "PROV_OK ${label} stamp ${stamp} within ${TOLERANCE}s of host ${host_dot} (delta ${delta}s)"
  return 0
}

bad=0

# Explicit stamp list for fixture tests: ONE_CLOCK_PROVENANCE_STAMPS='20260725.120701'
if [ -n "${ONE_CLOCK_PROVENANCE_STAMPS:-}" ]; then
  n=0
  while IFS= read -r s; do
    test -n "$s" || continue
    n=$((n + 1))
    check_stamp "$s" "explicit-$n" || bad=$((bad + 1))
  done <<EOF
$(printf '%s\n' "$ONE_CLOCK_PROVENANCE_STAMPS")
EOF
fi

# New or renamed dated artifacts vs base (working tree + index; two-dot diff)
BASE=${ONE_CLOCK_PROVENANCE_BASE:-origin/main}
if git rev-parse --verify "$BASE" >/dev/null 2>&1; then
  diff_tmp=$(mktemp)
  git diff --name-status "$BASE" 2>/dev/null >"$diff_tmp" || true
  while IFS= read -r line; do
    path=""
    case "$line" in
    A*) path=$(printf '%s' "$line" | awk '{print $2}') ;;
    R*) path=$(printf '%s' "$line" | sed -n 's/^R[0-9]*[[:space:]]\+[^[:space:]]\+[[:space:]]\+\(.*\)$/\1/p') ;;
    esac
    test -n "$path" || continue
    test -f "$path" || continue
    base=$(basename "$path")
    stamp=$(printf '%s' "$base" | sed -n 's/^\([0-9]\{8\}\)-\([0-9]\{6\}\)_.*$/\1.\2/p')
    test -n "$stamp" || continue
    check_stamp "$stamp" "$path" || bad=$((bad + 1))
  done <"$diff_tmp"
  rm -f "$diff_tmp"
fi

if [ "$bad" -ne 0 ]; then
  echo "PROV_FAIL count=$bad host=${host_dot} tolerance=${TOLERANCE}s"
  exit 1
fi

echo "PROV_OK host=${host_dot} tolerance=${TOLERANCE}s zone=${ZONE}"
