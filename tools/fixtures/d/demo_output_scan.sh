#!/bin/sh
# tools/fixtures/d/demo_output_scan.sh -- a page that prints a command AND its answer is a
# claim, so run the command and read the answer back.
#
# WHY. docs-geode/demos/README.md hands a newcomer five commands and prints what each one
# answered on the day it was written. That page is the shipping shelf's promise that a reader
# can check this tree for themselves, and until this scan nothing in the tree ran a single one
# of those five. tools/d/docs_command_path_witness.rish proves a printed PATH resolves; a path
# that resolves says nothing about what the command behind it now prints.
#
# The class had already bitten one room over on `20260916`: a front-door claim bound to no
# witness went false inside a fortnight, and `src/gate/README.md` stood wrong for ten days.
# A lantern that fires twice becomes a loom.
#
# THREE READINGS, because a printed block makes one of three different promises.
#
#   exact     -- no marker. Every byte of the printed block equals the command's own output.
#                This is what a fixed input earns: a SHA3-256 digest of five bytes and a
#                resolver's three lines are answers that must never move, and a byte
#                comparison is the only honest reading of a promise that strong.
#   selected  -- `<!-- selected: ... -->` above the block. The page gathered some lines out of
#                a longer report, so each printed line must STAND in the real output, and the
#                lines beside it are free.
#   volatile  -- `<!-- volatile: ... -->` above the block. The page declares the numbers move
#                with the tree. Every digit run is free; every other character must match a
#                real output line exactly, so a renamed key or a flipped verdict still reds
#                while a climbing count does not.
#
# The two marker comments were already on the page before this scan existed, written by a hand
# telling a reader which figures to distrust. They are read as machine input now, which is the
# cheapest kind of instrument: the page was already carrying the fixture.
#
# A ROSTER OF PAGES, NAMED RATHER THAN DISCOVERED, and the reason is capability rather than
# tidiness. This scan RUNS what a page prints. Discovering pages would mean running whatever
# any page in the tree happens to print inside a fenced block, which is a wide door to open by
# accident. A page joins the roster when a hand decides its commands are safe to run every lap.
#
# WHAT IS GATED, hard, at zero: a pair that ran and whose answer no longer matches the page.
# A command that cannot run inside its bound is reported as `errored` and gated too, since a
# page handing a reader a command that exits nonzero has already failed them.
#
# WHAT PASSES FREE. A `sh` block with no output block below it -- the page is showing a command
# to run rather than an answer to check, which is what the demos page does with a witness
# invocation. Those are counted as `unpaired` and reported.
#
# AND A READING THIS SCAN OWES ABOUT ITSELF: DOUBLE READ.
#
# tools/fixtures/t/tutorial_output_scan.sh, seated `20260909`, reads command-and-output pairs
# across a CORPUS of git pathspecs -- `docs-geode/*.md manual/*.md SOURCE.md` -- choosing what to
# run by a DERIVED rule on the command line rather than by a named page list. This scan's only
# rostered page sits inside that corpus. Measured `20260916`: of the five pairs run here, the
# sibling reads the same five fences and checks four of them, holding the fifth as outside its
# run roster. So four are checked twice, under two conventions, and the fifth is this scan's one
# piece of new coverage.
#
# That was not known when this scan was seated, and nothing in the tree could have said so. The
# reading below is what says so now: for each rostered page, whether another guard's corpus
# already holds it.
#
# REPORTED, NEVER GATED. Two guards reading one page is a cost rather than a fault, and which of
# the two should yield is a hand's word. What must not happen twice is a roster growing into that
# corpus with nobody seeing it.
#
# The sibling names its corpus in one constant and offers no verb printing it without running
# every command it reads, so the constant is read out of the file. A read that finds nothing says
# `double_read_state=unreadable` out loud rather than reporting a comfortable zero.
#
# USAGE
#   sh tools/fixtures/d/demo_output_scan.sh [--page PATH ...] [--list] [--overlap]
#
# `--overlap` prints the double-read reading and exits before the run loop, so a hand weighing a
# candidate page for this roster learns whether another guard already reads it, at no cost.
#
# Driven by tools/d/demo_output_witness.rish. Run from the repository root.

set -eu

