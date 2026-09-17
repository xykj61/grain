#!/bin/sh
# tools/fixtures/r/root_finder_scan.sh -- can this tree's own scripts find their root in a
# checkout of tracked bytes alone?
#
#   sh tools/fixtures/r/root_finder_scan.sh [--list] [--sentinels] [--doors] [--explain <path>]
#
# WHAT A ROOT-FINDER IS. Two hundred and some tracked shell sources open by walking up from their
# own directory until they reach a directory holding certain named children, then source a shared
# helper from there. The walk is a copied block and its stopping test is one line:
#
#   while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
#
# The named children are this reading's subject. Call them SENTINELS: a script has declared that
# the directory holding all of them is the repository root.
#
# WHAT THIS ASKS, AND WHY IT IS THE ONLY QUESTION A STATIC READING CAN ANSWER. A sentinel is a
# promise about where the root is, and the promise holds only where the sentinel EXISTS. So each
# sentinel is classified by what keeps it in existence, which `git ls-files` answers exactly:
#
#   tracked       -- the name holds tracked content, so it stands in every checkout of this
#                    repository, built or bare.
#   build_output  -- the name holds nothing tracked and is not `.git`. It stands only where
#                    somebody has run a build. `rishi/bin` is this class: it holds the built
#                    `rishi` binary and `git ls-files rishi/bin` reads 0.
#   git_dir       -- the name is literally `.git`. It stands as a DIRECTORY in an ordinary clone
#                    and as a FILE in a linked worktree, where `git worktree add` writes a
#                    `gitdir:` pointer instead, so `-d` is false there and the walk refuses.
#
# A finder naming a `build_output` sentinel cannot run in a fresh clone before its first build, in
# a detached worktree, or in any pristine-tree reading (REDS %788). That is the gated number below.
# A finder naming a `git_dir` sentinel runs in a clone and refuses in a linked worktree, which is a
# narrower fault wearing the same shape; it is reported rather than gated, since the two want
# different repairs and a merged number would hide which one a lane is looking at.
#
# WHY A RATCHET RATHER THAN A WALL. The repair is one directory name per file and the files are
# spread across every lane of the fleet, so the sweep's timing belongs to the fleet rather than to
# one ship (REDS %788's own closing sentence). A wall at zero would red eight ships at once for
# work none of them chose this hour. The ceiling only falls, so each lane sweeps its own files at
# its own pace and the fleet-wide property is provable the lap the last one lands.
#
# THE SECOND READING, WHICH NOTHING HELD. A walk that stops at the FIRST directory holding every
# sentinel stops at the wrong place if some directory below the root holds them all too. Measured
# by taking each sentinel's tracked parent directories and intersecting them across the finder's
# own sentinel set: an `ambiguous` finder has at least one non-root directory answering its test.
# Reported, because whether a given script can ever stand under such a directory is a judgment
# about that script's home rather than a fact about the tree. It is also BLIND IN ONE
# DIRECTION and says so: the parents are read from `git ls-files`, so a `build_output` or
# `git_dir` sentinel can never show a below-root occurrence here however many stand on disk.
# That blindness is safe for the reading it serves -- a finder naming such a sentinel is
# already counted in the gated number above, where the sharper fault lives.
#
# THIS SCAN IS NOT IN ITS OWN GATED POPULATION, on purpose and provably. Its own root-finder and
# its control's name `rishi/src` and `tools/fixtures`, both tracked, so both appear in `finders`
# and neither in `finders_bare_unrunnable` -- which the control asserts by reading this scan's own
# output rather than by trusting the sentence (`control_in_population_scan.sh`, REDS %785). Its
# plants live in a `mktemp` pen outside the tree, so no planted finder ever reaches tracked bytes.
#
# THE DOORS, AND WHY A READING RATHER THAN AN ARGUMENT (`--doors`). REDS %788 names two repairs
# and weighs neither. SWEEP replaces the build-output sentinel with a tracked one in every finder
# that names it; TRACK puts one tracked file under the build-output name, so the directory stands
# in a checkout of tracked bytes and no finder changes at all. A door is chosen by its cost and by
# what it makes true, so `--doors` derives both from the index rather than from a typed number.
#
# WHAT `--doors` COUNTS, and what each count decides. `finder_files` is the sweep's own population.
# `pen_files` is the population NOBODY had counted: a tracked source that creates the sentinel
# directory to lay out a pen keeps making the elder shape after a sweep, so a finder copied there
# walks out of the pen and refuses. Those sites are loud rather than silent -- a pen under `mktemp`
# has no ancestor holding the new sentinel, so the walk reaches `/` and exits 2 -- yet they are
# files the sweep must visit, and they sit in lanes the finder count never named.
#
# THE REPLACEMENT IS A PROPOSAL AND ITS PROPERTIES ARE MEASURED. `SWEEP_TO` is this row's own named
# repair, a judgment about which directory means "this repository"; whether it can carry the job is
# a fact, so the reading answers both halves -- `replacement_tracked`, and `replacement_below_root`,
# which must read 0 or the swept walk stops somewhere below the root.
#
# THE THIRD DOOR IS PRICED AND NOT COUNTED. `git -C "$(dirname "$0")" rev-parse --show-toplevel`
# needs no sentinel and is right in a clone and in a linked worktree alike. The walk's own seating
# comment names what it costs -- "git-free, so a pen copy outside a repository still resolves" --
# and `pen_files_no_repo` is that cost as a number: pen layouts creating the sentinel without
# running `git init`, where a git-rooted finder has no repository to answer from. It is reported
# beside the doors rather than gated, since adopting it is a fleet ruling rather than a lane's.
#
# WHAT IT DOES NOT REACH. A script computing its root some other way -- `git rev-parse --show-toplevel`,
# an environment variable, a literal path -- carries no `while [ ! -d` line and is invisible here.
# A finder whose stopping test spans more than one physical line is likewise unread; measured
# `20260917`, every root-finder in this tree writes its test on one line, and a second line would
# UNDERCOUNT rather than mislead.

