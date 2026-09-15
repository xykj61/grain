#!/bin/sh
# tools/fixtures/l/link_text_promise_convert.sh -- make a link's two promises agree.
#
# WHAT IT DOES. A link in this tree's shape carries a backticked path as its visible text and a
# relative path as its target. For every living anchor tools/fixtures/l/link_text_promise_scan.sh
# counts, this tool rewrites the visible text to the path the link already opens. So
# [`<shown>`](<opened>) becomes [`<opened>`](<opened>), and the path a reader copies at the door is
# the path a click reaches.
#
# WHY THAT IS THE REPAIR. The target is the half this tree's fold tools, link guards and staging
# hook have kept true for months. It is measured, repointed and proven; the anchor is the half
# every instrument read past. Taking the anchor from the target therefore copies the correct string
# onto the stale one. It is computable rather than chosen, so every page gets one rule and judgment
# stays out of a mechanical sweep.
#
# WHERE THE ROSTER COMES FROM. The scan's own --tsv reading, and there alone. A page that reading
# passes over -- dated testimony, vendored source, a prose phrase in backticks, a link that opens
# nowhere -- stays beyond this tool's reach by construction. Handing it its own grep would make the
# sweep and the meter two populations, which is the very fault it exists to avoid.
#
# HOW A CHANGE IS PROVEN, and why the proof rides inside the apply. After writing each page, this
# tool re-derives that page from its COMMITTED bytes: it applies the same substitution to
# `git show HEAD:<page>` and compares byte for byte. A match proves the named substitution moved
# and nothing else did. The proof runs in the SAME invocation as the write, on the SAME roster,
# because a separate pass would rebuild that roster from a tree the sweep has just emptied. First
# residency found exactly that: run after a successful sweep, a standalone check read zero anchors
# and answered `nothing_to_do` -- a clean bill of health from an instrument that examined nothing.
#
# THE MODE SURVIVES. Each page is written back through its own inode with `cat "$tmp" > "$f"`.
# A `mv` would carry the temporary file's mode instead, and a file's mode is content the repository
# tracks (.claude/rules/exec-bit.md).
#
# EVERY PAGE IS NAMED WITH A LEADING `./`. awk reads a bare argument as a VARIABLE ASSIGNMENT
# whenever the name left of an equals sign is a valid identifier. A root-level page called
# `eq=1.md` would therefore be read as a setting rather than opened, silently. A slash anywhere in
# the name already defeats that reading, so the root is where the accident runs out. The scan
# carries the same prefix for the same reason, and each is proven load-bearing by its own mutation.
#
# USAGE
#   sh tools/fixtures/l/link_text_promise_convert.sh --dry   # name every substitution, write nothing
#   sh tools/fixtures/l/link_text_promise_convert.sh         # apply, then re-derive every page written
#
# Run from the repository root.

set -eu

here=$(cd "$(dirname "$0")" && pwd)
scan="$here/link_text_promise_scan.sh"
[ -r "$scan" ] || { echo "verdict=no_scan"; echo "refused: the roster comes from $scan, which is absent" >&2; exit 1; }

mode=apply
case "${1:-}" in
  --dry) mode=dry ;;
  "") ;;
  *) echo "verdict=bad_flag"; echo "refused: unknown flag ${1} -- this tool takes --dry, or no flag to apply" >&2; exit 1 ;;
esac

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: run me from inside the repository" >&2; exit 1; }

work=$(mktemp -d) || { echo "verdict=no_pen"; exit 1; }
trap 'rm -rf "$work"' EXIT INT TERM

sh "$scan" --tsv > "$work/roster.tsv" 2>/dev/null || true

# Every roster row carries exactly three tab-separated fields. A malformed row is refused rather
# than swept past, because awk reads a bare argument holding an equals sign as a VARIABLE
# ASSIGNMENT rather than as a missing file -- so a summary line leaking into this roster would be
# read as a page, produce no error, and report a change to a file that does not exist.
if awk -F'\t' 'NF != 3 || $1 == "" || $2 == "" || $3 == "" { print NR; exit 1 }' "$work/roster.tsv" >/dev/null; then
  :
