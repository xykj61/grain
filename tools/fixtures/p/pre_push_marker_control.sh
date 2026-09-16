#!/bin/sh
# tools/fixtures/p/pre_push_marker_control.sh -- prove the pre-push conflict-marker wall on real
# git repositories in a throwaway pen, refusals and welcomes both.
#
# WHY BOTH DIRECTIONS. A refusal proven only in the passing direction cannot be told from a bypass:
# a hook that always exits 0 passes every clean case a control thinks to write. So every refusal
# here is planted and then lifted, and each welcome is asserted as hard as each refusal.
#
# WHY A REAL `git push` RATHER THAN A CALL TO THE SCRIPT. The wall's whole claim is that git reaches
# it -- through `core.hooksPath`, the way `tools/i/install_hooks.rish` arms every clone. A control
# that invoked the file directly would prove the file and leave the arming untested, which is the
# half that actually failed the fleet.
#
# WHY A REAL REBASE. The founding case is not that a marker exists; it is that `git rebase
# --continue` COMMITS WITHOUT RUNNING `pre-commit`, so rule nine of that hook -- which is correct,
# armed, and reads the same scan -- never sees the bytes the rebase wrote. Case 12 below does the
# whole thing on metal: a pre-commit hook that records every entry, three ordinary commits, one
# conflicted rebase resolved with the marker left in, and then the counts read back.
#
#   sh tools/fixtures/p/pre_push_marker_control.sh
#
# Exit 0 when every case behaves, 1 when one does not. No network, no key, no funds, no device.
set -eu

here="$(cd "$(dirname "$0")" && pwd)"
root="$(cd "$here/../../.." && pwd)"
HOOK="$root/tools/hooks/pre-push"
MARKER="$root/tools/fixtures/c/conflict_marker_scan.sh"
SCAN="$root/tools/fixtures/r/reds_spine_derive_scan.sh"
FILES="$root/tools/fixtures/r/reds_spine_files.sh"

for f in "$HOOK" "$MARKER" "$SCAN" "$FILES"; do
  [ -f "$f" ] || { echo "FAIL: $f is missing -- nothing to prove"; exit 1; }
done

pen="$(mktemp -d)"
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0
ok() { echo "PASS: $1"; pass=$((pass + 1)); }
no() { echo "FAIL: $1"; fail=$((fail + 1)); }

# The three labelled markers, built rather than written, so this control does not accuse itself the
# way the scan's own excluded roster exists to prevent.
L='<<<<<<'; L="$L< HEAD"
M='======'; M="$M="
R='>>>>>>'; R="$R> 0123abc (a peer's commit)"

marked_body() {
  printf '%s\n' "a line the file always had"
  printf '%s\n' "$L"
  printf '%s\n' "ours"
  printf '%s\n' "$M"
  printf '%s\n' "theirs"
  printf '%s\n' "$R"
}

# ---- the pen: a bare anointed remote, and a working clone armed exactly as a ship is ----
mkdir -p "$pen/up.git"
git init --quiet --bare -b main "$pen/up.git"

work="$pen/work"
mkdir -p "$work/construction" "$work/tools/fixtures/r" "$work/tools/fixtures/c" "$work/tools/hooks" "$work/notes"
cp "$SCAN" "$FILES" "$work/tools/fixtures/r/"
cp "$MARKER" "$work/tools/fixtures/c/"
cp "$HOOK" "$work/tools/hooks/pre-push"
chmod +x "$work/tools/hooks/pre-push"

# A ledger the spine rule reads clean, so rule one never colours a rule-two case.
{
  echo "# REDS -- the pen's ledger"
  echo
  printf '**REDS %%10 (`20260101.010101`) -- a planted row.** **OPEN**\n\n'
} > "$work/construction/REDS.md"

echo "a file with nothing wrong in it" > "$work/notes/plain.txt"

cd "$work"
git init --quiet -b main .
git config user.email pen@example.invalid
git config user.name "Pen Hand"
git config commit.gpgsign false
git config core.hooksPath tools/hooks
git remote add xy "$pen/up.git"
git add -A
git commit --quiet -m "pen: a clean tree"

remote_head() { git --git-dir="$pen/up.git" rev-parse --verify --quiet refs/heads/main || echo none; }

# Case 1 -- a clean tree publishes. This is also the first push to a ref the remote has never seen,
# so it exercises the unknown-range path in the welcoming direction.
if git push --quiet xy main 2>/dev/null; then
  ok "a clean tree publishes, first push and all"
else
  no "a clean tree was refused"
fi

before="$(remote_head)"

