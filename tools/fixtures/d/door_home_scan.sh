#!/bin/sh
# tools/fixtures/d/door_home_scan.sh -- a door that says where home is points at home.
#
# WHY. `**Where this sits:**` is this tree's one navigation sentence, and 117 living pages write
# it by hand. It names up to three places: home, which is the root README; a first hour, which is
# the docs-geode tutorial; and the whole path, which is SOURCE.md. Each is written as a RELATIVE
# link, with the number of `../` steps typed per page by whoever made it.
#
# Measured `20260917.153832`, every one of the 117 home clauses resolves to the root README, so
# nothing is presently wrong. The point is that its being right is care rather than a wall.
#
# THE RISK IS EXACT RATHER THAN HYPOTHETICAL. 49 of the 117 doors sit two or more directories
# deep. From `docs-geode/api/`, a typed `../README.md` resolves to `docs-geode/README.md` -- a
# real file, tracked, opening cleanly, and NOT home. So the two guards that already read links
# both call it fine: `tracked_link_scan.sh` reads whether a target RESOLVES, and the link-text
# promise guard reads the anchor text against the target rather than the target against a
# canonical page. A door copied one level down keeps a sentence that opens somewhere and stops
# pointing home, and every standing meter stays green.
#
# WHAT IS GATED, at zero:
#
#   1. `home_off` -- a door whose home clause resolves to something other than the root README
#
# WHAT IS REPORTED, never gated:
#
#   `home_absent`         -- a door carrying the key and no home clause
#   `first_hour_off`      -- a first-hour clause resolving somewhere other than the tutorial
#   `first_hour_absent`   -- a door naming no first hour
#   `source_off`          -- a whole-path clause resolving somewhere other than SOURCE.md
#   `source_absent`       -- a door naming no whole path
#
# The two optional clauses are reported rather than gated because a page may honestly carry
# fewer: a door one directory from the root has less to say than one four rooms deep, and a gate
# on their presence would refuse an honest page. Their TARGETS are read all the same, so a clause
# that IS written and points wrong is named out loud even though it refuses nothing.
#
# THE HOME CLAUSE IS ANCHORED TO THE KEY, and this is the reading that costs a lap to get right.
# The words `home is` occur TWICE in a door's sentence: the key opens with `home is`, and the
# third clause ends `the whole path from nothing to a signed, sandboxed home is [...](SOURCE.md)`.
# A pattern searching for `home is` takes the LAST one under every POSIX greedy rule and reads the
# SOURCE link as the home target.
#
# Both readings were run on this tree with the anchor struck out, and the two numbers are worth
# keeping side by side. Searching one LINE reports `home_off=1`, since the clause usually wraps
# before its third link -- one name, a page whose home clause is correct. Searching the BLOCK,
# which is what this scan reads and what the count above depends on, reports `home_off=106`
# against 117 doors, exactly the 106 that carry a resolving SOURCE clause. So the anchor is not
# a nicety guarding one page: without it this guard reds the whole tree on its first run and
# every name it prints is wrong. The pen plants the second occurrence to hold it in place.
#
# THE KEY IS A BLOCK, not a line. A door's sentence wraps: 111 of the 117 name a first hour and
# only 4 of them fit it on the key's own line. A line-oriented reading answers 4 where the truth
# is 111, which is a meter reporting a 96% absence rate against a tree that is almost entirely
# fine. The block runs from the key line to the first blank line or the next `**Key:**` header.
#
# BOUNDS. At most 8192 doors are read; a tree past that bound refuses rather than truncating.
# `DOOR_HOME_MAX` lowers that bound, which is how the pen reaches it without planting 8192 pages.
#
#   sh tools/fixtures/d/door_home_scan.sh            # readings, then verdict
#   sh tools/fixtures/d/door_home_scan.sh --list     # every off and absent page by name
#
# ROOT. `DOOR_HOME_ROOT` points the scan at another tree, which is how the control runs it
# against a pen. It defaults to this repository's own root.

set -u

list=no
for a in "$@"; do
  case "$a" in
    --list) list=yes ;;
    *) echo "detail: unknown argument $a"; echo "verdict=bad_argument"; exit 1 ;;
  esac
done

root=${DOOR_HOME_ROOT:-}
if [ -z "$root" ]; then
  root=$(git rev-parse --show-toplevel 2>/dev/null) || root=
fi
if [ -z "$root" ] || [ ! -d "$root" ]; then
  echo "detail: no tree to read -- set DOOR_HOME_ROOT or run inside a git repository"
  echo "verdict=no_tree"
  exit 1
fi
root=$(cd "$root" && pwd -P)

# The three canonical destinations, by real path. A tree lacking one of them is a tree this scan
# cannot answer about, so it refuses rather than calling every door off.
home_page="$root/README.md"
if [ ! -f "$home_page" ]; then
  echo "detail: $root carries no root README.md, so no door's home clause can be checked"
  echo "verdict=no_home_page"
  exit 1
fi
first_hour_page="$root/docs-geode/tutorials/the-first-hour.md"
source_page="$root/SOURCE.md"

DOOR_MAX=${DOOR_HOME_MAX:-8192}
case $DOOR_MAX in
  ''|*[!0-9]*) echo "detail: DOOR_HOME_MAX must be a count"; echo "verdict=bad_bound"; exit 1 ;;
esac

