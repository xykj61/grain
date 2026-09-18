#!/bin/sh
# tools/fixtures/s/section_citation_scan.sh -- a section named beside a path is a promise too.
#
# WHY. This tree cites a place INSIDE another page constantly -- a law page sends a reader to
# `context/GAUGE_STYLE.md` -> *Quality assurance -- the report card*, the compass rose sends one to a
# named station of the operator card, a rule names a Lexicon row. Two standing guards already read
# links, and both of them read PATHS: tools/fixtures/t/tracked_link_scan.sh asks whether the target
# resolves in a fresh clone, and tools/fixtures/l/link_text_promise_scan.sh asks whether the visible
# anchor names the path it opens. The SECTION name is prose standing beside the path, so nothing in
# the tree has ever read it.
#
# THE ROAD IT ARRIVES BY, on this tree's own history rather than argued. The operator card molted on
# `20260912` and its sections were renamed. `foundations/20260826-024943_follow-our-compass.md` --
# the return habit a lap walks when direction frays -- still sends a reader to *Now -- the live
# front*, *The Compass Chapter* and *Next -- the ranked remainder*. Not one of those is a heading on
# `construction/ITINERARY.md` today, and every link on both lines opens. A reader who has lost
# direction is the reader most likely to walk that rose, and the rose names three rooms that are
# gone. Found by listening on the aether rota row: the silence where a claim used to be.
#
# WHAT A NAMED PLACE IS, in this tree's own writing. A `#` heading, or a table row whose FIRST cell
# is bold -- `| **calendar** | ...` in `context/LEXICON.md`. Both are places a reader is sent to by
# name, and a guard reading only headings would call every Lexicon citation stale.
#
# WHAT COUNTS AS A CITATION, and why the join decides it. Three joins are read:
#   `<path>` -> *Name*        an arrow, the tree's own "look inside here" mark
#   `<path>` section **Name** the word said out loud
#   [text](<path>) *Name*     a link close, then italic -- the compass rose's own shape
# A name opening with `(` is a parenthetical gloss rather than a section, and is read past.
#
# THE JOIN THIS SCAN DOES NOT GATE, named rather than hidden. A bare `--` join reads exactly like
# ordinary emphasis after a dash, and the tree writes far more of the second than the first.
# Measured on the seating lap over the same living pages: 21 dash-joined candidates, 10 naming a
# real place, 11 not -- and of those 11, two are genuine stale citations and nine are a writer
# emphasising a word. A gate at that rate would red on ordinary prose, which is a gate somebody
# turns off. So the dash join is COUNTED AND PRINTED, never gated, and `--dash` names each one for a
# person to read.
#
# WHAT IS GATED. Living pages, at ZERO once the founding pair is repaired.
#
# WHAT IS READ PAST, each for its own reason. Dated testimony -- a page whose own basename carries a
# one-clock stamp -- keeps every word it wrote (accrete-never-break), and a stale reference there is
# resolved rather than rewritten. The `date/`, `archive/` and `yonder/` shelves for the same reason.
# `gratitude/`, `vendor/` and `seed/` are held or projected rather than authored here. Every
# `fixtures/` path, so this scan's own control may plant a citation that must stay false.
#
# WHY A DATED PAGE A RULE ROOM CITES IS READ ANYWAY. The founding case lives in `foundations/` under
# a dated basename, and the law rooms send every lap to it by name. A page the law cites is canon
# whatever its basename says, so the roster is DERIVED from the rule rooms' own citations, the same
# way tools/fixtures/a/ascii_document_scan.sh derives its enforced set. A page the law stops citing
# falls out of the roster by an edit made elsewhere, so the two memberships are printed apart --
# `pages_plain` and `pages_derived` -- and a drop is legible rather than silent.
#
# USAGE
#   sh tools/fixtures/s/section_citation_scan.sh
#   sh tools/fixtures/s/section_citation_scan.sh --list     # name every gated hit
#   sh tools/fixtures/s/section_citation_scan.sh --dash     # name every ungated dash-joined candidate
#
# Driven by tools/s/section_citation_witness.rish. Run from the repository root.

set -eu