set -u

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/src" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"
cd "$_fd_root" || exit 2

# THE CEILING, and why it is this number. It is the reading taken the lap this scan was seated,
# with no slack: a ceiling carrying room is a ceiling that welcomes the next copy. Lower it in the
# same commit that sweeps a file.
CEILING=189

# BOUNDS. A tree this size holds a few thousand shell sources and a few hundred finders; both
# limits sit an order above the live reading, so a wildly wrong enumeration meets a named refusal
# rather than an unbounded read.
MAX_SOURCES=20000
MAX_FINDERS=4000

# THE SWEEP'S PROPOSED REPLACEMENT, named by REDS %788 rather than derived: `rishi/src` holds four
# tracked files, so it stands in every checkout. The `--doors` reading MEASURES both properties the
# proposal rests on rather than restating them, and a replacement failing either reads `no` there.
SWEEP_TO=rishi/src

MODE=count
TARGET=
case "${1:-}" in
  '')          ;;
  --list)      MODE=list ;;
  --sentinels) MODE=sentinels ;;
  --doors)     MODE=doors ;;
  --explain)   MODE=explain; TARGET=${2:-} ;;
  *) echo "$0: unknown argument '$1' (want --list, --sentinels, --doors, or --explain <path>)" >&2; exit 2 ;;
esac
if [ "$MODE" = explain ] && [ -z "$TARGET" ]; then
  echo "$0: --explain wants a path" >&2
  exit 2
fi

work=$(mktemp -d) || exit 2
trap 'rm -rf "$work"' EXIT INT TERM

git ls-files -- '*.sh' '*.rish' > "$work/sources.txt" || exit 2
sources=$(wc -l < "$work/sources.txt" | tr -d ' ')
if [ "$sources" -gt "$MAX_SOURCES" ]; then
  echo "$0: $sources tracked shell sources past the bound of $MAX_SOURCES" >&2
  exit 2
fi

