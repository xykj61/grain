#!/bin/sh
# tools/fixtures/t/tame_core_surface_scan.sh -- the law page's declared audit is an audit that runs.
#
# WHY. `context/TAME_CORE.md` is the compressed core of TAME, written to ride in the agent rules
# so it is present every time family-language code is written. It closes on a table titled "The
# checkable surface" naming the tools that stand over those reflexes, and it states in its own
# words: "Every tool below sits on `construction/standing-equipment.kyri`, so a roster pass runs
# it whether or not a hand remembers to."
#
# On 20260908.111848 that sentence was false for three of the five tools the table then named.
# `rune_assert_sweep` was rostered by nobody; `opening_lines_witness` and `tame-check` stood on
# the supplement's lint table and nowhere else. All three were GREEN the hour they were seated,
# so the loss was hearing rather than health -- and the roster's own note on that repair names
# the instrument that was missing: an aggregate ratchet answers "how many runners does no lap
# reach", and cannot answer "is the tool this law page declares as its checkable surface one of
# them". Two questions, one number, and only the first was being asked.
#
# That repair was made by hand, and nothing holds it. A row added to the table tomorrow can be
# unrostered the same way, and every standing guard stays green -- which is a fence post firm to
# the eye and loose to the hand.
#
# WHAT IS GATED, hard, all three at zero.
#   Every tool the table names exists on disk.
#   Every tool the table names carries a `path` row in `construction/standing-equipment.kyri`,
#   so a roster pass runs it whether or not a hand remembers to.
#   Every tool's declared Clock matches the roster's own `tier` for that guard. A tier absent
#   from a block means `lap`, which is the roster's own rule and this reading honors it.
#
# WHAT IS NOT PROVEN. That a tool reads what its Reads column claims, that the table names every
# tool it ought to, or that a rostered guard is green. Only that the page's own declaration and
# the roster agree -- the claim, pressed where the claim is made.
#
# USAGE
#   sh tools/fixtures/t/tame_core_surface_scan.sh [core_page] [roster]
#
# Driven by tools/t/tame_core_surface_witness.rish. Run from the repository root.

set -u

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

core=${1:-context/TAME_CORE.md}
roster=${2:-construction/standing-equipment.kyri}

if [ ! -f "$core" ]; then
  echo "core_page_missing=$core"
  echo "verdict=core_page_missing"
  echo "refused: the page whose claim this reads is absent" >&2
  exit 1
fi
if [ ! -f "$roster" ]; then
  echo "roster_missing=$roster"
  echo "verdict=roster_missing"
  echo "refused: the roster this claim points at is absent" >&2
  exit 1
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The declared surface: the table under the checkable-surface heading, read to the next heading.
# Field one is a backticked tool path; field three is the declared clock. A delimiter row and the
# header row both fail the backticked-path test, so neither needs naming here.
awk '
  /^## / { inside = ($0 ~ /checkable surface/) ? 1 : 0; next }
  inside && /^\|/ {
    n = split($0, f, /\|/)
    if (n < 4) next
    tool = f[2]; clock = f[4]
    gsub(/^[ \t]+|[ \t]+$/, "", tool);  gsub(/`/, "", tool)
    gsub(/^[ \t]+|[ \t]+$/, "", clock); gsub(/`/, "", clock)
    if (tool !~ /^tools\//) next
    if (clock == "") clock = "lap"
    print tool "\t" clock
  }' "$core" > "$work/declared.tsv"

# The roster, block by block. Blocks are blank-line separated; within one, `path` names the tool
# and `tier` names its clock. A tier absent means `lap` -- the card's own rule, so a block that
# declines to write the common case is read as the common case rather than as a disagreement.
awk '
  function flush() {
    if (p != "") print p "\t" (t == "" ? "lap" : t)
    p = ""; t = ""
  }
  /^[ \t]*$/ { flush(); next }
  /^[ \t]*#/ { next }
  {
    line = $0
    sub(/#.*$/, "", line)
    gsub(/^[ \t]+|[ \t]+$/, "", line)
    if (line ~ /^path /)  { p = substr(line, 6); gsub(/^[ \t]+|[ \t]+$/, "", p) }
    if (line ~ /^tier /)  { t = substr(line, 6); gsub(/^[ \t]+|[ \t]+$/, "", t) }
  }
  END { flush() }' "$roster" > "$work/rostered.tsv"

: > "$work/absent.txt"
: > "$work/unrostered.txt"
: > "$work/clock.txt"

while IFS="	" read -r tool clock; do
  [ -n "$tool" ] || continue
  [ -f "$tool" ] || echo "$tool" >> "$work/absent.txt"
  seat=$(awk -F'\t' -v want="$tool" '$1 == want { print $2; exit }' "$work/rostered.tsv")
  if [ -z "$seat" ]; then
    echo "$tool" >> "$work/unrostered.txt"
  elif [ "$seat" != "$clock" ]; then
    echo "$tool declared=$clock roster=$seat" >> "$work/clock.txt"
  fi
done < "$work/declared.tsv"

declared=$(wc -l < "$work/declared.tsv" | tr -d ' ')
absent=$(wc -l < "$work/absent.txt" | tr -d ' ')
unrostered=$(wc -l < "$work/unrostered.txt" | tr -d ' ')
clocks=$(wc -l < "$work/clock.txt" | tr -d ' ')

echo "core_page=$core"
echo "roster=$roster"
echo "roster_guards=$(wc -l < "$work/rostered.tsv" | tr -d ' ')"
echo "declared_surface_tools=$declared"
echo "declared_absent_on_disk=$absent"
echo "declared_unrostered=$unrostered"
echo "declared_clock_disagreements=$clocks"

[ "$absent" -eq 0 ] || sed 's/^/absent: /' "$work/absent.txt"
[ "$unrostered" -eq 0 ] || sed 's/^/unrostered: /' "$work/unrostered.txt"
[ "$clocks" -eq 0 ] || sed 's/^/clock: /' "$work/clock.txt"

# A table that names nothing is a claim nobody can check, and it must not read as a pass.
if [ "$declared" -eq 0 ]; then
  echo "verdict=surface_empty"
  echo "refused: the checkable-surface table names no tool -- a green here would prove nothing" >&2
  exit 1
fi

if [ "$absent" -eq 0 ] && [ "$unrostered" -eq 0 ] && [ "$clocks" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=surface_unheard"
echo "refused: a tool the law page declares as its checkable surface is not one a lap runs" >&2
exit 1
