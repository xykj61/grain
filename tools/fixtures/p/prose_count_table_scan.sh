#!/bin/sh
# tools/fixtures/p/prose_count_table_scan.sh -- a count written above a table is a claim about that
# table's length, and until now nothing in this tree read it.
#
# WHY. A teaching page introduces a table by saying how long it is -- "Four tutorials ship from this
# room", "## The Seven Rooms" -- and the number is a copy of something standing three lines below
# it. The table grows when someone adds a row; the sentence does not. The shipping shelf has paid
# for this twice and written both receipts on its own face:
#
#   docs-geode/README.md   three sentences said *ten rooms* while the table listed twelve. They
#                          said it from the very commit that added the twelfth, and stood 16 days.
#   docs-geode/etc/README.md   named eleven neighbors while twelve stood -- and the room whose
#                          whole job is noticing a new genre was the room that missed one.
#
# Both repairs moved the count INTO the table, which is the right cure for those two pages and
# reaches no third page. Fourteen such claims stand in the teaching rooms today and every one is a
# number typed beside a thing that grows. A repair closes an instance; a reading closes a family.
#
# WHY NOTHING ELSE SEES IT. `qa_report_card` scores Truth by whether cited PATHS resolve, so a page
# with a stale count reads Truth 100 -- the blindness recorded at `20260910.073603`, when
# docs-geode/README.md told a reader the doorway guard reads 1,004 pages against a scan answering
# 1,261 and scored A+/98. `tutorial_output_scan` runs a command and compares what it PRINTS, and a
# prose count is inside no fence. `crushed_index_witness` reads this shelf's own room table against
# the rooms on disk, which is one page's one table rather than the shape. Three guards, three
# different jobs, and the sentence above the table falls between all of them.
#
# WHAT A SITE IS, and every clause of it earns its place by a false positive it removes.
#   - A count -- a numeral or a number word from two to twenty, or thirty, forty, fifty -- followed
#     by a PLURAL noun, the two separated by whitespace alone.
#   - Standing in a paragraph or a heading whose NEXT BLOCK, after one run of blank lines, is a
#     Markdown table (a header row, its delimiter, then its data rows).
#   - Whose noun's stem appears in that table's HEADER row.
#
# The noun-in-header test is the whole discriminator. Without it the reading finds 46 sites across
# this corpus and 30 are noise -- "twenty minutes" above a table of four, "sixty seconds" above a
# table of three -- because a number near a table says nothing about it. With it the reading finds
# fourteen and every one is a real claim.
#
# The NEXT-BLOCK test is the second half. docs-geode/README.md writes "The two rooms stand apart"
# three paragraphs above its thirteen-row room table, and a distance rule counting non-blank lines
# reads that as a claim of two against thirteen. A writer introduces a table with the paragraph
# immediately above it; that adjacency is the claim, and anything further up is prose about
# something else.
#
# The whitespace and plural clauses each remove exactly one live false positive, both the same
# shape -- a hyphen beside a numeral. `### 6 - The Workrooms` in MAP.md is a section number above an
# eight-row table, and `### Bar 6 -- three-door bus` in docs/ENCLOSURE.md is a compound adjective
# above a three-row table that agrees by coincidence. A count and its noun touch.
#
# WHAT IS GATED, hard, at zero: `drift` -- a count standing over a table of a different length.
# Fourteen sites, fourteen agreeing, on the day this was written. A room brought under a guard while
# it is clean stays clean; the same room brought under it later is a repair somebody has to
# schedule, which is this shelf's own sentence about the doorway guard.
#
# WHAT IS REPORTED, never gated: `near_block` -- a count standing in the paragraph or heading
# directly above a table whose header does NOT name its noun. Five stand, and reading all five is
# what shows the discriminator earning its keep rather than merely being strict: four are counts of
# something the table does not tabulate (`Two words on this shelf are our own` above the thirteen-
# room table; `three things a first hour needs` above four tutorials; `two calls`; `two holds`).
# The fifth is the honest cost -- `running-the-fleet.md` writes `Four places name it` above a table
# of four rows headed `Site`, a real claim this reading declines because the page and its own table
# choose different words for one thing. A synonym is past what a header test can reach, and naming
# that here is cheaper than guessing at it.
#
# WHAT THIS DOES NOT REACH, said plainly.
#   - A count above a LIST rather than a table, which is counted as `listform` and left ungated.
#     A list carries no header row, so the noun-matching test has nothing to read, and the reading
#     falls back to adjacency alone. Measured over this corpus: NINETEEN candidates, sixteen of
#     which agree, and the three that differ are each a different kind of not-a-claim -- a duration
#     (`Twenty minutes` above four items), a TAME rate (`two asserts` a function, which is a law and
#     can go stale only on a word), and a section reference (`6 describes`). Gating that reading
#     today would red on all three. The population is printed so the decline is visible rather than
#     silent, and so the lap that finds the list-shape discriminator has a standard to build
#     against -- sixteen real claims is what it would win.
#   - A count of something the page does NOT tabulate. MAP.md line 13 says "seven rooms" in prose
#     whose next block is a heading, and the claim is real. That page happens to repeat the count in
#     `## The Seven Rooms` directly above the table, which IS read, so the page is covered -- by
#     luck rather than by this reading.
#   - Whether the table itself is right. This proves the sentence and the table agree, never that
#     either matches the tree.
#
# USAGE
#   sh tools/fixtures/p/prose_count_table_scan.sh               # measure and gate
#   sh tools/fixtures/p/prose_count_table_scan.sh list          # name every site and near_block
#   sh tools/fixtures/p/prose_count_table_scan.sh prove-red     # plant a drift; must refuse
#   sh tools/fixtures/p/prose_count_table_scan.sh prove-vacuum  # hand it no pages; must refuse

