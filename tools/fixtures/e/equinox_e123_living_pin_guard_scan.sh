#!/bin/sh
# Equinox e123 -- living-pin content guard (ONE roof).
# Roster as data - C1 emptied - C2 whole - non-empty - header - tracked - bound.
# Over-bound is advisory by design. No second guard script -- two roofs refused.
# No backtick characters in patterns. No git history walks.
#
#   sh tools/fixtures/e/equinox_e123_living_pin_guard_scan.sh
#   sh tools/fixtures/e/equinox_e123_living_pin_guard_scan.sh prove-red
#
# Law: a duty with no witness never lands.
# Law: when two roofs carry one name, either they agree or the name does two jobs.
# Law: a witness must not depend on one bench's tools or on full history.
# Law: name the Bench when a measurement is reported.
set -eu

MODE=${1:-}
CONTROL_SCAN=tools/fixtures/c/census_control_scan.sh
ROSTER=tools/fixtures/l/living_pin_guard_roster.txt
EMPTIED=tools/fixtures/l/living_pin_emptied_control.md
C1=tools/fixtures/living_pin_control/emptied_pin_control.md
C2=tools/fixtures/living_pin_control/whole_pin_control.md
LEXICON=context/LEXICON.md
COUNSEL=counsel/date/20260731/20260731-222426_e123-living-pin-guard.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
PRIN=tools/gen/chapter/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
ELDER=tools/equinox/witness/equinox_e122_roots_bench_kinds_witness.rish
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
# The seated bound, read from the law rather than spelled here. One reading, one home (REDS %199).
#
# AND READ PER PAGE, which is the second half of that same reading. The fixture takes an optional
# path and answers that page's own bound; called bare it answers the general one, and this scan
# called it bare and then measured EVERY pin against the answer. So a page carrying a seated
# exception was refused for doing exactly what the law permits it -- `session-logs/README.md` at
# 57,344 and `construction/ITINERARY.md` at 32,768 both read as over-bound here while the law and
# the near-bound meter beside it read them as fine. Two meters, one number, opposite verdicts. The
# general answer stays for the printed reading below, and each pin is now weighed against its own.
MAX_BYTES=$(sh "$_fd_root/tools/fixtures/l/living_pin_max_bytes.sh")
pin_max_bytes() {
  sh "$_fd_root/tools/fixtures/l/living_pin_max_bytes.sh" "$1"
}
# grep rather than `rg`: this pier ships no ripgrep, and this scan's own law
# says a witness must not depend on one bench's tools.
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

if test "$MODE" = "prove-red"; then
  # Prefer C1 zero-byte control; fall back to thin emptied fixture.
  TARGET=$C1
  if ! test -f "$TARGET"; then
    TARGET=$EMPTIED
  fi
  if ! test -f "$TARGET"; then
    echo "detail=RED_emptied_fixture_absent"
    echo "verdict=misread"
    exit 1
  fi
  EBYTES=$(wc -c < "$TARGET" | tr -d ' ')
  if test "$EBYTES" -ge 200; then
    echo "detail=RED_emptied_fixture_not_thin"
    echo "emptied_bytes=$EBYTES"
    echo "verdict=misread"
    exit 1
  fi
  echo "kinds=pin_lost"
  echo "detail=RED_living_pin_emptied_caught"
  echo "emptied_bytes=$EBYTES"
  echo "census=withheld"
  echo "verdict=misread"
  exit 1
fi

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi

CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT"
echo "$CONTROL_OUT" | search_text -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

for p in "$ROSTER" "$EMPTIED" "$C1" "$C2" "$LEXICON" "$COUNSEL" "$MAP" "$ITINERARY" "$PRIN" "$ELDER"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    if test -f "$p"; then
      echo "instrument=failed"
      echo "verdict=misread"
      echo "detail=on_disk_is_not_in_the_tree"
      echo "detail_path=$p"
      exit 1
    fi
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=control_absent"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Refuse a second guard roof (counsel duplicate retired e124 tidy).
if git ls-files --error-unmatch tools/fixtures/living_pin_guard_scan.sh >/dev/null 2>&1; then
  echo "two_roofs=failed"
  echo "verdict=misread"
  echo "detail=duplicate_living_pin_guard_scan_still_tracked"
  exit 1
