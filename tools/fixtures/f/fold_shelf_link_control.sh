#!/bin/sh
# tools/fixtures/f/fold_shelf_link_control.sh -- the fold, performed wrongly on purpose.
#
# WHAT THIS DOES. tools/fixtures/f/fold_shelf_link_scan.sh claims that no link on a shelf in
# `construction/archive/` still carries the depth of the file it was folded out of. This control
# builds REAL git repositories in a throwaway pen, plants one thing in each, and watches the scan
# answer. Every refusal is shown from both sides -- planted, then lifted -- since a refusal proven
# only in the failing direction cannot be told from a scan that reds on everything.
#
# WHY REAL REPOSITORIES. The scan draws its population from `git ls-files`, so an untracked draft in
# the room is invisible to it on purpose: gating one would refuse a hand in the middle of a fold.
# That behavior is only provable on a tree where tracked and untracked genuinely differ.
#
# THE PHASES.
#   clean_free            -- a shelf whose links resolve from its own directory: verdict=ok, exit 0.
#   archive_form_bitten   -- `](archive/X)` where `X` sits beside the shelf: refused, repair named.
#   parent_form_bitten    -- `](../Y)` where `../../Y` exists: refused, repair named.
#   plant_lifted_free     -- the SAME pen repaired: green. Both sides, one move.
#   two_forms_counted     -- both forms in one shelf: counted as two, not one.
#   two_shelves_counted   -- one form on each of two shelves: both named.
#   pin_self_free         -- `](../REDS.md)` passes untouched. From a shelf it resolves to
#                            `construction/REDS.md`, which is where every shelf header points, so it
#                            needs no exception list -- it simply is not broken. Proven rather than
#                            assumed, because reds_fold_reanchor.sh carries a mask for this exact
#                            form and a reader may expect one here too.
#   code_span_free        -- the depth-lost form inside backticks passes. Markdown renders a code
#                            span literally, so it is prose ABOUT a link; REDS %218's own shelf
#                            quotes two broken links as its subject, and repairing those would
#                            destroy the testimony.
#   placeholder_free      -- `](date/YYYYMMDD/name)` passes. Stamp-and-name asks that illustrations
#                            be built from placeholders, so counting one is the fabrication that law
#                            warns about.
#   url_free              -- an absolute URL is nobody's relative path.
#   fragment_free         -- a resolving target with a `#fragment` passes; the fragment names a place
#                            inside the target, and the target is what has to exist.
#   dead_reported_free    -- a link resolving under NEITHER correction is counted in `links_dead` and
#                            NOT gated. This is the stale-reference class every other link guard
#                            deliberately leaves alone, and gating it would rewrite testimony.
#   outside_room_free     -- the same fault in a file outside the room passes: this reading has one
#                            subject and says so.
#   untracked_free        -- an untracked shelf carrying the fault passes -- a hand mid-fold.
#   no_repo_refused       -- outside a git repository: verdict=no_repo, exit 2.
#   no_room_refused       -- the room absent: verdict=no_room, exit 2.
#   no_shelves_refused    -- the room present and tracked-empty: verdict=no_shelves, exit 2. A
#                            reading of nothing must refuse rather than report a clean room
#                            (REDS %463).
#   pen_innocent          -- a scan mutated to always answer zero fails this control, so a green
#                            reading cannot come from a broken instrument.
#
# USAGE
#   sh tools/fixtures/f/fold_shelf_link_control.sh
#
# Driven by tools/f/fold_shelf_link_witness.rish. Run from the repository root.
set -eu

