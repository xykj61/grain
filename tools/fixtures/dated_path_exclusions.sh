#!/bin/sh
# tools/fixtures/dated_path_exclusions.sh -- what the dated-path tools do not look at. One list.
#
# WHY THIS FILE EXISTS. Two tools act on the same corpus of dated references: the census counts
# them and the repointer rewrites them. They must agree on what is NOT the field, and for one day
# they did not.
#
# The census learned first, reddening on its own demonstration paths, and excluded `dated_path_*`
# by name. The repointer -- written the same day, for the same corpus -- never received that
# lesson, and its apply run rewrote the witness's deliberately stale fixture, leaving the rung that
# proves the fold rule works proving nothing (REDS %121). Within the hour of booking that red, the
# two lists had diverged AGAIN: the census gained `shipped_binary_claim_control.sh` and the
# repointer did not.
#
# Twice is not carelessness, it is structure. A list kept in two places is two lists that happen to
# match today. So there is one list, here, and both tools read it.
#
# WHAT BELONGS ON IT, and the test is the same for every entry: **is this the field, or the
# instrument?** A tool that demonstrates recovery must cite a path that no longer resolves; a
# control that proves a guard refuses must plant the thing it refuses. Those paths are fixtures,
# not defects and not references -- counting them makes a meter rise as its proof gets stronger,
# and rewriting them disarms the proof entirely.
#
# HOW TO ADD ONE. Add the name below, once. Both tools pick it up, and
# `tools/dated_path_witness.rish` proves neither has drifted back to a private copy.
#
#   . tools/fixtures/dated_path_exclusions.sh
#   dp_grep_excludes   # sets "$@" to grep flags:  --exclude-dir=X ... --exclude=Y ...
#   dp_find_excludes   # sets "$@" to find tests:  ! -name Y ...
#   dp_find_paths      # sets "$@" to find tests:  ! -path ./Z ...
#   dp_paths_roster    # one excluded path per line, for consumers that filter afterward
#   dp_find_prune      # sets "$@" to find tests:  -name X -o -name Y ...   (for -prune)

# SURVEYED `20260821.203103`, AND THE OTHER LISTS DELIBERATELY STAY SEPARATE. Three more scan
# scripts in tools/fixtures carry exclusions, and the instinct after unifying these two was to
# gather those as well. Measurement said no, and the reasoning is recorded here so a later round
# does not re-open it and "helpfully" merge them:
#
#   shipped_binary_claim_scan.sh -- shares `.git seed vendor` and adds `gratitude`, because
#     third-party study notes make no claims about OUR tools. Folding it in would either scan that
#     text for claims it cannot make, or -- if `gratitude` joined the list below -- drop 113 dated
#     references from the census including SIX genuinely broken ones. A merge that hides real
#     breakage is not a merge.
#
#   vols_survey_truth.sh and vols_survey_crosscount.sh -- a survey scope rather than a field
#     boundary, and the two differ from each other on purpose: `truth` walks the real tree while
#     `crosscount` walks a fixture tree, so a narrower list fits a smaller corpus. Both witnesses
#     stand GREEN.
#
# THE TEST FOR WHETHER TWO LISTS SHOULD MERGE is whether they answer the same QUESTION, not
# whether they share entries. These two did -- both ask "what is not the field, and what is the
# instrument?" -- and the volatile half, the fixture names, grows with every tool that plants one.
# The three-directory base below is stable and duplicating it elsewhere costs nothing.
#
# Directories that are not this field at all: object storage and third-party source held
# unmodified. Matched by NAME, so an entry here prunes that directory wherever it sits -- correct
# only where the name is unambiguous in this tree, which was measured rather than assumed: `.git`
# and `vendor` each occur exactly once, at the root.
DP_EXCLUDE_DIRS=".git vendor"