# Case 2 -- the plant mutates: the scan itself sees the marker before the hook is asked.
marked_body > notes/plain.txt
git add -A
git commit --quiet --no-verify -m "pen: plant a marker in a file the push carries"
set +e
list_out="$(sh tools/fixtures/c/conflict_marker_scan.sh list 2>&1)"
list_code=$?
set -e
if [ "$list_code" -eq 0 ] && echo "$list_out" | grep -q '^notes/plain.txt:'; then
  ok "the plant mutates -- the scan lists notes/plain.txt by name"
else
  no "the plant did not mutate the scan (exit $list_code)"
fi

# Case 3 -- and the wall refuses the push that would publish it.
set +e
git push --quiet xy main 2>/dev/null
push_code=$?
set -e
if [ "$push_code" -ne 0 ] && [ "$(remote_head)" = "$before" ]; then
  ok "a marked path this push carries is refused, and the remote is untouched"
else
  no "a marked path reached the remote (push exit $push_code)"
fi

# Case 4 -- the refusal names the file, the line, and why pre-commit never saw it.
set +e
refusal="$(git push xy main 2>&1)"
set -e
if echo "$refusal" | grep -q 'notes/plain.txt:2' \
   && echo "$refusal" | grep -q 'rebase commits without running pre-commit'; then
  ok "the refusal names the file and line, and names the bypass that made it"
else
  no "the refusal named neither the hit nor the bypass"
fi

# Case 5 -- lift the plant and the same push goes through. Both sides of one gate.
echo "the conflict, resolved by a hand" > notes/plain.txt
git add -A
git commit --quiet -m "pen: resolve the conflict"
if git push --quiet xy main 2>/dev/null && [ "$(remote_head)" != "$before" ]; then
  ok "the resolved file publishes -- the gate lifts"
else
  no "the resolved file was still refused"
fi

# Case 6 -- a marker OUTSIDE the push's paths is reported and never refused. A second clone with no
# hooks arms nothing, so it can publish what this wall exists to prevent; the wall then has to
# welcome a later push that does not touch that file, because refusing it would red on what this
# lap cannot repair.
git clone --quiet "$pen/up.git" "$pen/rogue"
(
  cd "$pen/rogue" || { echo "refused: pen absent -- $0 did not enter its pen" >&2; exit 1; }
  git config user.email rogue@example.invalid
  git config user.name "Rogue Hand"
  git config commit.gpgsign false
  {
    printf '%s\n' "a line the file always had"
    printf '%s\n' "<<<<<<< HEAD"
    printf '%s\n' "ours"
    printf '%s\n' "======="
    printf '%s\n' "theirs"
    printf '%s\n' ">>>>>>> 0123abc (a peer's commit)"
  } > notes/theirs.txt
  git add -A
  git commit --quiet -m "rogue: publish a marker the wall would have refused"
  git push --quiet origin main 2>/dev/null
)
git fetch --quiet xy
git reset --quiet --hard xy/main
echo "a lap touching a different file entirely" > notes/mine.txt
git add -A
git commit --quiet -m "pen: a later lap over a peer's marker"
set +e
out6="$(git push xy main 2>&1)"
push_code=$?
set -e
if [ "$push_code" -eq 0 ] && echo "$out6" | grep -q 'outside this push.s paths'; then
  ok "a marker outside the push's paths is reported by name and welcomed"
else
  no "the wall mishandled a marker outside the push's paths (exit $push_code)"
fi

# Case 7 -- the wide path answers the same way. Forcing the bound to zero sends rule two over the
# whole census instead of the push's own paths; a marked path in the push must still refuse, or the
# two code paths disagree about one tree.
git rm --quiet notes/theirs.txt
marked_body > notes/plain.txt
git add -A
git commit --quiet --no-verify -m "pen: plant again, for the wide path"
before="$(remote_head)"
set +e
PRE_PUSH_MAX_RANGE_PATHS=0 git push --quiet xy main 2>/dev/null
push_code=$?
set -e
if [ "$push_code" -ne 0 ] && [ "$(remote_head)" = "$before" ]; then
  ok "the wide path refuses the same marked push -- the two readings agree"
else
  no "the wide path let a marked push through (exit $push_code)"
fi
git reset --quiet --hard HEAD~1

# Case 8 -- a delete publishes nothing, so rule two is never asked. Proven by taking the scan away:
# if the publishes check were decorative, this push would refuse.
# The peer's marker from case 6 is cleared first, so what follows reads rule two rather than it.
git rm --quiet notes/theirs.txt
git add -A
git commit --quiet -m "pen: clear the peer's marked file"
git push --quiet xy main 2>/dev/null
git push --quiet xy main:refs/heads/scratch 2>/dev/null
mv tools/fixtures/c/conflict_marker_scan.sh "$pen/marker.hidden"
if git push --quiet xy :refs/heads/scratch 2>/dev/null; then
  ok "a delete-only push passes without asking the marker scan"
else
  no "a delete-only push was refused"
