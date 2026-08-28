#!/bin/sh
# Equinox e130 -- land counsel's sealed nest jam-cue desk at max_lines ceiling.
# Exit 0 when the desk is tracked, at six bindings, runs GREEN, and seven refuses.
# No backtick characters.
#
#   sh tools/fixtures/equinox_e130_seal_desk_scan.sh
#   sh tools/fixtures/equinox_e130_seal_desk_scan.sh prove-red
#
# Law: a bound refuses its own author -- that is the bound working.
# Law: glow sits above rish on the build stack; product not only measurement.
set -eu

MODE=${1:-}
DESK=glow/gen/c/compose-bind-nest-seal-jam-cue.glow
ELDER=glow/gen/c/compose-bind-nest-four-jam-cue.glow
LOWER=glow/lower_multi.rye
CONTROL_SCAN=tools/fixtures/census_control_scan.sh
COUNSEL=counsel/date/20260731/20260731-234806_e130-seal-jam-cue-desk.md
LEXICON=context/LEXICON.md
MAP=construction/EQUINOX_SEAT_MAP.md
ITINERARY=construction/ITINERARY.md
PRIN=tools/gen/chapter/prin_scope.rish
ALMANAC=rye-learning-process/GLOW_ALMANAC.md
WORKER=tools/g/glow_run_worker.sh
ZIG="${RYE_ZIG:-vendor/zig-toolchain/zig}"

if test "$MODE" = "prove-red"; then
  echo "detail=RED_glow_past_max_lines"
  echo "verdict=misread"
  exit 1
fi

if ! test -f "$CONTROL_SCAN"; then
  echo "CONTROL=ABSENT"
  echo "verdict=absent"
  exit 1
fi
CONTROL_OUT=$(sh "$CONTROL_SCAN")
echo "$CONTROL_OUT" | rg -q '^verdict=ok$' || {
  echo "control_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "control_gate=honored"

for p in "$DESK" "$ELDER" "$LOWER" "$COUNSEL" "$LEXICON" "$MAP" "$ITINERARY" "$PRIN" "$WORKER"; do
  git ls-files --error-unmatch "$p" >/dev/null 2>&1 || {
    echo "instrument=failed"
    echo "verdict=misread"
    echo "detail=on_disk_is_not_in_the_tree"
    echo "detail_path=$p"
    exit 1
  }
done
echo "instruments_tracked=honored"

# Desk shape: exactly six =/ bindings - seal face - jam nest - cue
BIND_N=$(rg -c '^=/  ' "$DESK" || true)
BIND_N=${BIND_N:-0}
if test "$BIND_N" -ne 6; then
  echo "desk=failed"
  echo "detail=want_exactly_six_binds"
  echo "bind_n=${BIND_N}"
  echo "verdict=misread"
  exit 1
fi
rg -q 'seal=@u32' "$DESK" || {
  echo "desk=failed"
  echo "detail=want_seal_face"
  echo "verdict=misread"
  exit 1
}
rg -Fq '(jam (mix from amount) (mix payload seal))' "$DESK" || {
  echo "desk=failed"
  echo "detail=want_sealed_jam_nest"
  echo "verdict=misread"
  exit 1
}
rg -Fq '(cue cell-pack)' "$DESK" || {
  echo "desk=failed"
  echo "detail=want_cue"
  echo "verdict=misread"
  exit 1
}
echo "desk=honored"
echo "desk_binds=6"
echo "desk_at_ceiling=honored"

# Named bound in lower_multi
rg -q 'pub const max_lines: u32 = 6;' "$LOWER" || {
  echo "bound=failed"
  echo "detail=want_max_lines_6"
  echo "verdict=misread"
  exit 1
}
echo "bound=honored"
echo "max_lines=6"

# Living run -- requires zig + rye (bootstrapped on this Bench when possible)
if ! test -x "$ZIG"; then
  echo "glow_run=failed"
  echo "detail=zig_absent"
  echo "verdict=misread"
  exit 1
fi
if ! test -x rye/bin/rye; then
  echo "glow_run=failed"
  echo "detail=rye_absent"
  echo "verdict=misread"
  exit 1
fi

set +e
RUN_OUT=$(env RYE_ZIG="$ZIG" sh "$WORKER" "$DESK" 2>&1)
RUN_RC=$?
set -e
echo "$RUN_OUT"
if test "$RUN_RC" -ne 0; then
  echo "glow_run=failed"
  echo "verdict=misread"
  exit 1
fi
echo "$RUN_OUT" | rg -q '^EXIT:0$' || {
  echo "glow_run=failed"
  echo "detail=want_EXIT_0"
  echo "verdict=misread"
  exit 1
}
echo "glow_run=honored"
echo "glow_run_note=lowered_built_exit_0"

# Seven bindings must refuse
SEVEN=$(mktemp "${TMPDIR:-/tmp}/e130-seven.XXXXXX.glow")
printf '%s\n' \
  ':: seven bindings past ceiling' \
  '=/  from=@u32  5' \
  '=/  amount=@u32  3' \
  '=/  payload=@u32  9' \
  '=/  seal=@u32  7' \
  '=/  extra=@u32  1' \
  '=/  cell-pack=@u32  (jam (mix from amount) (mix payload seal))' \
  '=/  right=@u32  (cue cell-pack)' \
  > "$SEVEN"
set +e
SEVEN_OUT=$(env RYE_ZIG="$ZIG" sh "$WORKER" "$SEVEN" 2>&1)
SEVEN_RC=$?
set -e
rm -f "$SEVEN"
echo "$SEVEN_OUT"
if test "$SEVEN_RC" -eq 0; then
  echo "ceiling=failed"
  echo "detail=seven_must_refuse"
  echo "verdict=misread"
  exit 1
fi
echo "$SEVEN_OUT" | rg -qi 'too many Glow lines' || {
  echo "ceiling=failed"
  echo "detail=want_too_many_glow_lines"
  echo "verdict=misread"
  exit 1
}
echo "ceiling=honored"
echo "ceiling_note=bound_refuses_author"

rg -qi 'seal|max_lines|compose-bind-nest-seal|bound refuses' "$COUNSEL" "$ITINERARY" "$MAP" || {
  echo "living=failed"
  echo "verdict=misread"
  exit 1
}
echo "living=honored"

rg -q 'RESERVED' "$MAP" || {
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
}
if rg -q 'seat \*\*128\*\*.*SPENT|128.*LANDED' "$MAP"; then
  echo "reserve_keep=failed"
  echo "verdict=misread"
  exit 1
fi
echo "reserve_keep=honored"
echo "seat_128=reserved_close_choir"

if rg -q '^### 128\.' "$ALMANAC"; then
  echo "almanac=failed"
  echo "detail=seat_128_must_stay_unspent"
  echo "verdict=misread"
  exit 1
fi
echo "almanac=honored"
echo "no_content_seat_claimed=honored"

rg -qi 'shred \*\*RED\*\*|shred RED|shred=RED' "$ITINERARY" "$MAP" "$COUNSEL" || {
  echo "shred_gate=failed"
  echo "verdict=misread"
  exit 1
}
echo "shred_gate=honored"
echo "shred=RED"

if rg -q 'equinox_handback: return_surface_p59 CONSUMED' "$PRIN"; then
  echo "fork=failed"
  echo "verdict=misread"
  exit 1
fi
echo "fork=honored"
echo "gates_kept=shred_safe_geode_128"
echo "product=glow_desk_landed"
echo "build_stack_rung=glow"

echo "story=seal_desk>max_lines_6>glow_run_green>128_reserved"
echo "verdict=ok"
