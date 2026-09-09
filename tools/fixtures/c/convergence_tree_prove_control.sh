#!/bin/sh
# convergence_tree_prove_control.sh -- the pen-tree prover proven on operators built to pass and to fail.
#
# The subject here is a REPOSITORY rather than a file, so every case builds a real git repository in
# a throwaway pen and hands the prover a whole-tree operator to run inside it. A prover that only
# ever meets converging operators has proven nothing about its own teeth, so this pen builds two
# kinds of divergence on purpose and requires the prover to catch both.
#
#   sh tools/fixtures/c/convergence_tree_prove_control.sh
#
# TWO LEGS PROVE THE TWO DESIGN CHOICES THAT ARE ACTUALLY NEW, rather than only the verdicts:
#
#   the mode leg     -- an operator that toggles a file's exec bit changes no LINE, so a prover
#                       comparing diffs would call it converged. This one compares `git write-tree`,
#                       which is a hash over every path, its bytes AND its mode, so the toggle reads
#                       `diverges`. `.claude/rules/exec-bit.md` is thirty-nine exec bits' worth of
#                       argument that a mode is content.
#   the perturb legs -- the same operator reads `inert` on a settled tree and `converges` once
#                       `--perturb` gives it work. Without that pair, `--perturb` could be doing
#                       nothing at all and every reading would look the same. A third leg plants a
#                       perturbation that exits zero and changes nothing, which must read
#                       `perturb_inert` rather than blame the tool for a sample that never landed.
#
# Prints `pass=N fail=N`. Bounded: 19 cases, one pen, two subject repositories.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
prove="$root/tools/c/convergence_tree_prove.sh"
pen=${TMPDIR:-/tmp}/conv-tree-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

# THE SUBJECT REPOSITORY. Signing is off in this pen alone, never in the tree -- a throwaway
# repository built to be deleted is not this tree's history, and the same spelling stands in
# `reds_spine_derive_control.sh` and `exec_bit_control.sh` for the same reason.
subject="$pen/subject"
mkdir -p "$subject/rooms"
(
  cd "$subject"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name "Pen Hand"
  git config commit.gpgsign false
  printf 'a DASH here\n' > rooms/one.md
  printf 'and a DASH there\n' > rooms/two.md
  printf 'settled already\n' > rooms/quiet.md
  # OPERATORS THAT LIVE IN THE TREE THEY EDIT, which is where every real one lives. The five planted
  # below in `$ops` work on relative paths in whatever directory they are handed; not one resolves
  # its own root from `$0`, and 100 tracked tools in this tree do. That gap is why the prover ran
  # its subject against the live tree for a day with this control fully green
  # (`20260909.170804`): a stand-in that speaks a simpler contract than the answerer proves the
  # asker against a world that does not exist.
  mkdir -p tools
  cat > tools/rooter.sh <<'IN'
#!/bin/sh
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
sed 's/DASH/--/g' rooms/one.md > rooms/one.tmp && cat rooms/one.tmp > rooms/one.md && rm -f rooms/one.tmp
IN
  cat > tools/oncewriter.sh <<'IN'
#!/bin/sh
root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$root"
[ -e rooms/sealed.md ] && { echo "refused: sealed_exists -- a shelf is immutable once written" >&2; exit 2; }
printf 'sealed\n' > rooms/sealed.md
IN
  chmod +x tools/rooter.sh tools/oncewriter.sh
  git add -A
  git commit -qm "pen: the subject tree"
) >/dev/null 2>&1

# A SECOND SUBJECT, COMMITTED ALREADY SETTLED. The pen checkout is made from HEAD on every run, so
# a run cannot leave the next one a settled tree -- which is the whole reason `--perturb` exists and
# the reason the inert leg needs a repository whose HEAD holds no work.
settled="$pen/settled"
mkdir -p "$settled/rooms"
(
  cd "$settled"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name "Pen Hand"
  git config commit.gpgsign false
  printf 'settled already\n' > rooms/quiet.md
  git add -A
  git commit -qm "pen: a tree with nothing left to settle"
) >/dev/null 2>&1

