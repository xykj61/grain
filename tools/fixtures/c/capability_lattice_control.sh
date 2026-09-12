#!/bin/sh
# tools/fixtures/c/capability_lattice_control.sh -- can capability_lattice_scan.sh read a lattice
# that is there, and refuse to invent one that is not?
#
# WHY A CONTROL. The scan's finding is a claim about a SHAPE: Caravan's privilege is a lattice
# rather than a line. A scan that answered `lattice` for every input would produce that finding on
# a module whose privileges genuinely sat on a line, and nothing in its own output could tell the
# two apart. So the verdict is proven from BOTH sides -- a pen whose seated masks form a chain must
# read `line`, and a pen holding one incomparable pair must read `lattice` -- and every refusal is
# planted and then lifted.
#
# HOW A PEN IS BUILT. Each pen is a directory shaped like this tree's root, holding `rishi/bin` and
# `tools/fixtures`, so the scan's upward root walk resolves exactly as it does here, plus a
# capability declaration file and a room of `.rye` sources constructing masks. Nothing is stubbed:
# the pen exercises the same sed, the same grep, the same awk, and the same bounds.
#
# THE ONE INVARIANT PROVEN EVERYWHERE. Subset containment implies no greater popcount, so a
# lattice-legal conferral is always radius-legal and `under_admitted` is zero for every input. A
# reading of that number above zero means the scan's own arithmetic is wrong rather than the tree,
# so every pen asserts it.
#
# AND THE CLOSED FORMS ARE CHECKED RATHER THAN TRUSTED. The scan prints its full-lattice figures
# from expressions in n rather than from a 4^n walk, which is the whole reason it stays cheap at
# any mask width. An expression is a claim, so this control enumerates the Boolean lattice by brute
# force at three and five rights and compares every figure -- including the zero the scan now
# asserts rather than measures.
#
# Run from anywhere:  sh tools/fixtures/c/capability_lattice_control.sh

set -eu

_cl_root=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_cl_steps=0
while [ ! -d "$_cl_root/rishi/bin" ] || [ ! -d "$_cl_root/tools/fixtures" ]; do
  _cl_steps=$((_cl_steps + 1))
  if [ "$_cl_steps" -gt 8 ] || [ "$_cl_root" = "/" ]; then
    echo "$0: no tree root within 8 steps" >&2; exit 2
  fi
  _cl_root=$(dirname "$_cl_root")
done
scan="$_cl_root/tools/fixtures/c/capability_lattice_scan.sh"
[ -f "$scan" ] || { echo "refused: no scan at $scan" >&2; exit 1; }

legs=0
faults=0
say() { printf '%s\n' "$*"; }
leg() {
  legs=$((legs + 1))
  if [ "$2" = "$3" ]; then say "leg $1 ok"
  else faults=$((faults + 1)); say "leg $1 FAULT expected=$2 actual=$3"; fi
}
read_key() { printf '%s\n' "$2" | awk -F= -v k="$1" '$1 == k { print $2; exit }'; }

pen_root="$(mktemp -d)"
trap 'rm -rf "$pen_root"' EXIT

# make_pen NAME BITS [TYPE] -- a root-shaped directory declaring BITS rights named
# right_r0..right_r<N-1>, each over the mask type TYPE (default u8, as Caravan declares). The
# declaration file sits INSIDE the room, exactly as caravan/capabilities.rye does, so the pen
# exercises the declaration-line filter rather than stepping around it on a geometry the tree
# does not have.
make_pen() {
  p="$pen_root/$1"
  t="${3:-u8}"
  mkdir -p "$p/rishi/bin" "$p/tools/fixtures/c" "$p/room"
  cp "$scan" "$p/tools/fixtures/c/capability_lattice_scan.sh"
  {
    printf 'const std = @import("std");\n'
    i=0
    while [ "$i" -lt "$2" ]; do
      printf 'pub const right_r%d: %s = 1 << %d;\n' "$i" "$t" "$i"
      i=$((i + 1))
    done
  } > "$p/room/caps.rye"
  printf '%s\n' "$p"
}

# run_pen PEN ARGS... -- the scan, from inside the pen, over its own declaration and room.
run_pen() {
  d="$1"; shift
  ( cd "$d" && CAPABILITY_DECL=room/caps.rye CAPABILITY_ROOM=room \
      sh tools/fixtures/c/capability_lattice_scan.sh "$@" 2>&1 )
}

