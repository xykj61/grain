#!/bin/sh
# tools/fixtures/generated_page_freshness_control.sh -- the generated-page pre-commit hook, proven both ways.
#
# A guard that has never refused is a guard nobody has tested, and a guard that fires on every
# commit is one the bench learns to disable. This builds a throwaway repository, arms it with the
# tree's real tools/hooks/pre-commit, and plants a stand-in generator so five cases can be told
# apart in a second rather than in half a minute of real rendering:
#
#   a docs-only commit                                    -> no generator is invoked
#   a witness added, both pages clean and stale           -> BOTH refreshed AND staged into that commit
#   a witness added, a page stale with unstaged edits     -> REFUSED, nothing of the author's swept in
#   a witness added, the pages already fresh              -> commit proceeds, nothing extra staged
#   a docs-only commit beside a stale ledger              -> the ledger rule rests, the headline stays
#   a REDS row booked with the headline behind            -> the headline regenerated AND staged
#   a REDS row booked while the ledger carries edits      -> REFUSED, the author stages it
#   no rishi on disk at all                               -> the hook rests, the commit proceeds
#
# Two pages rather than one, because the tree holds two: README.md and the crushed library index
# docs-geode/libraries/README.md. Both count witnesses, and the roster caught the second one drifting
# on the very lap that added this witness -- so the hook covers the class rather than the first case.
#
# The stand-in generator is honest rather than a trick: the hook's whole contract is "invoke the
# generator, see whether README changed, act on the answer," so what the generator renders is the
# real tool's business and the hook's own logic is what this proves. The last case is the
# depersonalized seed, which carries no rishi and must commit exactly as it always has.
#
# The ledger cases use the REAL writer and the REAL spine scan rather than a stand-in, because the
# writer's arithmetic is the thing under proof there -- what the hook contributes is only WHEN it
# runs, and that is what the three cases tell apart.
#
# EXPECTED: docs_free=yes, clean_staged=yes, dirty_refused=yes, fresh_quiet=yes, ledger_free=yes,
#           ledger_staged=yes, ledger_dirty_refused=yes, no_rishi_free=yes.
#
# Driven by tools/g/generated_page_freshness_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cd "$work"
git init -q
git config user.email fixture@example.invalid
git config user.name Fixture
git config commit.gpgsign false

# The pen mirrors the real tree's rooms, generator rooms included: the hook names its generators
# at `tools/r/` and `tools/g/` since the `20260823.144100` fold, so the stand-ins must stand there
# too or the control proves a shape the hook no longer has.
mkdir -p tools/hooks tools/r tools/g rishi/bin
cp "$root/tools/hooks/pre-commit" tools/hooks/pre-commit
chmod +x tools/hooks/pre-commit
git config core.hooksPath tools/hooks

# The stand-in generator: it counts the witnesses the INDEX holds and splices that number
# between the same markers the real block uses, leaving a mark so a silent hook can be told
# from a resting one.
cat > rishi/bin/rishi <<'GEN'
#!/bin/sh
# Stand-in for `rishi run <generator> write`: it counts the witnesses the INDEX holds and rewrites
# the page that generator owns, leaving a mark so a silent hook can be told from a resting one.
set -eu
generator=$2
: > .generator-ran
count=$(git ls-files 'tools/*_witness.rish' | wc -l | tr -d ' ')
case "$generator" in
  tools/r/readme_metrics.rish) page=README.md ;;
  tools/g/geode_libraries.rish) page=docs-geode/libraries/README.md ;;
  *) exit 1 ;;
esac
printf 'witnesses=%s\n' "$count" > "$page"
GEN
chmod +x rishi/bin/rishi
printf '# generator stand-in, read by the hook only for its presence\n' > tools/r/readme_metrics.rish
printf '# generator stand-in, read by the hook only for its presence\n' > tools/g/geode_libraries.rish

mkdir -p docs-geode/libraries tools/fixtures construction
printf 'witnesses=0\n' > README.md
printf 'witnesses=0\n' > docs-geode/libraries/README.md
printf 'a page\n' > NOTES.md

# The ledger rule runs the tree's own writer and its own spine scan, copied in rather than stubbed.
cp "$root/tools/fixtures/reds_ledger_headline_write.sh" tools/fixtures/reds_ledger_headline_write.sh
cp "$root/tools/fixtures/reds_ledger_monotone_scan.sh" tools/fixtures/reds_ledger_monotone_scan.sh
chmod +x tools/fixtures/reds_ledger_headline_write.sh tools/fixtures/reds_ledger_monotone_scan.sh