ceiling="${SECTION_CITATION_CEILING:-0}"
list=no
dash=no
case "${1:-}" in
  --list) list=yes ;;
  --dash) dash=yes ;;
  "") ;;
  *) echo "verdict=bad_flag"; echo "refused: unknown flag ${1} -- this scan takes --list or --dash" >&2; exit 1 ;;
esac

command -v git >/dev/null 2>&1 || { echo "verdict=no_git"; echo "refused: this scan reads the tracked tree, so it wants git" >&2; exit 1; }
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "verdict=no_repo"; echo "refused: run me from inside the repository" >&2; exit 1; }

work=$(mktemp -d) || { echo "verdict=no_pen"; exit 1; }
cleanup() { rm -rf "$work"; }
trap cleanup EXIT INT TERM HUP

# The derived roster: every dated basename a rule room names. A rule room is the only room whose
# citations are law, so a teaching room's links stay links.
: > "$work/derived.txt"
if [ -d .claude/rules ] || [ -d .cursor/rules ]; then
  git grep -ohE '[0-9]{8}-[0-9]{6}[A-Za-z0-9_.-]*\.(md|mdc)' -- .claude/rules .cursor/rules 2>/dev/null \
    | sort -u > "$work/derived.txt" || true
fi

plain=0
derived=0
: > "$work/pages.txt"
# MEMBERSHIP WITHOUT A PROCESS (`20260917.214610`). The loop below asked `grep -qxF` once per
# tracked page whether a basename stood in `derived.txt`, and that single line was 962 of the
# 1,015 processes this scan started. `derived.txt` is written above and never appended to inside
# the loop, so one read serves every iteration, and `case` answers whole-line membership in the
# shell itself. The wrapping newlines are what keep the match EXACT, the way `grep -x` was: a
# basename must not match a longer one that merely contains it.
NL='
'
derived_set=$NL$(cat "$work/derived.txt" 2>/dev/null)$NL

git ls-files '*.md' '*.mdc' > "$work/tracked.txt"
while IFS= read -r f; do
  case "$f" in
    */date/*|*/archive/*|*/yonder/*|gratitude/*|vendor/*|seed/*|*fixtures/*) continue ;;
  esac
  b=${f##*/}
  case "$b" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]*)
      case "$derived_set" in *"$NL$b$NL"*) ;; *) continue ;; esac
      derived=$((derived + 1)) ;;
    *) plain=$((plain + 1)) ;;
  esac
  printf '%s\n' "$f" >> "$work/pages.txt"
done < "$work/tracked.txt"

pages=$((plain + derived))
if [ "$pages" -eq 0 ]; then
  echo "pages=0"
  echo "verdict=no_pages"
  exit 1
fi

