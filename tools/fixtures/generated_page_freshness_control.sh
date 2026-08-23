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
# EXPECTED: docs_free=yes, clean_staged=yes, dirty_refused=yes, fresh_quiet=yes, no_rishi_free=yes.
#
# Driven by tools/generated_page_freshness_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cd "$work"
git init -q
git config user.email fixture@example.invalid
git config user.name Fixture
git config commit.gpgsign false

mkdir -p tools/hooks rishi/bin
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
  tools/readme_metrics.rish) page=README.md ;;
  tools/geode_libraries.rish) page=docs-geode/libraries/README.md ;;
  *) exit 1 ;;
esac
printf 'witnesses=%s\n' "$count" > "$page"
GEN
chmod +x rishi/bin/rishi
printf '# generator stand-in, read by the hook only for its presence\n' > tools/readme_metrics.rish
printf '# generator stand-in, read by the hook only for its presence\n' > tools/geode_libraries.rish

mkdir -p docs-geode/libraries
printf 'witnesses=0\n' > README.md
printf 'witnesses=0\n' > docs-geode/libraries/README.md
printf 'a page\n' > NOTES.md
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
echo "no_rishi_free=$no_rishi_free"

if [ "$docs_free" = yes ] && [ "$clean_staged" = yes ] && [ "$dirty_refused" = yes ] \
  && [ "$fresh_quiet" = yes ] && [ "$no_rishi_free" = yes ]; then
  echo "control_verdict=ok"
else
  echo "control_verdict=wrong"
  exit 1
fi
