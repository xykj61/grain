#!/bin/sh
# tools/fixtures/f/foundations_reach_control.sh -- the reach scan proven from both sides.
#
# WHY. A refusal proven only in the passing direction cannot be told from a bypass. So every
# reading `foundations_reach_scan.sh` gates is planted here and then lifted, on real directories in
# a throwaway pen whose answer is known by construction.
#
# THE SEVEN LEGS
#   rota_absent_refused        a derived rota seat absent from the index refuses, and is named
#   rota_present_accepted      the same room reads ok once the index names it
#   outside_seat_not_counted   a seat living in another room is no claim on this index
#   ceiling_refused            one page past the ceiling refuses
#   ceiling_at_bound_accepted  a room standing exactly at the ceiling walks free
#   no_seats_derived_refused   a grid that answers nothing refuses, rather than calling all reachable
#   no_index_refused           an absent index refuses, rather than reading an empty room as whole
#
# Run from the repository root:
#   sh tools/fixtures/f/foundations_reach_control.sh

set -eu

scan=tools/fixtures/f/foundations_reach_scan.sh
pen=${TMPDIR:-/tmp}/frc-pen-$$
mkdir -p "$pen" || exit 2
trap 'rm -rf "$pen"' EXIT INT TERM

room="$pen/why"
mkdir -p "$room"
grid="$pen/grid.md"

seat="$room/20260101-000001_the-seat.md"
plain="$room/20260101-000002_a-plain-page.md"
printf 'seat\n' > "$seat"
printf 'plain\n' > "$plain"

# A grid whose element rows name the seat, in the shape the real grid writes.
{
  printf '| | **Cardinal** | **Fixed** | **Dual** |\n'
  printf '| **Aether - Jupiter** *why* | `%s` | x | y |\n' "$seat"
} > "$grid"

run_scan() { sh "$scan" "$room" "$room/README.md" "$grid" 2>&1 || true; }

# --- leg 1 and 2: the seat, absent then named -------------------------------------------------
printf '# index\n\nnames %s\n' "$(basename "$plain")" > "$room/README.md"
out=$(run_scan)
rota_absent_refused=no
case "$out" in *"verdict=rota_seat_unreachable"*) case "$out" in *"rota_absent: $seat"*) rota_absent_refused=yes ;; esac ;; esac

printf '# index\n\nnames %s and %s\n' "$(basename "$plain")" "$(basename "$seat")" > "$room/README.md"
out=$(run_scan)
rota_present_accepted=no
case "$out" in *"rota_absent=0"*) case "$out" in *"verdict=ok"*) rota_present_accepted=yes ;; esac ;; esac

# --- leg 3: a seat living in another room is no claim on this index ---------------------------
{
  printf '| | **Cardinal** | **Fixed** | **Dual** |\n'
  printf '| **Air - Saturn** *law* | `%s` | `elsewhere/20260101-000009_far.md` | y |\n' "$seat"
} > "$grid"
out=$(run_scan)
outside_seat_not_counted=no
case "$out" in *"rota_absent=0"*) case "$out" in *"verdict=ok"*) outside_seat_not_counted=yes ;; esac ;; esac

# --- legs 4 and 5: the ceiling, proven from both sides -----------------------------------------
ceiling=$(sh "$scan" "$room" "$room/README.md" "$grid" | sed -n 's/^absent_ceiling=//p')
i=0
while [ "$i" -lt "$ceiling" ]; do
  i=$((i + 1))
  printf 'filler\n' > "$room/20260202-0000$(printf '%02d' "$i")_filler.md"
done
out=$(run_scan)
ceiling_at_bound_accepted=no
case "$out" in *"absent=$ceiling"*) case "$out" in *"verdict=ok"*) ceiling_at_bound_accepted=yes ;; esac ;; esac

printf 'one more\n' > "$room/20260303-000001_one-past.md"
out=$(run_scan)
ceiling_refused=no
case "$out" in *"verdict=absent_over_ceiling"*) ceiling_refused=yes ;; esac
rm -f "$room/20260303-000001_one-past.md"

# --- leg 6: a grid that answers nothing refuses ------------------------------------------------
printf '# no element rows here\n' > "$grid"
out=$(run_scan)
no_seats_derived_refused=no
case "$out" in *"verdict=no_seats_derived"*) no_seats_derived_refused=yes ;; esac

# --- leg 7: an absent index refuses ------------------------------------------------------------
out=$(sh "$scan" "$room" "$room/ABSENT.md" "$grid" 2>&1 || true)
no_index_refused=no
case "$out" in *"verdict=no_index"*) no_index_refused=yes ;; esac

echo "rota_absent_refused=$rota_absent_refused"
echo "rota_present_accepted=$rota_present_accepted"
echo "outside_seat_not_counted=$outside_seat_not_counted"
echo "ceiling_at_bound_accepted=$ceiling_at_bound_accepted"
echo "ceiling_refused=$ceiling_refused"
echo "no_seats_derived_refused=$no_seats_derived_refused"
echo "no_index_refused=$no_index_refused"

for r in "$rota_absent_refused" "$rota_present_accepted" "$outside_seat_not_counted" \
         "$ceiling_at_bound_accepted" "$ceiling_refused" "$no_seats_derived_refused" \
         "$no_index_refused"; do
  [ "$r" = "yes" ] || { echo "control_verdict=leg_failed"; exit 1; }
done
echo "control_verdict=ok"
exit 0