# One awk over every page, emitting page, line, cited path, cited name, join.
cat > "$work/read.awk" <<'AWK'
{
  rest = $0
  while (match(rest, /[A-Za-z0-9_.\/-]+\.(md|mdc)/)) {
    p = substr(rest, RSTART, RLENGTH)
    after = substr(rest, RSTART + RLENGTH)
    join = ""
    if (match(after, /^[`)]*[ ]*->[ ]*(section[ ]+)?\*+[^*]+\*+/)) join = "arrow"
    else if (match(after, /^[`)]*[ ]+section[ ]+\*+[^*]+\*+/)) join = "section"
    else if (match(after, /^\)[ ]+\*[^*]+\*/)) join = "link"
    else if (match(after, /^[`)]*[ ]*--[ ]*\*+[^*]+\*+/)) join = "dash"
    if (join != "") {
      seg = substr(after, RSTART, RLENGTH)
      n = seg
      sub(/^[^*]*\*+/, "", n)
      sub(/\*+$/, "", n)
      if (n !~ /^\(/ && n != "")
        printf "%s\t%d\t%s\t%s\t%s\n", FILENAME, FNR, p, n, join
    }
    rest = after
  }
}
AWK
: > "$work/hits.txt"
# xargs -a and -d are GNU extensions; the roster is fed on stdin, which every xargs reads.
#
# THE FAILURE IS NAMED RATHER THAN DISCARDED. This line ended in `|| true` from the lap it was
# written, so an awk pass that refused -- an unreadable page, a program error, an xargs that could
# not spawn -- left `hits.txt` empty and the scan answered `stale=0`, which is exactly what a clean
# tree prints. An empty answer from a broken instrument reads like a healthy one, and that is the
# whole subject of `tools/i/instrument_refusal_witness.rish`, which caught this one lap after the
# scan landed. A roster with no pages is a real and clean answer and skips the pass; any other
# refusal exits with its own verdict rather than a count.
if [ -s "$work/pages.txt" ]; then
  if ! xargs awk -f "$work/read.awk" < "$work/pages.txt" >> "$work/hits.txt" 2>"$work/read.err"; then
    echo "instrument=failed"
    echo "detail=citation_read_pass_refused"
    sed -n '1,5p' "$work/read.err" | sed 's/^/detail_awk=/'
    echo "verdict=misread"
    exit 1
  fi
fi

# Each hit is asked of the page it names: does that page carry a place by this name?
cat > "$work/match.awk" <<'AWK'
function norm(s) {
  gsub(/[`*_]/, "", s)
  gsub(/[ \t]+/, " ", s)
  sub(/^ /, "", s); sub(/ $/, "", s)
  sub(/[:.]$/, "", s)
  return tolower(s)
}
function hit(h,   r) {
  if (h == want) return 1
  # A citation naming the HEAD of a longer heading is honest: *Custody gates* for
  # "Custody gates -- an autonomous agent STOPS here and surfaces".
  if (index(h, want) == 1) { r = substr(h, length(want) + 1); if (r ~ /^([ ]|--|,)/) return 1 }
  return 0
}
BEGIN { want = norm(WANT); found = 0 }
/^#+[ ]/ { h = $0; sub(/^#+[ ]*/, "", h); if (hit(norm(h))) { found = 1; exit } }
/^\|[ ]*\*\*/ { h = $0; sub(/^\|[ ]*/, "", h); sub(/[ ]*\|.*$/, "", h); if (hit(norm(h))) { found = 1; exit } }
END { exit(found ? 0 : 1) }
AWK

gated=0
gated_stale=0
dash_seen=0
dash_unmatched=0
unresolved=0
: > "$work/stale.txt"
: > "$work/dash.txt"
while IFS="$(printf '\t')" read -r f ln p name join; do
  [ -n "${f:-}" ] || continue
  d=${f%/*}
  [ "$d" != "$f" ] || d="."
  target="$d/$p"
  [ -f "$target" ] || target="$p"
  if [ ! -f "$target" ]; then
    # A link that opens nowhere belongs to tools/fixtures/t/tracked_link_scan.sh, not here.
    unresolved=$((unresolved + 1))
    continue
  fi
  if awk -v WANT="$name" -f "$work/match.awk" "$target"; then
    matched=yes
  else
    matched=no
  fi
  if [ "$join" = dash ]; then
    dash_seen=$((dash_seen + 1))
    if [ "$matched" = no ]; then
      dash_unmatched=$((dash_unmatched + 1))
      printf '%s:%s -- %s names no place called "%s"\n' "$f" "$ln" "$p" "$name" >> "$work/dash.txt"
    fi
  else
    gated=$((gated + 1))
    if [ "$matched" = no ]; then
      gated_stale=$((gated_stale + 1))
      printf '%s:%s -> %s names no place called "%s" (join %s)\n' "$f" "$ln" "$p" "$name" "$join" >> "$work/stale.txt"
    fi
  fi
done < "$work/hits.txt"

if [ "$list" = yes ]; then
  if [ "$gated_stale" -gt 0 ]; then cat "$work/stale.txt"; else echo "no gated hit stands"; fi
fi
if [ "$dash" = yes ]; then
  if [ "$dash_unmatched" -gt 0 ]; then cat "$work/dash.txt"; else echo "no dash-joined candidate stands unmatched"; fi
fi

echo "pages=$pages"
echo "pages_plain=$plain"
echo "pages_derived=$derived"
echo "citations=$gated"
echo "stale=$gated_stale"
echo "unresolved=$unresolved"
echo "dash_candidates=$dash_seen"
echo "dash_unmatched=$dash_unmatched"
echo "ceiling=$ceiling"
if [ "$gated_stale" -gt "$ceiling" ]; then
  echo "verdict=over_ceiling"
  exit 1
fi
echo "verdict=ok"
