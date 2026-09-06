#!/bin/sh
# tools/fixtures/r/reds_citation_scan.sh -- a number used as a link is a promise about where the
# link goes.
#
# WHY. A REDS row is cited two ways at once: as a number a reader recognises, and as a path a
# reader clicks. Those two halves are edited by different hands at different moments -- the number
# moves when the derived spine renumbers an unshared row, the path moves when a row folds onto a
# shelf -- and nothing in this tree ever read them together. Four times in one day (`20260906`) a
# citation was published whose number and path named different rows, and each repair fixed the half
# the eye happened to be on:
#
#   b441f97b2  a peer's `[`%492`](...)` was repointed at THIS ship's shelf by an unanchored replace
#   4ae9c6130  the repair moved my own number to `%494` and left its path saying `rows-492`
#   rows-494.md:11  `[`%360`](...rows-439-441.md)` -- a row that lives on the pin, linked to a shelf
#   rows-494.md:21  `[`%484`](...rows-480.md)` -- a shelf that exists, and the wrong one
#
# WHAT NO STANDING GUARD COULD SEE. `readme_reach` reads whether a living link OPENS, and caught
# exactly one of the four -- the one whose file was absent. The other three all resolve: they open a
# real shelf holding somebody else's row, which is a misdirection that reads green forever.
# `tracked_link` reads existence the same way. `reds_row_present` asks whether the ledger holds a
# row and never looks at who cites it. The question here is neither existence nor holding: it is
# whether the two halves of one citation agree.
#
# THE TWO FORMS IT READS, AND WHY ONLY THESE TWO. A window around a link picks up every `%N` in
# the neighbouring prose, and a sentence may lawfully name one row while linking another -- row
# %220's own shelf cites %218's, and a fold recital names a row's lesson beside a different row's
# number. Measured `20260906`, a nearest-preceding-%N reading over 1,001 living documents called 32
# such sentences wrong and every one of them was honest prose. So the scan reads only the two shapes
# that are PROMISES TO A READER rather than mentions:
#
#   NUMBERED  the anchor text IS the number -- [`%492`](path). A reader clicks a number, so the
#             number claims the destination. No judgment: the claim is in the anchor.
#   SHELF     the anchor text is a shelf word -- [shelf](path), [own shelf](path). The sentence
#             says *the shelf of the row just named*, so the claim is the nearest `%N` before the
#             link, on its own line or the one above -- one line of lookback, because this tree
#             hard-wraps its pins and the `%494`/`rows-492` break fell exactly across that wrap.
#             A `%N` AFTER the link is never its claim, which is what keeps a recital's trailing
#             lesson number from reading as a misdirection.
#
# A path may name several rows (`rows-451-469.md`), and a claim matching ANY of them agrees -- the
# shelf genuinely holds them all.
#
# WHAT IT READS, AND WHAT IT LEAVES ALONE. Tracked `*.md` present in the worktree, minus testimony:
# a basename carrying a one-clock stamp is a dated record and keeps every word it wrote
# (accrete-never-break). It reads the WORKTREE rather than the index, unlike `conflict_marker` --
# a citation that disagrees is durable prose rather than a transient block, so it is still there on
# the next lap to be read.
#
#   files_read            -- living documents holding at least one shelf link
#   numbered_links        -- [`%N`](shelf) citations found
#   numbered_disagree     -- of those, the number is not among the rows the path names. HELD AT ZERO.
#   shelf_links           -- [shelf-word](shelf) citations found
#   shelf_disagree        -- of those, the nearest preceding claim is not among them. HELD AT ZERO.
#   shelf_unnumbered      -- shelf-word links with no `%N` in the window. Reported, never gated:
#                            such a link makes no numeric promise to check.
#
# USAGE
#   sh tools/fixtures/r/reds_citation_scan.sh           # census -- key=value lines
#   sh tools/fixtures/r/reds_citation_scan.sh list      # one line per disagreement, with its site
#   ROOT_DIR=<dir> sh tools/fixtures/r/reds_citation_scan.sh    # read another checkout (the pen)
#
# Driven by tools/r/reds_citation_witness.rish. Proven both ways by reds_citation_control.sh.
# Run from the repository root.
set -u

SELF_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
ROOT=$SELF_DIR
_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done

# The pen hands its own checkout in, so the control can plant real files in a real repository and
# read them the way a lap reads this one.
subject=${ROOT_DIR:-$ROOT}
mode=${1:-census}
case "$mode" in
  census|list) ;;
  *) echo "$0: unknown mode '$mode' -- census or list" >&2; exit 2 ;;
esac

cd "$subject" 2>/dev/null || { echo "$0: cannot enter $subject" >&2; exit 2; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT

# THE STATUS IS CLASSIFIED, NEVER SWALLOWED (REDS %473). `git grep -l` exits 1 for *no match* and 2
# or more for *could not run at all*, and `|| :` reads those two alike -- which is how a guard comes
# to report a confident zero about a corpus it never opened.
git grep -l -- 'REDS-[a-z0-9-]*rows-[0-9]' -- '*.md' > "$pen/hits" 2>"$pen/grep.err"
grep_status=$?
if [ "$grep_status" -ge 2 ]; then
  echo "refused: git grep could not run in $subject (status $grep_status)" >&2
  sed -n '1,3p' "$pen/grep.err" >&2
  echo "verdict=refused_grep_failed"
  exit 1
fi

# Testimony keeps every word it wrote: a basename carrying a one-clock stamp is a dated record, and
# the spelling matches the three this tree writes (`_sprig.md` and the sprigless `.md` alike).
: > "$pen/files"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  base=${f##*/}
  case "$base" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]_*|\
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9].md) continue ;;
  esac
  [ -f "$f" ] || continue
  printf '%s\n' "$f" >> "$pen/files"
