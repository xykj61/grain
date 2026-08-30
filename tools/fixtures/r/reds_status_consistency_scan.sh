#!/bin/sh
# tools/fixtures/r/reds_status_consistency_scan.sh -- a row the ledger says is closed does not still
# read OPEN.
#
# WHAT THIS IS FOR. construction/REDS.md is the first page a lap reads under reds-first, and the
# one thing it has to get right is which rows are still open. A row carries that answer in a bold
# marker on its own line -- **OPEN** while the work stands, **CLOSED** once a witness closes it --
# and the ledger writes eight spellings of those two words, from a bare **CLOSED.** to a whole
# sentence in bold. The marker read here is bold text BEGINNING with OPEN or CLOSED, last one on
# the line, since a row that closes writes the newer word after the older.
#
# WHY IT DRIFTS, structurally rather than by accident. The ledger folds: the living pin keeps the
# rows still flat and every elder row moves onto a shelf under construction/archive/. So a row that
# CLOSES an earlier row routinely folds away while the row it closed stays on the pin. The closing
# sentence lands in a closed stack a lap never walks; the stale **OPEN** stays on the open shelf a
# lap reads first. Every future fold reproduces that split, which is why this is a meter rather
# than a correction.
#
# It happened on 20260828. `%308` closed and wrote "`%307`'s open clause closes with it: a guard
# reads instruction files against the gate list now". `%307`'s own row kept "**OPEN** -- no guard
# reads an instruction file against the gate list", and `%308` folded to construction/archive/ the
# same day. A reds-first lap read the pin, picked `%307` as its work, and found the guard already
# built, rostered, and GREEN on metal.
#
# WHAT IS GATED, at zero:
#   contradicted_rows  a row marked **OPEN** that another row names inside a closure phrase
#   phantom_closures   a closure phrase naming a row number the ledger's spine does not hold
#
# WHAT IS REPORTED, never gated: spine_rows, open_rows, closed_rows, closure_claims,
# duplicate_row_lines, and fold_blocked_rows -- rows this reading does NOT call open whose text
# still carries the bare uppercase word OPEN, which is the looser test tools/fixtures/r/reds_fold.sh
# refuses a fold on. The two readings differ on purpose: the fold tool errs toward keeping a row on
# the pin, and this one reports what the row says now. A row that records its own open history in
# prose satisfies both descriptions at once, so the number names which closed rows want a word-level
# touch before they can fold, rather than letting the next fold discover them at row_open. Most rows carry no marker and want none -- a row booked and repaired in one
# lap says so in its own prose. The marker is for a row that outlives its lap, so an absent marker
# is the ordinary case rather than a debt, and gating on it would refuse the whole ledger.
#
# HOW A CLOSURE PHRASE IS READ, and the honest limit. A row number standing within 60 characters of
# close/closes/closed/closing/closure, on another row's line. That is word proximity rather than
# comprehension, so it over-matches on its own: a row may discuss `%103` beside the word "closed"
# without claiming to close it. The gate survives that because it fires ONLY when the named row
# ALSO carries **OPEN** -- and a row marked open, named beside a closing word in another row, is
# exactly the ambiguity this page must not carry, whichever way it resolves.
#
# WHAT IT READS, and what it does not. Prose rows only -- `**REDS %N` and `**REDS #N` -- because
# only prose rows carry markers; the 83 elder table rows predate the habit and are counted by the
# spine's own scans instead. A row number appearing on more than one line (a row plus a pointer to
# it from another shelf) keeps the strongest marker any of its lines carries, since a markerless
# pointer line must never erase a status; those lines are counted as duplicate_row_lines.
#
# It does not reach whether a closure is TRUE -- that a witness ran and stayed green. This reads
# the ledger against itself and stops there.
#
# THE SETS ARE SPELLED ONCE. The spine's file set comes from tools/fixtures/r/reds_spine_files.sh and
# the row shape is the same expression tools/fixtures/r/reds_row_present.sh reads. That the two agree
# is proven on metal by the witness rather than promised here: it reads this scan's highest row
# against tools/fixtures/r/reds_ledger_monotone_scan.sh's own expect_next, and asks
# reds_row_present.sh for that row and the one past it.
#
#   sh tools/fixtures/r/reds_status_consistency_scan.sh
#   REDS_SPINE_GLOB="pen/*.md" sh tools/fixtures/r/reds_status_consistency_scan.sh   # for a pen
#
# Exit 0 clean - 1 a gated reading above zero - 2 misuse. Purely local: it reads markdown.
set -eu

SPINE=$(sh tools/fixtures/r/reds_spine_files.sh) || {
  echo "verdict=misuse detail=no_spine_files"
  exit 2
}

