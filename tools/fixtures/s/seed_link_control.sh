#!/bin/sh
# tools/fixtures/s/seed_link_control.sh -- prove the seed-link reading by doing, on real repositories.
#
# WHY. A guard that cannot red guards nothing (REDS row 59). This control builds git repositories
# in a temporary pen, each with its own small manifest, plants one condition in each, runs
# tools/fixtures/s/seed_link_scan.sh inside them, and checks the refusals bite and the honest
# readings stay free. Nothing here touches the tree it is run from.
#
# The ceiling is proven from BOTH sides by planting one document carrying exactly the ceiling's
# worth of dead links and then one more, so the pen stays small. There is no flag that lowers
# the ceiling, because a wall with a door beside it is a habit rather than a wall.
#
# THE CEILING IS READ OUT OF THE SCAN, never retyped here. It stood spelled in both files, and a
# number spelled twice is a number that drifts: lowering it in one reader and not the other
# makes the two answer differently about one tree, which the ASCII-document family booked one
# instrument over. So the plant is derived from the scan's own `ceiling=` line, and a lowering
# in the scan reaches this control on the next run with no hand at all.
#
# EVERY LEG IS TALLIED. `control_verdict=ok` says only that the control reached its last line, so
# a leg added tomorrow could read `no` under a green witness. The tally is asserted beside the
# named readings, which is how a new leg is heard on the lap it lands.
#
# USAGE
#   sh tools/fixtures/s/seed_link_control.sh
#
# Driven by tools/s/seed_link_witness.rish. Run from the repository root.

set -u

scan=$(pwd)/tools/fixtures/s/seed_link_scan.sh
[ -f "$scan" ] || { echo "control_verdict=scan_missing" >&2; exit 1; }

# The plant law, imported rather than re-spelled: the mutation below breaks the scan on purpose,
# and a break that matched nothing reads exactly like a clause that holds (REDS %519).
. "$(pwd)/tools/fixtures/p/plant.sh"

# Read the ceiling from the scan under test rather than retyping it here.
ceiling=$(sed -n 's/^ceiling=\([0-9][0-9]*\).*/\1/p' "$scan" | head -1)
case $ceiling in
  ''|*[!0-9]*) echo "control_verdict=ceiling_unreadable" >&2; exit 1 ;;
esac

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

# A pen ships `shipped/` and README.md, and withholds `withheld/` by simply never allowing it.
build() {
  name=$1; doc=$2; body=$3
  d=$pen/$name
  mkdir -p "$d/shipped" "$d/withheld" "$d/$(dirname "$doc")" 2>/dev/null
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf 'allow README.md\nallow shipped\nallow SECURITY.md\nallow SOURCE.md\n' > pen-manifest.kyri \
    && printf '# shipped\n' > shipped/here.md \
    && printf '# withheld\n' > withheld/there.md \
    && printf '# front\n' > README.md \
    && printf '%s\n' "$body" > "$doc" \
    && git add -A && git commit -qm 'pen: one shipped room and one withheld' ) >/dev/null 2>&1
  echo "$d"
}

# A SECOND PEN, whose manifest allows a FILE rather than the room holding it. The projection
# makes `deep/inner/` to hold the page it ships, so a link to that room opens in the seed exactly
# as it opens in the field -- while `withheld/`, which no allow row reaches, stays a room that is
# not there. One tree proves both sides, which is what keeps the clause from reading as a hole.
build_carried() {
  name=$1; doc=$2; body=$3
  d=$pen/$name
  mkdir -p "$d/deep/inner" "$d/withheld" "$d/$(dirname "$doc")" 2>/dev/null
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name Pen \
    && printf 'allow README.md\nallow deep/inner/page.md\n' > pen-manifest.kyri \
    && printf '# withheld\n' > withheld/there.md \
    && printf '# front\n' > README.md \
    && printf '%s\n' "$body" > "$doc" \
    && git add -A && git commit -qm 'pen: one carried room and one withheld' ) >/dev/null 2>&1
  echo "$d"
}

