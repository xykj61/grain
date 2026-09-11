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
  # ONE PROCESS FOR THE WHOLE SPINE. The elder form walked two file lists, spending a
  # `git cat-file -e` and a `git show` on each path of the first and a `git show` on each path
  # of the second -- 878 `git show` calls and 440 existence checks against a 440-file ledger,
  # measured `20260910.223000` on this pier, which was 3,940 of the guard's 3,958 processes.
  # `git cat-file --batch` takes one path per line on standard input and streams every blob,
  # so the two walks become one union list read by one process.
  #
  # A shelf may stand upstream and not here, or here and not upstream, so the union of both
  # lists is what the two walks produced between them -- and a path the ref lacks is handled
  # rather than dropped: `--batch` answers `<input> missing` on a single line, which carries
  # no row headline, so the same `pairs_of` sed finds nothing there and the `cat-file -e`
  # guard is inherent rather than removed.
  #
  # The header line `<oid> blob <size>` cannot be mistaken for a row either, for the same
  # reason: the pattern anchors on `**REDS %` at the start of a line.
  { cat "$work/files.txt"
    git ls-tree -r --name-only "$anointed" -- construction 2>/dev/null \
      | grep -E '^construction/(REDS\.md|archive/REDS-.*rows-.*\.md)$'
  } | sort -u > "$work/sharedfiles.txt"
  sed "s|^|$anointed:|" "$work/sharedfiles.txt" \
    | git cat-file --batch 2>/dev/null \
    | pairs_of >> "$work/shared.txt"
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
published_doubles=0
if [ "$anointed_ok" = yes ]; then
  # ONE PASS FOR THE WHOLE JOIN. The elder form read one row at a time and spawned a fresh `awk`
  # per row to look the number up in the anointed spine -- 615 rows against a 615-row spine, so
  # 615 processes to answer 615 questions of one 20 KB file. `awk` already takes two files and
  # already holds a hash, so the spine is read ONCE into two maps and every local row is answered
  # from memory.
  #
  # FIRST LINE WINS, exactly as the elder `{print $2; exit}` did. Both files are `sort -u`'d, so
  # for a number bound twice the first line carries the lexically smaller stamp, and `!(k in m)`
  # preserves that choice rather than letting a later line overwrite it. Reproducing the elder
  # tiebreak matters more than improving it: the published doubles below are named by these very
  # stamps, and a different pick would rewrite seven detail lines that a reader has already read.
  #
  # `FILENAME == sharedf` RATHER THAN `NR == FNR`, AND A WITNESS IS WHAT TAUGHT IT. The idiom
  # `NR == FNR` partitions two files only while the FIRST one has lines: an empty first file never
  # advances `FNR`, so the second file's own first line reads `NR == FNR` as true and is swallowed
  # by the map-building rule. Every map then stays empty and every answer comes back zero -- a
  # silent wrong reading rather than a refusal. The first draft of this pass wrote `NR == FNR` in
  # all three joins, read identically on the live tree where neither file is ever empty, and was
  # caught by `reds_ledger_monotone_witness.rish` in a pen with no anointed ref: `local_rows=2`
  # with a planted double-booking answered `double_booked=0`. Comparing `FILENAME` names the file
  # rather than counting it, so an empty side is simply an empty map.
  #
  # THE CLASSIFICATION STAYS IN THE SHELL. `awk` decides WHICH of the three shapes a row wears and
  # prints its fields; the counters and the prose stay where they were, so the three messages read
  # word for word as before and a diff shows a join replaced rather than a verdict rewritten.
  if ! awk -v sharedf="$work/shared.txt" '
    FILENAME == sharedf {
      if ($1 == "") next
      if (!($1 in up)) up[$1] = $2
      if (!($2 in where)) where[$2] = $1
      next
    }
    {
      if ($1 == "") next
      if (!($1 in up)) next
      if (up[$1] == $2) next
      if ($2 in where) {
        if (where[$2] == $1) { print "published_double", $1, up[$1], $2; next }
        print "rebinding", $1, up[$1], where[$2], $2
        next
      }
      print "squatting", $1, up[$1], $2
    }
  ' "$work/shared.txt" "$work/local.txt" > "$work/verdicts.txt"; then
    echo "refused: the anointed-comparison join failed -- no verdict can be given about rebinding" >&2
    exit 2
  fi
  while read -r kind n up_stamp a b; do
    case "$kind" in
      published_double)
        # ONE NUMBER BOUND TO TWO PUBLISHED STAMPS IS NOT A REBINDING A LAP CAN REPAIR, and calling it
        # one reddens eight ships every lap on a fault none of them may touch. A rebinding means THIS
        # tree binds a number the anointed spine bound elsewhere -- repairable here, by renumbering the
        # unshared row. A published double-binding means the ANOINTED SPINE ITSELF carries the number
        # twice: `derived-spine` rule 3 holds for both rows, so neither may move, and the two rules
        # meet head on. That deadlock is Keaton's word rather than a lap's, and it stands booked at
        # `20260907.014654`. Counted and named separately from `20260907.024141`, so the gate keeps
        # biting what a lap can fix and stops biting what it cannot.
        published_doubles=$((published_doubles + 1))
        detail "detail: published_double %$n -- the anointed spine binds this number to BOTH $up_stamp and $a; rule 3 holds for each, so no lap may move either. Keaton's word, booked 20260907.014654"
        ;;
      rebinding)
        rebindings=$((rebindings + 1))
        detail "detail: rebinding %$n -- the anointed spine binds it to $up_stamp, and binds $b to %$a"
        ;;
      squatting)
        rebindings=$((rebindings + 1))
        squatters=$((squatters + 1))
        detail "detail: squatting %$n -- the anointed spine spent it on $up_stamp; this row ($a) is unshared and derives above %$shared_max"
        ;;
    esac
  done < "$work/verdicts.txt"
