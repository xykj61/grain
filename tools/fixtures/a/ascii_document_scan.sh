#!/bin/sh
# tools/fixtures/a/ascii_document_scan.sh -- non-ASCII characters in living DOCUMENTS.
#
# WHY. `.claude/rules/ascii-first.md` names three subjects: "every new document, code comment, and
# commit message". Two of the three were measured over their whole subject and one was not.
#
#   comments        -- tools/fixtures/r/rye_comment_ascii_scan.sh and
#                      tools/fixtures/s/shell_comment_ascii_scan.sh, over every tracked source
#   commit messages -- no meter, and none is wanted today: measured `20260906.131411`, 0 of the
#                      last 400 commit bodies carry a byte above 0x7F, so the habit holds there
#                      without a wall, and a wall built where nothing is failing teaches nothing
#   documents       -- tools/fixtures/l/living_card_ascii_scan.sh, which reads TWO pins hard and
#                      six as advisory: EIGHT files of 5,529 tracked `.md`
#
# The subject the law names FIRST had the narrowest meter, and the gap sat exactly where it costs
# most. Measured `20260906.131411`: 63 of the 104 rule pages an editor reads as law -- the pages
# that carry the ASCII-first law itself -- held 859 non-ASCII characters, and every one of them was
# a form the rule's own substitution table spells. A law is not kept by the room that writes it.
#
# WHAT IT READS.
#
#   ENFORCE   `.claude/rules/*.md` and `.cursor/rules/*.mdc`, PLUS every living tracked page those
#             rooms name as canon. Zero characters above 0x7F, hard. The rule pages are read as law
#             by whichever editor is driving, so a rule page is the one document whose own bytes
#             are an argument about the rule -- and a page the law tells a reader to read first is
#             load-bearing in exactly the same way. Reported as `enforce_globbed` and
#             `enforce_derived` so a page leaving the wall is visible; see THE DERIVED CANON below.
#   RATCHET   every other LIVING tracked `.md` and `.mdc`, under a ceiling that only ever falls.
#
# WHAT THE RATCHET LEAVES OUT, and the reason for each, since a meter that cannot say why it
# skipped something is a meter nobody can check:
#
#   * a basename carrying a one-clock stamp (`YYYYMMDD-HHMMSS`) -- testimony by the mark law
#     (`.claude/rules/stamp-and-name.md`). Accrete-never-break: dated writing is never rewritten to
#     retrofit a law seated after it, and ASCII-first says so in its own words.
#   * `date/`, `archive/`, `yonder/` -- folded shelves and closed stacks. A day shelf is immutable
#     once its day closes (`.claude/rules/session-logs.md`), so counting one as debt would price a
#     repair the law forbids. Its own basename is often unstamped, which is why the path is read
#     as well as the name.
#   * `gratitude/`, `vendor/`, `seed/` -- third-party sources held unmodified, and the public
#     projection of this tree rather than the tree.
#   * any `fixtures/` path -- planted controls. `tools/fixtures/living_card_ascii_control/` MUST
#     stay non-ASCII or its own `prove-red` leg stops proving anything.
#
# THE UNIT IS A CHARACTER, counted by its UTF-8 lead byte under `LC_ALL=C` with the octal class
# `[\300-\377]`. Both halves of that sentence were paid for by the sibling meters: "this awk reads
# UTF-8" is true only of GNU awk, so one em dash read 3 on one bench and 1 on another; and `\x00`
# hex classes are a GNU awk extension that the BWK awk macOS ships reads as literal characters, so
# a negated class matches every character and a whole line counts as non-ASCII. Every non-ASCII
# character carries exactly one lead byte in `\300-\377`, so this counts characters under both.
#
# THE SPLIT, reported beside the total. `named` counts the forms the rule's own substitution table
# spells -- em dash, en dash, middle dot, curly quotes, arrows, ellipsis, and the three comparison
# signs -- which a program may convert mechanically. `unnamed` counts notation the table does not
# name: a section sign, a Greek letter, a superscript, a check mark. Those carry a meaning a reader
# should choose the ASCII form for, rather than a script guessing it. The ceiling gates the TOTAL,
# so the split cannot be gamed by reclassifying; it is there so a lap can see which part is work
# it can do and which part is a question it must ask.
#
# USAGE
#   sh tools/fixtures/a/ascii_document_scan.sh                 # census -- key=value lines
#   sh tools/fixtures/a/ascii_document_scan.sh --list          # ratchet files, worst first
#   sh tools/fixtures/a/ascii_document_scan.sh --enforce-list  # enforced files still dirty
#
# Run from the repository root, or from any git work tree (the control runs it inside a pen).
set -u

