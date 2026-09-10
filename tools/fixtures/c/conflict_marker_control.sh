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
# THE STAGED PHASES, added 20260910 when the reading moved to the commit. `staged` mode narrows the
# same rule to the paths a commit carries, so `tools/hooks/pre-commit` can refuse the marker at the
# moment it is made rather than at the next lap's open -- the placement fault the elder repair kept.
#   staged_marker_bitten -- a marker in a STAGED file refuses, and names the contract line the hook
#                           reads to tell this refusal from an instrument that could not measure.
#   staged_lifted_free   -- the SAME pen, resolved and staged again: green. Both sides, one move.
#   staged_elsewhere_free-- a marker committed in a file this commit does NOT stage passes. An
#                           author is refused for their own bytes and never for somebody else's.
#   staged_worktree_free -- a marker in the WORKING TREE of a file staged clean passes, since those
#                           bytes will not land -- and the SAME pen read as a census still refuses,
#                           which is what proves the narrowing is the mode rather than a hole.
#   staged_nothing_free  -- a commit staging no file at all reads staged_files=0 and passes.
#   staged_paths_agree   -- the narrowed query and the wide-then-filter reading name the SAME hits
#                           on one pen. Two code paths owe a leg showing they agree, or the fast
#                           one is a different guard wearing the same name.
#   unknown_mode_refused -- a mode this scan does not have refuses, rather than being answered as a
#                           census. A wrong answer at exit 0 is the shape a guard can least afford.
#   hook_refuses / hook_welcomes -- the REAL tools/hooks/pre-commit, armed in a pen on
#                           core.hooksPath, refuses a commit staging a marker and makes the same
#                           commit once resolved. The instrument and its WIRING are two claims, and
#                           this pair proves the second: the first draft of rule nine passed every
#                           scan leg and never ran, because the hook's own front gate wants rishi.
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


# --- staged_marker_bitten / staged_lifted_free ------------------------------------------
# The narrowed reading, planted and then lifted in one pen.
new_repo staged_bite
( cd "$pen/staged_bite" && plant_marker > card.md && git add card.md )
out=$( set +e; cd "$pen/staged_bite" || exit 0; sh ./tools/fixtures/c/conflict_marker_scan.sh staged 2>/dev/null; exit 0 )
case "$out" in *"verdict=conflict_marker"*) echo "staged_marker_bitten=yes" ;; *) echo "staged_marker_bitten=no" ;; esac
case "$out" in *"detail=RED_staged_conflict_marker"*) echo "staged_detail_named=yes" ;; *) echo "staged_detail_named=no" ;; esac
case "$out" in *"staged_files=1"*) echo "staged_population_named=yes" ;; *) echo "staged_population_named=no" ;; esac
( cd "$pen/staged_bite" && printf 'before\nours\nafter\n' > card.md && git add card.md )
out=$( set +e; cd "$pen/staged_bite" || exit 0; sh ./tools/fixtures/c/conflict_marker_scan.sh staged 2>/dev/null; exit 0 )
case "$out" in *"verdict=ok"*) echo "staged_lifted_free=yes" ;; *) echo "staged_lifted_free=no" ;; esac

# --- staged_elsewhere_free --------------------------------------------------------------
# A marker already committed in a file this commit does not touch. The census refuses it and the
# staged reading does not, which is the whole point of the narrowing: an author answers for the
# bytes they are shipping.
new_repo staged_elsewhere
( cd "$pen/staged_elsewhere" && plant_marker > old.md && git add old.md && git commit -q -m "pen: an elder marker" \
  && printf 'clean\n' > new.md && git add new.md )
out=$( set +e; cd "$pen/staged_elsewhere" || exit 0; sh ./tools/fixtures/c/conflict_marker_scan.sh staged 2>/dev/null; exit 0 )
case "$out" in *"verdict=ok"*) echo "staged_elsewhere_free=yes" ;; *) echo "staged_elsewhere_free=no" ;; esac
out=$(run_scan staged_elsewhere)
case "$out" in *"verdict=conflict_marker"*) echo "staged_elsewhere_census_bitten=yes" ;; *) echo "staged_elsewhere_census_bitten=no" ;; esac

# --- staged_worktree_free ---------------------------------------------------------------
# The index is what a commit ships. A file staged clean and then edited in the worktree carries a
# marker no clone will receive, so the staged reading passes it -- and the census, which reads both
# sides, still refuses. The pair proves the narrowing is the MODE rather than a hole in the pattern.
new_repo staged_worktree
( cd "$pen/staged_worktree" && printf 'clean\n' > card.md && git add card.md && plant_marker > card.md )
out=$( set +e; cd "$pen/staged_worktree" || exit 0; sh ./tools/fixtures/c/conflict_marker_scan.sh staged 2>/dev/null; exit 0 )
case "$out" in *"verdict=ok"*) echo "staged_worktree_free=yes" ;; *) echo "staged_worktree_free=no" ;; esac
out=$(run_scan staged_worktree)
case "$out" in *"verdict=conflict_marker"*) echo "staged_worktree_census_bitten=yes" ;; *) echo "staged_worktree_census_bitten=no" ;; esac

