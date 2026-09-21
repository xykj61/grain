#!/bin/sh
# tools/fixtures/l/link_text_promise_scan.sh -- a link's visible path is a promise too.
#
# WHY. This tree writes its links with the path showing -- in the shape [`<room>/<page>.md`](../<room>/<page>.md),
# with angle-bracket placeholders standing where a real room and page would go, since an illustration built from a
# real-looking name reads as a citation to every reader and every meter.
# A reader takes the backticked text in at the door and copies it -- into a grep, a cat, a message
# to a peer -- long before anyone clicks. Every standing link guard reads the OTHER half. The
# broken-link duty of tools/l/living_docs_lint.rish tests the target, tools/fixtures/t/tracked_link_scan.sh
# asks whether the target resolves in a fresh clone rather than on this disk, and
# tools/fixtures/l/link_touch_scan.sh asks the same target question at staging time. So a link whose
# visible path names a file the tree does not carry passes every one of them, because the thing it
# promises and the thing it opens are two different strings and only one was ever read.
#
# THE ROAD IT ARRIVES BY, proven on this tree's own history rather than argued. A fold moves a room
# and repoints the TARGET. On `20260828` commit d3ce030b4 rewrote
# `../active-designing/yonder/...` to `../active-designing/yonder/date/20260720/...` inside
# context/TAME_GUIDANCE.md and left the anchor text at its pre-fold spelling -- visible on one line,
# where sibling links that folded earlier carry both halves in agreement and the STOA plans carry
# one half moved. Two room moves, and the anchor was touched by neither. Measured on the seating
# lap: 69 living anchors across 15 pages promise a path this tree does not carry, while all 69 links
# open. All 69 were swept the next day, each anchor taking the path its own link already opened.
#
# WHAT IS READ, and what is deliberately read past.
#   An anchor counts only when it LOOKS like a path a reader would copy: it holds a slash, ends in
#   an extension this tree writes, and carries no space, fragment, or glob character. A prose phrase
#   in backticks is not a promise about a path.
#   The target must RESOLVE. A link that opens nowhere is a plain broken link and belongs to
#   living_docs_lint; this scan reads only the narrower case -- opens fine, promises elsewhere.
#   An anchor is tried BOTH ways, root-relative and relative to the citing page, because both
#   spellings are honest and this tree writes both. Only an anchor that reaches the tree NEITHER way
#   is counted.
#   Resolution is against the TRACKED tree, never the filesystem, for the reason tracked_link_scan
#   gives: an untracked symlink on one pier answers a question a fresh clone will answer differently.
#
# WHAT IS GATED. Living pages, at ZERO. It was a ratchet at 69 for one day, since a guard that reds
# on the ordinary is a guard somebody turns off; the sweep of `20260915.184010` took all 69 with
# tools/fixtures/l/link_text_promise_convert.sh, every page re-derived from its committed bytes, so
# the ordinary is now zero and the reading is a wall. The next anchor promising a path this tree
# does not carry reds on the lap it arrives.
#
# WHAT IS REPORTED, never gated. The same reading across dated testimony -- a page whose own
# basename carries a one-clock stamp, and every date/, archive/ or yonder/ shelf. Accrete-never-break:
# testimony keeps every word it wrote, and a stale reference there is resolved rather than rewritten.
#
# USAGE
#   sh tools/fixtures/l/link_text_promise_scan.sh
#   sh tools/fixtures/l/link_text_promise_scan.sh --list     # name every living hit
#   sh tools/fixtures/l/link_text_promise_scan.sh --tsv      # the same hits, tab-separated for a tool
#
# WHY A TSV MODE. The converter beside this scan must reach exactly the anchors this scan counts and
# nothing beside them, or a sweep and its meter are reading two different populations. One reading,
# printed two ways: --list for a person, --tsv for tools/fixtures/l/link_text_promise_convert.sh.
# Each --tsv row is page, shown text, opened target, tab separated, one living hit per line.
# Duplicate rows collapse, since one pair repeated on a page is one substitution either way.
# In this mode the summary lines go to STDERR, so a tool reading stdout receives rows and nothing
# else. The ceiling still runs and still refuses -- a mode that quietly skipped the gate would be a
# second population by another road. First residency taught the separation: with the summary on
# stdout the converter read `ceiling=69` as a page name, and awk takes a bare name holding an equals
# sign as a VARIABLE ASSIGNMENT rather than a missing file, so it reported no error at all.
#
# Driven by tools/l/link_text_promise_witness.rish. Run from the repository root.

