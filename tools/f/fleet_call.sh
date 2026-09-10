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
tab=$(printf '\t')   # a literal tab, so the whitespace test below reads both spellings


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
# invariant: a pattern names ONE command word, so whitespace in it can never match and a zero would
# read as absence rather than as impossibility.
case "$pattern" in
  *[![:space:]]*[[:space:]]*|*[[:space:]]*)
    printf 'fleet-call: --pattern names one command word and carries no whitespace; a multi-word pattern matches nothing here -- use --pid, or pattern the program name alone\n' >&2
    usage ;;
esac

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
argpen="$pen.args"
trap 'rm -f "$pen" "$argpen"' EXIT INT TERM
: > "$pen"

# A MATCH MUST LAND ON A COMMAND WORD RATHER THAN INSIDE PROSE. This tree's baton is prepended to
# every seat prompt and reaches each agent as ONE argument -- 11,558 bytes on this pier, measured
# `20260909.223500` -- and it NAMES this helper and the tools it searches for, three times over. So
# a substring test against the flattened command line matched all eight peer agents while exactly
# one process was the tool: `candidates=19` against a true 7, a 2.6x over-read on the very reading
# this helper exists to give. The wall held -- every one refused by cwd or ancestry -- and the
# READING is what was wrong, which is the worse half: a lap published a fleet-wide claim from it,
# and no refusal line said otherwise.
#
# THE DISCRIMINATOR IS SHAPE RATHER THAN LENGTH. A command word carries no whitespace: a program
# name, a path, a flag. A prompt is prose, and every piece of it holding the pattern carries spaces.
# A length bound was measured and declined -- the longest legitimate argument on this pier is 2,100
# bytes (a witness's inline awk program) against the baton's 11,558, so a threshold exists, and it
# is a number that drifts with whatever inline program grows next. Shape drifts with nothing.
#
# AND THE PATTERN ITSELF NAMES A COMMAND WORD, so a multi-word pattern can match nothing here by
# construction -- `--pattern 'runner.sh --hot'` is refused rather than silently empty, since a
# reading of zero that means "impossible" and one that means "nobody is running it" are two facts a
# hand acts on differently. Learned first-resident within the hour, reaching for exactly that form.
#
# WHAT THIS NARROWS, AND WHAT IT LEAVES. A prompt that put a bare path alone on its own line would
# read as a command word again, so this narrows the class rather than closing it -- measured against
# the live baton, four patterns this tree searches for yield zero whitespace-free pieces while the
# real invocation yields one. A genuine `sh -c '<script naming the tool>'` is refused, which is the
# safe direction this file already chose for cwd: a false refusal costs one line, a false send costs
# a peer's pass, and `--pid` is that case's door.
#
# ONE READING, WITH A NAMED DEGRADATION, DECIDED BY THE HOST AND NOT BY ONE PROCESS. Argument
# boundaries come from `$proc_root/<pid>/cmdline`, which a Mac does not have; there the flattened
# line is all there is, so the elder substring test stands and `reading=flattened` says so -- an
# honest "this host cannot tell prose from a command word" rather than a silent second rule. The
# capability is read ONCE, before the loop, because a per-candidate fallback made a single process
# that exited between the listing and the read report the whole reading as degraded -- caught
# first-resident on this Linux pier. A vanished process is skipped BY NAME instead, which is the
# same distinction `instrument_refusal` asks for one line down: gone and innocent are two facts.
if [ -d "$proc_root" ] && [ -r "$proc_root" ]; then reading=exact; else reading=flattened; fi
if [ -n "$pattern" ]; then
  # No grep child, and no matcher child of any kind: a process holding the pattern in its own
  # command line becomes a candidate, which is the self-match fault one process further out. The
  # whitespace test below is `case` in this shell for exactly that reason.
  ps -eo pid=,args= 2>/dev/null | while read -r cpid cargs; do
    case "$cpid" in ''|*[!0-9]*) continue ;; esac
    # The flattened line carries every piece's own bytes, so a piece can never match where this
    # does not -- which makes it a sound prefilter and keeps the split off 200 innocent processes.
    case "$cargs" in *"$pattern"*) : ;; *) continue ;; esac
    if [ "$reading" = exact ]; then
      # The process exited between the `ps` listing and this line, so there is nothing to reach.
      [ -r "$proc_root/$cpid/cmdline" ] || continue
      # `tr` splits on the NUL argv separator, and a prose argument's own newlines split with it.
      # That only makes the pieces smaller, so a prose piece stays prose and the test still holds.
      #
      # A FAILED READ IS ITS OWN OUTCOME rather than a fallback value. `|| printf ''` would hand the
      # test an empty string, which reads exactly like a command line holding no match -- and the
      # two are different facts: one process exited between the listing and this line, the other is
      # running and innocent. So the read is asserted, and a vanished process is skipped by name.
      if ! tr '\0' '\n' < "$proc_root/$cpid/cmdline" > "$argpen" 2>/dev/null; then
        continue
      fi
      hit=none
      while IFS= read -r piece; do
        case "$piece" in *"$pattern"*) : ;; *) continue ;; esac
        case "$piece" in
          *' '*|*"$tab"*) hit=prose ;;
          *) hit=word; break ;;
        esac
      done < "$argpen"
      case "$hit" in
        word) printf '%s\n' "$cpid" ;;
        prose) printf 'prose %s\n' "$cpid" ;;
      esac
    else
      case "$cargs" in *"$pattern"*) printf 'flat %s\n' "$cpid" ;; esac
    fi
  done >> "$pen" || true
fi

for p in $pids; do printf '%s\n' "$p" >> "$pen"; done

sent=0; refused_foreign=0; refused_self=0; refused_unknown=0; candidates=0; over=0

refused_prose=0
while read -r tag cpid; do
  # A bare number is a command-word match; `prose` and `flat` are the gather's own verdicts.
  case "$tag" in
    prose) refused_prose=$((refused_prose + 1))
           printf 'call pid=%s verdict=refused_prose -- the pattern matched only inside prose (a prompt), never a command word; use --pid to reach it\n' "$cpid"
           continue ;;
    flat)  : ;;
    *)     cpid=$tag ;;
  esac
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
printf 'candidates=%s %s=%s refused_foreign=%s refused_self=%s refused_unknown=%s refused_prose=%s over_bound=%s reading=%s root=%s verdict=ok\n' \
  "$candidates" "$verb" "$sent" "$refused_foreign" "$refused_self" "$refused_unknown" "$refused_prose" "$over" "$reading" "$root"
