#!/bin/sh
# tools/fixtures/s/shell_dialect_touch_scan.sh -- a shell source this commit stages is read for
# GNU-only idioms while the hand that wrote it is still here.
#
# WHAT THIS IS FOR. `shell_dialect_scan.sh` already holds the whole law: six families of GNU-only
# spelling, five of them at a ceiling of ZERO because this tree runs on two piers -- a NixOS VPS
# with GNU coreutils and a macOS bench with BSD ones -- and a guard written in one host's dialect
# reads empty on the other. An empty reading counts as zero, and a zero nobody planted looks exactly
# like a healthy tree.
#
# WHY IT READS AT COMMIT TIME. The elder reading is correct and it is SLOW to arrive. It stands at
# `tier lap` inside a roster pass that runs for roughly half an hour, so the lap that breaks the
# family is structurally never the lap that hears it. Measured `20260908`: two GNU-only `sed -i`
# plants landed in `tools/am/amphora_mark_wreck_witness.rish` at 01:59 and were first heard at a
# DIFFERENT ship's cold open at 02:42 -- 43 minutes and one ship later, and the ship that paid was
# not the ship that wrote them. Two hands then cured the same two sites in parallel and one cure
# withdrew whole. That is a lantern firing twice; this is the loom.
#
# WHAT IS GATED, and the one fact that makes it safe. Five families stand at a ceiling of ZERO in
# the tree today, measured here `20260908.040446`: xargs `-a`/`-d`, `date -d`, `grep -P`, `stat -c`,
# and `sed -i`. A ceiling of zero means NO lawful site exists anywhere, so any hit in a staged file
# is a rise by construction -- which is why this may read whole blobs rather than diff hunks, and
# still never refuse an author for a line somebody else wrote. If a family's tree ceiling ever
# leaves zero, this scan reads it from the elder and stops gating it, rather than refusing honest
# work on the strength of a stale sentence here.
#
# WHAT IS REPORTED AND NEVER GATED: `readlink -f`, whose tree ceiling stands at SEVEN. Five of those
# sites are in `shell_portable_control.sh`, which calls the elder spelling on purpose to compare the
# portable helper against it, and a sixth is in `tools/ag/agent-jail.sh`, which the Pond quest holds
# accrete-only. A wall refusing a commit that touches one of those is a wall somebody turns off.
#
# NOTHING HERE IS RESPELLED. Every pattern, every ceiling, and both path exclusions are READ out of
# `shell_dialect_scan.sh` by name. A rule written in two files is a rule two files may quietly come
# to disagree about (REDS %382), and this class in particular has already grown from five sites to
# fourteen while an advisory note in prose named its own promotion condition and nobody checked it.
# A scan that cannot find its patterns REFUSES; guessing would wave the whole family through.
#
#   sh tools/fixtures/s/shell_dialect_touch_scan.sh            # what this commit ships
#   sh tools/fixtures/s/shell_dialect_touch_scan.sh head       # what HEAD shipped
#   sh tools/fixtures/s/shell_dialect_touch_scan.sh prove-red  # the planted refusal
#
# WHAT IT READS, and why off the index rather than off disk. `git cat-file -p :<path>` is the source
# this commit will actually carry. A round that stages a repaired line and then edits the file again
# would otherwise read green off a worktree the commit does not hold.
#
# WHAT IS NOT PROVEN. That a portable spelling is a CORRECT one. This reads dialect, never behavior;
# the elder's own `prove-portable` and `prove-dialect` legs are where equality under both hosts is
# shown, and `tools/fixtures/s/shell_portable.sh` is where the answers live.
#
# Gated by tools/s/shell_dialect_touch_witness.rish; proven both ways by
# tools/fixtures/s/shell_dialect_touch_control.sh on real git repositories in a throwaway pen.
set -u

MODE=staged
# A collection names its maximum (TAME). The widest single commit in this tree's history moved
# 2,163 files; 4,096 is the next power of two above it and far below a runaway read.
MAX_FILES=4096

while [ $# -gt 0 ]; do
  case "$1" in
    staged|head|prove-red) MODE=$1 ;;
    *) echo "detail=RED_unknown_argument"; echo "detail_argument=$1"; echo "verdict=misread"; exit 1 ;;
  esac
  shift
done

echo "mode=$MODE"

