#!/bin/sh
# tools/fixtures/i/ignored_walk_scan.sh -- which tree walks read what git disowns.
# Gated by tools/i/ignored_walk_witness.rish. Proven by tools/fixtures/i/ignored_walk_control.sh.
#
# Why this exists: a guard that discovers its population by walking the filesystem reads every
# path standing under the root, and this tree's own laws send a lap to work in rooms git ignores --
# `.lap/` for a lap's scratch (read-scope.md), `session-output/` for a transcript, `loops/` for
# launcher state, and a `git worktree` parked under any of them. REDS %722 caught two such guards
# the hard way: a worktree at `.lap/verify` took `rye_harness_roster` from `unresolved=1` to `2`
# past a no-slack ceiling, naming one file counted twice, and a copy of `mantra/` under `.lap/probe/`
# took `copy_sameness` from `ok` to `drift`. Both readings were true about the disk and false about
# the tree, which is the direction a guard must never be wrong in: it reddens a rostered pass on
# every ship for a file no clone will ever hold, and that is how a gate gets turned off.
#
# That row closed the two guards that fired and named the class a lap. This is the lap. It reads
# the class rather than one member, so the next walk written tomorrow is counted the day it lands.
#
# WHAT IT GATES, AND WHY THAT NUMBER. `unfiltered` is a property of TRACKED SOURCES, so it reads the
# same on every ship and a ceiling over it refuses the same work everywhere. `exposed` counts the
# walks whose root holds an ignored path on THIS disk right now, which is a fact about one checkout
# -- a ship with an empty `.lap/` would read lower than its peer for no tree reason -- so it is
# reported by name and gated by nothing.
#
# THE PROXY, NAMED. A static reading cannot say whether an ignored path would MOVE a published
# number; it says the walk can reach one. Two of the ten probed by hand at %722 moved. So this is a
# reading of reach rather than of damage, and the roster it prints is a work list rather than a
# charge sheet.
# ONE WALK PER LINE. The grep answers per line, so two `find` calls sharing one line count once and
# the reading is an undercount by that shape. No living site in this tree carries two; naming the
# floor is cheaper than a parser, and a reading that says which way it errs can be trusted either way.
# Output convention: context/specs/20260729-215600_scan-seam-convention.md
#   values key=value - detail: prefixed - verdict= its own key - status agrees.
set -eu

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "sites=0"
  echo "verdict=no_git"
  echo "detail: this reading asks git which paths the tree disowns, so without git it declines rather than calling every walk clean"
  exit 2
fi

pen=$(mktemp -d) || { echo "verdict=no_scratch"; echo "detail: the scratch this reading is assembled in could not be made"; exit 2; }
trap 'rm -rf "$pen"' EXIT INT TERM

# The corpus is the tracked listing rather than a walk, for exactly the reason this guard exists.
if ! git ls-files -- 'tools/*' > "$pen/tracked.txt"; then
  echo "sites=0"
  echo "verdict=listing_refused"
  echo "detail: the tracked listing refused, and a broken instrument reads exactly like a clean tree"
  exit 2
fi
grep -E '\.(sh|rish)$' "$pen/tracked.txt" > "$pen/corpus.txt" || true
files=$(wc -l < "$pen/corpus.txt" | tr -d ' ')
[ "$files" -gt 0 ] || { echo "sites=0"; echo "verdict=empty_corpus"; echo "detail: no tracked shell or Rishi source stands under tools/"; exit 2; }
# A path carrying whitespace would be split by the `xargs` below into two names that open nothing,
# so the reading would silently shrink. Refused by name instead: zero such paths stand today, and a
# guard that says which path broke it costs one line where a wrong count costs a lap.
spaced=$(grep -c '[[:space:]]' "$pen/corpus.txt" || true)
if [ "${spaced:-0}" -gt 0 ]; then
  grep '[[:space:]]' "$pen/corpus.txt" | while IFS= read -r sp; do echo "detail: spaced-path $sp"; done
  echo "sites=0"
  echo "verdict=spaced_path"
  echo "detail: $spaced tracked paths carry whitespace, which this reading splits into names that open nothing -- it refuses rather than counting short"
  exit 2
fi

