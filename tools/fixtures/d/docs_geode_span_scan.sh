#!/bin/sh
# tools/fixtures/d/docs_geode_span_scan.sh -- a tutorial fence still equals the source lines.
#
#   sh tools/fixtures/d/docs_geode_span_scan.sh docs-geode/tutorials/the-two-functions.md
#
# A span fence opens with ```START:END:path and closes with ```. The lines between
# must equal path's lines START through END, counted from 1. A drift prints mismatch.
# This is the contract check beside the tutorial: the page asks, the file answers.
set -eu

cd "$(dirname "$0")/../../.."
page=${1:-docs-geode/tutorials/the-two-functions.md}
[ -f "$page" ] || { echo "docs-geode-span: missing $page"; exit 2; }

awk '
function finish_span(   cmd, line, got, gn) {
  spans++
  cmd = "sed -n \"" start "," end "p\" \"" path "\""
  got = ""
  gn = 0
  while ((cmd | getline line) > 0) {
    if (gn++) got = got "\n"
    got = got line
  }
  close(cmd)
  if (got == body) {
    print "match " path " " start " " end
  } else {
    mismatch++
    print "mismatch " path " " start " " end
  }
}
BEGIN { inspan = 0; spans = 0; mismatch = 0 }
{
  if (!inspan && $0 ~ /^```[0-9]+:[0-9]+:[^ ]+$/) {
    spec = substr($0, 4)
    n = split(spec, a, ":")
    start = a[1]
    end = a[2]
    path = a[3]
    for (i = 4; i <= n; i++) path = path ":" a[i]
    inspan = 1
    body = ""
    bn = 0
    next
  }
  if (inspan && $0 == "```") {
    finish_span()
    inspan = 0
    next
  }
  if (inspan) {
    if (bn++) body = body "\n"
    body = body $0
  }
}
END {
  if (inspan) {
    mismatch++
    print "mismatch unclosed " path " " start " " end
  }
  print "spans=" spans
  print "mismatch=" mismatch
  if (mismatch == 0 && spans > 0) print "verdict=ok"
  else print "verdict=miss"
}
' "$page"
