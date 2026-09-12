#!/bin/sh
# fleet_claim_control.sh -- prove the fleet's claim board, on real git repositories in a pen.
#
# WHY. Absence is checkable and intent is not, and that gap cost two ships a whole build apiece on
# `20260911`. The board is the declaration half; this proves the reader cannot be fooled by the
# four states that matter -- a peer building, a claim gone stale, your own claim, and a name that
# merely looks like another.
#
# EVERY REFUSAL IS SHOWN FROM BOTH SIDES. A refusal proven only in the passing direction cannot be
# told from a bypass, so each plant is made, bitten, removed, and shown to walk free again.
#
# IT BUILDS REAL REPOSITORIES. The reader's whole value is that it reads the ANOINTED REMOTE rather
# than local bytes, and a pen with no remote could not tell a working reader from a broken one.
#
#   sh tools/fixtures/f/fleet_claim_control.sh
set -eu

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
checks=0
failures=0
say() { checks=$((checks + 1)); printf '%s\n' "$1"; case "$1" in *=no) failures=$((failures + 1)) ;; esac; }

pen=$(mktemp -d 2>/dev/null || mktemp -d -t fleetclaim)
trap 'rm -rf "$pen"' EXIT
tree="$pen/grain-incense"
mkdir -p "$tree/construction" "$tree/tools/fixtures/f" "$tree/tools/f"
cp "$ROOT/tools/fixtures/f/fleet_claim_scan.sh"  "$tree/tools/fixtures/f/"
cp "$ROOT/tools/fixtures/f/fleet_roster_scan.sh" "$tree/tools/fixtures/f/"
cp "$ROOT/tools/f/fleet_claim.sh"                "$tree/tools/f/"
scan="$tree/tools/fixtures/f/fleet_claim_scan.sh"
writer="$tree/tools/f/fleet_claim.sh"

cat > "$tree/construction/fleet-roster.kyri" <<'ROSTER'
format fleet-roster-v1

seat incense
tree grain-incense
engine claude
lane law
status live

seat bakery
tree grain-bakery
engine claude
lane build
status live
ROSTER

now=$(date -u +%s)
fresh=$((now - 600))
old=$((now - 8 * 3600))

board() {
  cat > "$tree/construction/fleet-claims.kyri" <<BOARD
# a pen board
format fleet-claims-v1

claim port-band
seat bakery
stamp 20260911.180000
epoch $fresh
paths tools/p/port_band_scan.sh tools/p/port_band_witness.rish
what a census of the tree's port constants, with a band gate and lock coverage

claim old-thing
seat bakery
stamp 20260911.140000
epoch $old
paths tools/o/old_thing_scan.sh
what something begun this morning and never landed

claim mine-already
seat incense
stamp 20260911.200000
epoch $fresh
paths tools/m/mine_scan.sh
what a thing this very seat is building

claim undated-thing
seat bakery
stamp 20260911.210000
paths tools/u/undated_scan.sh
what a record whose epoch field never got written

claim near-name
seat bakery
stamp 20260911.210000
epoch $fresh
paths tools/f/fleet_claim
what a claim on a path that another path's name merely begins with
BOARD
}
board

# the anointed remote, and a checkout that pushes to it
git init -q --bare "$pen/remote.git"
cd "$tree"
git init -q .
git config user.email pen@example.invalid
git config user.name pen
git config commit.gpgsign false
git add -A >/dev/null
git commit -qm "pen: the board" >/dev/null
git branch -M main >/dev/null 2>&1 || true
git remote add xy "$pen/remote.git"
git push -q xy main >/dev/null 2>&1

run_check() { sh "$scan" --check "$@" 2>&1 || true; }

# --- the reader reads the remote, not this tree ------------------------------------------------
out=$(run_check tools/z/nothing.sh)
case "$out" in *"board=upstream"*) say "board_read_from_upstream=yes" ;; *) say "board_read_from_upstream=no" ;; esac
case "$out" in *"verdict=clear"*) say "unrelated_path_reads_clear=yes" ;; *) say "unrelated_path_reads_clear=no" ;; esac
case "$out" in *"seat=incense"*) say "seat_derived_from_roster=yes" ;; *) say "seat_derived_from_roster=no" ;; esac