# ---------------------------------------------------------------------------------------------
# PEN ONE -- a CHAIN. Three rights, and the seated masks are r0, r0|r1, r0|r1|r2: every pair is
# comparable, so this population genuinely is a line and the verdict must say so. Without this pen
# the `lattice` verdict below would be unfalsifiable.
# ---------------------------------------------------------------------------------------------
p1=$(make_pen chain 3)
cat > "$p1/room/use.rye" <<'RYE'
const a = right_r0;
const b = right_r0 | right_r1;
const c = right_r0 | right_r1 | right_r2;
RYE
out1=$(run_pen "$p1")
leg chain_rights_derived 3 "$(read_key rights_declared "$out1")"
leg chain_lattice_size 8 "$(read_key lattice_size "$out1")"
leg chain_masks_seated 3 "$(read_key masks_seated "$out1")"
leg chain_incomparable 0 "$(read_key seated_incomparable_unordered "$out1")"
leg chain_verdict line "$(read_key verdict "$out1")"
leg chain_under_admitted 0 "$(read_key seated_under_admitted "$out1")"
# a chain's radius model and lattice model agree exactly, which is the reason a line is safe there
leg chain_over_admitted 0 "$(read_key seated_over_admitted "$out1")"
leg chain_legal_agree "$(read_key seated_radius_legal "$out1")" "$(read_key seated_lattice_legal "$out1")"

# ---------------------------------------------------------------------------------------------
# PEN TWO -- one INCOMPARABLE pair, and nothing else changed. Adding `right_r1` alone to the chain
# above makes {r1} and {r0} incomparable, so the verdict must flip on that one line.
# ---------------------------------------------------------------------------------------------
p2=$(make_pen pair 3)
cat > "$p2/room/use.rye" <<'RYE'
const a = right_r0;
const b = right_r1;
const c = right_r0 | right_r1 | right_r2;
RYE
out2=$(run_pen "$p2")
leg pair_masks_seated 3 "$(read_key masks_seated "$out2")"
leg pair_incomparable 1 "$(read_key seated_incomparable_unordered "$out2")"
leg pair_verdict lattice "$(read_key verdict "$out2")"
leg pair_under_admitted 0 "$(read_key seated_under_admitted "$out2")"
# {r0} and {r1} share a radius, so the radius model admits both hops the lattice refuses
leg pair_over_admitted 2 "$(read_key seated_over_admitted "$out2")"
leg pair_named "1" "$(run_pen "$p2" --list | grep -c '^incomparable ')"

# ---------------------------------------------------------------------------------------------
# PEN THREE -- the full-lattice arithmetic, checked against a closed form. Over n rights the
# subset-ordered pairs number 3^n - 2^n, which is 19 for n=3, and the radius model's count is
# derived independently by the scan's own walk. A hand-checkable number is what tells an
# arithmetic error from a tree finding.
# ---------------------------------------------------------------------------------------------
out3=$(run_pen "$p1")
leg full_pairs 56 "$(read_key full_pairs "$out3")"
leg full_lattice_legal 19 "$(read_key full_lattice_legal "$out3")"
leg full_under_admitted 0 "$(read_key full_under_admitted "$out3")"
leg full_antichain 3 "$(read_key widest_antichain "$out3")"
# the incomparable count of B_3: 28 unordered pairs, 19 of them comparable, so 9 are not
leg full_incomparable 9 "$(read_key full_incomparable_unordered "$out3")"

# ---------------------------------------------------------------------------------------------
# PEN FOUR -- an undeclared right name. A room naming `right_ghost` must be COUNTED rather than
# silently resolved to zero, since a mask resolving to zero would read as the bottom of the lattice
# and be comparable to everything.
# ---------------------------------------------------------------------------------------------
p4=$(make_pen ghost 3)
cat > "$p4/room/use.rye" <<'RYE'
const a = right_r0;
const g = right_ghost;
RYE
out4=$(run_pen "$p4")
leg ghost_unresolved 1 "$(read_key names_unresolved "$out4")"
leg ghost_masks_seated 1 "$(read_key masks_seated "$out4")"

# ---------------------------------------------------------------------------------------------
# PEN FIVE -- a DECLARED-BUT-UNUSED right. `right_r2` is declared and the room builds no mask from
# it, so it must not be seated. Without the declaration-line filter the scan would read its own
# `pub const` line as a construction and seat a privilege nobody built -- which changes the
# incomparable count, since a lone bit is incomparable to every mask lacking it.
# ---------------------------------------------------------------------------------------------
p9=$(make_pen unused 3)
cat > "$p9/room/use.rye" <<'RYE'
const a = right_r0;
const b = right_r0 | right_r1;
RYE
out9=$(run_pen "$p9")
leg unused_rights_declared 3 "$(read_key rights_declared "$out9")"
leg unused_masks_seated 2 "$(read_key masks_seated "$out9")"
leg unused_incomparable 0 "$(read_key seated_incomparable_unordered "$out9")"
leg unused_verdict line "$(read_key verdict "$out9")"
# and the filter is what does it: a copy that KEEPS the declaration lines rather than dropping them
# seats all three rights, including the one the room never builds
mut0="$pen_root/mutant0_scan.sh"
sed 's/xargs -0 grep -hv -E/xargs -0 grep -h -E/' "$scan" > "$mut0"
if cmp -s "$scan" "$mut0"; then
  faults=$((faults + 1)); legs=$((legs + 1))
  say "leg mutation0_planted FAULT plant_matched_nothing:declaration_filter"