set -u
VERB="${1:-report}"

# The corpus: the three teaching rooms this tree's own front doors name as a set, plus the four
# root pages a newcomer meets before any of them. `sort -u` because `git ls-files` prints one line
# per INDEX STAGE, so a page standing unresolved mid-rebase would arrive three times and every
# claim on it be counted three times -- the reading about the index wearing a reading's clothes.
# The `date/`, `archive/` and `yonder/` shelves are read past: testimony keeps every word it wrote.
# `PROSE_COUNT_CORPUS` narrows the roster so a pen can hold four pages rather than a tree; the
# reading itself never changes with it.
CORPUS="${PROSE_COUNT_CORPUS:-docs-geode/*.md manual/*.md docs/*.md README.md MAP.md SOURCE.md CONTRIBUTING.md}"

work=$(mktemp -d) || exit 2
trap 'rm -rf "$work"' EXIT INT TERM

set -f
# shellcheck disable=SC2086
set -- $CORPUS
set +f
git ls-files -- "$@" 2>/dev/null | grep -vE '(^|/)(date|archive|yonder)/' | sort -u > "$work/pages.txt" || : > "$work/pages.txt"

if [ "$VERB" = "prove-vacuum" ]; then
  : > "$work/pages.txt"
fi

pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
if [ "$pages" -eq 0 ]; then
  echo "pages=0"
  echo "verdict=vacuum"
  echo "detail: no page reached the reading -- a corpus of nothing proves nothing, and a silent zero"
  echo "detail: would read exactly like a tree whose every count agrees with its table"
  exit 2
fi

