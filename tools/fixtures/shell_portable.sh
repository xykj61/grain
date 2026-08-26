# tools/fixtures/shell_portable.sh -- one shell dialect for the guards, on both piers.
#
# WHAT THIS IS FOR. A scan usually gathers a list of paths into a file and then runs one command
# over all of them. This file answers that single question -- how do the paths reach the command --
# once, in a spelling every host accepts, so a guard measures the tree rather than the machine it
# happens to be running on. Source it and call `xargs_lines`; nothing else here is needed.
#
#   . "$(CDPATH= cd "$(dirname "$0")" && pwd)/shell_portable.sh"
#   xargs_lines "$work/files.txt" grep -lE "$pattern"
#   xargs_lines_batched 400 "$work/files.txt" awk -v map="$m" "$program"
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
