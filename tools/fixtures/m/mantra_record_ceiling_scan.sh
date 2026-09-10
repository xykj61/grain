#!/bin/sh
# tools/fixtures/m/mantra_record_ceiling_scan.sh -- where does a record read off disk stop?
#
# WHAT THIS READS. `mantra/src/store.rye` bounds a blob in BYTES
# (`max_blob_bytes`, 1 << 27) and `mantra/src/weave.rye` bounds a weave in LINES
# (`max_weave_lines`, 1 << 20). The two ceilings stand on two units, and the
# conversion between them is what nobody had taken: a v2 row costs nine bytes at
# its shortest, so a blob standing UNDER the store's ceiling carries roughly
# fourteen times the lines a weave may hold. `read_v2_record` in main.rye
# appended every row of such a record and asserted the ceiling afterwards.
#
# WHAT THAT COST, measured on metal `20260910.034822` before the repair: a
# 15,666,516-byte store blob -- an eighth of the store's own ceiling -- made
# `mantra status` panic with `reached unreachable code` at exit 134, after
# allocating every one of its 1,048,600 rows. `Weave.from_v2` already refuses
# that record by name with `WeaveError.TooManyLines`; the assert fired first.
# `read_commit_v2`, sixty lines below in the same file, already made the right
# move against `max_commit_files` -- the law was written in this file's own hand.
#
# HOW THE READING IS TAKEN, and why it costs seconds rather than minutes. A
# record standing at the tree's real ceiling is 15 MB and takes minutes to read,
# so proving the fence from both sides at that size would price this guard out
# of a lap tier. Instead the scan builds the SAME reader twice with the ceiling
# lowered -- wide at 16 lines, narrow at 8 -- and has the wide binary WRITE the
# stores the narrow one reads. Every blob name is then an honest digest computed
# by Mantra itself, so no external hash tool is needed and no store is forged.
# The tree's real arithmetic is printed beside it, read off the two sources.
#
# BOTH DIRECTIONS. A fence that bites one row early is as wrong as one that never
# bites: `at_ceiling_reads` presses exactly there, over a store holding exactly
# the narrow ceiling's lines.
#
# THE ELDER READER IS READ AT ITS SOURCE, not driven. Nothing has written a
# `mantra-weave-v1` record since `20260909`, so this scan cannot make the wide
# binary produce one, and forging a v1 blob would need a SHA3-256 from outside
# the tree. `v1_reader_guarded` is therefore a reading of the source rather than
# of behavior, and it is named that way rather than dressed up.
#
# READINGS PRINTED, one per line, each a fact rather than a verdict:
#   built_wide=yes|no            a CLI at a 16-line ceiling compiled
#   built_narrow=yes|no          a CLI at an 8-line ceiling compiled
#   blob_ceiling_bytes=<n>       the tree's own `max_blob_bytes`
#   weave_ceiling_lines=<n>      the tree's own `max_weave_lines`
#   rows_under_blob_ceiling=<n>  those bytes at nine bytes a row
#   ceiling_gap=yes|no           the byte ceiling admits more rows than the line one
#   at_ceiling_reads=yes|no      a store of exactly the ceiling's lines still reads
#   overlong_refused=yes|no      a store one line past it is refused
#   refusal_named=yes|no         the refusal says TooManyLines
#   no_panic=yes|no              and it is not `reached unreachable code`
#   overlong_exit=<n>            the exit status of that refusal
#   v1_reader_guarded=yes|no     read_v1_rows carries the same edge refusal
#   lawful_roundtrip=yes|no      an ordinary add and status still work
#   verdict=ok|red
#
# ONE OPTIONAL ARGUMENT: a path to a `main.rye` to build instead of the tree's
# own, so the control can read a mutated CLI in a pen while the readings stay
# the tree's own shape.
#
# Run from the repository root. Driven by tools/m/mantra_record_ceiling_witness.rish.

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
src_dir="$(dirname "$main_src")"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

verdict=ok
note_red() { verdict=red; }

# The tree's own arithmetic, read off the two sources rather than typed here.
# A row of `1\t0\t0\t0\t\n` is nine bytes, which is the shortest a v2 row can be.
blob_bytes=$(sed -n 's/^pub const max_blob_bytes: u64 = 1 << \([0-9]*\);.*$/\1/p' "$root/mantra/src/store.rye" | head -1)
weave_lines=$(sed -n 's/^pub const max_weave_lines: u32 = 1 << \([0-9]*\);.*$/\1/p' "$root/mantra/src/weave.rye" | head -1)
if [ -n "$blob_bytes" ] && [ -n "$weave_lines" ]; then
  bb=$((1 << blob_bytes))
  wl=$((1 << weave_lines))
  rows=$((bb / 9))
  echo "blob_ceiling_bytes=$bb"
  echo "weave_ceiling_lines=$wl"
  echo "rows_under_blob_ceiling=$rows"
  if [ "$rows" -gt "$wl" ]; then echo "ceiling_gap=yes"; else echo "ceiling_gap=no"; fi