else
  echo "verdict=bad_roster"
  echo "refused: the scan's --tsv reading holds a row that is not three tab-separated fields" >&2
  exit 1
fi

anchors=$(wc -l < "$work/roster.tsv" | tr -d ' ')
echo "anchors=$anchors"
if [ "$anchors" -eq 0 ]; then
  echo "pages=0"; echo "changed=0"; echo "verdict=nothing_to_do"; exit 0
fi

cut -f1 "$work/roster.tsv" | sort -u > "$work/pages.txt"
pages=$(wc -l < "$work/pages.txt" | tr -d ' ')
echo "pages=$pages"

# One substitution rule: inside [`TXT`](TGT...), the anchor becomes TGT. Matched by literal index
# rather than by regex, so a path holding a dot, a plus or a bracket needs no escaping.
cat > "$work/sub.awk" <<'AWK'
NR == FNR { if ($1 == page) { n++; from[n] = $2; to[n] = $3 } next }
{
  line = $0
  for (i = 1; i <= n; i++) {
    open_s = "[`" from[i] "`](" to[i]
    want   = "[`" to[i]   "`](" to[i]
    out = ""
    rest = line
    while ((at = index(rest, open_s)) > 0) {
      out = out substr(rest, 1, at - 1) want
      rest = substr(rest, at + length(open_s))
      hits++
    }
    line = out rest
  }
  print line
}
END { print hits + 0 > hitfile }
AWK

changed=0
subs=0
rederived=0
disagreed=0
while IFS= read -r page; do
  [ -n "$page" ] || continue
  awk -F'\t' -v page="$page" -v hitfile="$work/hits" -f "$work/sub.awk" "$work/roster.tsv" "./$page" > "$work/new" || {
    echo "verdict=awk_failed"; echo "refused: the substitution failed on $page" >&2; exit 1; }
  n=$(cat "$work/hits")
  subs=$((subs + n))
  if cmp -s "$work/new" "$page"; then
    [ "$mode" = dry ] && echo "unchanged: $page"
    continue
  fi
  changed=$((changed + 1))
  if [ "$mode" = dry ]; then
    echo "would-change: $page  substitutions=$n"
    continue
  fi
  # The mode a file carries is content the repository tracks, so the page is written back through
  # its own inode rather than moved over (.claude/rules/exec-bit.md).
  cat "$work/new" > "$page"
  # Proven immediately, against the committed bytes, on this same roster.
  if git show "HEAD:$page" > "$work/old" 2>/dev/null; then
    awk -F'\t' -v page="$page" -v hitfile="$work/hits" -f "$work/sub.awk" "$work/roster.tsv" "$work/old" > "$work/derived" || {
      echo "verdict=awk_failed"; exit 1; }
    if cmp -s "$work/derived" "$page"; then
      rederived=$((rederived + 1))
      echo "changed: $page  substitutions=$n  rederived=yes"
    else
      disagreed=$((disagreed + 1))
      echo "changed: $page  substitutions=$n  rederived=NO -- the working copy carried an edit beyond this rule"
    fi
  else
    disagreed=$((disagreed + 1))
    echo "changed: $page  substitutions=$n  rederived=NO -- untracked at HEAD, so nothing to derive from"
  fi
done < "$work/pages.txt"

echo "substitutions=$subs"
echo "changed=$changed"

if [ "$mode" = dry ]; then
  echo "verdict=ok"
  exit 0
fi

echo "rederived=$rederived"
echo "disagreed=$disagreed"
if [ "$disagreed" -gt 0 ]; then
  echo "verdict=not_derived"
  echo "refused: $disagreed page(s) do not re-derive from their committed bytes under this rule" >&2
  exit 1
fi
echo "verdict=derived"
