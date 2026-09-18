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
# The form reader travels with the content reader, so this pen exercises the composed reading the
# fleet actually runs rather than the content half alone (REDS %787). Without it every board here
# would read `form=unread` and the pen would prove a reader nobody uses.
cp "$ROOT/tools/fixtures/f/fleet_claim_form_scan.sh" "$tree/tools/fixtures/f/"
cp "$ROOT/tools/fixtures/f/fleet_roster_scan.sh" "$tree/tools/fixtures/f/"
cp "$ROOT/tools/f/fleet_claim.sh"                "$tree/tools/f/"
# The nib writer travels too: the claim writer carries the operator card through it, and a pen
# lacking it would prove only the degrade path (`card_carried=no`) rather than the carry.
mkdir -p "$tree/tools/fixtures/r"
cp "$ROOT/tools/fixtures/r/remember_git_nib_write.sh" "$tree/tools/fixtures/r/"
nibwrite="$tree/tools/fixtures/r/remember_git_nib_write.sh"
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

# --- the writer carries the operator card, so the commit it rides in is not stale --------------
# THE CENTREPIECE RUNS THE RED RATHER THAN ARGUING IT. A claiming lap makes two commits this writer
# causes, and while it wrote the board alone both landed without `construction/ITINERARY.md`: the
# card's nib then named HEAD~2 and `remember_git_nib` read `stale` for the whole build window. The
# guard's own state predicate is copied verbatim below and asked what it sees, with the carry and
# without it -- a repair proven only by the new number cannot be told from a number that was always
# there.

nib_state() {
  # verbatim from tools/r/remember_git_nib_witness.rish step 3.
  ( cd "$tree" || return
    nib=$(awk '/Git nib:/{ if (match($0, /[0-9a-f]{7,40}/)) { print substr($0, RSTART, RLENGTH); exit } }' construction/ITINERARY.md)
    F=$(git rev-parse "$nib" 2>/dev/null); H=$(git rev-parse HEAD); P=$(git rev-parse HEAD^ 2>/dev/null); FP=$(git rev-parse "${nib}^" 2>/dev/null)
    if [ "$F" = "$H" ]; then echo head; elif [ "$FP" = "$P" ]; then echo sibling; elif [ "$F" = "$P" ]; then echo parent; else echo stale; fi )
}

# The board as the later legs expect to find it, kept by bytes rather than rebuilt from the
# fixture -- `fresh-thing` was opened above and a fixture rebuild would take it away, which the
# board-bound leg below reads as its own failure.
cp "$tree/construction/fleet-claims.kyri" "$pen/before-card-legs.kyri"

# a pen with NO card: the board is still written, and the absence is named rather than fatal. A
# claim the fleet cannot read is a worse outcome than a card one commit behind.
out=$(cd "$tree" && sh "$writer" --open cardless-thing --paths "tools/c/cardless.sh" --what "a claim opened where no card stands" 2>&1 || true)
case "$out" in *"verdict=claimed"*) say "a_missing_card_still_writes_the_board=yes" ;; *) say "a_missing_card_still_writes_the_board=no" ;; esac
case "$out" in *"card_carried=no"*) say "a_missing_card_is_named=yes" ;; *) say "a_missing_card_is_named=no" ;; esac

# now give the pen a card, and a couple of commits so HEAD has a parent to be older than
cat > "$tree/construction/ITINERARY.md" <<'CARD'
# a pen operator card

**Git nib:** `0000000000` -- the round this card describes.
CARD
git -C "$tree" add -A >/dev/null 2>&1
git -C "$tree" commit -qm "pen: a card" >/dev/null 2>&1
git -C "$tree" commit -q --allow-empty -m "pen: the previous lap's work commit" >/dev/null 2>&1

