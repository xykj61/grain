#!/bin/sh
# tools/fixtures/m/mantra_document_roundtrip_control.sh -- prove the roundtrip
# scan from the failing side, and price the first door on metal.
#
# WHY A CONTROL EXISTS. A refusal proven only in the passing direction cannot be
# told from a bypass. The scan beside it reads a healthy tree and answers
# `verdict=ok`. On its own that proves nothing about whether it can say anything
# else. So this control copies `mantra/src/` into a pen, mutates one named line,
# and asserts the scan changes its answer.
#
# THE FOURTH LEG IS THE ONE WORTH READING. Two legs break the CLI and watch the
# gate bite. The fourth restores the ELDER split rule -- the break that dropped
# the empty token a trailing `\n` leaves. Then it watches the closed defect
# reappear whole: one weave name for two documents, one commit name, `add` blind
# to an appended newline, and the seam reading invisible again. REDS %689 was
# repaired on `20260917`, so this pen is the one place its shape can still be
# seen. It prices the repair too. The same three-line terminated file reports
# four lines here and three there.
#
# READINGS PRINTED:
#   pen_built=yes|no                 the unmutated pen copy still builds
#   pen_baseline_ok=yes|no           and reads exactly as the tree does
#   frozen_add_bites=yes|no          a CLI that never weaves reds the gate
#   frozen_named=yes|no              and it is `lawful_change_seen` that says no
#   dirty_status_bites=yes|no        a CLI whose status never reads clean reds it
#   elder_drop_planted=yes|no        the plant named a line the module still has
#   elder_drop_builds=yes|no         the restored elder drop compiles
#   elder_drop_shares_weave=yes|no   and the two documents fall back to one weave name
#   elder_drop_shares_commit=yes|no  and one commit name
#   elder_drop_blind_to_add=yes|no   and `add` stops seeing an appended \n
#   elder_drop_hides_seam=yes|no     and the seam reading goes invisible again
#   elder_drop_reds_scan=yes|no      and the scan reaches its own red
#   elder_drop_keeps_lawful=yes|no   while an ordinary edit is still woven
#   clean_status_planted=yes|no      the always-clean plant named a line the CLI still has
#   clean_status_builds=yes|no       and it compiles
#   clean_status_flips_roundtrip=yes|no  head_insert_roundtrip can answer yes
#   clean_status_flips_move=yes|no   and head_insert_reports_move can answer no
#   clean_status_bites=yes|no        while the gate names the pen broken
#   clean_status_keeps_woven=yes|no  and the head insert is still woven
#   head_insert_position=<n>         where a head insert lands in the tree's own annotate
#   elder_drop_line_count=<n>        lines a three-line terminated file reports there
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
# The plant law, imported rather than restated: a sed naming a line of the real
# source is a CLAIM that the line is spelled that way today, and `plant_apply`
# refuses by name when it is not (REDS %519).
. "$root/tools/fixtures/p/plant.sh"

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
# The baseline asserts the repaired reading rather than the elder one: the
# terminator is VISIBLE in a healthy tree from `20260917`, so a pen answering
# `yes` here is a pen that lost the repair rather than one that copied it.
if [ "$(read_key "$work/base.out" verdict)" = ok ] \
   && [ "$(read_key "$work/base.out" terminator_invisible)" = no ]; then
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

# --- leg 4: the elder drop restored, so the closed defect is shown reappearing ---
#
# RE-AIMED `20260917`. This leg used to apply door 1 in a pen and price it, while
# the tree still dropped the token. The repair landed, so the pen now runs the
# other way: it restores the elder break and watches all four walls fall at once.
# A wall proven only by a healthy tree cannot be told from a constant.
#
# The plant is applied through `plant_apply` rather than a bare `sed`, so a line
# that moves is refused by name instead of leaving the pen byte-identical and
# reading the UNMUTATED module's answer as a law that holds -- which is exactly
# what this leg's own elder sed did the hour the repair landed (REDS %519).
elder="$(new_pen elder_drop)"
if plant_apply "$elder/diff.rye" \
  '/    while (it.next()) |line| {/a\        if (line.len == 0 and it.rest().len == 0) break;' \
  elder_drop; then
  ok elder_drop_planted
else
  bad elder_drop_planted
fi
sh "$scan" "$elder/main.rye" > "$work/elder.out" 2>&1 || true
case "$(read_key "$work/elder.out" built)" in
  yes) ok elder_drop_builds ;;
  *)   bad elder_drop_builds ;;