fi

# Case 9 -- and the same missing scan REFUSES a push that publishes bytes.
before="$(remote_head)"
echo "a lap made while the instrument is absent" > notes/later.txt
git add -A
git commit --quiet --no-verify -m "pen: a lap with the marker instrument absent"
set +e
out9="$(git push xy main 2>&1)"
push_code=$?
set -e
if [ "$push_code" -ne 0 ] && [ "$(remote_head)" = "$before" ] && echo "$out9" | grep -q 'is missing'; then
  ok "a missing marker scan refuses a publishing push, naming what is absent"
else
  no "a missing marker scan let a push through (exit $push_code)"
fi

# Case 10 -- an instrument that REFUSES is not an instrument that agrees. Exit 2 is a refusal.
cat > tools/fixtures/c/conflict_marker_scan.sh <<'STUB'
#!/bin/sh
echo "verdict=instrument_refusal"
exit 2
STUB
set +e
out10="$(git push xy main 2>&1)"
push_code=$?
set -e
if [ "$push_code" -ne 0 ] && echo "$out10" | grep -q 'exit 2'; then
  ok "a marker scan that exits 2 refuses the push and says the reading refused"
else
  no "a scan exiting 2 was read as a clean tree (exit $push_code)"
fi

# Case 11 -- restore the real scan and the same commit publishes. The exit-2 refusal lifts.
cp "$pen/marker.hidden" tools/fixtures/c/conflict_marker_scan.sh
if git push --quiet xy main 2>/dev/null; then
  ok "the restored scan lets the same commit publish -- the exit-2 gate lifts"
else
  no "the restored scan still refused"
fi

# Case 12 -- THE FOUNDING CASE, end to end on metal. A rebase commits without running pre-commit,
# so the marker lands; the push is where it is caught.
cat > tools/hooks/pre-commit <<'PC'
#!/bin/sh
echo ran >> "$PEN_PRECOMMIT_LOG"
exit 0
PC
chmod +x tools/hooks/pre-commit
PEN_PRECOMMIT_LOG="$pen/precommit.log"
export PEN_PRECOMMIT_LOG
: > "$PEN_PRECOMMIT_LOG"

echo "base" > notes/rebased.txt
git add -A
git commit --quiet -m "pen: a base for the rebase"
git checkout --quiet -b side
echo "side" > notes/rebased.txt
git commit --quiet -am "pen: the side edit"
git checkout --quiet main
echo "main" > notes/rebased.txt
git commit --quiet -am "pen: the main edit"
commits_before=$(grep -c . "$PEN_PRECOMMIT_LOG" || true)

git checkout --quiet side
set +e
git rebase main >/dev/null 2>&1
set -e
markers_in_worktree=$(grep -c '^<<<<<<< ' notes/rebased.txt || true)
git add notes/rebased.txt
set +e
GIT_EDITOR=true git rebase --continue >/dev/null 2>&1
rebase_code=$?
set -e
commits_after=$(grep -c . "$PEN_PRECOMMIT_LOG" || true)
committed_markers=$(git show HEAD:notes/rebased.txt | grep -c '^<<<<<<< ' || true)

if [ "$rebase_code" -eq 0 ] && [ "$markers_in_worktree" -eq 1 ] \
   && [ "$commits_after" -eq "$commits_before" ] && [ "$committed_markers" -eq 1 ]; then
  ok "a rebase commits a conflict marker without running pre-commit -- the bypass, on metal"
else
  no "the rebase bypass did not reproduce (rebase $rebase_code, pre-commit $commits_before to $commits_after, committed $committed_markers)"
fi

# Case 13 -- and the push is where it is caught. A first push of a brand-new ref, so this also
# proves the unknown-range path refuses rather than shrugging.
set +e
out13="$(git push xy side:refs/heads/side 2>&1)"
push_code=$?
set -e
side_head=$(git --git-dir="$pen/up.git" rev-parse --verify --quiet refs/heads/side || echo none)
if [ "$push_code" -ne 0 ] && [ "$side_head" = none ]; then
  ok "the rebase's marker is refused at the push, on a ref the remote has never seen"
else
  no "the rebase's marker reached the remote (exit $push_code, remote side $side_head)"
fi

# Case 14 -- resolve it and the same branch publishes.
echo "resolved by a hand" > notes/rebased.txt
git add -A
git commit --quiet -m "pen: resolve the rebased file"
if git push --quiet xy side:refs/heads/side 2>/dev/null; then
  ok "the resolved rebase publishes -- the gate lifts on the founding case too"
else
  no "the resolved rebase was still refused"
fi

echo
echo "cases_ok=$pass cases_red=$fail"
if [ "$fail" -ne 0 ]; then echo "control_verdict=red"; exit 1; fi
echo "control_verdict=ok"