verdict_of() { ( cd "$1" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$scan" 2>/dev/null; ) }

# 1. The agreeing tree -- the front door links only into the shipped room. Free, reading zero.
d=$(build agreeing README.md 'see [here](shipped/here.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=ok' && leg agreeing_free yes || leg agreeing_free no
echo "$out" | grep -q 'front_door_links_outside_seed=0' && leg clean_reads_zero yes || leg clean_reads_zero no

# 2. The regression itself -- the front door links into a withheld room. Refused, counted, named.
d=$(build front_dead README.md 'see [there](withheld/there.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=link_outside_seed' && leg front_dead_refused yes || leg front_dead_refused no
echo "$out" | grep -q 'front_door_links_outside_seed=1' && leg front_dead_counted yes || leg front_dead_counted no
echo "$out" | grep -q 'gated: README.md -> withheld/there.md' && leg front_dead_named yes || leg front_dead_named no

# 3. A document the seed never ships cannot break a link for a reader who never sees it. Free.
d=$(build unshipped withheld/note.md 'see [there](there.md)')
verdict_of "$d" | grep -q 'verdict=ok' && leg unshipped_doc_free yes || leg unshipped_doc_free no

# 4. A shipped NON-front-door document counts as a ratchet rather than a gate. At the wall's
#    zero ceiling there is no room "under" it, so a single stray link now refuses rather than
#    passing free -- the same reading leg 7 proves at ceiling+1, read here through the ratchet
#    path rather than the front-door gate.
d=$(build ratchet shipped/note.md 'see [there](../withheld/there.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=1' && leg ratchet_counted yes || leg ratchet_counted no
echo "$out" | grep -q 'front_door_links_outside_seed=0' && leg ratchet_not_gated yes || leg ratchet_not_gated no
echo "$out" | grep -q 'verdict=link_outside_seed' && leg ratchet_at_zero_refused yes || leg ratchet_at_zero_refused no

# 5. Dated testimony keeps every reference it ever wrote. Free, and not even counted.
d=$(build testimony shipped/20260101-000000_a-dated-note.md 'see [there](../withheld/there.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=0' && leg dated_testimony_free yes || leg dated_testimony_free no

# 5b. A closed stack is testimony BY DIRECTORY too, whatever its basename -- the same shape
#     ascii_document_scan.sh and read-scope.md already read past, and the retired countdown-prefix
#     research notes under external-research/yonder/ are exactly this: no one-clock stamp, still
#     frozen. Free, and not even counted.
d=$(build closed_stack shipped/yonder/9911_a-retired-note.md 'see [there](../../withheld/there.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=0' && leg closed_stack_dir_free yes || leg closed_stack_dir_free no

# 5c. The clause proven by its absence: strike the directory reading out of a copy of the scan and
#     the same pen counts the closed-stack page again.
if plant_write "$scan" "$pen/mutant2.sh" 's/(date|archive|yonder)/(nonesuch-closed-stack)/' closed_stack_clause; then
  out=$( ( cd "$d" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$pen/mutant2.sh" 2>/dev/null ) )
  echo "$out" | grep -q 'other_living_links_outside_seed=1' && leg mutation_closed_stack_counted yes || leg mutation_closed_stack_counted no
else
  leg mutation_closed_stack_counted no
fi

# 6. An external link and an anchor name no path in this tree. Free.
d=$(build external README.md 'see [web](https://example.invalid/x) and [top](#heading) and [mail](mailto:a@b.invalid)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=ok' && leg external_link_free yes || leg external_link_free no
echo "$out" | grep -q 'relative_links_checked=0' && leg external_not_counted yes || leg external_not_counted no

# 7. The ceiling, from both sides -- exactly at it free, one over refused, no flag involved.
over=$((ceiling + 1))
d=$(build ceiling_under shipped/many.md 'placeholder')
( cd "$d" && i=1; : > shipped/many.md
  while [ "$i" -le "$ceiling" ]; do printf 'see [x%s](../withheld/there.md)\n' "$i" >> shipped/many.md; i=$((i + 1)); done
  git add -A && git commit -qm 'pen: dead links exactly at the ceiling' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q "other_living_links_outside_seed=$ceiling" && leg ceiling_edge_counted yes || leg ceiling_edge_counted no
echo "$out" | grep -q 'verdict=ok' && leg ceiling_edge_free yes || leg ceiling_edge_free no

( cd "$d" && printf 'see [x%s](../withheld/there.md)\n' "$over" >> shipped/many.md \
  && git add -A && git commit -qm 'pen: one over the ceiling' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q "other_living_links_outside_seed=$over" && leg ceiling_over_counted yes || leg ceiling_over_counted no
echo "$out" | grep -q 'verdict=link_outside_seed' && leg ceiling_over_refused yes || leg ceiling_over_refused no

# 8. The widened roster: a second-step door is gated, and the count says how many stand.
d=$(build second_door SOURCE.md 'see [there](withheld/there.md)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'verdict=link_outside_seed' && leg second_door_refused yes || leg second_door_refused no
echo "$out" | grep -q 'gated: SOURCE.md -> withheld/there.md' && leg second_door_named yes || leg second_door_named no
echo "$out" | grep -q 'front_door_guarded=8' && leg roster_counted yes || leg roster_counted no

# 9. A ratchet is named in full on request, and capped at five without it. The repair falls on
#    touch, so a lane that cannot find its own share cannot perform it.
d=$(build listing shipped/many.md 'placeholder')
( cd "$d" && i=1; : > shipped/many.md
  while [ "$i" -le 7 ]; do printf 'see [x%s](../withheld/there.md)\n' "$i" >> shipped/many.md; i=$((i + 1)); done
  git add -A && git commit -qm 'pen: seven dead links, two past the print cap' ) >/dev/null 2>&1
capped=$( ( cd "$d" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$scan" 2>/dev/null ) | grep -c '^ratchet:' )
listed=$( ( cd "$d" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$scan" --list 2>/dev/null ) | grep -c '^ratchet:' )
[ "$capped" -eq 5 ] && leg default_caps_at_five yes || leg default_caps_at_five no
[ "$listed" -eq 7 ] && leg list_names_every_site yes || leg list_names_every_site no

# 10. The advice line points a lane at --list, and stays quiet when it has nothing to add.
out=$( ( cd "$d" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$scan" 2>/dev/null ) )
echo "$out" | grep -q 'advice: 7 sites stand and five are named' && leg advice_points_at_list yes || leg advice_points_at_list no
out=$( ( cd "$d" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$scan" --list 2>/dev/null ) )
echo "$out" | grep -q '^advice:' && leg advice_quiet_when_listing no || leg advice_quiet_when_listing yes
d2=$(build advice_small shipped/one.md 'see [there](../withheld/there.md)')
out=$( ( cd "$d2" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$scan" 2>/dev/null ) )
echo "$out" | grep -q '^advice:' && leg advice_quiet_under_cap no || leg advice_quiet_under_cap yes

# 11. An argument the scan does not know refuses rather than being read past.
out=$( ( cd "$d" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$scan" --nonesuch 2>/dev/null ) )
echo "$out" | grep -q 'verdict=bad_argument' && leg unknown_argument_refused yes || leg unknown_argument_refused no

over_carried=$((ceiling + 1))

# 12. A room the seed MAKES is a room the seed carries. The manifest names `deep/inner/page.md`
#     and never a directory, so the projection creates both rooms to hold that one page.
#     Planted one past the ceiling, so a reading that counted them would refuse: a leg that
#     cannot say no says nothing when it says yes.
d=$(build_carried carried_own deep/inner/page.md 'placeholder')
( cd "$d" && i=1; : > deep/inner/page.md
  while [ "$i" -le "$over_carried" ]; do printf 'see [x%s](./)\n' "$i" >> deep/inner/page.md; i=$((i + 1)); done
  git add -A && git commit -qm 'pen: one past the ceiling, every link into the carried room' ) >/dev/null 2>&1
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=0' && leg carried_own_room_uncounted yes || leg carried_own_room_uncounted no
echo "$out" | grep -q 'verdict=ok' && leg carried_own_room_free yes || leg carried_own_room_free no

d=$(build_carried carried_up deep/inner/page.md 'see [the room above](../)')
verdict_of "$d" | grep -q 'other_living_links_outside_seed=0' && leg carried_ancestor_free yes || leg carried_ancestor_free no

# 13. A room no allow row reaches is still a room that is not there. The welcome above is exact.
d=$(build_carried empty_room deep/inner/page.md 'see [nowhere](../../withheld/)')
out=$(verdict_of "$d")
echo "$out" | grep -q 'other_living_links_outside_seed=1' && leg empty_room_still_counted yes || leg empty_room_still_counted no
echo "$out" | grep -q 'ratchet: deep/inner/page.md -> ../../withheld/' && leg empty_room_named yes || leg empty_room_named no

# 14. The clause proven by its absence: strike the carried-room reading out of a copy of the scan
#     and the same pen counts the room again. The break itself is checked, so a plant that
#     matched nothing cannot read as a clause that holds.
d=$(build_carried mutation deep/inner/page.md 'see [this room](./)')
if plant_write "$scan" "$pen/mutant.sh" 's/if (p in carried) return 1/if (0) return 1/' carried_clause; then
  out=$( ( cd "$d" && SEED_LINK_MANIFEST=pen-manifest.kyri sh "$pen/mutant.sh" 2>/dev/null ) )
  echo "$out" | grep -q 'other_living_links_outside_seed=1' && leg mutation_carried_counted yes || leg mutation_carried_counted no
else
  leg mutation_carried_counted no
fi

echo "control_legs=$legs"
echo "control_failed=$failed"
echo "control_verdict=ok"
