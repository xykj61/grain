#!/bin/sh
# tools/fixtures/display_seam_probe.sh -- does this machine carry a graphical link seam?
#
# Exits 0 when every required seam stands on a path the linker searches, and 3 when any is
# absent, naming which on stdout. One place, one rule, so six callers cannot come to disagree.
#
# WHY (REDS %173). Five witnesses in this tree link `-lwayland-client -lxkbcommon`, and this pier
# is headless. Each one used to discover that at LINK time and report it as a build failure, so a
# random draw of 86 witnesses named a Wayland application on a screenless host as a genuine tree
# red beside one that truly was. A machine with no screen is a fact about the machine.
#
# `rt` is deliberately outside the check: it lives inside glibc on this platform, so `-lrt` links
# with no `librt.so` file to find, and gating on it would refuse every machine.
#
# The probe searches what the LINKER searches rather than the whole filesystem. That distinction is
# load-bearing: `/nix/store` here holds `libwayland-client.so.0.25.0`, and Zig still refused,
# because the store is not on any search path. A probe that found it would promise a link that
# cannot happen.
#
# USAGE
#   sh tools/fixtures/display_seam_probe.sh                 # wayland-client and xkbcommon
#   sh tools/fixtures/display_seam_probe.sh wayland-client  # only the named seams
#
# Proven both ways by tools/fixtures/pond_display_gate_control.sh, driven by
# tools/p/pond_display_gate_witness.rish. Run from the repository root.

set -u

seams=${*:-"wayland-client xkbcommon"}

seam_present() {
  _name=$1
  for _dir in ${LIBRARY_PATH:-} ${LD_LIBRARY_PATH:-} /lib64 /usr/lib64 /lib /usr/lib /usr/local/lib; do
    [ -n "$_dir" ] || continue
    for _cand in "$_dir/lib$_name.so" "$_dir/lib$_name.a" "$_dir/lib$_name".so.*; do
      [ -e "$_cand" ] && return 0
    done
  done
  if command -v ldconfig >/dev/null 2>&1; then
    ldconfig -p 2>/dev/null | grep -q "lib$_name\.so" && return 0
  fi
  return 1
}

missing=""
for seam in $seams; do
  seam_present "$seam" || missing="${missing}${missing:+ }$seam"
done

if [ -n "$missing" ]; then
  echo "no graphical link seam: ${missing}"
  echo "verdict=gated_no_display"
  exit 3
fi
echo "seams present: ${seams}"
echo "verdict=ok"
exit 0