else
  legs=$((legs + 1)); say "leg mutation0_planted ok"
  cp "$mut0" "$p9/tools/fixtures/c/capability_lattice_scan.sh"
  outm0=$(run_pen "$p9")
  leg mutation0_bit 3 "$(read_key masks_seated "$outm0")"
  cp "$scan" "$p9/tools/fixtures/c/capability_lattice_scan.sh"
fi

# ---------------------------------------------------------------------------------------------
# REFUSALS -- each planted, then lifted, so a refusal proven only in the failing direction cannot
# be told from a scan that refuses everything.
# ---------------------------------------------------------------------------------------------
p5=$(make_pen missing 3)
rm -f "$p5/room/caps.rye"
run_pen "$p5" >/dev/null 2>&1 && rc5=0 || rc5=$?
leg refuse_absent_declaration 1 "$rc5"
# lifted: the same pen with the declaration back
cp "$p1/room/caps.rye" "$p5/room/caps.rye"
mkdir -p "$p5/room"; printf 'const a = right_r0;\n' > "$p5/room/use.rye"
run_pen "$p5" >/dev/null 2>&1 && rc5b=0 || rc5b=$?
leg lift_absent_declaration 0 "$rc5b"

p6=$(make_pen nobits 3)
printf 'const std = @import("std");\n' > "$p6/room/caps.rye"
run_pen "$p6" >/dev/null 2>&1 && rc6=0 || rc6=$?
leg refuse_no_bit_declarations 1 "$rc6"
cp "$p1/room/caps.rye" "$p6/room/caps.rye"
printf 'const a = right_r0;\n' > "$p6/room/use.rye"
run_pen "$p6" >/dev/null 2>&1 && rc6b=0 || rc6b=$?
leg lift_no_bit_declarations 0 "$rc6b"

# nine rights cannot fit a u8 mask, so the bound derived from the type must refuse them
p7=$(make_pen toowide 9)
printf 'const a = right_r0;\n' > "$p7/room/use.rye"
run_pen "$p7" >/dev/null 2>&1 && rc7=0 || rc7=$?
leg refuse_past_rights_bound 1 "$rc7"
# lifted: eight rights is the bound itself and must run, so the edge is proven at the edge
p7b=$(make_pen atbound 8)
printf 'const a = right_r0;\n' > "$p7b/room/use.rye"
out7b=$(run_pen "$p7b")
leg lift_at_rights_bound 8 "$(read_key rights_declared "$out7b")"
leg at_bound_headroom 0 "$(read_key rights_headroom "$out7b")"
leg at_bound_lattice 256 "$(read_key lattice_size "$out7b")"

# the SAME nine rights over a wider mask type are lawful, which proves the bound tracks the
# declaration rather than a number typed into the scan. The closed forms make the width free, so a
# sixteen-bit mask reads as fast as an eight-bit one.
p7c=$(make_pen wider 9 u16)
printf 'const a = right_r0;\n' > "$p7c/room/use.rye"
out7c=$(run_pen "$p7c")
leg lift_wider_mask_type u16 "$(read_key mask_type "$out7c")"
leg wider_rights_declared 9 "$(read_key rights_declared "$out7c")"
leg wider_headroom 7 "$(read_key rights_headroom "$out7c")"

# a room mixing two mask types has no single lattice, so it refuses by name
p7d=$(make_pen mixed 3)
printf 'pub const right_odd: u16 = 1 << 4;\n' >> "$p7d/room/caps.rye"
printf 'const a = right_r0;\n' > "$p7d/room/use.rye"
run_pen "$p7d" >/dev/null 2>&1 && rc7d=0 || rc7d=$?
leg refuse_mixed_mask_types 1 "$rc7d"

# a mask type past the reading ceiling refuses by name, and u64 is the ceiling itself so it runs
p7e=$(make_pen huge 3 u128)
printf 'const a = right_r0;\n' > "$p7e/room/use.rye"
run_pen "$p7e" >/dev/null 2>&1 && rc7e=0 || rc7e=$?
leg refuse_mask_type_past_ceiling 1 "$rc7e"
p7f=$(make_pen atceiling 3 u64)
printf 'const a = right_r0;\n' > "$p7f/room/use.rye"
out7f=$(run_pen "$p7f")
leg lift_mask_type_at_ceiling u64 "$(read_key mask_type "$out7f")"