# --- staged_nothing_free ----------------------------------------------------------------
# A commit that stages nothing has no bytes to answer for, and the reading says so by naming the
# population rather than by falling silent (REDS %463, one guard over).
new_repo staged_nothing
out=$( set +e; cd "$pen/staged_nothing" || exit 0; sh ./tools/fixtures/c/conflict_marker_scan.sh staged 2>/dev/null; exit 0 )
case "$out" in *"staged_files=0"*) echo "staged_nothing_named=yes" ;; *) echo "staged_nothing_named=no" ;; esac
case "$out" in *"verdict=ok"*) echo "staged_nothing_free=yes" ;; *) echo "staged_nothing_free=no" ;; esac

# --- staged_paths_agree ----------------------------------------------------------------
# TWO CODE PATHS OWE A LEG SHOWING THEY AGREE. Under the bound the query itself is narrowed by
# pathspec; over it the reading goes wide and filters afterward. The two must answer identically on
# the same pen, or the fast path is a different guard wearing the same name.
new_repo staged_agree
( cd "$pen/staged_agree" && plant_marker > card.md && printf 'clean\n' > other.md && git add card.md other.md )
narrow=$( set +e; cd "$pen/staged_agree" || exit 0; sh ./tools/fixtures/c/conflict_marker_scan.sh staged 2>/dev/null; exit 0 )
wide=$( set +e; cd "$pen/staged_agree" || exit 0; CONFLICT_MARKER_MAX_PATHSPECS=0 sh ./tools/fixtures/c/conflict_marker_scan.sh staged 2>/dev/null; exit 0 )
case "$narrow" in *"staged_narrowed=yes"*) echo "staged_narrow_taken=yes" ;; *) echo "staged_narrow_taken=no" ;; esac
case "$wide" in *"staged_narrowed=no"*) echo "staged_wide_taken=yes" ;; *) echo "staged_wide_taken=no" ;; esac
n_hits=$(printf '%s\n' "$narrow" | grep '^marked: ' | sort)
w_hits=$(printf '%s\n' "$wide"   | grep '^marked: ' | sort)
[ "$n_hits" = "$w_hits" ] && echo "staged_paths_agree=yes" || echo "staged_paths_agree=no"
case "$narrow" in *"verdict=conflict_marker"*) echo "staged_narrow_bitten=yes" ;; *) echo "staged_narrow_bitten=no" ;; esac
case "$wide" in *"verdict=conflict_marker"*) echo "staged_wide_bitten=yes" ;; *) echo "staged_wide_bitten=no" ;; esac

# --- unknown_mode_refused ---------------------------------------------------------------
# The elder spelling read `list` and treated every other word as a census, so a caller asking for a
# mode this scan does not have was answered as though it had asked for the one it does.
new_repo unknown_mode
code=$( set +e; cd "$pen/unknown_mode" || { echo 99; exit 0; }; sh ./tools/fixtures/c/conflict_marker_scan.sh wibble >/dev/null 2>&1; echo $?; exit 0 )
[ "$code" = 2 ] && echo "unknown_mode_exit=2" || echo "unknown_mode_exit=$code"
out=$( set +e; cd "$pen/unknown_mode" || exit 0; sh ./tools/fixtures/c/conflict_marker_scan.sh wibble 2>/dev/null; exit 0 )
case "$out" in *"verdict=unknown_mode"*) echo "unknown_mode_refused=yes" ;; *) echo "unknown_mode_refused=no" ;; esac

# --- hook_refuses / hook_welcomes -------------------------------------------------------
# THE WIRING, which is a second claim and wants its own pen. Every rule in tools/hooks/pre-commit
# stands behind an `[ -f ... ]` test, so a pen carrying only this scan exercises rule nine alone --
# and behind the hook's own front gate, which wants an executable rishi/bin/rishi. That gate is why
# this phase exists: the first draft of rule nine passed every scan leg above and never ran.
hook="$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)/tools/hooks/pre-commit"
if [ -f "$hook" ]; then
  new_repo hookwire
  mkdir -p "$pen/hookwire/tools/hooks" "$pen/hookwire/rishi/bin"
  cp "$hook" "$pen/hookwire/tools/hooks/pre-commit"
  chmod +x "$pen/hookwire/tools/hooks/pre-commit"
  printf '#!/bin/sh\nexit 0\n' > "$pen/hookwire/rishi/bin/rishi"
  chmod +x "$pen/hookwire/rishi/bin/rishi"
  ( cd "$pen/hookwire" && git config core.hooksPath tools/hooks )
  ( cd "$pen/hookwire" && plant_marker > card.md && git add card.md )
  code=$( set +e; cd "$pen/hookwire" || { echo 99; exit 0; }; git commit -q -m "pen: a marked card" >/dev/null 2>&1; echo $?; exit 0 )
  [ "$code" = 0 ] && echo "hook_refuses_staged_marker=no" || echo "hook_refuses_staged_marker=yes"
  ( cd "$pen/hookwire" && printf 'before\nours\nafter\n' > card.md && git add card.md )
  code=$( set +e; cd "$pen/hookwire" || { echo 99; exit 0; }; git commit -q -m "pen: resolved" >/dev/null 2>&1; echo $?; exit 0 )
  [ "$code" = 0 ] && echo "hook_welcomes_resolved=yes" || echo "hook_welcomes_resolved=no"
else
  echo "hook_refuses_staged_marker=no_hook"
  echo "hook_welcomes_resolved=no_hook"
fi

echo "control_verdict=ok"
