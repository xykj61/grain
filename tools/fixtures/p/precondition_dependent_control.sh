#!/bin/sh
# precondition_dependent_control.sh -- the precondition census proven on a real repository in a pen.
#
# Every refusal is planted and then LIFTED, because a refusal shown only in the failing direction
# cannot be told from a guard that refuses everything. The gate is proven from both sides twice: once
# by declaring the capability the roster row was missing, and once by moving the same dependent's
# probe to a path the pen tracks, since only an untracked one is a precondition at all.
#
#   sh tools/fixtures/p/precondition_dependent_control.sh
#
# Prints `pass=N fail=N`. Bounded: one pen holding a throwaway git repository. The probe cases RUN
# the planted runners rather than reading them, which is the half a static pen cannot reach -- and
# the half that changed `gitlink_dependent`'s whole reading on `20260911`, when the behavior it had
# described for two days turned out to be the opposite of what it claimed.
#
# THE CASE THIS PEN EXISTS FOR is the e0 one: a runner that BUILDS the untracked path it probes is
# the worked example of the cure, and the scan's first draft charged it with the fault. It is proven
# in both spellings -- the literal path in the build line, and the bound variable the real file uses
# -- because the variable spelling is the one that was missed.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
scan="$root/tools/fixtures/p/precondition_dependent_scan.sh"
# The pen holds planted runners and no interpreter, so the probe is aimed at the real tree's rishi
# while its subjects stay in the pen.
real_rishi="$root/rishi/bin/rishi"
pen=${TMPDIR:-/tmp}/precondition-dependent-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/tools/p" "$pen/construction" "$pen/vendor"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

cd "$pen"
git init -q .
git config user.email pen@example.invalid
git config user.name pen

ask() { PRECOND_ROOT="$pen" PRECOND_RISHI="$real_rishi" sh "$scan" "${1:-measure}" 2>&1; }
stage() { git add -A >/dev/null 2>&1 || true; }

# CASE 1 -- a repository tracking no runner has no subject, and refuses rather than reading zero.
printf 'x\n' > README.md
stage
out=$(ask || true)
check "no runner refuses"              yes "$(has "$out" 'verdict=no_runners')"

# CASE 2 -- an ordinary runner naming no precondition is clean.
printf 'say "plain"\n' > tools/p/plain_witness.rish
stage
out=$(ask)
check "a plain runner is clean"        yes "$(has "$out" 'dependents=0')"
check "and the verdict is ok"          yes "$(has "$out" 'verdict=ok')"

# CASE 3 -- a probe on a path the pen TRACKS is no precondition: the file is there for every clone.
mkdir -p built
printf 'tracked\n' > built/tracked-thing
cat > tools/p/tracked_probe_witness.rish <<'W'
let have = run ["test" "-f" "built/tracked-thing"]
assert have.ok else "tracked: missing"
W
stage
out=$(ask)
check "a tracked probe is clean"       yes "$(has "$out" 'dependents=0')"

# CASE 4 -- the same probe on an UNTRACKED path is a precondition, and with no roster row it is
# unrostered. This is the `build wayland_seed first` shape REDS %646 left as a sample.
cat > tools/p/artifact_probe_witness.rish <<'W'
let have = run ["test" "-x" "built/made-thing"]
assert have.ok else "artifact: build made-thing first"
W
stage
out=$(ask)
check "an untracked probe is counted"  yes "$(has "$out" 'dependents=1')"
check "it reads as an artifact"        yes "$(has "$out" 'artifact_dependents=1')"
check "and it is unrostered"           yes "$(has "$out" 'unrostered=1')"

# CASE 5 -- a COMMENT naming the probe is documentation. Every member of this tree's own wayland
# family carries such a header beside the assert that does the work, so counting both would report
# one finding twice.
cat > tools/p/comment_only_witness.rish <<'W'
# Rebuild built/made-thing first if it is missing.
# let have = run ["test" "-x" "built/other-thing"]
say "this one only talks about it"
W
stage
out=$(ask)
check "a comment is not a dependency"  yes "$(has "$out" 'dependents=1')"

# CASE 6 -- a BOUND variable resolves. The real wayland family holds its path in
# `let seed_bin = "brushstroke/bin/brushstroke-wayland-seed"` and probes the name, so a scan reading
# only literals would see none of it.
cat > tools/p/bound_probe_witness.rish <<'W'
let seed_bin = "built/bound-thing"
let have = run ["test" "-x" seed_bin]
assert have.ok else "bound: build bound-thing first"
W
stage
out=$(ask)
check "a bound path resolves"          yes "$(has "$out" 'dependents=2')"

