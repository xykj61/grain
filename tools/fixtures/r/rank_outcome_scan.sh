#!/bin/sh
# tools/fixtures/r/rank_outcome_scan.sh -- DID THE RANKING PREDICT ANYTHING? The page
# active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md carries twelve speculative rows
# and, at its close, a ranking of all twelve. That ranking states its own operand in one line:
# "Ranked by what a lane can start on this pier, with no new hardware, this month." So it forecasts
# STARTABILITY and never truth, and it was written before any row had been read.
#
# Every one of the twelve now carries a dated erratum. That makes the forecast gradeable for the
# first time, and this scan grades it three ways, each a separate question.
#
#   READING 1 -- RANK AGAINST READ ORDER, which is what the ranking actually claimed. Each
#   erratum carries a one-clock stamp, so the order the rows were read in is recorded in the page's
#   own bytes. The scan sorts rows by first-erratum stamp and compares that order to the rank by
#   Kendall concordance and by Spearman rho. It reports the same pair of statistics for the SUBSET
#   whose erratum was its own first witness, separating those rows from the ones whose witness had
#   already landed before the erratum was written -- a row already built is a row whose reading was
#   never scheduled, and mixing the two measures two different things at once.
#
#   READING 2 -- RANK AGAINST SURVIVAL, which the ranking never claimed and which is worth reading
#   anyway. Each erratum's own recommendation word classifies the row: a re-rank, a re-aim, a
#   breach, or silence. The scan also reads the rank each erratum RECOMMENDS where it names one,
#   and reports the displacement from the original.
#
#   READING 3 -- WHICH HALF OF A ROW FAILED. A Gauge Field row carries a claim and a falsifier.
#   The scan classifies what each erratum found wrong with the FALSIFIER, by the erratum's own
#   words: structurally incapable of firing, already settled so that firing discriminates nothing,
#   aimed at the wrong subject, or unmentioned. This classification is a KEYWORD PROXY over prose
#   and it says so; the sentences it reads are quoted back under --explain so a reader can check
#   each one by hand.
#
# Every page figure is FREE: the page is living and may gain an erratum. The ordering statistics
# are HELD against planted permutations, whose closed forms the control proves from both sides.
#
# Emits key=value lines and a verdict. Bounds are named at the top. Exit 0 always; the witness
# reads the keys.
set -u

MAX_ROWS=64                 # ranked rows admitted; the page holds 12 and a reader holds far fewer
MAX_ERRATA=256              # erratum lines read before the reading refuses to grow
MAX_LINE_BYTES=65536        # one erratum stands on one line; longer is a page shape we do not know

PAGE=active-designing/date/20260910/20260910-060204_the-bounded-torus-moonshots.md
EXPLAIN=no

while [ $# -gt 0 ]; do
  case $1 in
    --page) shift; PAGE=${1:-$PAGE} ;;
    --explain) EXPLAIN=yes ;;
    *) ;;
  esac
  shift
done

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || ROOT=$PWD
cd "$ROOT" 2>/dev/null || :

echo "scan=rank_outcome"
echo "page=$PAGE"
echo "max_rows=$MAX_ROWS"
echo "max_errata=$MAX_ERRATA"
echo "explain=$EXPLAIN"

if [ ! -f "$PAGE" ]; then
  echo "page_present=no"
  echo "verdict=no_page"
  exit 0
fi
echo "page_present=yes"

# ---- reading 1 and 2: rank, stamp, recommendation, falsifier class, per row ----
awk -v page="$PAGE" -v maxrows="$MAX_ROWS" -v maxerrata="$MAX_ERRATA" \
    -v maxline="$MAX_LINE_BYTES" -v explain="$EXPLAIN" '
function lower(s) { return tolower(s) }

# a ranking row reads  | <rank> | <rownum>. <title> | <why> |
/^\| *[0-9]+ *\| *[0-9]+\./ {
  line = $0
  gsub(/^\| */, "", line)
  n = split(line, f, / *\| */)
  rank = f[1] + 0
  rw = f[2] + 0
  if (rank > 0 && rw > 0 && ranked < maxrows) {
    rank_of[rw] = rank
    row_at_rank[rank] = rw
    why_of[rw] = f[3]
    ranked++
  }
  next
}

