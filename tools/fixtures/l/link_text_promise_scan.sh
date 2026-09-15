#!/bin/sh
# tools/fixtures/l/link_text_promise_scan.sh -- a link's visible path is a promise, and its target
# is a different one. This reads the pages where the two disagree.
#
# WHY. This tree writes most of its cross-references as [`../room/file.md`](../room/file.md) --
# a backticked relative path as the visible text, and the same path as the target. Two readers use
# that line in two ways. One CLICKS, and reaches the target. One COPIES what they see, into a
# terminal, a grep, or a sibling page. When the two halves disagree, the first reader is served and
# the second is sent nowhere, and every standing guard reports the line as sound.
#
# NOTHING IN THE TREE READ THIS. `tools/t/tracked_link_witness.rish` resolves link TARGETS, and
# every target here resolves -- that is what makes the class invisible. `tools/l/law_tool_citation_witness.rish`
# reads backticked paths and gates them, and its own header bounds it to `.claude/rules/` on
# purpose. `tools/d/docs_command_path_witness.rish` reads a path a page tells a reader to RUN and
# passes an absent one free, also on purpose: tree-wide, a printed path the tree lacks is often one
# the reader is being asked to create.
#
# WHAT IS GATED, hard, at zero: `docs-geode/`, the shipping shelf -- the pages a newcomer meets
# first, where a copied path that reaches nothing is the most expensive. The room was swept to zero
# on the lap this scan was written, so the gate refuses only what arrives after it.
#
# WHAT IS RATCHETED under a ceiling that only falls: every other living page. The class stands
# across rooms this lane does not own, and a gate at zero would red on fifteen pages belonging to
# other ships -- a gate that reds on somebody else's work is a gate somebody turns off. A lane
# sweeping its own page lowers CEILING in the same commit.
#
# THE READING IS SELF-CONTAINED, and that is the whole reason it can be a gate where the proposal
# it grew from could not. `active-designing/20260911-000651_the-front-door-that-named-no-ceiling.md`
# proposed resolving every backticked relative path against its page's own directory. Run against
# `docs-geode/tutorials/the-first-hour.md` that reading refuses `./bootstrap.sh`, which is correct
# and which the page is correct to print: two lines above it the page says `cd rye`, so the path is
# relative to the reader's working directory rather than to the page. A bare backticked path
# carries no statement about what it is relative to. A LINK does: Markdown resolves a relative
# target against the document, so both halves of `[`X`](Y)` are page-relative by the format's own
# rule, and their disagreement is legible with no guess about intent.
#
# WHAT IS READ PAST, each for its own reason.
#   A file whose own basename carries a one-clock stamp is TESTIMONY and keeps every word it wrote
#   (accrete-never-break, `.claude/rules/stamp-and-name.md`). Counted and reported as `testimony`.
#   `vendor/`, `gratitude/` and `seed/` hold other people's bytes or a projection of our own.
#   A text that is not a relative path -- a bare word, a URL, a sentence -- promises no file.
#   A text and target that agree, which is the ordinary and correct case.
#   A text that RESOLVES from its page. Two different real files may be named deliberately: a text
#   naming a room and a target opening that room's door is one line doing two honest jobs.
#
# USAGE
#   sh tools/fixtures/l/link_text_promise_scan.sh              # the readings
#   sh tools/fixtures/l/link_text_promise_scan.sh --list       # every broken promise, one per line
#
# Proven by tools/l/link_text_promise_witness.rish over tools/fixtures/l/link_text_promise_control.sh.
# Run from the repository root.

set -u

CEILING=223

mode=${1:-report}

work=$(mktemp -d) || exit 1
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files > "$work/tracked.txt" || exit 1

# Every path the repository carries, plus every directory on the way to one, so a link naming a
# room resolves as readily as one naming a file.
awk '
  { print }
  {
    p = $0
    while (sub(/\/[^\/]*$/, "", p)) { if (p != "") print p "/" ; if (p != "") print p }
  }
' "$work/tracked.txt" | sort -u > "$work/paths.txt"

grep -E '\.(md|mdc)$' "$work/tracked.txt" \
  | grep -vE '^(vendor|gratitude|seed)/' > "$work/pages.txt"

echo "pages_read=$(wc -l < "$work/pages.txt" | tr -d ' ')"

