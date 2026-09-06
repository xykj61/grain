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
#   ENFORCE   `.claude/rules/*.md` and `.cursor/rules/*.mdc`. Zero characters above 0x7F, hard.
#             These are read as law by whichever editor is driving, so a rule page is the one
#             document whose own bytes are an argument about the rule. Swept to zero on the lap
#             this meter was seated, which is what earns the roster its gate.
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
CEILING="${ASCII_DOC_CEILING:-3956}"

# THE ROSTERS ARE GLOBS RATHER THAN A LIST OF NAMES. A rule page added tomorrow is governed the day
# it lands, where a name list would let it in unmeasured until somebody remembered to type it.
ENFORCE_GLOBS="${ASCII_DOC_ENFORCE_GLOBS:-.claude/rules/*.md .cursor/rules/*.mdc}"

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

# --- ENFORCE: the rule rooms, at zero ---
enforce_files=0
enforce_dirty=0
enforce_chars=0
enforce_report=""
for g in $ENFORCE_GLOBS; do
  for f in $g; do
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
  done
done

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
  case "$f" in
    .claude/rules/*.md|.cursor/rules/*.mdc) continue ;;
    gratitude/*|vendor/*|seed/*) continue ;;
    */fixtures/*|fixtures/*|*/fixture/*) continue ;;
    date/*|*/date/*|archive/*|*/archive/*|yonder/*|*/yonder/*) continue ;;
  esac
  b=${f##*/}
  # A one-clock stamp at the head of the basename means testimony. The sprig is optional, so the
  # stamp alone marks it (`%175`: 237 logs carry a stamp and no sprig, and a pattern requiring one
  # read every last of them as living).
  case "$b" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9]_*) continue ;;
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]-[0-9][0-9][0-9][0-9][0-9][0-9].*) continue ;;
  esac
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