# WITHOUT the carry, the state the fleet lived with: pin the card at HEAD's parent, which is the
# honest `parent` state, then land a board-only commit on top of it.
( cd "$tree" && sh "$nibwrite" construction/ITINERARY.md "$(git rev-parse --short=10 HEAD^)" ) >/dev/null 2>&1
case "$(nib_state)" in parent) say "a_card_pinned_at_the_parent_reads_honest=yes" ;; *) say "a_card_pinned_at_the_parent_reads_honest=no" ;; esac
printf 'claim board-only\nseat incense\nstamp 20260917.000000\nepoch %s\npaths tools/b/b.sh\nwhat a board-only commit, the shape this repair retires\n' "$fresh" >> "$tree/construction/fleet-claims.kyri"
git -C "$tree" add construction/fleet-claims.kyri >/dev/null 2>&1
git -C "$tree" commit -qm "pen: a board-only commit" >/dev/null 2>&1
case "$(nib_state)" in stale) say "a_board_only_commit_stales_the_card=yes" ;; *) say "a_board_only_commit_stales_the_card=no" ;; esac

# WITH the carry: the writer pins HEAD before the commit, so that HEAD becomes the commit's parent.
( cd "$tree" && sh "$nibwrite" construction/ITINERARY.md "$(git rev-parse --short=10 HEAD^)" ) >/dev/null 2>&1
head_before=$(git -C "$tree" rev-parse --short=10 HEAD)
out=$(cd "$tree" && sh "$writer" --open carried-thing --paths "tools/c/carried.sh" --what "a claim whose writer carried the card" 2>&1 || true)
case "$out" in *"card_carried=yes"*) say "an_open_carries_the_card=yes" ;; *) say "an_open_carries_the_card=no" ;; esac
case "$out" in *"card_nib=$head_before"*) say "the_carried_nib_is_the_pre_commit_head=yes" ;; *) say "the_carried_nib_is_the_pre_commit_head=no" ;; esac
git -C "$tree" add construction/fleet-claims.kyri construction/ITINERARY.md >/dev/null 2>&1
git -C "$tree" commit -qm "pen: a carried claim commit" >/dev/null 2>&1
case "$(nib_state)" in parent) say "a_carried_claim_commit_reads_honest=yes" ;; *) say "a_carried_claim_commit_reads_honest=no" ;; esac

# THE PAIR STAYS IDEMPOTENT. `infusion(world') -> world'` holds over BOTH files, not the board
# alone: the no-op open exits above the write and never reaches the carry.
cp "$tree/construction/fleet-claims.kyri" "$pen/pair-board.kyri"
cp "$tree/construction/ITINERARY.md" "$pen/pair-card.md"
out=$(cd "$tree" && sh "$writer" --open carried-thing --paths "tools/c/carried.sh" --what "a claim whose writer carried the card" 2>&1 || true)
case "$out" in *"verdict=claim_unchanged"*) say "a_reopen_with_a_card_is_idempotent=yes" ;; *) say "a_reopen_with_a_card_is_idempotent=no" ;; esac
case "$out" in *card_carried*) say "an_idempotent_open_never_reaches_the_carry=no" ;; *) say "an_idempotent_open_never_reaches_the_carry=yes" ;; esac
if cmp -s "$pen/pair-card.md" "$tree/construction/ITINERARY.md"; then say "an_idempotent_open_moves_no_card_byte=yes"; else say "an_idempotent_open_moves_no_card_byte=no"; fi
if cmp -s "$pen/pair-board.kyri" "$tree/construction/fleet-claims.kyri"; then say "an_idempotent_open_moves_no_board_byte=yes"; else say "an_idempotent_open_moves_no_board_byte=no"; fi

# THE CLOSE IS THE OTHER HALF, and it is rule 5's own shape -- a commit landing after the work
# commit. It was carrying the card no more than the open was.
git -C "$tree" commit -q --allow-empty -m "pen: this lap's work commit" >/dev/null 2>&1
( cd "$tree" && sh "$nibwrite" construction/ITINERARY.md "$(git rev-parse --short=10 HEAD^)" ) >/dev/null 2>&1
head_before=$(git -C "$tree" rev-parse --short=10 HEAD)
out=$(cd "$tree" && sh "$writer" --close carried-thing 2>&1 || true)
case "$out" in *"verdict=closed"*) say "a_close_still_closes=yes" ;; *) say "a_close_still_closes=no" ;; esac
case "$out" in *"card_nib=$head_before"*) say "a_close_carries_the_card=yes" ;; *) say "a_close_carries_the_card=no" ;; esac
git -C "$tree" add construction/fleet-claims.kyri construction/ITINERARY.md >/dev/null 2>&1
git -C "$tree" commit -qm "pen: a carried close commit" >/dev/null 2>&1
case "$(nib_state)" in parent) say "a_carried_close_commit_reads_honest=yes" ;; *) say "a_carried_close_commit_reads_honest=no" ;; esac

