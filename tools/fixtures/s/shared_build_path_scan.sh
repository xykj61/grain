#!/bin/sh
# shared_build_path_scan.sh -- witness build sites that emit to a literal path in the tree.
#
#   sh tools/fixtures/s/shared_build_path_scan.sh [--list]
#
# WHY THIS READING EXISTS (REDS %700). A guard that builds its binary to a fixed path in the tree
# shares that name with every other run in the same checkout. One run EXECUTES the binary while
# another run's linker opens the same path to write it, and the linker refuses: `failed to open
# output binary: FileBusy`, which is ETXTBSY. The guard then answers red on bytes nobody changed --
# it is FLAKY (`.claude/rules/vocabulary-flaky.md`), and a flaky guard is a defect in the EVIDENCE
# LAYER rather than in one witness, since a green from it cannot be told from a sound one.
#
# Caught in the act `20260915` by running three copies of one witness at once in ONE checkout: two
# red, one green, over identical bytes. A peer had repaired a shared PORT in the same guard four
# days earlier, which could never reach this: a port is a name on the MACHINE, a build path is a
# name in the TREE, and one flaky guard wore both.
#
# THE READING RESOLVES THE VARIABLE, which is the whole reason this file is longer than a grep.
# The dominant spelling is `-femit-bin=${bin}`, and a Rishi `${bin}` is almost always
# `let bin = "lotus/bin/thing"` -- a literal tree path wearing a variable's clothes. Two earlier
# hand counts of this same class read 304 and then 51 because they stopped at the dollar sign;
# following `let` to its value reads the tree as it is.
#
# WHAT IT CANNOT SAY. Whether a given site has ever actually collided, and at what rate. The window
# is the time between link and exit, so a fast build-and-run is a smaller target than a slow one --
# and every site is reachable, because this pier runs a detached roster pass beside laps that run
# guards by hand. This counts STRUCTURE, never incidents.
#
# THE BOUND IS A RATCHET THAT ONLY FALLS. The backlog was not made today, and a gate that reds on
# ordinary work is a gate somebody turns off. A site migrated to a pen lowers the count; lower the
# ceiling in the same commit.
set -eu

CEILING=${SHARED_BUILD_PATH_CEILING:-1813}
list=no
[ "${1:-}" = "--list" ] && list=yes

root=$(cd "$(dirname "$0")/../../.." && pwd -P)
cd "$root"

git ls-files 'tools/*/*witness.rish' > .shared_build_path.files 2>/dev/null || : > .shared_build_path.files

awk -v want_list="$list" '
FNR == 1 { delete val; delete penvar; files++ }
# let <name> = "<value>"   -- record what a Rishi binding holds
/^[ \t]*let[ \t]+[A-Za-z_][A-Za-z0-9_]*[ \t]*=/ {
  line = $0
  sub(/^[ \t]*let[ \t]+/, "", line)
  name = line
  sub(/[ \t]*=.*$/, "", name)
  rest = line
  sub(/^[^=]*=[ \t]*/, "", rest)
  if (rest ~ /^"/) { sub(/^"/, "", rest); sub(/".*$/, "", rest) }
  val[name] = rest
  if ($0 ~ /mktemp/) penvar[name] = 1
}
/femit-bin=/ {
  n = split($0, parts, "femit-bin=")
  for (i = 2; i <= n; i++) {
    t = parts[i]
    sub(/[ \t"\047].*$/, "", t)
    if (t == "") continue
    sites++
    resolved = t
    # ${name} or $name -> its recorded value, once; a binding of a binding stays unresolved
    if (t ~ /^\$\{[A-Za-z_][A-Za-z0-9_]*\}$/) {
      k = t; sub(/^\$\{/, "", k); sub(/\}$/, "", k)
      if (k in val) resolved = val[k]
    }
    # A MIGRATED SITE NAMES ITS PEN THROUGH A SECOND BINDING, and a reader that stops at one
    # level calls it unresolved -- so the meter would go blind to its own repair, and a room
    # migrated tomorrow would look like a room that merely got harder to read.
    penned = ($0 ~ /mktemp/) || (resolved ~ /mktemp/)
    if (!penned) for (pv in penvar) if (index(resolved, "${" pv ".out}") > 0) penned = 1
    if (penned) { penned_n++; continue }
    if (resolved ~ /\$/) { unresolved++; continue }   # a shell variable this pass cannot follow
    if (resolved ~ /\//) {
      fixed++
      if (!(FILENAME in seen)) { seen[FILENAME] = 1; fixed_files++ }
      if (want_list == "yes") print "site: " FILENAME " -> " resolved
    } else {
      unresolved++
    }
  }
}
END {
  printf "files_scanned=%d\n", files
  printf "build_sites=%d\n", sites
  printf "sites_fixed_tree_path=%d\n", fixed
  printf "sites_penned=%d\n", penned_n
  printf "sites_unresolved=%d\n", unresolved
  printf "files_with_fixed=%d\n", fixed_files
}
' $(cat .shared_build_path.files) /dev/null > .shared_build_path.out 2>/dev/null || :

rm -f .shared_build_path.files
[ "$list" = yes ] && grep '^site: ' .shared_build_path.out || :
grep -v '^site: ' .shared_build_path.out
fixed=$(grep '^sites_fixed_tree_path=' .shared_build_path.out | cut -d= -f2)
rm -f .shared_build_path.out
: "${fixed:=0}"
echo "ceiling=$CEILING"
if [ "$fixed" -le "$CEILING" ]; then echo "verdict=ok"; else echo "verdict=over_ceiling"; fi
