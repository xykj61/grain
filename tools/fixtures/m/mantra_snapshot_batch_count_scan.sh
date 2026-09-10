#!/bin/sh
# tools/fixtures/m/mantra_snapshot_batch_count_scan.sh -- does a snapshot import
# ask what follows its last declared batch?
#
# WHAT THIS READS. `mantra/snapshot_export.rye` writes a catalog snapshot whose
# header carries a leaf claim and a BATCH COUNT, and `import_catalog` walks
# exactly that many batches. It read no further: the offset it stopped at was
# never compared against the length of the blob it was handed, so bytes standing
# past the last declared batch reached nobody. The module's own error set has
# named that refusal -- `BatchCountMismatch` -- since it was written, and no line
# in the module ever returned it.
#
# WHAT THAT COST, on metal `20260910.140122` in a pen, before a line changed.
# Eight bytes of junk appended to an honest 1,292-byte snapshot: `import_catalog`
# and `import_catalog_horizon` both answered **5 leaves and success**, so two
# different byte strings imported as one catalog. Lowering the declared batch
# count then imported a PREFIX as though it were whole -- `drop=1 claim=3` and
# `drop=2 claim=2` were each accepted by `import_catalog`, since the leaf claim
# is a field the same hand writes. The horizon path refused both prefixes with
# `HeadDigestMismatch`, which names where the defense actually stood: in the head
# record, and in nothing the plain import ever checked.
#
# HOW THE READING IS TAKEN. The module carries its own `selftest`, so this scan
# builds it and reads the lines it prints. Two of those lines are the new ones --
# a padded snapshot refused by name, and a sweep proving no leaf claim admits a
# prefix -- and the ordinary replay legs are read beside them, because a refusal
# that also broke lawful import would be worse than the fault it closed.
#
# READINGS PRINTED, one per line, each a fact rather than a verdict:
#   source=<path>          the module this reading is about
#   named_error_declared=yes|no  `BatchCountMismatch` still stands in the error set
#   edge_check_present=yes|no    the offset is compared against the blob length
#   built=yes|no           the module compiled
#   selftest_exit=<n>      what the selftest left
#   honest_import=yes|no   an ordinary snapshot still replays every leaf
#   tail_refused=yes|no    bytes past the last declared batch are refused
#   prefix_refused=yes|no  no leaf claim imports a prefix as whole
#   verdict=ok|red
#
# Takes one optional argument: the `snapshot_export.rye` to read, so the control
# can point this scan at a mutated copy in a pen. Default is the tree's own.
#
# Driven by tools/m/mantra_snapshot_batch_count_witness.rish. Run from the root.

set -eu

root="$(pwd)"
src="${1:-$root/mantra/snapshot_export.rye}"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
verdict=ok
note_red() { verdict=red; }

echo "source=$src"

if grep -q '^    BatchCountMismatch,$' "$src"; then
  echo "named_error_declared=yes"
else
  echo "named_error_declared=no"; note_red
fi

if grep -q 'if (off != cap_u32(snapshot)) return error.BatchCountMismatch;' "$src"; then
  echo "edge_check_present=yes"
else
  echo "edge_check_present=no"
fi

work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
bin="$work/snapshot-export"

if env RYE_ZIG="$zig" "$rye" build "$src" -femit-bin="$bin" >"$work/build.log" 2>&1; then
  echo "built=yes"
else
  echo "built=no"; note_red
  echo "honest_import=no"
  echo "tail_refused=no"
  echo "prefix_refused=no"
  echo "verdict=red"
  exit 0
fi

out=$( "$bin" selftest 2>&1 || true )
( "$bin" selftest >/dev/null 2>&1 ) && exit_code=0 || exit_code=$?
echo "selftest_exit=$exit_code"

case "$out" in
  *"recall identical on every leaf GREEN"*) echo "honest_import=yes" ;;
  *) echo "honest_import=no"; note_red ;;
esac

case "$out" in
  *"bytes past the last declared batch refused as BatchCountMismatch GREEN"*)
    echo "tail_refused=yes" ;;
  *) echo "tail_refused=no"; note_red ;;
esac

case "$out" in
  *"no leaf claim imports a prefix as whole GREEN"*) echo "prefix_refused=yes" ;;
  *) echo "prefix_refused=no"; note_red ;;
esac

echo "verdict=$verdict"
