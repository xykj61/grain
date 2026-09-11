#!/bin/sh
# tools/fixtures/g/glow_trap_bound_control.sh -- the Glow compiler's own refusal of an
# unbounded loop, planted and lifted through the real driver.
#
# WHAT THIS PROVES, and why it is a control rather than a scan. Glow's `|-` trap takes a
# required bound as its first child (glow/rune_bounded_trap.rye), so a loop written with no
# circumference is a compile-time refusal rather than a runtime surprise. That claim had two
# proofs standing beside it and a hole between them, read 20260911:
#
#   module, refuses   glow/rune_bounded_trap_witness.rye proves parse() refuses four ways --
#                     GREEN in 2.2s, and on NO roster, so its silence meant nothing.
#   driver, accepts   glow_desk_run lowers, builds and runs 301 desks, two of them traps
#                     (glow/gen/b/bound-tick.glow, glow/gen/l/lent-tick.glow). Rostered.
#   driver, refuses   nothing, ever.
#
# A gate proven in the accepting direction alone cannot be told from a bypass, which is this
# tree's own sentence in .claude/rules/ascii-first.md. So this control drives
# glow/bin/glow_run itself -- the binary a hand runs -- writes each probe into a throwaway pen,
# and requires the refusal in the compiler's own words before lifting the same trap to a bound
# and requiring acceptance.
#
# WHAT IT DOES NOT REACH. Whether the lowered program enforces its bound at run time. That is
# rune_bounded_trap_witness's claims 7 and 8 (tick 20 under 32 completes; 40 under 32 refuses
# BoundExceeded), proven at the module and left there.
#
#   sh tools/fixtures/g/glow_trap_bound_control.sh

set -e
ROOT=$(CDPATH= cd -- "$(dirname "$0")/../../.." && pwd)
cd "$ROOT"

ZIG="${RYE_ZIG:-vendor/zig-toolchain/zig}"

# Bound: nine probes, stated once here and counted back at the close, so a case added without a
# leg -- or a leg lost to an early exit -- is a difference a reader sees rather than infers.
max_cases=9

test -f glow/glow_run.rye || { echo "glow_trap_bound: no compiler source at glow/glow_run.rye" >&2; exit 2; }
test -x "$ZIG" || { echo "glow_trap_bound: no zig toolchain at $ZIG" >&2; exit 2; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/glow-trap-bound.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

# The driver is built into the PEN rather than over glow/bin/glow_run. Those bytes are shared by
# the worker and the batch desk runner, and two builders interleaving there is the hazard the
# batch scan already takes a directory lock against. A control that needed that lock could not
# run beside a desk pass; one that owns its own binary can.
DRIVER="$PEN/glow_run"
if ! env RYE_ZIG="$ZIG" rye/bin/rye build glow/glow_run.rye -femit-bin="$DRIVER" > "$PEN/build.log" 2>&1; then
  echo "glow_trap_bound: driver build failed" >&2
  tail -20 "$PEN/build.log" >&2
  exit 2
fi

legs=0
failed=0

# A refusing probe writes no lowered file, and an accepting one writes glow/.cache/<stem>.rye --
# a shared, gitignored directory. Each probe therefore takes a stem of its own, so two passes
# running at once never read each other's lowering.
probe() {
  _name=$1; _want=$2; _wanterr=$3; _text=$4
  _stem="trapgate-$_name-$$"
  printf '%s\n' "$_text" > "$PEN/$_stem.glow"
  _out=$("$DRIVER" "$PEN/$_stem.glow" 2>&1) && _code=0 || _code=$?
  if [ "$_code" -eq 0 ]; then _got=accept; else _got="refuse"; fi
  _leg=ok
  if [ "$_got" != "$_want" ]; then _leg=no; fi
  if [ "$_want" = refuse ] && [ "$_leg" = ok ]; then
    # The error is named, never merely counted: a driver that refused everything for one
    # reason would pass a leg that asked only whether it refused.
    case $_out in
      *"$_wanterr"*) : ;;
      *) _leg=no ;;
    esac
  fi
  legs=$((legs + 1))
  [ "$_leg" = ok ] || failed=$((failed + 1))
  echo "case=$_name want=$_want got=$_got error=$_wanterr leg=$_leg detail=$_out"
  # An accepted probe leaves a lowered file behind in the shared cache. It is gitignored, so no
  # tree digest moves; it is removed anyway, because a directory that only grows is one somebody
  # eventually clears by hand under time pressure.
  rm -f "glow/.cache/$_stem.rye"
}

long_ident=a_very_long_identifier_name_that_runs_past_sixty_four_bytes_for_sure_ok

# The plant and its lift, first: one trap with no circumference, and the same trap with one.
probe bare_trap        refuse MissingBound        '|-'
probe literal_bound    accept -                   '|-  32'

# The dependent form. A period that is a runtime length is ACCEPTED rather than refused, which
# is the answer to the question a proposal page asked as its own falsifier.
probe lent_bound       accept -                   '|-  (lent records)'

# The four remaining refusals, each in the compiler's own word.
probe bare_ident       refuse MalformedBoundExpr  '|-  records'
probe lent_empty       refuse MalformedBoundExpr  '|-  (lent)'
probe lent_unclosed    refuse MalformedBoundExpr  '|-  (lent records'
probe literal_overflow refuse LiteralOverflow     '|-  4294967296'
probe ident_too_long   refuse IdentTooLong        "|-  (lent $long_ident)"

# A circumference of zero is ACCEPTED, and this leg exists to record that rather than to praise
# it. `|-  0` is a loop declared to take no steps, which parses, lowers, and runs clean. Whether
# a language should let a reader write it is a question for a hand; what a control owes is that
# the behavior is written down where a change to it is audible.
probe zero_bound       accept -                   '|-  0'

echo "control_legs=$legs"
echo "control_failed=$failed"
echo "control_max_cases=$max_cases"
if [ "$legs" -ne "$max_cases" ]; then
  echo "control_verdict=leg_count_moved"
  exit 1
fi
if [ "$failed" -ne 0 ]; then
  echo "control_verdict=failed"
  exit 1
fi
echo "control_verdict=ok"