# A board that stands here and NOT upstream is the one way to hold this tool and gain nothing, so
# the reader names that state rather than passing it off as the fleet's view.
cp "$tree/construction/fleet-claims.kyri" "$tree/construction/fleet-claims-unpushed.kyri"
out=$(FLEET_CLAIM_BOARD=construction/fleet-claims-unpushed.kyri sh "$scan" --check tools/z/nothing.sh 2>&1 || true)
case "$out" in *"board=local"*) say "local_only_board_is_named=yes" ;; *) say "local_only_board_is_named=no" ;; esac
case "$out" in *"no peer can have read"*) say "local_only_board_says_why=yes" ;; *) say "local_only_board_says_why=no" ;; esac
rm -f "$tree/construction/fleet-claims-unpushed.kyri"
out=$(run_check tools/z/nothing.sh)
case "$out" in *"board=upstream"*) say "a_pushed_board_reads_upstream=yes" ;; *) say "a_pushed_board_reads_upstream=no" ;; esac

# --- a peer building the same path is found ----------------------------------------------------
out=$(run_check tools/p/port_band_scan.sh)
case "$out" in *"verdict=claimed"*) say "peer_claim_is_found=yes" ;; *) say "peer_claim_is_found=no" ;; esac
case "$out" in *"overlap_peer=1"*) say "peer_overlap_is_counted_once=yes" ;; *) say "peer_overlap_is_counted_once=no" ;; esac
if sh "$scan" --check tools/p/port_band_scan.sh >/dev/null 2>&1; then say "a_claimed_path_exits_nonzero=no"; else say "a_claimed_path_exits_nonzero=yes"; fi

# --- your own claim never shouts at you --------------------------------------------------------
out=$(run_check tools/m/mine_scan.sh)
case "$out" in *"overlap_mine=1"*) say "own_claim_is_named_mine=yes" ;; *) say "own_claim_is_named_mine=no" ;; esac
case "$out" in *"verdict=clear"*) say "own_claim_does_not_shout=yes" ;; *) say "own_claim_does_not_shout=no" ;; esac

# --- a stale claim is a different answer from a live one ---------------------------------------
# A ship dies mid-lap and its claim would otherwise stand forever, so age decides. The two states
# get two verdicts, because "somebody is on this" and "somebody was on this eight hours ago" ask
# the reader for different things.
out=$(run_check tools/o/old_thing_scan.sh)
case "$out" in *"verdict=stale_claim"*) say "stale_claim_is_its_own_verdict=yes" ;; *) say "stale_claim_is_its_own_verdict=no" ;; esac
case "$out" in *"status=stale"*) say "stale_claim_is_named_stale=yes" ;; *) say "stale_claim_is_named_stale=no" ;; esac
out=$(run_check tools/p/port_band_scan.sh)
case "$out" in *"status=building"*) say "fresh_claim_is_named_building=yes" ;; *) say "fresh_claim_is_named_building=no" ;; esac
# the window is a knob, and moving it moves the verdict -- proven rather than asserted
out=$(FLEET_CLAIM_STALE_HOURS=24 sh "$scan" --check tools/o/old_thing_scan.sh 2>&1 || true)
case "$out" in *"verdict=claimed"*) say "a_wider_window_makes_it_live_again=yes" ;; *) say "a_wider_window_makes_it_live_again=no" ;; esac

# --- a record with no epoch is named, never read as fresh --------------------------------------
out=$(run_check tools/u/undated_scan.sh)
case "$out" in *"status=undated"*) say "a_record_without_epoch_is_named=yes" ;; *) say "a_record_without_epoch_is_named=no" ;; esac

