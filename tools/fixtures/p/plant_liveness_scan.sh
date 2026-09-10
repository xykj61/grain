#!/bin/sh
# tools/fixtures/p/plant_liveness_scan.sh -- check mutations against their tracked source.
#
# A control can keep testing an unchanged file after its sed pattern goes stale.
# This scan resolves single-quoted writing sed commands to tracked paths, then
# compares each complete result with its source. Identical bytes name a dead plant.
# The adoption scan beside this file answers who uses the shared plant helper;
# liveness answers whether a mutation changes the source it names today (REDS %519).
#
# Resolution covers literal variable assignments and paths behind a root variable.
# Unresolved targets are reported separately; they remain outside this proof.
# Control-authored fixtures are often in that group. This is a partial shell reader,
# so its counts describe the recognized forms, rather than every possible mutation.
#
# GNU sed's --sandbox disables command execution and file reads/writes in programs.
# Probe sed/gsed and timeout/gtimeout; a missing capability exits 2 by name.
# Each program gets a five-second deadline, one second of kill grace, and a
# native shell file-size limit. A failed
# program exits 1, separately from a successful transform that changes no bytes.
# Each invocation owns a temporary directory below this repository's session-output.
#
# Run from a repository. The control proves live, dead, repaired, and failed plants.

set -u

root=$(git rev-parse --show-toplevel 2>/dev/null) || { echo "verdict=no_repository"; exit 1; }
cd "$root" || { echo "verdict=no_repository"; exit 1; }

sandbox_sed=''
for candidate in sed gsed; do
  if "$candidate" --sandbox '' </dev/null >/dev/null 2>&1; then
    sandbox_sed=$candidate
    break
  fi
done
deadline_tool=''
for candidate in timeout gtimeout; do
  if "$candidate" -k 1 1 sh -c : >/dev/null 2>&1; then
    deadline_tool=$candidate
    break
  fi
done
want_list=no
[ "${1:-}" = --list ] && { want_list=yes; shift; }
if [ "${1:-}" = --capability ]; then
  if [ -n "$sandbox_sed" ] && [ -n "$deadline_tool" ]; then echo present; else echo absent; fi
  exit 0
fi
if [ -z "$sandbox_sed" ] || [ -z "$deadline_tool" ]; then
  echo "verdict=unavailable_safe_sed"
  echo "refused: plant liveness requires sed/gsed --sandbox and timeout/gtimeout" >&2
  exit 2
fi
# A typo can create a valid infinite sed loop. Bound its time and file output;
# 4096 native shell file-size units keeps even a printing loop in a small pen.
max_program_seconds=5
max_output_blocks=4096
mkdir -p "$root/session-output"
pen=$(mktemp -d "$root/session-output/plant-liveness.XXXXXX") || exit 2
trap 'rm -rf "$pen"' EXIT HUP INT TERM

controls=0
resolved=0
live=0
dead=0
unresolved=0
failed=0

