#!/bin/sh
# tools/fixtures/m/mantra_document_roundtrip_scan.sh -- does the store return the
# bytes it was handed?
#
# WHAT THIS READS. `mantra/src/diff.rye` `split_lines` drops the empty token a
# text ending in `\n` produces, and a text that does NOT end in `\n` produces no
# such token at all. So `x\ny` and `x\ny\n` split to the same two lines, and the
# CLI stores only that split: `cmd_add` in `mantra/src/main.rye` writes a weave
# and a commit, never the file's own bytes. One byte of the document has no home
# in the store.
#
# WHAT THAT COSTS, measured on metal `20260910.043900`. Two pens, two files
# differing by exactly the final newline, one `mantra add` each: both answer
# `HEAD -> 441c3c6fa8b8` and both weaves carry the digest
# `7695a361c00ecf2140b9fd60624cc0919c92437933c4f175b486d846daa8b3f1`. A
# content-addressed store gave one address to two contents. Worse than a display
# fault: `mantra status` calls the changed file **clean** and `mantra add`
# answers `unchanged -- nothing to weave`, so the store cannot record the change
# even when asked directly, in either direction.
#
# WHY THIS SCAN GATES SOME READINGS AND REPORTS OTHERS. The loss is a design
# seam with three doors, and each costs something a lap may not spend alone:
#   1. Keep the trailing empty token, and `split_lines` becomes injective with a
#      `\n` join at no format cost -- every terminated file then carries one more
#      line, so every existing weave drifts by one on its next add.
#   2. Carry a terminator flag beside the lines -- a field on the v2 counter row
#      or the commit's `file` row, which is a record-format change.
#   3. Write the file's own bytes as a blob and name it in the commit -- the
#      store is content-addressed already, and this too widens the `file` row.
# So the readings a repair must not break are GATED, and the loss itself is
# REPORTED by name under the row of `20260910.043900`. A gate that reds on what
# no lap may repair is a gate somebody turns off.
#
# BOTH DIRECTIONS. `lawful_change_seen` presses from the passing side: an
# ordinary edit to a line's text IS woven and IS reported by status. A guard that
# only ever says `no` cannot be told from a broken binary.
#
# READINGS PRINTED, one per line, each a fact rather than a verdict:
#   built=yes|no                    the tree's own CLI compiled
#   lawful_change_seen=yes|no       GATED -- an ordinary text edit is woven
#   lawful_status_seen=yes|no       GATED -- and status reports it
#   terminated_roundtrip=yes|no     GATED -- a file ending in \n reads back clean
#   bare_roundtrip=yes|no           GATED -- a file NOT ending in \n reads back clean
#   weave_digest_shared=yes|no      reported -- both files earn one weave name
#   commit_digest_shared=yes|no     reported -- and one commit name
#   add_sees_newline_added=yes|no   reported -- add weaves when \n is appended
#   status_sees_newline_added=yes|no   reported
#   add_sees_newline_removed=yes|no    reported -- and when it is taken away
#   status_sees_newline_removed=yes|no reported
#   raw_bytes_in_store=yes|no       reported -- the file's own bytes are a blob
#   terminator_invisible=yes|no     reported -- the seam, named in one word
#   verdict=ok|red
#
# ONE OPTIONAL ARGUMENT: a path to a `main.rye` to build instead of the tree's
# own, so a control can read a mutated CLI in a pen while the readings stay this
# shape.
#
# Run from the repository root. Driven by tools/m/mantra_document_roundtrip_witness.rish.

set -eu

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