# an erratum reads  **Row N erratum:** `STAMP` -- ...   (or "Row N second erratum")
/^\*\*Row [0-9]+ (second )?erratum:\*\*/ {
  if (errata >= maxerrata) next
  if (length($0) > maxline) { overlong++; next }
  errata++
  body = $0
  match(body, /Row [0-9]+/)
  rw = substr(body, RSTART + 4, RLENGTH - 4) + 0
  second = (body ~ /^\*\*Row [0-9]+ second erratum/) ? 1 : 0
  if (match(body, /`[0-9]{8}\.[0-9]{6}`/)) {
    st = substr(body, RSTART + 1, RLENGTH - 2)
  } else { st = "" }

  if (second) {
    second_count[rw]++
    later++
    if (st != "") later_stamp[rw] = st
    lb2 = lower(body)
    if (lb2 ~ /disposition: \*\*breach\*\*/ || lb2 ~ /recommended \*\*breach/) later_rec[rw] = "breach"
    else if (lb2 ~ /recommended \*\*re-aim/ || lb2 ~ /recommended re-aim/) later_rec[rw] = "reaim"
    else if (lb2 ~ /recommended re-rank/) later_rec[rw] = "rerank"
    else later_rec[rw] = "none"
    next
  }

  first_stamp[rw] = st
  seen_first[rw] = 1
  first_count++
  lb = lower(body)
  if (lb ~ /two of the twelve rows now carry falsifiers structurally incapable/) selfcount = 2

  # -- the recommendation the erratum makes
  if (lb ~ /disposition: \*\*breach\*\*/ || lb ~ /recommended \*\*breach/) rec[rw] = "breach"
  else if (lb ~ /recommended re-aim rather than re-rank/) rec[rw] = "reaim"
  else if (lb ~ /recommended \*\*re-aim/ || lb ~ /recommended re-aim/) rec[rw] = "reaim"
  else if (lb ~ /recommended re-rank/ || lb ~ /recommended \*\*re-rank/) rec[rw] = "rerank"
  else rec[rw] = "none"

  # -- a rank the erratum names for this row, in the page own words
  newrank[rw] = 0
  if (lb ~ /rank of fourth/)   newrank[rw] = 4
  if (lb ~ /rank of tenth/)    newrank[rw] = 10
  if (lb ~ /rank of twelfth/)  newrank[rw] = 12
  if (lb ~ /re-rank: last/)    newrank[rw] = 12

  # -- the CLAIM half, read by two signals that must AGREE. "GREEN on metal" alone is
  # ambiguous: it names the row own witness in one erratum and the GRADING instrument in
  # another, and row 7 carries it while recommending a re-aim. So a row stands only where a
  # green reading and NO recommendation stand together. And a missing recommendation is not
  # survival either: row 9 makes none and still refuses its own proposed witness.
  green_of[rw]   = (lb ~ /green on metal/ || lb ~ /it already stood/) ? 1 : 0
  blocked_of[rw] = (lb ~ /cannot be built here/) ? 1 : 0

  # -- whether the erratum reports a witness that had already landed
  prebuilt[rw] = (lb ~ /the first witness landed on/) ? 1 : 0
  body_of[rw] = body

  # -- what the erratum found wrong with the FALSIFIER (keyword proxy over prose)
  if (lb !~ /falsifier/) {
    fals[rw] = "silent"
  } else if (lb ~ /falsifier cannot fire/ || lb ~ /cannot fire in either direction/ \
          || lb ~ /fires at radius zero/ || lb ~ /stays green whatever the falsifier/ \
          || lb ~ /clustering \*\*cannot happen\*\*/) {
    fals[rw] = "incapable"
  } else if (lb ~ /falsifier is refused by construction/ || lb ~ /falsifier also retires/ \
          || lb ~ /falsifier is answered by/ || lb ~ /falsifier fires on a path and is extinguished/) {
    fals[rw] = "settled"
  } else if (lb ~ /falsifier fires on seated code rather than/) {
    fals[rw] = "misaimed"
  } else {
    fals[rw] = "named"
  }
  if (explain == "yes") {
    m = body
    gsub(/\. /, ".\n", m)
    nl = split(m, L, "\n")
    for (i = 1; i <= nl; i++) if (L[i] ~ /falsifier/) explain_line[rw] = explain_line[rw] " | " L[i]
  }
  next
}