done < "$pen/hits"

# ONE VALUE, ALWAYS. `grep -c ''` prints 0 AND exits 1 on an empty file, so a `|| echo 0` beside
# it yields two lines -- and `[ "$x" -eq 0 ]` then errors out and the branch is skipped, which is
# how this scan first read `refused_no_citation` over a corpus it had correctly found empty. The
# pen caught it; awk counts records and cannot do that.
files_read=$(awk 'END { print NR }' "$pen/files")
if [ "$files_read" -eq 0 ]; then
  # A CONFIDENT ZERO WOULD BE WORSE THAN A REFUSAL. No living document citing a shelf means either
  # a tree with no ledger or a corpus this scan failed to open, and both read as green if counted.
  echo "refused: no living document cites a REDS fold shelf in $subject"
  echo "verdict=refused_no_corpus"
  exit 1
fi

awk_prog='
FNR == 1 { prev = "" }
{
  line = $0

  # NUMBERED -- the anchor text is the number itself.
  s = line
  while (match(s, /\[`?%[0-9]+`?\]\([^)]*REDS-[A-Za-z0-9-]*rows-[0-9][0-9-]*\.md\)/)) {
    m = substr(s, RSTART, RLENGTH)
    s = substr(s, RSTART + RLENGTH)
    match(m, /%[0-9]+/)
    claim = substr(m, RSTART + 1, RLENGTH - 1) + 0
    match(m, /rows-[0-9][0-9-]*\.md/)
    rows = substr(m, RSTART + 5, RLENGTH - 8)
    numbered++
    if (!holds(rows, claim)) {
      numbered_bad++
      printf "disagree numbered %s:%d claim=%%%d path=rows-%s\n", FILENAME, FNR, claim, rows
    }
  }

  # SHELF -- the anchor text says *the shelf of the row just named*.
  pos = 0
  s = line
  while (match(s, /\[[^]]*[Ss]helf[^]]*\]\([^)]*REDS-[A-Za-z0-9-]*rows-[0-9][0-9-]*\.md\)/)) {
    start = pos + RSTART
    m = substr(s, RSTART, RLENGTH)
    pos = pos + RSTART + RLENGTH - 1
    s = substr(s, RSTART + RLENGTH)
    match(m, /rows-[0-9][0-9-]*\.md/)
    rows = substr(m, RSTART + 5, RLENGTH - 8)
    shelf++
    # One line of lookback, and never past the link: a `%N` after it belongs to the next sentence.
    before = (prev == "" ? "" : prev " ") substr(line, 1, start - 1)
    claim = -1
    w = before
    while (match(w, /%[0-9]+/)) {
      claim = substr(w, RSTART + 1, RLENGTH - 1) + 0
      w = substr(w, RSTART + RLENGTH)
    }
    if (claim < 0) { shelf_none++; continue }
    if (!holds(rows, claim)) {
      shelf_bad++
      printf "disagree shelf %s:%d claim=%%%d path=rows-%s\n", FILENAME, FNR, claim, rows
    }
  }

  prev = line
}
function holds(rows, claim,   n, part, i) {
  n = split(rows, part, "-")
  for (i = 1; i <= n; i++) if (part[i] + 0 == claim) return 1
  return 0
}
END {
  printf "numbered_links=%d\n", numbered + 0
  printf "numbered_disagree=%d\n", numbered_bad + 0
  printf "shelf_links=%d\n", shelf + 0
  printf "shelf_disagree=%d\n", shelf_bad + 0
  printf "shelf_unnumbered=%d\n", shelf_none + 0
}
'

# A filename holding a space would split under a bare expansion, so the list is fed one path per
# argument through xargs with newline as the only delimiter.
tr '\n' '\0' < "$pen/files" | xargs -0 awk "$awk_prog" > "$pen/out" 2>"$pen/awk.err" || {
  echo "refused: the reading could not run over $files_read documents" >&2
  sed -n '1,3p' "$pen/awk.err" >&2
  echo "verdict=refused_read_failed"
  exit 1
}

numbered_links=$(sed -n 's/^numbered_links=//p' "$pen/out")
numbered_disagree=$(sed -n 's/^numbered_disagree=//p' "$pen/out")
shelf_links=$(sed -n 's/^shelf_links=//p' "$pen/out")
shelf_disagree=$(sed -n 's/^shelf_disagree=//p' "$pen/out")
shelf_unnumbered=$(sed -n 's/^shelf_unnumbered=//p' "$pen/out")

if [ "$mode" = list ]; then
  grep '^disagree ' "$pen/out" || echo "no citation disagrees with its own path"
fi

total_links=$((numbered_links + shelf_links))
if [ "$total_links" -eq 0 ]; then
  echo "refused: $files_read documents name a shelf and not one citation took a readable form"
  echo "verdict=refused_no_citation"
  exit 1
fi

echo "files_read=$files_read"
echo "numbered_links=$numbered_links"
echo "numbered_disagree=$numbered_disagree"
echo "shelf_links=$shelf_links"
echo "shelf_disagree=$shelf_disagree"
echo "shelf_unnumbered=$shelf_unnumbered"

disagree=$((numbered_disagree + shelf_disagree))
if [ "$disagree" -ne 0 ]; then
  grep '^disagree ' "$pen/out" | sed 's/^/  /'
  echo "verdict=citation_disagrees"
  exit 1
fi
echo "verdict=ok"
exit 0
