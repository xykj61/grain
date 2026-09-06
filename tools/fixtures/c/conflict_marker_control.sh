#!/bin/sh
# tools/fixtures/c/conflict_marker_control.sh -- the marker, planted on purpose.
#
# WHAT THIS DOES. tools/fixtures/c/conflict_marker_scan.sh claims that no tracked file carries an
# unresolved conflict marker. This control builds REAL git repositories in a throwaway pen, plants
# one thing in each, and watches the scan answer. Every refusal is shown from both sides -- planted,
# then lifted -- since a refusal proven only in the failing direction cannot be told from a scan
# that reds on everything.
#
# WHY REAL REPOSITORIES, and one of them genuinely conflicted. The scan reads `git ls-files`, which
# lists an UNMERGED path once per stage, so a tree standing mid-merge reports the same file three
# times. That is precisely the tree this reading exists for, so one phase makes a real merge
# conflict rather than writing marker text by hand, and asserts the file is counted ONCE.
#
# THE PHASES.
#   clean_free           -- tracked files, no markers: verdict=ok, exit 0, and the file count named.
#   marker_bitten        -- `<<<<<<< HEAD` and `>>>>>>> other` in a tracked file: refused, named.
#   plant_lifted_free    -- the SAME pen with the marker removed: green. Both sides, one move.
#   head_alone_bitten    -- an opening marker with no closing one still refuses. A half-resolved
#                           file is the likelier accident, and the likelier one to survive review.
#   tail_alone_bitten    -- a closing marker alone still refuses, for the same reason.
#   divider_alone_free   -- a bare `=======` line passes. It is the Markdown setext underline for a
#                           heading, this tree writes it in prose, and gating it would red on
#                           ordinary work -- which is a guard someone turns off.
#   fenced_marker_bitten -- a marker inside a fenced code block is STILL refused. There is no shape
#                           door; a file that must show the marker is excluded by NAME, countably.
#   excluded_file_free   -- a file on the excluded roster carrying the marker passes, while a peer
#                           file with byte-identical content in the same pen is refused. That pair
#                           is what proves the exclusion is by name rather than by content.
#   untracked_free       -- an untracked file carrying a marker is not counted. The claim is about
#                           what the repository CARRIES, and an untracked file is nobody's yet.
#   vendor_free          -- a marker under vendor/ is not counted; that source is held unmodified.
#   unmerged_counted_once-- a real merge conflict is reported as ONE marked file, not three.
#
# MEASURED: 23 readings over 10 planted states in 9 real repositories. Exit codes are printed here
# and asserted by tools/c/conflict_marker_witness.rish, so the numbers live in one place.
#
# Driven by tools/c/conflict_marker_witness.rish. Run from the repository root.
set -eu

scan=$(CDPATH= cd -- "$(dirname "$0")" && pwd)/conflict_marker_scan.sh
[ -f "$scan" ] || { echo "control_verdict=no_scan"; echo "refused: no conflict_marker_scan.sh beside this control" >&2; exit 2; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

# The scan excludes ITSELF by name, so a pen must carry a copy at that exact path for the exclusion
# phase to mean anything. Each pen gets one.
new_repo() {
  d="$pen/$1"
  mkdir -p "$d/tools/fixtures/c"
  cp "$scan" "$d/tools/fixtures/c/conflict_marker_scan.sh"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name  pen \
    && git config commit.gpgsign false \
    && printf 'ordinary\n' > plain.txt \
    && git add -A \
    && git commit -q -m "pen: seed" )
}

# `set +e` inside both: most phases run a scan that REFUSES, and under `set -e` a command
# substitution assigned to a variable carries that exit outward and kills the script at its first
# successful refusal -- which reads exactly like a control that ran out of phases.
run_scan() { ( set +e; cd "$pen/$1" || exit 0; sh ./tools/fixtures/c/conflict_marker_scan.sh 2>/dev/null; exit 0 ); }
run_code() { ( set +e; cd "$pen/$1" || { echo 99; exit 0; }; sh ./tools/fixtures/c/conflict_marker_scan.sh >/dev/null 2>&1; echo $?; exit 0 ); }

plant_marker() {
  printf '%s\n' 'before' '<<<<<<< HEAD' 'ours' '=======' 'theirs' '>>>>>>> other-branch' 'after'
}

# --- clean_free -------------------------------------------------------------------------
new_repo clean
out=$(run_scan clean); code=$(run_code clean)
echo "clean_exit=$code"
case "$out" in *"verdict=ok"*) echo "clean_free=yes" ;; *) echo "clean_free=no" ;; esac
case "$out" in *"marked_files=0"*) echo "clean_none_marked=yes" ;; *) echo "clean_none_marked=no" ;; esac
case "$out" in *"files_scanned=1"*) echo "clean_count_named=yes" ;; *) echo "clean_count_named=no" ;; esac