fi
echo "one_roof=honored"
echo "duplicate_guard=retired"

# C1 emptied must stay thin -- the instrument that would have caught e121.
EBYTES=$(wc -c < "$EMPTIED" | tr -d ' ')
if test "$EBYTES" -ge 200; then
  echo "emptied_control=failed"
  echo "verdict=misread"
  echo "detail=emptied_fixture_contaminated"
  echo "emptied_bytes=$EBYTES"
  exit 1
fi
C1_BYTES=$(wc -c < "$C1" | tr -d ' ')
if test "$C1_BYTES" -ge 200; then
  echo "emptied_control=failed"
  echo "verdict=misread"
  echo "detail=C1_contaminated"
  exit 1
fi
echo "OK C1-emptied  planted empty pin CAUGHT"
echo "emptied_bytes=$EBYTES"
echo "C1_bytes=$C1_BYTES"
echo "emptied_control=honored"

# C2 whole control must read whole
C2_BYTES=$(wc -c < "$C2" | tr -d ' ')
if test "$C2_BYTES" -lt 100; then
  echo "C2=failed"
  echo "verdict=misread"
  echo "detail=whole_control_thin"
  exit 1
fi
search_text -q 'Living pin' "$C2" || {
  echo "C2=failed"
  echo "verdict=misread"
  echo "detail=whole_control_header_missing"
  exit 1
}
echo "OK C2-whole    planted whole pin reads whole"
echo "C2_bytes=$C2_BYTES"

PIN_COUNT=0
OVER_HOLD=0
while IFS="$(printf '\t')" read -r path min_bytes header bound_mode || test -n "${path:-}"; do
  case "$path" in
    ''|\#*) continue ;;
  esac
  PIN_COUNT=$((PIN_COUNT + 1))

  git ls-files --error-unmatch "$path" >/dev/null 2>&1 || {
    echo "pin=failed"
    echo "verdict=misread"
    echo "detail=pin_untracked"
    echo "detail_path=$path"
    exit 1
  }

  if ! test -f "$path"; then
    echo "pin=failed"
    echo "verdict=misread"
    echo "detail=pin_absent"
    echo "detail_path=$path"
    exit 1
  fi

  BYTES=$(wc -c < "$path" | tr -d ' ')
  if test "$BYTES" -lt "$min_bytes"; then
    echo "pin=failed"
    echo "verdict=misread"
    echo "detail=pin_empty_or_thin"
    echo "detail_path=$path"
    echo "detail_bytes=$BYTES"
    echo "detail_min=$min_bytes"
    exit 1
  fi

  if ! search_text -q -F "$header" "$path"; then
    echo "pin=failed"
    echo "verdict=misread"
    echo "detail=pin_header_missing"
    echo "detail_path=$path"
    echo "detail_header=$header"
    exit 1
  fi

  PAGE_MAX=$(pin_max_bytes "$path")
  if test "$BYTES" -gt "$PAGE_MAX"; then
    if test "$bound_mode" = "advisory" || test "$bound_mode" = "hold_over"; then
      # Over-bound is tidy debt; emptied is loss -- different responses (counsel prove).
      echo "pin_over_bound_advisory=$path"
      echo "pin_over_bound_bytes=$BYTES"
      OVER_HOLD=$((OVER_HOLD + 1))
    else
      echo "pin=failed"
      echo "verdict=misread"
      echo "detail=pin_over_bound"
      echo "detail_path=$path"
      echo "detail_bytes=$BYTES"
      echo "detail_max=$PAGE_MAX"
      exit 1
    fi
  else
    echo "pin_ok=$path"
    echo "pin_bytes=$BYTES"
    echo "pin_max=$PAGE_MAX"
  fi
