# tools/fixtures/s/shell_portable.sh -- one shell dialect for the guards, on both piers.
#
# WHAT THIS IS FOR. A guard asks the host a small number of questions, and three of them have a
# different answer on each pier. This file answers each once, in a spelling every host accepts, so
# a guard measures the tree rather than the machine it happens to be running on. Source it and call
# the function that names your question. The letter fold (seated 20260828) separated siblings, so
# the spelling walks to the root first -- the depth-proof block every fixtures guard now carries --
# and sources this file at its letter-room home:
#
#   . "$_fd_root/tools/fixtures/s/shell_portable.sh"
#
#   xargs_lines "$work/files.txt" grep -lE "$pattern"          # a path list reaches a command
#   xargs_lines_batched 400 "$work/files.txt" awk -f "$prog"    # ... in bounded batches
#   stamp_epoch 20260826.063705                                # a stamp becomes epoch seconds
#   epoch_stamp 1787740625                                     # ... and back again
#   stamp_ahead 14400                                          # the stamp four hours from now
#   file_mtime "$BIN"                                          # a file's mtime, fractional seconds
#   lock_acquire glow/.cache/.build.lock 1800                  # one writer at a time, bounded wait
#   search_text -q -i pattern file                             # grep; a pier without rg still measures
#   have_tool rg                                               # is the instrument here? silent, for branching
#   require_tool rg 'the roots row read' || exit 127            # ... refuse and NAME it, where no fallback exists
#
# WHY IT EXISTS. `xargs -a FILE` and `xargs -d '\n'` are GNU extensions. BSD xargs, which is what
# macOS ships, has neither, so on that bench the whole pipeline fails and the count taken from its
# empty output is zero. A zero nobody planted reads exactly like a healthy tree. Measured on this
# pier `20260826.062128` under an xargs that refuses those two flags exactly as BSD's does:
# `tools/fixtures/e/exec_bit_scan.sh` reads `directly_invoked=18` on GNU and `directly_invoked=0`
# under the shim, and prints `verdict=ok` both times -- so the exec-bit gate, which is held at zero
# and enforced, has been measuring nothing at all on the second pier (REDS %240, %249, %250).
#
# WHAT THE PORTABLE SPELLING ALSO FIXES. `xargs -a FILE` without `-d` splits on blanks and reads
# quotes, so a path with a space in it arrives as two broken paths. Two tracked paths carry spaces
# today, and neither reaches any list this helper feeds, so that repair is latent rather than
# active -- yet it is free, and a list of paths is newline-delimited by construction.

# A LIST THAT IS EMPTY RUNS NOTHING. Left to itself, xargs hands the command no operands and grep
# then reads standard input, which in a pipeline is the wrong file or no file at all. Returning
# early says what was meant: no paths, no work.
xargs_lines() {
  _sp_list=$1
  shift
  [ -s "$_sp_list" ] || return 0
  tr '\n' '\0' < "$_sp_list" | xargs -0 "$@"
}

# The batch size is the caller's, because only the caller knows what its command costs per
# invocation -- a lookup table read once per batch wants large batches, a per-file report wants
# whatever fits. `-n` and `-0` are both accepted by GNU and BSD xargs alike.
xargs_lines_batched() {
  _sp_n=$1
  _sp_list=$2
  shift 2
  [ -s "$_sp_list" ] || return 0
  tr '\n' '\0' < "$_sp_list" | xargs -0 -n "$_sp_n" "$@"
}


