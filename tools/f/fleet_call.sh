#!/bin/sh
# fleet_call.sh -- signal only what runs in THIS tree, and say out loud what it refused.
#
#   sh tools/f/fleet_call.sh --pattern <substring> [--root <path>]        # READS: who would I reach?
#   sh tools/f/fleet_call.sh --pattern <substring> --signal TERM           # ACTS: reach them
#   sh tools/f/fleet_call.sh --pid <pid> [--pid <pid>] ... [--signal TERM]
#
# NAMING A SIGNAL IS THE VERB. Without --signal this helper reports and signals nothing; with it,
# it signals. --dry-run still forces the reading whatever else is passed, and wins in any order.
#
# THE DEFAULT ACTION WAS TO SEND, AND TWO SHIPS LOST A PASS TO IT IN ONE MORNING -- `%617` at
# `20260908.051419` and `20260908.071628` two hours later, independently, each asking `what of mine
# is running?` and each answered with a TERM. The paragraph that stood here after the first firing
# warned about the default in exactly these words. The second firing happened anyway, on a ship that
# had read the baton clause naming this helper. `%617`'s own third field is what settled it: **a
# tool built to stop a dangerous default should not have one.**
#
# WHY THIS EXISTS. Eight ships run one program name from eight trees on one pier, so `pkill -f
# standing_equipment_run` reaches the fleet rather than the lap (REDS %541, fired three times in
# two laps). Two faults ride together and they are one fault from two sides: a match that cannot
# tell WHOSE process it is cannot tell whose to signal, and the calling shell's own command line
# holds the pattern, so the caller kills itself (exit 144).
#
# So this helper CALLS rather than kills: every candidate is resolved to a working directory, and
# a process outside this tree's root is refused OUT LOUD instead of signaled in silence. A `kill`
# that misses is silent on both sides; a refused call is a line both sides can read.
#
# THE BOUNDARY IS cwd, AND THAT IS A CHOICE WITH A LIMIT. A process may chdir away from the tree it
# belongs to, and this helper would then refuse a process that is genuinely the lap's own. That is
# the safe direction: a false refusal costs one line, a false send costs a peer's pass. It holds
# for the fleet's actual shape -- fleet-loop.sh runs each seat from that seat's own root and never
# chdirs out -- and the reading that would falsify it is a live loop whose /proc/<pid>/cwd names
# anything but its tree. Prefer --pid with a PID the lap recorded when you have one.
#
# WHY THE READING IS THE DEFAULT (`20260908`, the family's sixth firing and its first NEW shape).
# The five firings before this one all typed `pkill -f`. This one used THIS helper, and still lost
# a lap's roster pass -- because the head's own first line says "signal only what runs in THIS
# tree", and a hand under time pressure reads a tree-scoped signaller as a tree-scoped ANSWER. The
# wall did its whole job: two peer trees were refused out loud by name, and the blast radius was
# exactly this checkout. What no wall could do was tell the hand that the bare form ACTS.
#
# So the fix is a verb rather than a wall. Every other instrument in this tree reads before it
# writes -- `index-preview` before `index-fold`, `--list` before a repair, `reds_fold.sh` refusing
# an open row -- and this was the one family whose wrong guess costs a pass and whose default
# acted. The documented form `--pattern X --signal TERM` is unchanged and still acts, which is why
# no tracked caller moved and every acting leg of the control already named its signal.
#
# Exits 0 when it ran, 2 on a usage error. Bounded: 256 candidates, 64 levels of ancestry.
set -eu

max_candidates=256   # bound: a pier running eight ships shows tens of matches, never hundreds
max_ancestry=64      # bound: deeper than any real process chain on this pier

root=""
pattern=""
pids=""
signal=TERM
# invariant: the reading is the default, so a hand that asks a question is never answered with a
# signal. Naming a signal is what asks for one.
dry=yes
dry_forced=no
proc_root=${FLEET_CALL_PROC:-/proc}

usage() {
  sed -n '2,9p' "$0" | sed 's/^# \{0,1\}//'
  exit 2
}

while [ $# -gt 0 ]; do
  case "$1" in
    --pattern) [ $# -ge 2 ] || usage; pattern=$2; shift 2 ;;
    --pid)     [ $# -ge 2 ] || usage; pids="$pids $2"; shift 2 ;;
    --signal)  [ $# -ge 2 ] || usage; signal=$2; dry=no; shift 2 ;;
    --root)    [ $# -ge 2 ] || usage; root=$2; shift 2 ;;
    --dry-run) dry_forced=yes; shift ;;
    -h|--help) usage ;;
    *) printf 'fleet-call: unknown argument %s\n' "$1" >&2; usage ;;
  esac
done

[ -n "$pattern" ] || [ -n "$pids" ] || { printf 'fleet-call: name a --pattern or a --pid\n' >&2; usage; }

# invariant: --dry-run holds the reading whatever order the flags arrived in, so a hand that asks
# for a preview after naming a signal gets the preview.
[ "$dry_forced" = yes ] && dry=yes

