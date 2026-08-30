#!/bin/sh
# tools/fixtures/p/pin_bound_touch_scan.sh -- a round that moves a living pin measures it before it ships.
#
# WHAT THIS IS FOR. Seven pages in this tree are living pins, rostered in
# tools/fixtures/l/living_pin_guard_roster.txt, and each carries a byte bound so an agent can read it
# in one breath beside its lap. `equinox_e123_living_pin_guard` weighs all seven at roster time.
# This weighs only the ones THIS ROUND TOUCHED, off the index, at the moment the commit is made --
# which is the moment the overage can still be spent back out of the prose that caused it.
#
# WHY BOTH READINGS EXIST, since a second roof over one reading is refused by law. They are the same
# question asked at two different times, and neither answers for the other. The roster reading is
# whole and slow: it weighs every pin whether or not the round went near it, and on this bench a
# cold roster pass runs for roughly half an hour, so a lap that sends before it finishes sends
# unread. This reading is partial and instant: it weighs a pin only when the round's own diff names
# it, so it costs nothing on the many rounds that touch no pin at all. There is one roster file and
# one bound reading (tools/fixtures/l/living_pin_max_bytes.sh, REDS %199) -- so the two roofs cannot
# disagree about which pages are pins or about how heavy a pin may be, which is the whole content of
# the two-roofs refusal.
#
# THE HISTORY. REDS %293 (20260827.164635) found construction/SHRED_PREP.md shipped at 24,676 bytes
# against the 24,576 its own header declares, and named this exact repair in its own third field:
# "`git diff --cached --name-only` piped against the pin roster answers the question mechanically
# rather than from a reader's sense of what the round was about." It was named and left unbuilt, and
# the next day two more pins crossed -- construction/REDS.md at 28,568 and construction/ITINERARY.md
# at 24,579 -- and four commits shipped over a red roster row. A lantern that fires twice becomes a
# loom (REDS %316). This is the loom.
#
#   bash tools/fixtures/p/pin_bound_touch_scan.sh                  # what this commit ships
#   bash tools/fixtures/p/pin_bound_touch_scan.sh head             # what HEAD shipped
#   bash tools/fixtures/p/pin_bound_touch_scan.sh worktree         # every pin, off disk
#   bash tools/fixtures/p/pin_bound_touch_scan.sh prove-red        # the planted refusal
#   bash tools/fixtures/p/pin_bound_touch_scan.sh staged --roster <path>   # a pen roster
#
# WHAT IT READS, and why off the index rather than off disk. `git cat-file -s :<path>` is the size
# of the blob the commit will actually carry, and a worktree read answers about bytes that may never
# ship. A round holding an unstaged trim of the very pin it is committing would read green off disk
# and red in the repository, which is the reading that matters.
#
# WHAT IT REPORTS RATHER THAN REFUSES. A roster row's fourth column names its bound_mode. `enforce`
# refuses; `advisory` and `hold_over` are counted and printed, because over-bound is tidy debt where
# an emptied pin is loss, and the two earn different responses (e123's own counsel). A pin the round
# deleted is skipped -- absence is e123's reading, not this one's.
#
# EVERY PIN IS WEIGHED BEFORE ANY REFUSAL. e123 exits at its first over-bound pin, so on
# 20260828 it named the ITINERARY's 3-byte overage and the ledger's 3,992-byte overage went
# unreported for four commits. A meter that stops at the first fault reports one number about a set.
#
# Proven both ways by tools/fixtures/p/pin_bound_touch_control.sh on real git repositories in a
# throwaway pen -- 36 cases, every refusal shown from both sides, and five of them arming
# tools/hooks/pre-commit the way a clone arms it and running real `git commit`s through it, since a
# wall proven only by its scan is a wall nobody has watched refuse. Gated by
# tools/p/pin_bound_touch_witness.rish.
#
# Law: context/specs/20260724-132812_pin-and-ledger-living-pin-max-bytes.md
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
BOUND_READER="$_fd_root/tools/fixtures/l/living_pin_max_bytes.sh"

# A caller may hand down the shell it has already proved. Direct readings repeat the same bounded
# probe: this scan starts under an explicit interpreter, but its elder bound reader is a second
# process and must not fall back through an unreadable selector shell. The probe exercises the
# substitution-plus-cd shape that the 20260829 macOS enclosure garbled, rather than trusting a
# version banner that never asks the failing question.
BOUND_SHELL=${PIN_BOUND_SHELL:-}
bound_shell_works() {
  "$1" -c '_r=$(CDPATH= cd -- "$1" && pwd) && [ -d "$_r" ]' \
    pin-bound-probe "$_fd_root/tools/fixtures/l" >/dev/null 2>&1
}
if [ -n "$BOUND_SHELL" ] && ! bound_shell_works "$BOUND_SHELL"; then
  BOUND_SHELL=""
fi
if [ -z "$BOUND_SHELL" ]; then
  for candidate in /bin/bash bash /bin/sh sh; do
    if bound_shell_works "$candidate"; then
      BOUND_SHELL=$candidate
      break
    fi
  done
fi
if [ -z "$BOUND_SHELL" ]; then
  echo "detail=RED_bound_reader_shell_absent"
  echo "verdict=misread"
  exit 1
fi

MODE=staged
ROSTER=tools/fixtures/l/living_pin_guard_roster.txt