# --- MUTATION: carry the card ABOVE the idempotence exit, and the pair stops being idempotent ---
# The whole subtlety of this repair is WHERE the carry sits. Above the `cmp -s` early exit it runs
# on a no-op open, and the card moves on a run that was promised to move nothing.
# The mutant lives at the writer's own relative path, because the writer resolves its root from
# `dirname $0` -- one placed in the pen's scratch would operate on a tree that is not the pen's.
mutant="$tree/tools/f/mutant_claim.sh"
sed 's|^if cmp -s "\$tmp" "\$BOARD"; then|carry_the_card\nif cmp -s "$tmp" "$BOARD"; then|' "$writer" > "$mutant"
( cd "$tree" && sh "$nibwrite" construction/ITINERARY.md "$(git rev-parse --short=10 HEAD^)" ) >/dev/null 2>&1
cp "$tree/construction/ITINERARY.md" "$pen/mutant-card.md"
(cd "$tree" && sh tools/f/mutant_claim.sh --open carried-thing --paths "tools/c/carried.sh" --what "a claim whose writer carried the card" >/dev/null 2>&1) || true
if cmp -s "$pen/mutant-card.md" "$tree/construction/ITINERARY.md"; then
  say "mutation_carry_above_the_exit_is_bitten=no"
else
  say "mutation_carry_above_the_exit_is_bitten=yes"
fi

# --- MUTATION: carry HEAD's PARENT rather than HEAD, which is the amend shape in the wrong place -
# Rule 2's `HEAD^` is right for an amend and one short for a commit landing afresh, which is REDS
# %803 exactly. Here it must leave the card stale at the very commit it was meant to make honest.
mutant2="$tree/tools/f/mutant2_claim.sh"
sed 's|head=\$(git rev-parse --short=10 HEAD 2>/dev/null \|\| true)|head=$(git rev-parse --short=10 HEAD^ 2>/dev/null \|\| true)|' "$writer" > "$mutant2"
( cd "$tree" && sh "$nibwrite" construction/ITINERARY.md "$(git rev-parse --short=10 HEAD^)" ) >/dev/null 2>&1
(cd "$tree" && sh tools/f/mutant2_claim.sh --open amend-shaped --paths "tools/a/a.sh" --what "a claim carrying the amend shape" >/dev/null 2>&1) || true
git -C "$tree" add construction/fleet-claims.kyri construction/ITINERARY.md >/dev/null 2>&1
git -C "$tree" commit -qm "pen: an amend-shaped carry" >/dev/null 2>&1
case "$(nib_state)" in stale) say "mutation_the_amend_shape_is_bitten=yes" ;; *) say "mutation_the_amend_shape_is_bitten=no" ;; esac

# and the tree is returned to the board every later leg reads
cat "$pen/before-card-legs.kyri" > "$tree/construction/fleet-claims.kyri"
rm -f "$tree/construction/ITINERARY.md" "$mutant" "$mutant2"
git -C "$tree" add -A >/dev/null 2>&1
git -C "$tree" commit -qm "pen: restore the board, drop the card" >/dev/null 2>&1
git -C "$tree" push -q xy main >/dev/null 2>&1

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


