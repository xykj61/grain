# tools/fixtures/shell_portable.sh -- one shell dialect for the guards, on both piers.
#
# WHAT THIS IS FOR. A guard asks the host a small number of questions, and three of them have a
# different answer on each pier. This file answers each once, in a spelling every host accepts, so
# a guard measures the tree rather than the machine it happens to be running on. Source it and call
# the function that names your question:
#
#   . "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"
#
#   xargs_lines "$work/files.txt" grep -lE "$pattern"          # a path list reaches a command
#   xargs_lines_batched 400 "$work/files.txt" awk -f "$prog"    # ... in bounded batches
#   stamp_epoch 20260826.063705                                # a stamp becomes epoch seconds
#   epoch_stamp 1787740625                                     # ... and back again
#   stamp_ahead 14400                                          # the stamp four hours from now
#   file_mtime "$BIN"                                          # a file's mtime, fractional seconds
#
# WHY IT EXISTS. `xargs -a FILE` and `xargs -d '\n'` are GNU extensions. BSD xargs, which is what
# macOS ships, has neither, so on that bench the whole pipeline fails and the count taken from its
# empty output is zero. A zero nobody planted reads exactly like a healthy tree. Measured on this
# pier `20260826.062128` under an xargs that refuses those two flags exactly as BSD's does:
# `tools/fixtures/exec_bit_scan.sh` reads `directly_invoked=18` on GNU and `directly_invoked=0`
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
# `20260826.090745` in `tools/fixtures/ryekey_control.sh`, where `btime` returned six lines where
# it meant one (REDS %260). GNU goes first because GNU is the dialect whose refusal is clean: BSD
# `stat` has no `-c` at all, so the fallback is only ever reached once the first leg truly refused.
#
# THE LIMIT, named rather than hidden: the BSD leg would still print that five-line report if the
# GNU leg ever failed on a file that exists. Order is what prevents it, so order is what the
# gate in `tools/fixtures/shell_dialect_scan.sh` holds at zero.
file_mtime() {
  stat -c %.Y "$1" 2>/dev/null && return 0
  stat -f %Fm "$1" 2>/dev/null && return 0
  return 1
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