read_page() {
  awk '
  function num(w,   m, a, q){
    split("one two three four five six seven eight nine ten eleven twelve thirteen fourteen fifteen sixteen seventeen eighteen nineteen twenty", a, " ")
    for (q = 1; q <= 20; q++) m[a[q]] = q
    m["thirty"] = 30; m["forty"] = 40; m["fifty"] = 50
    if (w in m) return m[w]
    if (w ~ /^[0-9][0-9,]*$/) { gsub(/,/, "", w); return w + 0 }
    return -1
  }
  # A plural reaches its header word by more than one road, so every road is tried rather than
  # one chosen: `rooms` -> `room`, `boundaries` -> `boundary`, `kinds` -> `kind`. Stripping `es`
  # ahead of `s` turns `places` into `plac`, which matches a header spelling `Place` nowhere.
  function names(u, hdr,   b){
    if (index(hdr, u) > 0) return 1
    b = u; sub(/s$/, "", b);   if (length(b) >= 3 && index(hdr, b) > 0) return 1
    b = u; sub(/es$/, "", b);  if (length(b) >= 3 && index(hdr, b) > 0) return 1
    b = u; sub(/ies$/, "y", b); if (length(b) >= 3 && index(hdr, b) > 0) return 1
    return 0
  }
  { raw[FNR] = $0; last = FNR }
  END {
    fence = 0
    for (i = 1; i <= last; i++) {
      l = raw[i]
      # invariant: a fence is opened and closed by the same mark, so the flag toggles and a
      # command block is never read as prose.
      if (l ~ /^[ \t]*```/) { fence = 1 - fence; continue }
      if (fence) continue
      if (l ~ /^[ \t]*\|/ || l ~ /^[ \t]*$/) continue
      # the paragraph or heading standing here
      e = i
      while (e + 1 <= last && raw[e + 1] !~ /^[ \t]*$/ && raw[e + 1] !~ /^[ \t]*```/) e++
      # its NEXT BLOCK, after one run of blank lines -- the adjacency IS the claim
      b = e + 1
      while (b <= last && raw[b] ~ /^[ \t]*$/) b++
      rows = 0; hdr = ""; kind = ""
      if (b <= last && raw[b] ~ /^[ \t]*\|/ && raw[b + 1] ~ /^\|[ :|-]+\|?[ \t]*$/) {
        kind = "table"; hdr = tolower(raw[b]); m2 = b + 2
        while (m2 <= last && raw[m2] ~ /^[ \t]*\|/) { rows++; m2++ }
      } else if (b <= last && raw[b] ~ /^[ \t]*([-*]|[0-9]+\.)[ \t]/) {
        kind = "list"; m2 = b
        while (m2 <= last && raw[m2] !~ /^[ \t]*$/) {
          if (raw[m2] ~ /^[ \t]*([-*]|[0-9]+\.)[ \t]/) rows++
          m2++
        }
      }
      if (kind == "" || rows == 0) { i = e; continue }
      for (p = i; p <= e; p++) {
        s = raw[p]
        gsub(/[*_`#]/, " ", s)
        # Split on word boundaries, so a hyphen parts a compound: `### Bar 6 -- three-door bus`
        # offers `three` and `door`, and the plural rule below is what declines it.
        n = split(s, w, /[^A-Za-z0-9]+/)
        for (k = 1; k < n; k++) {
          a1 = w[k]; a2 = w[k + 1]
          # invariant: a count and its noun touch, separated by whitespace alone -- a hyphen
          # beside the numeral is a section number or a compound adjective, never a count.
          v = num(tolower(a1)); u = tolower(a2)
          if (v < 2 || u == "") continue
          # invariant: a count names a PLURAL. `### 6 - The Workrooms` offers `6` and `the`,
          # and the room table in MAP.md is headed `The doors`, so without this rule a section
          # number reads as a claim of six against eight.
          if (u !~ /(s|es|ies)$/) continue
          # A function word ending in s is not a noun, and the one that reached this reading came
          # from a stamp: `20260810.190149` parts into `190149` and `this` above a list of two.
          if (u ~ /^(this|his|its|as|is|was|has|does|goes|yes|thus|plus|less|unless|else|us|ours|yours|theirs|hers|always|perhaps|whereas|various|previous|obvious)$/) continue
          if (kind == "table") {
            if (names(u, hdr))
              printf "site %s %d %s %s %d %d %s\n", FILENAME, p, a1, a2, v, rows, (v == rows ? "agree" : "drift")
            else
              printf "near_block %s %d %s %s %d %d header_does_not_name_%s\n", FILENAME, p, a1, a2, v, rows, u
          } else {
            printf "listform %s %d %s %s %d %d %s\n", FILENAME, p, a1, a2, v, rows, (v == rows ? "agree" : "differ")
          }
        }
      }
      i = e
    }
  }' "$1"
}

: > "$work/out.txt"
while IFS= read -r page; do
  [ -f "$page" ] || continue
  read_page "$page" >> "$work/out.txt"
done < "$work/pages.txt"

if [ "$VERB" = "prove-red" ]; then
  # Plant one drift by hand rather than by editing a page: the reading is proven to REFUSE, and
  # the tree is left exactly as it was found.
  echo "site PLANTED/page.md 1 four rooms 4 7 drift" >> "$work/out.txt"
fi

sites=$(awk '$1 == "site"' "$work/out.txt" | wc -l | tr -d ' ')
agree=$(awk '$1 == "site" && $NF == "agree"' "$work/out.txt" | wc -l | tr -d ' ')
drift=$(awk '$1 == "site" && $NF == "drift"' "$work/out.txt" | wc -l | tr -d ' ')
near=$(awk '$1 == "near_block"' "$work/out.txt" | wc -l | tr -d ' ')
listform=$(awk '$1 == "listform"' "$work/out.txt" | wc -l | tr -d ' ')
list_agree=$(awk '$1 == "listform" && $NF == "agree"' "$work/out.txt" | wc -l | tr -d ' ')

if [ "$VERB" = "list" ]; then
  awk '{ printf "%-10s %s:%s  \"%s %s\" claims %s against %s  %s\n", $1, $2, $3, $4, $5, $6, $7, $8 }' "$work/out.txt"
  exit 0
fi

echo "pages=$pages"
echo "sites=$sites"
echo "agree=$agree"
echo "drift=$drift"
echo "near_block=$near"
echo "listform=$listform"
echo "listform_agree=$list_agree"

if [ "$drift" -gt 0 ]; then
  awk '$1 == "site" && $NF == "drift" { printf "detail: %s:%s says %s %s above a table of %s rows\n", $2, $3, $4, $5, $7 }' "$work/out.txt"
  echo "verdict=drift"
  exit 1
fi

echo "verdict=ok"
exit 0
