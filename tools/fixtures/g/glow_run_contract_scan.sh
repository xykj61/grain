#!/bin/sh
# tools/fixtures/g/glow_run_contract_scan.sh -- does glow_run's exit contract say what it does?
#
# WHY THIS EXISTS. glow/glow_run.rye is the language hop. Hand it a `.glow` desk and it writes the
# `.rye` a build can eat, printing that path on stdout. Beside the path it hands back an EXIT CODE.
#
# Three instruments in this tree read that code by number. tools/fixtures/g/glow_desk_run_scan.sh
# maps it onto its own stage codes, and two more doors recite it in prose. Each held its own account
# of what the numbers meant, since the module returning them stated none. Its door even called that a
# virtue: "glow_run draws the line itself, in its own contract rather than in its prose." The line
# was drawn in the code and read by hand, so the reading was rewritten twice off metal -- once at
# REDS %532, which recorded one refusal where three stand, and once on 20260908.234354, which
# recorded two.
#
# WHAT THE HAND-READING LEFT, measured on metal 20260911.230925. Two codes each carried two meanings:
#
#   exit 1  a lowering ran and failed       AND  the source was never read at all
#   exit 2  glow_run knows no head for it   AND  glow_run was called with no file
#
# The first is the one that costs. readFileAlloc was reached with `try`, so FileNotFound, IsDir and
# StreamTooLong each returned through Zig's `!u8` main, which exits 1. Downstream named that
# *lowering failed* -- a claim about a desk's CONTENT, for a file whose bytes went unseen. A desk
# deleted under a running pass, a path typed one letter aside, and a generated desk grown past the
# 64 KiB read ceiling all arrive wearing that name. `3 unreadable` and `4 usage` were seated the same
# stamp, each naming itself on stderr.
#
# WHAT THIS READS. Three questions over one file, plus the metal:
#
#   declared   the codes the module's own `//!` head table names
#   returned   the codes `pub fn main` actually returns
#   probed     what the built binary answers when each shape is handed to it
#
# A table and an implementation that drift apart are what the first two catch. A table and an
# implementation that agree while the binary answers otherwise are what the probes catch. Every
# reading is a gate at zero. A contract differs from a backlog: a code with two meanings is a fault
# on the lap it arrives, so there is no population to work down and a ceiling would hold air.
#
# HOW `returned` IS DERIVED, and the precondition that keeps it sound. Every bare integer return in
# this module belongs to `main` -- the three helpers above it return an optional slice, a usize, and
# a slice. So the reading is `return <digit>;` at or after the `pub fn main` line. Should a bare
# integer return ever appear ABOVE that line, the derivation has stopped being true, and the scan
# says so by name rather than reading a helper's number as an exit code.
#
#   sh tools/fixtures/g/glow_run_contract_scan.sh
#
# Gate: tools/g/glow_run_contract_witness.rish -- Pen: tools/fixtures/g/glow_run_contract_control.sh
set -eu
export LC_ALL=C

# Root by upward walk (seated 20260828): the letter fold moved this script one
# directory deeper, and fixed ../.. depth arithmetic is what broke. The walk finds
# the first ancestor holding rishi/bin and tools/fixtures -- git-free so pen copies
# outside a repository still resolve -- bounded at 8 steps, loud past the bound.
ROOT=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
_fd_steps=0
while [ ! -d "$ROOT/rishi/bin" ] || [ ! -d "$ROOT/tools/fixtures" ]; do
  _fd_steps=$((_fd_steps + 1))
  if [ "$_fd_steps" -gt 8 ] || [ "$ROOT" = "/" ] || [ -z "$ROOT" ]; then
    echo "$0: no tree root within 8 steps (needs rishi/bin and tools/fixtures)" >&2
    exit 2
  fi
  ROOT=$(dirname "$ROOT")
done
cd "$ROOT"

SRC=${GLOW_RUN_CONTRACT_SRC:-glow/glow_run.rye}
BIN=${GLOW_RUN_CONTRACT_BIN:-glow/bin/glow_run}
DESK=${GLOW_RUN_CONTRACT_DESK:-glow/gen/b/bound-tick.glow}

if [ ! -f "$SRC" ]; then
  echo "detail=no compiler source at $SRC"
  echo "verdict=no_source"
  exit 0
fi

MAIN_LINE=$(grep -n '^pub fn main(' "$SRC" | head -1 | cut -d: -f1 || true)
if [ -z "$MAIN_LINE" ]; then
  echo "detail=no 'pub fn main(' in $SRC -- the return sites cannot be scoped"
  echo "verdict=no_main"
  exit 0
