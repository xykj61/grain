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
# Prints `pass=N fail=N`. Bounded: 34 cases, one pen, two subject repositories.
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

# A THIRD SUBJECT, WHICH IGNORES ITS OWN ROOT. This tree's `.gitignore` denies the whole repository
# root with `/*` and allows the project's directories back one at a time, because the checkout sits
# inside a sandboxed home holding the editor, credentials and personal files. The shape is copied
# here rather than described, since the fault it produces is invisible to any pen that has no
# `.gitignore`: `git add -A` stages nothing ignored, so `git write-tree` -- the prover's whole
# comparison -- cannot see a write at the root at all.
ignoring="$pen/ignoring"
mkdir -p "$ignoring/rooms"
(
  cd "$ignoring"
  git init -q .
  git config user.email pen@example.invalid
  git config user.name "Pen Hand"
  git config commit.gpgsign false
  printf '/*\n!/.gitignore\n!/rooms\n!/tools\n' > .gitignore
  printf 'settled already\n' > rooms/quiet.md
  git add -A
  git commit -qm "pen: a tree that ignores its own root"
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
# AN OPERATOR WHOSE EVERY WRITE LANDS AT THE ROOT. It appends on every run, so it diverges wherever
# the comparison can see it -- and where the root is ignored the same operator wrote its whole
# output somewhere `write-tree` never looks. One operator, two repositories, and only the
# `.gitignore` between them: that pairing is what makes the reading about the instrument rather
# than about the tool.
cat > "$ops/scratch_appender.sh" <<'N'
#!/bin/sh
printf 'x\n' >> notes.txt
N
chmod +x "$ops/settle.sh" "$ops/append.sh" "$ops/toggle.sh" "$ops/refuser.sh" "$ops/sour.sh" "$ops/spoil.sh" "$ops/scratch_appender.sh"

run() { ( cd "$subject" && sh "$prove" "$@" 2>&1 ) || true; }
run_settled() { ( cd "$settled" && sh "$prove" "$@" 2>&1 ) || true; }
run_ignoring() { ( cd "$ignoring" && sh "$prove" "$@" 2>&1 ) || true; }

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

# THE LANGUAGE LEG, and it is the same sentence the `$0` leg above was written for, one language
# over. Every stand-in this pen plants is a shell script, so the prover's own `sh <tool>` invocation
# was never pressed -- and this tree writes 2,407 tracked `.rish` sources against 913 `.sh`, with a
# standing law molting an operational shell script to Rishi on substantial touch. Handed a Rishi
# operator the elder prover answered `refused`, over a shell syntax error, in a verdict that reads
# as the TOOL refusing. A stand-in population narrower than the answerers is the fault %668 booked;
# a stand-in population narrower in LANGUAGE is that fault wearing a second face.
cat > "$subject/tools/settler.rish" <<'IN'
let body = read-file "rooms/two.md"
if body contains "SETTLED" then exit exit-ok
let nl = (run ["printf" "\n"]).out
write-file "rooms/two.md" "${body}SETTLED${nl}"
IN
( cd "$subject" && git add -A && git commit -qm "pen: a Rishi operator" ) >/dev/null 2>&1

out=$(run "$subject/tools/settler.rish")
check "a Rishi operator converges"        yes "$(has "$out" 'verdict=converges')"
check "rather than reading as refused"    no  "$(has "$out" 'verdict=refused')"
check "and the subject tree is untouched" no  "$(has "$(cat "$subject/rooms/two.md")" 'SETTLED')"

# BOTH DIRECTIONS. The elder prover is this one with the Rishi branch of `run_subject` deleted -- a
# single line -- so what the pair measures is the dispatch and nothing beside it.
sed '/\*\.rish) ( cd "\$pen" \&\& "\$RISHI_BIN"/d' "$prove" > "$pen/shellonly_prove.sh"
out=$( ( cd "$subject" && sh "$pen/shellonly_prove.sh" "$subject/tools/settler.rish" 2>&1 ) || true)
check "the shell-only prover cannot"      no  "$(has "$out" 'verdict=converges')"

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

# THE IGNORED-PATH PAIR, and it is the same braid one layer down. `git write-tree` is the whole
# comparison, and it stages nothing `.gitignore` denies -- so a write at an ignored path moves the
# disk and moves no hash. Both directions, one operator, and only the `.gitignore` between them.
out=$(run "$ops/scratch_appender.sh")
check "a root write git can see"          yes "$(has "$out" 'verdict=diverges')"
out=$(run_ignoring "$ops/scratch_appender.sh")
check "the same write, root ignored"      yes "$(has "$out" 'verdict=unseen')"
check "rather than read as inert"         no  "$(has "$out" 'verdict=inert')"
check "and the unseen path is named"      yes "$(has "$out" 'notes.txt')"

# THE PERTURBATION'S HALF. A sample written to an ignored path landed on disk and reached no
# subject, and the elder reading called that "the sample never landed" -- a true-sounding sentence
# about a file sitting right there. Met by a hand before it was met here: proving the front door's
# metrics splice took two tries, the first writing its block file to the pen root.
out=$(run_ignoring --perturb 'printf x > side.txt' "$ops/settle.sh")
check "an ignored perturbation is named"  yes "$(has "$out" 'verdict=perturb_unseen')"
check "rather than called never-landed"   no  "$(has "$out" 'verdict=perturb_inert')"
# THE INDENTED FORM, never the bare name: `perturb=printf x > side.txt` recites the command, so a
# check for the bare word passes whatever verdict fired. Caught by running this control against a
# prover with the repair removed and watching this one leg stay green while its four siblings fell.
check "and the unseen path is listed"     yes "$(has "$out" '
  side.txt')"
out=$(run_ignoring --perturb 'printf "a DASH again\n" >> rooms/quiet.md' "$ops/settle.sh")
check "a visible perturbation still works" yes "$(has "$out" 'verdict=converges')"

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
echo "coverage: mode divergence, the perturb pair, a no-op perturbation, an ignored-root write and an ignored-root perturbation shown from both sides, both refusal shapes, an in-tree operator rooted at \$0, a Rishi operator against a shell-only prover, and the elder prover's own leak were each exercised"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