# ONE NAME, TWO MEANINGS -- and the two matchers can not both anchor it (REDS %122).
#
# `seed/` at the root is the gitignored projection of this same tree, and pruning it is what keeps
# every reference from being counted twice. `recursion-prompts/seed/` is the loop's own seed room,
# and a NAME match prunes it too. That collateral is how the council rota came to hold five dead
# paths after the fold with neither tool noticing: both were blind to the room those paths live in.
#
# find anchors cleanly -- `-path ./seed` matches the whole path, so the projection is pruned and
# the loop's room is kept. GREP CANNOT: --exclude-dir matches the directory NAME here, and a
# leading ./ in the pattern simply never matches, which a first attempt at this fix read as
# success because the check it was read from could not have matched either. So grep keeps the
# name exclusion and the collateral room is RE-ADMITTED explicitly, scanned in its own pass.
# Measured rather than assumed: `.git` and `vendor` each occur once, at the root, so their name
# match carries no collateral; `seed` occurs twice, which is why only it needs this treatment.
DP_EXCLUDE_ROOT_DIRS="./seed"

# The directory name that root path reduces to -- what grep must be given, since it matches names.
DP_EXCLUDE_ROOT_NAMES="seed"

# Rooms pruned only as collateral of a name match above, to be scanned in their own pass and
# folded back into the corpus. A consumer that skips this re-admit is blind to the room.
DP_READMIT_DIRS="recursion-prompts/seed"

# Files whose dated paths are the instrument's own fixtures rather than citations of the field.
# Matched by NAME, so an entry here excludes that filename wherever it sits.
DP_EXCLUDE_NAMES="dated_path_* room_bound_control.sh session_logs_archive.rye shipped_binary_claim_control.sh"

# The same test, applied to a file whose NAME cannot carry the exemption. `docs-geode/demos/`
# demonstrates the resolver recovering a stale reference, which requires quoting one -- and the
# page prints the answer it gets, so repointing the reference would make its own quoted output
# wrong. Its basename is README.md, which no name-match could exempt without exempting every
# README in the tree, so exact paths get their own list. Written relative to the repository root,
# without a leading ./ -- each consumer adds what its own matcher needs.
DP_EXCLUDE_PATHS="docs-geode/demos/README.md"

# Each helper REPLACES the positional parameters, so a caller captures its own arguments first.
# Globbing is disabled while the list is expanded, because `dated_path_*` is a pattern meant for
# grep and find rather than one the shell should resolve against the working directory.

dp_grep_excludes() {
  set -f
  _dp=""
  for _d in $DP_EXCLUDE_DIRS; do _dp="$_dp --exclude-dir=$_d"; done
  for _d in $DP_EXCLUDE_ROOT_NAMES; do _dp="$_dp --exclude-dir=$_d"; done
  for _n in $DP_EXCLUDE_NAMES; do _dp="$_dp --exclude=$_n"; done
  set -- $_dp
  set +f
  printf '%s\n' "$@"
}

dp_find_excludes() {
  set -f
  _dp=""
  for _n in $DP_EXCLUDE_NAMES; do _dp="$_dp ! -name $_n"; done
  set -- $_dp
  set +f
  printf '%s\n' "$@"
}

dp_find_paths() {
  set -f
  _dp=""
  for _p in $DP_EXCLUDE_PATHS; do _dp="$_dp ! -path ./$_p"; done
  set -- $_dp
  set +f
  printf '%s\n' "$@"
}

# For consumers that cannot exclude by path at match time -- grep has no --exclude-path -- the same
# list is emitted as a plain roster to filter against afterward.
dp_paths_roster() {
  set -f
  set -- $DP_EXCLUDE_PATHS
  set +f
  printf '%s\n' "$@"
}

dp_find_prune() {
  set -f
  _dp=""
  _first=1
  for _d in $DP_EXCLUDE_DIRS; do
    if [ "$_first" = 1 ]; then _dp="-name $_d"; _first=0; else _dp="$_dp -o -name $_d"; fi
  done
  for _d in $DP_EXCLUDE_ROOT_DIRS; do
    if [ "$_first" = 1 ]; then _dp="-path $_d"; _first=0; else _dp="$_dp -o -path $_d"; fi
  done
  set -- $_dp
  set +f
  printf '%s\n' "$@"
}

# The collateral rooms, emitted as plain paths for a consumer to scan in a second pass.
dp_readmit_dirs() {
  set -f
  set -- $DP_READMIT_DIRS
  set +f
  printf '%s\n' "$@"
}
