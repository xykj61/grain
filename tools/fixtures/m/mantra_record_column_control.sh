#!/bin/sh
# tools/fixtures/m/mantra_record_column_control.sh -- every column swapped, on both sides.
#
# WHAT THIS DOES. tools/fixtures/m/mantra_record_column_scan.sh claims that a two-commit store
# carrying a replacement tells the five numeric columns of the `mantra-weave-20260916.101910`
# record apart. This control plants each of the ten pairwise column swaps in a copy of
# mantra/src/main.rye THREE WAYS -- in the WRITER tuple of `serialize_weave` alone, in the READER
# row of `read_order_record` alone, and in BOTH together -- and watches the scan answer. Thirty
# swaps, one clean leg, one measurement leg, and two mutations of the scan itself.
#
# THE THIRD FAMILY IS THE ONE THIS GUARD WAS BUILT FOR. A swap planted on both sides is
# SELF-CONSISTENT: the store it writes is exactly the store it reads, so every round trip stays
# clean and every document renders correctly, while the record's own meaning has changed and every
# store written before that day is misread forever. Measured before this control was written, the
# standing guard at tools/fixtures/m/mantra_cli_record_scan.sh is BYTE-IDENTICAL on all ten of
# them -- nothing in this tree could see a record change its own meaning.
#
# THE PEN DEREFERENCES ITS SYMLINKS, AND COPIES THE SOURCE ROOM ALONE. mantra/src/ reaches tally
# through three symlinks whose targets are relative -- parse_int.rye,
# tally_receipt_offer_bounds.rye and tally_receipt_refusal.rye -- so a plain `cp -a` into a pen
# produces a directory that cannot build, and every phase then reads `built=no verdict=red` and
# looks like a catch. That false catch was met on this lap before the control was written: all
# ten swaps read red through a pen whose build had failed. `cp -aL` is the whole cure, and the
# clean leg is what proves it took. The copy takes `mantra/src` rather than `mantra`, because
# `mantra/bin` holds 195 MB of untracked build output and thirty-odd pens of it is gigabytes of
# copying for a room no build reads.
#
# TWO KINDS OF LEG, AND THE SECOND IS THE MEASUREMENT.
#
#   The CATCHES. Nine swaps in each of the three families must move a reading. The scan's whole
#   output is compared against the clean run's, so a phase passes only when something actually
#   differs -- a verdict alone would miss a swap that reds for a reason the pen invented.
#
#   The BLINDNESS. `site` against `run` must go unnoticed in all three families, and the control
#   asserts that as hard as it asserts the catches. The two columns share a profile because the
#   CLI exposes no merge, so no store this pen can write carries a site or a run above zero.
#
#   The GAP, proven rather than recalled. `sibling_blind` plants the consistent gen-pos swap and
#   runs the ELDER scan against it, asserting its output is byte-identical to its own clean run.
#   That is the reading this whole guard exists for: the fault walking past the standing guard,
#   shown rather than claimed.
#
#   The MUTATIONS, one per half of the instrument, each aimed at a swap only that half sees.
#   `no_profiles` strikes the column readings out of a copy of the scan and asserts the CONSISTENT
#   gen-pos swap then travels -- the profiles are the only reading that sees it, since the round
#   trip of a self-consistent store is clean by construction. `no_roundtrip` strikes the status
#   and annotate readings out and asserts the WRITER-ONLY site-ord swap travels -- that one moves
#   no column profile, because it leaves the record's own shape intact and breaks only the
#   agreement between the two sides. Each mutation says its half is load-bearing rather than
#   decorative, and neither could be shown by a swap the other half also catches.
#
# EXPECTED: clean_exit=0, twenty-seven catches, three blindness readings held, the sibling blind,
# and both mutations biting.
#
# WHAT A FUTURE RED HERE MEANS, said ahead of the day it fires. If `mantra` ever grows a merge
# subcommand, a store this pen writes will carry a site and a run above zero, the site-run swap
# will start being caught, and `both_site_run=blind` will red. That is the CORRECT red rather
# than a guard refusing an improvement: the sentence this instrument states about the pair it
# cannot separate would have stopped being true, and a stale bound is exactly what a guard should
# refuse to carry. The repair is to widen the expected profiles and rewrite the header, in the
# same commit as the merge.
#
# Driven by tools/m/mantra_record_column_witness.rish. Run from the repository root.

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/src" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/src and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/p/plant.sh"

root="$(pwd)"
scan="$root/tools/fixtures/m/mantra_record_column_scan.sh"
sibling="$root/tools/fixtures/m/mantra_cli_record_scan.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

writer_tuple='.{ row.gen, row.pos, row.site, row.run, row.ord }'
reader_row='OrderRow{ .text = text, .gen = gen, .pos = pos, .site = site, .run = run, .ord = ord }'

# Build a pen of mantra/ with its symlinks dereferenced, optionally planting a sed program into
# the copied main.rye, then run a scan against it and echo the scan's whole output.
run_pen() {
  name="$1"; program="$2"; which_scan="$3"
  pen="$work/$name"
  rm -rf "$pen"; mkdir -p "$pen"
  cp -aL "$root/mantra/src" "$pen/src"
  if [ -n "$program" ]; then
    if ! plant_apply "$pen/src/main.rye" "$program" "$name"; then
      echo "plant_matched_nothing"
      return
    fi
  fi
  sh "$which_scan" "$pen/src/main.rye" 2>&1 || true
}

