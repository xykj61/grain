#!/bin/sh
# tools/fixtures/m/mantra_weave_head_scan.sh -- the module head, held to the module.
#
# WHAT THIS READS. mantra/src/weave.rye opens with a `//!` head that ENUMERATES the
# operations the module publishes. An enumeration is a claim with a count inside it, and
# nothing in this tree read it: the merge guard greps for `pub fn merge`, which proves the
# function exists and never that the head knows about it. So `merge` landed on 20260906 and
# the head went on saying "Three operations" over four, in the file the whole module is read
# from (REDS %483).
#
# TWO READINGS, BOTH GATED AT ZERO, because a list can be wrong in two directions and a
# guard watching one of them reports the other as green:
#
#   head_missing  -- a `pub fn` of Weave that no head line names. This is the direction that
#                    actually fired: an operation lands and the head stays behind.
#   head_stale    -- a head line naming an operation the module no longer publishes. The
#                    mirror, and the one a rename produces.
#
# WHAT COUNTS AS AN OPERATION. A `pub fn` declared inside `pub const Weave = struct {`, which
# is the module's last container -- so the scope is "after that line". Indentation alone was
# the first draft and it was wrong: `Note`'s four readers sit at the same four-space indent,
# because `Note` is a top-level container too, and the guard read them as operations of the
# weave. They are deliberately out of scope -- they read a value the module hands back rather
# than advancing a weave, and a head listing every accessor stops being read at all.
#
# If that container line is ever renamed, the scan refuses under `weave_container_absent`
# rather than counting zero operations and answering ok. A census that reads nothing and says
# nothing is wrong is indistinguishable from a healthy file (REDS %463), and this one would
# have been exactly that on the lap somebody renamed the struct.
#
# THE HEAD'S OWN SHAPE. A listed operation is a `//!` line indented by exactly three spaces
# -- the list indent -- whose first word is the operation name followed by `(`, with an
# optional receiver in front of it: `//!   weave.merge(alloc, other) -- one weave from two`.
# Both halves of that anchor earn their place. The three spaces separate a list entry from
# head prose, which is indented by one; and the receiver is stripped rather than required, so
# the head keeps the `Weave.empty()` form a reader can copy. Searching the head for a name
# anywhere would have counted the opening paragraph's `current()` -- it stands there in an
# ordinary sentence -- as the entry for `current`.
#
# EXPECTED: container_seen=1, head_missing=0, head_stale=0, verdict=ok.
#
# Driven by tools/m/mantra_weave_annotate_witness.rish. Run from the repository root.

set -eu

module="${1:-mantra/src/weave.rye}"

if [ ! -f "$module" ]; then
  echo "module=$module"
  echo "container_seen=0"
  echo "head_missing=0"
  echo "head_stale=0"
  echo "verdict=module_absent"
  exit 1
fi

readings="$(awk '
  # A head entry: //! then the operation name with its open parenthesis.
  /^\/\/!   ([A-Za-z_]+\.)?[a-z_]+\(/ {
    name = $2
    sub(/\(.*/, "", name)
    sub(/^.*\./, "", name)
    listed[name] = 1
    listed_n++
    next
  }
  # The last container in the file. Everything below it belongs to Weave.
  /^pub const Weave = struct \{/ { in_weave = 1; next }
  # A published operation of Weave: pub fn at four-space indent, inside it.
  in_weave && /^    pub fn [a-z_]+\(/ {
    name = $3
    sub(/\(.*/, "", name)
    declared[name] = 1
    declared_n++
  }
  END {
    missing = 0
    stale = 0
    for (n in declared) if (!(n in listed)) { print "detail head_missing " n; missing++ }
    for (n in listed) if (!(n in declared)) { print "detail head_stale " n; stale++ }
    print "container_seen=" in_weave + 0
    print "declared=" declared_n + 0
    print "listed=" listed_n + 0
    print "head_missing=" missing
    print "head_stale=" stale
    # A file publishing nothing, or a head listing nothing, is a state the pen can build and
    # the tree cannot -- name it rather than answering zero of everything, which is the one
    # verdict indistinguishable from a healthy file (REDS %463).
    if (in_weave + 0 == 0) { print "verdict=weave_container_absent"; exit }
    if (declared_n + 0 == 0) { print "verdict=no_operations_declared"; exit }
    if (listed_n + 0 == 0) { print "verdict=head_lists_nothing"; exit }
    if (missing + stale > 0) { print "verdict=head_disagrees"; exit }
    print "verdict=ok"
  }
' "$module")"

echo "module=$module"
printf '%s\n' "$readings"

# The verdict is read back from the lines just printed rather than taken from an exit status
# a pipeline would swallow -- an instrument whose refusal reaches nobody is the fault this
# tree keeps booking (REDS %472), and a reader can check this answer against the lines above
# it rather than being asked to trust one.
case "$readings" in
  *"verdict=ok"*) exit 0 ;;
  *) exit 1 ;;
esac