: > "$work/links.txt"
# One grep over every page, rather than one per page: the per-file shape did not finish. The list
# rides through `tr` and `xargs -0 -n`, the spelling `tools/fixtures/s/shell_portable.sh` carries
# as `xargs_lines_batched` -- inlined rather than sourced, because the control runs mutated copies
# of this file from a pen with no tree root above them. `xargs -a` is GNU alone and would read
# EMPTY on the other pier, where an empty reading counts as a healthy zero. An empty list runs
# nothing at all, since xargs with no operands would leave grep reading stdin.
if [ -s "$work/pages.txt" ]; then
  tr '\n' '\0' < "$work/pages.txt" \
    | xargs -0 -n 400 grep -HoE '\[`[^`]+`\]\([^) ]+\)' >> "$work/links.txt" 2>/dev/null || true
fi

awk -v paths="$work/paths.txt" '
  BEGIN {
    while ((getline p < paths) > 0) have[p] = 1
    close(paths)
  }
  function normalize(base, rel,   parts, out, n, i, j) {
    # Resolve rel against directory base, the way a Markdown reader does.
    n = split(base "/" rel, parts, "/")
    j = 0
    for (i = 1; i <= n; i++) {
      if (parts[i] == "" || parts[i] == ".") continue
      if (parts[i] == "..") { if (j > 0) j--; continue }
      out[++j] = parts[i]
    }
    p = ""
    for (i = 1; i <= j; i++) p = (i == 1) ? out[i] : p "/" out[i]
    return p
  }
  {
    line = $0
    i = index(line, ":")
    file = substr(line, 1, i - 1)
    rest = substr(line, i + 1)
    j = index(rest, "](")
    text = substr(rest, 3, j - 4)
    target = substr(rest, j + 2)
    sub(/\)$/, "", target)
    sub(/#.*$/, "", target)
    if (text == target) next
    if (text !~ /^\.{1,2}\//) next          # not a relative path: promises no file
    if (target ~ /^[a-z]+:/) next           # a URL target answers a different question
    if (target == "") next
    dir = file
    if (!sub(/\/[^\/]*$/, "", dir)) dir = "."
    tp = normalize(dir, text)
    gp = normalize(dir, target)
    if (tp in have) next                    # the text resolves: two real files, deliberately
    if (!(gp in have)) next                 # the target is broken too: tracked_link owns that
    base = file
    sub(/^.*\//, "", base)
    kind = (base ~ /^[0-9]{8}-[0-9]{6}[_.]/) ? "testimony" : "living"
    room = (file ~ /^docs-geode\//) ? "geode" : "other"
    print kind "\t" room "\t" file "\t" text "\t" target
  }
' "$work/links.txt" | sort -u > "$work/broken.txt"

testimony=$(awk -F'\t' '$1 == "testimony"' "$work/broken.txt" | wc -l | tr -d ' ')
geode=$(awk -F'\t' '$1 == "living" && $2 == "geode"' "$work/broken.txt" | wc -l | tr -d ' ')
other=$(awk -F'\t' '$1 == "living" && $2 == "other"' "$work/broken.txt" | wc -l | tr -d ' ')
pages_other=$(awk -F'\t' '$1 == "living" && $2 == "other" {print $3}' "$work/broken.txt" | sort -u | wc -l | tr -d ' ')

echo "links_read=$(wc -l < "$work/links.txt" | tr -d ' ')"
echo "promise_broken_geode=$geode"
echo "promise_broken_other=$other"
echo "promise_broken_other_pages=$pages_other"
echo "promise_broken_testimony=$testimony"
echo "ceiling=$CEILING"

if [ "$mode" = "--list" ]; then
  awk -F'\t' '{print $1 " " $3 " text=" $4 " target=" $5}' "$work/broken.txt"
fi

[ "$geode" -eq 0 ] || awk -F'\t' '$1 == "living" && $2 == "geode" {print "geode: " $3 " text=" $4 " target=" $5}' "$work/broken.txt"

if [ "$geode" -eq 0 ] && [ "$other" -le "$CEILING" ]; then
  echo "verdict=ok"
  exit 0
fi

if [ "$geode" -ne 0 ]; then
  echo "verdict=geode_promise_broken"
  echo "refused: a docs-geode link shows a path the repository does not carry" >&2
else
  echo "verdict=over_ceiling"
  echo "refused: living broken promises rose above the ceiling that only falls" >&2
fi
exit 1
