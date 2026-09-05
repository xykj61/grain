#!/bin/sh
# tools/fixtures/r/reds_spine_derive_scan.sh -- the derived spine: a row's key is its stamp,
# and its %N is a view allocated by the anointed remote rather than by a local tree.
#
# WHY THIS FILE EXISTS. A row number allocated by reading a tree is allocated PER TREE. Three
# stars write into one tree from three hosts, so two of them read the same "next free" number
# within the same hour and both book it. That is not a race anyone can be careful enough to
# avoid: both spines read perfect alone. It fired six times before this guard was written --
# %230, %252, the %283-%285 re-seat, %290's own first move, the %294-%296 re-seat, and %297's
# third seat -- and every firing was repaired by hand, renumbering rows and sweeping citations.
#
# THE KEY. A row's immutable identity is its ONE-CLOCK STAMP. The %N is a derived view: rows
# sort by stamp, the earlier stamp taking the lower number, ties broken by commit hash. The
# design is Move 1 of active-designing/20260825-205011_the-pen-the-gossip-and-the-derived-spine.md,
# seated 20260827 on Keaton's word.
#
# THE BOUNDARY, which is the whole of the safety. A row that has reached the ANOINTED REMOTE is
# SHARED, and a shared row keeps its number forever -- 2,519 citations of %N stand in the tree,
# 532 of them in immutable commit bodies, so a number that moves after publication is a citation
# broken in testimony that can never be edited. Only UNSHARED rows -- booked locally, not yet
# pushed -- may be renumbered, and this script proves that renumbering is confined to them.
#
#   sh tools/fixtures/r/reds_spine_derive_scan.sh                  # read, change nothing
#   sh tools/fixtures/r/reds_spine_derive_scan.sh --next           # print the number to book next
#   REDS_ANOINTED=xy/main sh tools/fixtures/r/reds_spine_derive_scan.sh
#   REDS_SPINE_GLOB='pen/REDS-*.md' REDS_PIN=pen/REDS.md sh ...  # for a control's pen
#
# READINGS, and which are gated at zero:
#   rebindings       -- a number the anointed spine already bound to a stamp, bound
#                       here to a different one. This is the whole fault. ENFORCED ZERO.
#   squatters        -- of those, the ones whose stamp is nowhere upstream: a new row
#                       booked from a local read onto a number upstream just spent.
#   dropped_upstream_stamps -- a stamp upstream carries and this tree does not.
#                       Reported, never gated -- an unfetched shelf looks the same.
#   stamp_duplicates -- two rows sharing a stamp to the second; lawful, and it
#                       means the commit-hash tiebreak decides. Reported.
#   next_free        -- the number a new row takes, read from the ANOINTED spine.
#
# Exit 0 ok - 1 a gated reading is non-zero - 2 misuse or an unreadable spine. A misuse exits
# DIFFERENTLY from a refusal, so a caller never reads a broken invocation as a clean ledger.
set -eu

# Every collection names a maximum (TAME). 4,096 is an order of magnitude above the 297 rows
# this ledger holds and far below anything a shell sort would struggle with.
MAX_ROWS=4096

anointed="${REDS_ANOINTED:-xy/main}"
mode=report

while [ "$#" -gt 0 ]; do
  case "$1" in
    --next)   mode=next ;;
    --remote) shift; [ "$#" -gt 0 ] || { echo "verdict=misuse_remote_needs_value" >&2; exit 2; }; anointed="$1" ;;
    --help|-h) sed -n '2,30p' "$0"; exit 0 ;;
    *) echo "verdict=misuse_unknown_arg ($1)" >&2; exit 2 ;;
  esac
  shift
done

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT INT TERM

# The spine's file set is spelled once, in reds_spine_files.sh, and asked for here rather than
# repeated -- the same discipline reds_spine_grep.sh keeps (REDS %231).
# Located beside this script rather than by a path from the repo root, so a control can run
# this scan from inside its own pen with the pen's git repository as the one git answers for.
# A DETAIL LINE IS DIAGNOSIS, AND `--next` PROMISES ONE NUMBER. The header documents `--next` as
# *print the number to book next*, and it printed forty-one lines: every `stamp_duplicate` note
# ahead of the answer, on stdout. Every caller in this tree therefore ends in `| tail -1`, which
# works and hides the shape -- a fresh caller writing `N=$(... --next)` gets a paragraph where it
# expects an integer. Details route through one emitter now, and it stays quiet in `next` mode.
detail() { [ "$mode" = next ] || echo "$1"; }