mode="${1:-census}"

# The ceiling only falls. Lower it whenever a lap converts a document; never raise it.
#   3956  `20260906.131411`  across 92 of 347 living pages, the reading this meter was seated on
#   3331  `20260908.052550`  after the five pages the ENFORCE rooms NAME as their canon were swept
#   3232  `20260909.220333`  the law-cited canon left the ratchet for the gate below -- 99
#                            characters across two living pins, swept rather than carried. The
#                            reading fell 3324 -> 3225; the ceiling keeps the 7 of slack it already
#                            stood on and takes none of the 99, so this lap is credited with
#                            nothing it did not repair.
#   2780  `20260910.043000`  the compressor shelf joined the wall below -- 452 characters across 12
#                            of its 15 pages, 450 of them forms the rule's own table spells and 2
#                            read by hand. The reading fell 3225 -> 2773; the ceiling keeps the same
#                            7 of slack and takes none of the 452.
#   1343  `20260910.042550`  one page held 1,437 of the 2,773 -- 52 percent of the whole remaining
#                            ratchet in `rye-learning-process/GLOW_ALMANAC.md`, and 1,350 of those
#                            were a single form: the middle dot the rule's table has always spelled.
#                            1,434 converted by the table, 1 by the row this lap added below, and 3
#                            read by hand. The reading fell 2773 -> 1336; the ceiling keeps the same
#                            7 of slack and takes none of the 1,437.
#   1307  `20260910.054344`  `bat/README.md`, a front door outside every roster, held 36 -- 21
#                            middots and 15 em dashes, every one a form the table spells. The page
#                            was walled by nothing: no rule room cites it and it stands outside
#                            `docs/`. The reading fell 1336 -> 1300; the ceiling keeps the same
#                            7 of slack and takes none of the 36.
#    770  `20260910.061813`  the front doors, read as one class rather than one page at a time: 573
#                            characters across 26 living `README.md` pages -- 43 percent of the
#                            remaining 1,336, on the pages a newcomer meets first. 564 converted by
#                            the table and re-derived from committed bytes, 9 read by hand, every
#                            one taking a spelling the tree had already written elsewhere. The
#                            reading fell 1336 -> 763; the ceiling keeps the same 7 of slack and
#                            takes none of the 573.
CEILING="${ASCII_DOC_CEILING:-750}"

# THE ROSTERS ARE GLOBS RATHER THAN A LIST OF NAMES. A rule page added tomorrow is governed the day
# it lands, where a name list would let it in unmeasured until somebody remembered to type it.
#
# THE WALL AND THE SEED ARE TWO ROSTERS, and they were one until `20260910.043000`. The wall names
# who is HELD at zero. The seed names whose citations are CANON, which is a claim about law: a rule
# room tells a reader which page to read first, and that page is held to the rule. A teaching room's
# links are links. So `docs/` -- the compressor shelf a newcomer is sent to by `MAP.md` -- joins the
# wall on its own account and seeds nothing, and the derived roster keeps meaning what it said.
ENFORCE_GLOBS="${ASCII_DOC_ENFORCE_GLOBS:-.claude/rules/*.md .cursor/rules/*.mdc docs/*.md}"
DERIVE_GLOBS="${ASCII_DOC_DERIVE_GLOBS:-.claude/rules/*.md .cursor/rules/*.mdc}"

