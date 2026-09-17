#!/bin/sh
# tools/fixtures/l/living_pin_fence_scan.sh -- a page's fences close, or the rest of it is code.
#
# WHY. Every guard standing over a living pin in this tree reads its BYTES. `ascii_document` counts
# characters, `tracked_link` and `link_text_promise` read links, the pin bound counts length,
# `nib_honesty` reads one key. Not one of them reads the page as MARKDOWN, so a page whose markup
# has broken renders wrongly for every reader while the whole roster stays green.
#
# THE FIRING, measured rather than argued. On `20260916` at 21:39 commit 99d4948e6 wrapped a
# sentence in construction/ITINERARY.md so a bare triple-backtick fence opener landed at column 0 in
# prose -- the author was naming a fence, not opening one. CommonMark reads a line beginning with
# three backticks as an opening code fence, and states that when no closing fence is found the block
# runs to the end of the document. So 30,791 of that card's 38,970 bytes, 79 percent, rendered as
# one code block for every markdown reader, GitHub included: the whole INNER LOOP every ship reads
# at each lap open, the product direction, and all eight ships' accounts. Every standing guard was
# green throughout, and the card's own bound, register, link and character readings all passed,
# because each of them was reading bytes that had not changed.
#
# WHAT IS READ. A code fence by CommonMark's own rule: three or more backticks or tildes, indented
# at most three spaces, at the start of a line. A fence is closed by one of the SAME character, at
# least as long, carrying nothing after it but whitespace -- so a tilde fence inside a backtick
# block is content rather than a closer. A backtick opener's info string may hold no backtick, which
# is what keeps an ordinary inline `code span` from reading as a fence.
#
# WHAT IS GATED. Living pages, at ZERO. Measured on the seating lap across 399 living tracked
# markdown pages: exactly one unbalanced fence stood in the tree, and it was the firing above. A
# population already at zero earns a wall rather than a ratchet -- the next unclosed fence reds on
# the lap it arrives, which is the whole point of building this after a fault rather than before.
#
# WHAT IS REPORTED, never gated. The same reading across dated testimony -- a page whose own
# basename carries a one-clock stamp, and every date/, archive/ or yonder/ shelf. Accrete-never-break:
# testimony keeps every word it wrote, so a broken fence there is a fact about that day rather than
# a fault a lap may repair.
#
# WHAT THIS DOES NOT REACH, named rather than left to be discovered. A fence indented four or more
# spaces -- inside a list item or a blockquote -- is not read as a fence here, because telling that
# case from an indented code block wants a block-structure parser rather than a line reader. When
# BOTH the opener and the closer are indented that far the page reads balanced and this scan is
# silent, which is an undercount in the safe direction. When only the closer is, the reading names
# a line a person can look at, so a rare false reading costs one glance rather than a wrong repair.
#
# WHAT IT COUNTS AND STEPS PAST. `unread_paths` is a path the index carries and the working tree
# lacks -- a staged deletion mid-lap. It is reported rather than gated, since an absent file holds
# no fence either way, and handing one to awk exits 2 and takes the whole reading with it.
#
# USAGE
#   sh tools/fixtures/l/living_pin_fence_scan.sh
#   sh tools/fixtures/l/living_pin_fence_scan.sh --list    # name every page and its opening line
#
# Driven by tools/l/living_pin_fence_witness.rish. Run from the repository root.

set -eu

ceiling="${LIVING_PIN_FENCE_CEILING:-0}"
list=no
case "${1:-}" in
  --list) list=yes ;;
  "") ;;
  *) echo "verdict=bad_flag"; echo "refused: unknown flag ${1} -- this scan takes --list" >&2; exit 1 ;;
esac

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: run me from inside the repository" >&2; exit 1; }

# A page is TESTIMONY when its own basename carries a one-clock stamp, or when it sits on a date/,
# archive/ or yonder/ shelf -- the split .claude/rules/stamp-and-name.md already draws. Vendored and
# projected rooms are other people's bytes; a fixtures/ path is planted input and must be free to
# hold a broken fence, or a control proving this reading could not plant one.
# A page name may hold a space -- this tree carries one -- so every list below is NEWLINE
# delimited and every walk sets IFS to a newline alone. A word-split list drops such a page from
# the reading in silence, which is the failure a gate can least afford.
NL=$(printf '\nx'); NL=${NL%x}
pages=$(git ls-files -- '*.md' '*.mdc' | sort -u)