spine_files="$(dirname "$0")/reds_spine_files.sh"
if ! sh "$spine_files" > "$work/files.txt" 2>/dev/null; then
  echo "verdict=missing_ledger"
  exit 2
fi

# (number, stamp) for every row that carries a stamp. A row headline is
#   **REDS %N (`YYYYMMDD.HHMMSS`) -- headline.**
# Elder table rows carry no stamp and are frozen by age; they are counted, never derived.
pairs_of() {
  # $1 = a command that prints one file's contents
  sed -n 's/^\*\*REDS [%#]\([0-9][0-9]*\) *(`\([0-9]\{8\}\.[0-9]\{6\}\)`).*/\1 \2/p'
}

: > "$work/local.txt"
while IFS= read -r f; do
  [ -f "$f" ] || continue
  pairs_of < "$f" >> "$work/local.txt"
done < "$work/files.txt"
# Bytewise unique, never numeric: `sort -n -u` compares by the leading number alone, so two
# stamps under one number look equal and one is silently dropped -- the very fault reading 4
# gates. Order is irrelevant to every consumer; the maxima sort numerically for themselves.
sort -u -o "$work/local.txt" "$work/local.txt"

local_rows=$(grep -c '[0-9]' "$work/local.txt" || true)
if [ "$local_rows" -gt "$MAX_ROWS" ]; then
  detail "detail: $local_rows rows exceeds the declared maximum of $MAX_ROWS"
  echo "verdict=too_many_rows"
  exit 2
fi

# The anointed spine. Read from git when the ref resolves; when it does not -- a fresh clone
# with no remote, or a control's pen -- the reading says so rather than guessing, because an
# allocator that silently falls back to the local tree is the very fault this guard names.
anointed_ok=no
: > "$work/shared.txt"
if git rev-parse --verify --quiet "$anointed" >/dev/null 2>&1; then
  anointed_ok=yes
  while IFS= read -r f; do
    git cat-file -e "$anointed:$f" 2>/dev/null || continue
    git show "$anointed:$f" 2>/dev/null | pairs_of >> "$work/shared.txt"
  done < "$work/files.txt"
  # A shelf may exist upstream and not here (or the reverse), so ask the remote tree for its
  # own file set too rather than only for the paths this checkout happens to hold.
  git ls-tree -r --name-only "$anointed" -- construction 2>/dev/null \
    | grep -E '^construction/(REDS\.md|archive/REDS-.*rows-.*\.md)$' \
    | while IFS= read -r f; do
        git show "$anointed:$f" 2>/dev/null | pairs_of
      done >> "$work/shared.txt"
  sort -u -o "$work/shared.txt" "$work/shared.txt"
fi

shared_rows=$(grep -c '[0-9]' "$work/shared.txt" || true)
shared_max=$(awk '{print $1}' "$work/shared.txt" | sort -n | tail -1)
[ -n "${shared_max:-}" ] || shared_max=0
local_max=$(awk '{print $1}' "$work/local.txt" | sort -n | tail -1)
[ -n "${local_max:-}" ] || local_max=0

# THE GATED READING -- a number the anointed spine has already bound to a stamp, bound here to
# a different one. This is ONE reading rather than two, and the control is why: a "collision"
# (a new row squatting a number upstream just spent) and a "rebound" (a published row's stamp
# edited under it) are structurally identical when you compare (number, stamp) sets -- in both,
# a published number points somewhere else here. Two readings that always fire together are one
# reading wearing two names, and naming them apart would have let a control pass by watching the
# wrong counter. So the GATE is single, and the DIAGNOSIS is what tells the two apart: a local
# stamp absent from the whole anointed spine is a new row squatting; a local stamp present
# upstream under a different number is a row that moved.
rebindings=0
squatters=0
if [ "$anointed_ok" = yes ]; then
  while read -r n stamp; do
    [ -n "${n:-}" ] || continue
    up=$(awk -v k="$n" '$1 == k {print $2; exit}' "$work/shared.txt")
    [ -n "${up:-}" ] || continue
    [ "$up" = "$stamp" ] && continue
    rebindings=$((rebindings + 1))
    if awk -v s="$stamp" '$2 == s {found=1} END {exit !found}' "$work/shared.txt"; then
      elsewhere=$(awk -v s="$stamp" '$2 == s {print $1; exit}' "$work/shared.txt")
      detail "detail: rebinding %$n -- the anointed spine binds it to $up, and binds $stamp to %$elsewhere"
    else
      squatters=$((squatters + 1))
      detail "detail: squatting %$n -- the anointed spine spent it on $up; this row ($stamp) is unshared and derives above %$shared_max"
    fi
  done < "$work/local.txt"
