#!/bin/sh
# tools/fixtures/m/mantra_document_roundtrip_scan.sh -- does the store return the
# bytes it was handed?
#
# WHAT THIS READS. `split_lines` in `mantra/src/diff.rye` turns a text into
# lines. `cmd_add` in `mantra/src/main.rye` stores that split and nothing beside
# it -- a weave and a commit, never the file's own bytes. So what the split
# cannot tell apart, the store cannot tell apart.
#
# THE DEFECT, AND THE REPAIR. Until `20260917` the split broke its loop at the
# empty token a trailing `\n` leaves. So `x\ny` and `x\ny\n` split to one list of
# two lines. Measured on metal `20260910.043900`: two pens, two files one byte
# apart, one `mantra add` each. Both answered `HEAD -> 441c3c6fa8b8`. Both weaves
# carried the digest `7695a361c00e...`. One address, two contents. `mantra status`
# called the changed file **clean** in both directions, so the store declined the
# change even when asked for it. REDS %689 booked that. Keaton ruled door 2 on
# `20260916.000449`: a weave records the terminator as HISTORY. The repair landed
# once its sibling %680 closed. The split keeps that token now. Appending a
# newline is an INSERT; removing one is a DELETE.
#
# WHY EVERY READING BUT ONE IS GATED NOW. Seven readings below name the loss.
# Each was REPORTED while the repair wanted a ruling, since a gate that reds on
# what no lap may repair is a gate somebody turns off. The ruling came and the
# repair landed, so each is a wall. `raw_bytes_in_store` stays REPORTED. Door 3
# -- write the file's own bytes as a blob and name it in the commit -- was never
# taken, and it widens the `file` row when it is.
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
#   weave_digest_shared=yes|no      GATED -- the two files must NOT earn one weave name
#   commit_digest_shared=yes|no     GATED -- nor one commit name
#   add_sees_newline_added=yes|no   GATED -- add weaves when \n is appended
#   status_sees_newline_added=yes|no   GATED
#   add_sees_newline_removed=yes|no    GATED -- and when it is taken away
#   status_sees_newline_removed=yes|no GATED
#   terminator_invisible=yes|no     GATED -- the repaired seam, named in one word
#   raw_bytes_in_store=yes|no       reported -- door 3, never taken
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

# --- GATED: two documents, two addresses (REDS %689, repaired `20260917`) ---
tw="$(weave_name_in "$term")"
bw="$(weave_name_in "$bare")"
if [ -n "$tw" ] && [ "$tw" = "$bw" ]; then
  echo "weave_digest_shared=yes"
  note_red
else
  echo "weave_digest_shared=no"
fi
th="$(cat "$term/.mantra/HEAD" 2>/dev/null || echo none)"
bh="$(cat "$bare/.mantra/HEAD" 2>/dev/null || echo none)"
if [ "$th" != none ] && [ "$th" = "$bh" ]; then
  echo "commit_digest_shared=yes"
  note_red
else
  echo "commit_digest_shared=no"
fi

# --- GATED: the change the store records, from both sides ---
add="$work/add"
pen_with "$add" 'x\ny' || note_red
printf 'x\ny\n' > "$add/f.txt"
if ( cd "$add" && "$bin" status f.txt 2>&1 | grep -q -- '-- clean' ); then
  echo "status_sees_newline_added=no"
  note_red
else
  echo "status_sees_newline_added=yes"
fi
if ( cd "$add" && "$bin" add f.txt 2>&1 | grep -q '^mantra: wove' ); then
  echo "add_sees_newline_added=yes"
else
  echo "add_sees_newline_added=no"
  note_red
fi

rem="$work/rem"
pen_with "$rem" 'p\nq\n' || note_red
printf 'p\nq' > "$rem/f.txt"
if ( cd "$rem" && "$bin" status f.txt 2>&1 | grep -q -- '-- clean' ); then
  echo "status_sees_newline_removed=no"
  note_red
else
  echo "status_sees_newline_removed=yes"
fi
if ( cd "$rem" && "$bin" add f.txt 2>&1 | grep -q '^mantra: wove' ); then
  echo "add_sees_newline_removed=yes"
else
  echo "add_sees_newline_removed=no"
  note_red
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
  note_red
else
  echo "terminator_invisible=no"
fi

echo "verdict=$verdict"