fi

# A stamp the anointed spine carries and this tree does not. Reported rather than gated: a fold,
# a shelf this checkout has not fetched, or a genuinely dropped row all look like this, and only
# the third is a fault. A gate here would red on ordinary work, which is a gate someone turns off.
dropped=0
if [ "$anointed_ok" = yes ]; then
  # The same whole-file join as above, pointed the other way: this tree's stamps read into one set,
  # the anointed spine's rows counted against it in one pass rather than one `awk` per shared row.
  #
  # AND THE REFUSAL STOPS BEING A READING. The elder form wrote `awk ... && continue`, which spends
  # the exit status on the ANSWER -- found is 0, absent is 1 -- so an `awk` that genuinely failed
  # was counted as a dropped stamp and the number came back larger with nothing said. That is the
  # shape `instrument_refusal` holds at zero. The count is printed now and the exit status carries
  # failure alone.
  if ! dropped=$(awk -v localf="$work/local.txt" '
    FILENAME == localf { if ($1 != "") seen[$2]; next }
    { if ($1 == "") next; if (!($2 in seen)) c++ }
    END { print c + 0 }
  ' "$work/local.txt" "$work/shared.txt"); then
    echo "refused: the dropped-stamp join failed -- no verdict can be given about dropped rows" >&2
    exit 2
  fi
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
# A DOUBLE-BOOKING THE ANOINTED SPINE ALREADY CARRIES IS NOT ONE THIS LAP MADE (`20260907.024141`).
# The gate above is right in principle -- a number meaning two rows breaks every citation that trusts
# it -- and it reads the local spine, which on every ship is a copy of the anointed one. So a pair
# published upstream reddens EIGHT SHIPS EVERY LAP on a fault none of them may repair: `derived-spine`
# rule 3 holds for both rows, so neither number may move, and the deadlock is Keaton's word (booked
# `20260907.014654`). Such a pair is counted as `published_doubles` and named loudly; the GATE keeps
# biting a pair this tree created, which is the class a lap can actually fix by renumbering its own
# unshared row. A gate that reds on what nobody may touch is a gate somebody turns off.
double_booked=0
# NO `|| true` HERE. `uniq -d` prints nothing when there are no duplicates and still exits 0, so the
# empty case needs no rescue -- and a `|| true` would discard a REAL failure of awk or sort, which is
# the shape `instrument_refusal` gates at zero. It caught this line on the lap that wrote it.
if ! awk '{print $1}' "$work/local.txt" | sort | uniq -d > "$work/dupes.txt"; then
  echo "refused: the duplicate-number read failed -- no verdict can be given about double-booking" >&2
  exit 2
fi
# THE THIRD JOIN OF THE SAME FAMILY, and the reason it is here rather than left alone: every
# duplicate number spent an `awk`, a `wc` and a `tr` to ask one question of the spine already in
# hand -- does the anointed spine bind this number twice? One pass counts each number's rows once
# and prints only the duplicates the spine does NOT already carry twice, which is the set the elder
# `else` branch reached. With no anointed ref the counts are empty, so every duplicate is named,
# exactly as the elder `[ "$anointed_ok" = yes ] &&` short-circuit did.
if ! awk -v sharedf="$work/shared.txt" '
  FILENAME == sharedf { if ($1 != "") c[$1]++; next }
  { if ($1 == "") next; if (c[$1] >= 2) next; print $1 }
' "$work/shared.txt" "$work/dupes.txt" > "$work/doubles.txt"; then
  echo "refused: the duplicate-number join failed -- no verdict can be given about double-booking" >&2
  exit 2
fi
while IFS= read -r n; do
  [ -n "$n" ] || continue
  double_booked=$((double_booked + 1))
  detail "detail: double_booked %$n -- this tree binds one number to two stamps"
done < "$work/doubles.txt"

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

# `--next` REFUSES MID-REBASE. The allocator above starts at the anointed maximum and then SKIPS past
# any number the LOCAL tree holds -- which is right when booking a second row, and wrong when the
# first is still in flight, because a replaying tree holds the very row being renumbered. Nothing in
# the reading can tell an in-flight row from a settled one. A rebase can, so it does.
#
# THIS IS A PRECAUTION RATHER THAN A REPAIR, and the difference is worth stating because an elder
# draft of this comment got it backwards. It cited the Petrichor seat being answered 436 against an
# anointed maximum of 434 -- taken from that seat's own report and never checked. Verified after:
# `%435` stands on the anointed spine, folded to
# `construction/archive/REDS-the-page-that-became-its-own-ancestor-rows-435.md`, so the maximum was
# 435 and **436 was the correct answer**. The skip never fired. The hazard the refusal guards is
# real and has simply not happened yet.
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
echo "published_doubles=$published_doubles"
echo "squatters=$squatters"
echo "dropped_upstream_stamps=$dropped"
echo "stamp_duplicates=$stamp_duplicates"
echo "double_booked=$double_booked"
echo "next_free=$next_free"

if [ "$rebindings" -ne 0 ]; then echo "verdict=rebinding"; exit 1; fi
if [ "$double_booked" -ne 0 ]; then echo "verdict=double_booked"; exit 1; fi
echo "verdict=ok"