fi

# A stamp the anointed spine carries and this tree does not. Reported rather than gated: a fold,
# a shelf this checkout has not fetched, or a genuinely dropped row all look like this, and only
# the third is a fault. A gate here would red on ordinary work, which is a gate someone turns off.
dropped=0
if [ "$anointed_ok" = yes ]; then
  while read -r n stamp; do
    [ -n "${n:-}" ] || continue
    awk -v s="$stamp" '$2 == s {found=1} END {exit !found}' "$work/local.txt" && continue
    dropped=$((dropped + 1))
  done < "$work/shared.txt"
fi

# READING 3 -- two rows sharing a stamp to the second. Lawful; it means the tiebreak decides,
# and it is reported so a hand knows the order was not chosen by stamp alone.
stamp_duplicates=$(awk '{print $2}' "$work/local.txt" | sort | uniq -d | grep -c . || true)
awk '{print $2}' "$work/local.txt" | sort | uniq -d | while IFS= read -r s; do
  [ -n "$s" ] && detail "detail: stamp_duplicate $s -- the commit-hash tiebreak decides this pair"
done

# READING 4 (%369) -- one number carrying two stamps in THIS tree's own ledger. The gated
# rebinding reads local against anointed; this reads the local spine against itself, which is
# how the %364 double-booking was measured before its row was written: distinct (number, stamp)
# pairs counted against distinct numbers, held equal. Held at zero like the rebinding gate --
# a number meaning two rows breaks every citation that trusts it.
pair_count=$(sort -u "$work/local.txt" | grep -c . || true)
number_count=$(awk '{print $1}' "$work/local.txt" | sort -u | grep -c . || true)
double_booked=$((pair_count - number_count))
awk '{print $1}' "$work/local.txt" | sort | uniq -d | while IFS= read -r n; do
  [ -n "$n" ] && detail "detail: double_booked %$n -- this tree binds one number to two stamps"
done

# The allocator. A new row takes one above the ANOINTED maximum, never one above the local
# maximum -- reading the local tree is the fault, not the fix. With no anointed ref reachable,
# the local maximum is all there is, and the reading says so plainly.
if [ "$anointed_ok" = yes ]; then
  next_free=$((shared_max + 1))
  while awk -v k="$next_free" '$1 == k {found=1} END {exit !found}' "$work/local.txt"; do
    next_free=$((next_free + 1))
  done
else
  next_free=$((local_max + 1))
fi

# `--next` REFUSES MID-REBASE, because the allocator above skips past numbers the LOCAL tree holds
# and a replaying tree holds the very row being renumbered. The Petrichor seat read `--next` during
# a rebase on `20260905`, was answered **436** while the anointed spine's highest was 434 and its own
# unshared row was 435, and renumbered six citation sites the wrong way before
# `reds_ledger_monotone` caught it. The skip is right when booking a second row and wrong when the
# first one is in flight, and nothing in the reading could tell those apart. A rebase can, so it does.
gitdir=$(git rev-parse --git-dir 2>/dev/null || echo .git)
if [ "$mode" = next ] && { [ -d "$gitdir/rebase-merge" ] || [ -d "$gitdir/rebase-apply" ]; }; then
  echo "reds_spine_derive: REFUSED -- a rebase is open, and the allocator counts this tree's own" >&2
  echo "  in-flight row as already taken. Finish or abort the rebase, then read --next." >&2
  exit 2
fi

if [ "$mode" = next ]; then
  echo "$next_free"
  exit 0
fi

echo "anointed=$anointed"
echo "anointed_reachable=$anointed_ok"
echo "shared_rows=$shared_rows"
echo "shared_max=$shared_max"
echo "local_rows=$local_rows"
echo "local_max=$local_max"
echo "rebindings=$rebindings"
echo "squatters=$squatters"
echo "dropped_upstream_stamps=$dropped"
echo "stamp_duplicates=$stamp_duplicates"
echo "double_booked=$double_booked"
echo "next_free=$next_free"

if [ "$rebindings" -ne 0 ]; then echo "verdict=rebinding"; exit 1; fi
if [ "$double_booked" -ne 0 ]; then echo "verdict=double_booked"; exit 1; fi
echo "verdict=ok"
