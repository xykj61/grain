#!/bin/sh
# tools/fixtures/t/tame_core_surface_control.sh -- proves the surface reading from both sides.
#
# A refusal shown only in the passing direction cannot be told from a bypass, so every plant here
# is counted while it stands and read back to zero once it is lifted. The pens are throwaway
# directories holding a two-line core page and a small roster; nothing here touches the tree.
#
# USAGE
#   sh tools/fixtures/t/tame_core_surface_control.sh
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
scan="$_fd_root/tools/fixtures/t/tame_core_surface_scan.sh"

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
fails=0
note() { printf '%s=%s\n' "$1" "$2"; [ "$2" = yes ] || fails=$((fails + 1)); }

# Every pen is a tree root of its own, so the scan's upward walk stops inside it rather than
# climbing back out into the repository it was launched from.
mkpen() {
  d="$pen/$1"; rm -rf "$d"; mkdir -p "$d/rishi/bin" "$d/tools/fixtures/t" "$d/context" "$d/construction"
  printf 'x\n' > "$d/tools/one.rish"
  printf 'x\n' > "$d/tools/two.rish"
  echo "$d"
}

core_head='## The checkable surface -- what stands, on which clock, over what

| Tool | Reads | Clock |
|---|---|---|'

# --- a pen where the page and the roster agree ----------------------------------------------
d=$(mkpen agree)
printf '%s\n| `tools/one.rish` | one thing | lap |\n| `tools/two.rish` | another | cadence |\n\n## Crash headroom\n' "$core_head" > "$d/context/TAME_CORE.md"
printf 'guard one\npath tools/one.rish\ntier lap\n\nguard two\npath tools/two.rish\ntier cadence\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note agree_free $([ $rc -eq 0 ] && echo yes || echo no)
note agree_verdict_ok $(echo "$out" | grep -q '^verdict=ok$' && echo yes || echo no)
note declared_counted_exactly $(echo "$out" | grep -q '^declared_surface_tools=2$' && echo yes || echo no)
note clean_absent_zero $(echo "$out" | grep -q '^declared_absent_on_disk=0$' && echo yes || echo no)
note clean_unrostered_zero $(echo "$out" | grep -q '^declared_unrostered=0$' && echo yes || echo no)
note clean_clocks_zero $(echo "$out" | grep -q '^declared_clock_disagreements=0$' && echo yes || echo no)

# --- the fault the repair of 20260908 fixed by hand: a declared tool nobody rosters -----------
d=$(mkpen unrostered)
printf '%s\n| `tools/one.rish` | one thing | lap |\n| `tools/two.rish` | another | lap |\n' "$core_head" > "$d/context/TAME_CORE.md"
printf 'guard one\npath tools/one.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note unrostered_refused $([ $rc -ne 0 ] && echo yes || echo no)
note unrostered_counted $(echo "$out" | grep -q '^declared_unrostered=1$' && echo yes || echo no)
note unrostered_named $(echo "$out" | grep -q '^unrostered: tools/two.rish$' && echo yes || echo no)
note unrostered_verdict $(echo "$out" | grep -q '^verdict=surface_unheard$' && echo yes || echo no)
# lifting the plant returns the reading to zero, so the count is of the tree and not of the guard
printf 'guard one\npath tools/one.rish\ntier lap\n\nguard two\npath tools/two.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 )
note unrostered_lifted_zero $(echo "$out" | grep -q '^declared_unrostered=0$' && echo yes || echo no)

# --- a declared tool that is not on disk ------------------------------------------------------
d=$(mkpen absent)
printf '%s\n| `tools/one.rish` | one thing | lap |\n| `tools/gone.rish` | vanished | lap |\n' "$core_head" > "$d/context/TAME_CORE.md"
printf 'guard one\npath tools/one.rish\ntier lap\n\nguard gone\npath tools/gone.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note absent_refused $([ $rc -ne 0 ] && echo yes || echo no)
note absent_counted $(echo "$out" | grep -q '^declared_absent_on_disk=1$' && echo yes || echo no)
note absent_named $(echo "$out" | grep -q '^absent: tools/gone.rish$' && echo yes || echo no)