# The window is 60 characters because the corpus's own binding sentences fit inside it -- the
# widest standing case, "`%307`'s open clause closes with it", spans 34. A window wide enough to
# reach the next sentence would bind rows that merely stand near one another.
awk -v window=60 '
# The LAST bold marker on the line is the row status, because a row that reopens or closes writes
# the newer word after the older one. The marker is bold text BEGINNING with OPEN or CLOSED rather
# than the exact string, because the ledger writes eight spellings of it -- **OPEN**, **OPEN,
# gated**, **OPEN as five booked folds**, **CLOSED**, **CLOSED.**, and a whole sentence in bold.
# Reading only the exact forms saw four of eleven open rows on 20260828, which is a status meter
# lying quietly, and the looser bare-word test in reds_fold.sh was the more correct of the two.
function last_marker(s,   pos, rest, hit, len, found, word) {
  # BOOKED joined OPEN and CLOSED with door B (20260829): the defect stands repaired and the
  # remainder is a ratchet, a seat, or a booked lap -- neither open nor closed, and lawful for
  # reds_fold.sh to fold.
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
/^\*\*REDS [%#][0-9]/ {
  n = $0
  sub(/^\*\*REDS [%#]/, "", n)
  sub(/[^0-9].*/, "", n)

  st = last_marker($0)

  if ($0 ~ /(^|[^A-Za-z])OPEN([^A-Za-z]|$)/) bareopen[n] = 1

  if (n in rowstatus) {
    duplicate_lines++
    # A markerless pointer line must never erase a status a real row line already wrote.
    if (st != "unmarked") rowstatus[n] = st
  } else {
    rowstatus[n] = st
    order[++rows] = n
    if (n + 0 > maxrow) maxrow = n + 0
  }

  # Closure claims are read per LINE, so a pointer line on another shelf is read too.
  pos = 1
  while (1) {
    rest = substr($0, pos)
    if (!match(rest, /clos(e|es|ed|ing|ure)/)) break
    hit = pos + RSTART - 1
    len = RLENGTH
    s = hit - window; if (s < 1) s = 1
    ctx = substr($0, s, window * 2 + len)
    pos = hit + len
    cc = ctx
    # A CUSTODY GATE WEARS THE SAME SIGIL AS A LEDGER ROW. `.claude/rules/git-signing.md`
    # seats `%` for any number this tree assigns itself -- REDS rows, custody gates, errata,
    # study numbers alike -- so `gate %5` inside a sentence carrying a closing word read as a
    # claim about REDS row 5, and refused a ledger that was entirely correct (REDS %375). A
    # gate is never a row, so the word that always precedes one is read and the pair dropped
    # before the tokens are scanned. Narrow on purpose: only the literal word `gate` and the number
    # touching it, with the backtick this tree quotes numbers in allowed between them, so
    # `closed by %5` keeps every tooth it had. A line-wrapped `gate` and its number fall outside
    # this, exactly as they fall outside the per-line scan itself.
    gsub(/[Gg]ate `?[%#][0-9][0-9]*/, "gate", cc)
    while (match(cc, /[%#][0-9][0-9]*/)) {
      tok = substr(cc, RSTART + 1, RLENGTH - 1)
      cc = substr(cc, RSTART + RLENGTH)
      if (tok == n) continue
      key = n "->" tok
      if (key in seen) continue
      seen[key] = 1
      claims++
      claim_source[claims] = n
      claim_target[claims] = tok
    }
  }
  next
}
END {
  contradicted = 0
  phantom = 0
  for (i = 1; i <= claims; i++) {
    tgt = claim_target[i]
    src = claim_source[i]
    if (!(tgt in rowstatus)) {
      phantom++
      print "detail: phantom_closure -- %" src " names %" tgt " beside a closing word, and the spine holds no such row"
      continue
    }
    if (rowstatus[tgt] == "open") {
      contradicted++
      print "detail: contradicted -- %" tgt " reads **OPEN** while %" src " names it inside a closure phrase"
    }
  }
  opens = 0; closeds = 0; foldblocked = 0
  for (i = 1; i <= rows; i++) {
    n = order[i]
    if (rowstatus[n] == "open")   { opens++; print "detail: open_row %" n }
    if (rowstatus[n] == "closed") { closeds++ }
    if (rowstatus[n] == "booked") { bookeds++ }
    # Since door B the fold tool reads the marker first, so a marked row carrying the bare word
    # OPEN in its prose folds fine; only a MARKERLESS row with that word would still be refused
    # at row_open, and that is the reading kept here.
    if (rowstatus[n] == "unmarked" && (n in bareopen)) {
      foldblocked++
      print "detail: fold_blocked %" n " -- carries the bare word OPEN with no marker, which reds_fold.sh refuses"
    }
  }
  print "spine_rows=" rows + 0
  print "highest_row=" maxrow + 0
  print "open_rows=" opens
  print "closed_rows=" closeds
  print "booked_rows=" bookeds + 0
  print "closure_claims=" claims + 0
  print "duplicate_row_lines=" duplicate_lines + 0
  print "fold_blocked_rows=" foldblocked
  print "contradicted_rows=" contradicted
  print "phantom_closures=" phantom
  if (contradicted > 0 || phantom > 0) {
    print "verdict=ledger_contradicts_itself"
    exit 1
  }
  print "verdict=every_status_agrees"
}
' $SPINE
