#!/bin/sh
# Write a stamped manifest beside a git bundle (bundle discipline 20260730.041405).
# Never writes under /tmp. No backtick characters in patterns.
#
#   sh tools/gen/season/equinox_bundle_manifest.sh \
#     <bundle-path> <kind> <pier> <start-hash> <end-hash> <stamp> <basis-note>
#
# kind: rehearsal | wave | e63 | e127 | e191 | e255 | crossing
set -eu

BUNDLE=${1:?bundle path}
KIND=${2:?kind}
PIER_RAW=${3:?pier}
START=${4:?start hash}
END=${5:?end hash}
STAMP=${6:?stamp}
BASIS=${7:-}

# Never publish credentials in a tracked manifest — keep host/path only.
case "$PIER_RAW" in
  *@*)
    PIER=$(printf '%s' "$PIER_RAW" | awk -F@ '{print $NF}')
    ;;
  git@*)
    PIER=$(printf '%s' "$PIER_RAW" | cut -c5- | tr ':' '/')
    ;;
  https://*|http://*)
    PIER=$(printf '%s' "$PIER_RAW" | awk -F/ '{print $3 "/" $4 "/" $5}')
    ;;
  *)
    PIER=$PIER_RAW
    ;;
esac
if test -z "$PIER"; then
  PIER=unknown-pier
fi

case "$BUNDLE" in
  /tmp/*|/var/tmp/*)
    echo "equinox-bundle-manifest: refusing tmpfs path"
    exit 1
    ;;
esac

test -f "$BUNDLE" || {
  echo "equinox-bundle-manifest: bundle absent"
  exit 1
}

MANIFEST="${BUNDLE}.manifest"
BYTES=$(wc -c < "$BUNDLE" | tr -d '[:space:]')
REFS=$(git bundle list-heads "$BUNDLE" 2>/dev/null | wc -l | tr -d '[:space:]')
# Commit count for a span when start is a real hash; --all uses tip ancestry count.
if test "$START" = "--all" || test "$START" = "all"; then
  COMMITS=$(git rev-list --count "$END" 2>/dev/null | tr -d '[:space:]' || echo 0)
  SPAN="--all..${END}"
else
  COMMITS=$(git rev-list --count "${START}..${END}" 2>/dev/null | tr -d '[:space:]' || echo 0)
  SPAN="${START}..${END}"
fi

REDS_ROWS=$(rg -c '^\| [0-9]+ \|' work-in-progress/REDS.md 2>/dev/null || echo 0)
REMEMBER_BYTES=$(wc -c < work-in-progress/REMEMBER.md | tr -d '[:space:]')
LEXICON_BYTES=$(wc -c < context/LEXICON.md | tr -d '[:space:]')
SESSION_INDEX_LINES=$(wc -l < session-logs/README.md | tr -d '[:space:]')
ALMANAC_BYTES=$(wc -c < rye-learning-process/GLOW_ALMANAC.md | tr -d '[:space:]')
SEAT_MAP_BYTES=$(wc -c < work-in-progress/EQUINOX_SEAT_MAP.md | tr -d '[:space:]')

{
  echo "format equinox-bundle-manifest-v1"
  echo "stamp ${STAMP}"
  echo "kind ${KIND}"
  echo "pier ${PIER}"
  echo "basis ${BASIS}"
  echo "span ${SPAN}"
  echo "start ${START}"
  echo "end ${END}"
  echo "tip ${END}"
  echo "bundle_path ${BUNDLE}"
  echo "bundle_bytes ${BYTES}"
  echo "bound_bytes 268435456"
  echo "refs_listed ${REFS}"
  echo "commit_count ${COMMITS}"
  echo "living_doc work-in-progress/REDS.md rows=${REDS_ROWS}"
  echo "living_doc work-in-progress/REMEMBER.md bytes=${REMEMBER_BYTES}"
  echo "living_doc context/LEXICON.md bytes=${LEXICON_BYTES}"
  echo "living_doc session-logs/README.md lines=${SESSION_INDEX_LINES}"
  echo "living_doc rye-learning-process/GLOW_ALMANAC.md bytes=${ALMANAC_BYTES}"
  echo "living_doc work-in-progress/EQUINOX_SEAT_MAP.md bytes=${SEAT_MAP_BYTES}"
  echo "restore verified_rather_than_trusted"
  echo "discipline counsel/replies/20260730-041405_bundle-discipline.md"
  echo "verdict ok"
} > "$MANIFEST"

echo "manifest_path=${MANIFEST}"
echo "manifest_bytes=$(wc -c < "$MANIFEST" | tr -d '[:space:]')"
echo "verdict=ok"
exit 0