# Population: living tracked Markdown. Dated testimony keeps every word it wrote, so the three
# shelves and any stamped basename are read past (`.claude/rules/stamp-and-name.md`).
# ONE prefilter pass rather than one grep per page. The living tree carries roughly 1,500
# candidate pages and 117 doors, so asking each page separately costs 1,500 processes and read
# 23.1s on metal; one `grep -l` over the whole list finds the same 117 and reads 13.1s.
pages=$(cd "$root" && git ls-files -z -- '*.md' 2>/dev/null \
  | tr '\0' '\n' \
  | grep -vE '(^|/)(date|archive|yonder)/' \
  | grep -vE '(^|/)[0-9]{8}-[0-9]{6}[_.]' \
  | tr '\n' '\0' \
  | xargs -0 -r grep -l '^\*\*Where this sits:\*\*' -- 2>/dev/null)

doors=0
home_on=0; home_off=0; home_absent=0
fh_on=0; fh_off=0; fh_absent=0
so_on=0; so_off=0; so_absent=0
HOME_OFF=''; HOME_ABSENT=''; FH_OFF=''; SO_OFF=''; FH_ABSENT=''; SO_ABSENT=''

# The key's block: its own line plus every continuation, up to a blank line or the next header.
block_of() {
  awk '
    /^\*\*Where this sits:\*\*/ { inb = 1; printf "%s ", $0; next }
    inb && /^[[:space:]]*$/ { exit }
    inb && /^\*\*[A-Za-z][^*]*:\*\*/ { exit }
    inb { printf "%s ", $0 }
  ' "$1"
}

# Resolve a relative target against the page's own directory, as a reader's click would.
resolve() {
  _d=$(dirname "$root/$1")
  ( cd "$_d" 2>/dev/null && readlink -f "$2" 2>/dev/null )
}

for p in $pages; do
  doors=$((doors + 1))
  if [ "$doors" -gt "$DOOR_MAX" ]; then
    echo "detail: more than $DOOR_MAX doors stand in this tree, past the bound this scan names"
    echo "verdict=door_bound"
    exit 1
  fi
  b=$(block_of "$root/$p")

  # HOME -- anchored to the key rather than searched for in the line. See the header.
  t=$(printf '%s\n' "$b" | sed -n 's/^\*\*Where this sits:\*\* *home is \[`[^`]*`\](\([^)]*\)).*/\1/p')
  if [ -z "$t" ]; then
    home_absent=$((home_absent + 1)); HOME_ABSENT="$HOME_ABSENT $p"
  elif [ "$(resolve "$p" "$t")" = "$home_page" ]; then
    home_on=$((home_on + 1))
  else
    home_off=$((home_off + 1)); HOME_OFF="$HOME_OFF $p"
  fi

  # FIRST HOUR -- optional, and read wherever in the block it was written.
  t=$(printf '%s\n' "$b" | sed -n 's/.*first hour[^[]*is \[`[^`]*`\](\([^)]*\)).*/\1/p')
  if [ -z "$t" ]; then
    fh_absent=$((fh_absent + 1)); FH_ABSENT="$FH_ABSENT $p"
  elif [ "$(resolve "$p" "$t")" = "$first_hour_page" ]; then
    fh_on=$((fh_on + 1))
  else
    fh_off=$((fh_off + 1)); FH_OFF="$FH_OFF $p"
  fi

  # WHOLE PATH -- optional, same reading.
  t=$(printf '%s\n' "$b" | sed -n 's/.*whole path[^[]*is \[`[^`]*`\](\([^)]*\)).*/\1/p')
  if [ -z "$t" ]; then
    so_absent=$((so_absent + 1)); SO_ABSENT="$SO_ABSENT $p"
  elif [ "$(resolve "$p" "$t")" = "$source_page" ]; then
    so_on=$((so_on + 1))
  else
    so_off=$((so_off + 1)); SO_OFF="$SO_OFF $p"
  fi
done

echo "doors=$doors"
echo "home_on=$home_on home_off=$home_off home_absent=$home_absent"
echo "first_hour_on=$fh_on first_hour_off=$fh_off first_hour_absent=$fh_absent"
echo "source_on=$so_on source_off=$so_off source_absent=$so_absent"

if [ "$list" = yes ]; then
  for x in $HOME_OFF; do echo "list: home_off $x"; done
  for x in $HOME_ABSENT; do echo "list: home_absent $x"; done
  for x in $FH_OFF; do echo "list: first_hour_off $x"; done
  for x in $SO_OFF; do echo "list: source_off $x"; done
  for x in $FH_ABSENT; do echo "list: first_hour_absent $x"; done
  for x in $SO_ABSENT; do echo "list: source_absent $x"; done
fi

# Reported rather than gated: a clause that is written and points wrong is named out loud, so a
# reader meets it, and refuses nothing, since neither clause is owed by any page.
for x in $FH_OFF; do echo "detail: $x names a first hour that is not the tutorial"; done
for x in $SO_OFF; do echo "detail: $x names a whole path that is not SOURCE.md"; done
if [ "$home_absent" -gt 0 ]; then
  for x in $HOME_ABSENT; do echo "detail: $x carries the key and names no home"; done
fi

if [ "$home_off" -gt 0 ]; then
  for x in $HOME_OFF; do
    echo "detail: $x says where home is and points somewhere else"
  done
  echo "verdict=home_off"
  exit 1
fi

echo "verdict=ok"