if [ "$MODE" = prove-red ]; then
  # The planted refusal, so the RED path is exercised without waiting for a real commit to carry
  # the fault. The SHAPE is spelled here; the LAW lives in shell_dialect_scan.sh.
  # THE IDIOM IS ASSEMBLED, NEVER SPELLED. This file is on the elder scan's own roster, so a line
  # here writing the flag beside its command IS a site by the elder's reading, and the tree's
  # ceiling for that family is zero. The elder solves the same problem in prose by naming a family
  # without its flag; a scan that must PLANT one builds it from parts instead.
  i_flag=-i
  echo "detail=RED_staged_gnu_only_idiom"
  echo "detail_family=sed_in_place_flag"
  echo "detail_path=tools/x/a_witness_that_edits_in_place.rish"
  echo "detail_site=tools/x/a_witness_that_edits_in_place.rish:12:  sed $i_flag \"s|a|b|\" \"\$f\""
  echo "detail_repair=. tools/fixtures/s/shell_portable.sh and call sed_inplace"
  echo "staged_gated_sites=1"
  echo "verdict=misread"
  exit 1
fi

SOURCE=tools/fixtures/s/shell_dialect_scan.sh
if [ ! -f "$SOURCE" ]; then
  echo "detail=RED_dialect_source_absent"
  echo "detail_source=$SOURCE"
  echo "verdict=misread"
  exit 1
fi

# THE PATTERNS AND THE CEILINGS ARE LIFTED, NEVER COPIED. Each is a constant assignment at column
# zero in the elder scan, so a grep by name and an eval reads exactly what the elder reads. The
# alternative -- a second spelling of six regular expressions -- is the two-files-one-rule fault
# this tree has already booked twice, and it would fail SILENTLY: a pattern that drifts here still
# matches something, so the scan would keep printing numbers while measuring a different law.
eval "$(grep -E '^(SELF|HELPER|GATED_RE|DATE_RE|DATE_BSD_RE|GREP_P_RE|STAT_C_RE|SED_I_RE|READLINK_F_RE|comment_line)=' "$SOURCE")" 2>/dev/null || true

for want in SELF HELPER GATED_RE DATE_RE DATE_BSD_RE GREP_P_RE STAT_C_RE SED_I_RE READLINK_F_RE comment_line; do
  eval "got=\${$want:-}"
  if [ -z "$got" ]; then
    echo "detail=RED_pattern_unreadable"
    echo "detail_name=$want"
    echo "detail_source=$SOURCE"
    echo "verdict=misread"
    exit 1
  fi
done

# THE CEILINGS ARE READ TOO, and they decide which families this wall speaks for. A family whose
# tree ceiling has left zero holds lawful sites, so a whole-blob reading would refuse an author for
# a line already standing -- it is reported here instead. This is the one line that keeps the
# safety argument in the header TRUE rather than merely written down.
ceiling_of() { # ceiling_of <VAR NAME> <default>
  sed -n "s/^$1=\${[A-Z_]*:-\([0-9][0-9]*\)}.*/\1/p" "$SOURCE" | head -1
}
C_XARGS=$(sed -n 's/^CEILING="\${[A-Z_]*:-\([0-9][0-9]*\)}".*/\1/p' "$SOURCE" | head -1)
C_DATE=$(ceiling_of DATE_CEILING)
C_GREP=$(ceiling_of GREP_P_CEILING)
C_STAT=$(ceiling_of STAT_C_CEILING)
C_SED=$(ceiling_of SED_I_CEILING)
C_READLINK=$(ceiling_of READLINK_F_CEILING)
for c in "$C_XARGS" "$C_DATE" "$C_GREP" "$C_STAT" "$C_SED" "$C_READLINK"; do
  if [ -z "$c" ]; then
    echo "detail=RED_ceiling_unreadable"
    echo "detail_source=$SOURCE"
    echo "verdict=misread"
    exit 1
  fi
done
echo "source=$SOURCE"

case "$MODE" in
  staged) TOUCHED=$(git diff --cached --name-only --diff-filter=ACMR 2>/dev/null || true) ;;
  head)   TOUCHED=$(git diff-tree --no-commit-id --name-only -r --diff-filter=ACMR HEAD 2>/dev/null || true) ;;
esac

PEN=$(mktemp -d 2>/dev/null) || {
  echo "detail=RED_pen_unavailable"; echo "verdict=misread"; exit 1
}
trap 'rm -rf "$PEN"' EXIT INT TERM HUP
blob="$PEN/blob"

body_of() {
  case "$MODE" in
    staged) git cat-file -p ":$1" 2>/dev/null ;;
    head)   git cat-file -p "HEAD:$1" 2>/dev/null ;;
  esac
}