# --- the clock the page declares disagreeing with the tier the roster keeps --------------------
d=$(mkpen clock)
printf '%s\n| `tools/one.rish` | one thing | cadence |\n' "$core_head" > "$d/context/TAME_CORE.md"
printf 'guard one\npath tools/one.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note clock_refused $([ $rc -ne 0 ] && echo yes || echo no)
note clock_counted $(echo "$out" | grep -q '^declared_clock_disagreements=1$' && echo yes || echo no)
note clock_named_both $(echo "$out" | grep -q '^clock: tools/one.rish declared=cadence roster=lap$' && echo yes || echo no)

# --- a roster block with no tier means lap, which is the roster's own rule ---------------------
d=$(mkpen tierless)
printf '%s\n| `tools/one.rish` | one thing | lap |\n' "$core_head" > "$d/context/TAME_CORE.md"
printf 'guard one\npath tools/one.rish\nseated 20260909.000000\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note tierless_reads_lap_free $([ $rc -eq 0 ] && echo yes || echo no)
# and the same silence disagrees honestly when the page claims cadence
printf '%s\n| `tools/one.rish` | one thing | cadence |\n' "$core_head" > "$d/context/TAME_CORE.md"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note tierless_vs_cadence_refused $([ $rc -ne 0 ] && echo yes || echo no)

# --- a trailing comment on the tier line is a note, never part of the clock --------------------
d=$(mkpen trailing)
printf '%s\n| `tools/one.rish` | one thing | lap |\n' "$core_head" > "$d/context/TAME_CORE.md"
printf 'guard one\npath tools/one.rish\ntier lap       # 7.1s over 1,127 derived files\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note trailing_comment_free $([ $rc -eq 0 ] && echo yes || echo no)

# --- a commented-out roster row rosters nothing ------------------------------------------------
d=$(mkpen commented)
printf '%s\n| `tools/one.rish` | one thing | lap |\n' "$core_head" > "$d/context/TAME_CORE.md"
printf '# path tools/one.rish -- named in prose, seated nowhere\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note commented_row_refused $([ $rc -ne 0 ] && echo yes || echo no)
note commented_row_unrostered $(echo "$out" | grep -q '^declared_unrostered=1$' && echo yes || echo no)

# --- a table elsewhere on the page is not the checkable surface --------------------------------
d=$(mkpen elsewhere)
printf '## Rye reflexes\n\n| Tool | Reads | Clock |\n|---|---|---|\n| `tools/two.rish` | not the surface | lap |\n\n%s\n| `tools/one.rish` | one thing | lap |\n' "$core_head" > "$d/context/TAME_CORE.md"
printf 'guard one\npath tools/one.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note other_table_unread $([ $rc -eq 0 ] && echo yes || echo no)
note other_table_uncounted $(echo "$out" | grep -q '^declared_surface_tools=1$' && echo yes || echo no)

# --- a surface naming nothing must refuse rather than read as a pass ---------------------------
d=$(mkpen empty)
printf '%s\n\n## Crash headroom\n' "$core_head" > "$d/context/TAME_CORE.md"
printf 'guard one\npath tools/one.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note empty_surface_refused $([ $rc -ne 0 ] && echo yes || echo no)
note empty_surface_verdict $(echo "$out" | grep -q '^verdict=surface_empty$' && echo yes || echo no)

# --- an absent input refuses rather than reading zero ------------------------------------------
d=$(mkpen missing)
printf 'guard one\npath tools/one.rish\ntier lap\n' > "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note missing_core_refused $([ $rc -ne 0 ] && echo yes || echo no)
note missing_core_verdict $(echo "$out" | grep -q '^verdict=core_page_missing$' && echo yes || echo no)
printf '%s\n| `tools/one.rish` | one thing | lap |\n' "$core_head" > "$d/context/TAME_CORE.md"
rm -f "$d/construction/standing-equipment.kyri"
out=$( (cd "$d" && sh "$scan") 2>&1 ); rc=$?
note missing_roster_refused $([ $rc -ne 0 ] && echo yes || echo no)
note missing_roster_verdict $(echo "$out" | grep -q '^verdict=roster_missing$' && echo yes || echo no)

echo "control_checks=30"
echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=control_failed"
echo "refused: the control disagrees with itself -- read the no lines above" >&2
exit 1
