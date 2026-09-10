#!/bin/sh
# tools/fixtures/m/mantra_idempotent_add_scan.sh -- does a second `mantra add` change anything?
#
# WHAT THIS READS. `foundations/20260823-222019_what-brix-infuse-is.md` states
# the tree's own claim about how change behaves: `infusion(world') -> world'`,
# so running a change twice does what running it once did. This scan drives the
# built Mantra CLI over one file in a throwaway pen, adds it three times with no
# edit in between, and compares the bytes of `.mantra/` after each run.
#
# WHY IT EXISTS. `cmd_add` wrote a commit blob and moved HEAD on every run. The
# weave is content-addressed, so the weave blob was already identical and the
# file list was the prior list entry for entry -- the new commit recorded that
# somebody ran the command. `mantra log` walks at most `max_log_depth` (1,000)
# commits, so a watcher calling `add` on a timer pushes the real first commit
# past the end of the log inside a day. Booked `20260910.024500`.
#
# WHY THE READING IS THE STORE'S BYTES. A commit count answers how the record is
# shaped, and a shape is free to change; the infusion claim is about the WORLD,
# so the reading hashes every file under `.mantra/` and asks whether the second
# run left what the first run left.
#
# THE OPPOSITE DIRECTION IS READ TOO, and it is the half a lazy guard forgets: a
# skip that fires too eagerly stops recording real work. `edit_commits` and
# `second_file_commits` press exactly there, and they are separate readings
# because a comparison that ignores the weave name and one that ignores the list
# length break them one apiece.
#
# READINGS PRINTED, one per line, each a fact rather than a verdict:
#   built=yes|no               the CLI compiled
#   store_stable=yes|no        `.mantra/` bytes identical after the second add
#   store_stable_third=yes|no  and after the third, so the answer is not a pair
#   head_stable=yes|no         HEAD names the same commit after all three
#   commits_after_three=<n>    commits the chain holds after three no-op adds
#   second_add_says=<words>    what the second run told the user
#   edit_commits=yes|no        a real edit still writes a commit and moves HEAD
#   edit_status_clean=yes|no   and the edited file reads clean afterward
#   second_file_commits=yes|no adding a NEW file still writes a commit
#   brix_stable=yes|no         the .brix add-all route run twice leaves the bytes
#   verdict=ok|red
#
# ONE OPTIONAL ARGUMENT: a path to a `main.rye` to build instead of the tree's
# own, so the control can read a mutated CLI in a pen while the readings stay
# the tree's.
#
# Run from the repository root. Driven by tools/m/mantra_idempotent_add_witness.rish.

set -eu

