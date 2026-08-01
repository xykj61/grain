#!/bin/sh
# Equinox bundle send — cut · verify · stamped manifest (shell; no rishi required).
# Crossing MODE — not an almanac seat. Never writes under /tmp.
#
#   sh tools/gen/season/equinox_bundle_send.sh rehearsal
#   sh tools/gen/season/equinox_bundle_send.sh rehearsal --span HEAD~20..HEAD
#   sh tools/gen/season/equinox_bundle_send.sh closing e255
#   sh tools/gen/season/equinox_bundle_send.sh wave q64
#   sh tools/gen/season/equinox_bundle_send.sh prove-red
#
# Law: cut home-side, verify, write stamped manifest beside the bundle.
# Law: kg does not open shred · geode · seat 128 — this is a crossing mode only.
# Law (e141): closing's four rounds stay verbatim; wave carries the round name
#   into the path; rehearsal no longer hardcodes e129 (instrument count ages).
set -eu

MODE=${1:-rehearsal}
ARG2=${2:-}
BOUND=268435456
STAMP=$(date -u +%Y%m%d.%H%M%S)
PIER=$(git remote get-url origin 2>/dev/null || echo unknown)
END=$(git rev-parse HEAD)
END10=$(git rev-parse --short=10 HEAD)

if test "$MODE" = "prove-red"; then
  echo "detail=RED_bundle_send_tmpfs"
  echo "verdict=misread"
  exit 1
fi

mkdir -p bundles/rehearsal bundles/wave

case "$MODE" in
  rehearsal)
    KIND=rehearsal
    if test "$ARG2" = "--span" && test -n "${3:-}"; then
      SPAN_SPEC=$3
      START_REF=${SPAN_SPEC%%..*}
      END_REF=${SPAN_SPEC##*..}
      START=$(git rev-parse "$START_REF")
      END=$(git rev-parse "$END_REF")
      END10=$(git rev-parse --short=10 "$END")
      OUT="bundles/rehearsal/rehearsal-span-${END10}.bundle"
      BASIS="span ${START}..${END}"
      echo "cutting span ${START_REF}..${END_REF} (${START}..${END})"
      # Name the tip as a ref so git bundle create accepts the thin span.
      git bundle create "$OUT" "$END_REF" "^${START_REF}"
    else
      # Full --all rehearsal — the overdue crossing rehearsal
      START=--all
      OUT="bundles/rehearsal/rehearsal-all-${END10}.bundle"
      BASIS="full --all cut at tip ${END}"
      echo "cutting --all at tip ${END}"
      git bundle create "$OUT" --all
    fi
    ;;
  closing)
    ROUND=${ARG2:?closing needs round e63|e127|e191|e255}
    case "$ROUND" in
      e63|e127|e191|e255) ;;
      *)
        echo "detail=not_a_closing_round"
        echo "verdict=misread"
        exit 1
        ;;
    esac
    KIND=$ROUND
    START=--all
    OUT="bundles/equinox_${ROUND}.bundle"
    BASIS="closing round ${ROUND} full --all"
    mkdir -p bundles
    git bundle create "$OUT" --all
    ;;
  wave)
    # Nested-wave / quest cut — round name travels in the path (e141 accretion).
    # Closing's four rounds stay untouched. Full-history root for --all bytes.
    ROUND=${ARG2:?wave needs round label e.g. q64}
    case "$ROUND" in
      *[!A-Za-z0-9._-]*)
        echo "detail=wave_round_label_refused"
        echo "verdict=misread"
        exit 1
        ;;
      '')
        echo "detail=wave_round_label_empty"
        echo "verdict=misread"
        exit 1
        ;;
    esac
    KIND=wave
    START=--all
    OUT="bundles/wave/${ROUND}-all-${END10}.bundle"
    BASIS="wave round ${ROUND} full --all"
    git bundle create "$OUT" --all
    ;;
  *)
    echo "usage: equinox_bundle_send.sh rehearsal [--span A..B] | closing <round> | wave <round> | prove-red"
    exit 2
    ;;
esac

case "$OUT" in
  /tmp/*|/var/tmp/*)
    echo "detail=tmpfs_refused"
    echo "verdict=misread"
    exit 1
    ;;
esac

git bundle verify "$OUT"
BYTES=$(wc -c < "$OUT" | tr -d '[:space:]')
if test "$BYTES" -gt "$BOUND"; then
  echo "detail=over_bound"
  echo "bundle_bytes=${BYTES}"
  echo "verdict=misread"
  exit 1
fi

sh tools/gen/season/equinox_bundle_manifest.sh \
  "$OUT" "$KIND" "$PIER" "$START" "$END" "$STAMP" "$BASIS"

echo "bundle_path=${OUT}"
echo "bundle_bytes=${BYTES}"
echo "bound_bytes=${BOUND}"
echo "tip=${END}"
echo "stamp=${STAMP}"
echo "kind=${KIND}"
echo "durable=honored"
echo "tmpfs=refused"
echo "crossing_mode=bundle_send"
echo "seat_claimed=none"
echo "shred=RED"
echo "verdict=ok"