for f in $(git ls-files 'tools/fixtures/*_control.sh'); do
  [ -f "$f" ] || continue
  controls=$((controls + 1))

  # Literal path assignments in this control: `name=path.ext` or `name="path.ext"`. Only a value
  # that LOOKS like a repository path is kept, so `mode="$3"` and `zig=$1` are passed over.
  # A control names its target three ways, and all three are read here: bare
  # (`src=caravan/edge.rye`), quoted (`src="caravan/edge.rye"`), and prefixed by a root or pen
  # variable (`SCAN="$ROOT/tools/fixtures/am/amphora_roster_scan.sh"`). The prefix is dropped and
  # the remainder offered to `git ls-files` below, which decides -- so a pen path the control
  # authored resolves to nothing and reads `unresolved`, exactly as it should, while a tracked
  # source behind a `$ROOT/` resolves and is measured.
  vars=$(sed -n 's/^[[:space:]]*\([a-zA-Z_][a-zA-Z0-9_]*\)="\{0,1\}\(\$[{]\{0,1\}[a-zA-Z_][a-zA-Z0-9_]*[}]\{0,1\}\/\)\{0,1\}\([a-zA-Z][a-zA-Z0-9_\/.-]*\.[a-z][a-z0-9]\{1,5\}\)"\{0,1\}[[:space:]]*$/\1 \3/p' "$f")

  # Each single-quoted sed program in the file, with the line it stands on.
  # Only a sed that WRITES is a plant. A `sed -n ... p` reading a file into a variable mutates
  # nothing, and counting one as an unresolved plant would inflate the reported number with lines
  # that were never plants at all. The two writing forms are a redirect and an in-place rewrite.
  sed -n "/\(^\|[[:space:]]\)sed \(-[a-zA-Z.]* \)*'/=" "$f" | while read -r ln; do
    body=$(sed -n "${ln}p" "$f")
    case "$body" in
      \#*|[[:space:]]*\#*) continue ;;
    esac
    # A DESCRIPTOR DUPLICATION IS NOT A WRITE. `>&2` and `>&1` carry the same `>` character a file
    # redirect does, so testing the raw line for `>` reads `sed -n '1,20p' "$log" >&2` -- a
    # diagnostic READ printed to stderr -- as a writing plant. Two such lines stood inside
    # `plants_unresolved` while the comment above declared exactly this inflation avoided
    # (REDS %519). Strip the duplications first, then ask whether a file redirect remains.
    written=$(printf '%s\n' "$body" | sed 's/>&[0-9-]//g')
    case "$written" in
      "sed -i"*|*" sed -i"*) : ;;
      "sed "*">"*|*" sed "*">"*) : ;;
      *) continue ;;
    esac
    prog=$(printf '%s\n' "$body" | sed -n "s/^\(.*[[:space:]]\)\{0,1\}sed \(-[a-zA-Z.]* \)*'\(.*\)'[^']*\$/\3/p")
    [ -n "$prog" ] || continue

    # Preserve the supported reading flags; only in-place output is removed.
    flags=$(printf '%s\n' "$body" | sed -n "s/^\(.*[[:space:]]\)\{0,1\}sed \(\(-[a-zA-Z.]* \)*\)'.*\$/\2/p")
    set --
    supported=yes
    for flag in $flags; do
      case "$flag" in
        -i|-i.*|-e) : ;;
        -n|-E|-r) set -- "$@" "$flag" ;;
        *) supported=no ;;
      esac
    done
    if [ "$supported" = no ]; then echo "U $f:$ln"; continue; fi

    # Read the input operand alone. A variable in the sed program or output
    # redirect names a different role and cannot establish the source path.
    args=$(printf '%s\n' "$body" | sed -n "s/^\(.*[[:space:]]\)\{0,1\}sed \(-[a-zA-Z.]* \)*'\(.*\)'\([^']*\)\$/\4/p")
    operand=${args%%>*}
    operand=$(printf '%s\n' "$operand" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//;s/^"\(.*\)"$/\1/')

    # Resolve a single input by variable first, then by pen path.
    src=''
    if [ -n "$vars" ]; then
      src=$(printf '%s\n' "$vars" | while read -r name val; do
        case "$operand" in
          "\$$name"|"\${$name}")
            # git decides, never the spelling: a pen file the control authored is untracked and
            # falls through to `unresolved`, where it belongs.
            if git ls-files --error-unmatch "$val" >/dev/null 2>&1; then printf '%s\n' "$val"; fi
            break ;;
        esac
      done | head -1)
    fi
    if [ -z "$src" ]; then
      cand=$(printf '%s\n' "$operand" | sed -n 's|^\$[{]\{0,1\}[a-zA-Z_][a-zA-Z0-9_]*[}]\{0,1\}/\([a-zA-Z][a-zA-Z0-9_/.-]*\.[a-z][a-z0-9]\{1,5\}\)$|\1|p' | head -1)
      if [ -n "$cand" ] && git ls-files --error-unmatch "$cand" >/dev/null 2>&1; then
        src=$cand
      fi
    fi

    if [ -z "$src" ] || [ ! -f "$src" ]; then
      echo "U $f:$ln"
      continue
    fi
    if ! git ls-files --error-unmatch "$src" >/dev/null 2>&1; then
      echo "U $f:$ln"
      continue
    fi

    # Keep the command's status separate from the byte comparison. A syntax
    # error can produce different bytes while proving no valid mutation at all.
    if ! (
      ulimit -c 0 || exit 125
      ulimit -f "$max_output_blocks" || exit 125
      exec "$deadline_tool" -k 1 "$max_program_seconds" "$sandbox_sed" --sandbox "$@" "$prog" "$src"
    ) > "$pen/output" 2> "$pen/error"; then
      echo "F $f:$ln $src"
      continue
    fi
    if cmp -s "$pen/output" "$src"; then
      echo "D $f:$ln $src"
    else
      echo "L $f:$ln $src"
    fi
  done
done > "$pen/tally"

tally="$pen/tally"
live=$(grep -c '^L ' "$tally" 2>/dev/null || true)
dead=$(grep -c '^D ' "$tally" 2>/dev/null || true)
unresolved=$(grep -c '^U ' "$tally" 2>/dev/null || true)
failed=$(grep -c '^F ' "$tally" 2>/dev/null || true)
live=${live:-0}; dead=${dead:-0}; unresolved=${unresolved:-0}; failed=${failed:-0}
resolved=$((live + dead + failed))

echo "controls=$controls"
echo "plants_resolved=$resolved"
echo "plants_live=$live"
echo "plants_dead=$dead"
echo "plants_unresolved=$unresolved"
echo "plants_failed=$failed"

# `--list` names the lines behind the counts, and it can never move a verdict: it prints from the
# same tally the counts are grepped from, above every exit path, and adds no `verdict=` line of its
# own. A census that reports a number nobody can locate asks each lane to rediscover the population
# before it can work one row down -- which is why `plants_unresolved` stood at 67 for three days
# with no way to read which 67 (REDS %519).
if [ "$want_list" = yes ]; then
  echo "-- plants, by reading --"
  while read -r mark where what; do
    case "$mark" in
      L) echo "live       $where -- $what" ;;
      D) echo "dead       $where -- $what" ;;
      F) echo "failed     $where -- $what" ;;
      U) echo "unresolved $where" ;;
    esac
  done < "$tally"
  echo "-- end --"
fi

if [ "$dead" -gt 0 ]; then
  grep '^D ' "$tally" | while read -r _ where what; do
    echo "dead_plant $where -- the program matches nothing in $what, so the phase tests the unmutated file"
  done
fi

if [ "$failed" -gt 0 ]; then
  grep '^F ' "$tally" | while read -r _ where what; do
    echo "failed_plant $where -- sed refused the program for $what"
  done
  echo "verdict=plant_failed"
  exit 1
fi

# The arithmetic is stated so a reader checks the reading rather than trusting it.
if [ "$((live + dead + failed))" -ne "$resolved" ]; then
  echo "verdict=unbalanced"
  exit 1
fi

if [ "$dead" -gt 0 ]; then
  echo "verdict=plant_dead"
  echo "refused: $dead plant(s) name a line their source no longer carries -- REDS %519" >&2
  exit 1
fi

echo "verdict=ok"
exit 0