# A GUARD THAT CANNOT RUN ITS INSTRUMENT MUST SAY SO. An empty answer from a failed `git ls-files`
# is byte-identical to an empty answer from a clean tree, and the second is what everyone hopes to
# read. `%473` one guard over: exit 1 is *no match*, 2 or more is *could not run*, and `|| :`
# reads them alike.
LISTFILE=$(mktemp "${TMPDIR:-/tmp}/ascii-doc.XXXXXX") || {
  echo "instrument=failed"
  echo "detail=mktemp_refused"
  echo "verdict=misread"
  exit 1
}
trap 'rm -f "$LISTFILE"' EXIT INT TERM
# THE LISTING GOES THROUGH A FILE AND A `read -r` LOOP, never through word splitting on a
# variable. This tree holds a tracked document whose path carries a space --
# `expanding-prompts/yonder/cursor-prompt_reorg-chunk-3_external-research (1).md` -- and a
# `for f in $LIST` would read it as two paths, skip one and count the other absent. A NUL-delimited
# read is unavailable in POSIX `read`, so the line-delimited form is used and git's own quoting of
# an embedded newline is detected below rather than trusted away.
if ! git ls-files -- '*.md' '*.mdc' > "$LISTFILE" 2>/dev/null; then
  echo "instrument=failed"
  echo "detail=git_ls_files_refused"
  echo "verdict=misread"
  exit 1
fi
if [ ! -s "$LISTFILE" ]; then
  echo "instrument=failed"
  echo "detail=no_tracked_documents"
  echo "verdict=misread"
  exit 1
fi

# --- THE WALLED SET, enumerated ONCE ------------------------------------------------------------
#
# THREE READERS ASK WHETHER A PAGE IS WALLED, and until `20260910.043000` each answered by TYPING
# the roster again: the enforce loop expanded the globs, the derived roster skipped
# `.claude/rules/*|.cursor/rules/*`, and the ratchet skipped `.claude/rules/*.md|.cursor/rules/*.mdc`.
# Three spellings of one fact, correct only while the roster never changed -- and this roster's own
# arc is to widen. Measured on the lap that widened it: adding one glob made `docs/ZETA.md` appear
# in BOTH rosters, so its 43 characters were counted twice and `enforce_files` read one page too
# many. A ratchet skip left behind the same way would price a character twice in the other
# direction, letting a ceiling fall for a repair the gate had already required.
#
# THE SET IS BUILT FROM THE TRACKED LISTING, never from pathname expansion, and each of the three
# reasons was paid for by a sibling reading of this same family:
#
#   A `case` pattern's `*` crosses a slash where pathname expansion's does not, so
#   `case "$f" in docs/*.md)` calls `docs/redacted/a-note.md` walled while `for f in docs/*.md`
#   never reaches it -- a page dropped from the ratchet and held by nothing. So a glob is split at
#   its last slash and the two halves are asked separately: the directory by equality, the basename
#   by pattern. `*` then cannot cross a slash, because no slash is left for it to cross.
#
#   `for f in $g` SPLITS ON SPACES. This tree carries a tracked document whose path holds one, and
#   the pen has proven that shape since the ratchet was seated -- read as two words, one skipped and
#   one counted absent. Reading the listing a line at a time is the same repair the ratchet already
#   made.
#
#   TRACKED IS THE TEST, as it is for the derived roster: only a page this repository carries can be
#   held to anything, and an untracked draft left in a walled room is nobody's fault yet.
#
# AND A WALLED ROOM MAY HOLD TESTIMONY. Accrete-never-break outranks the wall: a dated basename and
# a closed-stack shelf are read past here exactly as the ratchet and the derived roster read them
# past, so no gate can ever price a repair the one-clock law forbids. This mattered the day `docs/`
# joined, since a compressor shelf may hold a dated page where a rule room never does.
walled_list=$(mktemp "${TMPDIR:-/tmp}/ascii-doc-walled.XXXXXX") || {
  echo "instrument=failed"
  echo "detail=mktemp_refused"
  echo "verdict=misread"
  exit 1
}
trap 'rm -f "$LISTFILE" "$walled_list"' EXIT INT TERM
set -f                                   # the globs are patterns to compare, never paths to expand
while IFS= read -r f; do
  [ -n "$f" ] || continue
  case "$f" in '"'*) continue ;; esac     # a git-quoted path; the ratchet counts and names these
  case "$f" in
    gratitude/*|vendor/*|seed/*) continue ;;
    */fixtures/*|fixtures/*|*/fixture/*) continue ;;
    date/*|*/date/*|archive/*|*/archive/*|yonder/*|*/yonder/*) continue ;;
  esac
  b=${f##*/}
  case "$b" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*) continue ;;
  esac
  fdir=${f%/*}; [ "$fdir" = "$f" ] && fdir=.
  for g in $ENFORCE_GLOBS; do
    gdir=${g%/*}; [ "$gdir" = "$g" ] && gdir=.
    [ "$fdir" = "$gdir" ] || continue
    case "$b" in ${g##*/}) echo "$f"; break ;; esac
  done