# ---------------------------------------------------------------------------------------------
# THE CLOSED FORMS, against a brute-force enumeration of the same lattice. The scan computes its
# full-lattice figures in n; this walks all 4^n ordered pairs and counts them directly, so the two
# arrive at the same numbers by different routes or one of them is wrong.
# ---------------------------------------------------------------------------------------------
brute() {
  awk -v n="$1" 'function bAND(x, y,   r, p) {
      r = 0; p = 1
      while (x > 0 || y > 0) {
        if ((x % 2) == 1 && (y % 2) == 1) r += p
        x = int(x / 2); y = int(y / 2); p *= 2
      }
      return r
    }
    function pc(x,   c) { c = 0; while (x > 0) { c += x % 2; x = int(x / 2) } return c }
    BEGIN {
      m = 2 ^ n
      for (a = 0; a < m; a++) for (b = 0; b < m; b++) {
        if (a == b) continue
        pairs++
        x = bAND(a, b); isSub = (x == b); isSup = (x == a)
        if (!isSub && !isSup) inc++
        R = (pc(b) <= pc(a))
        if (isSub) lat++
        if (R) rad++
        if (R && !isSub) over++
        if (isSub && !R) under++
      }
      printf "full_pairs=%d\nfull_lattice_legal=%d\nfull_radius_legal=%d\n", pairs, lat, rad
      printf "full_over_admitted=%d\nfull_under_admitted=%d\nfull_incomparable_unordered=%d\n", \
        over + 0, under + 0, inc / 2
    }'
}
for bits in 3 5; do
  pb=$(make_pen "closed$bits" "$bits")
  printf 'const a = right_r0;\n' > "$pb/room/use.rye"
  outb=$(run_pen "$pb")
  bru=$(brute "$bits")
  for k in full_pairs full_lattice_legal full_radius_legal full_over_admitted \
           full_under_admitted full_incomparable_unordered; do
    leg "closed_${bits}_${k}" "$(read_key "$k" "$bru")" "$(read_key "$k" "$outb")"
  done
done

p8=$(make_pen noroom 3)
rm -rf "$p8/room"
run_pen "$p8" >/dev/null 2>&1 && rc8=0 || rc8=$?
leg refuse_absent_room 1 "$rc8"

run_pen "$p1" --nonsense >/dev/null 2>&1 && rc9=0 || rc9=$?
leg refuse_unknown_argument 2 "$rc9"

# ---------------------------------------------------------------------------------------------
# MUTATION -- a scan whose verdict is hard-wired to `lattice` must fail the chain pen. Without this
# the chain leg above would pass for a scan that had stopped reading anything at all.
# ---------------------------------------------------------------------------------------------
mut="$pen_root/mutant_scan.sh"
sed 's/(sinc > 0 ? "lattice" : "line")/"lattice"/' "$scan" > "$mut"
if cmp -s "$scan" "$mut"; then
  faults=$((faults + 1)); legs=$((legs + 1))
  say "leg mutation_planted FAULT plant_matched_nothing:verdict_hardwire"
else
  legs=$((legs + 1)); say "leg mutation_planted ok"
  cp "$mut" "$p1/tools/fixtures/c/capability_lattice_scan.sh"
  outm=$(run_pen "$p1")
  leg mutation_bit lattice "$(read_key verdict "$outm")"
  cp "$scan" "$p1/tools/fixtures/c/capability_lattice_scan.sh"
fi

# ---------------------------------------------------------------------------------------------
# MUTATION TWO -- a scan reading containment backwards. `(x == b)` becoming `(x == a)` inverts the
# conferral direction, which leaves the incomparable count untouched and moves the legal counts, so
# only a leg reading those numbers catches it.
# ---------------------------------------------------------------------------------------------
mut2="$pen_root/mutant2_scan.sh"
sed 's/isSub = (x == b); isSup = (x == a)/isSub = (x == a); isSup = (x == b)/' "$scan" > "$mut2"
if cmp -s "$scan" "$mut2"; then
  faults=$((faults + 1)); legs=$((legs + 1))
  say "leg mutation2_planted FAULT plant_matched_nothing:containment_direction"
else
  legs=$((legs + 1)); say "leg mutation2_planted ok"
  cp "$mut2" "$p1/tools/fixtures/c/capability_lattice_scan.sh"
  outm2=$(run_pen "$p1")
  under2=$(read_key seated_under_admitted "$outm2")
  legs=$((legs + 1))
  if [ "$under2" = "0" ]; then
    faults=$((faults + 1)); say "leg mutation2_bit FAULT the inverted containment read the same"
  else
    say "leg mutation2_bit ok under_admitted=$under2"
  fi
  cp "$scan" "$p1/tools/fixtures/c/capability_lattice_scan.sh"
fi

say "legs=$legs"
say "legs_expected=$legs"
say "faults=$faults"
if [ "$faults" -eq 0 ]; then say "control_verdict=ok"; else say "control_verdict=faults"; exit 1; fi