# --- the writer may not author a malformed board ------------------------------------------------
# TWO READINGS STAND HERE AND EACH IS AIMED AT A SHAPE THE OTHER MISSES. The newline refusal names
# a field value that becomes two lines; the form gate refuses any write that raises the board's
# CORRUPTING count, whatever shape does it. A newline whose continuation reads `hello world` makes
# an `unknown_key`, which is CONFINED, so only the first catches it; a sentence ending in a bare
# `claim some-name` carries no newline at all, so only the second does. Both mutations below are
# aimed that way on purpose.
form_scan_pen="$tree/tools/fixtures/f/fleet_claim_form_scan.sh"
form_corrupting() { sh "$form_scan_pen" "$1" 2>/dev/null | awk -F= '$1=="corrupting"{print $2}'; }
NL='
'
cp "$tree/construction/fleet-claims.kyri" "$pen/before-form-legs.kyri"

if (cd "$tree" && sh "$writer" --open newline-claim --paths "tools/n/nl.sh" --what "a sentence${NL}seat impostor" >/dev/null 2>&1); then
  say "a_newline_in_the_sentence_is_refused=no"
else
  say "a_newline_in_the_sentence_is_refused=yes"
fi
if cmp -s "$pen/before-form-legs.kyri" "$tree/construction/fleet-claims.kyri"; then
  say "a_refused_newline_leaves_the_board_untouched=yes"
else
  say "a_refused_newline_leaves_the_board_untouched=no"
fi
if (cd "$tree" && sh "$writer" --open newline-paths --paths "tools/a.sh${NL}what stolen" --what "one line" >/dev/null 2>&1); then
  say "a_newline_in_the_paths_is_refused=no"
else
  say "a_newline_in_the_paths_is_refused=yes"
fi
# and the refusal lifts: the same claim, said on one line, walks free
if (cd "$tree" && sh "$writer" --open newline-claim --paths "tools/n/nl.sh" --what "a sentence, seat impostor and all, on one line" >/dev/null 2>&1); then
  say "a_one_line_sentence_walks_free=yes"
else
  say "a_one_line_sentence_walks_free=no"
fi

# the form gate: a sentence ending in a bare claim header is the `glued_header` signature, and it
# carries no newline, so the refusal above cannot see it
cp "$tree/construction/fleet-claims.kyri" "$pen/before-gate-leg.kyri"
out=$(cd "$tree" && sh "$writer" --open glued-claim --paths "tools/g/g.sh" --what "the peer already opened claim port-band" 2>&1) || true
case "$out" in *"verdict=would_corrupt"*) say "a_sentence_ending_in_a_bare_header_is_refused=yes" ;; *) say "a_sentence_ending_in_a_bare_header_is_refused=no" ;; esac
if cmp -s "$pen/before-gate-leg.kyri" "$tree/construction/fleet-claims.kyri"; then
  say "a_gate_refusal_leaves_the_board_untouched=yes"
else
  say "a_gate_refusal_leaves_the_board_untouched=no"
fi
if (cd "$tree" && sh "$writer" --open glued-claim --paths "tools/g/g.sh" --what "the peer already opened the port-band claim" >/dev/null 2>&1); then
  say "the_same_sentence_reworded_walks_free=yes"
else
  say "the_same_sentence_reworded_walks_free=no"
fi
case "$(form_corrupting "$tree/construction/fleet-claims.kyri")" in
  0) say "a_writer_run_leaves_the_board_uncorrupted=yes" ;;
  *) say "a_writer_run_leaves_the_board_uncorrupted=no" ;;
esac

# AN INHERITED CORRUPTING BOARD STILL TAKES A CLAIM, which is the gate's whole design: refusing
# there would let one ship's bad conflict resolution stop every other ship from declaring.
printf 'claim planted-damage\nseat bakery\nstamp 20260917.120000\nepoch %s\npaths tools/p/p.sh\nwhat a sentence a hand glued to claim port-band\n' "$fresh" >> "$tree/construction/fleet-claims.kyri"
case "$(form_corrupting "$tree/construction/fleet-claims.kyri")" in
  0) say "the_planted_damage_is_corrupting=no" ;;
  *) say "the_planted_damage_is_corrupting=yes" ;;
