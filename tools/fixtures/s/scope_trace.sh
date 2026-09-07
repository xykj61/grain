#!/bin/sh
# tools/fixtures/s/scope_trace.sh -- what a guard actually reads, against what its map row claims.
#
# WHY THIS READING EXISTS. tools/fixtures/s/standing_equipment_scope_map.sh names, per guard, the
# files that guard watches, and a `--scoped` roster pass SKIPS a guard no changed path reaches. A
# row is therefore a behavioral claim: "this guard reads these files and no others that matter."
# Nothing compared that claim to the guard's behavior. The map's own header calls a row naming LESS
# than its guard gates "the one direction that skips real work", and on 20260906 thirteen rows
# stood in it; a sample of eight on 20260907 found six under-named, one of them by 816 files
# (external-research/20260907-061951_the-map-a-guard-writes-for-itself.md). A map row is a header,
# and the observed read set is the pack -- so this program opens the pack.
#
# THE MECHANISM, in plain words. Run the guard under `strace -f -y -e trace=openat`, read the
# resolved path each successful `openat` returns inside its `fd<...>` annotation, and keep the ones
# under the repository root. That set is exactly what the guard opened. Each observed FILE is then
# matched against the guard's row with tools/fixtures/s/scope_match.sh -- the same matcher the
# runner skips by and the ranking prices by -- so a gap named here is a skip the runner would
# actually take.
#
# WHY DIRECTORIES ARE COUNTED APART. A guard that walks a room opens the room, and `log_has_a_row`
# opened 76 directories beside 50 files. A changed path in a git diff is always a file, so a bare
# directory can never be the thing a row must reach; counting one as a gap would invent work.
#
# WHY A FAILED OPEN IS PRINTED, NEVER GATED. A guard asserting a file is ABSENT depends on that
# absence, and `-y` resolves successful opens alone. Measured on `index_row_bound`, zero failed
# opens landed inside the repository and all 16,647 sat in /nix/ and /sys/ -- the dynamic linker's
# search. So repo-internal ENOENT paths are reported for a reader's judgment: a guard that plants
# and then removes a pen file inside the tree would list one, and that is not a watch word.
#
# WHAT THIS DOES NOT DECIDE, and the map's header says why. A row follows the guard's GATED
# readings, so an advisory ratchet the witness merely prints leaves the watch set where it is.
# Observation cannot tell a gated read from an advisory one. THE SAFE COMPOSITION IS UNION: derive,
# then ADD to the hand-written row, never subtract -- adding a watch word only ever makes a guard
# run more often. This program therefore prints gaps and never edits the map.
#
# ONE TREE IS ONE TREE. A guard whose read set branches on the CONTENT of a file may reach a room
# it never reached here. The set observed is honest about this tree at this moment, which is what
# `verdict=ok` claims and the whole of it.
#
#   sh tools/fixtures/s/scope_trace.sh <guard> [--timeout SECONDS] [--paths]
#
# Run from anywhere -- the root is found by upward walk.

set -eu

_fd_root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
_fd_steps=0
while [ ! -d "$_fd_root/rishi/bin" ] || [ ! -d "$_fd_root/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$_fd_root" = "/" ] || [ -z "$_fd_root" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  _fd_root=$(dirname "$_fd_root")
done
. "$_fd_root/tools/fixtures/s/scope_match.sh"

# BOUNDS, each named and checked at the edge (TAME). The path ceiling is the one that matters: a
# trace of a whole-tree reader returns one line per open, and `living_card_ascii` opens 15,011
# files, so the ceiling is set above the largest reader this tree holds and refuses past it rather
# than filling a pen.
max_paths=65536
max_timeout=3600
min_timeout=1

guard=""
timeout_s=600
want_paths=no
while [ $# -gt 0 ]; do
  case "$1" in
    --timeout) timeout_s=${2:-}; shift 2 ;;
    --paths)   want_paths=yes; shift ;;
    -*) echo "refused: unknown argument '$1' -- takes <guard> [--timeout SECONDS] [--paths]" >&2; exit 2 ;;
    *) if [ -n "$guard" ]; then
         echo "refused: one guard at a time -- '$guard' then '$1'" >&2; exit 2
       fi
       guard=$1; shift ;;
  esac