# invariant: the root is resolved PHYSICALLY before any comparison. A symlinked checkout reads
# local in a path string and sits in a sibling on disk, which is the same fault wearing a disguise.
[ -n "$root" ] || root=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
root=$(CDPATH= cd -- "$root" 2>/dev/null && pwd -P) || {
  printf 'fleet-call: root does not resolve\n' >&2; exit 2; }

# -- the caller and every one of its ancestors are off limits -----------------------------------
# invariant: the shell running this helper holds the pattern in its own command line, so a match
# on the pattern matches the caller. Refusing self alone is not enough -- the loop's shell, the
# tee, and the launcher above it all carry it too, which is how exit 144 arrives.
kin=" $$ "
walker=$$
depth=0
while [ "$depth" -lt "$max_ancestry" ]; do
  up=$(ps -o ppid= -p "$walker" 2>/dev/null | tr -d ' ') || break
  [ -n "$up" ] || break
  case "$up" in ''|*[!0-9]*) break ;; esac
  [ "$up" -gt 1 ] || break
  kin="$kin$up "
  walker=$up
  depth=$((depth + 1))
done

is_kin() { case "$kin" in *" $1 "*) return 0 ;; *) return 1 ;; esac; }

# -- a candidate's working directory, granted on Linux and borrowed on a Mac ---------------------
cwd_of() {
  # `readlink -f` IS GNU-ONLY, and this file already refuses to measure its host anywhere else,
  # so it does not reach for it here either -- a subshell `cd` into the cwd link and `pwd -P` is
  # the same physical resolution in a spelling every POSIX host runs (`shell_dialect`, `20260907.081135`).
  # It also reads BETTER on a deleted directory: `readlink -f` answers a path with `(deleted)`
  # glued to it, which `under_root` would then compare as an ordinary string, where `cd` simply
  # fails and the lsof leg below gets its turn.
  if [ -r "$proc_root/$1/cwd" ]; then
    c=$(cd "$proc_root/$1/cwd" 2>/dev/null && pwd -P) || c=
    [ -n "$c" ] && { printf '%s\n' "$c"; return 0; }
  fi
  if command -v lsof >/dev/null 2>&1; then
    c=$(lsof -a -p "$1" -d cwd -Fn 2>/dev/null | sed -n 's/^n//p' | head -1)
    [ -n "$c" ] && { printf '%s\n' "$c"; return 0; }
  fi
  return 1
}

under_root() {
  case "$1" in "$root") return 0 ;; "$root"/*) return 0 ;; *) return 1 ;; esac
}

# -- gather candidates ---------------------------------------------------------------------------
pen=${TMPDIR:-/tmp}/fleet-call-$$
trap 'rm -f "$pen"' EXIT INT TERM
: > "$pen"

if [ -n "$pattern" ]; then
  # No grep child: a grep holding the pattern would itself become a candidate, which is the
  # self-match fault one process further out.
  ps -eo pid=,args= 2>/dev/null | while read -r cpid cargs; do
    case "$cargs" in *"$pattern"*) printf '%s\n' "$cpid" ;; esac
  done >> "$pen" || true
fi
for p in $pids; do printf '%s\n' "$p" >> "$pen"; done

sent=0; refused_foreign=0; refused_self=0; refused_unknown=0; candidates=0; over=0

while read -r cpid; do
  [ -n "$cpid" ] || continue
  candidates=$((candidates + 1))
  if [ "$candidates" -gt "$max_candidates" ]; then over=$((over + 1)); continue; fi
  if is_kin "$cpid"; then
    printf 'call pid=%s verdict=refused_self -- the caller or one of its ancestors\n' "$cpid"
    refused_self=$((refused_self + 1))
    continue
  fi
  if ! cwd=$(cwd_of "$cpid"); then
    printf 'call pid=%s verdict=refused_unknown -- no readable working directory\n' "$cpid"
    refused_unknown=$((refused_unknown + 1))
    continue
  fi
  if ! under_root "$cwd"; then
    printf 'call pid=%s cwd=%s verdict=refused_foreign -- outside %s\n' "$cpid" "$cwd" "$root"
    refused_foreign=$((refused_foreign + 1))
    continue
  fi
  if [ "$dry" = yes ]; then
    printf 'call pid=%s cwd=%s verdict=dry signal=%s\n' "$cpid" "$cwd" "$signal"
  else
    kill "-$signal" "$cpid" 2>/dev/null || true
    printf 'call pid=%s cwd=%s verdict=sent signal=%s\n' "$cpid" "$cwd" "$signal"
  fi
  sent=$((sent + 1))
done < "$pen"

# invariant: a dry run reports would_send, never sent. Caught by first-resident use within the hour
# this landed: reading `sent=1` off a --dry-run summary is the same silence the whole helper exists
# to end, one field over -- a line that says a signal went where none did.
verb=sent
[ "$dry" = yes ] && verb=would_send
printf 'candidates=%s %s=%s refused_foreign=%s refused_self=%s refused_unknown=%s over_bound=%s root=%s verdict=ok\n' \
  "$candidates" "$verb" "$sent" "$refused_foreign" "$refused_self" "$refused_unknown" "$over" "$root"
