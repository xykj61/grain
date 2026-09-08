#!/bin/sh
# tools/fixtures/r/reds_ledger_monotone_scan.sh -- REDS row numbers accrete, never rewrite.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
#
# Companion to reds_ledger_scan.sh (three fields - living-pin bound).
# This seam proves row indices are 1..N with no gaps and no duplicates --
# the mechanical half of "rows are never edited or removed."
#
# Fold-aware (20260811.143500): a closed-range fold moves a contiguous PREFIX of
# rows into an archive file to keep the living pin under bound, so the living
# ledger holds only a suffix. The 1..N spine therefore spans the living pin AND its
# fold archives together. Pass every file that holds rows (the archives then the
# living pin); this scan unions their row indices and proves the UNION is 1..N with
# no gaps or dupes -- so a fold never breaks the spine and a bundle still cannot
# silently rewrite a landed row number. Before this, the scan read one file and
# expected it to start at 1, so it went red the moment the first fold landed.
#
# TWO ROW SHAPES (20260820.232126, REDS %102). The ledger grew a second shape and
# this scan was never taught it. Elder rows are table lines opening on a digit cell;
# every row from %81 forward is prose -- a bold `**REDS %N ...**` opening followed by
# the three fields in italics. Reading only the table shape, this scan could see 73
# of the 101 rows that exist, and it answered `verdict=ok` over that partial spine
# because the witness above it happened to pass only the three archives whose rows
# were all table-shaped. A count that cannot see what it measures is a guess wearing
# a measurement's clothes -- REDS %97's own lesson, which repaired the sibling scan
# beside this one and left this one exactly as it was. Both shapes are unioned now,
# so the spine is proven over every row the ledger actually holds.

set -eu
# THE DEFAULT SPANS THE SHELVES (REDS %237). Called with no arguments this once read
# construction/REDS.md alone, which since the first fold holds a SUFFIX of the spine -- three
# rows on 20260825 against 232 -- so every bare caller got `verdict=not_monotone` from a ledger
# that was perfectly whole. Fourteen scans in tools/fixtures/ call it bare, and the comment
# above them has said `pass every file that holds rows` the whole time. A default that
# contradicts its own documentation is a trap rather than a convenience, so the default now
# does what the witness beside it does. A caller naming its own files still overrides, which is
# what the planted single-file pens in the witness rely on.
if [ "$#" -eq 0 ]; then
  set -- construction/REDS.md
  for shelf in construction/archive/REDS-*rows-*.md; do
    # An unmatched glob stays literal in POSIX sh, so a tree that has never folded is read
    # exactly as it was before -- the living pin alone, and honestly.
    [ -f "$shelf" ] && set -- "$shelf" "$@"
  done
fi
for f in "$@"; do
  [ -f "$f" ] || { echo "detail: absent ($f)"; echo "verdict=missing_ledger"; exit 2; }
done

# Union every "| N |" row index across all given files, sorted numerically.
# Both shapes: the elder table line opening on a digit cell, and the prose row opening
# on a bold `**REDS %N` or `**REDS #N` -- the living ledger writes the latter and wrote
# the former, so the spine spans both.
mentions=$(for f in "$@"; do
  sed -n 's/^| *\([0-9][0-9]*\) *|.*/\1/p' "$f"
  sed -n 's/^\*\*REDS [%#]\([0-9][0-9]*\).*/\1/p' "$f"
done | sort -n)

# The spine is the DISTINCT set of row numbers, because the ledger honestly names one
# row more than once: a full row is written when the red is found, and a closure note
# written later speaks ABOUT that row rather than opening a new one, keeping its number
# (REDS %97 drew exactly this distinction in the sibling scan). Counting mentions would
# read every closure note as a duplicate and refuse a ledger that is perfectly whole --
# a gate that reds on valid input, which REDS %100 named as its own kind of fault. Both
# counts are printed, so the gap between them stays visible rather than folded away.
n_mentions=$(printf '%s\n' "$mentions" | grep -c '[0-9]' || true)
sorted=$(printf '%s\n' "$mentions" | sort -n -u)

