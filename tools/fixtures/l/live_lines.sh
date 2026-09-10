# tools/fixtures/l/live_lines.sh -- which lines of a shell source is a reading allowed to read?
#
#   . tools/fixtures/l/live_lines.sh
#   live_lines <file>          # emit the live lines of one file
#   live_lines_awk             # emit the awk function source, to embed in a multi-file pass
#
# WHY THIS EXISTS, AND WHY IT IS A LIBRARY RATHER THAN A HABIT. A scan that greps a source for an
# idiom reads a MATCHED SPAN, and a span carries no position. A shell script may hold a hundred
# lines inside one quoted argument -- an embedded awk program, a `git filter-branch --tree-filter`
# body, a heredoc fed to another interpreter -- and text inside such an argument is data this file
# hands to another command rather than something this file does.
#
# The walker below reads a source as a shell lexer -- single quotes, double quotes with backslash
# escapes, unquoted `#` comments, and heredocs including the `<<-` and quoted-delimiter forms --
# and calls a line LIVE when it began outside every quoted region and is not a whole-line comment.
#
# THE LANTERN FIRED TWICE, WHICH IS WHY IT IS A LOOM (`20260910.035630`). It was written once, for
# `tools/c/convergence_census.sh`, where a write inside a `--tree-filter` string had made
# `upstream_shape_scan.sh` a standing false candidate. Five days later
# `tools/fixtures/e/elf_machine_census_scan.sh` met the same shape from the other side: thirteen
# `run ["sh" "-c" "file ..."]` lines inside the heredoc PLANTS of
# `tools/fixtures/s/self_matching_assert_control.sh` were counted as thirteen live sites, and a
# census standing at 3 of a ceiling of 3 read 16 the hour that control landed. Two rooms, one
# reading, so the reading lives in one file.
#
# PROVEN BY ITS OWN EXIT STATE, which is the check that tells tracking from drift: a well-formed
# shell script ends outside every quote, so the walker's final state is the reading. Measured over
# the tree's 3,322 tracked tool sources it ends OUT on 3,321.
#
# THE ONE HONEST LIMIT: RISHI IS NOT SHELL. This is a shell lexer, and a `.rish` source whose
# quoting differs desyncs the walk from that line to the file's end. The failure direction is safe
# in both callers -- a desync can only ever WITHHOLD lines, so a reading loses a site rather than
# inventing one. `tools/l/launch-claude-chapter.rish:83` is the tree's one such line today.
#
# BOUNDS: the caller sets its own line bound; this file walks whatever it is handed.

live_lines_awk() {
  # live_lines_awk -- the awk source of the walker, for a caller building a multi-file pass.
  # State lives in `ll_st` / `ll_hd` / `ll_strip`, which a multi-file caller resets on `FNR == 1`.
  # invariant: `ll_live` answers for the state at the START of the line it is handed, so a line
  # that OPENS a quoted region is still live and every line inside it is not.
  cat <<'AWK'
function ll_live(s,   len, i, c, p, rest, q, d, idx, t, was) {
  was = (ll_st == "OUT" && s !~ /^[[:space:]]*#/) ? 1 : 0
  if (ll_st == "HD") {
    t = s
    if (ll_strip) sub(/^[ \t]+/, "", t)
    if (t == ll_hd) { ll_st = "OUT"; ll_hd = "" }
    return 0
  }
  len = length(s); i = 1
  while (i <= len) {
    c = substr(s, i, 1)
    if (ll_st == "SQ") { if (c == "'") ll_st = "OUT"; i++; continue }
    if (ll_st == "DQ") {
      if (c == "\\") { i += 2; continue }
      if (c == "\"") ll_st = "OUT"
      i++; continue
    }
    if (c == "\\") { i += 2; continue }
    if (c == "'") { ll_st = "SQ"; i++; continue }
    if (c == "\"") { ll_st = "DQ"; i++; continue }
    if (c == "#") {
      p = (i == 1) ? " " : substr(s, i - 1, 1)
      if (p == " " || p == "\t" || p == ";" || p == "(" || p == "&" || p == "|") break
      i++; continue
    }
    if (substr(s, i, 2) == "<<") {
      rest = substr(s, i + 2)
      ll_strip = 0
      if (substr(rest, 1, 1) == "-") { ll_strip = 1; rest = substr(rest, 2) }
      if (substr(rest, 1, 1) == "<") { i += 3; continue }
      sub(/^[ \t]*/, "", rest)
      q = substr(rest, 1, 1)
      if (q == "'" || q == "\"") {
        d = rest; sub(/^./, "", d); idx = index(d, q)
        if (idx > 0) { ll_hd = substr(d, 1, idx - 1); ll_st = "HD" }
      } else if (match(rest, /^[A-Za-z_][A-Za-z0-9_]*/)) {
        ll_hd = substr(rest, 1, RLENGTH); ll_st = "HD"
      }
      break
    }
    i++
  }
  return was
}
function ll_reset() { ll_st = "OUT"; ll_hd = ""; ll_strip = 0 }
AWK
}

live_lines() {
  # live_lines <file> [max-lines] -- the live lines of one file, bounded.
  # invariant: every emitted line began outside every quoted region, so a matched idiom is one this
  # file performs rather than text it hands to another command.
  awk -v max="${2:-20000}" "$(live_lines_awk)"'
    BEGIN { ll_reset() }
    NR > max { exit }
    { if (ll_live($0)) print }
  ' "$1" 2>/dev/null
}
