#!/bin/sh
# tools/fixtures/s/seat_prompt_figure_control.sh -- prove seat_prompt_figure_scan.sh on planted fleets.
#
# Every refusal is shown from the failing side AND then lifted, so a reading can never be a plant
# that planted nothing (REDS `%519`). Every welcome is asserted as hard as every refusal, because a
# refusal proven only in the passing direction cannot be told from a bypass. The pen is proven
# innocent too: a scan patched to always answer zero must FAIL this control, with the patch's own
# landing proven by `cmp -s` rather than assumed from a `sed` exit code.
#
# THE FAIL LINE GOES TO STDOUT, on purpose. REDS `%530` found five rostered witnesses filing an
# evidence page that named the guard and no reason, because their controls wrote `FAIL <behavior>`
# to stderr and the witnesses forwarded stdout alone. Forwarding both was the repair; writing the
# reason where the verdict already goes is the cure, and it is what this control does.
#
# Run from the repository root:
#   sh tools/fixtures/s/seat_prompt_figure_control.sh
set -u

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/s/seat_prompt_figure_scan.sh"
. "$ROOT/tools/fixtures/s/shell_portable.sh"
PEN=$(mktemp -d "${TMPDIR:-/tmp}/seat_prompt_figure_control.XXXXXX") || exit 2
trap 'rm -rf "$PEN"' EXIT

behaviors=0
failed=0

check() { # check <name> <expected> <actual>
  behaviors=$((behaviors + 1))
  if [ "$2" = "$3" ]; then
    echo "  ok   $1"
  else
    echo "  FAIL $1 -- wanted [$2] got [$3]"
    failed=$((failed + 1))
  fi
}

# A pen fleet: one live seat `alpha`, one parked seat `zulu`, each with a prompt. Every plant below
# starts from this and changes exactly one thing.
mkfleet() { # mkfleet <name> ; echoes its root
  d="$PEN/$1"
  mkdir -p "$d/construction" "$d/tools/a" "$d/tools/z"
  cat > "$d/construction/fleet-roster.kyri" <<'ROSTER'
format fleet-roster-v1
seat alpha
tree grain-alpha
engine claude
lane the pen's one live seat
status live
seated 20260101.000000

seat zulu
tree grain-zulu
engine claude
lane the pen's parked seat
status parked
seated 20260101.000000
ROSTER
  printf 'YOU ARE ALPHA. Your lane is the pen.\n' > "$d/tools/a/alpha_seat_prompt.txt"
  printf 'YOU ARE ZULU. Your lane is the pen.\n' > "$d/tools/z/zulu_seat_prompt.txt"
  printf '%s' "$d"
}

prompt_of() { # prompt_of <root> <seat>
  printf '%s/tools/%s/%s_seat_prompt.txt' "$1" "$(printf '%s' "$2" | cut -c1)" "$2"
}
field_of() { # field_of <key> <root> [<scan>]
  sh "${3:-$SCAN}" "$2" 2>/dev/null | sed -n "s/^$1=//p" | head -1
}
exit_of() { # exit_of <root> [<scan>]
  sh "${2:-$SCAN}" "$1" >/dev/null 2>&1
  echo $?
}
details_of() { # details_of <root> -- count of detail_figure lines
  sh "$SCAN" "$1" 2>/dev/null | grep -c '^detail_figure=' || true
}

echo "seat_prompt_figure_control: planted fleets"

# -- 1. the clean baseline walks free ------------------------------------------------------------
p=$(mkfleet clean)
check "clean fleet counts one live seat"  "1"  "$(field_of seats "$p")"
check "clean fleet finds its prompt"      "1"  "$(field_of prompts "$p")"
check "clean fleet carries no figures"    "0"  "$(field_of figures "$p")"
check "clean fleet exits ok"              "0"  "$(exit_of "$p")"
check "clean fleet verdict"               "ok" "$(field_of verdict "$p")"

# -- 2. a module count is a measurement ----------------------------------------------------------
p=$(mkfleet modules)
printf 'It holds 10 Rye modules.\n' >> "$(prompt_of "$p" alpha)"
check "a module count is read"            "1" "$(field_of figures "$p")"
# `sed -i` has no portable spelling -- GNU takes no argument and BSD requires a backup suffix -- so
# the tree's own helper writes a temporary and copies back through the original inode, which also
# keeps the mode the repository tracks (`.claude/rules/exec-bit.md`).
sed_inplace 's/It holds 10 Rye modules\.//' "$(prompt_of "$p" alpha)"
check "and removing it lifts the reading" "0" "$(field_of figures "$p")"

# -- 3. a line count is a measurement, and a thousands comma is ONE figure ------------------------
p=$(mkfleet lines)
printf 'It holds 3,861 lines.\n' >> "$(prompt_of "$p" alpha)"
check "a line count is read"              "1" "$(field_of figures "$p")"
check "a thousands comma is one figure"   "1" "$(details_of "$p")"

