#!/bin/sh
# tools/fixtures/d/door_home_control.sh -- proves tools/fixtures/d/door_home_scan.sh on real
# trees in a throwaway pen, every refusal planted and then lifted.
#
#   sh tools/fixtures/d/door_home_control.sh
#
# The centrepiece is the ANCHOR. The scan reads a door's home clause from the key's own opening
# rather than searching its sentence for the words `home is`, because a door's third clause ends
# with those same two words -- `the whole path from nothing to a signed, sandboxed home is`. With
# the anchor struck out, the living tree reports 106 off doors against 117, every name wrong. So
# the pen builds a door carrying both occurrences, proves it walks free, and then strikes the
# anchor out of a copy of the scan and proves that same door refuses.
#
# A refusal proven only in the passing direction cannot be told from a bypass, so every plant is
# lifted and the reading asserted again.

set -u

scan=$(pwd)/tools/fixtures/d/door_home_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

# The plant law, imported rather than re-spelled: a mutation that matched nothing reads exactly
# like a clause that holds (REDS %519).
. "$(pwd)/tools/fixtures/p/plant.sh"

legs=0
failed=0
leg() {
  legs=$((legs + 1))
  if [ "$2" = yes ]; then
    echo "$1=yes"
  else
    failed=$((failed + 1))
    echo "$1=no"
  fi
}

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# A pen is a real git repository, since the scan's population comes from `git ls-files`.
fresh() {
  d=$pen/$1
  rm -rf "$d"; mkdir -p "$d"
  ( cd "$d" && git init -q . && git config user.email pen@example.invalid && git config user.name pen )
  mkdir -p "$d/docs-geode/tutorials"
  printf '# home\n' > "$d/README.md"
  printf '# source\n' > "$d/SOURCE.md"
  printf '# first hour\n' > "$d/docs-geode/tutorials/the-first-hour.md"
  echo "$d"
}

# Write a page carrying the key, at whatever depth, with the home target given verbatim.
door() {
  _d=$1; _path=$2; _home=$3
  mkdir -p "$(dirname "$_d/$_path")"
  printf '# page\n\n**Where this sits:** home is [`%s`](%s)\n' "$_home" "$_home" > "$_d/$_path"
}

seal() { ( cd "$1" && git add -A && git commit -qm pen ); }

run() { ( cd "$1" && shift; sh "$scan" "$@" 2>/dev/null ); }

# --- 1. a clean door at the root walks free -------------------------------------------------
d=$(fresh clean)
door "$d" GUIDE.md README.md
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'doors=1' && leg clean_door_counted yes || leg clean_door_counted no
echo "$out" | grep -q 'home_on=1 home_off=0' && leg clean_door_on yes || leg clean_door_on no
echo "$out" | grep -q 'verdict=ok' && leg clean_door_free yes || leg clean_door_free no

# --- 2. the founding case: a door one room deep whose ../README.md is a real non-home page ---
# This is the fault no standing guard can see. The target RESOLVES, is TRACKED, and opens; it is
# simply not home. `tracked_link_scan` calls it fine and the link-text guard calls it fine.
d=$(fresh shadow)
mkdir -p "$d/room"
printf '# not home\n' > "$d/room/README.md"
door "$d" room/deep/page.md ../README.md
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'home_off=1' && leg shadow_readme_off yes || leg shadow_readme_off no
echo "$out" | grep -q 'verdict=home_off' && leg shadow_readme_refuses yes || leg shadow_readme_refuses no
echo "$out" | grep -q 'detail: room/deep/page.md says where home is' && leg shadow_readme_named yes || leg shadow_readme_named no
# the target really does resolve to a real tracked file -- the whole point of the leg
[ -f "$d/room/README.md" ] && leg shadow_target_is_real yes || leg shadow_target_is_real no

# --- 3. lifting the plant returns the same pen to green -------------------------------------
door "$d" room/deep/page.md ../../README.md
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'home_on=1 home_off=0' && leg shadow_lifted_on yes || leg shadow_lifted_on no
echo "$out" | grep -q 'verdict=ok' && leg shadow_lifted_free yes || leg shadow_lifted_free no

# --- 4. a deep door with the right number of steps walks free -------------------------------
d=$(fresh deep)
door "$d" a/b/c/page.md ../../../README.md
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'home_on=1 home_off=0' && leg deep_door_on yes || leg deep_door_on no
echo "$out" | grep -q 'verdict=ok' && leg deep_door_free yes || leg deep_door_free no