done
[ -n "$guard" ] || { echo "refused: name a guard -- sh $0 <guard>" >&2; exit 2; }
case "$timeout_s" in ''|*[!0-9]*) echo "refused: --timeout wants a whole number of seconds" >&2; exit 2 ;; esac
[ "$timeout_s" -ge "$min_timeout" ] && [ "$timeout_s" -le "$max_timeout" ] \
  || { echo "refused: --timeout $timeout_s outside $min_timeout..$max_timeout" >&2; exit 2; }

cd "$_fd_root"
root=$(pwd -P)

roster="${STANDING_ROSTER:-construction/standing-equipment.kyri}"
scope_map="${STANDING_SCOPE_MAP:-tools/fixtures/s/standing_equipment_scope_map.sh}"
[ -f "$roster" ] || { echo "refused: no roster at $roster" >&2; exit 1; }
[ -f "$scope_map" ] || { echo "refused: no scope map at $scope_map" >&2; exit 1; }

# THE INSTRUMENT IS PROBED, NEVER ASSUMED. A guard without its instrument reports a clean read set
# and reads exactly like a guard with nothing to say (tools/fixtures/s/shell_portable.sh's third
# tier: borrowed -- probe, then announce). strace is Linux-only, so a macOS bench gets a named
# refusal rather than a silent zero.
if ! command -v strace >/dev/null 2>&1; then
  echo "guard=$guard"
  echo "verdict=no_instrument"
  echo "refused: strace is absent on this host -- a read set cannot be observed here" >&2
  exit 3
fi

path=$(awk -v g="$guard" '
  $1 == "guard" { cur = $2; next }
  $1 == "path" && cur == g { print $2; exit }
' "$roster")
[ -n "$path" ] || { echo "refused: '$guard' is not a guard the roster seats" >&2; exit 1; }
[ -f "$path" ] || { echo "refused: the roster points '$guard' at $path, which is absent" >&2; exit 1; }

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT

sh "$scope_map" > "$pen/mapraw" || { echo "refused: the scope map fixture failed" >&2; exit 1; }
maprow=$(awk -v g="$guard" '$1 == g { $1=""; sub(/^ /,""); print; exit }' "$pen/mapraw")
if [ -z "$maprow" ] || [ "$maprow" = DISCOVERY ]; then mapped=no; else mapped=yes; fi

# The guard runs under the tracer exactly as the runner invokes it: a `.rish` through rishi, a
# `.sh` through sh. Reading the extension rather than the exec bit keeps this true for a guard
# whose mode has drifted (.claude/rules/exec-bit.md holds that at zero, and a reader that trusted
# the bit would go blind on the lap it stopped being true).
case "$path" in
  *.rish) set -- rishi/bin/rishi run "$path" ;;
  *.sh)   set -- sh "$path" ;;
  *)      set -- "$path" ;;
esac

started=$(date +%s)
strace -f -y -e trace=openat -o "$pen/trace" \
  timeout "$timeout_s" "$@" >/dev/null 2>&1 || true
ended=$(date +%s)

[ -s "$pen/trace" ] || {
  echo "guard=$guard"
  echo "verdict=trace_empty"
  echo "refused: the tracer wrote no lines -- the guard never started, so its read set is unknown" >&2
  exit 1
}

lines=$(grep -c . "$pen/trace" || true)
[ "$lines" -le "$max_paths" ] \
  || { echo "refused: the trace holds $lines lines, past the bound of $max_paths" >&2; exit 1; }