ops="$pen/ops"; mkdir -p "$ops"

# A CONVERGING operator: it walks the tree and settles a marker whose settled form matches nothing.
cat > "$ops/settle.sh" <<'G'
#!/bin/sh
for f in rooms/*.md; do
  sed 's/DASH/--/g' "$f" > "$f.tmp" && cat "$f.tmp" > "$f" && rm -f "$f.tmp"
done
G
# A DIVERGING operator: every run appends, so the second run never equals the first.
cat > "$ops/append.sh" <<'B'
#!/bin/sh
echo "another line" >> rooms/one.md
B
# A MODE-DIVERGING operator: it changes no line at all, only a bit git tracks.
cat > "$ops/toggle.sh" <<'M'
#!/bin/sh
if [ -x rooms/one.md ]; then chmod -x rooms/one.md; else chmod +x rooms/one.md; fi
M
# An operator that REFUSES outright.
cat > "$ops/refuser.sh" <<'R'
#!/bin/sh
echo "refused: on purpose" >&2
exit 2
R
# An operator that works once and then refuses its own output WITHOUT rewriting it. This was
# planted as `the sharpest divergence` and it is nothing of the kind: the tree it leaves after the
# refusal is the tree its first run left, which is what accrete-never-break asks of every write-once
# writer here. It reads `write_once` from `20260909.170804`, and the case below says so.
cat > "$ops/sour.sh" <<'S'
#!/bin/sh
if grep -q SOURED rooms/two.md; then echo "refused: I will not read my own work" >&2; exit 1; fi
echo SOURED >> rooms/two.md
S
# THE ACTUAL sharpest divergence, which nothing here exercised until now: it changes the tree AGAIN
# and then refuses. The exit code it shows is the one `sour.sh` shows, so only the tree tells them
# apart.
cat > "$ops/spoil.sh" <<'S'
#!/bin/sh
printf 'spoil\n' >> rooms/two.md
n=$(grep -c spoil rooms/two.md)
if [ "$n" -gt 1 ]; then echo "refused: I spoiled my own work and wrote anyway" >&2; exit 1; fi
S
chmod +x "$ops/settle.sh" "$ops/append.sh" "$ops/toggle.sh" "$ops/refuser.sh" "$ops/sour.sh" "$ops/spoil.sh"

run() { ( cd "$subject" && sh "$prove" "$@" 2>&1 ) || true; }
run_settled() { ( cd "$settled" && sh "$prove" "$@" 2>&1 ) || true; }

out=$(run "$ops/settle.sh")
check "a converging operator converges"   yes "$(has "$out" 'verdict=converges')"
check "and it names the tool"             yes "$(has "$out" "tool=$ops/settle.sh")"

out=$(run "$ops/append.sh")
check "an appending operator is caught"   yes "$(has "$out" 'verdict=diverges')"
check "and the changed path is shown"     yes "$(has "$out" 'rooms/one.md')"

# THE MODE LEG. No line moves here, so this is the case a line-diff prover would pass.
out=$(run "$ops/toggle.sh")
check "a mode-only toggle is caught"      yes "$(has "$out" 'verdict=diverges')"
check "rather than read as converged"     no  "$(has "$out" 'verdict=converges')"

out=$(run "$ops/refuser.sh")
check "a refusing operator is no pass"    yes "$(has "$out" 'verdict=refused')"

out=$(run "$ops/sour.sh")
check "refusing and changing nothing"     yes "$(has "$out" 'verdict=write_once')"
check "is not called a divergence"        no  "$(has "$out" 'verdict=refused_on_second')"
out=$(run "$ops/spoil.sh")
check "writing again AND refusing is"     yes "$(has "$out" 'verdict=refused_on_second')"
check "told apart from write_once"        no  "$(has "$out" 'verdict=write_once')"

# THE IN-TREE OPERATOR, the class every real tool belongs to and the one this control lacked.
out=$(run "$subject/tools/rooter.sh")
check "an operator rooted at \$0 converges" yes "$(has "$out" 'verdict=converges')"
check "rather than reading as inert"      no  "$(has "$out" 'verdict=inert')"
check "and the subject file is untouched" yes "$(has "$(cat "$subject/rooms/one.md")" 'a DASH here')"

out=$(run "$subject/tools/oncewriter.sh")
check "an in-tree write-once writer"      yes "$(has "$out" 'verdict=write_once')"
check "and it sealed nothing out here"    no  "$(has "$(ls "$subject/rooms")" 'sealed.md')"

# BOTH DIRECTIONS, and this leg is the whole reason the repair exists. The elder prover is this one
# with the in-pen invocation removed -- a single assignment -- so the difference measured is the
# repair itself and nothing beside it. Planted, read, and then the damage undone.
sed '/RUN_TOOL="\$pen\/\$TOOL_REL"/d' "$prove" > "$pen/elder_prove.sh"
out=$( ( cd "$subject" && sh "$pen/elder_prove.sh" "$subject/tools/rooter.sh" 2>&1 ) || true)
check "the elder prover read inert"       yes "$(has "$out" 'verdict=inert')"
check "while editing the subject tree"    yes "$(has "$(cat "$subject/rooms/one.md")" 'a -- here')"
( cd "$subject" && git checkout -q -- rooms/one.md )
check "and the damage is undone"          yes "$(has "$(cat "$subject/rooms/one.md")" 'a DASH here')"

# THE PERTURB PAIR. One operator, one repository, and only the sample between them differs -- which
# is the only way to show `--perturb` is doing the work rather than the operator or the tree.
out=$(run_settled "$ops/settle.sh")
check "a settled tree reads inert"        yes "$(has "$out" 'verdict=inert')"
check "and inert is not a pass"           no  "$(has "$out" 'verdict=converges')"
out=$(run_settled --perturb 'printf "a DASH again\n" >> rooms/quiet.md' "$ops/settle.sh")
check "a perturbation gives it work"      yes "$(has "$out" 'verdict=converges')"
check "and the perturbation is recited"   yes "$(has "$out" 'perturb=')"

out=$(run --perturb 'exit 3' "$ops/settle.sh")
check "a failing perturbation refuses"    yes "$(has "$out" 'verdict=refused')"

# A PERTURBATION MAY EXIT ZERO AND STILL DO NOTHING, which is how a broken sample passes for a true
# reading. The two are told apart by asking the TREE rather than the exit status.
out=$(run_settled --perturb 'sed -n 1p rooms/quiet.md >/dev/null' "$ops/settle.sh")
check "a no-op perturbation is named"     yes "$(has "$out" 'verdict=perturb_inert')"
check "rather than blamed on the tool"    no  "$(has "$out" 'verdict=inert')"

# THE TREE UNDER TEST IS NEVER TOUCHED -- eleven runs above, and its own files still read as committed.
check "the subject tree is untouched"     yes "$(has "$(cat "$subject/rooms/one.md")" 'a DASH here')"
check "and no pen worktree is left"       ""  "$( ( cd "$subject" && git worktree list --porcelain | sed -n 's/^worktree //p' | grep -v "^$subject$" ) || true)"

if ( cd "$subject" && sh "$prove" "$ops/nosuch.sh" >/dev/null 2>&1 ); then
  check "a missing tool refuses" refused accepted
else
  check "a missing tool refuses" refused refused
fi
if ( cd "$pen" && sh "$prove" "$ops/settle.sh" >/dev/null 2>&1 ); then
  check "outside a repository refuses" refused accepted
else
  check "outside a repository refuses" refused refused
fi

# SAID OUT LOUD, because `check` prints only on failure: a witness asserting on a failure message
# would be asserting on text that appears only when this control is broken.
echo "coverage: mode divergence, the perturb pair, a no-op perturbation, both refusal shapes, an in-tree operator rooted at \$0, and the elder prover's own leak were each exercised"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