set -eu

# `xargs -a FILE` and `xargs -d` are GNU extensions; BSD xargs refuses both, and the macOS pier is a
# living seat. tools/fixtures/s/shell_portable.sh carries the one portable spelling. The helper is
# reached through this script's own $0 rather than through the caller's directory, because the pen
# runs this scan from inside a throwaway repository where a relative source finds nothing.
#
# THE ROOT IS WALKED rather than computed by depth arithmetic: a fold moving this script one
# directory deeper breaks a fixed `../s` reach silently, which is the class
# tools/f/fixture_depth_witness.rish holds at zero. The walk climbs from this script's own $0
# looking for rishi/bin beside tools/fixtures.
#
# THE SIBLING REACH REMAINS AS A NAMED FALLBACK, because tools/fixtures/l/link_text_promise_control.sh
# copies this scan into a flat throwaway pen holding fixtures/l and fixtures/s and no tree at all.
# There is no root to find there, so a walk that only refuses would refuse the control's own pen.
_here=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_root="$_here"
_steps=0
while [ ! -d "$_root/rishi/bin" ] || [ ! -d "$_root/tools/fixtures" ]; do
  _steps=$((_steps + 1))
  if [ "$_steps" -gt 8 ] || [ "$_root" = "/" ] || [ -z "$_root" ]; then
    _root=""
    break
  fi
  _root=$(dirname "$_root")
done
if [ -n "$_root" ]; then
  _portable="$_root/tools/fixtures/s/shell_portable.sh"
else
  _portable="$_here/../s/shell_portable.sh"
fi
[ -f "$_portable" ] || { echo "$0: shell_portable.sh absent -- looked in a walked root and beside \$0" >&2; exit 2; }
. "$_portable"

ceiling="${LINK_TEXT_PROMISE_CEILING:-0}"
list=no
tsv=no
case "${1:-}" in
  --list) list=yes ;;
  --tsv)  tsv=yes ;;
  "") ;;
  *) echo "verdict=bad_flag"; echo "refused: unknown flag ${1} -- this scan takes --list or --tsv" >&2; exit 1 ;;
esac

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: run me from inside the repository" >&2; exit 1; }

work=$(mktemp -d) || { echo "verdict=no_pen"; exit 1; }
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files > "$work/tracked.txt"
# vendor/, gratitude/ and seed/ are held or projected rather than authored here.
# Each page is handed to awk with a leading `./`. awk reads a bare argument as a VARIABLE
# ASSIGNMENT whenever the name left of an equals sign is a valid identifier, so a root-level page
# called `eq=1.md` would be read as a setting rather than opened -- no error, no hit, and the page
# passes in silence. A slash anywhere in the name already defeats that reading, which is why only
# the root runs out of accident. The prefix is stripped back off inside the program, so every
# reported path stays the tracked spelling.
git ls-files '*.md' '*.mdc' \
  | grep -v '^vendor/' | grep -v '^gratitude/' | grep -v '^seed/' \
  | sed 's|^|./|' > "$work/pages.txt" || true

pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
[ "$pages" -gt 0 ] || { echo "pages=0"; echo "verdict=no_pages"; exit 1; }

