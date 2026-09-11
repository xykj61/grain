#!/bin/sh
# tools/fixtures/m/mantra_annotate_cli_scan.sh -- what story does the CLI tell about one file?
#
# WHAT THIS READS. `mantra/src/weave.rye` publishes `Weave.annotate`, which
# reads two weaves side by side and answers what each side did at every
# position. Until `mantra annotate` landed, that reading was reachable only
# from Rye: the CLI offered `status`, which answers HOW MANY lines moved, and
# nothing that answers what each line DID. This scan drives the built CLI in a
# throwaway pen and reads the story it prints.
#
# WHY THE PEN IS A DIRECTORY OF ITS OWN, and why the binary is built into it:
# `tools/m/mantra_recall_tablecloth_query_wire.rish` builds into fixed paths
# under `mantra/bin/` and answered red then green on one unchanged tree with
# eight ships' passes running beside it (REDS %700). A pen per run cannot meet
# a peer halfway through its own build.
#
# THE READINGS, one per line, each a fact rather than a verdict:
#   built=yes|no              the CLI compiled
#   clean_summary=<words>     the summary line over a file nobody edited
#   clean_shows_text=yes|no   an unchanged line comes back with its own text
#   clean_unchanged=<n>       lines the two sides both hold
#   edit_added=<n>            lines the working file added, appended
#   edit_removed=<n>          lines it removed
#   edit_shows_plus=yes|no    the added line carries the `+` mark
#   drop_removed=<n>          a line taken out of the working file
#   drop_shows_minus=yes|no   and it carries the `-` mark with its own text
#   tombstone_hidden=yes|no   a line deleted in a PAST commit stays unprinted
#   repeat_identical=yes|no   two runs over one state print the same bytes
#   store_untouched=yes|no    `.mantra/` holds the same bytes after a reading
#   head_untouched=yes|no     and HEAD names the same commit
#   absent_file_code=<n>      the exit code for a path that is not there
#   no_store_code=<n>         the exit code before `mantra init` has run
#   verdict=ok|red
#
# ONE OPTIONAL ARGUMENT: a path to a `main.rye` to build instead of the tree's
# own, so the control can read a mutated CLI while the readings stay this
# scan's.
#
# THE EDITS APPEND AND DROP THE LAST LINE, deliberately. `%680` stands OPEN over
# a REPLACEMENT, where `Place.less_than` reads the run ahead of the position and
# the replaced line leaves the document. Pressing there would re-measure a seam
# awaiting Keaton's word rather than measure this reading.
#
# Run from the repository root. Driven by tools/m/mantra_annotate_cli_witness.rish.

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

# `print` in Rye is `std.debug.print`, which writes to STDERR, so every reading
# below captures 2>&1 rather than the 2>/dev/null a reader expects here.
annotate() { ( cd "$1" && "$bin" annotate "$2" 2>&1 || true ); }

# Every file under .mantra/, name and bytes together, folded to one digest. The
# names ride along because a run that wrote a new blob and left the old ones
# alone would otherwise read as stable.
store_digest() {
  ( cd "$1" && find .mantra -type f | LC_ALL=C sort | while IFS= read -r f; do
      printf '%s ' "$f"; cat "$f"; printf '\n'
    done ) | sha256sum | cut -d' ' -f1
}

count_field() { printf '%s\n' "$1" | sed -n "s/.*-- \([0-9]*\) unchanged, \([0-9]*\) added, \([0-9]*\) removed.*/\\$2/p" | head -1; }

pen="$work/pen"
mkdir -p "$pen"
printf 'alpha\nbeta\ngamma\n' > "$pen/a.txt"
( cd "$pen" && "$bin" init >/dev/null 2>&1 && "$bin" add a.txt >/dev/null 2>&1 ) || note_red

# --- a file nobody edited: every line unchanged, and every line shown ---
d_before=$(store_digest "$pen")
h_before=$(cat "$pen/.mantra/HEAD" 2>/dev/null || echo "")
clean_out=$(annotate "$pen" a.txt)
echo "clean_summary=$(printf '%s' "$clean_out" | sed -n 's/^mantra annotate: //p' | head -1)"
case "$clean_out" in *'  beta'*) echo "clean_shows_text=yes" ;; *) echo "clean_shows_text=no"; note_red ;; esac
echo "clean_unchanged=$(count_field "$clean_out" 1)"

# --- a reading writes nothing ---
d_after=$(store_digest "$pen")
h_after=$(cat "$pen/.mantra/HEAD" 2>/dev/null || echo "")
if [ "$d_before" = "$d_after" ]; then echo "store_untouched=yes"; else echo "store_untouched=no"; note_red; fi
if [ -n "$h_before" ] && [ "$h_before" = "$h_after" ]; then echo "head_untouched=yes"; else echo "head_untouched=no"; note_red; fi

# --- running the same reading twice prints the same bytes ---
repeat_out=$(annotate "$pen" a.txt)
if [ "$clean_out" = "$repeat_out" ]; then echo "repeat_identical=yes"; else echo "repeat_identical=no"; note_red; fi

# --- the working file appends a line ---
printf 'alpha\nbeta\ngamma\ndelta\n' > "$pen/a.txt"
edit_out=$(annotate "$pen" a.txt)
echo "edit_added=$(count_field "$edit_out" 2)"
echo "edit_removed=$(count_field "$edit_out" 3)"
case "$edit_out" in *'+ delta'*) echo "edit_shows_plus=yes" ;; *) echo "edit_shows_plus=no"; note_red ;; esac

# --- the working file drops a line ---
printf 'alpha\nbeta\n' > "$pen/a.txt"
drop_out=$(annotate "$pen" a.txt)
echo "drop_removed=$(count_field "$drop_out" 3)"
case "$drop_out" in *'- gamma'*) echo "drop_shows_minus=yes" ;; *) echo "drop_shows_minus=no"; note_red ;; esac

# --- a line deleted in a PAST commit stays out of the reading ---
( cd "$pen" && "$bin" add a.txt >/dev/null 2>&1 ) || note_red
tomb_out=$(annotate "$pen" a.txt)
case "$tomb_out" in *gamma*) echo "tombstone_hidden=no"; note_red ;; *) echo "tombstone_hidden=yes" ;; esac

# --- the two refusals, each named rather than crashed ---
# `set -e` would end the scan on a refusal, so each code is read inside an `if`
# -- the refusals are the subject here rather than an accident.
if ( cd "$pen" && "$bin" annotate nosuch.txt >/dev/null 2>&1 ); then
  echo "absent_file_code=0"
else
  echo "absent_file_code=$?"
fi
bare="$work/bare"
mkdir -p "$bare"
printf 'one\n' > "$bare/b.txt"
if ( cd "$bare" && "$bin" annotate b.txt >/dev/null 2>&1 ); then
  echo "no_store_code=0"
else
  echo "no_store_code=$?"
fi

echo "verdict=$verdict"