# A successful openat prints its resolved path inside the fd annotation strace's -y adds:
#   1234  openat(AT_FDCWD, "x", O_RDONLY) = 3</home/keeper/grain/x>
# Reading THAT rather than the quoted argument is what makes a relative open, a symlink, and a
# `..` walk all resolve to one spelling -- the same spelling `git ls-files` prints.
sed -n 's/.*= [0-9][0-9]*<\(.*\)>$/\1/p' "$pen/trace" \
  | grep "^$root/" | sed "s|^$root/||" | sort -u > "$pen/observed"

# A repo-internal failed open is a dependency on an ABSENCE, and `-y` annotates successful calls
# alone -- so the QUOTED argument is read instead. Two spellings arrive. An absolute one under the
# root is exact. A relative one is resolved against the root, which is where this program starts the
# guard, and that resolution is an ASSUMPTION rather than a fact: a tracee that chdirs elsewhere
# would have a miss there attributed to the root. Two things make the assumption safe enough to
# print. `..` is refused outright, since a path climbing out of the root cannot be resolved from
# here at all. And a candidate is kept only when nothing stands at that path today, which is what
# ENOENT already said and what a wrongly-attributed name would usually fail. THE READING IS
# REPORTED AND NEVER GATED, which is the other half of the safety: an absence is a hand's judgment
# about whether a guard depends on it, never a watch word this program may demand.
sed -n 's/.*openat([^,]*, "\([^"]*\)".*= -1 ENOENT.*/\1/p' "$pen/trace" | sort -u \
  | while IFS= read -r cand; do
      [ -n "$cand" ] || continue
      case "$cand" in
        *..*) continue ;;
        "$root"/*) rel=${cand#"$root"/} ;;
        /*) continue ;;
        *) rel=$cand ;;
      esac
      [ -e "$rel" ] || echo "$rel"
    done | sort -u > "$pen/enoent"

: > "$pen/files"
: > "$pen/dirs"
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  if [ -d "$rel" ]; then echo "$rel" >> "$pen/dirs"; else echo "$rel" >> "$pen/files"; fi
done < "$pen/observed"

: > "$pen/gaps"
covered=0
if [ "$mapped" = yes ]; then
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    if scope_match_row "$maprow" "$f"; then
      covered=$((covered + 1))
    else
      echo "$f" >> "$pen/gaps"
    fi
  done < "$pen/files"
fi

read_files=$(grep -c . "$pen/files" || true)
read_dirs=$(grep -c . "$pen/dirs" || true)
read_enoent=$(grep -c . "$pen/enoent" || true)
gaps=$(grep -c . "$pen/gaps" || true)

echo "scope-trace: a map row is a header, and the observed read set is the pack."
echo "guard=$guard"
echo "command=$path"
echo "traced_seconds=$((ended - started))"
echo "mapped=$mapped"
echo "read_files=$read_files"
echo "read_dirs=$read_dirs"
echo "read_enoent=$read_enoent"
echo "covered=$covered"
echo "gaps=$gaps"

if [ "$want_paths" = yes ]; then
  while IFS= read -r g; do [ -n "$g" ] && echo "gap $g"; done < "$pen/gaps"
  while IFS= read -r d; do [ -n "$d" ] && echo "dir $d"; done < "$pen/dirs"
  while IFS= read -r e; do [ -n "$e" ] && echo "enoent $e"; done < "$pen/enoent"
fi

# THE VERDICT IS A READING, NOT A GATE, and the reason is the map's own header. A gap is a watch
# word a hand should consider adding; it is not a defect this program may declare, because a row
# follows GATED readings and observation cannot see which reads are gated. `verdict=ok` says the
# trace succeeded and the comparison ran. `under_named` says the same and adds that gaps stand, so
# a caller can branch on it without reading a count.
if [ "$mapped" = no ]; then
  echo "verdict=unmapped"
elif [ "$gaps" -gt 0 ]; then
  echo "verdict=under_named"
else
  echo "verdict=ok"
fi
exit 0
