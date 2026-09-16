#!/bin/sh
# tools/fixtures/b/built_tool_freshness_scan.sh -- the two binaries every witness runs through are
# the two nothing checked for staleness.
#
# WHY. `rye/bin/` and `rishi/bin/` are gitignored, so a clone carries no binary and a pull carries
# no rebuild. On 20260915 a seat rebased onto a commit that added the field `out_brief` to
# `rishi/src/main.rye`, did not rebuild, and watched two healthy peer witnesses die with
# `rishi: line 38: NoSuchField` -- a hard error attributed to whatever the interpreter happened to
# be running. The tree was correct; the binary was ten days behind its own source (REDS %746).
#
# The nearest standing guard is `tools/fixtures/w/witness_own_build_scan.sh`, and it passes both
# binaries free on a named reason that is exactly right about the thing it checks: *if either is
# absent nothing runs at all, so their presence is a bootstrap fact rather than a promise any
# single witness makes.* That is a statement about PRESENCE. Freshness is a second question
# wearing the same skip, and a present binary arbitrarily far behind its own source runs every
# guard on the ship.
#
# WHAT IS GATED, hard. Every declared tool whose binary stands on disk was modified no earlier
# than the newest TRACKED source in its module. One stale tool refuses, names the source that
# outran it, and prints the one command that repairs it.
#
# WHAT IS REPORTED, never gated.
#   An ABSENT binary. A fresh clone has none, and the bootstrap is the documented first step --
#   refusing there would red on the one state the tree already tells a newcomer to expect.
#   Whether `rishi` is older than the `rye` that compiles it. A compiler change reaches `rishi`
#   only on the next `rishi` build, and that chain is real; gating it would refuse every ship for
#   the minutes between the two builds, which is a guard somebody turns off.
#
# WHAT THIS READS, and its honest limit. Modification time, against the tracked sources of the
# module -- one `git ls-files` and one `find -newer` per tool. Untracked scratch beside a source
# is read past deliberately, so a stray file cannot red a healthy tree.
#
# The limit is that mtime answers *later*, never *different*. A checkout that rewrites a source to
# byte-identical content moves its mtime and reads stale when nothing changed; the cost of that
# false positive is one rebuild, and the false NEGATIVE it avoids is a whole fleet attributing
# phantom errors to the tree. `touch` fools it, and so does a clock moved backward. A content
# digest would answer *different*, and it wants the build to record one beside the binary, which
# is a compiler change rather than a reading.
#
# WHY THIS IS PLAIN SHELL RATHER THAN RISHI. The subject of the reading is the interpreter the
# witness half runs under. A `rishi` stale enough to matter is a `rishi` that may refuse to parse
# the guard that would have named it, so the whole reading lives where it can always run.
#
# USAGE
#   sh tools/fixtures/b/built_tool_freshness_scan.sh
#
# Driven by tools/b/built_tool_freshness_witness.rish. Run from the repository root.

set -u

# One dialect for both piers. `file_mtime` is the portable spelling of a modification time: GNU
# spells the field `stat -c %.Y` and BSD, which is what macOS ships, spells it `stat -f %Fm`, and
# reaching for either directly is the GNU-only idiom `shell_dialect` gates at zero. Root by upward
# walk, the same one every fixture here uses -- the letter fold moves a script's depth, and fixed
# `../..` arithmetic is what breaks. Bounded at 8 steps, loud past the bound.
_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/shell_portable.sh"

# THE DECLARATION -- one line per tool: name, binary, module source directory, repair command.
# Read as a table rather than as code, so adding a third built tool is one line.
tools='rye|rye/bin/rye|rye/src|sh rye/bootstrap.sh
rishi|rishi/bin/rishi|rishi/src|rye/bin/rye build rishi/src/main.rye -femit-bin=rishi/bin/rishi'

declared=0
absent=0
fresh=0
stale=0

# An instrument that cannot answer REFUSES rather than passing. `git ls-files` outside a repository
# returns nothing, which this reading would otherwise take as "no source is newer than the binary"
# and call every tool fresh -- a silent green on the one state where it knows least.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "tools_declared=0"
  echo "verdict=no_repository"
  echo "refused: this reading asks the index which sources are the module's -- run it from inside the tree" >&2
  exit 2
fi

work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT INT TERM

# The newest tracked source under a directory that is strictly newer than a reference file.
# `git ls-files` keeps the reading about the repository: untracked scratch beside a module's
# sources is not what the binary was built from.
newer_sources() {
  dir=$1; ref=$2
  git ls-files "$dir" 2>/dev/null | while IFS= read -r f; do
    [ -f "$f" ] || continue
    found=$(find "$f" -newer "$ref" 2>/dev/null)
    [ -n "$found" ] && echo "$f"
  done
}

mtime_of() {
  # `file_mtime` answers in fractional seconds on both piers; the whole part is what a distance
  # in seconds wants, and a fractional remainder would only make the number harder to read.
  m=$(file_mtime "$1" 2>/dev/null) || m=0
  [ -n "$m" ] || m=0
  echo "${m%%.*}"
}

: > "$work/stale.txt"

echo "$tools" | while IFS='|' read -r name bin src repair; do
  [ -n "$name" ] || continue
  if [ ! -f "$bin" ]; then
    echo "tool=$name binary=$bin verdict=absent"
    echo absent >> "$work/tally"
    continue
  fi
  newer_sources "$src" "$bin" > "$work/newer.$name"
  if [ -s "$work/newer.$name" ]; then
    top=$(head -1 "$work/newer.$name")
    bin_m=$(mtime_of "$bin")
    src_m=$(mtime_of "$top")
    behind=$((src_m - bin_m))
    echo "tool=$name binary=$bin verdict=stale outran_by=$(wc -l < "$work/newer.$name" | tr -d ' ') newest_source=$top behind_seconds=$behind"
    echo "repair: $name is $behind seconds behind $top -- $repair" >> "$work/stale.txt"
    echo stale >> "$work/tally"
  else
    echo "tool=$name binary=$bin verdict=fresh"
    echo fresh >> "$work/tally"
  fi
done

# The loop above runs in a subshell of the pipe, so the tallies come back off disk.
[ -f "$work/tally" ] || : > "$work/tally"
declared=$(wc -l < "$work/tally" | tr -d ' ')
absent=$(grep -c '^absent$' "$work/tally" || true)
fresh=$(grep -c '^fresh$' "$work/tally" || true)
stale=$(grep -c '^stale$' "$work/tally" || true)

# REPORTED: the compiler chain. `rishi` is built BY `rye`, so a `rye` newer than `rishi` means a
# codegen change has yet to reach the interpreter. Real, and not a fault on its own.
chain=no
if [ -f rishi/bin/rishi ] && [ -f rye/bin/rye ] && [ -n "$(find rye/bin/rye -newer rishi/bin/rishi 2>/dev/null)" ]; then
  chain=yes
fi

echo "tools_declared=$declared"
echo "tools_absent=$absent"
echo "tools_fresh=$fresh"
echo "tools_stale=$stale"
echo "rishi_older_than_compiler=$chain"

[ "$stale" -eq 0 ] || cat "$work/stale.txt"

if [ "$stale" -eq 0 ]; then
  echo "verdict=ok"
  exit 0
fi
echo "verdict=stale_tool"
echo "refused: a built tool is older than its own source -- every guard it runs may read falsely" >&2
exit 1
