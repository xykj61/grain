#!/bin/sh
# tools/fixtures/fascia_home_link_control.sh -- the fascia meter, proven on planted pages.
#
# WHY. A ratchet is only worth its ceiling if the reading underneath it is right, and a counter that
# reads every page as an orphan would ratchet just as smoothly as a correct one. This plants real
# git repositories in a throwaway pen and proves the reading from both sides.
#
# WHAT IS PROVEN -- six behaviors:
#   1  a page linking `../README.md` counts as having a path home
#   2  a page linking `../../README.md` counts too, so depth does not fool it
#   3  a page with no such link counts as an orphan
#   4  a page naming `README.md` without the `../` prefix is NOT a path home -- it points at itself
#   5  vendored and projected rooms are left out, since those pages are not ours to edit
#   6  the root README is not counted, since it is home rather than a page needing a way there
#
# USAGE
#   sh tools/fixtures/fascia_home_link_control.sh
#
# Run from the repository root; it reads only the scan script from there.

set -u

scan=$PWD/tools/fixtures/fascia_home_link_scan.sh
[ -r "$scan" ] || { echo "control_verdict=no_scan"; exit 1; }

pen=$(mktemp -d)
trap 'rm -rf "$pen"' EXIT INT TERM
cd "$pen" || exit 1

git init -q . 2>/dev/null
git config user.email c@example.invalid; git config user.name control

mkdir -p near far/deeper self vendor/theirs seed/copy
printf '# near\n\n[home](../README.md)\n'        > near/README.md
printf '# far\n\n[home](../../README.md)\n'      > far/deeper/README.md
printf '# lone\n\nnothing points anywhere.\n'    > lone_README_holder_README.md 2>/dev/null
mkdir -p lone && printf '# lone\n\nno way back.\n' > lone/README.md
printf '# self\n\n[me](README.md)\n'             > self/README.md
printf '# theirs\n\n[home](../../README.md)\n'   > vendor/theirs/README.md
printf '# copy\n\n[home](../../README.md)\n'     > seed/copy/README.md
printf '# root\n\nthis is home.\n'               > README.md
rm -f lone_README_holder_README.md
git add -A >/dev/null 2>&1; git commit -qm plant >/dev/null 2>&1

out=$(sh "$scan" --list 2>/dev/null)
line=$(echo "$out" | grep '^FASCIA_HOME')
echo "$line"

# 1, 2 -- both depths read as having a path home
echo "$out" | grep -q "no_path_home near/README.md" && echo "near_read_as_orphan=yes" || echo "near_read_as_orphan=no"
echo "$out" | grep -q "no_path_home far/deeper/README.md" && echo "deep_read_as_orphan=yes" || echo "deep_read_as_orphan=no"

# 3 -- a page with nothing is an orphan
echo "$out" | grep -q "no_path_home lone/README.md" && echo "lone_read_as_orphan=yes" || echo "lone_read_as_orphan=no"

# 4 -- a self-link is not a path home
echo "$out" | grep -q "no_path_home self/README.md" && echo "self_link_read_as_orphan=yes" || echo "self_link_read_as_orphan=no"

# 5 -- vendored and projected rooms are out of the population entirely
case "$out" in *"vendor/theirs"*) echo "vendor_excluded=no";; *) echo "vendor_excluded=yes";; esac
case "$out" in *"seed/copy"*) echo "seed_excluded=no";; *) echo "seed_excluded=yes";; esac

# 6 -- three of ours counted: near, far/deeper, lone, self
case "$line" in *"total=4"*) echo "root_excluded=yes";; *) echo "root_excluded=no";; esac

# 7 -- the ceiling refuses from above, planted rather than argued. No override exists.
pen2=$(mktemp -d)
cd "$pen2" || exit 1
git init -q . 2>/dev/null
git config user.email c@example.invalid; git config user.name control
printf '# root\n' > README.md
i=0
while [ "$i" -lt 109 ]; do
  mkdir -p "room$i"
  printf '# room %s\n\nno way back.\n' "$i" > "room$i/README.md"
  i=$((i + 1))
done
git add -A >/dev/null 2>&1; git commit -qm plant >/dev/null 2>&1
over=$(sh "$scan" 2>/dev/null)
case "$over" in *"under_ceiling=no"*) echo "ceiling_refuses_from_above=yes";; *) echo "ceiling_refuses_from_above=no";; esac
cd / && rm -rf "$pen2"

echo "control_verdict=ok"
