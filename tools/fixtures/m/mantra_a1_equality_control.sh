#!/bin/sh
# tools/fixtures/m/mantra_a1_equality_control.sh -- the equality arc, broken on purpose.
#
# WHAT THIS DOES. tools/m/mantra_a1_equality_witness.rish claims that four Glow desks under
# src/gate/ decide Mantra's field counts EXACTLY -- 3 for a Line, 2 for a Weave, 2 for a Diff,
# 3 for a Store -- answering 1 on the count and 0 on either neighbor. This control builds a pen,
# changes ONE thing in it, and watches a witness answer with a non-zero exit. Every break is
# shown from both sides, so a real refusal stays tellable from a bypass.
#
# THE PEN IS A DIRECTORY WITH ONE REAL ROOM. Each witness reads its desk by a path relative to
# the working directory -- src/gate/<name>.glow -- and shells out to tools/g/glow_run_worker.sh
# to run it. So the pen carries a REAL COPY of src/gate/ and symlinks the four rooms the worker
# needs (tools, glow, rye, vendor). Copying the toolchain would make the pen a second tree; a
# symlink keeps the pen small and keeps the phases honest, because the only thing that differs
# between a passing phase and a failing one is the desk this control edited.
#
# SIX PHASES.
#   clean                -- the unmutated pen reaches GREEN, exit 0. This leg is what lets every
#                           other phase read as the break speaking rather than the pen.
#   eq_to_gth            -- `(eq sample 2)` becomes `(gth sample 1)`, so a CEILING answers where
#                           an exact answer is owed. Both agree on 2 and on 1; they part at 3,
#                           which is why the witness asks the just-over side at all. This is the
#                           arc's own subject: gth speaks ceilings, eq speaks exactly.
#   constant_moved       -- `(eq sample 2)` becomes `(eq sample 3)`, a field count drifting out
#                           from under its lock while the rune stays right.
#   desk_missing         -- the desk is deleted. An absent file must red rather than read as
#                           agreement, which is the shape REDS %467 named one room over: presence
#                           is the cheaper question wearing the expensive one's answer.
#   neighbor_broken      -- the gth neighbor desk src/gate/gate-mantra-gen-floor-u32.glow is
#                           broken. Each witness re-checks that neighbor by name, so the arc
#                           cannot be closed by breaking the family it was measured against.
#   witness_uncompilable -- a type error is planted in the witness copy and it is built. This is
#                           REDS %449's fault -- a proof that stopped compiling while grep-shaped
#                           guards stayed green -- reproduced here so this guard is known to
#                           catch it rather than assumed to.
#
# EXPECTED: clean_exit=0 and every other phase non-zero. The exit codes are printed rather than
# asserted here; tools/m/mantra_a1_equality_witness.rish holds them, so the numbers live in one
# place and this file stays the thing that produces them.
#
# Driven by tools/m/mantra_a1_equality_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
zig="$root/vendor/zig-toolchain/zig"
rye="$root/rye/bin/rye"
witness_src="$root/tools/rye/mantra_a1_weave_fields_eq_witness.rye"
desk_name="gate-mantra-weave-fields-eq-u32.glow"
neighbor_name="gate-mantra-gen-floor-u32.glow"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

# A type error inside a function the witness actually calls, so no comptime walker is wanted:
# `contains` is on main's own path, and any build at all analyzes it.
planted_fault='s|return std.mem.indexOf(u8, hay, needle) != null;|return hay + needle;|'

# One pen: a real src/gate/ and symlinks to the rooms the Glow worker reads.
make_pen() {
  _pen="$1"
  mkdir -p "$_pen/src"
  cp -R "$root/src/gate" "$_pen/src/gate"
  for _room in tools glow rye vendor; do
    ln -s "$root/$_room" "$_pen/$_room"
  done
}

# Run one phase. $1 name, $2 sed program for the desk (empty for none), $3 extra shell to run
# inside the pen before the witness (empty for none). Echoes "<name>_exit=<code>".
run_phase() {
  _name="$1"
  _desk_program="$2"
  _extra="$3"
  _pen="$work/$_name"
  make_pen "$_pen"
  if [ -n "$_desk_program" ]; then
    sed "$_desk_program" "$_pen/src/gate/$desk_name" > "$_pen/desk.tmp"
    cat "$_pen/desk.tmp" > "$_pen/src/gate/$desk_name"
    rm -f "$_pen/desk.tmp"
  fi
  if [ -n "$_extra" ]; then
    ( cd "$_pen" && eval "$_extra" ) || true
  fi
  # The braces carry their own stderr redirect on purpose: a witness that fails an assert dies
  # on SIGABRT, and the SHELL -- not the subshell -- prints "Aborted (core dumped)" to its own
  # stderr when a child dies on a signal. Redirecting only the subshell leaves that line on the
  # control's output, where a reader takes it for a fault in the control rather than the refusal
  # it was asked to produce. The exit code survives the wrap, which is what the phase reads.
  _code=0
  { ( cd "$_pen" && "$bin" ) >/dev/null 2>&1 ; } 2>/dev/null || _code=$?
  echo "${_name}_exit=${_code}"
}

# The witness binary is built once from the real source and reused by every desk phase, so a
# desk phase cannot pass or fail for a build reason. The uncompilable phase builds its own.
bin="$work/a1-weave-fields"
env RYE_ZIG="$zig" "$rye" build "$witness_src" -femit-bin="$bin" >/dev/null 2>&1 || {
  echo "control_verdict=broken"
  echo "detail: the witness does not build from its own source, so no phase below can mean anything"
  exit 1
}

run_phase clean '' ''
run_phase eq_to_gth 's|(eq sample 2)|(gth sample 1)|' ''
run_phase constant_moved 's|(eq sample 2)|(eq sample 3)|' ''
run_phase desk_missing '' "rm -f src/gate/$desk_name"
run_phase neighbor_broken '' "printf 'this is not a desk\n' > src/gate/$neighbor_name"

# The sixth phase is a build rather than a run, so it stands outside run_phase.
sed "$planted_fault" "$witness_src" > "$work/planted_witness.rye"
if ! grep -q 'return hay + needle;' "$work/planted_witness.rye"; then
  echo "control_verdict=broken"
  echo "detail: the plant did not land -- the line it edits left the witness, so the phase below proves nothing"
  exit 1
fi
uncompilable_code=0
env RYE_ZIG="$zig" "$rye" build "$work/planted_witness.rye" \
  -femit-bin="$work/planted_witness" >/dev/null 2>&1 || uncompilable_code=$?
echo "witness_uncompilable_exit=${uncompilable_code}"

echo "control_verdict=ok"