# CASE 7 -- THE e0 CASE, literal spelling. A runner that BUILDS the untracked path it probes is the
# cure rather than the fault, and it leaves the population into `builds_own`.
cat > tools/p/builds_literal_witness.rish <<'W'
let build = run ["sh" "-c" "rye build thing.rye -femit-bin=built/literal-thing"]
assert build.ok else "builds-literal: the build must succeed"
let have = run ["test" "-x" "built/literal-thing"]
assert have.ok else "builds-literal: the build must leave an executable"
W
stage
out=$(ask)
check "building literally is excused"  yes "$(has "$out" 'dependents=2')"
check "and counted as builds_own"      yes "$(has "$out" 'builds_own=1')"

# CASE 8 -- THE e0 CASE, variable spelling, which is the one the first draft missed. The build names
# `${bin}` and the literal path appears only on the binding line, so a search for the literal finds
# no build and charges the worked example with the fault.
cat > tools/p/builds_bound_witness.rish <<'W'
let bin = "built/bound-built-thing"
let build = run ["sh" "-c" "rye build thing.rye -femit-bin=${bin}"]
assert build.ok else "builds-bound: the build must succeed"
let have = run ["test" "-x" bin]
assert have.ok else "builds-bound: the build must leave an executable"
W
stage
out=$(ask)
check "building via a variable too"    yes "$(has "$out" 'dependents=2')"
check "and both read builds_own"       yes "$(has "$out" 'builds_own=2')"

# CASE 9 -- a probe under `vendor/` is a REQUIRED dependency rather than an optional precondition.
# The operator card names `vendor/` a precondition every clone initialises before its first lap, so a
# red from an empty one is an environment fact. Derived from the room, never from a list kept here.
cat > tools/p/vendor_probe_witness.rish <<'W'
let zig = "vendor/zig-toolchain/zig"
let have = run ["test" "-x" zig]
assert have.ok else "vendor: the toolchain must be fetched"
W
stage
out=$(ask)
check "a vendor probe is required"     yes "$(has "$out" 'required_dependents=1')"
check "and leaves the population"      yes "$(has "$out" 'dependents=2')"

# CASE 10 -- a DISPLAY precondition with no artifact beside it reads `display`. REDS %173 already
# seated this class's cure one room over: a machine with no screen is a machine, never a red.
cat > tools/p/display_probe_witness.rish <<'W'
let wayland = run ["sh" "-c" "test x$WAYLAND_DISPLAY != x"]
assert wayland.ok else "display: WAYLAND_DISPLAY unset"
W
stage
out=$(ask)
check "a display probe is counted"     yes "$(has "$out" 'dependents=3')"
check "and reads as display"           yes "$(has "$out" 'display_dependents=1')"

# CASE 11 -- a runner wanting BOTH is counted in both kinds rather than sorted into one. The two
# counts OVERLAP on purpose: read as a partition, the display count read zero on this tree, where
# four of ten dependents want a screen as well as a binary.
cat > tools/p/both_probe_witness.rish <<'W'
let wayland = run ["sh" "-c" "test x$WAYLAND_DISPLAY != x"]
assert wayland.ok else "both: WAYLAND_DISPLAY unset"
let have = run ["test" "-x" "built/both-thing"]
assert have.ok else "both: build both-thing first"
W
stage
out=$(ask)
check "both kinds count one runner"    yes "$(has "$out" 'both_dependents=1')"
check "the artifact count includes it" yes "$(has "$out" 'artifact_dependents=3')"
check "the display count does too"     yes "$(has "$out" 'display_dependents=2')"
check "and the population counts once" yes "$(has "$out" 'dependents=4')"

# CASE 12 -- THE GATE. A rostered dependent naming no `capability` is the one row that would red the
# whole fleet on every machine lacking the artifact or the screen.
cat > construction/standing-equipment.kyri <<'R'
format standing-equipment-v1
guard artifact_probe
path tools/p/artifact_probe_witness.rish
tier lap
R
stage
out=$(ask || true)
check "a rostered dependent is gated"  yes "$(has "$out" 'rostered_undeclared=1')"
check "and the verdict names it"       yes "$(has "$out" 'verdict=undeclared_precondition')"