END {
  printf "ranked_rows=%d\n", ranked
  printf "errata_lines=%d\n", errata
  printf "errata_first=%d\n", first_count
  printf "overlong_lines=%d\n", overlong + 0

  # every ranked row must carry a first erratum for the order reading to be whole
  missing = 0
  for (r = 1; r <= ranked; r++) { rw = row_at_rank[r]; if (!(rw in seen_first)) missing++ }
  printf "rows_without_erratum=%d\n", missing
  printf "page_fully_read=%s\n", (missing == 0 && ranked > 0 ? "yes" : "no")

  # -- read order by first-erratum stamp; a tie keeps rank order and is counted
  n = 0
  for (r = 1; r <= ranked; r++) {
    rw = row_at_rank[r]
    if (!(rw in seen_first)) continue
    n++
    ord_row[n] = rw; ord_stamp[n] = first_stamp[rw]; ord_rank[n] = r
  }
  for (i = 2; i <= n; i++) {
    for (j = i; j > 1; j--) {
      if (ord_stamp[j] < ord_stamp[j-1]) {
        t = ord_stamp[j]; ord_stamp[j] = ord_stamp[j-1]; ord_stamp[j-1] = t
        t = ord_row[j];   ord_row[j]   = ord_row[j-1];   ord_row[j-1] = t
        t = ord_rank[j];  ord_rank[j]  = ord_rank[j-1];  ord_rank[j-1] = t
      } else break
    }
  }
  ties = 0
  for (i = 2; i <= n; i++) if (ord_stamp[i] == ord_stamp[i-1]) ties++
  printf "read_ordered=%d\n", n
  printf "stamp_ties=%d\n", ties

  seq = ""
  for (i = 1; i <= n; i++) seq = seq (i > 1 ? "," : "") ord_rank[i]
  printf "rank_in_read_order=%s\n", seq

  # -- Kendall concordance and Spearman rho over all read rows
  stat(n, "all")

  # -- the subset whose erratum WAS its first witness
  m = 0
  for (i = 1; i <= n; i++) {
    rw = ord_row[i]
    if (prebuilt[rw]) { pre_ranks = pre_ranks (pre_ranks != "" ? "," : "") ord_rank[i]; pre_pos = pre_pos (pre_pos != "" ? "," : "") i; prebuilt_n++; continue }
    m++
    sub_rank[m] = ord_rank[i]
  }
  printf "prebuilt_rows=%d\n", prebuilt_n + 0
  printf "prebuilt_ranks=%s\n", (pre_ranks == "" ? "-" : pre_ranks)
  printf "prebuilt_read_positions=%s\n", (pre_pos == "" ? "-" : pre_pos)
  # the subset needs ranks RELATIVE to itself: an original rank of 3 in a subset whose
  # lowest rank is 3 is that subset first place, or the statistic reads a constant offset
  # as disagreement. Rank each subset member among the subset ranks, order preserved.
  for (i = 1; i <= m; i++) {
    rel = 1
    for (j = 1; j <= m; j++) if (sub_rank[j] < sub_rank[i]) rel++
    ord_rank[i] = rel
  }
  stat2(m, "own")

  # -- reading 2: survival and displacement
  for (r = 1; r <= ranked; r++) {
    rw = row_at_rank[r]
    if (!(rw in seen_first)) continue
    c = rec[rw]; rc[c]++
    if (newrank[rw] > 0) {
      named_rank++
      d = newrank[rw] - r
      if (d < 0) d = -d
      disp_total += d
      if (d == 0) kept_rank++; else moved_rank++
      if (d > disp_max) disp_max = d
    }
    fk = fals[rw]; fc[fk]++
    if (explain == "yes" && explain_line[rw] != "") printf "explain row=%d rank=%d falsifier=%s%s\n", rw, r, fk, explain_line[rw]
  }
  printf "rec_breach=%d\n", rc["breach"] + 0
  printf "rec_reaim=%d\n",  rc["reaim"] + 0
  printf "rec_rerank=%d\n", rc["rerank"] + 0
  printf "rec_none=%d\n",   rc["none"] + 0
  # the LIVING disposition is a row newest erratum, which for row 5 is its second
  for (r = 1; r <= ranked; r++) {
    rw = row_at_rank[r]
    if (!(rw in seen_first)) continue
    lc = (rw in later_rec) ? later_rec[rw] : rec[rw]
    dc[lc]++
  }
  printf "later_errata=%d\n", later + 0
  printf "final_breach=%d\n", dc["breach"] + 0
  printf "final_reaim=%d\n",  dc["reaim"] + 0
  printf "final_rerank=%d\n", dc["rerank"] + 0
  printf "final_none=%d\n",   dc["none"] + 0
  for (r = 1; r <= ranked; r++) {
    rw = row_at_rank[r]
    if (!(rw in seen_first)) continue
    lc = (rw in later_rec) ? later_rec[rw] : rec[rw]
    if (blocked_of[rw]) k = "blocked"
    else if (green_of[rw] && lc == "none") k = "stands"
    else k = "altered"
    cc[k]++
    if (k == "stands") {
      stands_ranks = stands_ranks (stands_ranks != "" ? "," : "") r
      # the confound, counted rather than argued: a row whose witness landed before its
      # erratum, or which the erratum says already stood, survived by PRE-EXISTENCE.
      if (prebuilt[rw] || lower(body_of[rw]) ~ /it already stood/) stands_pre++
    }
  }
  printf "claim_stands=%d\n",  cc["stands"] + 0
  printf "claim_blocked=%d\n", cc["blocked"] + 0
  printf "claim_altered=%d\n", cc["altered"] + 0
  printf "claim_stands_ranks=%s\n", (stands_ranks == "" ? "-" : stands_ranks)
  printf "claim_stands_preexisting=%d\n", stands_pre + 0
  printf "rank_named_by_erratum=%d\n", named_rank + 0
  printf "rank_kept=%d\n", kept_rank + 0
  printf "rank_moved=%d\n", moved_rank + 0
  printf "rank_displacement_total=%d\n", disp_total + 0
  printf "rank_displacement_max=%d\n", disp_max + 0

  # -- reading 3: which half of a row failed
  printf "falsifier_incapable=%d\n", fc["incapable"] + 0
  printf "falsifier_settled=%d\n",   fc["settled"] + 0
  printf "falsifier_misaimed=%d\n",  fc["misaimed"] + 0
  printf "falsifier_named=%d\n",     fc["named"] + 0
  printf "falsifier_silent=%d\n",    fc["silent"] + 0
  faulted = fc["incapable"] + fc["settled"] + fc["misaimed"] + 0
  printf "falsifier_faulted=%d\n", faulted
  printf "falsifier_read=%d\n", n
  if (n > 0) printf "falsifier_faulted_share=%.4f\n", faulted / n
  else printf "falsifier_faulted_share=0.0000\n"

  # the page counts this class inside its own errata; read what it claims
  printf "page_selfcount_claim=%d\n", selfcount + 0

  if (ranked == 0)        print "verdict=no_ranking"
  else if (missing > 0)   print "verdict=partly_read"
  else                    print "verdict=graded"
}


function stat(k, tag) {
  conc = 0; disc = 0; d2 = 0
  for (a = 1; a <= k; a++) {
    d = ord_rank[a] - a
    d2 += d * d
    for (b = a + 1; b <= k; b++) {
      if (ord_rank[b] > ord_rank[a]) conc++
      else if (ord_rank[b] < ord_rank[a]) disc++
    }
  }
  pairs = k * (k - 1) / 2
  printf "%s_pairs=%d\n", tag, pairs
  printf "%s_concordant=%d\n", tag, conc
  printf "%s_discordant=%d\n", tag, disc
  if (pairs > 0) {
    printf "%s_kendall_tau=%.4f\n", tag, (conc - disc) / pairs
    printf "%s_concordant_share=%.4f\n", tag, conc / pairs
  }
  if (k > 1) printf "%s_spearman_rho=%.4f\n", tag, 1 - (6 * d2) / (k * (k * k - 1))
  printf "%s_sum_d2=%d\n", tag, d2
}
function stat2(k, tag) { stat(k, tag) }
' "$PAGE"

echo "figures=FREE -- the page is living and may gain an erratum; the ordering arithmetic is HELD"
