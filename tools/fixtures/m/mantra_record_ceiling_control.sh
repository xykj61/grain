#!/bin/sh
# tools/fixtures/m/mantra_record_ceiling_control.sh -- the record ceiling, broken on purpose.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_record_ceiling_scan.sh builds the Mantra
# reader twice at two lowered ceilings, has the wide binary write the stores the
# narrow one reads, and asks where the reading stops. This control copies
# mantra/src into a throwaway pen, changes ONE thing in the copy of main.rye,
# points the scan at that pen, and watches the reading it broke come back wrong.
#
# THE PEN IS A DIRECTORY. Zig resolves an import inside the root file's own
# directory, so main.rye's four siblings -- weave.rye, diff.rye, store.rye and
# the parse_int.rye symlink -- are copied beside it. The scan lowers the ceiling
# in the pen's own weave.rye, so a phase reads the mutated reader at both
# ceilings.
#
# WHY EACH PLANT CARRIES A LINE RANGE. The edge refusal is spelled the same in
# `read_v2_record` and in `read_v1_rows`, so a bare substitution would rewrite
# both and no phase could say which reader it broke. Each program is addressed
# to one function's own lines.
#
# FOUR PHASES: one innocence leg and three breaks, and every break moves a
# reading no other break moves.
#   clean          -- the unmutated copy reads verdict=ok with every reading in
#                     place, which is what lets the others read as the break
#                     speaking rather than the pen.
#   no_edge_v2     -- the v2 reader's edge refusal is deleted, so the record is
#                     allocated whole and the trailing assert fires.
#                     `no_panic` reads no and `refusal_named` reads no, while
#                     `overlong_refused` still reads yes -- the record IS refused,
#                     by a panic instead of by name. This is the red restored.
#   eager          -- the same refusal bites one row early. `at_ceiling_reads`
#                     reads no while `overlong_refused` and `no_panic` stay yes,
#                     which is the opposite direction and the half a lazy guard
#                     forgets: a fence that closes early loses lawful records.
#   v1_unguarded   -- the elder reader's edge refusal is deleted.
#                     `v1_reader_guarded` reads no while every driven reading
#                     stays right, since nothing writes a v1 record to drive.
#
# EXPECTED: clean_ok=1, no_edge_v2_no_panic=no, no_edge_v2_refusal_named=no,
# no_edge_v2_overlong_refused=yes, eager_at_ceiling_reads=no,
# eager_overlong_refused=yes, eager_no_panic=yes, v1_unguarded_v1_reader_guarded=no,
# v1_unguarded_overlong_refused=yes.
#
# Driven by tools/m/mantra_record_ceiling_witness.rish. Run from the repository root.

set -eu

# The plant law, imported rather than restated: `plant_apply` rewrites a pen file
# through a sed program and refuses by name when the program matched nothing, so
# a line that moves in main.rye reds this control instead of quietly handing a
# phase an unmutated file (REDS %519). Root by upward walk (seated 20260828).
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
. "$_fd_root/tools/fixtures/p/plant.sh"

root="$(pwd)"
src="$root/mantra/src"
scan="$root/tools/fixtures/m/mantra_record_ceiling_scan.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

run_pen() {
  name="$1"
  program="$2"
  pen="$work/$name"
  mkdir -p "$pen"
  # -L follows the parse_int.rye symlink, so the pen holds a real file rather
  # than a link pointing back out of it.
  cp -L "$src"/main.rye "$src"/weave.rye "$src"/diff.rye "$src"/store.rye "$src"/parse_int.rye "$pen/"
  if [ -n "$program" ]; then
    if ! plant_apply "$pen/main.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  sh "$scan" "$pen/main.rye" 2>/dev/null
}

reading() { printf '%s\n' "$1" | sed -n "s/^$2=//p" | head -1; }

clean=$(run_pen clean "")
clean_ok=0
if [ "$(reading "$clean" verdict)" = "ok" ] \
  && [ "$(reading "$clean" at_ceiling_reads)" = "yes" ] \
  && [ "$(reading "$clean" overlong_refused)" = "yes" ] \
  && [ "$(reading "$clean" refusal_named)" = "yes" ] \
  && [ "$(reading "$clean" no_panic)" = "yes" ] \
  && [ "$(reading "$clean" v1_reader_guarded)" = "yes" ] \
  && [ "$(reading "$clean" lawful_roundtrip)" = "yes" ] \
  && [ "$(reading "$clean" ceiling_gap)" = "yes" ]; then
  clean_ok=1
fi
echo "clean_ok=$clean_ok"

ne=$(run_pen no_edge_v2 '/^fn read_v2_record/,/^}/ s|^ *if (rows.items.len >= weave.max_weave_lines) return weave.WeaveError.TooManyLines;$||')
echo "no_edge_v2_no_panic=$(reading "$ne" no_panic)"
echo "no_edge_v2_refusal_named=$(reading "$ne" refusal_named)"
echo "no_edge_v2_overlong_refused=$(reading "$ne" overlong_refused)"

eg=$(run_pen eager '/^fn read_v2_record/,/^}/ s|if (rows.items.len >= weave.max_weave_lines)|if (rows.items.len + 1 >= weave.max_weave_lines)|')
echo "eager_at_ceiling_reads=$(reading "$eg" at_ceiling_reads)"
echo "eager_overlong_refused=$(reading "$eg" overlong_refused)"
echo "eager_no_panic=$(reading "$eg" no_panic)"

vu=$(run_pen v1_unguarded '/^fn read_v1_rows/,/^}/ s|^ *if (rows.items.len >= weave.max_weave_lines) return weave.WeaveError.TooManyLines;$||')
echo "v1_unguarded_v1_reader_guarded=$(reading "$vu" v1_reader_guarded)"
echo "v1_unguarded_overlong_refused=$(reading "$vu" overlong_refused)"

echo "control_verdict=ok"