# A ledger holding rows 1..21, with a headline deliberately left at 1. Twenty-one rather than a
# handful, so the derived remainder stays a natural number as the real ledger's does.
book_row() {
  printf '**REDS %%%s (`20260825.000000`) -- a planted row %s.** *What went wrong:* a thing. *What caught it:* a guard. *What it taught:* a rule. CLOSED.\n' "$1" "$1" >> construction/REDS.md
}
{
  echo "# REDS -- a planted ledger"
  echo
  echo "**Rows: 1 - in the tree before the ledger: 6 - recovered by opening it: 14 - added under the reds-first law: 1** -- counted from the ledger. Every number from 1 to 1 is used."
  echo
} > construction/REDS.md
n=1
while [ "$n" -le 21 ]; do book_row "$n"; n=$((n + 1)); done
git add -A
git commit -qm "seed the fixture" --no-verify
rm -f .generator-ran

# 1 -- a docs-only commit leaves the generator alone.
printf 'a page, edited\n' > NOTES.md
git add NOTES.md
git commit -qm "docs only"
docs_free=$([ ! -f .generator-ran ] && echo yes || echo no)

# 2 -- a witness arrives with README clean: refreshed and staged into the same commit.
printf '# a witness\n' > tools/first_witness.rish
git add tools/first_witness.rish
git commit -qm "add the first witness" >/dev/null
front=$(git show HEAD:README.md | sed -n 's/^witnesses=//p')
index=$(git show HEAD:docs-geode/libraries/README.md | sed -n 's/^witnesses=//p')
clean_staged=$([ "$front" = 1 ] && [ "$index" = 1 ] && git diff --quiet && echo yes || echo no)
rm -f .generator-ran

# 3 -- a witness arrives while README carries unstaged edits of the author's own: refused.
printf 'witnesses=1\nhand-edited by the author\n' > README.md
printf '# a second witness\n' > tools/second_witness.rish
git add tools/second_witness.rish
code=0
git commit -qm "add the second witness" >/dev/null 2>&1 || code=$?
still_staged=$(git diff --cached --name-only | grep -c 'second_witness' || true)
dirty_refused=$([ "$code" -ne 0 ] && [ "$still_staged" -eq 1 ] && echo yes || echo no)

# 4 -- the same commit, once README is staged as the hook asked: it proceeds, adding nothing.
git add README.md
git commit -qm "add the second witness" >/dev/null
head_count=$(git show HEAD:README.md | sed -n 's/^witnesses=//p')
fresh_quiet=$([ "$head_count" = 2 ] && git diff --quiet && echo yes || echo no)
rm -f .generator-ran

# 6 -- the ledger's headline stands stale and a docs-only commit leaves it exactly there. The
#      ledger rule's trigger is the ledger being staged, so a commit that never touches it rests.
printf 'a page, edited again\n' > NOTES.md
git add NOTES.md
git commit -qm "docs only, beside a stale ledger" >/dev/null
ledger_free=$(git show HEAD:construction/REDS.md | grep -q '^\*\*Rows: 1 ' && echo yes || echo no)

# 7 -- a row is booked and the headline is left behind, which is REDS %127, %141, and %229 exactly.
#      The hook regenerates the headline and stages it into the same commit.
book_row 22
git add construction/REDS.md
git commit -qm "book a row and forget the headline" >/dev/null
booked=$(git show HEAD:construction/REDS.md)
ledger_staged=$(echo "$booked" | grep -q '^\*\*Rows: 22 ' \
  && echo "$booked" | grep -q 'reds-first law: 2\*\*' \
  && echo "$booked" | grep -q 'from 1 to 22 is used' \
  && git diff --quiet && echo yes || echo no)

# 8 -- a row is staged while the ledger carries a further unstaged edit of the author's own. The
#      refreshed page is left in the worktree and the commit is refused, so nothing is swept in.
book_row 23
git add construction/REDS.md
book_row 24
ledger_code=0
git commit -qm "book a row over unstaged edits" >/dev/null 2>&1 || ledger_code=$?
ledger_dirty_refused=$([ "$ledger_code" -ne 0 ] && echo yes || echo no)
git add construction/REDS.md
git commit -qm "book two rows, staged as asked" >/dev/null

# 5 -- no rishi on disk: the hook rests and the commit proceeds, which is the seed's case.
rm -rf rishi
printf '# a third witness\n' > tools/third_witness.rish
git add tools/third_witness.rish
seed_code=0
git commit -qm "add the third witness" >/dev/null 2>&1 || seed_code=$?
no_rishi_free=$([ "$seed_code" -eq 0 ] && [ ! -f .generator-ran ] && echo yes || echo no)

echo "docs_free=$docs_free"
echo "clean_staged=$clean_staged"
echo "dirty_refused=$dirty_refused"
echo "fresh_quiet=$fresh_quiet"
echo "ledger_free=$ledger_free"
echo "ledger_staged=$ledger_staged"
echo "ledger_dirty_refused=$ledger_dirty_refused"
echo "no_rishi_free=$no_rishi_free"

if [ "$docs_free" = yes ] && [ "$clean_staged" = yes ] && [ "$dirty_refused" = yes ] \
  && [ "$fresh_quiet" = yes ] && [ "$ledger_free" = yes ] && [ "$ledger_staged" = yes ] \
  && [ "$ledger_dirty_refused" = yes ] && [ "$no_rishi_free" = yes ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