scan=$(CDPATH= cd -- "$(dirname "$0")" && pwd)/fold_shelf_link_scan.sh
[ -f "$scan" ] || { echo "control_verdict=no_scan"; echo "refused: no fold_shelf_link_scan.sh beside this control" >&2; exit 2; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

# Each pen is a small tree wearing the shape the scan reads: a `construction/` holding REDS.md and
# an `archive/` shelf room, plus a `context/` one level up from `construction/` so a `../` link has
# something real to reach for.
new_repo() {
  d="$pen/$1"
  mkdir -p "$d/tools/fixtures/f" "$d/construction/archive" "$d/context"
  cp "$scan" "$d/tools/fixtures/f/fold_shelf_link_scan.sh"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name  pen \
    && git config commit.gpgsign false \
    && printf 'the pin\n' > construction/REDS.md \
    && printf 'a guide\n' > context/GUIDE.md \
    && printf 'an elder shelf\n' > construction/archive/20260101-000000_elder.md \
    && git add -A \
    && git commit -q -m "pen: seed" )
}

# A shelf is written, then committed, so `git ls-files` sees it.
shelf() {
  d="$pen/$1"; name="$2"
  cat > "$d/construction/archive/$name"
  ( cd "$d" && git add -A && git commit -q -m "pen: shelf" )
}

# `set +e` inside both: most phases run a scan that REFUSES, and under `set -e` a command
# substitution assigned to a variable carries that exit outward and kills the script at its first
# successful refusal -- which reads exactly like a control that ran out of phases.
run_scan() { ( set +e; cd "$pen/$1" || exit 0; sh ./tools/fixtures/f/fold_shelf_link_scan.sh 2>/dev/null; exit 0 ); }
run_code() { ( set +e; cd "$pen/$1" || { echo 99; exit 0; }; sh ./tools/fixtures/f/fold_shelf_link_scan.sh >/dev/null 2>&1; echo $?; exit 0 ); }
say() { case "$2" in *"$3"*) echo "$1=yes" ;; *) echo "$1=no" ;; esac; }
# `deny` is `say` inverted, and it exists because the first draft of this control spelled an
# absence with `say` and printed `no_shelves_never_ok=no` -- an assertion whose NAME claims one
# thing while its VALUE means the opposite, which a witness gates as a failure and a reader gates
# as nothing at all. An absence wants its own word.
deny() { case "$2" in *"$3"*) echo "$1=no" ;; *) echo "$1=yes" ;; esac; }

# --- clean_free ---------------------------------------------------------------------------
# A shelf whose two links already read correctly from `construction/archive/`.
new_repo clean
shelf clean 20260202-000000_ok.md <<'EOF'
# a clean shelf

Folded from [the pin](../REDS.md), beside [an elder](20260101-000000_elder.md),
and out to [a guide](../../context/GUIDE.md).
EOF
out=$(run_scan clean)
say clean_free "$out" "verdict=ok"
say clean_counts_links "$out" "links_read=3"
say clean_no_loss "$out" "fold_depth_lost=0"
[ "$(run_code clean)" = 0 ] && echo "clean_exit_zero=yes" || echo "clean_exit_zero=no"

# --- archive_form_bitten ------------------------------------------------------------------
# `](archive/X)` is correct from `construction/` and points at `construction/archive/archive/X`
# from a shelf. The repair is the bare name.
new_repo archiveform
shelf archiveform 20260202-000000_a.md <<'EOF'
# folded, depth kept

See [the elder](archive/20260101-000000_elder.md).
EOF
out=$(run_scan archiveform)
say archive_form_bitten "$out" "verdict=fold_depth_lost"
say archive_form_counted "$out" "fold_depth_lost=1"
say archive_form_repair_named "$out" "-> 20260101-000000_elder.md"
[ "$(run_code archiveform)" = 1 ] && echo "archive_form_exit_one=yes" || echo "archive_form_exit_one=no"

# --- parent_form_bitten -------------------------------------------------------------------
new_repo parentform
shelf parentform 20260202-000000_b.md <<'EOF'
# folded, depth kept

See [the guide](../context/GUIDE.md).
EOF
out=$(run_scan parentform)
say parent_form_bitten "$out" "verdict=fold_depth_lost"
say parent_form_repair_named "$out" "-> ../../context/GUIDE.md"

