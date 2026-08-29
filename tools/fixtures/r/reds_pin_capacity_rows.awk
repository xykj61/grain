# tools/fixtures/r/reds_pin_capacity_rows.awk -- how a REDS row is read, spelled once.
#
# reds_pin_capacity_scan.sh asks this of the living pin and of every shelf, so the two can never
# come to disagree about what a row is (REDS %231: a set spelled twice is a set two files may come
# to disagree about).
#
# TWO QUESTIONS, TWO READINGS, on purpose:
#
#   fold_refused()  would reds_fold.sh refuse this row? Since door B (20260829): the LAST bold
#                   status marker decides -- BOOKED and CLOSED fold, OPEN refuses, and a
#                   markerless row keeps the elder whole-uppercase-word test. This mirrors the
#                   fold tool's own case, so it is the only honest way to ask the question.
#
#   last_marker()   the LAST bold marker beginning OPEN, CLOSED, or BOOKED. This is the row's
#                   DECLARED status, read the way reds_status_consistency_scan.sh reads it,
#                   because a row that closes writes the newer word after the older one. BOOKED
#                   (door B) means the defect's instances stand repaired and the remainder is a
#                   ratchet, a seat, or a booked lap -- not open, not closed.
#
#   awk -f reds_pin_capacity_rows.awk -v mode=pin       FILE   # shell assignments for eval
#   awk -f reds_pin_capacity_rows.awk -v mode=open_rows FILE   # one row number per line

function last_marker(s,   pos, rest, hit, len, found, word) {
  found = "unmarked"
  pos = 1
  while (1) {
    rest = substr(s, pos)
    if (!match(rest, /\*\*(OPEN|CLOSED|BOOKED)[^*]*\*\*/)) break
    hit = pos + RSTART - 1
    len = RLENGTH
    word = substr(s, hit + 2, 4)
    if (word == "OPEN") found = "open"
    else if (word == "BOOK") found = "booked"
    else found = "closed"
    pos = hit + len
  }
  return found
}

function fold_refused(s,   m) {
  m = last_marker(s)
  if (m == "booked" || m == "closed") return 0
  if (m == "open") return 1
  return (s ~ /(^|[^A-Za-z])OPEN([^A-Za-z]|$)/)
}

function row_number(s,   r) {
  r = s
  sub(/^\*\*REDS [%#]/, "", r)
  sub(/[^0-9].*/, "", r)
  return r
}

/^\*\*REDS [%#][0-9]/ {
  rows++
  len[rows] = length($0) + 1
  if (fold_refused($0)) refused++
  if (last_marker($0) == "open") {
    opens++
    if (mode == "open_rows") print row_number($0)
  }
}

END {
  if (mode != "pin") exit 0
  # Median by sort and upper-middle element, so an even count leans to the larger row rather than
  # inventing a mean that stands between two real rows.
  for (i = 1; i <= rows; i++)
    for (j = i + 1; j <= rows; j++)
      if (len[j] < len[i]) { t = len[i]; len[i] = len[j]; len[j] = t }
  med = (rows > 0) ? len[int(rows / 2) + 1] : 0
  printf "PIN_ROWS=%d\nPIN_OPEN=%d\nPIN_REFUSED=%d\nMEDIAN=%d\n", rows + 0, opens + 0, refused + 0, med + 0
}
