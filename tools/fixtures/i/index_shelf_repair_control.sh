#!/bin/sh
# tools/fixtures/i/index_shelf_repair_control.sh -- the shelf repair, proven on real files in a pen.
#
# WHY A CONTROL. This tool rewrites a page of testimony without a hand watching, which is the one
# kind of tool that has to be shown refusing before it is trusted to act. So every refusal below is
# planted and then lifted, every welcome is asserted as hard as every refusal, and the load-bearing
# check -- the permutation postcondition, which is what makes an unattended rewrite safe -- is
# shown from BOTH sides: a copy whose sort drops a line must refuse, and the same copy with the
# postcondition removed must write the shortened page. A check proven only in the passing direction
# cannot be told from a check that has merely started saying yes.
#
# The two mutations are made with tools/fixtures/p/plant.sh, so a line this control names by hand
# and the real file later moves reads `plant_matched_nothing` rather than passing silently
# (REDS %519).
#
# EXPECTED: every behavior satisfied, faults=0, exit 0.
#
# Driven by tools/in/index_row_bound_witness.rish. Run from anywhere.

set -u

_fd_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/p/plant.sh"

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/fixtures/i" "$pen/tools/fixtures/p" "$pen/session-logs/date" "$pen/rishi/bin"
cp "$_fd_root/tools/fixtures/i/index_row_bound_scan.sh" "$pen/tools/fixtures/i/"
cp "$_fd_root/tools/fixtures/i/index_shelf_repair.sh" "$pen/tools/fixtures/i/"
cp "$_fd_root/tools/fixtures/p/plant.sh" "$pen/tools/fixtures/p/"
: > "$pen/session-logs/f.kyri"

behaviors=0
faults=0
note() {
  _label=$1; _got=$2; _want=$3
  behaviors=$((behaviors + 1))
  if [ "$_got" = "$_want" ]; then echo "OK   $_label ($_got)"
  else echo "FAULT $_label -- got '$_got', owed '$_want'"; faults=$((faults + 1)); fi
}

SHELF="$pen/session-logs/date/README-index-20260907.md"
srow() { printf '| `%s` | [t](../f.kyri) | %s |\n' "$1" "$2"; }

pin() {
  { echo "# Session logs"; echo; echo "| Stamp | Log | Meaning |"; echo "|---|---|---|"
    printf '| `20260906.010101` | [t](f.kyri) | a row |\n'; } > "$pen/session-logs/README.md"
}
shelf() {                      # shelf <row-line>...
  { echo "# session-logs day index -- 20260907"; echo
    echo "Prose above the table, which must never move."; echo
    echo "| Stamp | Log | What it recorded |"; echo "|---|---|---|"
    for l in "$@"; do printf '%s\n' "$l"; done; } > "$SHELF"
}
repair() { ( cd "$pen" && INDEX_ROW_ROOT=. sh tools/fixtures/i/index_shelf_repair.sh "$@" 2>&1 ); }
val() { echo "$1" | sed -n "s/^$2=\(.*\)/\1/p" | head -1; }
pin

echo "== 1. a misordered shelf is sorted, and the sort is a permutation =="
shelf "$(srow 20260907.021117 'older, seated on top by a merge')" \
      "$(srow 20260907.023053 'newer, pushed under it')" \
      "$(srow 20260907.013921 'oldest')"
cp "$SHELF" "$pen/before.md"
o=$(repair)
note "sorted_a_misordered_shelf" "$(val "$o" repair)" "sorted"
note "sorted_verdict" "$(val "$o" verdict)" "repaired"
note "newest_now_on_top" \
  "$(awk '/^\|[- |:]*\|[ \t]*$/ { getline; print; exit }' "$SHELF" | sed -n 's/^| `\([0-9.]*\)`.*/\1/p')" \
  "20260907.023053"
note "sort_is_a_permutation" \
  "$(cmp -s "$(LC_ALL=C sort "$pen/before.md" > "$pen/a"; echo "$pen/a")" \
            "$(LC_ALL=C sort "$SHELF" > "$pen/b"; echo "$pen/b")" && echo same || echo differs)" "same"
note "header_and_prose_stand" \
  "$(head -5 "$pen/before.md" > "$pen/ha"; head -5 "$SHELF" > "$pen/hb"; cmp -s "$pen/ha" "$pen/hb" && echo same || echo differs)" "same"

echo
echo "== 2. the repair is idempotent, and an ordered shelf is left alone =="
cp "$SHELF" "$pen/once.md"
o=$(repair)
note "idempotent_reports_none" "$(val "$o" repair)" "none"
note "idempotent_leaves_bytes" "$(cmp -s "$pen/once.md" "$SHELF" && echo same || echo differs)" "same"
note "ordered_shelf_verdict_ok" "$(val "$o" verdict)" "ok"

echo
echo "== 3. --check names the fault and changes nothing =="
shelf "$(srow 20260907.021117 'older')" "$(srow 20260907.023053 'newer')"
cp "$SHELF" "$pen/before.md"
o=$(repair --check); rc=$?
note "check_names_misorder" "$(val "$o" repair)" "would_sort"
note "check_verdict" "$(val "$o" verdict)" "misordered"
note "check_changed_nothing" "$(cmp -s "$pen/before.md" "$SHELF" && echo same || echo differs)" "same"