esac
out=$(cd "$tree" && sh "$writer" --open on-damaged --paths "tools/d/d.sh" --what "a claim opened on a board a peer damaged" 2>&1) || true
case "$out" in *"verdict=claimed"*) say "an_inherited_corrupting_board_still_takes_a_claim=yes" ;; *) say "an_inherited_corrupting_board_still_takes_a_claim=no" ;; esac
case "$out" in *"board_inherited_corrupting="*) say "an_inherited_corrupting_board_is_named=yes" ;; *) say "an_inherited_corrupting_board_is_named=no" ;; esac

# A DUPLICATE NAME IS THE ONE CORRUPTING SHAPE A REBASE AUTHORS, twice in this board's 383
# revisions, and the writer's drop-awk already repairs it by taking every record of that name
# before appending one. Proven rather than assumed.
cat "$pen/before-form-legs.kyri" > "$tree/construction/fleet-claims.kyri"
printf 'claim doubled-name\nseat incense\nstamp 20260917.120000\nepoch %s\npaths tools/x/one.sh\nwhat the first side of a rebase\n' "$fresh" >> "$tree/construction/fleet-claims.kyri"
printf 'claim doubled-name\nseat incense\nstamp 20260917.120100\nepoch %s\npaths tools/x/two.sh\nwhat the second side of a rebase\n' "$fresh" >> "$tree/construction/fleet-claims.kyri"
case "$(form_corrupting "$tree/construction/fleet-claims.kyri")" in
  0) say "a_doubled_name_is_corrupting=no" ;;
  *) say "a_doubled_name_is_corrupting=yes" ;;
esac
(cd "$tree" && sh "$writer" --open doubled-name --paths "tools/x/one.sh" --what "one record, said once" >/dev/null 2>&1) || true
if [ "$(grep -c '^claim doubled-name$' "$tree/construction/fleet-claims.kyri")" = 1 ]; then
  say "an_inherited_doubled_name_is_repaired_by_its_seat=yes"
else
  say "an_inherited_doubled_name_is_repaired_by_its_seat=no"
fi

# --- MUTATION: strike the newline refusal, aimed at a shape only IT catches --------------------
# The continuation line `hello world` makes an `unknown_key`, which is a CONFINED finding, so the
# form gate below passes it. Without the refusal the board takes a second line in silence.
cat "$pen/before-form-legs.kyri" > "$tree/construction/fleet-claims.kyri"
mutant3="$tree/tools/f/mutant3_claim.sh"
sed 's|^if has_newline "\$what"; then|if false; then|' "$writer" > "$mutant3"
(cd "$tree" && sh tools/f/mutant3_claim.sh --open mutant-newline --paths "tools/m/m.sh" --what "a sentence${NL}hello world" >/dev/null 2>&1) || true
if grep -q '^hello world$' "$tree/construction/fleet-claims.kyri"; then
  say "mutation_the_newline_refusal_is_bitten=yes"
else
  say "mutation_the_newline_refusal_is_bitten=no"
fi

# --- MUTATION: strike the form gate, aimed at a shape only IT catches --------------------------
# A sentence ending in a bare `claim port-band` carries no newline, so the refusal above is blind
# to it. Without the gate the writer authors a corrupting board.
cat "$pen/before-form-legs.kyri" > "$tree/construction/fleet-claims.kyri"
mutant4="$tree/tools/f/mutant4_claim.sh"
sed 's|^form_gate "\$(corrupting_count "\$BOARD")"$|:|' "$writer" > "$mutant4"
(cd "$tree" && sh tools/f/mutant4_claim.sh --open mutant-glued --paths "tools/m/g.sh" --what "the peer already opened claim port-band" >/dev/null 2>&1) || true
case "$(form_corrupting "$tree/construction/fleet-claims.kyri")" in
  0) say "mutation_the_form_gate_is_bitten=no" ;;
  *) say "mutation_the_form_gate_is_bitten=yes" ;;
esac
rm -f "$mutant3" "$mutant4"
cat "$pen/before-form-legs.kyri" > "$tree/construction/fleet-claims.kyri"

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