done < "$LISTFILE" | sort -u > "$walled_list"
set +f

# Answer the one question all three readers ask, from the one enumeration above.
walled() { grep -qxF "$1" "$walled_list"; }

# Count non-ASCII characters in one file, split named/unnamed, printed as "total named unnamed".
# ABSENT IS SKIPPED AND COUNTED, never fatal: `git ls-files` reads the INDEX, and a rename staged
# mid-lap lists a path the working tree no longer holds. A sibling scan died `fatal: cannot open
# file` on exactly that during a rebase, which is the one moment a reading is worth having.
count_file() {
  # The named table lives in an associative array built once in BEGIN, rather than in a chain of
  # comparisons. Two reasons, and the second was paid for on this lap: a table reads as a table, and
  # awk will not accept a comment between a trailing `||` and the newline that continues the
  # statement -- the first draft carried one per row, awk refused the whole program, and the scan
  # answered a clean zero for every file in the tree. That is this meter's own subject turned back
  # on itself, so the awk exit status is checked below rather than discarded.
  LC_ALL=C awk '
    BEGIN {
      tot = 0; named = 0
      t["\342\200\224"] = 1   # em dash
      t["\342\200\223"] = 1   # en dash
      t["\342\200\230"] = 1   # left single quote
      t["\342\200\231"] = 1   # right single quote
      t["\342\200\234"] = 1   # left double quote
      t["\342\200\235"] = 1   # right double quote
      t["\342\200\246"] = 1   # ellipsis
      t["\342\206\222"] = 1   # right arrow
      t["\342\206\220"] = 1   # left arrow
      t["\342\206\224"] = 1   # left-right arrow
      t["\342\207\222"] = 1   # rightwards double arrow
      t["\342\211\240"] = 1   # not equal
      t["\342\211\244"] = 1   # less-than or equal
      t["\342\211\245"] = 1   # greater-than or equal
      t["\342\210\222"] = 1   # typographic minus -- one ASCII spelling, and the rule names it
      two["\302\267"] = 1     # middle dot, a two-byte sequence
    }
    {
      s = $0
      n = length(s)
      for (i = 1; i <= n; i++) {
        c = substr(s, i, 1)
        if (c !~ /[\300-\377]/) continue
        tot++
        if (two[substr(s, i, 2)]) { named++; continue }
        if (t[substr(s, i, 3)]) named++
      }
    }
    END { printf "%d %d %d\n", tot, named, tot - named }
  ' "$1"
}

