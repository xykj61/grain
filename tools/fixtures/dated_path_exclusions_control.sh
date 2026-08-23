#!/bin/sh
# tools/fixtures/dated_path_exclusions_control.sh -- the single-list rule, proven both ways.
#
# WHY. The census and the repointer act on one corpus and must agree on what is not the field. For
# a day they kept private copies, diverged twice, and the second divergence let the repointer
# rewrite the witness fixture that proves it is needed (REDS %121). One list now, sourced by both.
#
# A rule like that is only worth writing down if something notices when it lapses. So this plants a
# copy of each tool carrying a hand-rolled exclusion flag, and checks the detector refuses it --
# and checks it accepts the real ones, which is the half that keeps the rule from being a nuisance.
#
# EXPECTED: private_copy_refused=yes, real_tools_accepted=yes.
#
# Driven by tools/d/dated_path_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# The detector, in one place: a CODE line (not a comment) carrying a hand-rolled exclusion flag.
detect() {
  grep -nE -- '--exclude|! -name|! -path' "$1" 2>/dev/null | grep -vE '^[0-9]+:[[:space:]]*#' | wc -l | tr -d ' '
}

real=0
for f in "$root/tools/fixtures/dated_path_scan.sh" "$root/tools/fixtures/dated_path_repoint_scan.sh"; do
  n=$(detect "$f")
  real=$((real + n))
  sourced=$(grep -c 'dated_path_exclusions.sh' "$f" || true)
  [ "$sourced" -ge 1 ] || { echo "control: $f does not source the shared list" >&2; exit 1; }
done
echo "real_tools_hand_rolled=$real"
echo "real_tools_accepted=$([ "$real" -eq 0 ] && echo yes || echo no)"

# A planted private copy: the same tool with one exclusion written by hand again.
cp "$root/tools/fixtures/dated_path_scan.sh" "$work/private.sh"
printf 'grep -r --exclude=some_control.sh . >/dev/null 2>&1 || true\n' >> "$work/private.sh"
planted=$(detect "$work/private.sh")
echo "planted_hand_rolled=$planted"
echo "private_copy_refused=$([ "$planted" -gt 0 ] && echo yes || echo no)"

if [ "$real" -eq 0 ] && [ "$planted" -gt 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