# --- a path boundary, which is where a reference sweep goes wrong ------------------------------
# The queried name below begins with the claimed directory's characters and is a SIBLING of it, so
# a reader comparing bare prefixes would collide the two. The comparison is made at a directory
# boundary instead. The name is a query rather than a citation: it must name no file, or the leg
# would be testing nothing.
out=$(run_check tools/f/fleet_claims_other.sh)
case "$out" in *"verdict=clear"*) say "a_merely_similar_name_is_not_a_collision=yes" ;; *) say "a_merely_similar_name_is_not_a_collision=no" ;; esac
out=$(run_check tools/f/fleet_claim)
case "$out" in *"verdict=claimed"*) say "the_exact_path_still_collides=yes" ;; *) say "the_exact_path_still_collides=no" ;; esac
out=$(run_check tools/f/fleet_claim/inner.sh)
case "$out" in *"verdict=claimed"*) say "a_path_inside_a_claimed_directory_collides=yes" ;; *) say "a_path_inside_a_claimed_directory_collides=no" ;; esac
# a directory containing a claimed path is a collision, in both directions
out=$(run_check tools/p)
case "$out" in *"verdict=claimed"*) say "a_directory_above_a_claim_collides=yes" ;; *) say "a_directory_above_a_claim_collides=no" ;; esac

# --- the sentence is printed, because it is the reading that catches the founding case ---------
# `port_registry` and `port_band` shared NO path. Only a person reading two plain sentences could
# have caught them, so the board prints every live claim's `what` on every check.
out=$(run_check tools/z/nothing.sh)
case "$out" in *"what a census of the tree's port constants"*) say "the_sentence_is_printed_even_when_clear=yes" ;; *) say "the_sentence_is_printed_even_when_clear=no" ;; esac
case "$out" in *"claims_live=5"*) say "every_live_claim_is_counted=yes" ;; *) say "every_live_claim_is_counted=no" ;; esac

# --- MUTATION: loosen the boundary and the guard must bite -------------------------------------
cp "$scan" "$pen/scan.bak"
sed 's|if (substr(b, 1, length(a) + 1) == a "/") return 1|if (substr(b, 1, length(a)) == a) return 1|' "$pen/scan.bak" > "$scan"
out=$(run_check tools/f/fleet_claims_other.sh)
case "$out" in *"verdict=claimed"*) say "mutation_substring_boundary_bites=yes" ;; *) say "mutation_substring_boundary_bites=no" ;; esac
cp "$pen/scan.bak" "$scan"
out=$(run_check tools/f/fleet_claims_other.sh)
case "$out" in *"verdict=clear"*) say "lifting_the_mutation_walks_free=yes" ;; *) say "lifting_the_mutation_walks_free=no" ;; esac

# --- MUTATION: read the local board instead of the remote's ------------------------------------
# The whole value is reading upstream. A reader that fell back to local bytes would pass every leg
# above, because in this pen the two copies agree -- so the plant makes them disagree first, and
# the planted words appear in the output only if the reader is reading the wrong file.
sed 's|^what a census of the tree.s port constants.*|what A LOCAL EDIT THAT NEVER LEFT THIS TREE|' \
  "$tree/construction/fleet-claims.kyri" > "$pen/edited.kyri"
cat "$pen/edited.kyri" > "$tree/construction/fleet-claims.kyri"
out=$(run_check tools/p/port_band_scan.sh)
case "$out" in
  *"A LOCAL EDIT THAT NEVER LEFT THIS TREE"*) say "a_local_edit_does_not_reach_the_reader=no" ;;
  *) say "a_local_edit_does_not_reach_the_reader=yes" ;;
esac
# and the same edit, once pushed, DOES reach it -- so the leg above proves a reader looking
# upstream rather than a reader that simply cannot see.
git -C "$tree" add -A >/dev/null 2>&1
git -C "$tree" commit -qm "pen: push the edit" >/dev/null 2>&1
git -C "$tree" push -q xy main >/dev/null 2>&1
out=$(run_check tools/p/port_band_scan.sh)
case "$out" in
  *"A LOCAL EDIT THAT NEVER LEFT THIS TREE"*) say "a_pushed_edit_does_reach_the_reader=yes" ;;
  *) say "a_pushed_edit_does_reach_the_reader=no" ;;
