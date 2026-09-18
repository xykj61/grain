#!/bin/sh
# tools/fixtures/m/mantra_head_door_cost_control.sh -- every class planted, every rule priced.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_head_door_cost_scan.sh counts both sides of the
# falsifier written into active-designing/20260916-105110_no-anchor-names-the-head.md. This
# control plants one site of each class into a copy of the module room, plants three shapes of
# design page, and strikes two rules out of a copy of the scan itself -- watching each reading
# move exactly where the scan's header says it will.
#
# THE PEN COPIES THE SOURCE ROOM WITH ITS SYMLINKS DEREFERENCED. mantra/src/ reaches tally through
# three relative symlinks, and while this scan never builds, `cp -a` would leave them dangling and
# a later reader of this pen would meet the same false catch the record-column control met.
# `cp -aL` costs nothing here and keeps the pen honest for whoever extends it.
#
# THE ORDERING LEG IS THE ONE WORTH READING. `var at: u32 = @intCast(lines.items.len)` matches the
# free rule AND the alloc rule, and it is an insertion index rather than an allocation. The scan
# tests free first. The `alloc_first` mutation swaps those two rules and asserts that one site
# crosses the gate -- so the order is priced rather than merely asserted in a comment.
#
# EXPECTED: clean_exit=0, every planted class counted, both mutations biting, control_failed=0.
#
# Run from the repository root:
#   sh tools/fixtures/m/mantra_head_door_cost_control.sh

set -eu

