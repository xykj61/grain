#!/bin/sh
# gitlink_dependent_control.sh -- the optional-dependency census proven on real repositories in a pen.
#
# Every refusal is planted and then LIFTED, because a refusal shown only in the failing direction
# cannot be told from a guard that refuses everything. The gate is proven from both sides twice: once
# by declaring the capability the roster row was missing, and once by moving the same dependent from
# an optional gitlink to a required one, since only the first is gated.
#
#   sh tools/fixtures/g/gitlink_dependent_control.sh
#
# Prints `pass=N fail=N`. Bounded: 37 cases, one pen holding a throwaway git repository. The last
# five RUN the planted witnesses rather than reading them, which is the half a static pen could not
# reach -- see the scan header for the population where shape and behavior came apart.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
scan="$root/tools/fixtures/g/gitlink_dependent_scan.sh"
pen=${TMPDIR:-/tmp}/gitlink-dependent-pen-$$
trap 'rm -rf "$pen" "$pen-outside"' EXIT INT TERM
mkdir -p "$pen/tools/g" "$pen/construction"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

cd "$pen"
git init -q .
git config user.email pen@example.invalid
git config user.name pen

ask() { GITLINK_ROOT="$pen" sh "$scan" "${1:-measure}" 2>&1; }
# A gitlink is a mode-160000 index entry. Planting one by hand is exactly what an uninitialised
# submodule looks like on disk: recorded in the index, nothing checked out.
link() { git update-index --add --cacheinfo "160000,$(printf '%040d' 1),$1"; }
# `git add -A` removes an index entry whose path is absent from disk, and an uninitialised submodule
# is exactly that -- so every staging re-plants the two gitlinks. This mirrors the real thing: a
# checkout keeps the entry because the SUPERPROJECT's tree carries it, not because a directory does.
links_planted=no
stage() {
  git add -A >/dev/null
  if [ "$links_planted" = yes ]; then link gratitude/teacher; link vendor/library; fi
}

# CASE 1 -- a repository recording no submodule has no subject, and says so rather than reading zero.
printf 'say "nothing here"\n' > tools/g/plain_witness.rish
stage
out=$(ask || true)
check "no gitlink refuses"            yes "$(has "$out" 'verdict=no_gitlinks')"

# Now the two rooms, each holding one uninitialised submodule.
link gratitude/teacher
link vendor/library
links_planted=yes
out=$(ask)
check "both gitlinks are counted"     yes "$(has "$out" 'gitlinks=2')"
check "gratitude reads optional"      yes "$(has "$out" 'optional_gitlinks=1')"
check "vendor reads required"         yes "$(has "$out" 'required_gitlinks=1')"

# CASE 2 -- a witness naming the optional submodule only in a COMMENT is documentation, never a
# dependency. Every member of this tree's own tigerbeetle family carries such a header, so counting
# it would double every real finding.
cat > tools/g/comment_only_witness.rish <<'W'
# Requires gratitude/teacher checked out.
say "this one only talks about it"
W
stage
out=$(ask)
check "a comment is not a dependency" yes "$(has "$out" 'optional_dependents=0')"

# CASE 3 -- the same path on a working line IS a dependency, and with no roster row it is unrostered.
cat > tools/g/optional_witness.rish <<'W'
let clone = run ["test" "-d" "gratitude/teacher/src"]
assert clone.ok else "optional: gratitude/teacher/src ABSENT"
W
stage
out=$(ask)
check "a working line IS a dependency" yes "$(has "$out" 'optional_dependents=1')"
check "an unrostered one is counted"   yes "$(has "$out" 'optional_unrostered=1')"
check "and unrostered does not gate"   yes "$(has "$out" 'verdict=ok')"
out=$(ask list)
check "the unrostered one is named"    yes "$(has "$out" 'unrostered: tools/g/optional_witness.rish')"

# CASE 4 -- THE BITE. Rostering it without declaring the capability is the one row that would red
# every machine studying rather than cloning, so it refuses.
cat > construction/standing-equipment.kyri <<'R'
format standing-equipment-v1
guard optional_guard
path tools/g/optional_witness.rish
tier lap
R
stage
out=$(ask)
check "rostered undeclared bites"      yes "$(has "$out" 'verdict=undeclared_dependency')"
check "and it is counted"              yes "$(has "$out" 'rostered_undeclared=1')"
out=$(ask list)
check "the undeclared row is named"    yes "$(has "$out" 'undeclared: tools/g/optional_witness.rish')"

# CASE 5 -- THE PLANT LIFTED. Declaring the capability is the whole cure, and the gate opens.
cat > construction/standing-equipment.kyri <<'R'
format standing-equipment-v1
guard optional_guard
path tools/g/optional_witness.rish
tier lap
capability teacher_clone
R
stage
out=$(ask)
check "a declared capability passes"   yes "$(has "$out" 'verdict=ok')"
check "and nothing is left undeclared" yes "$(has "$out" 'rostered_undeclared=0')"

# CASE 6 -- ONE DECLARED ROW MAY NOT EXCUSE THE NEXT. The roster is read per record, so a second
# undeclared guard beside a declared one still bites. Reading the file for the word anywhere would
# pass this, which is why the record boundary is the check.
cat > tools/g/second_witness.rish <<'W'
let clone = run ["test" "-d" "gratitude/teacher/src"]
assert clone.ok else "second: gratitude/teacher/src ABSENT"
W
cat >> construction/standing-equipment.kyri <<'R'