fi

# The derivation's own precondition, refused rather than assumed (door above).
EARLY=$(awk -v m="$MAIN_LINE" 'NR < m && /^[[:space:]]*return [0-9]+;/' "$SRC" | wc -l | tr -d ' ')
if [ "$EARLY" != "0" ]; then
  echo "early_integer_returns=$EARLY"
  echo "detail=a helper above main returns a bare integer, so 'returned' would read a non-exit number"
  echo "verdict=derivation_unsound"
  exit 0
fi

# DECLARED -- the head table. A row is two leading spaces, the code, two spaces, the name, so a
# prose line mentioning a digit can never be read as a row.
DECLARED=$(awk '/^\/\/![[:space:]]+[0-9][[:space:]][[:space:]]+[a-z]/ {
  for (i = 1; i <= NF; i++) if ($i ~ /^[0-9]$/) { print $i; break }
}' "$SRC" | sort -u)
DECLARED_N=$(printf '%s\n' "$DECLARED" | grep -c . || true)

# RETURNED -- main's own bare integer returns.
RETURNED=$(awk -v m="$MAIN_LINE" 'NR >= m && /^[[:space:]]*return [0-9]+;/ {
  gsub(/[^0-9]/, ""); print
}' "$SRC" | sort -u)
RETURNED_N=$(printf '%s\n' "$RETURNED" | grep -c . || true)

undeclared=
for c in $RETURNED; do
  case " $(echo $DECLARED) " in *" $c "*) ;; *) undeclared="$undeclared $c" ;; esac
done
unreturned=
for c in $DECLARED; do
  case " $(echo $RETURNED) " in *" $c "*) ;; *) unreturned="$unreturned $c" ;; esac
done
UNDECLARED_N=$(printf '%s\n' $undeclared | grep -c . || true)
UNRETURNED_N=$(printf '%s\n' $unreturned | grep -c . || true)

echo "src=$SRC"
echo "declared=$(echo $DECLARED | tr ' ' ',')"
echo "declared_codes=$DECLARED_N"
echo "returned=$(echo $RETURNED | tr ' ' ',')"
echo "returned_codes=$RETURNED_N"
echo "undeclared_returns=$UNDECLARED_N"
echo "undeclared_return_codes=$(echo $undeclared | tr ' ' ',')"
echo "unreturned_declared=$UNRETURNED_N"
echo "unreturned_declared_codes=$(echo $unreturned | tr ' ' ',')"

# PROBED -- what the binary answers. A tree with no built binary reports the fact by name rather
# than calling the contract proven; a guard that cannot run its instrument must not describe its
# subject (%460, one lane over).
if [ ! -x "$BIN" ]; then
  echo "probes=0"
  echo "probe_mismatch=0"
  echo "detail=no built binary at $BIN -- the declared/returned halves stand, the metal half is unread"
  echo "verdict=unprobed"
  exit 0
fi

PEN=$(mktemp -d "${TMPDIR:-/tmp}/glow-run-contract.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM
mkdir -p "$PEN/adir"
# A source past the 64 KiB ceiling the module reads with.
{ head -c 70000 /dev/zero | tr '\0' 'x'; printf '\n|-  32\n'; } > "$PEN/over.glow"

probes=0
mismatch=0
mismatch_names=
probe() {
  _want=$1
  _name=$2
  shift 2
  _got=0
  "$BIN" "$@" >/dev/null 2>&1 || _got=$?
  probes=$((probes + 1))
  echo "probe_${_name}=$_got"
  if [ "$_got" != "$_want" ]; then
    mismatch=$((mismatch + 1))
    mismatch_names="$mismatch_names ${_name}(want=${_want},got=${_got})"
  fi
}

probe 4 usage_bare
probe 4 usage_sample_argv --sample-argv
probe 3 unreadable_absent "$PEN/no-such-desk.glow"
probe 3 unreadable_directory "$PEN/adir"
probe 3 unreadable_over_ceiling "$PEN/over.glow"
if [ -f "$DESK" ]; then
  probe 0 lowered "$DESK"
else
  echo "detail=no sample desk at $DESK -- the lowered probe is unread"
fi

echo "probes=$probes"
echo "probe_mismatch=$mismatch"
echo "probe_mismatch_detail=${mismatch_names# }"

if [ "$UNDECLARED_N" != "0" ] || [ "$UNRETURNED_N" != "0" ]; then
  echo "verdict=table_disagrees"
  exit 0
fi
if [ "$mismatch" != "0" ]; then
  echo "verdict=metal_disagrees"
  exit 0
fi
echo "verdict=ok"