# The weave blob a pen's store holds, by its own header line.
weave_name_in() {
  for b in "$1"/.mantra/blobs/*; do
    [ -f "$b" ] || continue
    case "$(head -1 "$b")" in mantra-weave-*) basename "$b" ;; esac
  done
}

# A pen holding one file of the given bytes, added once. $1 pen, $2 the printf
# format that writes the file.
pen_with() {
  mkdir -p "$1"
  # shellcheck disable=SC2059
  printf "$2" > "$1/f.txt"
  ( cd "$1" && "$bin" init >/dev/null 2>&1 && "$bin" add f.txt >"$1/add.out" 2>&1 )
}

# --- GATED: an ordinary edit is seen, so a `no` below means something ---
lawful="$work/lawful"
pen_with "$lawful" 'alpha\nbeta\ngamma\n' || note_red
printf 'alpha\nBETA\ngamma\n' > "$lawful/f.txt"
if ( cd "$lawful" && "$bin" add f.txt 2>&1 | grep -q '^mantra: wove' ); then
  echo "lawful_change_seen=yes"
else
  echo "lawful_change_seen=no"
  note_red
fi
printf 'alpha\nGAMMA\ngamma\n' > "$lawful/f.txt"
if ( cd "$lawful" && "$bin" status f.txt 2>&1 | grep -q 'added' ); then
  echo "lawful_status_seen=yes"
else
  echo "lawful_status_seen=no"
  note_red
fi

# --- GATED: each file reads back clean against its own stored weave ---
term="$work/term"
pen_with "$term" 'x\ny\n' || note_red
if ( cd "$term" && "$bin" status f.txt 2>&1 | grep -q -- '-- clean' ); then
  echo "terminated_roundtrip=yes"
else
  echo "terminated_roundtrip=no"
  note_red
fi

bare="$work/bare"
pen_with "$bare" 'x\ny' || note_red
if ( cd "$bare" && "$bin" status f.txt 2>&1 | grep -q -- '-- clean' ); then
  echo "bare_roundtrip=yes"
else
  echo "bare_roundtrip=no"
  note_red
fi

# --- REPORTED: two documents, one address ---
tw="$(weave_name_in "$term")"
bw="$(weave_name_in "$bare")"
if [ -n "$tw" ] && [ "$tw" = "$bw" ]; then
  echo "weave_digest_shared=yes"
else
  echo "weave_digest_shared=no"
fi
th="$(cat "$term/.mantra/HEAD" 2>/dev/null || echo none)"
bh="$(cat "$bare/.mantra/HEAD" 2>/dev/null || echo none)"
if [ "$th" != none ] && [ "$th" = "$bh" ]; then
  echo "commit_digest_shared=yes"
else
  echo "commit_digest_shared=no"
fi

# --- REPORTED: the change the store cannot record, from both sides ---
add="$work/add"
pen_with "$add" 'x\ny' || note_red
printf 'x\ny\n' > "$add/f.txt"
if ( cd "$add" && "$bin" status f.txt 2>&1 | grep -q -- '-- clean' ); then
  echo "status_sees_newline_added=no"
else
  echo "status_sees_newline_added=yes"
fi
if ( cd "$add" && "$bin" add f.txt 2>&1 | grep -q '^mantra: wove' ); then
  echo "add_sees_newline_added=yes"
else
  echo "add_sees_newline_added=no"
fi

rem="$work/rem"
pen_with "$rem" 'p\nq\n' || note_red
printf 'p\nq' > "$rem/f.txt"
if ( cd "$rem" && "$bin" status f.txt 2>&1 | grep -q -- '-- clean' ); then
  echo "status_sees_newline_removed=no"
else
  echo "status_sees_newline_removed=yes"
fi
if ( cd "$rem" && "$bin" add f.txt 2>&1 | grep -q '^mantra: wove' ); then
  echo "add_sees_newline_removed=yes"
else
  echo "add_sees_newline_removed=no"
fi

# --- REPORTED: are the file's own bytes anywhere in the store? ---
found=no
for b in "$bare"/.mantra/blobs/*; do
  [ -f "$b" ] || continue
  if cmp -s "$b" "$bare/f.txt"; then found=yes; fi
done
echo "raw_bytes_in_store=$found"

if [ "$tw" = "$bw" ]; then
  echo "terminator_invisible=yes"
else
  echo "terminator_invisible=no"
fi

echo "verdict=$verdict"