# --- marker_bitten, then plant_lifted_free -----------------------------------------------
new_repo marked
( cd "$pen/marked" && plant_marker > card.md && git add card.md && git commit -q -m "pen: a card with a marker" )
out=$(run_scan marked); code=$(run_code marked)
echo "marked_exit=$code"
case "$out" in *"verdict=conflict_marker"*) echo "marker_bitten=yes" ;; *) echo "marker_bitten=no" ;; esac
case "$out" in *"marked: card.md:2"*) echo "marker_named=yes" ;; *) echo "marker_named=no" ;; esac
case "$out" in *"dividers=1"*) echo "divider_counted_inside=yes" ;; *) echo "divider_counted_inside=no" ;; esac

( cd "$pen/marked" && printf 'before\nours\nafter\n' > card.md && git add card.md && git commit -q -m "pen: resolved" )
out=$(run_scan marked); code=$(run_code marked)
echo "lifted_exit=$code"
case "$out" in *"verdict=ok"*) echo "plant_lifted_free=yes" ;; *) echo "plant_lifted_free=no" ;; esac

# --- head_alone_bitten, tail_alone_bitten ------------------------------------------------
new_repo halves
( cd "$pen/halves" \
  && printf 'a\n<<<<<<< HEAD\nb\n' > head_only.md \
  && printf 'c\n>>>>>>> other-branch\nd\n' > tail_only.md \
  && git add -A && git commit -q -m "pen: half-resolved" )
out=$(run_scan halves)
case "$out" in *"marked: head_only.md:2"*) echo "head_alone_bitten=yes" ;; *) echo "head_alone_bitten=no" ;; esac
case "$out" in *"marked: tail_only.md:2"*) echo "tail_alone_bitten=yes" ;; *) echo "tail_alone_bitten=no" ;; esac

# --- divider_alone_free -------------------------------------------------------------------
# The false-positive phase, and the one that keeps this guard usable: a setext heading underline.
new_repo divider
( cd "$pen/divider" \
  && printf 'A Heading\n=======\n\nprose beneath it\n' > page.md \
  && git add -A && git commit -q -m "pen: a setext heading" )
out=$(run_scan divider); code=$(run_code divider)
echo "divider_exit=$code"
case "$out" in *"verdict=ok"*) echo "divider_alone_free=yes" ;; *) echo "divider_alone_free=no" ;; esac

# --- fenced_marker_bitten ------------------------------------------------------------------
new_repo fenced
( cd "$pen/fenced" \
  && { printf 'teaching the shape:\n\n```\n'; plant_marker; printf '```\n'; } > lesson.md \
  && git add -A && git commit -q -m "pen: a marker inside a fence" )
out=$(run_scan fenced)
case "$out" in *"verdict=conflict_marker"*) echo "fenced_marker_bitten=yes" ;; *) echo "fenced_marker_bitten=no" ;; esac

# --- excluded_file_free, beside a byte-identical peer that is bitten ------------------------
new_repo excluded
( cd "$pen/excluded" \
  && mkdir -p tools/c \
  && { cat tools/fixtures/c/conflict_marker_scan.sh; echo; plant_marker; } > tools/c/conflict_marker_witness.rish \
  && { cat tools/fixtures/c/conflict_marker_scan.sh; echo; plant_marker; } > tools/c/a_peer_witness.rish \
  && git add -A && git commit -q -m "pen: one excluded, one not, same bytes" )
out=$(run_scan excluded)
case "$out" in *"marked: tools/c/conflict_marker_witness.rish"*) echo "excluded_file_free=no" ;; *) echo "excluded_file_free=yes" ;; esac
case "$out" in *"marked: tools/c/a_peer_witness.rish"*) echo "peer_still_bitten=yes" ;; *) echo "peer_still_bitten=no" ;; esac

# --- untracked_free -------------------------------------------------------------------------
new_repo untracked
( cd "$pen/untracked" && plant_marker > never_added.md )
out=$(run_scan untracked); code=$(run_code untracked)
echo "untracked_exit=$code"
case "$out" in *"verdict=ok"*) echo "untracked_free=yes" ;; *) echo "untracked_free=no" ;; esac

# --- vendor_free -----------------------------------------------------------------------------
new_repo vendored
( cd "$pen/vendored" \
  && mkdir -p vendor/upstream \
  && plant_marker > vendor/upstream/theirs.c \
  && git add -A && git commit -q -m "pen: a marker in vendored source" )
