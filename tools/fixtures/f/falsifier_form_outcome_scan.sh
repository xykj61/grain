#!/bin/sh
# tools/fixtures/f/falsifier_form_outcome_scan.sh -- DOES THE FORM PREDICT THE OUTCOME?
#
# Two instruments in this lane read falsifiers and neither reads the other.
#
#   tools/fixtures/f/falsifier_reach_scan.sh reads FORM. It walks every living page
#   under external-research/ and active-designing/, captures each falsifier region,
#   and classes it runnable (names a path or a command form this tree carries),
#   quantified (carries a quantity), or narrative (a condition with nothing to
#   count). Its landed page closes on one handoff sentence: "27 runnable falsifiers
#   is the number to grow."
#
#   tools/fixtures/r/rank_outcome_scan.sh reads OUTCOME. Over a ranked page whose
#   rows have since been read, it classifies what each erratum found wrong with that
#   row's falsifier -- structurally incapable of firing, already settled so firing
#   discriminates nothing, aimed at the wrong subject, or unmentioned.
#
# Nothing crossed them, so the handoff sentence travelled on a hypothesis: that
# growing the runnable count buys a falsifier more likely to do its job. This scan
# crosses the two readings row by row and reports what the crossing can and cannot
# support.
#
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#
# THE POPULATION, and why it is this one. A ranked page is DISCOVERED by carrying a
# `## The ranking` heading, rather than listed here, so a third ranked page joins the
# reading on the lap it lands. Each page's rows are its `### N. ` sections. The
# crossing needs both halves per row, and only a ranked page carrying errata has an
# outcome to cross against.
#
# NEITHER RULE IS COPIED. The class comes from `falsifier_reach_scan.sh --list`,
# whose per-region lines carry a class and a start line; this scan maps each start
# line into the row section containing it. The fault verdict comes from
# `rank_outcome_scan.sh --explain`, whose `explain row=N ... falsifier=CLASS` lines
# already carry it. A second class test written here would be a second rule to drift,
# which is the fault two peer lanes spent this morning sweeping out of glow/.
#
# THE READING STATED AHEAD OF THE RUN, so the verdict is not chosen after seeing it.
# A crossing answers only when every form class holds rows. A class holding none
# leaves an EMPTY CELL, and an empty cell on the class under test means the data are
# structurally unable to answer -- which is the same fault the rank scan calls
# `incapable`, arriving in the measurement rather than in the page. `verdict` reads
# `underdetermined` while the runnable cell is empty and `crossed` once it holds a row.
#
# THE ONE WALL, decidable by text: a ranked row carrying no falsifier region at all.
# A page that ranks its rows has committed to comparing them, and a row with no
# falsifier cannot be graded by any later erratum. Gated at zero.
#
# WHAT IT CANNOT READ, counted rather than hidden. `rows_ungraded` is a row whose
# erratum has yet to be written; those rows carry a form and no outcome, so they
# widen the form reading and not the crossing. The fault classification it borrows is
# a keyword proxy over prose and says so in its own header; this scan inherits that
# softness whole and cannot reduce it.
set -eu

[ -d .git ] || { echo "verdict=not_a_repo"; exit 2; }

MAX_PAGES=32                # ranked pages admitted; the tree carries two
MAX_ROWS=64                 # rows per page; the larger page holds twelve
MAX_LINE_BYTES=65536        # one row heading stands on one line

REACH=tools/fixtures/f/falsifier_reach_scan.sh
RANK=tools/fixtures/r/rank_outcome_scan.sh
EXPLAIN=no
PAGES=

while [ $# -gt 0 ]; do
  case $1 in
    --page) shift; PAGES="$PAGES ${1:-}" ;;
    --explain) EXPLAIN=yes ;;
    *) ;;
  esac
  shift
done

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
cd "$ROOT" 2>/dev/null || :

echo "scan=falsifier_form_outcome"
echo "max_pages=$MAX_PAGES"
echo "max_rows=$MAX_ROWS"
echo "max_line_bytes=$MAX_LINE_BYTES"

# BOTH BORROWED INSTRUMENTS MUST BE PRESENT. A crossing that silently drops one half
# reports the other half's numbers under this scan's name, which is worse than refusing.
[ -f "$REACH" ] || { echo "verdict=no_reach_scan"; echo "detail: $REACH is absent -- the form half cannot be read"; exit 2; }
[ -f "$RANK" ]  || { echo "verdict=no_rank_scan";  echo "detail: $RANK is absent -- the outcome half cannot be read"; exit 2; }

