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
# An operator that works once and then refuses its own output -- the sharpest divergence.
cat > "$ops/sour.sh" <<'S'
#!/bin/sh
if grep -q SOURED rooms/two.md; then echo "refused: I will not read my own work" >&2; exit 1; fi
echo SOURED >> rooms/two.md
S
chmod +x "$ops/settle.sh" "$ops/append.sh" "$ops/toggle.sh" "$ops/refuser.sh" "$ops/sour.sh"

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
check "refusing its own output is named"  yes "$(has "$out" 'verdict=refused_on_second')"

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
echo "coverage: mode divergence, the perturb pair, a no-op perturbation, and both refusal shapes were each exercised"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