# The rooms git disowns on this disk, one line each, so exposure is asked of git rather than spelled.
# ITS FAILURE REFUSES RATHER THAN READING EMPTY. A `|| true` here would hand the exposure reading an
# empty list, and every walk in the tree would then print `latent` under `exposed=0` -- the cleanest
# possible answer, produced by an instrument that ran nothing. The status is caught before the pipe
# swallows it, since a pipeline reports only its last command.
if ! git status --porcelain --ignored=matching -unormal > "$pen/status.txt" 2>/dev/null; then
  echo "sites=0"
  echo "verdict=status_refused"
  echo "detail: git could not list what this tree disowns, and an empty list would read as a tree with no ignored room in it"
  exit 2
fi
awk '$1 == "!!" { $1 = ""; sub(/^ /, ""); print }' "$pen/status.txt" > "$pen/ignored.txt"
ignored_paths=$(wc -l < "$pen/ignored.txt" | tr -d ' ')

# A walk site is a `find` in COMMAND position -- start of line, or after a pipe, semicolon,
# ampersand, opening paren or command substitution. A `find` inside prose or a comment is not a
# walk, and the elder hand census of this class was a claim about a spelling three times over
# (%721), so the spelling is written down here rather than left in a reader's head.
: > "$pen/raw.txt"
# One grep over the whole listing rather than one per file -- 3,480 processes cost more than the
# reading is worth, and a per-lap tier has to be affordable or it becomes a cadence tier. `xargs`
# reads the list on STDIN rather than through `-a`, which is a GNU extension this tree walls at zero
# (`shell_dialect`). `xargs` splits its input on whitespace either way, so a tracked path carrying a
# space would be read as two, and that is refused by name above rather than left to corrupt a count.
# The anchor lives in one named place so the control can mutate it and watch the reading move.
# Dropping it makes the sentence "a reader will find tools useful" read as a walk of `tools`.
FIND_AT_COMMAND='(^|[;&|(]|\$\()[[:space:]]*find[[:space:]]'
xargs grep -nHE "$FIND_AT_COMMAND" < "$pen/corpus.txt" > "$pen/raw.txt" 2>/dev/null || true