rows=0
expect=1
fail=0
for n in $sorted; do
  rows=$((rows + 1))
  if [ "$n" -ne "$expect" ]; then
    echo "detail: expected row $expect, found $n"
    fail=$((fail + 1))
  fi
  expect=$((n + 1))
done

# THE SPINE PROVES WHOLE, NOT DISTINCT (REDS %287). Everything above proves the row numbers
# run 1..N with no gaps or duplicate NUMBERS, which is what "rows are never edited or removed"
# needs -- and a spine can be perfectly whole while holding one incident twice under two
# numbers. That is what two piers allocating from their own trees produce: a red booked on one
# bench, shifted onto the other by a merge repair, then re-seated a second time when it arrived
# again from upstream. Measured 20260826: %249/%271, %250/%272 and %251/%273 are three
# incidents standing twice, so a spine reading 285 holds 282 distinct reds. REDS %230 named the
# blindness one layer back -- a guard cannot see a collision it has no second tree to compare
# against -- and after a merge there is no second tree, so the collision is inside this one
# wearing two names.
#
# THE READING. A headline is the row's own one-sentence identity, so one headline published
# under two DIFFERENT row numbers is the signal. Pairs are deduped by (number, headline) first,
# so a row and its own closure note stay one row -- the same welcome the mentions/rows split
# above already makes, because a gate that reds on valid input teaches the bench to route
# around it (REDS %100).
#
# A CEILING THAT ONLY FALLS, rather than a gate at zero. The three pairs standing today are on
# dated shelves and in the living pin, and resolving them edits testimony, which is Keaton's
# word under `debride`. So this holds the line where it stands and refuses the fourth.
duplicate_headlines_ceiling=3