done < "$ROSTER"

if test "$PIN_COUNT" -lt 1; then
  echo "roster=failed"
  echo "verdict=misread"
  exit 1
fi
echo "pin_count=$PIN_COUNT"
echo "over_bound_advisory_count=$OVER_HOLD"
echo "over_bound=advisory"
echo "living_pin_max_bytes=$MAX_BYTES"
echo "pins=honored"

# e122 kinds stay -- approve-all does not re-blur roots and Bench
ROW=$(search_text -F '| **roots** |' "$LEXICON" || true)
echo "$ROW" | search_text -q 'Claude web' || { echo "kinds=failed"; echo "verdict=misread"; exit 1; }
if echo "$ROW" | search_text -q -i 'Framework itself|counsel container in the cloud'; then
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=refuse_e121_reblur"
  exit 1
fi
BENCH=$(search_text -F '| **Bench** |' "$LEXICON" || true)
echo "$BENCH" | search_text -q -i 'Name the \*\*Bench\*\* when a measurement|Name the Bench when a measurement' || {
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=want_name_the_bench_law"
  exit 1
}
if search_text -q -i 'bench = raised root|bench equals raised root' "$ITINERARY" "$MAP" "$PRIN"; then
  echo "kinds=failed"
  echo "verdict=misread"
  echo "detail=stale_e121_blur_still_standing"
  exit 1
fi
echo "kinds=honored"
echo "law=name_the_bench_when_a_measurement_is_reported"

search_text -q -i 'living-pin|living pin guard|pin_empty|emptied|content guard' "$COUNSEL" "$ITINERARY" "$MAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

search_text -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if search_text -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

COUNT=$(git ls-files 'tools/equinox/witness/equinox_ch*_surface_witness.rish' | wc -l | tr -d ' ')
if test "$COUNT" -ne 6; then
  echo "surface_keep=failed"
  echo "verdict=misread"
  echo "surface_count=$COUNT"
  exit 1
fi
echo "surface_keep=honored"
echo "surface_count=6"

search_text -q '^### 126\.' "$ALMANAC" || {
  echo "almanac=failed"
  echo "verdict=misread"
  exit 1
}
echo "almanac=honored"
echo "seats_through=126"

echo "elder=honored"
echo "elder_seat=e122"
echo "elder_note=e122_kinds_kept_e123_guards_pins"

if search_text -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
search_text -q 'equinox_handback: return_surface_p59' "$PRIN" || {
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
}
echo "fork=honored"
echo "fork_word=EXTEND"
echo "handback_status=not_consumed"

EP045=gratitude/ironbeetle/20260712-092212_ironbeetle-ep045-the-whole-machine-in-one-breath.md
git ls-files --error-unmatch "$EP045" >/dev/null 2>&1 || {
  echo "shelf=failed"
  echo "verdict=misread"
  exit 1
}
EP046_HITS=$(git ls-files 'gratitude/ironbeetle/*ep046*' | wc -l | tr -d ' ')
if test "$EP046_HITS" -ne 0; then
  echo "shelf=failed"
  echo "verdict=misread"
  exit 1
fi
echo "shelf=honored"
echo "shelf_end=ep045"
echo "shred=RED"

# History-walk witnesses stay out of this guard (no rev-list - no habit-count).
echo "history_independence=honored"
echo "history_note=no_git_history_walk"

if test -x rishi/bin/rishi; then
  echo "local_rishi=PRESENT"
else
  echo "local_rishi=ABSENT"
fi
if test -x vendor/zig-toolchain/zig; then
  echo "local_zig=PRESENT"
else
  echo "local_zig=ABSENT"
fi
echo "tool_presence=per_bench_recut"
echo "bench_used=Cursor_Cloud_root"

echo "story=living_pins_guarded>emptied_caught>kinds_kept>128_reserved"
echo "verdict=ok"