out=$(run_scan vendored)
case "$out" in *"verdict=ok"*) echo "vendor_free=yes" ;; *) echo "vendor_free=no" ;; esac

# --- unmerged_counted_once --------------------------------------------------------------------
# A REAL conflict, so `git ls-files` lists the path at three stages. The file must be counted once.
new_repo unmerged
( cd "$pen/unmerged" \
  && printf 'base\n' > shared.md && git add -A && git commit -q -m "pen: base" \
  && git checkout -q -b other && printf 'theirs\n' > shared.md && git commit -q -am "pen: theirs" \
  && git checkout -q - && printf 'ours\n' > shared.md && git commit -q -am "pen: ours" \
  && git merge other >/dev/null 2>&1 || true )
out=$(run_scan unmerged)
case "$out" in *"marked_files=1"*) echo "unmerged_counted_once=yes" ;; *) echo "unmerged_counted_once=no" ;; esac
case "$out" in *"verdict=conflict_marker"*) echo "unmerged_bitten=yes" ;; *) echo "unmerged_bitten=no" ;; esac

# --- index_only_bitten ------------------------------------------------------------------
# The state the real fault passed through, and the one a worktree-only reading cannot see: the
# block is STAGED and the working copy has already been repaired. This is what a commit would
# ship, so it must bite -- and it must say the worktree alone reads clean, which is why both
# sides are read rather than one.
new_repo index_only
( cd "$pen/index_only" \
  && plant_marker > staged.md && git add staged.md \
  && printf 'repaired\n' > staged.md )
out=$(run_scan index_only); code=$(run_code index_only)
case "$out" in *"verdict=conflict_marker"*) echo "index_only_bitten=yes" ;; *) echo "index_only_bitten=no" ;; esac
case "$out" in *"marked_files=1"*) echo "index_only_counted=yes" ;; *) echo "index_only_counted=no" ;; esac
[ "$code" = 1 ] && echo "index_only_exit=1" || echo "index_only_exit=$code"
# and the same tree read with only the worktree side is genuinely clean, so the reading is
# earning its second pass rather than duplicating the first.
wt=$( set +e; cd "$pen/index_only" || exit 0
      git grep -nE '^(<<<<<<< |>>>>>>> )' -- . >/dev/null 2>&1; echo $?; exit 0 )
[ "$wt" = 1 ] && echo "index_only_worktree_clean=yes" || echo "index_only_worktree_clean=no"

# --- diff3_base_bitten ------------------------------------------------------------------
# merge.conflictStyle=diff3 and zdiff3 write a third labelled marker naming the merge base. It is
# as unambiguous as the other two, and a tree configured that way was half-read before.
new_repo diff3
( cd "$pen/diff3" \
  && printf '%s\n' 'before' '<<<<<<< HEAD' 'ours' '||||||| base' 'base' '=======' 'theirs' '>>>>>>> other' > d.md \
  && git add -A && git commit -q -m "pen: a diff3 block" )
out=$(run_scan diff3)
case "$out" in *"verdict=conflict_marker"*) echo "diff3_bitten=yes" ;; *) echo "diff3_bitten=no" ;; esac
case "$out" in *"marked: d.md:4"*) echo "diff3_base_line_named=yes" ;; *) echo "diff3_base_line_named=no" ;; esac

# --- instrument_refusal -----------------------------------------------------------------
# REDS %473's fault, planted rather than asserted. `git grep` exits 1 for "no match" and 2 or more
# when it could not run, and a truthy fallback reads those two opposite answers the same way. The
# plant is one unterminated bracket in the pattern; git grep exits 128 and the scan must refuse by
# name rather than report a clean tree. This bit for real while the two-sided reading was being
# written -- `--cached` placed after the pattern is read by git grep as a REVISION.
new_repo instrument
( cd "$pen/instrument" \
  && sed "s/'\^(<<<<<<< /'^(<<<<<<< [/" tools/fixtures/c/conflict_marker_scan.sh > bad_scan.sh )
out=$( set +e; cd "$pen/instrument" || exit 0; sh bad_scan.sh 2>/dev/null; exit 0 )
case "$out" in *"verdict=instrument_refusal"*) echo "instrument_refusal_bitten=yes" ;; *) echo "instrument_refusal_bitten=no" ;; esac
case "$out" in *"verdict=ok"*) echo "instrument_never_reads_ok=no" ;; *) echo "instrument_never_reads_ok=yes" ;; esac
# the same pen, unmutated, still reads clean -- so the refusal belongs to the plant.
out=$(run_scan instrument)
case "$out" in *"verdict=ok"*) echo "instrument_pen_innocent=yes" ;; *) echo "instrument_pen_innocent=no" ;; esac

echo "control_verdict=ok"
