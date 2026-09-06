#!/bin/sh
# tools/fixtures/r/reds_citation_control.sh -- plant a citation whose number and path name different
# rows, and watch the scan bite.
#
# WHY A PEN AND NOT THE FIELD. The gate reads zero on this tree and is meant to, so nothing here
# could ever show it able to refuse -- and a refusal proven only in the passing direction cannot be
# told from a bypass. The pen supplies the cases the field does not hold, in real git repositories,
# every refusal planted and then lifted so the same bytes are shown to read both ways.
#
# WHAT EACH CASE IS FOR. The two welcomes are asserted as hard as the refusals, because the reading
# that cost this round its lap was a false positive: a nearest-preceding-%N window called 32 honest
# sentences wrong before the form was narrowed to the two that are promises. Cases 6 and 7 are that
# narrowing, proven -- a `%N` after the link, and a `%N` two lines above it, must BOTH pass.
#
# Run from the repository root; it takes no lock and touches nothing outside its own pen:
#   sh tools/fixtures/r/reds_citation_control.sh
set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

scan="$ROOT/tools/fixtures/r/reds_citation_scan.sh"
[ -f "$scan" ] || { echo "control: no scan at $scan" >&2; exit 2; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

cases=0
fails=0
repos=0

# Build a fresh repository, run the scan over it, and read one key or the verdict.
new_repo() {
  repos=$((repos + 1))
  R="$pen/r$repos"
  mkdir -p "$R"
  ( cd "$R" && git init -q . && git config user.email pen@example.invalid && git config user.name pen ) >/dev/null 2>&1
}
commit_all() { ( cd "$R" && git add -A && git commit -qm pen --no-gpg-sign ) >/dev/null 2>&1; }
read_key() { ROOT_DIR="$R" sh "$scan" 2>/dev/null | sed -n "s/^$1=//p"; }
read_verdict() { ROOT_DIR="$R" sh "$scan" 2>/dev/null | sed -n 's/^verdict=//p'; }

want() {
  cases=$((cases + 1))
  name=$1; got=$2; expect=$3
  if [ "$got" = "$expect" ]; then
    echo "  ok   $name ($got)"
  else
    echo "  FAIL $name -- read '$got', wanted '$expect'"
    fails=$((fails + 1))
  fi
}

# A shelf file the plants can name, so the pen exercises the reading rather than a missing file --
# existence is `readme_reach`'s question, and this scan asks a different one.
shelves() {
  mkdir -p "$R/construction/archive"
  : > "$R/construction/archive/REDS-a-pen-row-rows-100.md"
  : > "$R/construction/archive/REDS-a-pen-row-rows-101.md"
  : > "$R/construction/archive/REDS-a-pen-pair-rows-110-111.md"
}

echo "reds-citation control: the two forms, from both sides."

# 1 -- NUMBERED, agreeing.
new_repo; shelves
printf 'The row [`%%100`](construction/archive/REDS-a-pen-row-rows-100.md) closed.\n' > "$R/pin.md"
commit_all
want numbered_agree_welcomed "$(read_verdict)" ok
want numbered_agree_counted "$(read_key numbered_links)" 1

# 2 -- NUMBERED, disagreeing: the number says 100, the path says 101, and the path OPENS.
new_repo; shelves
printf 'The row [`%%100`](construction/archive/REDS-a-pen-row-rows-101.md) closed.\n' > "$R/pin.md"
commit_all
want numbered_disagree_bitten "$(read_verdict)" citation_disagrees
want numbered_disagree_counted "$(read_key numbered_disagree)" 1
want numbered_disagree_named \
  "$(ROOT_DIR="$R" sh "$scan" list 2>/dev/null | sed -n 's/^disagree numbered [^:]*:\([0-9]*\) .*/line\1/p')" line1

# 3 -- the plant lifted: the same file, the path corrected, reads ok. Same bytes both ways.
printf 'The row [`%%100`](construction/archive/REDS-a-pen-row-rows-100.md) closed.\n' > "$R/pin.md"
commit_all
want numbered_disagree_lifted "$(read_verdict)" ok

# 4 -- a path naming several rows: a claim matching EITHER agrees, because the shelf holds both.
new_repo; shelves
printf 'Both [`%%111`](construction/archive/REDS-a-pen-pair-rows-110-111.md) rest here.\n' > "$R/pin.md"
commit_all
want multi_row_second_number_welcomed "$(read_verdict)" ok

# 5 -- a claim matching NEITHER of a multi-row path still refuses.
printf 'Both [`%%112`](construction/archive/REDS-a-pen-pair-rows-110-111.md) rest here.\n' > "$R/pin.md"
commit_all
want multi_row_outsider_bitten "$(read_verdict)" citation_disagrees

# 6 -- SHELF, agreeing on one line.
new_repo; shelves
printf '`%%100` CLOSED, folded to its [shelf](construction/archive/REDS-a-pen-row-rows-100.md).\n' > "$R/pin.md"
commit_all
want shelf_agree_welcomed "$(read_verdict)" ok
want shelf_agree_counted "$(read_key shelf_links)" 1

# 7 -- SHELF, disagreeing ACROSS THE HARD WRAP. This is the break that actually shipped: the number
# on one line, its link on the next, and a repair that read only the half it was looking at.
new_repo; shelves
{ printf '**COPAL -- a wrapper is only transparent** `%%100` CLOSED\n'
  printf '([shelf](construction/archive/REDS-a-pen-row-rows-101.md)). The rest of the paragraph.\n'
} > "$R/pin.md"
commit_all
want shelf_wrap_disagree_bitten "$(read_verdict)" citation_disagrees
want shelf_wrap_disagree_counted "$(read_key shelf_disagree)" 1

# 8 -- the same wrap, repaired: the number and the path name one row.
{ printf '**COPAL -- a wrapper is only transparent** `%%100` CLOSED\n'
  printf '([shelf](construction/archive/REDS-a-pen-row-rows-100.md)). The rest of the paragraph.\n'
} > "$R/pin.md"
commit_all
want shelf_wrap_lifted "$(read_verdict)" ok

# 9 -- a `%N` AFTER the link is not its claim. A fold recital writes exactly this shape -- *Row 170
# folded to [link] ... -- REDS %83's own guard* -- and reading the trailing number as the claim is
# what called 32 honest sentences wrong.
new_repo; shelves
printf 'Row 100 folded to its [shelf](construction/archive/REDS-a-pen-row-rows-100.md) -- `%%83` taught it.\n' > "$R/pin.md"
commit_all
want claim_after_link_not_read "$(read_verdict)" ok

# 10 -- a `%N` two lines above is out of the window, so the link makes no numeric promise here.
new_repo; shelves
{ printf 'A paragraph naming `%%101` and nothing else.\n'
  printf '\n'
  printf 'Its [shelf](construction/archive/REDS-a-pen-row-rows-100.md) stands.\n'
} > "$R/pin.md"
commit_all
want lookback_bounded_at_one_line "$(read_verdict)" ok
want lookback_bounded_counted "$(read_key shelf_unnumbered)" 1

# 11 -- TESTIMONY keeps every word it wrote: a stamped basename holding a wrong citation is read past.
new_repo; shelves
mkdir -p "$R/session-logs/date/20260906"
printf 'The row [`%%100`](construction/archive/REDS-a-pen-row-rows-101.md) closed.\n' \
  > "$R/session-logs/date/20260906/20260906-120000_a-dated-record.md"
printf 'A living page citing [`%%100`](construction/archive/REDS-a-pen-row-rows-100.md).\n' > "$R/pin.md"
commit_all
want testimony_read_past "$(read_verdict)" ok

# 12 -- and the same wrong citation in a LIVING file refuses, so case 11 is the stamp doing the work
# rather than the reading failing to see it.
printf 'A living page citing [`%%100`](construction/archive/REDS-a-pen-row-rows-101.md).\n' > "$R/pin.md"
commit_all
want living_twin_of_testimony_bitten "$(read_verdict)" citation_disagrees

# 13 -- an UNTRACKED file is not the tree's word, so it is not read.
new_repo; shelves
printf 'A living page citing [`%%100`](construction/archive/REDS-a-pen-row-rows-100.md).\n' > "$R/pin.md"
commit_all
printf 'Untracked [`%%100`](construction/archive/REDS-a-pen-row-rows-101.md).\n' > "$R/stray.md"
want untracked_not_read "$(read_verdict)" ok

# 14 -- no document cites a shelf at all: a confident zero would be worse than a refusal.
new_repo
printf 'A page with no ledger citation in it.\n' > "$R/pin.md"
commit_all
want empty_corpus_refuses "$(read_verdict)" refused_no_corpus

# 15 -- a document naming a shelf in no readable form. The corpus is real and the reading finds
# nothing to check, which is a different refusal from an empty corpus.
new_repo; shelves
printf 'See construction/archive/REDS-a-pen-row-rows-100.md for the row, unlinked.\n' > "$R/pin.md"
commit_all
want unreadable_form_refuses "$(read_verdict)" refused_no_citation

# 16 -- an unknown mode refuses at exit 2, which is a misuse rather than a finding.
ROOT_DIR="$R" sh "$scan" fetch >/dev/null 2>&1
want unknown_mode_refuses "$?" 2

# 17 -- a subject that is no git repository at all cannot be read, and says so.
new_repo
rm -rf "$R/.git"
printf 'A page citing [`%%100`](construction/archive/REDS-a-pen-row-rows-100.md).\n' > "$R/pin.md"
want no_repository_refuses "$(read_verdict)" refused_grep_failed

echo "cases=$cases repos=$repos failed=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=a_case_read_wrong"
exit 1