# THE SECOND DIALECT QUESTION: how does a date reach and leave the `date` command. GNU spells the
# parse `-d STRING` and the format-an-epoch `-d @EPOCH`; BSD, which is what macOS ships, spells
# them `-j -f INFMT STRING` and `-r EPOCH` and refuses `-d` outright. Measured `20260826.015353`:
# `tools/o/one_clock_witness.rish` fails its own PASS fixture on the macOS bench, because the
# four-hours-ahead stamp it builds with `date -d '+4 hours'` comes back empty and an empty stamp is
# unparsable (REDS %250). This family earned its gate the way the `xargs` one did -- by costing a
# real reading on a real host -- so it is counted at zero rather than left advisory.
#
# ORDER MATTERS, and only in one direction. GNU rejects `-j` and `-v` cleanly, so trying BSD first
# on a GNU host is safe. `-r` is the trap: BSD reads it as an epoch and GNU reads it as a FILE whose
# mtime to report, so `date -r 1787742895` on GNU searches for a file of that name. It fails today
# and would answer a wrong time the day such a file exists. GNU therefore goes first in both
# functions, and the BSD leg is only ever reached once the GNU leg has already refused.

# stamp_epoch <YYYYmmdd.HHMMSS | YYYYmmdd> -> epoch seconds on stdout.
# A bare day means midnight local, which is what `date -d 20260826` already meant.
# The caller sets TZ; this function reads whatever zone it is handed.
stamp_epoch() {
  _sp_ymd=${1%%.*}
  case $1 in *.*) _sp_hms=${1#*.} ;; *) _sp_hms=000000 ;; esac
  # invariant: fifteen digits in two runs, because a stamp this tree writes is exactly that shape
  # and a half-read stamp must refuse rather than answer some other moment.
  case ${_sp_ymd}${_sp_hms} in ''|*[!0-9]*) return 1 ;; esac
  [ ${#_sp_ymd} -eq 8 ] && [ ${#_sp_hms} -eq 6 ] || return 1
  _sp_y=${_sp_ymd%????}
  _sp_mo=${_sp_ymd#????}; _sp_mo=${_sp_mo%??}
  _sp_d=${_sp_ymd#??????}
  _sp_h=${_sp_hms%????}
  _sp_mi=${_sp_hms#??}; _sp_mi=${_sp_mi%??}
  _sp_s=${_sp_hms#????}
  date -d "${_sp_y}-${_sp_mo}-${_sp_d} ${_sp_h}:${_sp_mi}:${_sp_s}" +%s 2>/dev/null && return 0
  date -j -f '%Y%m%d%H%M%S' "${_sp_ymd}${_sp_hms}" +%s 2>/dev/null && return 0
  return 1
}

# epoch_stamp <epoch seconds> -> YYYYmmdd.HHMMSS on stdout. The inverse of stamp_epoch, and the
# only part of "what time will it be in four hours" that needs a date extension at all.
epoch_stamp() {
  case $1 in ''|*[!0-9]*) return 1 ;; esac
  date -d "@$1" +%Y%m%d.%H%M%S 2>/dev/null && return 0
  date -r "$1" +%Y%m%d.%H%M%S 2>/dev/null && return 0
  return 1
}

# stamp_ahead <seconds> -> the one-clock stamp that many seconds from now.
# The shift itself is plain arithmetic on `date +%s`, which every host spells the same way; only
# the formatting needed a dialect. Naming the question keeps the caller reading as the question.
stamp_ahead() {
  epoch_stamp "$(( $(date +%s) + $1 ))"
}

# THE THIRD DIALECT QUESTION: how a file's modification time reaches the shell. GNU spells it
# `stat -c %.Y FILE` and BSD, which is what macOS ships, spells it `stat -f %Fm FILE`. Both answer
# in fractional seconds, which is what a caller asking "did this get rebuilt?" needs -- two builds
# inside one second are ordinary, and whole seconds would call them the same moment.
#
# THE SAME ORDER, AND THE SAME REASON AS THE CLOCK ABOVE. `stat -f` is the `date -r` trap wearing
# another flag: BSD reads it as the format string and GNU reads it as `--file-system`. So
# `stat -f %Fm out` on a GNU host asks for the filesystem holding a file named `%Fm`, which fails,
# AND the one holding `out`, which succeeds -- printing five lines of block and inode counts to
# stdout before exiting 1. A caller spelling it BSD-first therefore gets both answers concatenated
# on every GNU host, and its `||` fires on a command that partly worked. Measured on this pier
# `20260826.090745` in `tools/fixtures/r/ryekey_control.sh`, where `btime` returned six lines where
# it meant one (REDS %260). GNU goes first because GNU is the dialect whose refusal is clean: BSD
# `stat` has no `-c` at all, so the fallback is only ever reached once the first leg truly refused.
#
# THE LIMIT, named rather than hidden: the BSD leg would still print that five-line report if the
# GNU leg ever failed on a file that exists. Order is what prevents it, so order is what the
# gate in `tools/fixtures/s/shell_dialect_scan.sh` holds at zero.
file_mtime() {
  stat -c %.Y "$1" 2>/dev/null && return 0
  stat -f %Fm "$1" 2>/dev/null && return 0
  return 1
}

# THE FOURTH DIALECT QUESTION: how a path is made absolute with its symlinks resolved. GNU spells it
# `readlink -f PATH`, and it succeeds on a path whose last component does not yet exist. BSD readlink
# carried no `-f` at all for most of its life; macOS gained one in a recent release, so a tree that
# reaches for it is betting on the age of the second bench rather than on a spelling both accept.
# The bet is avoidable for one function's worth of shell.
#
# The portable answer asks the shell instead of the tool: `cd` into the directory and let `pwd -P`
# resolve the symlinks, which every POSIX shell does. The last component is appended by hand rather
# than walked, because the callers here resolve a FILE whose directory is the part that may be a
# link -- `/etc/localtime` on a host that symlinks its zoneinfo, a `rye/lib` entry, a binary on
# PATH. A last component that is itself a symlink to elsewhere is followed one hop, which covers
# every caller in this tree and stops short of a general link walker nobody has needed.
#
# WHY NOT A LOOP TO A FIXED POINT. A full resolver has to bound its own recursion or hang on a
# symlink cycle, and bounding it means naming a maximum depth nobody here can justify from
# measurement. One hop is what the callers need, so one hop is what this promises, and the promise
# is the whole of it.
resolve_path() {
  _sp_target=$1
  [ -n "$_sp_target" ] || return 1
  # A symlink is followed one hop, so a link into another directory resolves against that directory.
  if [ -L "$_sp_target" ]; then
    _sp_hop=$(readlink "$_sp_target" 2>/dev/null) || return 1
    case "$_sp_hop" in
      /*) _sp_target=$_sp_hop ;;
      *)  _sp_target=$(dirname "$_sp_target")/$_sp_hop ;;
    esac
  fi
  _sp_dir=$(dirname "$_sp_target")
  _sp_base=$(basename "$_sp_target")
  _sp_dir=$(CDPATH= cd "$_sp_dir" 2>/dev/null && pwd -P) || return 1
  case "$_sp_dir" in
    /) printf '%s\n' "/$_sp_base" ;;
    *) printf '%s\n' "$_sp_dir/$_sp_base" ;;
  esac
}

# THE FIFTH: editing a file in place. GNU `sed -i` takes no argument; BSD `sed -i` REQUIRES a backup
# suffix and reads the next word as one, so `sed -i 's|a|b|' f` on BSD tries to use the script as a
# suffix and then finds no file to edit. The two spellings have no overlap, which is why the tree
# writes neither: a temporary file and a copy back through the original inode is a spelling every
# host runs, and it preserves the mode the repository tracks (the exec-bit law) where `mv` would not.
#
# The caller passes the script and the file, exactly as `sed -i` would take them.
sed_inplace() {
  _sp_script=$1
  _sp_file=$2
  [ -f "$_sp_file" ] || return 1
  _sp_tmp="$_sp_file.sp.$$"
  sed "$_sp_script" "$_sp_file" > "$_sp_tmp" || { rm -f "$_sp_tmp"; return 1; }
  cat "$_sp_tmp" > "$_sp_file" || { rm -f "$_sp_tmp"; return 1; }
  rm -f "$_sp_tmp"
}

# THE SIXTH: one writer at a time. `flock(1)` is util-linux, and macOS ships none at all, so a
# guard that serializes its builds behind `flock -w` dies on `flock: command not found` before it
# does any work. Measured on the macOS bench `20260826.212000`: every one of the 44 witnesses that
# reach `tools/g/glow_run_worker.sh` refused there, seven of them Caravan rungs, so the Caravan
# choir could not go green on that pier for a reason that had nothing to do with Caravan (REDS
# %279). `mkdir` is atomic on every POSIX filesystem -- it either creates the directory or reports
# that it exists, with no window between the two -- so a lock directory is the same mutual
# exclusion in a spelling every host runs.
#
# THE ONE PROPERTY A DIRECTORY DOES NOT INHERIT, and why the pid file is here rather than tidy.
# A `flock` on an open descriptor is released by the kernel when the process ends, however it
# ends. A directory outlives its owner, so a build killed mid-run would leave a lock nobody
# releases and every later run would wait out its whole bound and refuse. The owner's pid is
# written inside the lock, and a waiter that finds an owner no longer running reaps the lock and
# takes it. That check is what keeps a crash costing one retry rather than a bounded hang.
#
# The wait is bounded and refuses by name, exactly as `flock -w` did: a deadlock reports itself
# rather than hanging forever.
#
#   lock_acquire glow/.cache/.build.lock 1800 || { echo "FAIL: ..."; exit 3; }
#   trap 'lock_release glow/.cache/.build.lock' EXIT
#   trap 'exit 130' INT
#   trap 'exit 143' TERM
#
# THREE TRAPS RATHER THAN ONE, and the reason is not tidiness. `trap 'cleanup' EXIT INT TERM`
# reads like "clean up and stop"; POSIX runs the handler and then RESUMES the script where the
# signal landed. So the script carries on having released the lock and deleted the scratch, and
# what happens next depends on a flag nobody set for this reason: under `set -e` it dies at the
# first write and loses its verdict, and without `set -e` it RUNS TO COMPLETION and prints a
# total counted from a directory that is gone -- a low number a ratchet welcomes. Giving the
# signals their own traps that call `exit` lets the EXIT trap clean up exactly once and stops
# the script where it was stopped. 130 and 143 are 128 plus SIGINT and SIGTERM.
#
# This header taught the one-line form until 20260906, which is why the tree wrote it 142 times
# against the correct form's once (REDS %487). Proven both directions on metal in
# tools/fixtures/s/signal_trap_control.sh; the population is counted by
# tools/fixtures/s/signal_trap_scan.sh.
lock_acquire() {
  _sp_lock=$1
  _sp_wait=${2:-1800}
  _sp_waited=0
  while ! mkdir "$_sp_lock" 2>/dev/null; do
    # A lock whose owner has gone is a lock nobody will ever release, so it is reaped rather than
    # waited out. An unreadable or empty pid file means a lock caught mid-creation: wait, never reap.
    if [ -s "$_sp_lock/pid" ]; then
      _sp_owner=$(cat "$_sp_lock/pid" 2>/dev/null || printf '')
      case "$_sp_owner" in
        ''|*[!0-9]*) : ;;
        *) kill -0 "$_sp_owner" 2>/dev/null || { rm -rf "$_sp_lock"; continue; } ;;
      esac
    fi
    [ "$_sp_waited" -ge "$_sp_wait" ] && return 1
    sleep 1
    _sp_waited=$((_sp_waited + 1))
  done
  printf '%s\n' "$$" > "$_sp_lock/pid"
  return 0
}

# Releasing is unconditional: a caller that holds the lock is the only one that calls this, and a
# caller that never acquired it removes a directory that is not there, which costs nothing.
lock_release() {
  rm -rf "$1"
}

# THE SEVENTH: searching a file. `rg` (ripgrep) is faster and sits on some piers; POSIX `grep`
# sits on every one. A guard that names `rg` reds in 0s on a pier that never installed it -- this
# one, measured 20260830 and still red 20260904 -- which is a missing binary rather than a tree
# defect, and the living-pin scan's own law already says a witness must not depend on one bench's
# tools. This function is grep, always, with the small flag set both GNU and BSD accept: -q -i -F
# -E. Alternation in the pattern adds -E when the caller did not pass -F, so a `|` keeps meaning
# "or" the way rg spelled it.
#
#   search_text [-q] [-i] [-F] [-E] pattern [file ...]
# Reads stdin when no file is given, matching both tools.
search_text() {
  _st_q=
  _st_i=
  _st_F=
  _st_E=
  while [ $# -gt 0 ]; do
    case $1 in
      -q) _st_q=-q ;;
      -i) _st_i=-i ;;
      -F) _st_F=-F ;;
      -E) _st_E=-E ;;
      --) shift; break ;;
      -*) printf 'search_text: unknown flag %s\n' "$1" >&2; return 2 ;;
      *) break ;;
    esac
    shift
  done
  if [ $# -lt 1 ]; then
    printf 'search_text: pattern required\n' >&2
    return 2
  fi
  _st_pat=$1
  shift
  if [ -z "$_st_F" ] && [ -z "$_st_E" ]; then
    case $_st_pat in
      *\|*) _st_E=-E ;;
    esac
  fi
  grep ${_st_q} ${_st_i} ${_st_F} ${_st_E} -- "$_st_pat" "$@"
}


# THE FOURTH DIALECT QUESTION, AND THE ONLY ONE WITH NO PORTABLE ANSWER: is the instrument here at
# all. The three questions above each have a spelling that works on both piers. This one does not --
# when a guard reaches for a tool the bench does not carry, no spelling saves it, and the only
# honest move is to refuse and SAY WHICH TOOL.
#
# WHAT IT COSTS WHEN IT IS MISSED. Measured `20260905.224445` on the three guards the standing
# roster reaches that call `rg` in command position, run with the ripgrep directory taken off PATH
# and nothing else changed:
#
#   tools/fixtures/e/equinox_e122_roots_bench_kinds_scan.sh  ->  control_gate=failed / verdict=misread
#   tools/t/tally_glow_tend_limb1_witness.rish               ->  "tally glow limb missing"
#   tools/t/tally_glow_tend_limb4_witness.rish               ->  "parse_int.rye missing LeadingZero/InvalidCharacter"
#
# All three refuse, which is right. All three name an innocent file, which is not: the control had
# printed `verdict=ok` one line above its own gate, `tally/parse_int.rye` carries both of those
# names twice over, and the Glow file is present and matches. A hand reading any of the three goes
# to repair a file that is already correct, and the one line naming the real cause -- `rg: command
# not found` -- went to stderr, which a witness reading `run` output does not keep. Refusing is half
# the reflex; naming the instrument is the half that saves the hour.
#
#   have_tool rg && ... || ...              # branch silently, where a fallback exists
#   require_tool rg || exit 127             # refuse in the scan's own key=value voice, where none does
#   require_tool rg 'the roots row read' || exit 127     # ... and say what it was wanted for
#
# WHY 127 RATHER THAN 1. That is the shell's own status for a command it could not find, so a caller
# tells "this bench is missing something" from "this tree measured badly" without parsing prose.
# A misuse -- no name at all -- returns 2, the same way `search_text` above separates misuse from
# absence, because a caller must never read its own empty argument as a missing tool.

# have_tool <name> -- true when this bench carries it. Silent, so a caller may branch on it.
have_tool() {
  # invariant: exactly one non-empty name, because `command -v` with no operand answers about the
  # shell rather than about a tool, and would report every bench as fully equipped.
  [ $# -eq 1 ] || return 2
  [ -n "${1:-}" ] || return 2
  command -v "$1" >/dev/null 2>&1
}

# require_tool <name> [<what it was wanted for>] -- refuse, naming the instrument, on stdout.
require_tool() {
  _rt_name=${1:-}
  _rt_use=${2:-}
  if [ -z "$_rt_name" ]; then
    printf 'require_tool: instrument name required\n' >&2
    unset _rt_use
    return 2
  fi
  if have_tool "$_rt_name"; then
    unset _rt_name _rt_use
    return 0
  fi
  # STDOUT, not stderr. A scan is read by a witness that captures `run` output, and the reading that
  # sent a lap looking at the wrong file was on stderr the whole time. The shape is the tree's own
  # key=value line so an existing reader needs no new grammar.
  printf 'instrument=%s\n' "$_rt_name"
  if [ -n "$_rt_use" ]; then
    printf 'instrument_for=%s\n' "$_rt_use"
  fi
  printf 'detail=instrument_absent\n'
  printf 'verdict=instrument_absent\n'
  unset _rt_name _rt_use
  return 127
}
# THE MECHANISM PROVES ITSELF ON THE HOST THAT RUNS IT, once per sourcing script, for three
# processes. The probe asks the one question that matters -- does a newline-delimited list survive
# the round trip whole -- and a path carrying a space is the sharpest way to ask it: `tr` must emit
# a NUL byte, `xargs -0` must accept one as the separator, and the space must stay inside its
# operand. Refusing here is the whole point of the file. The class this guards against costs a
# silent zero every time, and a silent zero is the one failure a scan cannot report on its own.
_sp_probe=$(printf 'a b\nc\n' | tr '\n' '\0' | xargs -0 -n 9 printf '[%s]' 2>/dev/null) || _sp_probe=''
if [ "$_sp_probe" != '[a b][c]' ]; then
  echo "refused: this host cannot carry a newline-delimited path list through tr and xargs -0." >&2
  echo "refused: probe wanted '[a b][c]' and read '$_sp_probe' -- a scan run here would answer zero." >&2
  exit 1
fi
unset _sp_probe

# THE EIGHTH: the instrument itself. Every function above answers "how is this spelled on that
# host". This one answers the question underneath them -- is the tool there at all -- and it is
# the only one whose wrong answer is silent. A missing `sed` reports itself the moment a line
# fails to change. A missing `rg` reports nothing, because the shape a guard reaches for is
#
#   hits="$(rg PATTERN paths 2>/dev/null || true)"; [ -n "$hits" ] && refuse
#
# and three separate constructions in that one line each discard the evidence: `2>/dev/null` hides
# `rg: command not found`, `|| true` discards exit 127, and the emptiness test reads "nothing
# matched" out of "nothing ran". The healthy reading and the dead reading are the same bytes.
#
# MEASURED ON THIS PIER `20260905.223102`, with a shim on PATH answering exit 127 exactly as a
# missing binary does. Of 117 tracked scans naming `rg` in command position, 115 said nothing about
# the cause on their own stdout, and two -- `tools/fixtures/i/inner_i1_twah_residual.sh` and
# `tools/fixtures/i/inner_i2_djin_prose.sh` -- printed their GREEN line byte for byte and exited 0.
# `rishi/bin/rishi run tools/i/inner_i1_twah_residual.rish` read GREEN with no ripgrep on the host
# at all (REDS %442). The other 115 refused for reasons of their own, loudly and by accident,
# which is luck rather than design: none of them named the instrument.
#
# WHAT THIS IS NOT. It is not the tool-grant roster, which is designed and waiting in
# `active-designing/yonder/20260905-064341_the-tools-a-guard-may-assume.md` and rightly begins with
# a roster rather than a meter. This is the one reflex that reads true with no roster behind it,
# because it makes no claim about tiers: it only refuses to let a tool's absence wear a tool's
# answer.
#
#   require_instrument rg                       # refuse, naming rg, if it is not on PATH
#   require_instrument rg jq                    # ... or if any of several is missing
#
# Exit 2 rather than 1, so a caller can tell "the tree is wrong" from "the bench is wrong".
require_instrument() {
  _ri_missing=
  for _ri_tool in "$@"; do
    command -v "$_ri_tool" >/dev/null 2>&1 || _ri_missing="${_ri_missing:+$_ri_missing }$_ri_tool"
  done
  [ -z "$_ri_missing" ] && return 0
  printf 'refused: %s needs an instrument this host does not have: %s\n' "${0##*/}" "$_ri_missing" >&2
  printf 'refused: without it an empty reading is indistinguishable from a healthy one.\n' >&2
  exit 2
}