# --- THE DERIVED CANON: the pages the law itself names ------------------------------------------
#
# THE WALL IS A GLOB AND THE LAW IS A GRAPH, which is the same fault this meter was built to
# catch, one room further out. A rule page is walled because an editor reads it as law; the page
# that rule tells a reader to READ FIRST was walled by nothing. Measured `20260908.052550`:
# `tame-guidance.md` stood at zero while `context/TAME_CORE.md`, the page it names as its
# compressed core, held 51 characters, and `CLAUDE.md` -- the root file that loads every rule --
# held 38. A hand swept five such pages to zero that lap and left the roster at two globs, so
# what held them there afterward was ratchet slack: 7 characters on `20260909.220333`, which is
# to say one em dash in `context/RADIANT_STYLE.md` reddened nothing and eight of them reddened a
# total naming no page.
#
# SO THE WALL FOLLOWS THE LAW'S OWN CITATIONS. A living page that a rule room names as canon is
# held to the rule. Derived rather than listed, for the reason the globs are globs: a page the law
# begins citing tomorrow is walled the day it lands, where a typed list waits for somebody to
# remember it. Both citation shapes are read, because the law writes canon both ways -- a Markdown
# link, and far more often a backticked path.
#
# WHAT IT COST TO WIDEN, and the reading that was wrong first. A hand grep answered that all 33
# derived pages already stood at zero, which would have made the widening free. The widened scan
# then refused two of them -- `session-logs/CHAPTERS.md` at 50 characters and
# `construction/SHRED_PREP.md` at 49, both living pins the law names by path, both holding em
# dashes and middle dots the rule's own table spells. The hand grep had spelled its octal class
# inside single quotes, where `[\300-\377]` is a literal set of digits and a backslash rather than
# the high-byte range, so it answered a clean zero for every file it read. That is this meter's own
# subject turned back on the hand measuring it, twice in one lap, and it is why the number above
# comes from the instrument. Both pages were swept by
# `tools/fixtures/a/ascii_document_convert.sh` and proven by re-derivation from their committed
# bytes before this roster was seated.
#
# THE ONE THING DERIVATION CAN DO THAT A GLOB CANNOT is drop a page silently -- a rule that stops
# citing `context/RADIANT_STYLE.md` lets it fall out of the wall by an edit made somewhere else.
# That is why the membership count is PRINTED beside the globbed one rather than folded into a
# single total: a wall that shrinks should be legible in the census, and no reader can see a
# number that was never reported.
derived_list=$(mktemp "${TMPDIR:-/tmp}/ascii-doc-derived.XXXXXX") || {
  echo "instrument=failed"
  echo "detail=mktemp_refused"
  echo "verdict=misread"
  exit 1
}
trap 'rm -f "$LISTFILE" "$walled_list" "$derived_list"' EXIT INT TERM
{
  for g in $DERIVE_GLOBS; do
    for f in $g; do
      [ -f "$f" ] || continue
      # link form: a Markdown link whose target ends in the md or mdc extension, with any anchor
      # and any leading relative prefix removed. Spelled in words rather than shown, because an
      # illustration built to LOOK like a path reads as a citation to every reader and every tool
      # -- the habit `.claude/rules/stamp-and-name.md` names, and this line was costing the file
      # two unresolved references in its own quality reading.
      grep -oE '\]\([^)]+\.(md|mdc)\)' "$f" 2>/dev/null | sed 's/^](//; s/)$//; s/#.*//'
      # backtick form, which is how the law names canon most of the time
      grep -oE '`[A-Za-z0-9_./-]+\.(md|mdc)`' "$f" 2>/dev/null | tr -d '`'
    done
  done
} | sed 's|^\(\.\./\)*||; s|^\./||' | sort -u | while IFS= read -r c; do
  [ -n "$c" ] || continue
  # Third-party, projected, planted, or closed-stack testimony: each is read past for the same
  # reason the ratchet reads it past, so the two rosters cannot disagree. A page already walled by
  # a glob is dropped below, by the one enumeration rather than by a second spelling of the roster.
  case "$c" in
    gratitude/*|vendor/*|seed/*) continue ;;
    */fixtures/*|fixtures/*|*/fixture/*) continue ;;
    date/*|*/date/*|archive/*|*/archive/*|yonder/*|*/yonder/*) continue ;;
  esac
  b=${c##*/}
  case "$b" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*) continue ;;
  esac
  # TRACKED IS THE TEST, and it is answered from the listing already in hand rather than by a
  # `git ls-files` per candidate: the law cites example paths, fossils, and pages of other trees,
  # and only a page this repository actually carries can be held to anything.
  grep -qxF "$c" "$LISTFILE" || continue
  [ -f "$c" ] || continue
  walled "$c" && continue
  echo "$c"
done | sort -u > "$derived_list"
enforce_derived=$(wc -l < "$derived_list" | tr -d ' ')