# The roster. One page today. A hand adds a row after reading the commands it prints.
ROSTER='docs-geode/demos/README.md'

max_pairs=64          # a bound on how much of a page this will run in one pass
pair_timeout=180      # seconds one printed command may take before it is called errored

list=no
overlap_only=no
pages=''
while [ $# -gt 0 ]; do
  case "$1" in
    --page) shift; [ $# -gt 0 ] || { echo "verdict=bad_flag"; exit 1; }; pages="$pages $1" ;;
    --list) list=yes ;;
    --overlap) overlap_only=yes ;;
    *) echo "verdict=bad_flag"; echo "refused: unknown flag $1" >&2; exit 1 ;;
  esac
  shift
done
[ -n "$pages" ] || pages="$ROSTER"

work=$(mktemp -d)
cleanup() { rm -rf "$work"; }
trap cleanup EXIT
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM
mkdir -p "$work/pairs"

roster_pages=0
missing_pages=0
for page in $pages; do
  roster_pages=$((roster_pages + 1))
  if [ ! -f "$page" ]; then
    missing_pages=$((missing_pages + 1))
    echo "detail: $page is on the roster and not in the tree"
    continue
  fi
  echo "$page" >> "$work/pages"
done

if [ "$missing_pages" -gt 0 ]; then
  echo "roster_pages=$roster_pages"
  echo "verdict=roster_page_absent"
  exit 1
fi

# ---- double read: is a rostered page already inside another guard's corpus? -----------------

SIBLING=${DEMO_OUTPUT_SIBLING:-tools/fixtures/t/tutorial_output_scan.sh}
double_read=0
double_read_state=read
if [ ! -f "$SIBLING" ]; then
  double_read_state=no_sibling
else
  sib_corpus=$(sed -n 's/^CORPUS=${TUTORIAL_OUTPUT_CORPUS:-\(.*\)}$/\1/p' "$SIBLING")
  if [ -z "$sib_corpus" ]; then
    double_read_state=unreadable
  else
    # The corpus is git pathspecs, so the shell's own globbing stays off and git does the
    # expanding -- git's `*` crosses a slash and the shell's does not, which is the difference
    # between a whole subtree and one top-level page.
    set -f
    # shellcheck disable=SC2086
    set -- $sib_corpus
    set +f
    git ls-files -- "$@" 2>/dev/null > "$work/sibling_pages" || : > "$work/sibling_pages"
    while IFS= read -r rpage; do
      if grep -qxF -- "$rpage" "$work/sibling_pages"; then
        double_read=$((double_read + 1))
        echo "double_read: $rpage is on this roster and inside $SIBLING's corpus"
      fi
    done < "$work/pages"
  fi
fi

if [ "$overlap_only" = yes ]; then
  echo "roster_pages=$roster_pages"
  echo "double_read=$double_read"
  echo "double_read_state=$double_read_state"
  echo "verdict=overlap_read"
  exit 0
fi

# ONE AWK OVER THE ROSTER. It walks each page's fences and writes one .cmd and one .exp file
# per pair, plus an index naming the page and which of the three readings the pair earned.
# A ```sh fence opens a command; the next fence decides what the command was: a plain ``` fence
# below it is the answer, and another ```sh fence means the first was unpaired.
LC_ALL=C awk -v work="$work" '
  function flush_pair(   i, base) {
    if (n >= '"$max_pairs"') { over++; return }
    n++
    base = work "/pairs/" n
    for (i = 1; i <= cmdn; i++) print cmd[i] > (base ".cmd")
    close(base ".cmd")
    for (i = 1; i <= expn; i++) print ans[i] > (base ".exp")
    close(base ".exp")
    print n "\t" page "\t" (marker == "" ? "exact" : marker) "\t" cmd[1] >> (work "/index")
  }
  FNR == 1 { page = FILENAME; infence = 0; kind = ""; pend = 0; marker = ""; cmdn = 0; expn = 0 }
  /^[[:space:]]*```/ {
    lang = $0; sub(/^[[:space:]]*```/, "", lang); gsub(/[[:space:]]/, "", lang)
    if (!infence) {
      infence = 1
      if (lang == "sh") { if (pend) unpaired++; pend = 0; kind = "cmd"; cmdn = 0; marker = "" }
      else if (lang == "" && pend) { kind = "exp"; expn = 0 }
      else { if (pend) unpaired++; pend = 0; kind = "other" }
    } else {
      infence = 0
      if (kind == "cmd") pend = 1
      else if (kind == "exp") { flush_pair(); pend = 0 }
      kind = ""
    }
    next
  }
  !infence {
    if (pend && $0 ~ /<!--[[:space:]]*volatile:/) marker = "volatile"
    if (pend && $0 ~ /<!--[[:space:]]*selected:/) marker = "selected"
    next
  }
  kind == "cmd" { cmd[++cmdn] = $0; next }
  kind == "exp" { ans[++expn] = $0; next }
  END {
    if (pend) unpaired++
    print unpaired + 0 > (work "/unpaired")
    print over + 0 > (work "/over")
  }