_sp_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_sp_steps=0
while [ ! -d "$_sp_root/rishi/src" ] || [ ! -d "$_sp_root/tools/fixtures" ]; do
  _sp_steps=$((_sp_steps + 1))
  if [ "$_sp_steps" -gt 8 ] || [ "$_sp_root" = "/" ] || [ -z "$_sp_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _sp_root=$(dirname "$_sp_root")
done
. "$_sp_root/tools/fixtures/s/shell_portable.sh"

root="$(pwd)"
scan="$root/tools/fixtures/m/mantra_head_door_cost_scan.sh"
paper="$root/active-designing/20260916-105110_no-anchor-names-the-head.md"
# THE PEN SITS INSIDE THIS TREE, under the lap's own gitignored scratch room. A mutated copy of
# the scan has to find a tree root within eight steps of itself, and a copy in /tmp finds none --
# so a mutation run there refuses at its first line and reads exactly like a mutation that bit.
mkdir -p "$root/.lap"
work="$(mktemp -d "$root/.lap/head-door-XXXXXX")"
trap 'rm -rf "$work"' EXIT

legs_ran=0
legs_failed=0
leg() {
  name="$1"; want="$2"; got="$3"
  legs_ran=$((legs_ran + 1))
  if [ "$got" = "$want" ]; then
    echo "$name=ok"
  else
    echo "$name=FAILED want=$want got=$got"
    legs_failed=$((legs_failed + 1))
  fi
}

read_key() { grep -E "^$2=" "$1" | head -1 | cut -d= -f2-; }

# --- the clean pen, which every later reading is measured against ---
pen="$work/src"
cp -aL "$root/mantra/src" "$pen"
sh "$scan" "$paper" "$pen" > "$work/clean.txt" 2>&1
clean_exit=$?
leg clean_exit 0 "$clean_exit"
leg clean_verdict ok "$(read_key "$work/clean.txt" verdict)"

c_free=$(read_key "$work/clean.txt" doorc_free)
c_ext=$(read_key "$work/clean.txt" doorc_external)
c_alloc=$(read_key "$work/clean.txt" doorc_alloc)
c_must=$(read_key "$work/clean.txt" doorc_must_learn)
c_ord=$(read_key "$work/clean.txt" doorb_ord_sites_code)
c_ordall=$(read_key "$work/clean.txt" doorb_ord_sites_all)
c_cons=$(read_key "$work/clean.txt" doorb_place_constructions)
c_same=$(read_key "$work/clean.txt" doorb_same_unit)
echo "clean_free=$c_free clean_external=$c_ext clean_alloc=$c_alloc clean_must_learn=$c_must"
echo "clean_ord_code=$c_ord clean_constructions=$c_cons clean_same_unit=$c_same"
leg clean_unclassified 0 "$(read_key "$work/clean.txt" doorc_unclassified)"

# --- one site of each Door C class, planted one at a time ---
plant_src() {
  rm -rf "$work/p"; cp -aL "$root/mantra/src" "$work/p"
  printf '%s\n' "$1" >> "$work/p/weave.rye"
  sh "$scan" "$paper" "$work/p" > "$work/p.txt" 2>&1 || true
}

plant_src '            if (self.lines.items.len > max_weave_lines) return WeaveError.TooManyLines;'
leg plant_external_counted "$((c_ext + 1))" "$(read_key "$work/p.txt" doorc_external)"
leg plant_external_must_learn "$((c_must + 1))" "$(read_key "$work/p.txt" doorc_must_learn)"

plant_src '            const n: u32 = @intCast(self.lines.items.len);'
leg plant_alloc_counted "$((c_alloc + 1))" "$(read_key "$work/p.txt" doorc_alloc)"
leg plant_alloc_must_learn "$((c_must + 1))" "$(read_key "$work/p.txt" doorc_must_learn)"

plant_src '            if (i + 1 < self.lines.items.len) continue;'
leg plant_free_counted "$((c_free + 1))" "$(read_key "$work/p.txt" doorc_free)"
leg plant_free_travels "$c_must" "$(read_key "$work/p.txt" doorc_must_learn)"

plant_src '            const shape = self.lines.items.len;'
leg plant_unclassified_counted 1 "$(read_key "$work/p.txt" doorc_unclassified)"
leg plant_unclassified_reds red "$(read_key "$work/p.txt" verdict)"

# --- Door B's two shapes, planted one at a time ---
plant_src '            const k = held.ord;'
leg plant_ord_counted "$((c_ord + 1))" "$(read_key "$work/p.txt" doorb_ord_sites_code)"
leg plant_ord_same_unit "$((c_same + 1))" "$(read_key "$work/p.txt" doorb_same_unit)"

plant_src '            const p = .{ .run = 0, .site = 0, .pos = 0, .ord = 0 };'
leg plant_construction_counted "$((c_cons + 1))" "$(read_key "$work/p.txt" doorb_place_constructions)"

# A `.ord` inside a comment needs no edit to keep compiling, so it must raise the ALL reading and
# leave the CODE reading exactly where it stood. Both halves are asserted, since a rule proven
# only in the direction that rises cannot be told from a rule that counts everything.
plant_src '            // the .ord field is what orders a line'
leg plant_comment_ord_all "$((c_ordall + 1))" "$(read_key "$work/p.txt" doorb_ord_sites_all)"
leg plant_comment_ord_code "$c_ord" "$(read_key "$work/p.txt" doorb_ord_sites_code)"

# --- the page, in three shapes ---
page_as() {
  sed "$1" "$paper" > "$work/page.md"
  sh "$scan" "$work/page.md" "$pen" > "$work/page.txt" 2>&1 || true
}

page_as 's/the 12 place constructions/the 40 place constructions/'
leg page_threshold_read 40 "$(read_key "$work/page.txt" paper_threshold)"
leg page_threshold_lifts_falsifier no "$(read_key "$work/page.txt" falsifier_fires)"

page_as 's/the 12 place constructions/the 6 place constructions/'
leg page_unit_reproduces yes "$(read_key "$work/page.txt" paper_unit_reproduces)"

page_as 's/the 12 place constructions/the place constructions/'
leg page_threshold_absent absent "$(read_key "$work/page.txt" paper_threshold)"
leg page_threshold_absent_reds red "$(read_key "$work/page.txt" verdict)"

# A page this tree does not carry is refused rather than read as a page stating nothing.
sh "$scan" "$work/no-such-page.md" "$pen" > "$work/missing.txt" 2>&1 || true
leg page_missing_refused no "$(read_key "$work/missing.txt" paper_readable)"

# --- the mutations, one per rule whose removal a reader could not otherwise notice ---

# Strike the free rule. The insertion index falls through to the alloc rule, and the four
# adjacency walks match no rule at all -- so the scan reports them UNCLASSIFIED and reds, rather
# than quietly counting them as a cost. A rule removed should leave a hole a reader can see.
awk '/\{ free\+\+;/ { next } { print }' "$scan" > "$work/mut.sh"
sh "$work/mut.sh" "$paper" "$pen" > "$work/mut.txt" 2>&1 || true
leg no_free_rule_unclassified 4 "$(read_key "$work/mut.txt" doorc_unclassified)"
leg no_free_rule_reds red "$(read_key "$work/mut.txt" verdict)"
leg no_free_rule_biting "$((c_must + 1))" "$(read_key "$work/mut.txt" doorc_must_learn)"

# Swap the free and alloc rules: exactly the one site matching both crosses the gate. This is the
# ordering the scan's header calls load-bearing, priced rather than asserted.
awk '/\{ free\+\+;/ { held=$0; next } /\{ alloc\+\+;/ { print; if (held != "") { print held; held="" } next } { print }' "$scan" > "$work/mut.sh"
sh "$work/mut.sh" "$paper" "$pen" > "$work/mut.txt" 2>&1 || true
leg alloc_first_free "$((c_free - 1))" "$(read_key "$work/mut.txt" doorc_free)"
leg alloc_first_biting "$((c_must + 1))" "$(read_key "$work/mut.txt" doorc_must_learn)"

echo "legs_ran=$legs_ran"
echo "control_failed=$legs_failed"
if [ "$legs_failed" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