esac
board
git -C "$tree" add -A >/dev/null 2>&1
git -C "$tree" commit -qm "pen: restore the board" >/dev/null 2>&1
git -C "$tree" push -q xy main >/dev/null 2>&1

# --- the writer: idempotent, which is the water row's own law ----------------------------------
# `infusion(world') -> world'`. Opening a claim that already stands unchanged moves no byte.
out=$(cd "$tree" && sh "$writer" --open fresh-thing --paths "tools/n/new_scan.sh" --what "a new thing" 2>&1 || true)
case "$out" in *"verdict=claimed"*) say "a_new_claim_is_written=yes" ;; *) say "a_new_claim_is_written=no" ;; esac
cp "$tree/construction/fleet-claims.kyri" "$pen/after-first.kyri"
out=$(cd "$tree" && sh "$writer" --open fresh-thing --paths "tools/n/new_scan.sh" --what "a new thing" 2>&1 || true)
case "$out" in *"verdict=claim_unchanged"*) say "reopening_is_idempotent=yes" ;; *) say "reopening_is_idempotent=no" ;; esac
if cmp -s "$pen/after-first.kyri" "$tree/construction/fleet-claims.kyri"; then say "idempotent_run_moves_no_byte=yes"; else say "idempotent_run_moves_no_byte=no"; fi

# an edited sentence refreshes the record and KEEPS the original stamp, because age measures how
# long the build has run rather than when the line was last touched
first_stamp=$(awk '/^claim fresh-thing$/{c=1;next} c&&$1=="stamp"{print $2;exit}' "$tree/construction/fleet-claims.kyri")
out=$(cd "$tree" && sh "$writer" --open fresh-thing --paths "tools/n/new_scan.sh" --what "a new thing, said better" 2>&1 || true)
second_stamp=$(awk '/^claim fresh-thing$/{c=1;next} c&&$1=="stamp"{print $2;exit}' "$tree/construction/fleet-claims.kyri")
case "$out" in *"verdict=claimed"*) say "an_edited_sentence_is_written=yes" ;; *) say "an_edited_sentence_is_written=no" ;; esac
if [ "$first_stamp" = "$second_stamp" ] && [ -n "$first_stamp" ]; then say "an_edit_keeps_the_original_stamp=yes"; else say "an_edit_keeps_the_original_stamp=no"; fi

# --- the writer refuses what it must -----------------------------------------------------------
if (cd "$tree" && sh "$writer" --open port-band --paths "tools/x/x.sh" --what "..." >/dev/null 2>&1); then
  say "a_peers_claim_name_is_refused=no"
else
  say "a_peers_claim_name_is_refused=yes"
fi
if (cd "$tree" && sh "$writer" --close port-band >/dev/null 2>&1); then
  say "closing_a_peers_claim_is_refused=no"
else
  say "closing_a_peers_claim_is_refused=yes"
fi
if (cd "$tree" && sh "$writer" --open "bad name" --paths p --what w >/dev/null 2>&1); then
  say "a_name_with_a_space_is_refused=no"
else
  say "a_name_with_a_space_is_refused=yes"
fi
if (cd "$tree" && sh "$writer" --open sentence-less --paths "tools/n/n.sh" >/dev/null 2>&1); then
  say "a_claim_without_a_sentence_is_refused=no"
else
  say "a_claim_without_a_sentence_is_refused=yes"
fi
# and the refusals lift: the same shapes, made lawful, walk free
if (cd "$tree" && sh "$writer" --open lawful-name --paths "tools/n/n.sh" --what "a lawful claim" >/dev/null 2>&1); then
  say "a_lawful_claim_walks_free=yes"
else
  say "a_lawful_claim_walks_free=no"
