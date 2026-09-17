#!/bin/sh
# tools/fixtures/i/itinerary_list_control.sh -- prove the list-spine scan from both sides.
#
# Every refusal is planted and then lifted, and every welcome is asserted as hard as every refusal:
# a refusal proven only in the passing direction cannot be told from a bypass. Two legs replay the
# REAL firings, REDS %789 and the row of 20260916.220730, out of this repository's own history -- a guard that catches the
# defect that actually happened says more than any plant.
#
#   sh tools/fixtures/i/itinerary_list_control.sh
#
# BOUNDS: one pen, at most 32 legs, removed on exit.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
SCAN="$ROOT/tools/fixtures/i/itinerary_list_scan.sh"
[ -f "$SCAN" ] || { echo "refused: no scan at $SCAN"; exit 2; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/pin-list-control.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

legs=0
failed=0

leg() {  # leg <name> <expected> <actual>
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then
    echo "leg $legs $1 = $3"
  else
    failed=$((failed + 1))
    echo "leg $legs $1 FAILED -- wanted $2, read $3"
  fi
}

pen_new() {  # pen_new <scan-path-override>; builds a fresh pen tree and echoes its root
  d=$(mktemp -d "$PEN/t.XXXXXX")
  mkdir -p "$d/construction" "$d/tools/fixtures/l" "$d/tools/fixtures/i"
  cp "${1:-$SCAN}" "$d/tools/fixtures/i/itinerary_list_scan.sh"
  printf 'construction/PIN.md\t200\tLiving pin\tenforce\n' > "$d/tools/fixtures/l/living_pin_guard_roster.txt"
  echo "$d"
}

read_key() {  # read_key <pen> <key> [mode]
  ITINERARY_LIST_ROOT="$1" sh "$1/tools/fixtures/i/itinerary_list_scan.sh" "${3:-count}" \
    | grep "^$2=" | cut -d= -f2
}

# ---- 1-2. a clean list is welcomed, and its items are counted -------------------------------
d=$(pen_new)
printf '# Pin\n\n1. one\n2. two\n3. three\n' > "$d/construction/PIN.md"
leg clean_list_welcomed 0 "$(read_key "$d" broken_runs)"
leg clean_list_items_counted 3 "$(read_key "$d" ordered_items)"

# ---- 3-4. the founding shape: a foreign line eats an item -----------------------------------
printf '# Pin\n\n1. one\n2. two\n3. three\n**Git nib:** `deadbeef` -- stole item four.\n5. five\n6. six\n' \
  > "$d/construction/PIN.md"
leg foreign_line_refused 1 "$(read_key "$d" broken_runs)"
leg foreign_line_splits_run 2 "$(read_key "$d" ordered_runs)"

# ---- 5. and lifting the plant returns it to green --------------------------------------------
printf '# Pin\n\n1. one\n2. two\n3. three\n4. four\n5. five\n6. six\n' > "$d/construction/PIN.md"
leg foreign_line_lifted 0 "$(read_key "$d" broken_runs)"

# ---- 6-8. a gap, a repeat, and a run that never starts at one --------------------------------
printf '# Pin\n\n1. one\n2. two\n4. four\n' > "$d/construction/PIN.md"
leg gap_refused 1 "$(read_key "$d" broken_runs)"
printf '# Pin\n\n1. one\n2. two\n2. two again\n3. three\n' > "$d/construction/PIN.md"
leg repeat_refused 1 "$(read_key "$d" broken_runs)"
printf '# Pin\n\n2. two\n3. three\n' > "$d/construction/PIN.md"
leg headless_run_refused 1 "$(read_key "$d" broken_runs)"

# ---- 9-10. a loose list keeps its numbering across a blank line -------------------------------
printf '# Pin\n\n1. one\n\n2. two\n\n3. three\n' > "$d/construction/PIN.md"
leg loose_list_welcomed 0 "$(read_key "$d" broken_runs)"
leg loose_list_is_one_run 1 "$(read_key "$d" ordered_runs)"

# ---- 11-12. two separate lists each reading 1..N are both welcomed ----------------------------
printf '# Pin\n\n1. one\n2. two\n\nprose between them\n\n1. one\n2. two\n' > "$d/construction/PIN.md"
leg two_lists_welcomed 0 "$(read_key "$d" broken_runs)"
leg two_lists_are_two_runs 2 "$(read_key "$d" ordered_runs)"

# ---- 13-14. a nested list is its own run, and its PARENT RESUMES after it --------------------
printf '# Pin\n\n1. one\n   1. inner one\n   2. inner two\n2. two\n' > "$d/construction/PIN.md"
leg nested_list_welcomed 0 "$(read_key "$d" broken_runs)"
leg nested_list_is_two_runs 2 "$(read_key "$d" ordered_runs)"

# ---- 15. a nested list with its own gap is refused, and the parent is not blamed --------------
printf '# Pin\n\n1. one\n   1. inner one\n   3. inner three\n2. two\n' > "$d/construction/PIN.md"
leg nested_gap_refused 1 "$(read_key "$d" broken_runs)"

# ---- 16-17. a rostered page absent from the tree is reported, never counted broken ------------
d2=$(pen_new)
leg absent_pin_reported 1 "$(read_key "$d2" pins_absent)"
leg absent_pin_not_broken 0 "$(read_key "$d2" broken_runs)"

# ---- 18. no roster is a refusal rather than a zero ---------------------------------------------
d3=$(pen_new)
printf '# Pin\n\n1. one\n' > "$d3/construction/PIN.md"
rm -f "$d3/tools/fixtures/l/living_pin_guard_roster.txt"
if ITINERARY_LIST_ROOT="$d3" sh "$d3/tools/fixtures/i/itinerary_list_scan.sh" >/dev/null 2>&1; then
  leg roster_absent_refuses refused passed
else
  leg roster_absent_refuses refused refused
fi

# ---- 19-22. THE REAL FIRINGS, replayed out of this repository's own history --------------------
# REDS %789 is commit 5f96df5e1 and the row of 20260916.220730 is commit 00493b3be. Each replaced item 7 of the
# INNER LOOP with a duplicate Git nib line. The commit BEFORE each is the same page intact.
if git -C "$ROOT" cat-file -e 00493b3be:construction/ITINERARY.md 2>/dev/null; then
  d4=$(pen_new)
  printf 'construction/ITINERARY.md\t1000\tLiving pin\tenforce\n' \
    > "$d4/tools/fixtures/l/living_pin_guard_roster.txt"

  git -C "$ROOT" show 5f96df5e1:construction/ITINERARY.md > "$d4/construction/ITINERARY.md"
  leg reds_789_firing_refused 1 "$(read_key "$d4" broken_runs)"
  git -C "$ROOT" show 5f96df5e1~1:construction/ITINERARY.md > "$d4/construction/ITINERARY.md"
  leg reds_789_parent_welcomed 0 "$(read_key "$d4" broken_runs)"

  git -C "$ROOT" show 00493b3be:construction/ITINERARY.md > "$d4/construction/ITINERARY.md"
  leg reds_791_firing_refused 1 "$(read_key "$d4" broken_runs)"
  git -C "$ROOT" show 00493b3be~1:construction/ITINERARY.md > "$d4/construction/ITINERARY.md"
  leg reds_791_parent_welcomed 0 "$(read_key "$d4" broken_runs)"
else
  echo "note: the two firing commits are absent from this clone -- four history legs skipped"
fi

# ---- 23-24. MUTATION: the foreign-line close is what catches the founding shape ----------------
# Delete the line that ends a run when a foreign line stands at or left of its indent, and the
# scan reads straight past the intruder -- which is the elder blindness exactly.
# ---- MUTATION: the foreign-line unwind is what keeps two lists from reading as one -------------
# Delete the unwind that ends a run at a foreign line and two separate 1..N lists, with prose
# between them, read as one run of 1,2,1,2 -- a false refusal on ordinary writing, which is the
# failure a guard can least afford.
mut="$PEN/mut-close.sh"
sed '/a foreign line at or left of a run ends that run/d' "$SCAN" > "$mut"
d5=$(pen_new "$mut")
printf '# Pin\n\n1. one\n2. two\n\nprose between them\n\n1. one\n2. two\n' > "$d5/construction/PIN.md"
leg mutation_unwind_bites 1 "$(read_key "$d5" broken_runs)"
d6=$(pen_new)
printf '# Pin\n\n1. one\n2. two\n\nprose between them\n\n1. one\n2. two\n' > "$d6/construction/PIN.md"
leg mutation_unwind_control 0 "$(read_key "$d6" broken_runs)"

# ---- 25-26. MUTATION: the ascending check is what catches a gap --------------------------------
mut2="$PEN/mut-want.sh"
sed 's/if (num\[d SUBSEP i\] + 0 != want) {/if (0) {/' "$SCAN" > "$mut2"
d7=$(pen_new "$mut2")
printf '# Pin\n\n1. one\n3. three\n' > "$d7/construction/PIN.md"
leg mutation_ascending_bites 0 "$(read_key "$d7" broken_runs)"
d8=$(pen_new)
printf '# Pin\n\n1. one\n3. three\n' > "$d8/construction/PIN.md"
leg mutation_ascending_control 1 "$(read_key "$d8" broken_runs)"

# ---- 27. an item without a space after the dot is a version string, never a list ---------------
d9=$(pen_new)
printf '# Pin\n\nRye 20260916.215019 is the version.\n1. one\n2. two\n' > "$d9/construction/PIN.md"
leg version_string_not_an_item 2 "$(read_key "$d9" ordered_items)"

# ---- 28. a page with no ordered list at all reads zero runs and stays green ---------------------
printf '# Pin\n\njust prose, no list anywhere.\n' > "$d9/construction/PIN.md"
leg no_list_is_zero_runs 0 "$(read_key "$d9" ordered_runs)"

echo "control_legs=$legs"
echo "control_failed=$failed"
[ "$failed" -eq 0 ] && echo "control_verdict=ok" || echo "control_verdict=failed"
