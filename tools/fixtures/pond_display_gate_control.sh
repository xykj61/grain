#!/bin/sh
# tools/fixtures/pond_display_gate_control.sh -- the display gate, proven from both sides.
#
# WHY (REDS %173). tools/fixtures/pond_build_drawn_terminal.sh used to print
# "assuming host link seams on metal" and hand that guess to a compile which discovered the truth
# at link time, twenty minutes later. On a headless pier the discovery reads as a broken tree
# rather than as a machine with no screen, and a random draw of 86 witnesses duly reported it as a
# genuine red beside one that truly was.
#
# A gate that always fires is a witness that never runs, so this pen proves both directions:
# absent seams gate at exit 3, present seams open the gate and let the ordinary build verdict
# through. The second half is the one worth having -- it is what stops the gate becoming a bypass.
#
# WHAT IS PROVEN
#   gate_fires           -- with no seam on the search path, the script exits 3
#   gate_names_verdict   -- and says verdict=gated_no_display rather than only refusing
#   gate_names_libraries -- and names WHICH seam is absent, so a reader can provision it
#   gate_opens           -- with both seams on LIBRARY_PATH, prepare reports both present by name
#   gate_yields_to_build -- and the run proceeds past prepare into compile
#   red_survives_gate    -- a build that then fails exits NON-3, so a real breakage stays red
#   one_seam_still_gates -- one seam present and one absent still gates, naming only the absent one
#   rt_is_not_gated      -- `rt` lives inside glibc, so it is deliberately outside the check
#
# USAGE
#   sh tools/fixtures/pond_display_gate_control.sh
#
# Driven by tools/p/pond_display_gate_witness.rish. Run from the repository root.

set -u

SCRIPT=tools/fixtures/pond_build_drawn_terminal.sh
faults=0

check() {
  _name=$1; _want=$2; _got=$3
  if [ "$_want" = "$_got" ]; then
    echo "case=$_name ok ($_got)"
  else
    echo "case=$_name FAULT want=$_want got=$_got"
    faults=$((faults + 1))
  fi
}

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM

# 1 -- no seam anywhere the linker looks: the gate fires at 3 and says why.
out=$(LIBRARY_PATH="$pen/none" LD_LIBRARY_PATH="$pen/none" sh "$SCRIPT" 2>&1)
code=$?
check gate_fires 3 "$code"
case "$out" in
  *"verdict=gated_no_display"*) check gate_names_verdict ok ok ;;
  *) check gate_names_verdict ok missing ;;
esac
case "$out" in
  *"wayland-client xkbcommon"*) check gate_names_libraries ok ok ;;
  *) check gate_names_libraries ok missing ;;
esac

# 2 -- both seams on the search path: the gate opens and the ordinary build runs. The stubs are
#      empty files, so the link fails -- which is exactly the point. A real failure must survive.
mkdir -p "$pen/lib"
: > "$pen/lib/libwayland-client.so"
: > "$pen/lib/libxkbcommon.so"
out2=$(LIBRARY_PATH="$pen/lib" sh "$SCRIPT" 2>&1)
code2=$?
case "$out2" in
  *"prepare -- seams present: wayland-client xkbcommon"*) check gate_opens ok ok ;;
  *) check gate_opens ok missing ;;
esac
case "$out2" in
  *"build: compile"*) check gate_yields_to_build ok ok ;;
  *) check gate_yields_to_build ok missing ;;
esac
if [ "$code2" -eq 3 ]; then
  check red_survives_gate non3 3
else
  check red_survives_gate non3 non3
fi

# 3 -- one present, one absent: still gated, and only the absent one is named.
mkdir -p "$pen/half"
: > "$pen/half/libwayland-client.so"
out3=$(LIBRARY_PATH="$pen/half" LD_LIBRARY_PATH="$pen/none" sh "$SCRIPT" 2>&1)
code3=$?
if [ "$code3" -eq 3 ]; then
  case "$out3" in
    *"link seam: xkbcommon"*) check one_seam_still_gates ok ok ;;
    *) check one_seam_still_gates ok "named_wrong" ;;
  esac
else
  check one_seam_still_gates ok "code$code3"
fi

# 4 -- `rt` is never gated: it lives inside glibc, so `-lrt` links with no librt.so to find.
#      With both real seams present the gate opens, which proves rt was never in the check.
case "$out2" in
  *"GATED"*) check rt_is_not_gated ok "gated_anyway" ;;
  *) check rt_is_not_gated ok ok ;;
esac

if [ "$faults" -eq 0 ]; then
  echo "control=ok"
  exit 0
fi
echo "control=faults faults=$faults"
exit 2