# CASE 13 -- the gate LIFTED by declaring the capability, which is the repair the roster already
# carries for `ipv6`, `qemu_riscv`, and `tigerbeetle_clone`.
cat > construction/standing-equipment.kyri <<'R'
format standing-equipment-v1
guard artifact_probe
path tools/p/artifact_probe_witness.rish
tier lap
capability wayland_seed_built
R
stage
out=$(ask)
check "declaring lifts the gate"       yes "$(has "$out" 'rostered_undeclared=0')"
check "and the verdict returns to ok"  yes "$(has "$out" 'verdict=ok')"
check "the row leaves unrostered"      yes "$(has "$out" 'unrostered=3')"

# CASE 14 -- ONE ROW'S DECLARATION EXCUSES ONLY ITS OWN ROW. Asking whether the FILE holds the word
# `capability` anywhere would let the row above cover every undeclared one beneath it.
cat >> construction/standing-equipment.kyri <<'R'

guard bound_probe
path tools/p/bound_probe_witness.rish
tier lap
R
stage
out=$(ask || true)
check "a second row is its own record" yes "$(has "$out" 'rostered_undeclared=1')"

# CASE 15 -- no roster at all reads `roster_present=no` rather than refusing: a pen, a fresh clone,
# and a checkout mid-rebase all legitimately lack it.
rm -f construction/standing-equipment.kyri
stage
out=$(ask)
check "an absent roster is named"      yes "$(has "$out" 'roster_present=no')"
check "and every dependent unrostered" yes "$(has "$out" 'unrostered=4')"

# THE PROBE. Static shape above, measured behavior here.

# CASE 16 -- a dependent that REFUSES over its absent precondition is the REDS %646 shape exactly,
# and `probe_red` counts it.
out=$(PRECOND_PROBE_CEILING=99 ask probe)
check "a refusing dependent reds"      yes "$(has "$out" 'probe_red=4')"
check "and none runs clean"            yes "$(has "$out" 'probe_green=0')"

# CASE 17 -- a dependent that SKIPS HONESTLY exits clean and is rostable today. This is the shape
# every one of `gitlink_dependent`'s 38 members already has, and none of this family's ten.
cat > tools/p/honest_skip_witness.rish <<'W'
let have = run ["test" "-x" "built/skipped-thing"]
if have.ok then say "honest-skip: GREEN"
if (have.ok == false) then say "honest-skip: SKIP -- built/skipped-thing absent on this bench"
W
stage
out=$(PRECOND_PROBE_CEILING=99 ask probe)
check "an honest skip runs clean"      yes "$(has "$out" 'probe_green=1')"
check "and the refusals are unchanged" yes "$(has "$out" 'probe_red=4')"

# CASE 18 -- a dependent whose precondition this bench MEETS reads `probe_unread`. Absence cannot be
# observed without removing the artifact, and removing what it measures is the one move a meter may
# never make.
printf '#!/bin/sh\nexit 0\n' > built/made-thing
chmod +x built/made-thing
out=$(PRECOND_PROBE_CEILING=99 ask probe)
check "a met precondition is unread"   yes "$(has "$out" 'probe_unread=1')"
check "and leaves the red count"       yes "$(has "$out" 'probe_red=3')"
rm -f built/made-thing

# CASE 19 -- THE CEILING, proven from both sides. At the count it refuses nothing; one under it
# refuses, so the ratchet is a real reading rather than a number nobody tests.
out=$(PRECOND_PROBE_CEILING=4 ask probe)
check "at the ceiling it passes"       yes "$(has "$out" 'probe_under_ceiling=yes')"
check "and the verdict is ok"          yes "$(has "$out" 'verdict=ok')"
out=$(PRECOND_PROBE_CEILING=3 ask probe || true)
check "one under it refuses"           yes "$(has "$out" 'probe_under_ceiling=no')"
check "and the verdict names it"       yes "$(has "$out" 'verdict=probe_over_ceiling')"

# CASE 20 -- an instrument that cannot answer refuses rather than calling every dependent red. A
# bench fact wearing a finding's colour is the one error this whole reading exists to prevent.
out=$(PRECOND_ROOT="$pen" PRECOND_RISHI="$pen/no-such-runner" sh "$scan" probe 2>&1 || true)
check "an absent runner refuses"       yes "$(has "$out" 'verdict=no_runner')"

printf 'pass=%s fail=%s\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