pairs=$(for f in "$@"; do
  awk '
    /^\*\*REDS [%#][0-9]+/ {
      line = $0
      match(line, /^\*\*REDS [%#][0-9]+/)
      num = substr(line, RSTART, RLENGTH)
      sub(/^\*\*REDS [%#]/, "", num)
      rest = substr(line, RSTART + RLENGTH)
      p = index(rest, " -- ")
      if (p == 0) next
      head = substr(rest, p + 4)
      q = index(head, "**")
      if (q > 0) head = substr(head, 1, q - 1)
      printf "%s\t%s\n", num, head
    }
  ' "$f"
done | sort -u)

dup_file=$(mktemp)
printf '%s\n' "$pairs" | cut -f2- | sort | uniq -d > "$dup_file"
duplicate_headlines=$(wc -l < "$dup_file" | tr -d ' ')


# THE NUMBER NAMES ONE ROW (REDS %536). Everything above proves the spine COVERS 1..N, and that
# no one headline stands under two numbers. Neither reading can see the mirror fault: one NUMBER
# standing over two rows. Coverage is answered by a duplicate exactly as well as by a unique row,
# because the duplicate's twin fills the slot a missing number would otherwise leave -- so a tree
# whose spine is internally doubled reads `gaps_or_dupes=0` and calls itself whole. That is what
# %530 did on 20260907: two rows, two stamps, both published. The only instrument that saw it was
# reds_spine_derive_scan.sh, which compares this tree against the REMOTE, so the doubling reddened
# in the NEXT ship to fetch rather than in the tree that made it, eighty minutes after it landed.
#
# THE KEY IS THE STAMP (.claude/rules/derived-spine.md): a row's immutable identity is its
# one-clock stamp, and the %N beside it is a view the anointed remote allocates. So the reading is
# over (number, stamp, file), and it holds two properties that fail differently:
#
#   numbers_double_bound -- one number carrying more than one stamp. Two incidents wear one
#                           number, and the repair is a word on which of them renumbers.
#   rows_double_shelved  -- one (number, stamp) standing in more than one file. One incident is
#                           written twice, and whether that is a FAULT is a reading rather than a
#                           rule. %512's two shelves are deliberate and say so on their own faces:
#                           two hands folded one row without knowing, and both pages were kept --
#                           one carrying what the row taught, one how it ended. So this reading
#                           counts and names; it does not prescribe.
#
# They are named apart rather than summed because a refusal that cannot say which repair is
# wanted gives an exact number and no way to act (REDS %528). Each stands at exactly one instance
# today: %530 is double-bound, which is a genuine collision, and %512 is double-shelved, which is
# a pair somebody chose.
#
# WHAT COUNTS AS A ROW OPENING, and why the shape is this narrow. Measured 20260907 over the 447
# openings on disk, three other line shapes carry the bold sigil and a number:
#
#   - a closure note -- `**REDS %112 CLOSED (`stamp`) -- ...` -- which lawfully re-states its own
#     row's number under its own LATER stamp. Fourteen numbers do this, and reading them as second
#     rows would refuse a ledger that is perfectly whole, which is the gate REDS %100 named;
#   - a note wearing some other word -- `**REDS %83 prevention LANDED (`20260817`) -- ...`;
#   - a prose mention that happens to open a line -- `**REDS %155**, which found ...` -- carrying
#     no stamp at all.
#
# One fact written on the line itself tells all three from an opening: an opening puts the stamp
# IMMEDIATELY after the number, with no word between. Requiring that parenthesised stamp does both
# jobs at once -- it excludes the prose mention, and it hands the row its true key. Across 447
# openings the reading finds exactly the two faults above and no others, so the discrimination is
# measured rather than argued. The elder rows carry a date-only stamp, so both widths are read;
# spelled out digit by digit rather than with an interval, since interval expressions are not
# something every awk on a borrowed pier answers to.
#
# `rows_double_shelved` KEEPS ITS CEILING, and for the same reason duplicate_headlines_ceiling
# carries above: its one instance stands on published dated shelves, so touching it edits testimony
# -- Keaton's word under `debride` -- and it is not a fault at all, merely a pair somebody kept.
rows_double_shelved_ceiling=1

# `numbers_double_bound` IS REPORTED HERE AND GATED ELSEWHERE (REDS `20260907.230000`). It carried a
# ceiling of 1 until this reading was written, on the argument that holding the line makes the NEXT
# doubling red inside the tree that made it. That argument wants one fact this scan cannot reach:
# whether the doubling is one a lap may repair.
#
# `tools/fixtures/r/reds_spine_derive_scan.sh` reads the ANOINTED remote and splits the class in two.
# A pair this tree created is `double_booked`, gated at zero, and a lap repairs it in one line by
# renumbering its own unshared row. A pair the anointed spine already carries is `published_doubles`,
# reported and gated by nothing: `.claude/rules/derived-spine.md` rule 3 holds for BOTH rows, so no
# lap may move either, and the deadlock is Keaton's word (booked `20260907.014654`).
#
# This scan reads FILES. It sees a number standing over two stamps and it cannot see which side of
# that split the pair falls on, so a ceiling here bites both classes identically. On `20260907` the
# second published double landed -- `%592`, bound to `20260907.211709` on a shelf and to
# `20260907.215114` on the living pin, both already on `xy/main` -- and this ceiling reddened
# `reds_ledger_monotone` and `reds_row_present` on every ship that fetched it, for a fault none of
# them may touch. `reds_spine_derive` read the same tree, the same hour, and answered `verdict=ok`
# with `published_doubles=2` beside it, because it could see what this reading cannot.
#
# So the teeth move to the instrument holding the remote, and the count stays here where it is
# cheap and where the pen can plant it. Two derivations of one law that disagree are one law
# written twice, and the blind one was holding the gate.

bindings=$(for f in "$@"; do
  awk '
    match($0, /^\*\*REDS [%#][0-9][0-9]* \(`[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9](\.[0-9][0-9][0-9][0-9][0-9][0-9])?`\)/) {
      s = substr($0, RSTART, RLENGTH)
      num = s; sub(/^\*\*REDS [%#]/, "", num); sub(/ .*/, "", num)
      st = s; sub(/^.*\(`/, "", st); sub(/`\).*/, "", st)
      printf "%s\t%s\t%s\n", num, st, FILENAME
    }
  ' "$f"
done | sort -u)

n_bindings=$(printf '%s\n' "$bindings" | grep -c '	' || true)

# A number bound to more than one stamp. The (number, stamp) pairs are deduped first, so one row
# copied onto two shelves counts here as the single binding it is, and lands in the reading below.
bound_file=$(mktemp)
printf '%s\n' "$bindings" | cut -f1,2 | sort -u | cut -f1 | sort -n | uniq -d > "$bound_file"
numbers_double_bound=$(grep -c '[0-9]' "$bound_file" || true)

# One (number, stamp) standing in more than one file. The triples are already deduped, so a row
# mentioned twice within one shelf counts once and only a genuine second home is read.
shelved_file=$(mktemp)
printf '%s\n' "$bindings" | cut -f1,2 | sort | uniq -d > "$shelved_file"
rows_double_shelved=$(grep -c '[0-9]' "$shelved_file" || true)
echo "mentions=$n_mentions"
echo "rows=$rows"
echo "expect_next=$expect"
echo "gaps_or_dupes=$fail"
echo "duplicate_headlines=$duplicate_headlines"
echo "duplicate_headlines_ceiling=$duplicate_headlines_ceiling"
echo "bindings=$n_bindings"
echo "numbers_double_bound=$numbers_double_bound"
echo "numbers_double_bound_gated_by=reds_spine_derive"
echo "rows_double_shelved=$rows_double_shelved"
echo "rows_double_shelved_ceiling=$rows_double_shelved_ceiling"
while IFS= read -r h; do
  [ -n "$h" ] || continue
  ns=$(printf '%s\n' "$pairs" | awk -F'\t' -v h="$h" '$2==h { printf "%%%s ", $1 }')
  echo "detail: one headline under ${ns}-- $(printf '%s' "$h" | cut -c1-72)"
done < "$dup_file"
rm -f "$dup_file"
while IFS= read -r n; do
  [ -n "$n" ] || continue
  ss=$(printf '%s\n' "$bindings" | awk -F'\t' -v n="$n" '$1==n { printf "%s ", $2 }')
  echo "detail: %$n is bound to ${ss}-- two incidents under one number; sh tools/fixtures/r/reds_spine_derive_scan.sh says whether a lap may repair it"
done < "$bound_file"
rm -f "$bound_file"
while IFS= read -r line; do
  [ -n "$line" ] || continue
  n=$(printf '%s' "$line" | cut -f1)
  s=$(printf '%s' "$line" | cut -f2)
  fs=$(printf '%s\n' "$bindings" | awk -F'\t' -v n="$n" -v s="$s" '$1==n && $2==s { printf "%s ", $3 }')
  echo "detail: %$n (\`$s\`) stands in ${fs}-- one incident on two shelves; open both before judging"
done < "$shelved_file"
rm -f "$shelved_file"
if [ "$rows" -eq 0 ]; then echo "verdict=no_rows"; exit 1; fi
if [ "$fail" -eq 0 ] &&
   [ "$duplicate_headlines" -le "$duplicate_headlines_ceiling" ] &&
   [ "$rows_double_shelved" -le "$rows_double_shelved_ceiling" ]; then
  echo "verdict=ok"
  exit 0
fi
if [ "$fail" -ne 0 ]; then echo "verdict=not_monotone"; exit 1; fi
if [ "$duplicate_headlines" -gt "$duplicate_headlines_ceiling" ]; then
  echo "verdict=duplicate_rows"
  echo "refused: one headline stands under two row numbers past the ceiling -- read the lines above" >&2
  exit 1
fi
# One incident in two files is repaired by opening both and choosing, which is a different act from
# every refusal above, so it keeps its own word rather than sharing one that would tell a reader
# something is doubled and leave them to find out what (REDS %528).
echo "verdict=row_double_shelved"
echo "refused: one row stands in two files past the ceiling -- read the lines above" >&2
exit 1