# -- 4. a witness count is a measurement, spelled or in digits -----------------------------------
p=$(mkfleet witnesses)
printf 'It has 16 witnesses.\n' >> "$(prompt_of "$p" alpha)"
check "a digit witness count is read"     "1" "$(field_of figures "$p")"
p=$(mkfleet spelled)
printf 'Guarded by four rostered witnesses.\n' >> "$(prompt_of "$p" alpha)"
check "a spelled witness count is read"   "1" "$(field_of figures "$p")"

# -- 5. A RATE IS A LAW; A TOTAL IS A MEASUREMENT -------------------------------------------------
p=$(mkfleet rate)
printf 'Write Rye under TAME: two asserts a function.\n' >> "$(prompt_of "$p" alpha)"
check "a law-rate is seen as a rate"      "1" "$(field_of rates "$p")"
check "and is excluded from the count"    "0" "$(field_of figures "$p")"
check "and is named in no figure detail"  "0" "$(details_of "$p")"

# -- 6. the floor, named rather than hidden -------------------------------------------------------
p=$(mkfleet article)
printf "The seams where one module's meaning reaches another.\n" >> "$(prompt_of "$p" alpha)"
check "a possessive is an article"        "0" "$(field_of figures "$p")"
p=$(mkfleet instruction)
printf 'Read the newest shelf and its top three rows.\n' >> "$(prompt_of "$p" alpha)"
check "an instruction quantity is not read" "0" "$(field_of figures "$p")"

# -- 7. digits that are not measurements ----------------------------------------------------------
p=$(mkfleet digits)
printf 'Seated 20260905.164639, and REDS %%291 governs it, port 38495.\n' >> "$(prompt_of "$p" alpha)"
check "a stamp, a row number and a port" "0" "$(field_of figures "$p")"

# -- 8. a parked seat is not read -----------------------------------------------------------------
p=$(mkfleet parked)
printf 'It holds 99 modules.\n' >> "$(prompt_of "$p" zulu)"
check "a parked seat's prompt is skipped" "0" "$(field_of figures "$p")"
check "and the parked seat is uncounted"  "1" "$(field_of seats "$p")"

# -- 9. a live seat with no prompt is missing, never a figure --------------------------------------
p=$(mkfleet absent)
rm -f "$(prompt_of "$p" alpha)"
check "an absent prompt counts missing"   "1" "$(field_of missing "$p")"
check "and finds no prompt"               "0" "$(field_of prompts "$p")"
check "and adds no figure"                "0" "$(field_of figures "$p")"

# -- 10. --seat reads exactly one seat --------------------------------------------------------------
p=$(mkfleet oneseat)
printf 'It holds 10 Rye modules.\n' >> "$(prompt_of "$p" alpha)"
check "--seat alpha reads it" "1" "$(sh "$SCAN" "$p" --seat alpha 2>/dev/null | sed -n 's/^figures=//p')"
check "--seat zulu reads none" "0" "$(sh "$SCAN" "$p" --seat zulu 2>/dev/null | sed -n 's/^seats=//p')"

# -- 11. an unreadable roster answers misread, never zero -------------------------------------------
p=$(mkfleet noroster)
rm -f "$p/construction/fleet-roster.kyri"
check "an absent roster is misread" "misread" "$(field_of verdict "$p")"
check "and exits 2"                 "2"       "$(exit_of "$p")"

# -- 12. every counted figure is named ---------------------------------------------------------------
p=$(mkfleet detail)
printf 'It holds 10 Rye modules and 3,861 lines and 16 witnesses.\n' >> "$(prompt_of "$p" alpha)"
check "three figures counted"  "3" "$(field_of figures "$p")"
check "three figures named"    "3" "$(details_of "$p")"

# -- 13. the pen is proven innocent -------------------------------------------------------------------
LIAR="$PEN/liar_scan.sh"
sed 's/^  figures=\$((figures + a))$/  figures=$((figures + 0))/' "$SCAN" > "$LIAR"
if [ ! -s "$LIAR" ] || cmp -s "$LIAR" "$SCAN"; then
  behaviors=$((behaviors + 1))
  # An unreadable source leaves an EMPTY copy, which differs from the original and would read as a
  # landed patch -- so emptiness is checked before difference.
  echo "  FAIL innocence patch matched nothing -- the liar scan is empty or byte-identical"
  failed=$((failed + 1))
else
  echo "  ok   innocence patch landed"
  p=$(mkfleet innocence)
  printf 'It holds 10 Rye modules.\n' >> "$(prompt_of "$p" alpha)"
  check "liar scan reads zero"   "0" "$(field_of figures "$p" "$LIAR")"
  check "real scan reads one"    "1" "$(field_of figures "$p")"
fi

echo "behaviors=$behaviors"
echo "failed=$failed"
if [ "$failed" -ne 0 ]; then
  echo "verdict=control_failed"
  exit 1
fi
echo "verdict=ok"