echo
echo "== 4. the refusals, each with the file untouched =="
shelf "$(srow 20260907.023053 'one')" "$(srow 20260907.023053 'the same stamp again')"
cp "$SHELF" "$pen/before.md"
o=$(repair)
note "duplicate_refused" "$(val "$o" verdict)" "duplicate_stamps"
note "duplicate_left_untouched" "$(cmp -s "$pen/before.md" "$SHELF" && echo same || echo differs)" "same"

shelf "$(srow 20260907.021117 'older')" "| not a stamp cell | [t](../f.kyri) | x |" \
      "$(srow 20260907.023053 'newer')"
cp "$SHELF" "$pen/before.md"
o=$(repair)
note "unstamped_refused" "$(val "$o" verdict)" "unstamped_row"
note "unstamped_left_untouched" "$(cmp -s "$pen/before.md" "$SHELF" && echo same || echo differs)" "same"

{ echo "# no table here"; echo; echo "just prose."; } > "$SHELF"
cp "$SHELF" "$pen/before.md"
o=$(repair)
note "no_delimiter_refused" "$(val "$o" verdict)" "no_delimiter"
note "no_delimiter_left_untouched" "$(cmp -s "$pen/before.md" "$SHELF" && echo same || echo differs)" "same"

echo
echo "== 5. only the OPEN shelf is a target; a closed one is immutable =="
CLOSED="$pen/session-logs/date/README-index-20260906.md"
{ echo "# session-logs day index -- 20260906"; echo
  echo "| Stamp | Log | What it recorded |"; echo "|---|---|---|"
  printf '| `20260906.010101` | [t](../f.kyri) | older on top |\n'
  printf '| `20260906.020202` | [t](../f.kyri) | newer below, and it stays |\n'; } > "$CLOSED"
cp "$CLOSED" "$pen/closed.before.md"
shelf "$(srow 20260907.021117 'older')" "$(srow 20260907.023053 'newer')"
o=$(repair)
note "open_shelf_is_the_newest_day" "$(val "$o" shelf)" "session-logs/date/README-index-20260907.md"
note "closed_shelf_untouched" "$(cmp -s "$pen/closed.before.md" "$CLOSED" && echo same || echo differs)" "same"

echo
echo "== 6. the mode is tracked content, so the write goes through the inode =="
shelf "$(srow 20260907.021117 'older')" "$(srow 20260907.023053 'newer')"
chmod 755 "$SHELF"
repair >/dev/null 2>&1 || true
note "mode_kept_through_the_write" "$([ -x "$SHELF" ] && echo exec || echo plain)" "exec"
chmod 644 "$SHELF"

echo
echo "== 7. the permutation postcondition, shown from both sides =="
# A copy whose sort drops a line. The postcondition must catch it and write nothing.
cp "$_fd_root/tools/fixtures/i/index_shelf_repair.sh" "$pen/tools/fixtures/i/lossy.sh"
# `plant_apply` refuses by name to stderr and returns 1; a `|| echo` fallback would DISCARD that
# refusal and leave the phase testing an unmutated copy, which is the swallowed-instrument shape
# `tools/i/instrument_refusal_witness.rish` holds at zero. So the refusal is counted as a fault.
if ! plant_apply "$pen/tools/fixtures/i/lossy.sh" \
  's|sort -r "$pen/block" >|sort -r "$pen/block" \| sed 1d >|' lossy_sort; then
  note "lossy_plant_landed" "refused" "landed"
fi
shelf "$(srow 20260907.021117 'older')" "$(srow 20260907.023053 'newer')" "$(srow 20260907.013921 'oldest')"
cp "$SHELF" "$pen/before.md"
o=$( ( cd "$pen" && INDEX_ROW_ROOT=. sh tools/fixtures/i/lossy.sh 2>&1 ) )
note "lossy_sort_refused" "$(val "$o" verdict)" "not_a_permutation"
note "lossy_sort_wrote_nothing" "$(cmp -s "$pen/before.md" "$SHELF" && echo same || echo differs)" "same"

# The same copy with the postcondition removed. It must write the shortened page -- which is what
# proves the postcondition above is the thing doing the stopping.
cp "$pen/tools/fixtures/i/lossy.sh" "$pen/tools/fixtures/i/blind.sh"
if ! plant_apply "$pen/tools/fixtures/i/blind.sh" \
  's|^if ! cmp -s "$pen/before.keyed" "$pen/after.keyed"; then$|if false; then|' blind_postcondition; then
  note "blind_plant_landed" "refused" "landed"
fi
cp "$pen/before.md" "$SHELF"
o=$( ( cd "$pen" && INDEX_ROW_ROOT=. sh tools/fixtures/i/blind.sh 2>&1 ) )
note "blind_copy_writes_the_loss" "$(val "$o" repair)" "sorted"
note "blind_copy_lost_a_row" "$([ "$(grep -c '^|' "$SHELF")" -lt "$(grep -c '^|' "$pen/before.md")" ] && echo shorter || echo whole)" "shorter"

echo
echo "behaviors=$behaviors"
echo "faults=$faults"
if [ "$faults" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=faults"
exit 1
