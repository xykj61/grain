# tools/fixtures/r/reference_block.awk -- tell a reference table apart from a paragraph.
#
# WHY THIS FILE EXISTS. A report card reads a page by counting sentences, and a reference table has
# none. This tree writes its key lists without terminal punctuation, so a run of them merges into
# whatever sentence abuts it and the card weighs a head as if it held a handful of enormous ones.
# Twenty-eight such lines moved one real scan's head from C 74 to A 91 with its content unchanged,
# which is seventeen composite points of punctuation (REDS %397). So the table is held out of the
# reading and reported beside it, the way declaration docs already are.
#
# WHAT COUNTS AS ONE, read off the line's own face rather than judged:
#
#   entry         leading space, a bare identifier, TWO or more spaces, then text
#   continuation  a line indented deeper than that entry's key column
#   block         two or more entries sharing one key column, continuations between them allowed
#
# TWO entries rather than one, and a blank line ends a block. A lone double-spaced line is prose far
# more often than a table, and holding one out would quietly shrink a page's measured prose; a blank
# line is how this tree ends a table, so it is where a block ends here too.
#
# A FENCED REGION IS LEFT ALONE. Both readings that consume this already skip a fence, so reaching
# in would move no grade and would only inflate the count the card prints.
#
# MEASURED 20260831 across the tree: 154 program heads carry a block, 928 lines in all, and holding
# them out moves 130 of those files -- 57 across the B door, one below it, mean +7.2 composite
# points. Exactly one living non-dated prose file of 1,503 carries a block at all, and it is
# template-manifest.bron, whose every line reads `template  <path>  # why`.
#
# USAGE
#   awk -v MODE=prose -f reference_block.awk <file>   the lines that are NOT part of a block
#   awk -v MODE=ref   -f reference_block.awk <file>   the lines that ARE
#   awk -v MODE=count -f reference_block.awk <file>   how many lines are
#
# Read by tools/fixtures/q/qa_report_card.sh. Proven by tools/fixtures/q/qa_report_card_control.sh.
{ ln[NR] = $0 }
END {
  # A fence opens and closes on a line of its own, so the state flips on the marker and the marker
  # itself belongs to neither side.
  infence = 0
  for (i = 1; i <= NR; i++) {
    if (ln[i] ~ /^[ \t]*```/) { fence[i] = 1; infence = 1 - infence; continue }
    fence[i] = infence
  }
  # A blank line carries indent -1 on purpose: it is deeper than no key column, so it ends a block
  # wherever it falls.
  for (i = 1; i <= NR; i++) {
    entry[i] = 0; keycol[i] = -1; indent[i] = -1
    if (ln[i] ~ /^[ \t]*$/) continue
    match(ln[i], /^[ \t]*/); indent[i] = RLENGTH
    if (fence[i]) continue
    # `[ ][ ]+` rather than an interval, since BSD awk read nothing from `\<` once already and an
    # interval is the same shape of risk (the register scan's own comment, 20260825).
    if (ln[i] ~ /^[ \t]*[A-Za-z_][A-Za-z0-9_]*[ ][ ]+[^ ]/) { entry[i] = 1; keycol[i] = indent[i] }
  }
  for (i = 1; i <= NR; i++) {
    if (!entry[i] || ref[i]) continue
    col = keycol[i]; last = i; entries = 1; j = i + 1
    while (j <= NR) {
      if (entry[j] && keycol[j] == col) { entries++; last = j; j++; continue }
      if (!fence[j] && indent[j] > col) { j++; continue }
      break
    }
    if (entries >= 2) { for (k = i; k <= last; k++) if (!fence[k] && indent[k] >= col) ref[k] = 1 }
    i = last
  }
  n = 0
  for (i = 1; i <= NR; i++) {
    if (ref[i]) { n++; if (MODE == "ref") print ln[i] }
    else if (MODE == "prose") print ln[i]
  }
  if (MODE == "count") print n
}
