#!/bin/sh
# one_clock_provenance_scan.sh -- duty 4: stamp not ahead of live host clock.
#
# Monotonicity can never catch a forward jump -- every zone we might drift into
# runs ahead of ours. Only a comparison against the live clock can.
#
# ONE_CLOCK_PROVENANCE_TOLERANCE_SECONDS (default 900): fifteen minutes covers
# witness runtime, commit, and push without forbidding honest same-minute stamps.
set -eu

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

TOLERANCE=${ONE_CLOCK_PROVENANCE_TOLERANCE_SECONDS:-900}
ZONE=${ONE_CLOCK_CANONICAL_ZONE:-America/New_York}

host_dot=$(TZ="$ZONE" date +%Y%m%d.%H%M%S)
host_epoch=$(TZ="$ZONE" date +%s)

# The parse itself lives in tools/fixtures/s/shell_portable.sh, because this body stood byte for byte
# in two scans and `date -d` is a GNU extension BSD spells `-j -f` -- one rule two files could come
# to disagree about, in the one place where disagreeing means calling every stamp unparsable.
stamp_to_epoch() {
  TZ="$ZONE" stamp_epoch "$1"
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
BASE=${ONE_CLOCK_PROVENANCE_BASE:-debrided/main}
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
    # [_.] rather than _: the sprig is OPTIONAL, and 237 dated files carry a
    # stamp and none, so an underscore-anchored read calls every one of them
    # undated and weighs none of them (the REDS %175 shape, found here on
    # 20260911.020039 while repairing the same blindness in duty 5's population).
    stamp=$(printf '%s' "$base" | sed -n 's/^\([0-9]\{8\}\)-\([0-9]\{6\}\)[_.].*$/\1.\2/p')
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