else
  echo "blob_ceiling_bytes=unread"
  echo "weave_ceiling_lines=unread"
  echo "rows_under_blob_ceiling=unread"
  echo "ceiling_gap=unread"
  note_red
fi

# The elder reader is read at its source: the same edge refusal, inside its loop.
if sed -n '/^fn read_v1_rows/,/^}/p' "$src_dir/main.rye" \
   | grep -q 'if (rows.items.len >= weave.max_weave_lines) return weave.WeaveError.TooManyLines;'; then
  echo "v1_reader_guarded=yes"
else
  echo "v1_reader_guarded=no"
  note_red
fi

# --- two binaries, one reader, two ceilings ---
build_at() {
  _ceil="$1"; _name="$2"
  _d="$work/$_name"
  mkdir -p "$_d"
  # -L follows the parse_int.rye symlink, so the pen holds a real file.
  cp -L "$src_dir"/main.rye "$src_dir"/weave.rye "$src_dir"/diff.rye \
        "$src_dir"/store.rye "$src_dir"/parse_int.rye "$_d/"
  sed_inplace "s|^pub const max_weave_lines: u32 = .*$|pub const max_weave_lines: u32 = $_ceil;|" \
    "$_d/weave.rye" || return 1
  grep -q "max_weave_lines: u32 = $_ceil;" "$_d/weave.rye" || return 1
  env RYE_ZIG="$zig" "$rye" build "$_d/main.rye" -femit-bin="$work/$_name.bin" >/dev/null 2>&1
}

if build_at 16 wide; then echo "built_wide=yes"; else echo "built_wide=no"; echo "verdict=red"; exit 0; fi
if build_at 8 narrow; then echo "built_narrow=yes"; else echo "built_narrow=no"; echo "verdict=red"; exit 0; fi

wide="$work/wide.bin"
narrow="$work/narrow.bin"

# A store of exactly `n` lines, written by the wide binary, whose digests are
# therefore Mantra's own.
write_store() {
  _pen="$1"; _n="$2"
  mkdir -p "$_pen"
  ( cd "$_pen" && awk -v n="$_n" 'BEGIN{for(i=0;i<n;i++) print "line" i}' > f.txt \
    && "$wide" init >/dev/null 2>&1 && "$wide" add f.txt >/dev/null 2>&1 )
}

# --- exactly at the narrow ceiling: the fence must not bite one row early ---
at_pen="$work/at"
write_store "$at_pen" 8 || note_red
at_out=$( cd "$at_pen" && "$narrow" status f.txt 2>&1 || true )
case "$at_out" in
  *TooManyLines*|*unreachable*) echo "at_ceiling_reads=no"; note_red ;;
  *) echo "at_ceiling_reads=yes" ;;
esac

# --- one line past it: refused, by name, without a panic ---
over_pen="$work/over"
write_store "$over_pen" 9 || note_red
over_out=$( cd "$over_pen" && "$narrow" status f.txt 2>&1 || true )
( cd "$over_pen" && "$narrow" status f.txt >/dev/null 2>&1 ) && over_exit=0 || over_exit=$?
echo "overlong_exit=$over_exit"
case "$over_out" in
  *TooManyLines*) echo "overlong_refused=yes"; echo "refusal_named=yes" ;;
  *unreachable*)  echo "overlong_refused=yes"; echo "refusal_named=no"; note_red ;;
  *)              echo "overlong_refused=no";  echo "refusal_named=no"; note_red ;;
esac
case "$over_out" in
  *unreachable*) echo "no_panic=no"; note_red ;;
  *)             echo "no_panic=yes" ;;
esac

# --- and an ordinary store still opens, adds, and reads clean ---
law_pen="$work/lawful"
write_store "$law_pen" 3 || note_red
law_out=$( cd "$law_pen" && "$wide" status f.txt 2>&1 || true )
case "$law_out" in
  *clean*) echo "lawful_roundtrip=yes" ;;
  *)       echo "lawful_roundtrip=no"; note_red ;;
esac

echo "verdict=$verdict"