# --- 5. a home link pointing at nothing at all refuses ---------------------------------------
d=$(fresh missing)
door "$d" page.md ../outside/README.md
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'home_off=1' && leg missing_target_off yes || leg missing_target_off no
echo "$out" | grep -q 'verdict=home_off' && leg missing_target_refuses yes || leg missing_target_refuses no

# --- 6. THE ANCHOR --------------------------------------------------------------------------
# A door carrying the full three-clause sentence: home first, and the third clause ending in the
# same two words. Its home clause is correct, so it must walk free.
d=$(fresh anchor)
mkdir -p "$d/room"
{
  printf '# page\n\n'
  printf '**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is\n'
  printf '[`../docs-geode/tutorials/the-first-hour.md`](../docs-geode/tutorials/the-first-hour.md) - the whole\n'
  printf 'path from nothing to a signed, sandboxed home is [`../SOURCE.md`](../SOURCE.md)\n'
} > "$d/room/page.md"
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'home_on=1 home_off=0' && leg anchor_home_on yes || leg anchor_home_on no
echo "$out" | grep -q 'verdict=ok' && leg anchor_free yes || leg anchor_free no
# and the BLOCK reading is what found the other two clauses, wrapped onto continuation lines
echo "$out" | grep -q 'first_hour_on=1' && leg block_finds_wrapped_first_hour yes || leg block_finds_wrapped_first_hour no
echo "$out" | grep -q 'source_on=1' && leg block_finds_wrapped_source yes || leg block_finds_wrapped_source no
# the second `home is` really is present -- a plant that planted nothing proves nothing
grep -q 'sandboxed home is' "$d/room/page.md" && leg anchor_plant_present yes || leg anchor_plant_present no

# --- 7. MUTATION: strike the anchor, and that same door refuses ------------------------------
if plant_write "$scan" "$pen/mut_anchor.sh" 's|s/\^\\\*\\\*Where this sits:\\\*\\\* \*home is|s/.*home is|' anchor_unanchored; then
  out=$( cd "$d" && sh "$pen/mut_anchor.sh" 2>/dev/null )
  echo "$out" | grep -q 'home_off=1' && leg mutation_anchor_bites yes || leg mutation_anchor_bites no
  echo "$out" | grep -q 'verdict=home_off' && leg mutation_anchor_refuses yes || leg mutation_anchor_refuses no
else
  leg mutation_anchor_bites no; leg mutation_anchor_refuses no
fi

# --- 8. MUTATION: read one line rather than the block ---------------------------------------
# The wrapped clauses vanish, which on the living tree turns 110 first-hour readings into 4.
if plant_write "$scan" "$pen/mut_block.sh" 's|^    inb { printf "%s ", \$0 }|    inb { exit }|' block_single_line; then
  out=$( cd "$d" && sh "$pen/mut_block.sh" 2>/dev/null )
  echo "$out" | grep -q 'first_hour_absent=1' && leg mutation_block_bites yes || leg mutation_block_bites no
else
  leg mutation_block_bites no
fi

# --- 9. a door naming no home is counted and never gated ------------------------------------
d=$(fresh nohome)
mkdir -p "$d/room"
printf '# page\n\n**Where this sits:** the room map is [`../README.md`](../README.md)\n' > "$d/room/page.md"
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'home_absent=1' && leg absent_home_counted yes || leg absent_home_counted no
echo "$out" | grep -q 'verdict=ok' && leg absent_home_free yes || leg absent_home_free no
echo "$out" | grep -q 'detail: room/page.md carries the key and names no home' && leg absent_home_named yes || leg absent_home_named no

# --- 10. the two optional clauses: written, pointing wrong, reported, refusing nothing -------
d=$(fresh optional)
mkdir -p "$d/room"
{
  printf '# page\n\n'
  printf '**Where this sits:** home is [`../README.md`](../README.md) - a first hour in your hands is\n'
  printf '[`../SOURCE.md`](../SOURCE.md) - the whole path from nothing to a signed, sandboxed home is\n'
  printf '[`../README.md`](../README.md)\n'
} > "$d/room/page.md"
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'first_hour_off=1' && leg optional_first_hour_off yes || leg optional_first_hour_off no
echo "$out" | grep -q 'source_off=1' && leg optional_source_off yes || leg optional_source_off no
echo "$out" | grep -q 'verdict=ok' && leg optional_never_gates yes || leg optional_never_gates no
echo "$out" | grep -q 'detail: room/page.md names a first hour that is not the tutorial' && leg optional_first_hour_named yes || leg optional_first_hour_named no
echo "$out" | grep -q 'detail: room/page.md names a whole path that is not SOURCE.md' && leg optional_source_named yes || leg optional_source_named no