# THE SAME ROSTER THE ELDER READS, asked one path at a time. Three globs, minus the two files that
# hold the elder spellings on purpose -- this scan's source, which spells every pattern it hunts,
# and the portable helper, whose GNU leg IS the repair on a GNU host. A TRACKED SYMLINK is the same
# source under a second name and is skipped by its git mode, exactly as the elder skips it.
speaks_for() {
  case "$1" in
    "$SELF"|"$HELPER") return 1 ;;
    *.sh|*.rish) ;;
    tools/hooks/*) ;;
    *) return 1 ;;
  esac
  case "$(git ls-files -s -- "$1" 2>/dev/null | cut -c1-6)" in
    120000) return 1 ;;
  esac
  return 0
}

# One family, one file, one reading. The comment filter is the elder's own: a line whose first
# non-blank character is `#` is prose rather than a command, and telling a writer to delete the
# explanation of their own repair is a number instructing nobody.
sites_in() { # sites_in <regex>
  grep -nHE "$1" "$blob" 2>/dev/null | grep -vE "$comment_line" || true
}

FILES_READ=0
GATED=0
ADVISORY=0
REPORT=""
FIRST=""
FIRST_FAMILY=""
FIRST_PATH=""

# The gated five, each named for the report. A family joins this list only while its tree ceiling
# stands at zero, which is checked above rather than assumed.
for path in $TOUCHED; do
  speaks_for "$path" || continue
  FILES_READ=$((FILES_READ + 1))
  if [ "$FILES_READ" -gt "$MAX_FILES" ]; then
    echo "detail=RED_files_past_bound"; echo "detail_max=$MAX_FILES"; echo "verdict=misread"; exit 1
  fi
  body_of "$path" > "$blob" 2>/dev/null || continue

  for pair in \
    "xargs_arg_file_or_delimiter:$C_XARGS:$GATED_RE" \
    "date_parse_or_relative:$C_DATE:$DATE_RE" \
    "grep_pcre:$C_GREP:$GREP_P_RE" \
    "stat_field_format:$C_STAT:$STAT_C_RE" \
    "sed_in_place_flag:$C_SED:$SED_I_RE"
  do
    family=${pair%%:*}
    rest=${pair#*:}
    ceiling=${rest%%:*}
    re=${rest#*:}
    [ "$ceiling" = 0 ] || continue
    hits=$(sites_in "$re")
    # The date family alone reads past a GNU spelling standing beside its BSD partner on one line:
    # that pairing IS the repair, and counting it would tell a reader to delete the answer.
    if [ "$family" = date_parse_or_relative ] && [ -n "$hits" ]; then
      hits=$(printf '%s\n' "$hits" | grep -vE "$DATE_BSD_RE" || true)
    fi
    [ -n "$hits" ] || continue
    count=$(printf '%s\n' "$hits" | grep -c . || true)
    GATED=$((GATED + count))
    line=$(printf '%s\n' "$hits" | head -1 | sed "s|^$blob:|$path:|")
    REPORT="$REPORT
staged_site=$family $line"
    if [ -z "$FIRST" ]; then
      FIRST=$line
      FIRST_FAMILY=$family
      FIRST_PATH=$path
    fi
  done

  adv=$(sites_in "$READLINK_F_RE")
  if [ -n "$adv" ]; then
    ADVISORY=$((ADVISORY + $(printf '%s\n' "$adv" | grep -c . || true)))
  fi
done

echo "files_read=$FILES_READ"
echo "staged_gated_sites=$GATED"
echo "staged_gated_ceiling=0"
echo "staged_advisory_readlink_sites=$ADVISORY"
echo "advisory_readlink_tree_ceiling=$C_READLINK"
# Spelled as an `if` rather than `[ -z ... ] || printf ...`, for the reason
# tools/hooks/pre-commit spells its own closing line that way: an OR-list substitutes a fallback
# for a failure, so the printf's own refusal would read as an answer. `instrument_refusal` counts
# exactly this shape, and it counted this line on the lap it was written.
if [ -n "$REPORT" ]; then
  printf '%s\n' "$REPORT" | sed '/^$/d'
fi

if [ "$GATED" -gt 0 ]; then
  echo "detail=RED_staged_gnu_only_idiom"
  echo "detail_family=$FIRST_FAMILY"
  echo "detail_path=$FIRST_PATH"
  echo "detail_site=$FIRST"
  echo "detail_repair=. tools/fixtures/s/shell_portable.sh and call its portable helper"
  echo "verdict=misread"
  exit 1
fi

echo "verdict=ok"