# The swapped tuple for a given side and pair, spelled by position so the two sides share one
# rule rather than two hand-written lists.
swap_program() {
  side="$1"; a="$2"; b="$3"
  set -- gen pos site run ord
  eval "na=\${$a}"; eval "nb=\${$b}"
  i=0; wout=""; rout=""
  for f in gen pos site run ord; do
    i=$((i + 1)); v="$f"
    [ "$i" = "$a" ] && v="$nb"
    [ "$i" = "$b" ] && v="$na"
    wout="$wout row.$v,"
    rout="$rout .$f = $v,"
  done
  wout=$(printf '%s' "$wout" | sed 's/,$//')
  rout=$(printf '%s' "$rout" | sed 's/,$//')
  wprog=$(printf 's|%s|.{%s }|' "$writer_tuple" "$wout")
  rprog=$(printf 's|%s|OrderRow{ .text = text,%s }|' "$reader_row" "$rout")
  case "$side" in
    writer) printf '%s' "$wprog" ;;
    reader) printf '%s' "$rprog" ;;
    both)   printf '%s; %s' "$wprog" "$rprog" ;;
  esac
}

clean_out="$(run_pen clean '' "$scan")"
clean_exit=0
printf '%s\n' "$clean_out" | grep -q '^verdict=ok$' || clean_exit=1
echo "phase=clean"
echo "clean_exit=$clean_exit"

# --- the twenty swaps ---
#
# A phase is a CATCH when the scan's whole output differs from the clean run's, and BLIND when
# it is identical. Comparing the whole output rather than the verdict is what makes a catch mean
# the swap was seen: a phase whose pen failed to build reds too, and reds for a reason the pen
# invented.
catches=0
blind=0
legs=0
for side in writer reader both; do
  for a in 1 2 3 4 5; do
    for b in 1 2 3 4 5; do
      [ "$a" -lt "$b" ] || continue
      set -- gen pos site run ord
      eval "na=\${$a}"; eval "nb=\${$b}"
      pair="${na}_${nb}"
      out="$(run_pen "${side}_${pair}" "$(swap_program "$side" "$a" "$b")" "$scan")"
      legs=$((legs + 1))
      if [ "$out" = "plant_matched_nothing" ]; then
        echo "${side}_${pair}=plant_matched_nothing"
      elif [ "$out" = "$clean_out" ]; then
        echo "${side}_${pair}=blind"
        blind=$((blind + 1))
      else
        echo "${side}_${pair}=caught"
        catches=$((catches + 1))
      fi
    done
  done
done
echo "swaps_caught=$catches"
echo "swaps_blind=$blind"

# --- the gap, shown rather than claimed ---
#
# The pos-site writer swap through the ELDER scan. Its output must be byte-identical to its own
# clean run, which is the measurement this guard was built on.
sibling_clean="$(run_pen sibling_clean '' "$sibling")"
sibling_swapped="$(run_pen sibling_swapped "$(swap_program both 1 2)" "$sibling")"
sibling_blind=no
[ "$sibling_clean" = "$sibling_swapped" ] && sibling_blind=yes
echo "sibling_blind=$sibling_blind"

# --- two mutations, one per half of the instrument ---
#
# Each strikes one half out of a COPY of the scan and asserts a swap that half was catching now
# travels. A guard whose halves are never removed is a guard whose halves are never priced.
# THE MUTATED COPY NEEDS A ROOT ABOVE IT. Every scan in this tree finds the repository by walking
# up from its own `$0` until it sees `rishi/src` and `tools/fixtures`, so a copy dropped straight
# into a temporary directory exits 2 before it reads a byte -- and a phase reading that as a
# difference would call a broken pen a catch. The pen gets both markers as symlinks to the real
# rooms, so the copy's walk lands on the pen and sources the real shell_portable.sh.
mutate_scan() {
  name="$1"; program="$2"
  home="$work/${name}_home"
  mkdir -p "$home"
  ln -sf "$root/tools" "$home/tools"
  ln -sf "$root/rishi" "$home/rishi"
  copy="$home/$name.sh"
  cp "$scan" "$copy"
  plant_apply "$copy" "$program" "$name" || { echo "plant_matched_nothing"; return 1; }
  printf '%s' "$copy"
}

no_profiles=biting
if copy="$(mutate_scan no_profiles '/^  echo "col/d; /^echo "profile_classes=/d')"; then
  a="$(run_pen no_profiles_clean '' "$copy")"
  b="$(run_pen no_profiles_swap "$(swap_program both 1 2)" "$copy")"
  [ "$a" = "$b" ] || no_profiles=silent
else
  no_profiles=plant_matched_nothing
fi
echo "no_profiles=$no_profiles"

no_roundtrip=biting
if copy="$(mutate_scan no_roundtrip '/^echo "status=/d; /^echo "document_order=/d; /^echo "annotate=/d')"; then
  a="$(run_pen no_roundtrip_clean '' "$copy")"
  b="$(run_pen no_roundtrip_swap "$(swap_program writer 3 5)" "$copy")"
  [ "$a" = "$b" ] || no_roundtrip=silent
else
  no_roundtrip=plant_matched_nothing
fi
echo "no_roundtrip=$no_roundtrip"

# THE PEN COUNTS ITS OWN LEGS OUT LOUD, for the reason its siblings give: a control that merely
# finishes proves nothing about how much of it ran.
legs_expected=30
echo "legs_expected=$legs_expected"
echo "legs_ran=$legs"

verdict=ok
[ "$legs" -eq "$legs_expected" ] || verdict=leg_count_disagrees
[ "$clean_exit" -eq 0 ] || verdict=clean_failed
[ "$catches" -eq 27 ] || verdict=catch_count_moved
[ "$blind" -eq 3 ] || verdict=blind_count_moved
[ "$sibling_blind" = yes ] || verdict=sibling_noticed
[ "$no_profiles" = biting ] || verdict=profiles_not_load_bearing
[ "$no_roundtrip" = biting ] || verdict=roundtrip_not_load_bearing
echo "control_verdict=$verdict"