# Candidates first, so the extractor reads a few hundred files rather than a few thousand. The
# path list reaches grep through `xargs_lines`, which is newline-delimited on both piers -- a bare
# `$(cat ...)` splits a path on a space and hands grep two broken paths that quietly match nothing.
xargs_lines "$work/sources.txt" \
  grep -lE '^[[:space:]]*(while|until)[[:space:]]*\[[[:space:]]*!' \
  > "$work/candidates.txt" 2>/dev/null || true

# One finder per line: `<path>\t<sentinel> <sentinel> ...`, sentinels in the order the test names
# them. A file may carry more than one finder and each is counted on its own.
: > "$work/finders.txt"
while IFS= read -r f; do
  [ -n "$f" ] || continue
  awk -v path="$f" '
    { line[NR] = $0 }
    END {
      for (n = 1; n <= NR; n++) {
        if (line[n] !~ /^[[:space:]]*(while|until)[[:space:]]*\[[[:space:]]*!/) continue
        rest = line[n]
        out = ""
        var = ""
        while (match(rest, /-d[[:space:]]*"\$[A-Za-z_][A-Za-z0-9_]*\/[A-Za-z0-9_.\/-]+"/)) {
          tok = substr(rest, RSTART, RLENGTH)
          rest = substr(rest, RSTART + RLENGTH)
          sub(/^-d[[:space:]]*"\$/, "", tok)
          sub(/"$/, "", tok)
          slash = index(tok, "/")
          v = substr(tok, 1, slash - 1)
          child = substr(tok, slash + 1)
          if (var == "") var = v
          else if (var != v) var = "!mixed"
          out = (out == "" ? child : out " " child)
        }
        if (out == "" || var == "" || var == "!mixed") continue
        # A ROOT-FINDER WALKS UP. The loop body must reassign the very variable the test names,
        # from `dirname`. Without that clause a wait loop -- `while [ ! -d "$REPO/.../run.lock" ]`
        # -- reads as a root-finder, which is exactly what one did before this was written.
        walks = 0
        for (m = n + 1; m <= NR && m <= n + 12; m++) {
          if (line[m] ~ ("^[[:space:]]*" var "=\\$\\(dirname")) { walks = 1; break }
          if (line[m] ~ /^[[:space:]]*done/) break
        }
        if (walks) printf "%s\t%s\n", path, out
      }
    }
  ' "$f" >> "$work/finders.txt"
done < "$work/candidates.txt"

finders=$(wc -l < "$work/finders.txt" | tr -d ' ')
if [ "$finders" -gt "$MAX_FINDERS" ]; then
  echo "$0: $finders root-finders past the bound of $MAX_FINDERS" >&2
  exit 2
fi

# Every distinct sentinel name, classified once. `git ls-files -- <name>` answering nothing means
# the name holds no tracked content; `.git` is named apart because it exists without being tracked.
cut -f2 "$work/finders.txt" | tr ' ' '\n' | sort -u > "$work/sentinels.txt"
: > "$work/classified.txt"
while IFS= read -r s; do
  [ -n "$s" ] || continue
  if [ "$s" = ".git" ]; then
    cls=git_dir
  elif [ -n "$(git ls-files -- "$s" | head -1)" ]; then
    cls=tracked
  else
    cls=build_output
  fi
  # A sentinel's tracked parent directories, root excluded. `a/b/<s>/...` gives parent `a/b`.
  git ls-files -- "*/$s/*" \
    | awk -v s="$s" '{ i = index($0, "/" s "/"); if (i > 1) print substr($0, 1, i - 1) }' \
    | sort -u > "$work/parents.$cls.$(echo "$s" | tr / _).txt"
  below=$(wc -l < "$work/parents.$cls.$(echo "$s" | tr / _).txt" | tr -d ' ')
  printf '%s\t%s\t%s\t%s\n' "$s" "$cls" "$below" "$work/parents.$cls.$(echo "$s" | tr / _).txt" \
    >> "$work/classified.txt"
done < "$work/sentinels.txt"

# The classified table is read ONCE into two membership lists and a name-to-file map, rather than
# re-awked per sentinel per finder. At 214 finders that spelling cost some 850 process spawns and
# most of this scan's wall time; the lists are seven entries long.
BUILD_SENTINELS=$(awk -F'\t' '$2 == "build_output" { printf "%s ", $1 }' "$work/classified.txt")
GITDIR_SENTINELS=$(awk -F'\t' '$2 == "git_dir" { printf "%s ", $1 }' "$work/classified.txt")
awk -F'\t' '{ print $1, $4 }' "$work/classified.txt" > "$work/parentmap.txt"
parents_of() {
  awk -v s="$1" '$1 == s { print $2; exit }' "$work/parentmap.txt"
}

# AMBIGUITY IS ANSWERED PER DISTINCT SENTINEL SET, once, rather than per finder. Two hundred and
# some finders spell only a handful of distinct sets, and the answer depends on the set alone.
AMB_SETS=
cut -f2 "$work/finders.txt" | sort -u > "$work/sets.txt"
while IFS= read -r set; do
  [ -n "$set" ] || continue
  first=yes
  for s in $set; do
    p=$(parents_of "$s")
    if [ "$first" = yes ]; then
      cp "$p" "$work/inter.txt"
      first=no
    else
      comm -12 "$work/inter.txt" "$p" > "$work/inter.next" 2>/dev/null || : > "$work/inter.next"
      mv "$work/inter.next" "$work/inter.txt"
    fi
  done
  if [ "$first" = no ] && [ -s "$work/inter.txt" ]; then
    AMB_SETS="$AMB_SETS|$(echo "$set" | tr ' ' ',')|"
  fi
done < "$work/sets.txt"

bare=0
fragile=0
ambiguous=0
: > "$work/rows.txt"
while IFS="$(printf '\t')" read -r path sentinels; do
  [ -n "$path" ] || continue
  verdict=runnable
  has_build=no
  has_gitdir=no
  for s in $sentinels; do
    case " $BUILD_SENTINELS " in *" $s "*) has_build=yes ;; esac
    case " $GITDIR_SENTINELS " in *" $s "*) has_gitdir=yes ;; esac
  done
  [ "$has_build" = yes ] && { bare=$((bare + 1)); verdict=bare_unrunnable; }
  [ "$has_gitdir" = yes ] && { fragile=$((fragile + 1)); [ "$verdict" = runnable ] && verdict=worktree_fragile; }

  # Ambiguity: a non-root directory answering EVERY sentinel of this finder, looked up by set.
  amb=no
  case "$AMB_SETS" in
    *"|$(echo "$sentinels" | tr ' ' ',')|"*) amb=yes; ambiguous=$((ambiguous + 1)) ;;
  esac

  printf '%s sentinels=%s verdict=%s ambiguous=%s\n' \
    "$path" "$(echo "$sentinels" | tr ' ' ',')" "$verdict" "$amb" >> "$work/rows.txt"