# --- plant_lifted_free --------------------------------------------------------------------
# The SAME pen, repaired. A refusal proven only in the failing direction cannot be told from a
# scan that reds on everything.
( cd "$pen/parentform" \
  && printf '# folded, depth kept\n\nSee [the guide](../../context/GUIDE.md).\n' \
     > construction/archive/20260202-000000_b.md \
  && git add -A && git commit -q -m "pen: repair" )
out=$(run_scan parentform)
say plant_lifted_free "$out" "verdict=ok"
say plant_lifted_zero "$out" "fold_depth_lost=0"

# --- two_forms_counted --------------------------------------------------------------------
new_repo twoforms
shelf twoforms 20260202-000000_c.md <<'EOF'
# both forms

[elder](archive/20260101-000000_elder.md) and [guide](../context/GUIDE.md).
EOF
out=$(run_scan twoforms)
say two_forms_counted "$out" "fold_depth_lost=2"

# --- two_shelves_counted ------------------------------------------------------------------
new_repo twoshelves
shelf twoshelves 20260202-000000_d.md <<'EOF'
[guide](../context/GUIDE.md)
EOF
shelf twoshelves 20260203-000000_e.md <<'EOF'
[elder](archive/20260101-000000_elder.md)
EOF
out=$(run_scan twoshelves)
say two_shelves_counted "$out" "fold_depth_lost=2"
say two_shelves_first_named "$out" "20260202-000000_d.md"
say two_shelves_second_named "$out" "20260203-000000_e.md"

# --- pin_self_free ------------------------------------------------------------------------
# reds_fold_reanchor.sh masks `](../REDS.md)` before its blanket rewrite, so a reader may expect an
# exception here. There is none, and none is wanted: from a shelf that link already resolves.
new_repo pinself
shelf pinself 20260202-000000_f.md <<'EOF'
**Folded:** rows lifted from [`../REDS.md`](../REDS.md).
EOF
out=$(run_scan pinself)
say pin_self_free "$out" "verdict=ok"

# --- code_span_free -----------------------------------------------------------------------
# The depth-lost form, inside backticks, is prose about a link rather than a link.
new_repo codespan
shelf codespan 20260202-000000_g.md <<'EOF'
# a row quoting its own subject

The fold left `](../context/GUIDE.md)` pointing at nothing, which is the fault.
EOF
out=$(run_scan codespan)
say code_span_free "$out" "verdict=ok"
say code_span_not_read "$out" "links_read=0"

# --- placeholder_free ---------------------------------------------------------------------
new_repo placeholder
shelf placeholder 20260202-000000_h.md <<'EOF'
A row moving onto a shelf goes from [x](archive/YYYYMMDD-HHMMSS_sprig.md) to
[y](YYYYMMDD-HHMMSS_sprig.md).
EOF
out=$(run_scan placeholder)
say placeholder_free "$out" "verdict=ok"