' $(cat "$work/pages")

[ -f "$work/index" ] || : > "$work/index"
[ -f "$work/unpaired" ] || echo 0 > "$work/unpaired"
[ -f "$work/over" ] || echo 0 > "$work/over"

pairs=$(wc -l < "$work/index" | tr -d ' ')
unpaired=$(cat "$work/unpaired")
over_bound=$(cat "$work/over")

matched=0
drifted=0
errored=0
exact=0
selected=0
volatile=0

# Digit runs go free in the volatile reading and nowhere else. One normalizer, applied to both
# sides of the comparison, so the rule is stated once.
norm() { LC_ALL=C sed 's/[0-9][0-9]*/#/g' "$1"; }

while IFS="$(printf '\t')" read -r n page mode first; do
  case "$mode" in exact) exact=$((exact + 1)) ;; selected) selected=$((selected + 1)) ;; volatile) volatile=$((volatile + 1)) ;; esac
  if timeout "$pair_timeout" sh "$work/pairs/$n.cmd" > "$work/pairs/$n.out" 2> "$work/pairs/$n.err"; then
    :
  else
    errored=$((errored + 1))
    echo "detail: $page pair $n ($mode) -- \`$first\` did not exit clean inside ${pair_timeout}s"
    continue
  fi
  bad=0
  case "$mode" in
    exact)
      cmp -s "$work/pairs/$n.exp" "$work/pairs/$n.out" || bad=1
      ;;
    selected)
      while IFS= read -r want; do
        grep -Fxq -- "$want" "$work/pairs/$n.out" || { bad=1; echo "detail: $page pair $n (selected) -- the output no longer carries: $want"; }
      done < "$work/pairs/$n.exp"
      ;;
    volatile)
      norm "$work/pairs/$n.out" > "$work/pairs/$n.outn"
      norm "$work/pairs/$n.exp" > "$work/pairs/$n.expn"
      while IFS= read -r want; do
        grep -Fxq -- "$want" "$work/pairs/$n.outn" || { bad=1; echo "detail: $page pair $n (volatile) -- no output line has this shape: $want"; }
      done < "$work/pairs/$n.expn"
      ;;
  esac
  if [ "$bad" -eq 0 ]; then
    matched=$((matched + 1))
    [ "$list" = yes ] && echo "ok: $page pair $n ($mode) -- \`$first\`"
  else
    drifted=$((drifted + 1))
    [ "$mode" = exact ] && echo "detail: $page pair $n (exact) -- \`$first\` no longer prints what the page shows"
  fi
done < "$work/index"

echo "roster_pages=$roster_pages"
echo "double_read=$double_read"
echo "double_read_state=$double_read_state"
echo "pairs=$pairs"
echo "pairs_exact=$exact"
echo "pairs_selected=$selected"
echo "pairs_volatile=$volatile"
echo "unpaired=$unpaired"
echo "over_bound=$over_bound"
echo "max_pairs=$max_pairs"
echo "matched=$matched"
echo "drifted=$drifted"
echo "errored=$errored"

if [ "$pairs" -eq 0 ]; then
  echo "verdict=no_pairs"
  exit 1
fi
if [ "$errored" -gt 0 ]; then
  echo "verdict=command_errored"
  exit 1
fi
if [ "$drifted" -gt 0 ]; then
  echo "verdict=output_drifted"
  exit 1
fi
echo "verdict=ok"