living=""
dated=""
OIFS=$IFS
IFS=$NL
for f in $pages; do
  IFS=$OIFS
  case "$f" in
    gratitude/*|vendor/*|seed/*|*/fixtures/*|fixtures/*) IFS=$NL; continue ;;
  esac
  case "$f" in
    */date/*|*/archive/*|*/yonder/*|date/*|archive/*|yonder/*)
      dated="$dated$f$NL"; IFS=$NL; continue ;;
  esac
  base=${f##*/}
  case "$base" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]*)
      dated="$dated$f$NL"; IFS=$NL; continue ;;
  esac
  living="$living$f$NL"
  IFS=$NL
done
IFS=$OIFS

read_fences() {
  # One file per invocation keeps the reading honest: awk's FNR==1 rule runs with FILENAME already
  # advanced to the next file, so a multi-file walk reports the previous page's fault under the next
  # page's name. That misreading was live in this reading's own first draft.
  OIFS=$IFS
  IFS=$NL
  for f in $1; do
    IFS=$OIFS
    # A path the index carries and the working tree lacks is stepped past rather than handed to
    # awk, which would exit 2 and take the whole reading with it. It is COUNTED in the main shell
    # above, never here: a command substitution is a subshell, so a counter incremented inside this
    # function never reaches the caller. That is how the first draft reported zero absent paths on
    # the very lap whose staged deletion had killed it.
    if [ ! -f "$f" ]; then IFS=$NL; continue; fi
    # `awk ... file` with a bare name holding an equals sign is read as a VARIABLE ASSIGNMENT
    # rather than a file; a leading ./ defeats that reading, and only a root-level page could
    # ever meet it.
    awk -v page="$f" '
      {
        line = $0; sub(/\r$/, "", line)
        if (match(line, /^ {0,3}(`{3,}|~{3,})/)) {
          marker = substr(line, RSTART, RLENGTH); sub(/^ +/, "", marker)
          ch = substr(marker, 1, 1); len = length(marker)
          rest = substr(line, RSTART + RLENGTH)
          if (openline == 0) {
            if (ch == "`" && index(rest, "`") > 0) next
            openline = FNR; ochar = ch; olen = len
          } else if (ch == ochar && len >= olen && rest ~ /^[[:space:]]*$/) {
            openline = 0
          }
        }
      }
      END { if (openline > 0) printf "%s open_line=%d fence=%s%d\n", page, openline, ochar, olen }
    ' "./$f"
    IFS=$NL
  done
  IFS=$OIFS
}

unread=0
OIFS=$IFS
IFS=$NL
for f in $living$dated; do
  IFS=$OIFS
  [ -f "$f" ] || unread=$((unread + 1))
  IFS=$NL
done
IFS=$OIFS

living_hits=$(read_fences "$living")
dated_hits=$(read_fences "$dated")

living_count=$(printf '%s\n' "$living_hits" | grep -c . || true)
dated_count=$(printf '%s\n' "$dated_hits" | grep -c . || true)
living_pages=$(printf '%s' "$living" | grep -c . || true)
dated_pages=$(printf '%s' "$dated" | grep -c . || true)

if [ "$list" = yes ]; then
  [ -n "$living_hits" ] && printf 'living %s\n' "$living_hits"
  [ -n "$dated_hits" ] && printf 'testimony %s\n' "$dated_hits"
fi

echo "living_pages=$living_pages"
echo "dated_pages=$dated_pages"
echo "unbalanced_living=$living_count"
echo "unbalanced_dated=$dated_count"
echo "unread_paths=$unread"
echo "ceiling=$ceiling"

if [ "$living_count" -gt "$ceiling" ]; then
  echo "verdict=over_ceiling"
  echo "refused: $living_count living pages hold an unclosed code fence, against a ceiling of $ceiling" >&2
  echo "         run with --list to name them; everything after the named line renders as code" >&2
  exit 1
fi
echo "verdict=ok"
