#!/bin/sh
# tools/fixtures/m/mantra_document_roundtrip_control.sh -- prove the roundtrip
# scan from the failing side, and price the first door on metal.
#
# WHY A CONTROL EXISTS. A refusal proven only in the passing direction cannot be
# told from a bypass. `mantra_document_roundtrip_scan.sh` reads a healthy tree
# and answers `verdict=ok`, so on its own it proves nothing about whether it can
# say anything else. This control copies `mantra/src/` into a pen, mutates one
# named line, and asserts the scan changes its answer.
#
# THE THIRD LEG IS THE ONE WORTH READING. Two legs break the CLI and watch the
# gate bite. The third applies **door 1** of the seam the scan reports -- keep
# the empty token a trailing `\n` produces, so `split_lines` becomes injective
# with a `\n` join -- and measures what that door actually costs: whether the two
# documents part, and how a line count moves. That turns a design choice named in
# prose into a reading somebody can weigh.
#
# READINGS PRINTED:
#   pen_built=yes|no                 the unmutated pen copy still builds
#   pen_baseline_ok=yes|no           and reads exactly as the tree does
#   frozen_add_bites=yes|no          a CLI that never weaves reds the gate
#   frozen_named=yes|no              and it is `lawful_change_seen` that says no
#   dirty_status_bites=yes|no        a CLI whose status never reads clean reds it
#   door1_builds=yes|no              the keep-the-token mutation compiles
#   door1_parts_digests=yes|no       and the two documents earn two weave names
#   door1_sees_newline_added=yes|no  and `add` weaves when a \n is appended
#   door1_line_count=<n>             lines a three-line terminated file reports
#   tree_line_count=<n>              what the tree reports for the same file
#   pass=<n> fail=<n>
#   control_verdict=ok|red
#
# Run from the repository root. Driven by tools/m/mantra_document_roundtrip_witness.rish.

set -eu

root="$(pwd)"
scan="$root/tools/fixtures/m/mantra_document_roundtrip_scan.sh"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# `sed -i` is a GNU spelling BSD sed refuses, so the portable helper does the
# in-place rewrite through the original inode -- the exec-bit law's own move.
. "$root/tools/fixtures/s/shell_portable.sh"

pass=0
fail=0
ok()   { pass=$((pass + 1)); echo "$1=yes"; }
bad()  { fail=$((fail + 1)); echo "$1=no"; }
claim() { if [ "$2" = "$3" ]; then ok "$1"; else bad "$1"; fi; }

# A fresh copy of the module under a pen root. Bare-name imports mean the whole
# directory travels together.
new_pen() {
  d="$work/$1"
  mkdir -p "$d"
  cp -L "$root/mantra/src/main.rye" "$root/mantra/src/weave.rye" \
        "$root/mantra/src/diff.rye" "$root/mantra/src/store.rye" \
        "$root/mantra/src/parse_int.rye" "$d/"
  echo "$d"
}

read_key() { sed -n "s/^$2=//p" "$1"; }

# --- leg 1: an unmutated pen copy reads exactly as the tree does ---
base="$(new_pen base)"
if sh "$scan" "$base/main.rye" > "$work/base.out" 2>&1; then
  case "$(read_key "$work/base.out" built)" in
    yes) ok pen_built ;;
    *)   bad pen_built ;;
  esac
else
  bad pen_built
fi
if [ "$(read_key "$work/base.out" verdict)" = ok ] \
   && [ "$(read_key "$work/base.out" terminator_invisible)" = yes ]; then
  ok pen_baseline_ok
else
  bad pen_baseline_ok
fi

# --- leg 2: a CLI that never weaves must red the gate, by name ---
frozen="$(new_pen frozen)"
sed_inplace 's/^    if (files_agree(prior_files, files)) {$/    if (true) {/' "$frozen/main.rye"
sh "$scan" "$frozen/main.rye" > "$work/frozen.out" 2>&1 || true
claim frozen_add_bites "$(read_key "$work/frozen.out" verdict)" red
claim frozen_named "$(read_key "$work/frozen.out" lawful_change_seen)" no

# --- leg 3: a CLI whose status never reads clean must red the gate ---
dirty="$(new_pen dirty)"
sed_inplace "s/-- clean\\\\n/-- unclean\\\\n/" "$dirty/main.rye"
sh "$scan" "$dirty/main.rye" > "$work/dirty.out" 2>&1 || true
if [ "$(read_key "$work/dirty.out" verdict)" = red ] \
   && [ "$(read_key "$work/dirty.out" terminated_roundtrip)" = no ]; then
  ok dirty_status_bites
else
  bad dirty_status_bites
fi

# --- leg 4: door 1 on metal -- keep the trailing empty token ---
door1="$(new_pen door1)"
sed_inplace 's|^        if (line.len == 0 and it.rest().len == 0) break;$|        // door 1, priced in a pen: the token is kept.|' \
  "$door1/diff.rye"
sh "$scan" "$door1/main.rye" > "$work/door1.out" 2>&1 || true
case "$(read_key "$work/door1.out" built)" in
  yes) ok door1_builds ;;
  *)   bad door1_builds ;;
esac
claim door1_parts_digests "$(read_key "$work/door1.out" weave_digest_shared)" no
claim door1_sees_newline_added "$(read_key "$work/door1.out" add_sees_newline_added)" yes

# What a three-line terminated file costs under each reading.
count_lines() {
  b="$work/$2.bin"
  if env RYE_ZIG="$zig" "$rye" build "$1" -femit-bin="$b" >/dev/null 2>&1; then
    p="$work/$2.pen"
    mkdir -p "$p"
    printf 'alpha\nbeta\ngamma\n' > "$p/f.txt"
    ( cd "$p" && "$b" init >/dev/null 2>&1 && "$b" add f.txt 2>&1 ) \
      | sed -n 's/.*-- +\([0-9]*\) -.*/\1/p'
  else
    echo unbuilt
  fi
}
echo "door1_line_count=$(count_lines "$door1/main.rye" d1count)"
echo "tree_line_count=$(count_lines "$base/main.rye" tcount)"

echo "pass=$pass fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