fi
if (cd "$tree" && sh "$writer" --close lawful-name >/dev/null 2>&1); then
  say "a_seat_closes_its_own_claim=yes"
else
  say "a_seat_closes_its_own_claim=no"
fi
if grep -q "^claim lawful-name$" "$tree/construction/fleet-claims.kyri"; then
  say "a_closed_claim_leaves_the_board=no"
else
  say "a_closed_claim_leaves_the_board=yes"
fi
# the board's own bound: past it, a NEW claim refuses and an existing one still updates
if (cd "$tree" && FLEET_CLAIM_MAX=1 sh "$writer" --open over-bound --paths "tools/n/o.sh" --what "one past the bound" >/dev/null 2>&1); then
  say "a_full_board_refuses_a_new_claim=no"
else
  say "a_full_board_refuses_a_new_claim=yes"
fi
if (cd "$tree" && FLEET_CLAIM_MAX=1 sh "$writer" --open fresh-thing --paths "tools/n/new_scan.sh" --what "a new thing, said better" >/dev/null 2>&1); then
  say "a_full_board_still_updates_its_own=yes"
else
  say "a_full_board_still_updates_its_own=no"
fi

# --- an EMPTY board, which is the state every ship meets first ---------------------------------
# The board ships empty, so this is the FIRST reading any ship takes -- and it was the one the pen
# could not reach, because the absent-board leg exits before the parse ever runs. Found by running
# the real thing against the real remote on the lap it was written: `claims_live=` printed blank,
# out of an awk variable no record had ever touched. A count that prints nothing reads as a broken
# instrument, which is the one thing a guard may never look like.
cat > "$tree/construction/fleet-claims.kyri" <<'EMPTY'
# a pen board with no claims on it
format fleet-claims-v1
EMPTY
git -C "$tree" add -A >/dev/null 2>&1
git -C "$tree" commit -qm "pen: an empty board" >/dev/null 2>&1
git -C "$tree" push -q xy main >/dev/null 2>&1
out=$(run_check tools/z/nothing.sh)
case "$out" in *"claims_live=0"*) say "an_empty_board_counts_zero=yes" ;; *) say "an_empty_board_counts_zero=no" ;; esac
case "$out" in *"verdict=clear"*) say "an_empty_board_reads_clear=yes" ;; *) say "an_empty_board_reads_clear=no" ;; esac
board
git -C "$tree" add -A >/dev/null 2>&1
git -C "$tree" commit -qm "pen: refill the board" >/dev/null 2>&1
git -C "$tree" push -q xy main >/dev/null 2>&1

# --- the reader refuses what it cannot answer --------------------------------------------------
if sh "$scan" --check >/dev/null 2>&1; then say "a_check_with_no_path_refuses=no"; else say "a_check_with_no_path_refuses=yes"; fi
# The queries reach awk space-joined, so a path with a space would split and read as a collision
# with neither half. A false `clear` is the one answer this reader must never give.
if sh "$scan" --check "tools/f/a file.sh" >/dev/null 2>&1; then say "a_path_with_a_space_refuses=no"; else say "a_path_with_a_space_refuses=yes"; fi
rm -f "$tree/construction/fleet-claims.kyri"
git -C "$tree" rm -q --cached construction/fleet-claims.kyri >/dev/null 2>&1 || true
git -C "$tree" commit -qm "pen: no board" >/dev/null 2>&1 || true
git -C "$tree" push -q xy main >/dev/null 2>&1 || true
out=$(run_check tools/z/nothing.sh)
case "$out" in *"board=absent"*) say "an_absent_board_is_named=yes" ;; *) say "an_absent_board_is_named=no" ;; esac
case "$out" in *"verdict=clear"*) say "an_absent_board_reads_clear=yes" ;; *) say "an_absent_board_reads_clear=no" ;; esac

cd "$ROOT"
echo "control_checks=$checks"
echo "control_failures=$failures"
if [ "$failures" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=broken"; exit 1
