#!/bin/sh
# tools/fixtures/m/mantra_multifile_scan.sh -- does a second tracked file keep the first one's history?
#
# WHAT THIS READS. `mantra add` with no argument walks the `file` rows of a
# .brix descriptor and weaves each one, which is the tool's own advertised
# route for a project of more than one source. This scan drives the built
# binary over exactly that route in a throwaway pen and then asks the store
# what it kept.
#
# WHY IT EXISTS. The store held ONE weave for a whole directory, so
# `cmd_add` loaded that weave, diffed the next file against it, and applied
# the difference -- which deletes every line of the file added before. Two
# files meant the second erased the first, and the CLI reported
# `wove 2/2 file(s).` while it happened. Booked `20260910.003046`.
#
# WHY THE READING IS `status` RATHER THAN A BLOB COUNT. A blob count answers
# how the record is shaped, and the shape is free to change; what a user is
# promised is that a file nobody edited reads clean. So the readings below
# ask the tool the user's own question, on a file the pen never touched
# after weaving it.
#
# READINGS PRINTED, one per line, each a fact rather than a verdict:
#   built=yes|no              the CLI compiled
#   first_clean=yes|no        the FIRST file added reads clean afterward
#   last_clean=yes|no         the LAST file added reads clean afterward
#   first_status=<words>      what `status` says about that untouched first file
#   brix_first_clean=yes|no   the same question down the .brix add-all route
#   brix_files=<n>            how many files that route wove
#   weave_blobs=<n>           weave-headed blobs the store holds after both adds
#   commit_header=<line 0>    the header the newest commit blob carries
#   elder_opens=yes|no        the frozen v1 store still reads back
#   verdict=ok|red
#
# ONE OPTIONAL ARGUMENT: a path to a `main.rye` to build instead of the
# tree's own, so the control can read a mutated CLI in a pen while the
# readings and the frozen elder store stay the tree's.
#
# Run from the repository root. Driven by tools/m/mantra_multifile_witness.rish.

set -eu

# The portable-dialect helpers, imported rather than restated: `sed -i` is a GNU spelling that
# reads as an empty edit on the other pier, where an empty reading counts as a healthy zero.
# Root by upward walk (seated 20260828), so the letter fold's depth is never spelled here.
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
elder="$root/tools/fixtures/m/mantra_elder_v1_store"
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

# --- two files, added one at a time, neither edited after ---
pen="$work/pen"
mkdir -p "$pen"
printf 'alpha\nbeta\n' > "$pen/a.txt"
printf 'one\ntwo\n'    > "$pen/b.txt"
( cd "$pen" && "$bin" init >/dev/null 2>&1 && "$bin" add a.txt >/dev/null 2>&1 && "$bin" add b.txt >/dev/null 2>&1 ) || note_red

first_out=$( cd "$pen" && "$bin" status a.txt 2>&1 || true )
last_out=$(  cd "$pen" && "$bin" status b.txt 2>&1 || true )
echo "first_status=$(printf '%s' "$first_out" | head -1)"
case "$first_out" in *clean*) echo "first_clean=yes" ;; *) echo "first_clean=no"; note_red ;; esac
case "$last_out"  in *clean*) echo "last_clean=yes"  ;; *) echo "last_clean=no";  note_red ;; esac

weave_blobs=0
for b in "$pen"/.mantra/blobs/*; do
  [ -f "$b" ] || continue
  case "$(head -1 "$b")" in mantra-weave-*) weave_blobs=$((weave_blobs + 1)) ;; esac
done
echo "weave_blobs=$weave_blobs"

head_name=$(cat "$pen/.mantra/HEAD" 2>/dev/null || echo "")
if [ -n "$head_name" ] && [ -f "$pen/.mantra/blobs/$head_name" ]; then
  echo "commit_header=$(head -1 "$pen/.mantra/blobs/$head_name")"
else
  echo "commit_header=none"
  note_red
fi

# --- the same question down the .brix add-all route ---
bpen="$work/brixpen"
mkdir -p "$bpen"
printf 'alpha\nbeta\n' > "$bpen/a.txt"
printf 'one\ntwo\n'    > "$bpen/b.txt"
printf 'name pen\nversion 20260910\nfile a.txt\nfile b.txt\n' > "$bpen/.brix"
brix_out=$( cd "$bpen" && "$bin" init >/dev/null 2>&1; cd "$bpen" && "$bin" add 2>&1 || true )
echo "brix_files=$(printf '%s' "$brix_out" | grep -c "^mantra: wove '" || true)"
brix_first=$( cd "$bpen" && "$bin" status a.txt 2>&1 || true )
case "$brix_first" in *clean*) echo "brix_first_clean=yes" ;; *) echo "brix_first_clean=no"; note_red ;; esac

# --- the frozen elder store: does a v1 commit still open? ---
old="$work/old"
mkdir -p "$old/.mantra"
cp -r "$elder/HEAD" "$elder/blobs" "$old/.mantra/"
cp "$elder/doc.txt" "$old/doc.txt"
if ( cd "$old" && "$bin" status doc.txt >"$work/old.out" 2>&1 ); then
  case "$(cat "$work/old.out")" in
    *clean*) echo "elder_opens=yes" ;;
    *)       echo "elder_opens=no"; note_red ;;
  esac
else
  echo "elder_opens=no"
  note_red
fi

echo "verdict=$verdict"
