#!/bin/sh
# tools/fixtures/p/page_evict_control.sh -- the eviction wall, shown from both sides.
#
#   sh tools/fixtures/p/page_evict_control.sh
#
# WHY THIS EXISTS. `tools/rye/page_evict.rye` claims two things: that it drops this tree's cached
# pages and proves it by reading residency back, and that it refuses every path landing outside
# this tree. The second claim is the one peers depend on, since a tool that evicted the wrong
# inode would charge seven other ships for one ship's measurement. A refusal proven only in the
# passing direction cannot be told from a bypass, so every refusal here is planted on a real path
# and required to BITE, and every welcome is asserted as hard as every refusal.
#
# READINGS: `cases=N fail=M` and a `control_verdict=` line. Exit 1 when any case fails.
set -u

ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"
BIN="$ROOT/tools/bin/page-evict"

cases=0
fail=0

pen="$ROOT/.lap/page_evict_control"
rm -rf "$pen"
mkdir -p "$pen" || { echo "control_verdict=no_pen"; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

check() {
  name=$1; want=$2; got=$3
  cases=$((cases + 1))
  if [ "$want" = "$got" ]; then
    echo "ok   $name ($got)"
  else
    echo "FAIL $name -- wanted $want, read $got"
    fail=$((fail + 1))
  fi
}

# Every claim line this program prints goes to stderr, as every hosted Rye program in this tree
# prints through `std.debug.print`. The redirect is what puts the census where awk can read it --
# without it every reading below comes back empty and each check fails for the wrong reason.
resident_of() {
  "$BIN" census "$1" 2>&1 | awk '{for (i=1;i<=NF;i++) if ($i ~ /^resident_pages=/) { sub(/^resident_pages=/,"",$i); print $i } }'
}

[ -x "$BIN" ] || { echo "control_verdict=no_binary"; exit 1; }

# -- the refusals, each on a real path a typo could actually reach ----------------------------

"$BIN" census /nix/store >/dev/null 2>&1
check "outside_tree_refuses" 3 $?

"$BIN" evict /etc >/dev/null 2>&1
check "system_path_refuses" 3 $?

peer=$(dirname "$ROOT")/grain-bakery
if [ -d "$peer" ]; then
  "$BIN" census "$peer" >/dev/null 2>&1
  check "peer_tree_refuses" 3 $?
else
  # A pier without that peer checked out still proves the class, through a sibling of its own
  # making whose name merely begins the way this root does.
  mkdir -p "$ROOT-control-peer" 2>/dev/null && : >"$ROOT-control-peer/x"
  "$BIN" census "$ROOT-control-peer/x" >/dev/null 2>&1
  check "same_prefix_sibling_refuses" 3 $?
  rm -rf "$ROOT-control-peer"
fi

# -- the welcome, asserted as hard as the refusals ----------------------------------------------

"$BIN" census "$ROOT/tools/rye/page_evict.rye" >/dev/null 2>&1
check "own_tree_welcomed" 0 $?

# A path inside the tree reached through a symbolic link is welcomed by where it LANDS. This tree
# spells `rye/lib` as links into `vendor/`, so a checker reading the spelling would be checking a
# name rather than a file.
if [ -e "$ROOT/rye/lib/std/std.zig" ]; then
  "$BIN" census "$ROOT/rye/lib/std/std.zig" >/dev/null 2>&1
  check "in_tree_symlink_welcomed" 0 $?
fi

# -- residency, read rather than assumed ---------------------------------------------------------

big="$pen/warm.bin"
dd if=/dev/urandom of="$big" bs=65536 count=64 >/dev/null 2>&1
sync

warm=$(resident_of "$big")
check "written_file_is_resident" 64 "$(( warm >= 1000 ? 64 : 0 ))"

# A census changes nothing. A reader that evicted what it measured would make every before-and-
# after pair meaningless.
again=$(resident_of "$big")
check "census_moves_no_page" "$warm" "$again"

"$BIN" evict "$big" >/dev/null 2>&1
after=$(resident_of "$big")
check "evict_drops_the_pages" 0 "$after"

# -- the honest limit, proven rather than described ----------------------------------------------
#
# `POSIX_FADV_DONTNEED` declines a DIRTY page, correctly, since dropping one would lose the write.
# A caller writing a file it then means to evict owes it an fsync first, and this leg is what keeps
# that sentence in the header true.
dirty="$pen/dirty.bin"
dd if=/dev/urandom of="$dirty" bs=65536 count=64 >/dev/null 2>&1
"$BIN" evict "$dirty" >/dev/null 2>&1
dirty_left=$(resident_of "$dirty")
check "dirty_pages_survive_the_advice" 1 "$(( dirty_left > 0 ? 1 : 0 ))"

sync
"$BIN" evict "$dirty" >/dev/null 2>&1
clean_left=$(resident_of "$dirty")
check "synced_pages_then_drop" 0 "$clean_left"

# -- the selftest itself walks free in this same pen ---------------------------------------------

"$BIN" selftest >/dev/null 2>&1
check "selftest_green" 0 $?

echo "cases=$cases fail=$fail"
if [ "$fail" -eq 0 ]; then
  echo "control_verdict=ok"
  exit 0
fi
echo "control_verdict=failed"
exit 1
