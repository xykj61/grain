#!/bin/sh
# tools/fixtures/o/one_title_scan.sh -- does every living page carry exactly one title?
#
# WHY THIS EXISTS. `context/TAME_GUIDANCE.md`'s lint table stood under the heading **Enforced
# now** until `20260912`, and one of its rows reads *One `# Title` per markdown -- flag any `.md` with zero or more
# than one top-level `#`, fenced code ignored*. Nothing in this tree flagged one. The rule was
# written with no instrument named beside it, and the one page that mentions the duty --
# `tools/fixtures/r/radiant_lint_scan.sh`, duty 3 -- prints `deferred (TAME one-# Title /
# tame-check owns it)`, while `tools/t/tame-check.rish` and its scan spell no heading at all.
# Two pages each pointing at the other is a promise standing on nobody, and a reader meeting
# that heading had no way to tell that row from the nineteen beside it that a guard really holds.
#
# Found on an aether lap `20260911` -- the row that hears, listening for the page nobody answered.
#
# WHY THE RULE IS WORTH AN INSTRUMENT AT ALL. A page's single top-level heading is its name. Two
# titles means two documents sharing a file, which breaks every reader that takes the first `# `
# as the page's subject -- a table of contents, a link preview, an agent skimming a room. Zero
# titles means a page that cannot say what it is. Neither is caught by anything else here:
# `tools/m/markdown_structure_witness.rish` compares headings BEFORE and AFTER a style pass, so it
# holds a pass honest and says nothing about a page written wrong in the first place.
#
# WHAT COUNTS AS A TITLE, and why three forms rather than one.
#   - `# Text` at the head of a line, outside a fenced block. The Markdown form.
#   - `<h1 ...>` anywhere outside a fence. The tree's own front door is this shape: `README.md`
#     centers its title as HTML, so a reader sees one title and a naive `^# ` count reads ZERO.
#     A meter that called the most-read page in the tree a violation would be turned off the
#     first day, and rightly.
#   - Inline code is masked before either test, since a page that writes ABOUT titles names both
#     forms in backticks -- as `context/TAME_GUIDANCE.md`'s own lint row and this guard's own
#     sentence about the front door both do.
#   - A fence opens on ``` or ~~~ and everything inside it is program text. The discrimination is
#     already proven in this tree: `tools/fixtures/c/census_control_h1_fenced.md` plants one true
#     title with three decoys inside a fence, and its seam reads `duty1_h1_true=1 duty1_h1_naive=4`.
#     This scan makes the same distinction over the whole corpus.
#
# WHAT IT READS, and what it reads past. Tracked `*.md`, minus five classes, each for a reason
# the tree already states somewhere else:
#   - a dated basename (`YYYYMMDD-HHMMSS_sprig.md`) is TESTIMONY; accrete-never-break forbids
#     repairing it, so counting it would gate a number no lap may lower (REDS %626's shape).
#   - `date/`, `archive/` and `yonder/` shelves are the same testimony by room.
#   - `gratitude/`, `vendor/`, `seed/` and `research-silo/` hold text that is not ours to edit.
#   - a `fixtures/` path may PLANT a violation on purpose -- including the fenced-decoy control
#     this scan borrows its method from, which must keep its four naive titles or prove nothing.
#
# THE READINGS.
#   pages          living tracked pages read
#   titled         pages carrying exactly one title
#   no_title       pages carrying none
#   many_titles    pages carrying two or more
#   outside        no_title + many_titles                 RATCHET, ceiling only falls
#
# THE TWO FAULT KEYS ARE NAMED SO NO OTHER KEY ENDS IN ONE. `untitled=0` holds `titled=0` as a
# substring, so a reader asserting the population is non-empty would match the wrong line and read
# a healthy tree as a broken instrument -- the shape REDS %310 booked one room over. A key is a
# word a reader greps for, so it earns a spelling nothing else contains.
#
# WHY A RATCHET AT ONE RATHER THAN A WALL AT ZERO. Measured `20260911` over 390 living pages:
# 389 carry exactly one title and ONE carries two -- `classical-vedic-astrology/templates/
# reading-template.md`, a template in another lane's room, where two titles may well be the point.
# Editing a peer's room to make a number pretty is the opposite of what a ceiling is for. One of
# slack, published at exactly what was measured, so the second page outside the rule reds on the
# lap it lands; it falls when that template's own lane rules on it.
#
# WHAT IT DOES NOT REACH. Whether the title a page carries is a GOOD name for it, and whether a
# heading hierarchy below the title is sane. It asks one question with one answer per page.
#
#   sh tools/fixtures/o/one_title_scan.sh [--list]

set -u
LC_ALL=C
export LC_ALL

OUTSIDE_CEILING=${ONE_TITLE_CEILING:-1}
CORPUS=${ONE_TITLE_CORPUS:-}