# A RANKED PAGE IS DISCOVERED BY ITS OWN TEXT, never listed, so a third one joins on
# the lap it lands. Archive and yonder are read past -- a page moved to archive/ is
# superseded, and yonder/ is deferred work -- yet date/ stays IN the population: a
# ranked page's own errata accrue over days, so it is expected to fold to its day
# shelf while still gradeable, and both ranked pages this scan was built to cross
# (`active-designing/date/20260910/...moonshots.md`,
# `active-designing/date/20260917/...refusal-that-can-fire.md`) were already living
# there on the day this scan was born. Excluding date/ here left pages_found=0 from
# birth (20260917.134251) rather than reading the two ranked pages it was written for.
if [ -z "$PAGES" ]; then
  PAGES=$(git grep -l '^## The ranking' -- 'active-designing/*.md' 'external-research/*.md' 2>/dev/null \
    | grep -vE '/(archive|yonder)/' || true)
fi

pages_found=$(printf '%s\n' $PAGES | grep -c . || true)
echo "pages_found=$pages_found"
[ "$pages_found" -gt 0 ] || { echo "verdict=no_ranked_pages"; exit 2; }
[ "$pages_found" -le "$MAX_PAGES" ] || { echo "verdict=over_page_bound"; exit 2; }

rows=$(mktemp 2>/dev/null || echo "./.ffo_rows.$$")
regions=$(mktemp 2>/dev/null || echo "./.ffo_regions.$$")
faults=$(mktemp 2>/dev/null || echo "./.ffo_faults.$$")
errata=$(mktemp 2>/dev/null || echo "./.ffo_errata.$$")
trap 'rm -f "$rows" "$regions" "$faults" "$errata"' EXIT INT TERM

# THE FORM HALF, read once for the whole corpus rather than once per page: the reach
# scan walks 497 pages and calling it per page would walk them twice.
sh "$REACH" --list 2>/dev/null \
  | awk '$1=="detail:" && $2=="region"{
      cls=$3; sub(/^class=/,"",cls)
      loc=$4; n=split(loc,a,":"); line=a[n]; path=loc; sub(":" line "$","",path)
      print path "\t" line "\t" cls
    }' > "$regions" || true

[ -s "$regions" ] || { echo "verdict=reach_walk_empty"; echo "detail: $REACH --list emitted no region lines"; exit 2; }

# THE ROW TABLE. Each `### N. ` heading opens a row; the row runs to the next such
# heading or to the next top-level heading, whichever comes first, so the ranking
# section below the rows never swallows one.
: > "$rows"
for p in $PAGES; do
  [ -f "$p" ] || { echo "verdict=page_missing"; echo "detail: $p"; exit 2; }
  awk -v path="$p" -v maxb="$MAX_LINE_BYTES" '
    length($0) > maxb { next }
    /^### [0-9]+\. / {
      if (num != "") print path "\t" num "\t" start "\t" (FNR-1)
      num=$2; sub(/\./,"",num); start=FNR; next
    }
    /^## / { if (num != "") { print path "\t" num "\t" start "\t" (FNR-1); num="" } }
    END { if (num != "") print path "\t" num "\t" start "\t" FNR }
  ' "$p" >> "$rows"
done

rows_total=$(wc -l < "$rows" | tr -d ' ')
echo "rows_total=$rows_total"
[ "$rows_total" -gt 0 ] || { echo "verdict=no_rows"; exit 2; }
[ "$rows_total" -le $((MAX_PAGES * MAX_ROWS)) ] || { echo "verdict=over_row_bound"; exit 2; }

# THE OUTCOME HALF, per page, from the rank scan's own explain lines.
: > "$faults"
for p in $PAGES; do
  sh "$RANK" --page "$p" --explain 2>/dev/null \
    | awk -v path="$p" '$1=="explain" && $2 ~ /^row=/{
        r=$2; sub(/^row=/,"",r)
        for (i=3;i<=NF;i++) if ($i ~ /^falsifier=/) { f=$i; sub(/^falsifier=/,"",f); print path "\t" r "\t" f; break }
      }' >> "$faults" || true
done

# WHICH ROWS CARRY AN ERRATUM AT ALL. The rank scan emits an explain line only for a
# row whose erratum SAYS something about the falsifier, so a row whose erratum is
# silent on it looks identical from there to a row with no erratum at all. Those are
# two different facts wanting two different repairs -- an unread row and a reading
# that skipped the falsifier -- so the erratum's own `**Row N erratum:**` line is read
# here and the two are told apart.
: > "$errata"
for p in $PAGES; do
  awk -v path="$p" '
    match($0, /\*\*Row [0-9]+ (second |third )?erratum:\*\*/) {
      s = substr($0, RSTART, RLENGTH)
      n = s; gsub(/[^0-9]/, "", n)
      if (!(n in seen)) { seen[n] = 1; print path "\t" n }
    }
  ' "$p" >> "$errata" || true