# --- url_free -----------------------------------------------------------------------------
new_repo url
shelf url 20260202-000000_i.md <<'EOF'
See [the spec](https://example.invalid/archive/thing.md).
EOF
out=$(run_scan url)
say url_free "$out" "verdict=ok"

# --- fragment_free ------------------------------------------------------------------------
new_repo fragment
shelf fragment 20260202-000000_j.md <<'EOF'
See [a section](../../context/GUIDE.md#a-heading).
EOF
out=$(run_scan fragment)
say fragment_free "$out" "verdict=ok"
say fragment_counted "$out" "links_read=1"

# --- dead_reported_free -------------------------------------------------------------------
# Neither correction resolves, so no answer is safe and none is guessed. This is the stale
# reference every other link guard leaves to `dated_path_resolve.rish`.
new_repo dead
shelf dead 20260202-000000_k.md <<'EOF'
See [a departed page](../context/GONE.md).
EOF
out=$(run_scan dead)
say dead_reported_free "$out" "verdict=ok"
say dead_counted "$out" "links_dead=1"
say dead_not_gated "$out" "fold_depth_lost=0"

# --- outside_room_free --------------------------------------------------------------------
new_repo outside
( cd "$pen/outside" \
  && printf '# the card\n\nSee [guide](../context/GUIDE.md).\n' > construction/ITINERARY.md \
  && git add -A && git commit -q -m "pen: card" )
out=$(run_scan outside)
say outside_room_free "$out" "verdict=ok"

# --- untracked_free -----------------------------------------------------------------------
# A draft mid-fold is nobody's promise yet.
new_repo untracked
printf '[guide](../context/GUIDE.md)\n' > "$pen/untracked/construction/archive/20260202-000000_draft.md"
out=$(run_scan untracked)
say untracked_free "$out" "verdict=ok"

# --- absent_listed_survived -----------------------------------------------------------------
# `git ls-files` reads the INDEX, so a shelf staged for deletion or renamed mid-rebase is listed
# while nothing stands at that name on disk. This bit for real on the lap that wrote the scan: the
# awk aborted with `fatal: cannot open file` and the whole reading died. A tree mid-rebase is when
# this guard matters most, so it must survive one -- and the absent path is COUNTED rather than
# silently dropped, since a reading that quietly got smaller is the fault REDS %463 booked.
new_repo absent
shelf absent 20260202-000000_gone.md <<'EOF'
[the guide](../../context/GUIDE.md)
EOF
( cd "$pen/absent" && rm -f construction/archive/20260202-000000_gone.md )
out=$(run_scan absent)
say absent_listed_survived "$out" "verdict=ok"
say absent_listed_counted "$out" "shelves_absent=1"
deny absent_listed_no_fatal "$out" "fatal"

# --- no_repo_refused ----------------------------------------------------------------------
mkdir -p "$pen/norepo/construction/archive" "$pen/norepo/tools/fixtures/f"
cp "$scan" "$pen/norepo/tools/fixtures/f/fold_shelf_link_scan.sh"
out=$( set +e; cd "$pen/norepo" || exit 0; sh ./tools/fixtures/f/fold_shelf_link_scan.sh 2>/dev/null; exit 0 )
say no_repo_refused "$out" "verdict=no_repo"

# --- no_room_refused ----------------------------------------------------------------------
new_repo noroom
( cd "$pen/noroom" && git rm -q -r --cached construction/archive >/dev/null 2>&1 || true )
rm -rf "$pen/noroom/construction/archive"
out=$(run_scan noroom)
say no_room_refused "$out" "verdict=no_room"
[ "$(run_code noroom)" = 2 ] && echo "no_room_exit_two=yes" || echo "no_room_exit_two=no"

# --- no_shelves_refused -------------------------------------------------------------------
# The room is there and holds no tracked `.md`. A reading of nothing is not a reading (REDS %463).
# The room must be kept ALIVE by something that is not a shelf, because `git rm` of the last file
# takes the directory with it and the scan then answers `no_room` -- a correct refusal for a state
# this phase did not mean to build. A tracked `.txt` beside the shelves is the honest way in, and
# it doubles as proof that the population is `.md` rather than "whatever is in the room".
new_repo noshelves
( cd "$pen/noshelves" \
  && printf 'a note, not a shelf\n' > construction/archive/NOTES.txt \
  && git rm -q construction/archive/20260101-000000_elder.md >/dev/null 2>&1 \
  && git add -A \
  && git commit -q -m "pen: empty the room of shelves" )
out=$(run_scan noshelves)
say  no_shelves_refused  "$out" "verdict=no_shelves"
deny no_shelves_never_ok "$out" "verdict=ok"
[ "$(run_code noshelves)" = 2 ] && echo "no_shelves_exit_two=yes" || echo "no_shelves_exit_two=no"

# --- pen_innocent -------------------------------------------------------------------------
# A scan that always answers zero must FAIL this control, or a green reading proves nothing about
# the instrument that produced it.
( cd "$pen/twoforms" \
  && sed 's/^fold_depth_lost=$(grep -c . "$work\/lost" || true)$/fold_depth_lost=0/' \
       tools/fixtures/f/fold_shelf_link_scan.sh > blind_scan.sh )
out=$( set +e; cd "$pen/twoforms" || exit 0; sh blind_scan.sh 2>/dev/null; exit 0 )
say  blind_scan_reads_ok    "$out" "verdict=ok"
deny blind_scan_never_bites "$out" "verdict=fold_depth_lost"
# the same pen, unmutated, still refuses -- so the green above belongs to the mutation.
out=$(run_scan twoforms)
say pen_innocent "$out" "verdict=fold_depth_lost"

# --- repoint_mixed ------------------------------------------------------------------------
# The repointer edits testimony, so the one behavior that must be proven rather than trusted is
# that it touches ONLY what the scan approved. One shelf carries all three classes at once: a
# depth-lost link to repair, the SAME target quoted inside backticks as the row's own subject, and
# a stale reference resolving under neither correction. A blanket rewrite fails all three ways.
if [ -f "$(dirname "$scan")/fold_shelf_link_repoint.sh" ]; then
  repoint=$(dirname "$scan")/fold_shelf_link_repoint.sh
  new_repo repoint
  cp "$repoint" "$pen/repoint/tools/fixtures/f/fold_shelf_link_repoint.sh"
  shelf repoint 20260202-000000_mix.md <<'EOF'
A real link to [the guide](../context/GUIDE.md) that must be repaired.

The row explains that `](../context/GUIDE.md)` pointed at nothing, which is prose.

A stale one to [a departed page](../context/GONE.md) that must be left alone.
EOF
  # dry run first: it must name the work and change not one byte.
  before=$(cat "$pen/repoint/construction/archive/20260202-000000_mix.md")
  out=$( set +e; cd "$pen/repoint" || exit 0; sh ./tools/fixtures/f/fold_shelf_link_repoint.sh --dry-run 2>/dev/null; exit 0 )
  say repoint_dry_names "$out" "verdict=dry_run"
  say repoint_dry_counts "$out" "edits=1"
  after=$(cat "$pen/repoint/construction/archive/20260202-000000_mix.md")
  [ "$before" = "$after" ] && echo "repoint_dry_writes_nothing=yes" || echo "repoint_dry_writes_nothing=no"

  out=$( set +e; cd "$pen/repoint" || exit 0; sh ./tools/fixtures/f/fold_shelf_link_repoint.sh 2>/dev/null; exit 0 )
  say repoint_applied "$out" "verdict=repointed"
  body=$(cat "$pen/repoint/construction/archive/20260202-000000_mix.md")
  case "$body" in *"[the guide](../../context/GUIDE.md)"*) echo "repoint_repairs_link=yes" ;; *) echo "repoint_repairs_link=no" ;; esac
  case "$body" in *'`](../context/GUIDE.md)`'*) echo "repoint_spares_code_span=yes" ;; *) echo "repoint_spares_code_span=no" ;; esac
  case "$body" in *"[a departed page](../context/GONE.md)"*) echo "repoint_spares_stale=yes" ;; *) echo "repoint_spares_stale=no" ;; esac
  out=$(run_scan repoint)
  say repoint_leaves_green "$out" "verdict=ok"
  say repoint_stale_still_counted "$out" "links_dead=1"
  # and again on the same tree: a repointer that is not idempotent rewrites its own repair.
  out=$( set +e; cd "$pen/repoint" || exit 0; sh ./tools/fixtures/f/fold_shelf_link_repoint.sh 2>/dev/null; exit 0 )
  say repoint_idempotent "$out" "verdict=nothing_to_do"
else
  echo "repoint_dry_names=no"
  echo "refused: no fold_shelf_link_repoint.sh beside the scan" >&2
fi

echo "control_verdict=ok"