# Root by upward walk -- the letter fold moves this script's depth, so fixed `../..` arithmetic
# breaks. Skipped entirely when a corpus is handed in: a control's pen is a directory of pages
# rather than a tree, and asking it for a root would refuse the one caller needing no root.
if [ -z "$CORPUS" ]; then
  ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
  _ot_steps=0
  while [ ! -d "$ROOT/tools/fixtures" ] || [ ! -d "$ROOT/.git" ]; do
    _ot_steps=$((_ot_steps + 1))
    if [ "$_ot_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
      echo "$0: no tree root within 8 steps (needs tools/fixtures and .git)" >&2
      exit 2
    fi
    ROOT=$(dirname "$ROOT")
  done
  cd "$ROOT" || exit 2
fi

list=no
[ "${1:-}" = "--list" ] && list=yes

pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT INT TERM

if [ -n "$CORPUS" ]; then
  # Into the pen, so a pen path reads exactly like a tree path. The four room names below are
  # anchored at the ROOT on purpose -- `recursion-prompts/seed/` holds three living pages and is
  # not the public seed, so a `(^|/)seed/` anchor would drop them from the population in silence.
  # A pen whose paths were absolute could never prove that anchor either way.
  cd "$CORPUS" || exit 2
  find . -name '*.md' -type f | sed 's|^\./||' | sort > "$pen/all.txt"
else
  # The tracked listing is the oracle rather than the filesystem. A page present on this machine
  # and absent from the repository is not a page anybody else receives -- and one checkout's
  # ignored scratch is not a fault eight ships can see (the `.lap/` reading of `20260911`).
  if ! git ls-files -- '*.md' > "$pen/tracked_raw.txt"; then
    echo "pages=0"
    echo "verdict=listing_refused"
    echo "detail: the tracked listing refused, and a broken instrument reads exactly like a clean tree"
    exit 1
  fi
  sort "$pen/tracked_raw.txt" > "$pen/all.txt"
fi

grep -vE '^(gratitude|vendor|seed|research-silo)/' "$pen/all.txt" \
  | grep -vE '(^|/)(date|archive|yonder)/' \
  | grep -vE '(^|/)fixtures?/' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' > "$pen/files.txt" || true
pages=$(wc -l < "$pen/files.txt" | tr -d ' ')

if [ "$pages" -eq 0 ]; then
  echo "pages=0"
  echo "verdict=no_corpus"
  echo "detail: the walk found no living page at all -- the meter has lost its subject, which reads exactly like a tree with nothing to count"
  exit 1
fi

# ONE PASS over the corpus, one line out per page: `<count>\t<path>`.
# `tr` and `xargs -0` rather than `xargs -a`: the arg-file flag is GNU-only and this fleet has a
# Mac door, where a guard reading zero files would read as a clean tree (`shell_dialect`).
tr '\n' '\0' < "$pen/files.txt" | xargs -0 awk '
  FNR == 1 { flush(); fence = 0; n = 0; prevfile = FILENAME }
  /^[ \t]*(```|~~~)/ { fence = 1 - fence; next }
  fence == 1 { next }
  {
    # INLINE CODE IS MASKED BEFORE EITHER TEST. A page that WRITES ABOUT titles mentions both
    # forms in backticks, and this very tree does: the lint row reading `# Title` and the sentence
    # explaining that `README.md` centers its own title as `<h1>`. Counting a mention as a title
    # made the two pages this guard was built for read as violations on its first live run.
    masked = $0
    while (match(masked, /`[^`]*`/)) {
      masked = substr(masked, 1, RSTART - 1) substr(masked, RSTART + RLENGTH)
    }
  }
  masked ~ /^# / { n++; next }
  masked ~ /<[hH]1[ >]/ { n++ }
  function flush() { if (prevfile != "") print n "\t" prevfile }
  END { flush() }
' > "$pen/counts.txt"

read_pages=$(wc -l < "$pen/counts.txt" | tr -d ' ')
titled=$(awk -F'\t' '$1 == 1' "$pen/counts.txt" | wc -l | tr -d ' ')
awk -F'\t' '$1 == 0' "$pen/counts.txt" > "$pen/untitled.txt"
awk -F'\t' '$1 > 1' "$pen/counts.txt" > "$pen/multi.txt"
no_title=$(wc -l < "$pen/untitled.txt" | tr -d ' ')
many_titles=$(wc -l < "$pen/multi.txt" | tr -d ' ')
outside=$((no_title + many_titles))

# THE WALK MUST HAVE REACHED EVERY PAGE IT LISTED. A reader that stopped early reports a smaller
# `outside` and reads as a cleaner tree, which is the one failure a ratchet cannot catch.
verdict=ok
if [ "$read_pages" -ne "$pages" ]; then
  verdict=walk_short
elif [ "$outside" -gt "$OUTSIDE_CEILING" ]; then
  verdict=outside_over_ceiling
fi

echo "pages=$pages"
echo "read_pages=$read_pages"
echo "titled=$titled"
echo "no_title=$no_title"
echo "many_titles=$many_titles"
echo "outside=$outside"
echo "outside_ceiling=$OUTSIDE_CEILING"
echo "verdict=$verdict"

if [ "$list" = yes ]; then
  echo "outside_list:"
  while IFS="$(printf '\t')" read -r n f; do
    [ -n "$f" ] && echo "  titles=$n $f"
  done < "$pen/untitled.txt"
  while IFS="$(printf '\t')" read -r n f; do
    [ -n "$f" ] && echo "  titles=$n $f"
  done < "$pen/multi.txt"
fi

[ "$verdict" = ok ] || exit 1
exit 0