done

# THE CROSSING. One awk holds the four tables, so a row appears in exactly one cell.
# It writes to a file rather than to the terminal, because two readings below are taken
# from its own row lines and a second invocation would re-walk the whole 497-page corpus.
out=$(mktemp 2>/dev/null || echo "./.ffo_out.$$")
trap 'rm -f "$rows" "$regions" "$faults" "$errata" "$out"' EXIT INT TERM

awk -F'\t' '
  FILENAME == ARGV[1] { cls[$1 "\t" $2] = $3; next }
  FILENAME == ARGV[2] { fault[$1 "\t" $2] = $3; next }
  FILENAME == ARGV[3] { erratum[$1 "\t" $2] = 1; next }
  {
    path=$1; num=$2; s=$3; e=$4
    rows++
    form="none"
    for (k in cls) {
      split(k, a, "\t")
      if (a[1] == path && a[2]+0 >= s+0 && a[2]+0 <= e+0) { form=cls[k]; break }
    }
    f = fault[path "\t" num]
    if (f == "") f = (erratum[path "\t" num] ? "silent" : "unread")
    formn[form]++
    if (f == "unread") unread++
    else {
      graded++
      cell[form "\t" f]++
      if (f == "named") clean++
      else if (f == "silent") silent++
      else faulted[form]++
      if (f != "named" && f != "silent") faultn++
    }
    printf "detail: row page=%s n=%s form=%s outcome=%s\n", path, num, form, f
  }
  END {
    printf "rows_read=%d\n", rows+0
    printf "form_runnable=%d\n",   formn["runnable"]+0
    printf "form_quantified=%d\n", formn["quantified"]+0
    printf "form_narrative=%d\n",  formn["narrative"]+0
    printf "form_none=%d\n",       formn["none"]+0
    printf "rows_graded=%d\n",   graded+0
    printf "rows_unread=%d\n", unread+0
    printf "outcome_faulted=%d\n", faultn+0
    printf "outcome_clean=%d\n",   clean+0
    printf "outcome_silent=%d\n",  silent+0
    n = 0
    for (c in cell) { split(c, a, "\t"); line[++n] = sprintf("cross_%s_%s=%d", a[1], a[2], cell[c]) }
    for (i = 1; i <= n; i++) print line[i]
    split("runnable quantified narrative", order, " ")
    empty = 0
    for (i = 1; i <= 3; i++) {
      c = order[i]
      g = 0
      for (k in cell) { split(k, a, "\t"); if (a[1] == c) g += cell[k] }
      # A SHARE OVER AN EMPTY DENOMINATOR is a number with nothing behind it, so the
      # class says `none` rather than printing a zero a reader would read as a rate.
      if (g == 0) { empty++; printf "rate_%s=none\n", c }
      else printf "rate_%s=%.4f\n", c, (faulted[c]+0) / g
    }
    printf "form_cells_empty=%d\n", empty
  }
' "$regions" "$faults" "$errata" "$rows" > "$out"

[ -s "$out" ] || { echo "verdict=crossing_failed"; exit 2; }

[ "$EXPLAIN" = yes ] && grep '^detail: row ' "$out" || true
grep -v '^detail: row ' "$out"

rows_no_falsifier=$(awk '$1=="detail:" && $2=="row" && /form=none/{n++} END{print n+0}' "$out")
echo "rows_no_falsifier=$rows_no_falsifier"

runnable=$(awk '$1=="detail:" && $2=="row" && /form=runnable/{n++} END{print n+0}' "$out")
echo "rows_runnable=$runnable"

# THE VERDICT TURNS ON THE GRADED CELL, never on the row merely existing. A runnable
# row nobody has read yet widens the form reading and leaves the crossing exactly as
# empty as it was, which is the distinction the whole scan is about.
runnable_graded=$(awk -F= '/^cross_runnable_/{n += $2} END{print n+0}' "$out")
echo "rows_runnable_graded=$runnable_graded"

if [ "$rows_no_falsifier" -ne 0 ]; then
  echo "verdict=row_without_falsifier"
  echo "detail: a ranked row carrying no falsifier region cannot be graded by any later erratum"
  echo "figures=FREE -- a ranked page may gain a row or an erratum; the class and fault rules are HELD by their own scans"
  exit 0
fi

if [ "$runnable_graded" -eq 0 ]; then
  echo "verdict=underdetermined"
  echo "detail: the runnable cell is empty, so the crossing cannot say whether the class the reach scan's handoff names buys a falsifier that fires"
else
  echo "verdict=crossed"
fi
echo "figures=FREE -- a ranked page may gain a row or an erratum; the class and fault rules are HELD by their own scans"
