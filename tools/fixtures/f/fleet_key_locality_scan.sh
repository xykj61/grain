#!/bin/sh
# Every path a fleet tree's git config names must live inside that tree.
#
# WHY THIS GUARD EXISTS, and why no standing one could have caught it: `agent-jail.sh` binds
# exactly ONE tree into the enclosure, so a `gpg.program` or an `IdentityFile` naming a sibling
# is a path the ship cannot see from inside its own jail. grain-pheromone was born holding
# petrichor's wrapper and petrichor's deploy key, and could neither sign nor push from its
# enclosure -- while every check run at a host prompt passed, because at a host prompt the
# sibling is right there. The fault is invisible from outside the wall and total inside it.
#
# And it lives where nothing else looks: `.git/config` and `.git/ssh_config_jail` are UNTRACKED
# by design (they hold custody paths), so `tracked_link_scan.sh` cannot reach them, the commit
# hook's path check cannot reach them, and the link duty cannot reach them. This scan reads the
# working tree's own untracked files, which is the one way the reading is available at all.
#
# Reads the fleet roster for seats. A seat whose tree is absent from this pier is REPORTED and
# never counted -- a fresh clone holds one tree, and a guard that reds on that is a guard the
# next clone turns off.
set -u
here=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd) || exit 1
roster="$here/tools/fixtures/f/fleet_roster_scan.sh"

# THE INSTRUMENT IS PROVEN PRESENT BEFORE IT IS TRUSTED (REDS %413). A scan whose helper is
# missing must refuse loudly; the elder shape discarded the error and printed a clean zero,
# which reads exactly like a pass.
if [ ! -f "$roster" ]; then
  echo "fleet_key_locality: REFUSED -- the roster scan is absent at $roster" >&2
  exit 2
fi

seats=$(sh "$roster" --live 2>/dev/null) || {
  echo "fleet_key_locality: REFUSED -- the roster scan would not list live seats" >&2
  exit 2
}
[ -n "$seats" ] || { echo "fleet_key_locality: REFUSED -- the roster listed no live seat" >&2; exit 2; }

pier=$(dirname "$here")
foreign=0; checked=0; absent=0; trees=0

for seat in $seats; do
  name=$(sh "$roster" --tree "$seat" 2>/dev/null) || continue
  [ -n "$name" ] || continue
  tree="$pier/$name"
  if [ ! -d "$tree/.git" ]; then
    absent=$((absent + 1))
    echo "absent: $seat ($name) -- not on this pier, not counted"
    continue
  fi
  trees=$((trees + 1))

  # The two config values, then every absolute path inside the ssh config they point at.
  gp=$(git -C "$tree" config --local --get gpg.program 2>/dev/null || true)
  sc=$(git -C "$tree" config --local --get core.sshCommand 2>/dev/null || true)
  cfg="$tree/.git/ssh_config_jail"
  paths=""
  [ -n "$gp" ] && paths="$paths $gp"
  # core.sshCommand is `ssh -F <path>`; the last field is the path.
  case "$sc" in *' '*) paths="$paths ${sc##* }" ;; esac
  if [ -f "$cfg" ]; then
    inner=$(LC_ALL=C awk '$1=="IdentityFile"||$1=="UserKnownHostsFile"{print $2}' "$cfg" 2>/dev/null)
    paths="$paths $inner"
  fi

  # THE PATH IS RESOLVED BEFORE IT IS COMPARED. A symlink is this exact fault wearing a disguise:
  # `grain-pheromone/.gnupg-rye -> ../grain-petrichor/.gnupg-rye` reads as a local path in the
  # config and lands in a sibling on disk, so a guard comparing the written string would call it
  # local and the ship would still refuse inside its jail. `cd`/`pwd -P` rather than `readlink -f`,
  # which is GNU-only -- the dialect guard has already caught this tree reaching for a GNU flag.
  tphys=$(CDPATH= cd -- "$tree" 2>/dev/null && pwd -P) || tphys="$tree"
  for pth in $paths; do
    case "$pth" in /*) ;; *) continue ;; esac   # relative paths resolve inside the tree already
    checked=$((checked + 1))
    pdir=$(CDPATH= cd -- "$(dirname -- "$pth")" 2>/dev/null && pwd -P)
    if [ -n "$pdir" ]; then real="$pdir/$(basename -- "$pth")"; else real="$pth"; fi
    case "$real" in
      "$tphys"/*) ;;
      *) foreign=$((foreign + 1))
         if [ "$real" = "$pth" ]; then
           echo "foreign: $seat names $pth -- outside $tree, unreachable from its jail"
         else
           echo "foreign: $seat names $pth, which resolves to $real -- outside $tree, unreachable from its jail"
         fi ;;
    esac
  done
done

# REPORTED, NEVER GATED: how many of the fleet's own signing keys this tree can verify with. A ship
# missing a peer's PUBLIC key still signs and pushes perfectly -- it just reads that peer's commits
# as `E` (cannot check), which is indistinguishable at a glance from `N` (unsigned). That ambiguity
# is what hid REDS %427 for a day: pheromone's `%G?` read `N` on five commits and the tree was read
# as unsigned, when the objects carried `gpgsig` all along and gpg was simply failing to exec.
for seat in $seats; do
  name=$(sh "$roster" --tree "$seat" 2>/dev/null) || continue
  [ -n "$name" ] || continue
  [ -d "$pier/$name/.gnupg-rye" ] || continue
  n=$(GNUPGHOME="$pier/$name/.gnupg-rye" gpg --list-keys 2>/dev/null | grep -c '^pub')
  echo "verifies_with: $seat holds $n fleet public key(s)"
done

echo "trees=$trees"
echo "absent_trees=$absent"
echo "paths_checked=$checked"
echo "foreign_paths=$foreign"
if [ "$foreign" -eq 0 ]; then echo "verdict=every_path_is_local"; else echo "verdict=foreign_path"; fi