: > "$pen/sites.txt"
while IFS= read -r line; do
  f=${line%%:*}
  rest=${line#*:}
  ln=${rest%%:*}
  body=${rest#*:}
  printf '%s\n' "$body" | grep -qE '^[[:space:]]*#' && continue
  # The first operand after `find` and its leading -L/-H/-P options is the walk root.
  root=$(printf '%s\n' "$body" \
    | sed -E 's/.*find[[:space:]]+//; s/^-[LHP][[:space:]]+//' \
    | sed -E 's/[[:space:]].*//' | tr -d '\042\047')
  [ -n "$root" ] || continue
  printf '%s\t%s\t%s\n' "$f" "$ln" "$root" >> "$pen/sites.txt"
done < "$pen/raw.txt"

sites=$(wc -l < "$pen/sites.txt" | tr -d ' ')

# Does this file ask git what the tree disowns, anywhere in its body? One reading per FILE rather
# than per site, because the cure is one helper the whole script shares. The test wants the CALL
# rather than the words: a file discussing `check-ignore` in a comment has cured nothing, and a
# meter excused by prose is a meter anybody can talk out of a reading.
#
# THIS METER'S OWN CONTROL IS COUNTED HERE, and that is correct rather than convenient. Its pen
# fixtures are written as heredocs holding real walks, so they read as walk sites; the file also
# makes the real call, so they land in `git_filtered` and never in the gated number. A fixture is
# part of a tracked source and gets read like one.
filtered_file() { grep -qE 'git[[:space:]]+check-ignore' "$1" 2>/dev/null; }

# Is this root a path inside the working tree, rather than a pen, an absolute path, or a variable?
# A variable root is REPORTED rather than guessed at: resolving one needs the shell's own state,
# and a guess in either direction is worse than a named gap.
# A `.` walk in a file that changes directory to a VARIABLE walks wherever that variable pointed,
# and a static reader cannot follow it. Measured `20260912`, seven such walks stand and they split
# three ways: `cd "$ROOT"` in `glow_desk_reach_scan.sh` and `radiant_select_wave.sh` lands on the
# repository root, so `.` genuinely IS the tree; `cd "$CORPUS"` in `one_title_scan.sh` and
# `line_length_census_scan.sh` and `cd "$SRC"` in both cellar exports land in a pen, so `.` is not.
# FOUR OF THE SEVEN ARE INERT MEMBERS OF THE GATED NUMBER, and that is said here rather than fixed by
# a rule, because both candidate rules are wrong: reclassifying every cd-relocated walk drops three
# real findings, and spelling `ROOT` as the root-ish name is the same claim-about-remembered-names
# this whole reading exists to retire. They are counted and printed by name under `cd_relocated`, so
# a lane repairing the class knows which members it can never bring to zero.
cds_to_variable() { grep -qE '(^|[;&|(]|\$\()[[:space:]]*cd[[:space:]]+"?\$' "$1" 2>/dev/null; }

tree_root() {
  case "$1" in
    .|./*) return 0 ;;
    /*|~*) return 1 ;;
    '$'*|'${'*) return 1 ;;
    *'$'*) return 1 ;;
    *) [ -d "${1%%/*}" ] && git ls-files --error-unmatch "${1%%/*}" >/dev/null 2>&1 && return 0
       [ -d "${1%%/*}" ] && [ -n "$(git ls-files -- "${1%%/*}" | head -1)" ] && return 0
       return 1 ;;
  esac
}

# An ignored path stands under this walk root on this disk.
exposed_root() {
  r=$1
  case "$r" in .|./) return 0 ;; esac
  r=${r#./}
  r=${r%/}
  grep -q -e "^$r/" -e "^$r\$" "$pen/ignored.txt" 2>/dev/null && return 0
  return 1
}

unfiltered=0
filtered=0
exposed=0
unresolved=0
offtree=0
relocated=0
: > "$pen/roster.txt"
while IFS="$(printf '\t')" read -r f ln root; do
  if ! tree_root "$root"; then
    case "$root" in
      '$'*|'${'*|*'$'*) unresolved=$((unresolved + 1)); echo "detail: unresolved-root $f:$ln $root" ;;
      *) offtree=$((offtree + 1)) ;;
    esac
    continue
  fi
  if filtered_file "$f"; then
    filtered=$((filtered + 1))
    continue
  fi
  unfiltered=$((unfiltered + 1))
  case "$root" in
    .|./*) if cds_to_variable "$f"; then
             relocated=$((relocated + 1))
             echo "detail: cd-relocated $f:$ln walks . in a file that changes directory to a variable, so this root is whatever that variable held"
           fi ;;
  esac
  if exposed_root "$root"; then
    exposed=$((exposed + 1))
    printf '%s:%s\t%s\texposed\n' "$f" "$ln" "$root" >> "$pen/roster.txt"
  else
    printf '%s:%s\t%s\tlatent\n' "$f" "$ln" "$root" >> "$pen/roster.txt"
  fi
done < "$pen/sites.txt"

# The roster prints by NAME, every row, because a reported population that prints only its size is
# visible the way a locked door is (the reading of 20260911.212157, one room over).
if [ -s "$pen/roster.txt" ]; then
  sort "$pen/roster.txt" | while IFS="$(printf '\t')" read -r site root state; do
    echo "detail: $state $site walks $root"
  done
fi

# The ceiling is the reading on the lap this meter was seated, one lower for the repair that rode
# with it (`tools/fixtures/t/tools_py_ban_scan.sh`). It only falls. RUN the scan rather than reading
# this number, since a lane that repairs a walk lowers both in the same commit.
CEILING=${IGNORED_WALK_CEILING:-27}
echo "files_read=$files"
echo "sites=$sites"
echo "ignored_paths=$ignored_paths"
echo "walks_tree=$((unfiltered + filtered))"
echo "git_filtered=$filtered"
echo "unfiltered=$unfiltered"
echo "exposed=$exposed"
echo "unresolved_root=$unresolved"
echo "cd_relocated=$relocated"
echo "off_tree=$offtree"
echo "ceiling=$CEILING"

if [ "$unfiltered" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
  echo "detail: $unfiltered tree walks read what git disowns, against a ceiling of $CEILING -- the cure is one helper asking git check-ignore, as tools/fixtures/c/copy_sameness_scan.sh carries it"
  exit 1
fi
echo "verdict=ok"