# --- ENFORCE: the walled rooms and the canon the law names, at zero ---
enforce_files=0
enforce_globbed=0
enforce_dirty=0
enforce_chars=0
enforce_report=""
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$f" ] || continue
  enforce_files=$((enforce_files + 1))
  enforce_globbed=$((enforce_globbed + 1))
  reading=$(count_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  set -- $reading
  n=${1:-0}
  if [ "$n" -gt 0 ]; then
    enforce_dirty=$((enforce_dirty + 1))
    enforce_chars=$((enforce_chars + n))
    enforce_report="$enforce_report$n $f
"
  fi
done < "$walled_list"

# The derived canon reads through the same counter and the same report, so one page cannot be
# dirty in one roster and clean in the other.
while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$f" ] || continue
  enforce_files=$((enforce_files + 1))
  reading=$(count_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  set -- $reading
  n=${1:-0}
  if [ "$n" -gt 0 ]; then
    enforce_dirty=$((enforce_dirty + 1))
    enforce_chars=$((enforce_chars + n))
    enforce_report="$enforce_report$n $f
"
  fi
done < "$derived_list"

# --- RATCHET: every other living document in the actively-written rooms ---
ratchet_files=0
ratchet_dirty=0
ratchet_total=0
ratchet_named=0
ratchet_unnamed=0
ratchet_absent=0
ratchet_report=""
ratchet_quoted=0
while IFS= read -r f; do
  [ -n "$f" ] || continue
  # git quotes a path holding a newline or a high byte; such a path cannot be read line-by-line,
  # so it is counted and named rather than silently mis-parsed.
  case "$f" in
    '"'*) ratchet_quoted=$((ratchet_quoted + 1)); continue ;;
  esac
  walled "$f" && continue
  case "$f" in
    gratitude/*|vendor/*|seed/*) continue ;;
    */fixtures/*|fixtures/*|*/fixture/*) continue ;;
    date/*|*/date/*|archive/*|*/archive/*|yonder/*|*/yonder/*) continue ;;
  esac
  b=${f##*/}
  # A one-clock stamp at the head of the basename means testimony. The sprig is optional, so the
  # stamp alone marks it (`%175`: 237 logs carry a stamp and no sprig, and a pattern requiring one
  # read every last of them as living). ONE ARM, spelled `[_.]` -- the separator written as a
  # class, which is the repair dated_spelling_scan.sh prescribes by name. It stood as two arms,
  # `_*` and `.*`, matching exactly the same set; that meter reads a line at a time and cannot
  # see a sibling arm, so the sprigged half read as a pattern requiring the sprig and reddened a
  # cadence guard for a scan that was already answering correctly (20260907.145507).
  case "$b" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9][_.]*) continue ;;
  esac
  # A page the law names is counted by the ENFORCE roster above. Counting it here as well would
  # price one character twice and let a ceiling fall for a repair the gate already required.
  grep -qxF "$f" "$derived_list" && continue
  if [ ! -f "$f" ]; then
    ratchet_absent=$((ratchet_absent + 1))
    continue
  fi
  ratchet_files=$((ratchet_files + 1))
  reading=$(count_file "$f") || {
    echo "instrument=failed"
    echo "detail=awk_refused_a_file"
    echo "detail_path=$f"
    echo "verdict=misread"
    exit 1
  }
  set -- $reading
  n=${1:-0}; na=${2:-0}; un=${3:-0}
  if [ "$n" -gt 0 ]; then
    ratchet_dirty=$((ratchet_dirty + 1))
    ratchet_total=$((ratchet_total + n))
    ratchet_named=$((ratchet_named + na))
    ratchet_unnamed=$((ratchet_unnamed + un))
    ratchet_report="$ratchet_report$n $f
"
  fi
done < "$LISTFILE"

if [ "$mode" = "--list" ]; then
  printf '%s' "$ratchet_report" | sort -rn | head -40
fi
if [ "$mode" = "--enforce-list" ]; then
  printf '%s' "$enforce_report" | sort -rn | head -40
fi

if [ "$ratchet_total" -le "$CEILING" ]; then under=yes; else under=no; fi

echo "enforce_files=$enforce_files"
echo "enforce_globbed=$enforce_globbed"
echo "enforce_derived=$enforce_derived"
echo "enforce_dirty_files=$enforce_dirty"
echo "enforce_chars=$enforce_chars"
echo "ratchet_files=$ratchet_files"
echo "ratchet_absent=$ratchet_absent"
echo "ratchet_unreadable_paths=$ratchet_quoted"
echo "ratchet_dirty_files=$ratchet_dirty"
echo "ratchet_named=$ratchet_named"
echo "ratchet_unnamed=$ratchet_unnamed"
echo "ASCII_DOCUMENT files=$ratchet_files chars=$ratchet_total ceiling=$CEILING under_ceiling=$under"

if [ "$enforce_chars" -ne 0 ]; then
  printf '%s' "$enforce_report" | sort -rn | while IFS=' ' read -r c p; do
    [ -n "$p" ] || continue
    echo "detail=non_ascii_in_enforced_document"
    echo "detail_path=$p"
    echo "detail_chars=$c"
  done
  echo "enforce=failed"
  echo "verdict=misread"
  exit 1
fi
echo "enforce=honored"

if [ "$under" != "yes" ]; then
  echo "detail=ratchet_rose_above_ceiling"
  echo "verdict=misread"
  exit 1
fi
echo "story=rule_rooms_at_zero>living_documents_ratcheted>testimony_and_fixtures_read_past"
echo "verdict=ok"