# --- 11. testimony is read past, in all four spellings ---------------------------------------
# A broken door inside dated testimony must leave the gate alone; accrete-never-break outranks it.
d=$(fresh testimony)
door "$d" date/20260101/page.md ../../nowhere/README.md
door "$d" archive/page.md ../nowhere/README.md
door "$d" yonder/page.md ../nowhere/README.md
door "$d" room/20260101-010101_sprig.md ../nowhere/README.md
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'doors=0' && leg testimony_read_past yes || leg testimony_read_past no
echo "$out" | grep -q 'verdict=ok' && leg testimony_free yes || leg testimony_free no

# --- 12. the same broken door, living, refuses -- so leg 11 proves an exclusion, not an absence
d=$(fresh testimony_lifted)
door "$d" room/page.md ../nowhere/README.md
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'doors=1' && leg testimony_lifted_counted yes || leg testimony_lifted_counted no
echo "$out" | grep -q 'verdict=home_off' && leg testimony_lifted_refuses yes || leg testimony_lifted_refuses no

# --- 13. a page with no key is no door -------------------------------------------------------
d=$(fresh nokey)
printf '# page\n\nordinary prose naming home is [`elsewhere`](elsewhere.md)\n' > "$d/page.md"
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'doors=0' && leg no_key_no_door yes || leg no_key_no_door no
echo "$out" | grep -q 'verdict=ok' && leg no_key_free yes || leg no_key_free no

# --- 14. an untracked page is no door --------------------------------------------------------
d=$(fresh untracked)
door "$d" tracked.md README.md
seal "$d"
door "$d" loose.md ../nowhere/README.md
out=$(run "$d")
echo "$out" | grep -q 'doors=1' && leg untracked_read_past yes || leg untracked_read_past no
echo "$out" | grep -q 'verdict=ok' && leg untracked_free yes || leg untracked_free no

# --- 15. a tree with no root README refuses rather than calling every door off ---------------
d=$(fresh noroot)
door "$d" page.md README.md
rm -f "$d/README.md"
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'verdict=no_home_page' && leg no_root_refuses yes || leg no_root_refuses no

# --- 16. the door bound refuses rather than truncating ---------------------------------------
d=$(fresh bound)
door "$d" one.md README.md
door "$d" two.md README.md
seal "$d"
out=$( cd "$d" && DOOR_HOME_MAX=1 sh "$scan" 2>/dev/null )
echo "$out" | grep -q 'verdict=door_bound' && leg bound_refuses yes || leg bound_refuses no
out=$( cd "$d" && DOOR_HOME_MAX=2 sh "$scan" 2>/dev/null )
echo "$out" | grep -q 'verdict=ok' && leg bound_at_the_bound_free yes || leg bound_at_the_bound_free no

# --- 17. --list names the pages, and an unknown argument refuses -----------------------------
d=$(fresh listing)
door "$d" room/page.md ../nowhere/README.md
seal "$d"
out=$(run "$d" --list)
echo "$out" | grep -q 'list: home_off room/page.md' && leg list_names_page yes || leg list_names_page no
out=$( cd "$d" && sh "$scan" --bogus 2>/dev/null )
echo "$out" | grep -q 'verdict=bad_argument' && leg bad_argument_refuses yes || leg bad_argument_refuses no

# --- 18. a home clause resolving to the root README by a longer walk still reads home --------
# Resolution is by real path, so `../room/../README.md` is home exactly as `../README.md` is.
d=$(fresh walk)
door "$d" room/page.md ../room/../README.md
seal "$d"
out=$(run "$d")
echo "$out" | grep -q 'home_on=1' && leg long_walk_reads_home yes || leg long_walk_reads_home no

echo "control_legs=$legs"
echo "control_failed=$failed"
echo "control_verdict=ok"