done < "$work/finders.txt"

if [ "$MODE" = list ]; then
  sort "$work/rows.txt"
fi
if [ "$MODE" = explain ]; then
  grep -F -- "$TARGET " "$work/rows.txt" \
    || echo "explain: $TARGET carries no root-finder this reading can see"
fi
if [ "$MODE" = sentinels ]; then
  while IFS="$(printf '\t')" read -r s cls below _p; do
    n=$(cut -f2 "$work/finders.txt" | tr ' ' '\n' | grep -cxF "$s")
    echo "sentinel $s class=$cls finders=$n below_root_dirs=$below"
  done < "$work/classified.txt"
fi

if [ "$MODE" = doors ]; then
  # One door pair per build-output sentinel. The tree carries exactly one today; the loop is what
  # keeps the reading true if a second arrives, rather than a sentence promising it would.
  while IFS="$(printf '\t')" read -r s cls _below _p; do
    [ "$cls" = build_output ] || continue

    # The sweep's own population, split into SITES (one finder) and FILES (one path), because a
    # file may carry two finders and a sweep visits the file once.
    awk -F'\t' -v s="$s" '{ n = split($2, a, " "); for (i = 1; i <= n; i++) if (a[i] == s) print $1 }' \
      "$work/finders.txt" > "$work/door.sites.txt"
    finder_sites=$(wc -l < "$work/door.sites.txt" | tr -d ' ')
    sort -u "$work/door.sites.txt" > "$work/door.files.txt"
    finder_files=$(wc -l < "$work/door.files.txt" | tr -d ' ')

    # The population nobody had counted: tracked sources that CREATE the sentinel directory to lay
    # out a pen. A sweep that leaves them behind leaves a pen whose copied finder walks out of it.
    # The `[^|;&]*` bound keeps the match inside one command rather than reaching across a pipe.
    s_re=$(printf '%s' "$s" | sed 's/[.[\*^$]/\\&/g')
    xargs_lines "$work/sources.txt" grep -lE "mkdir[^|;&]*$s_re" 2>/dev/null \
      | sort -u > "$work/door.pens.txt" || : > "$work/door.pens.txt"
    pen_files=$(wc -l < "$work/door.pens.txt" | tr -d ' ')

    # Of those, the ones building NO repository. That is the price of the git-rooted third door,
    # which the walk's own seating comment names in words and nothing had named in a number.
    if [ -s "$work/door.pens.txt" ]; then
      xargs_lines "$work/door.pens.txt" grep -LE 'git[[:space:]]+init' 2>/dev/null \
        | sort -u > "$work/door.norepo.txt" || : > "$work/door.norepo.txt"
    else
      : > "$work/door.norepo.txt"
    fi
    pen_files_no_repo=$(wc -l < "$work/door.norepo.txt" | tr -d ' ')

    sort -u "$work/door.files.txt" "$work/door.pens.txt" > "$work/door.union.txt"
    sweep_files=$(wc -l < "$work/door.union.txt" | tr -d ' ')

    # The proposal's two properties, measured. A replacement holding no tracked content repairs
    # nothing, and one occurring below the root stops the walk somewhere below the root.
    if [ -n "$(git ls-files -- "$SWEEP_TO" | head -1)" ]; then rep_tracked=yes; else rep_tracked=no; fi
    rep_below=$(git ls-files -- "*/$SWEEP_TO/*" \
      | awk -v t="$SWEEP_TO" '{ i = index($0, "/" t "/"); if (i > 1) print substr($0, 1, i - 1) }' \
      | sort -u | wc -l | tr -d ' ')

    # The track door: whether the name holds tracked content today, and which ignore rule denies
    # it. Two files -- the rule's allow-back and the one tracked file -- and no finder moves.
    tracked_today=$(git ls-files -- "$s" | wc -l | tr -d ' ')
    ignore_rule=$(git check-ignore -v -- "$s/.keep" 2>/dev/null | awk '{ print $1 }')
    [ -n "$ignore_rule" ] || ignore_rule=none

    echo "door sweep sentinel=$s to=$SWEEP_TO finder_sites=$finder_sites finder_files=$finder_files pen_files=$pen_files files=$sweep_files replacement_tracked=$rep_tracked replacement_below_root=$rep_below"
    echo "door track sentinel=$s tracked_today=$tracked_today ignore_rule=$ignore_rule finder_files=0 files=2"
    echo "door git_root sentinel=$s pen_files_no_repo=$pen_files_no_repo finder_files=$finder_files files=$sweep_files"
  done < "$work/classified.txt"
fi

echo "sources_tracked=$sources"
echo "candidates=$(wc -l < "$work/candidates.txt" | tr -d ' ')"
echo "finders=$finders"
echo "sentinels_distinct=$(wc -l < "$work/sentinels.txt" | tr -d ' ')"
echo "sentinels_build_output=$(awk -F'\t' '$2 == "build_output"' "$work/classified.txt" | wc -l | tr -d ' ')"
echo "sentinels_git_dir=$(awk -F'\t' '$2 == "git_dir"' "$work/classified.txt" | wc -l | tr -d ' ')"
echo "finders_bare_unrunnable=$bare"
echo "finders_worktree_fragile=$fragile"
echo "finders_ambiguous=$ambiguous"
echo "ceiling=$CEILING"
if [ "$bare" -gt "$CEILING" ]; then
  echo "verdict=over_ceiling"
else
  echo "verdict=ok"
fi