# One awk per batch of pages, reading the tracked set once. A process per link ran for minutes.
# The program lands in the pen rather than on stdin: xargs splits this roster into four batches on
# this tree, and `awk -f /dev/stdin` would be handed an exhausted stream from the second batch on --
# which reads as an empty program, so three quarters of the tree passed in silence.
cat > "$work/read.awk" <<'AWK'
function norm(p,   i, c, n, parts, stack, out) {
  gsub(/\/+/, "/", p)
  c = split(p, parts, "/")
  n = 0
  for (i = 1; i <= c; i++) {
    if (parts[i] == "" || parts[i] == ".") continue
    if (parts[i] == "..") { if (n > 0) n--; continue }
    stack[++n] = parts[i]
  }
  out = ""
  for (i = 1; i <= n; i++) out = (out == "" ? stack[i] : out "/" stack[i])
  return out
}
function here(p) { return (p != "" && ((p in tracked) || (p in dirs))) }
# Testimony keeps every word it wrote: a stamped basename, or any dated / archived / deferred shelf.
function testimony(p,   b) {
  if (p ~ /(^|\/)(date|archive|yonder)\//) return 1
  b = p; sub(/^.*\//, "", b)
  return (b ~ /^[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]/)
}
NR == FNR {
  tracked[$0] = 1
  d = $0
  while (sub(/\/[^\/]*$/, "", d)) dirs[d] = 1
  next
}
FNR == 1 { page = FILENAME; sub(/^\.\//, "", page); dir = page; if (!sub(/\/[^\/]*$/, "", dir)) dir = "" }
{
  line = $0
  while (match(line, /\[`[^`]+`\]\([^)]+\)/)) {
    m = substr(line, RSTART, RLENGTH)
    line = substr(line, RSTART + RLENGTH)
    txt = m; sub(/^\[`/, "", txt); sub(/`\].*$/, "", txt)
    tgt = m; sub(/^.*\]\(/, "", tgt); sub(/\)$/, "", tgt)
    # An anchor is a promise about a path only when it is shaped like one.
    if (txt ~ /[ #*?]/) continue
    if (txt !~ /\//) continue
    if (txt !~ /\.(md|mdc|rish|rye|sh|kyri|kyri|brix|glow|awk|json|txt|nix|brush|myc)$/) continue
    if (tgt ~ /^(https?:|mailto:|#)/) continue
    sub(/#.*$/, "", tgt)
    if (tgt == "") continue
    # A link that opens nowhere is living_docs_lint's reading, never this one.
    if (!here(norm(dir "/" tgt))) continue
    # Both spellings are honest; only an anchor reaching the tree NEITHER way is a broken promise.
    if (here(norm(txt))) continue
    if (here(norm(dir "/" txt))) continue
    print (testimony(page) ? "testimony" : "living") "\t" page "\t" txt "\t" tgt
  }
}
AWK
xargs_lines "$work/pages.txt" awk -f "$work/read.awk" "$work/tracked.txt" > "$work/hits.txt"

living=$(awk -F'\t' '$1 == "living"' "$work/hits.txt" | wc -l | tr -d ' ')
testimony=$(awk -F'\t' '$1 == "testimony"' "$work/hits.txt" | wc -l | tr -d ' ')
living_pages=$(awk -F'\t' '$1 == "living" { print $2 }' "$work/hits.txt" | sort -u | wc -l | tr -d ' ')

if [ "$list" = yes ]; then
  awk -F'\t' '$1 == "living" { print "promise: " $2 " shows " $3 " and opens " $4 }' "$work/hits.txt" | sort
fi

# The converter's whole roster, so a sweep can never reach a page this reading passed over.
if [ "$tsv" = yes ]; then
  awk -F'\t' '$1 == "living" { print $2 "\t" $3 "\t" $4 }' "$work/hits.txt" | sort -u
fi

# In --tsv mode the rows own stdout; every summary line goes to stderr.
say() { if [ "$tsv" = yes ]; then echo "$@" >&2; else echo "$@"; fi; }

say "pages=$pages"
say "living=$living"
say "living_pages=$living_pages"
say "testimony=$testimony"
say "ceiling=$ceiling"

if [ "$living" -gt "$ceiling" ]; then
  say "ceiling_ok=no"
  say "verdict=over_ceiling"
  echo "refused: $living living anchors promise a path the tree does not carry, above the ceiling of $ceiling" >&2
  echo "refused: name them with  sh tools/fixtures/l/link_text_promise_scan.sh --list" >&2
  exit 1
fi

say "ceiling_ok=yes"
say "verdict=ok"