guard second_guard
path tools/g/second_witness.rish
tier lap
R
stage
out=$(ask)
check "a declared row excuses nobody"  yes "$(has "$out" 'rostered_undeclared=1')"
check "and the pair still bites"       yes "$(has "$out" 'verdict=undeclared_dependency')"

# CASE 7 -- THE GATE'S OTHER SIDE. The same undeclared row depending on a REQUIRED gitlink walks
# free, because the operator card already names `vendor/` a precondition every clone initialises.
cat > tools/g/second_witness.rish <<'W'
let lib = run ["test" "-d" "vendor/library/src"]
assert lib.ok else "second: vendor/library/src ABSENT"
W
stage
out=$(ask)
check "a required dependency is free"  yes "$(has "$out" 'verdict=ok')"
check "and it is counted apart"        yes "$(has "$out" 'required_dependents=1')"

# CASE 8 -- THE PEN PROVEN INNOCENT. A directory that is no repository at all must refuse rather
# than read the checkout the caller happens to be standing in, since a scan reaching past its own
# root would report the real tree's numbers from inside a pen and every case above would be a lie.
outside="$pen-outside"
mkdir -p "$outside"
out=$(GITLINK_ROOT="$outside" sh "$scan" 2>&1 || true)
check "a non-repository refuses"       yes "$(has "$out" 'verdict=not_a_repository')"
check "and reports no count at all"    no  "$(has "$out" 'gitlinks=')"

# --------------------------------------------------------------------------------------------
# THE PROBE. Everything above reads a SHAPE. These read a BEHAVIOR, and the two came apart in the
# real tree: 38 runners the static half called `unrostered` all exit clean with the clone absent,
# while CASE 3's plant -- written from the header's own sentence rather than from a file on disk --
# was the only hard-asserting specimen anywhere. So both shapes are planted here, and the free one
# is planted FIRST, because a refusal proven only against a specimen built to refuse proves nothing
# about the population it is aimed at.
rishi_real=$root/rishi/bin/rishi
probe() { GITLINK_ROOT="$pen" GITLINK_RISHI="$rishi_real" sh "$scan" probe 2>&1; }

# Leave exactly one optional dependent standing, so each probe reading has one subject.
rm -f tools/g/second_witness.rish
cat > construction/standing-equipment.kyri <<'R'
format standing-equipment-v1
R

# CASE 9 -- THE SHAPE THE TREE ACTUALLY HOLDS. A runner that reads the absence and skips is clean,
# and the probe must say so rather than inheriting the static half's word for it.
cat > tools/g/optional_witness.rish <<'W'
let clone = run ["test" "-d" "gratitude/teacher/src"]
if (clone.ok == false) then say "optional: SKIP -- gratitude/teacher is uninitialised here"
if clone.ok then say "optional: read the clone"
W
stage
out=$(probe || true)
check "an honest skip reads green"     yes "$(has "$out" 'probe_green=1')"
check "and nothing reds"               yes "$(has "$out" 'probe_red=0')"
check "and the verdict stands"         yes "$(has "$out" 'verdict=ok')"
check "and it is named as green"       yes "$(has "$out" 'probe green: tools/g/optional_witness.rish')"
check "while the shape still counts it" yes "$(has "$out" 'optional_unrostered=1')"

# CASE 10 -- THE BITE. The hard assert over a reading library is REDS %646's shape exactly, and it
# is the one thing `probe_red` exists to refuse.
cat > tools/g/optional_witness.rish <<'W'
let clone = run ["test" "-d" "gratitude/teacher/src"]
assert clone.ok else "optional: gratitude/teacher/src ABSENT"
W
stage
out=$(probe || true)
check "a hard assert reads red"        yes "$(has "$out" 'probe_red=1')"
check "and the probe gate bites"       yes "$(has "$out" 'verdict=probe_red')"
check "and it is named as red"         yes "$(has "$out" 'probe RED: tools/g/optional_witness.rish')"
check "and green falls to zero"        yes "$(has "$out" 'probe_green=0')"

# CASE 11 -- THE STATIC HALF IS BLIND TO BOTH. The same two plants read identically to `measure`,
# which is the whole finding: one reading counts a shape, the other measures what it does.
out=$(ask)
check "measure sees no colour"         no  "$(has "$out" 'probe_red=')"
check "and still says ok"              yes "$(has "$out" 'verdict=ok')"

# CASE 12 -- THE PLANT LIFTED, by checking the clone OUT rather than by editing the runner. With
# the submodule populated the absence cannot be observed, so the same red-shaped runner reads
# `unread` -- and a meter that answered anything else would have to delete a clone to find out.
mkdir -p gratitude/teacher/src
printf 'teacher\n' > gratitude/teacher/src/readme
out=$(probe || true)
check "a checked-out clone is unread"  yes "$(has "$out" 'probe_unread=1')"
check "and the red is not claimed"     yes "$(has "$out" 'probe_red=0')"
check "and the verdict opens again"    yes "$(has "$out" 'verdict=ok')"
check "and it is named as unread"      yes "$(has "$out" 'probe unread: tools/g/optional_witness.rish')"
rm -rf gratitude/teacher

# CASE 13 -- AN INSTRUMENT THAT CANNOT ANSWER REFUSES. Without a runner every dependent would read
# red, and that red would be a bench fact wearing this very finding's colour.
out=$(GITLINK_ROOT="$pen" GITLINK_RISHI="$pen/no-such-runner" sh "$scan" probe 2>&1 || true)
check "an absent runner refuses"       yes "$(has "$out" 'verdict=no_runner')"
check "and claims no colour at all"    no  "$(has "$out" 'probe_red=')"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