esac
claim elder_drop_shares_weave  "$(read_key "$work/elder.out" weave_digest_shared)" yes
claim elder_drop_shares_commit "$(read_key "$work/elder.out" commit_digest_shared)" yes
claim elder_drop_blind_to_add  "$(read_key "$work/elder.out" add_sees_newline_added)" no
claim elder_drop_hides_seam    "$(read_key "$work/elder.out" terminator_invisible)" yes
claim elder_drop_reds_scan     "$(read_key "$work/elder.out" verdict)" red
claim elder_drop_keeps_lawful  "$(read_key "$work/elder.out" lawful_change_seen)" yes

# --- leg 5: the head-insert readings are not constants (REDS %807) ---
#
# The two head-insert readings in the scan are REPORTED rather than gated. A
# reported reading is the easiest kind to go quiet: it reds nothing when it
# freezes, so a reading stuck at `no` reads exactly like a defect still
# standing. So this leg plants a status calling every file clean. Both readings
# flip -- `head_insert_roundtrip` to `yes`, `head_insert_reports_move` to `no`,
# since a clean report prints no lines to intersect. The gate bites in the same
# breath, which names the pen broken.
#
# This takes none of the three doors %807 names. Which door the weave takes is
# a ruling about how places are assigned. The pen proves one thing: the
# instrument can answer other than it does today.
clean="$(new_pen clean_status)"
if plant_apply "$clean/main.rye" \
  's/^    if (d.inserts.len == 0 and d.deletes.len == 0) {$/    if (true) {/' \
  clean_status; then
  ok clean_status_planted
else
  bad clean_status_planted
fi
sh "$scan" "$clean/main.rye" > "$work/clean.out" 2>&1 || true
case "$(read_key "$work/clean.out" built)" in
  yes) ok clean_status_builds ;;
  *)   bad clean_status_builds ;;
esac
claim clean_status_flips_roundtrip "$(read_key "$work/clean.out" head_insert_roundtrip)" yes
claim clean_status_flips_move      "$(read_key "$work/clean.out" head_insert_reports_move)" no
claim clean_status_bites           "$(read_key "$work/clean.out" lawful_status_seen)" no
# The head insert is still WOVEN under this plant -- only the reporting was
# broken. That is what keeps the gate above meaning what it says: a pen where add
# had also stopped weaving would flip the two readings for a different reason.
claim clean_status_keeps_woven     "$(read_key "$work/clean.out" head_insert_woven)" yes

# What the tree answers today, read off the built binary rather than asserted.
# The insert is woven. The untouched file then reports a move.
head_pen="$work/headprice"
mkdir -p "$head_pen"
if env RYE_ZIG="$zig" "$rye" build "$base/main.rye" -femit-bin="$work/headprice.bin" >/dev/null 2>&1; then
  printf 'a\nb\n' > "$head_pen/f.txt"
  ( cd "$head_pen" && "$work/headprice.bin" init >/dev/null 2>&1 \
      && "$work/headprice.bin" add f.txt >/dev/null 2>&1 )
  printf 'zero\na\nb\n' > "$head_pen/f.txt"
  ( cd "$head_pen" && "$work/headprice.bin" add f.txt >/dev/null 2>&1 )
  # `2>&1` rather than `2>/dev/null`. The CLI reports through `std.debug.print`,
  # which writes to STDERR. A reading keeping only stdout reads an empty
  # document and prints a blank. Every other capture here merges the two
  # streams for that reason.
  ( cd "$head_pen" && "$work/headprice.bin" annotate f.txt ) > "$work/headann.out" 2>&1 || true
  echo "head_insert_position=$(grep -n '^[-+ ] *zero' "$work/headann.out" | head -1 | cut -d: -f1)"
else
  echo "head_insert_position=unbuilt"
fi

# What a three-line terminated file reports under each reading. The tree answers
# FOUR -- three lines a hand wrote and the terminator -- where the elder drop
# answers three. That one line is the price of the repair, read off two built
# binaries rather than argued, and it is the cost Keaton's door-2 ruling accepted
# by name: every weave already on disk drifts by one on its next add.
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
echo "elder_drop_line_count=$(count_lines "$elder/main.rye" edcount)"
echo "tree_line_count=$(count_lines "$base/main.rye" tcount)"

echo "pass=$pass fail=$fail"
if [ "$fail" -eq 0 ]; then echo "control_verdict=ok"; else echo "control_verdict=red"; fi
