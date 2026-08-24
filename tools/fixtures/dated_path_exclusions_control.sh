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

# --- discovery: a planted name is FOUND, and the two things it must never find are not ------------
#
# Each conjunct closes the other's failure mode, and the first attempt at this count proved it by
# getting it wrong: matching on "named in code" alone returned real documents that had merely
# MOVED, and matching on "sprig absent" alone returns every document that was ever DELETED.
dpen=$(mktemp -d)
mkdir -p "$dpen/tools/fixtures" "$dpen/foundations" "$dpen/vendor/x"
cp "$root/tools/fixtures/dated_path_exclusions.sh" "$dpen/tools/fixtures/"

# a real document, and a witness naming it at a DIFFERENT stamp -- a move, never a planting
: > "$dpen/foundations/20260501-120000_a-real-page.md"
printf 'see foundations/20260401-090000_a-real-page.md\n' > "$dpen/tools/fixtures/mover_scan.sh"
# a name an instrument plants: written in code, and its sprig names nothing
printf 'echo 20260101-000000_ghost.md\n' > "$dpen/tools/fixtures/planter_scan.sh"
# a deleted document: sprig names nothing, and no code mentions it
printf 'gone: 20260101-000000_deleted-page.md\n' > "$dpen/A-DOC.md"
# a vendored mention is somebody else's fixture
printf 'echo 20260101-000000_vendored.md\n' > "$dpen/vendor/x/v_scan.sh"

( cd "$dpen" && git init -q . && git add -A \
  && git -c user.email=p@p -c user.name=p commit -qm pen ) >/dev/null 2>&1

d_out=$( cd "$dpen" && . tools/fixtures/dated_path_exclusions.sh && dp_discovered_fixture_basenames . )
has() { printf '%s\n' "$d_out" | grep -qxF -- "$1"; }

has 20260101-000000_ghost.md && echo "discovers_a_planting=yes" || echo "discovers_a_planting=no"
has 20260401-090000_a-real-page.md && echo "moved_doc_free=no" || echo "moved_doc_free=yes"
has 20260101-000000_deleted-page.md && echo "deleted_doc_free=no" || echo "deleted_doc_free=yes"
has 20260101-000000_vendored.md && echo "vendored_free=no" || echo "vendored_free=yes"

# the roster reading itself would discover everything it lists, so it is out of its own corpus
printf 'DP_X="20260101-000000_listed-only.md"\n' >> "$dpen/tools/fixtures/dated_path_exclusions.sh"
( cd "$dpen" && git add -A && git -c user.email=p@p -c user.name=p commit -qm add ) >/dev/null 2>&1
d2=$( cd "$dpen" && . tools/fixtures/dated_path_exclusions.sh && dp_discovered_fixture_basenames . )
printf '%s\n' "$d2" | grep -qxF -- 20260101-000000_listed-only.md \
  && echo "roster_reads_itself=yes" || echo "roster_reads_itself=no"

# and it leaves no scratch file behind in the tree it read
ls "$dpen"/.dp_sprigs.* >/dev/null 2>&1 && echo "discovery_leaves_scratch=yes" || echo "discovery_leaves_scratch=no"
rm -rf "$dpen"

if [ "$real" -eq 0 ] && [ "$planted" -gt 0 ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