# The portable-dialect helpers, imported rather than restated. Root by upward
# walk (seated 20260828), so the letter fold's depth is never spelled here.
_sp_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_sp_steps=0
while [ ! -d "$_sp_root/rishi/bin" ] || [ ! -d "$_sp_root/tools/fixtures" ]; do
  _sp_steps=$((_sp_steps + 1))
  if [ "$_sp_steps" -gt 8 ] || [ "$_sp_root" = "/" ] || [ -z "$_sp_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _sp_root=$(dirname "$_sp_root")
done
. "$_sp_root/tools/fixtures/s/shell_portable.sh"

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
main_src="${1:-$root/mantra/src/main.rye}"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

bin="$work/mantra"
if env RYE_ZIG="$zig" "$rye" build "$main_src" -femit-bin="$bin" >/dev/null 2>&1; then
  echo "built=yes"
else
  echo "built=no"
  echo "verdict=red"
  exit 0
fi

verdict=ok
note_red() { verdict=red; }

# Every file under .mantra/, name and bytes together, folded to one digest. The
# names ride along because a run that wrote a new blob and left the old ones
# alone would otherwise read as stable.
store_digest() {
  ( cd "$1" && find .mantra -type f | LC_ALL=C sort | while IFS= read -r f; do
      printf '%s ' "$f"; cat "$f"; printf '\n'
    done ) | sha256sum | cut -d' ' -f1
}

commit_depth() {
  # `print` in Rye is `std.debug.print`, which writes to STDERR -- so the log
  # is read with 2>&1 rather than the 2>/dev/null a reader expects here.
  ( cd "$1" && "$bin" log 2>&1 | grep -c '^  commit ' ) || true
}

# --- one file, added three times, never edited ---
pen="$work/pen"
mkdir -p "$pen"
printf 'alpha\nbeta\ngamma\n' > "$pen/a.txt"
( cd "$pen" && "$bin" init >/dev/null 2>&1 && "$bin" add a.txt >/dev/null 2>&1 ) || note_red
d1=$(store_digest "$pen")
h1=$(cat "$pen/.mantra/HEAD" 2>/dev/null || echo "")

second_out=$( cd "$pen" && "$bin" add a.txt 2>&1 || true )
d2=$(store_digest "$pen")
( cd "$pen" && "$bin" add a.txt >/dev/null 2>&1 ) || note_red
d3=$(store_digest "$pen")
h3=$(cat "$pen/.mantra/HEAD" 2>/dev/null || echo "")

echo "second_add_says=$(printf '%s' "$second_out" | head -1)"
if [ "$d1" = "$d2" ]; then echo "store_stable=yes"; else echo "store_stable=no"; note_red; fi
if [ "$d1" = "$d3" ]; then echo "store_stable_third=yes"; else echo "store_stable_third=no"; note_red; fi
if [ -n "$h1" ] && [ "$h1" = "$h3" ]; then echo "head_stable=yes"; else echo "head_stable=no"; note_red; fi
echo "commits_after_three=$(commit_depth "$pen")"

# --- the opposite direction: a real edit must still land ---
# The edit APPENDS rather than replacing a middle line, and the choice is
# deliberate: `%680` stands OPEN over a replacement, where `Place.less_than`
# reads the run ahead of the position and the replaced line leaves the document.
# A pure append reads clean, so this leg measures the skip rather than
# re-measuring an open seam a peer's word owns.
printf 'alpha\nbeta\ngamma\ndelta\n' > "$pen/a.txt"
( cd "$pen" && "$bin" add a.txt >/dev/null 2>&1 ) || note_red
h4=$(cat "$pen/.mantra/HEAD" 2>/dev/null || echo "")
if [ -n "$h4" ] && [ "$h4" != "$h3" ]; then echo "edit_commits=yes"; else echo "edit_commits=no"; note_red; fi
edit_out=$( cd "$pen" && "$bin" status a.txt 2>&1 || true )
case "$edit_out" in *clean*) echo "edit_status_clean=yes" ;; *) echo "edit_status_clean=no"; note_red ;; esac

# --- and a NEW path must still land, which is a different break ---
printf 'one\ntwo\n' > "$pen/b.txt"
( cd "$pen" && "$bin" add b.txt >/dev/null 2>&1 ) || note_red
h5=$(cat "$pen/.mantra/HEAD" 2>/dev/null || echo "")
if [ -n "$h5" ] && [ "$h5" != "$h4" ]; then echo "second_file_commits=yes"; else echo "second_file_commits=no"; note_red; fi

# --- the .brix add-all route, run twice over files nobody edited ---
bpen="$work/brixpen"
mkdir -p "$bpen"
printf 'alpha\nbeta\n' > "$bpen/a.txt"
printf 'one\ntwo\n'    > "$bpen/b.txt"
printf 'name pen\nversion 20260910\nfile a.txt\nfile b.txt\n' > "$bpen/.brix"
( cd "$bpen" && "$bin" init >/dev/null 2>&1 && "$bin" add >/dev/null 2>&1 ) || note_red
b1=$(store_digest "$bpen")
( cd "$bpen" && "$bin" add >/dev/null 2>&1 ) || note_red
b2=$(store_digest "$bpen")
if [ "$b1" = "$b2" ]; then echo "brix_stable=yes"; else echo "brix_stable=no"; note_red; fi

echo "verdict=$verdict"