# A collection names its maximum (TAME). Seven pins are rostered today; sixty-four is far above
# every roster this tree has held and far below a runaway read.
MAX_ROSTER_ROWS=64

while [ $# -gt 0 ]; do
  case "$1" in
    staged|head|worktree|prove-red) MODE=$1 ;;
    --roster) shift; ROSTER=${1:-} ;;
    *) echo "detail=RED_unknown_argument"; echo "detail_argument=$1"; echo "verdict=misread"; exit 1 ;;
  esac
  shift
done

echo "mode=$MODE"
echo "roster=$ROSTER"

if [ "$MODE" = prove-red ]; then
  # The planted refusal: one pin, one byte past the bound, so the RED path is exercised without
  # waiting for a real pin to cross. The bound is READ from living_pin_max_bytes.sh rather than
  # spelled here -- a fixture that states the law in its own digits is a second copy of the law,
  # which declared_ceiling_scan.sh correctly reads as deciding with a copy, and which would go
  # quietly false the day the number moves.
  prove_pin=tools/fixtures/pin_bound_touch_prove_red_pin.md
  prove_bound=$("$BOUND_SHELL" "$BOUND_READER" "$prove_pin")
  echo "pin_over=$prove_pin"
  echo "detail=RED_touched_pin_over_bound"
  echo "detail_path=$prove_pin"
  echo "detail_bytes=$((prove_bound + 1))"
  echo "detail_bound=$prove_bound"
  echo "over_bound_enforced=1"
  echo "verdict=misread"
  exit 1
fi

if [ ! -f "$ROSTER" ]; then
  echo "detail=RED_roster_absent"
  echo "verdict=misread"
  exit 1
fi

if [ ! -f "$BOUND_READER" ]; then
  echo "detail=RED_bound_reader_absent"
  echo "detail_path=$BOUND_READER"
  echo "verdict=misread"
  exit 1
fi

# The touched set. In worktree mode every rostered pin is touched by definition, so the set is left
# empty and the loop below reads them all.
TOUCHED=""
case "$MODE" in
  staged) TOUCHED=$(git diff --cached --name-only 2>/dev/null || true) ;;
  head)   TOUCHED=$(git diff-tree --no-commit-id --name-only -r HEAD 2>/dev/null || true) ;;
esac

ROWS=0
TOUCHED_PINS=0
OVER_ENFORCED=0
OVER_ADVISORY=0
REPORT=""

while IFS="$(printf '\t')" read -r path min_bytes header bound_mode || [ -n "${path:-}" ]; do
  case "$path" in
    ''|\#*) continue ;;
  esac
  ROWS=$((ROWS + 1))
  if [ "$ROWS" -gt "$MAX_ROSTER_ROWS" ]; then
    echo "detail=RED_roster_past_bound"
    echo "detail_max=$MAX_ROSTER_ROWS"
    echo "verdict=misread"
    exit 1
  fi

  # Is this pin in the round's own diff? A whole-line match, so `a/README.md` can never answer for
  # `b/a/README.md`.
  if [ "$MODE" != worktree ]; then
    printf '%s\n' "$TOUCHED" | grep -qxF "$path" || continue
  fi

  # Read the bytes from where this mode says the truth is.
  BYTES=""
  case "$MODE" in
    staged)   BYTES=$(git cat-file -s ":$path" 2>/dev/null || true) ;;
    head)     BYTES=$(git cat-file -s "HEAD:$path" 2>/dev/null || true) ;;
    worktree) [ -f "$path" ] && BYTES=$(wc -c < "$path" | tr -d ' ') ;;
  esac

  # A pin the round removed carries no bytes to weigh. Absence is e123's reading.
  if [ -z "$BYTES" ]; then
    REPORT="$REPORT
pin_absent=$path"
    continue
  fi

  TOUCHED_PINS=$((TOUCHED_PINS + 1))
  BOUND=$("$BOUND_SHELL" "$BOUND_READER" "$path")

  if [ "$BYTES" -le "$BOUND" ]; then
    REPORT="$REPORT
pin_ok=$path
pin_bytes=$BYTES
pin_bound=$BOUND"
    continue
  fi

  case "$bound_mode" in
    advisory|hold_over)
      OVER_ADVISORY=$((OVER_ADVISORY + 1))
      REPORT="$REPORT
pin_over_bound_advisory=$path
pin_over_bound_bytes=$BYTES
pin_bound=$BOUND" ;;
    *)
      OVER_ENFORCED=$((OVER_ENFORCED + 1))
      REPORT="$REPORT
pin_over=$path
detail=RED_touched_pin_over_bound
detail_path=$path
detail_bytes=$BYTES
detail_bound=$BOUND
detail_over_by=$((BYTES - BOUND))" ;;
  esac
done < "$ROSTER"

if [ "$ROWS" -lt 1 ]; then
  echo "detail=RED_roster_empty"
  echo "verdict=misread"
  exit 1
fi

printf '%s\n' "$REPORT" | sed '/^$/d'
echo "roster_rows=$ROWS"
echo "touched_pins=$TOUCHED_PINS"
echo "over_bound_enforced=$OVER_ENFORCED"
echo "over_bound_advisory=$OVER_ADVISORY"

if [ "$OVER_ENFORCED" -gt 0 ]; then
  echo "verdict=misread"
  exit 1
fi

echo "story=the_round_weighs_the_pin_it_moved"
echo "verdict=ok"
