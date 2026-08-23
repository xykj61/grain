#!/bin/sh
# tools/fixtures/tool_path_repoint_control.sh -- the tools repointer proven on a tree with a
# known answer.
#
# WHY. tools/fixtures/tool_path_repoint_scan.sh EDITS FILES, roughly two and a half thousand of
# them in one pass. Its whole safety rests on four rules, and a rule that has never been tested is
# a rule nobody has kept:
#
#   1. a file whose own basename carries a one-clock stamp is dated testimony and is never written
#      to -- unless it lives in a room named living, where a standing guard requires its links to
#      resolve
#   2. only TRACKED files are read, because this tree keeps agent transcripts inside itself
#   3. `tool_path_*` is the instrument and keeps its deliberately stale citations
#   4. a leading segment is cut only behind a `$`, so a path in some other tree is left alone
#
# THE CASES, each with its right answer known before the tool runs:
#
#   living.md                      cites a flat path whose file folded    -> repointed
#   20260102-000000_testimony.md   cites the very same flat path          -> untouched
#   foundations/20260104-000000_x.md  same, in a living-named room        -> repointed
#   already.md                     cites the folded path directly         -> untouched
#   elsewhere.md                   cites a path that never folded         -> untouched
#   untracked.md                   tracked by nobody                      -> untouched
#   tool_path_fixture.md           the instrument's own name              -> untouched
#   foreign.md                     cites otherproject/tools/<same base>   -> untouched
#   varprefix.md                   cites $ROOT/tools/<same base>          -> repointed
#
# EXPECTED: every reading 1, idempotent=yes, verdict=ok
#
# Driven by tools/t/tool_path_repoint_witness.rish. Run from the repository root.

set -eu

root="$(pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

cd "$work"
git init -q .
git config user.email fixture@example.invalid
git config user.name Fixture
git config commit.gpgsign false

# The folded room, as the fold leaves it: one file in its letter room, one that never moved.
mkdir -p tools/m tools/fixtures foundations
echo folded > tools/m/moved_witness.rish
echo standing > tools/fixtures/stayed_scan.sh

printf 'run tools/moved_witness.rish for the proof\n' > living.md
printf 'run tools/moved_witness.rish for the proof\n' > 20260102-000000_testimony.md
printf 'run tools/moved_witness.rish for the proof\n' > foundations/20260104-000000_a-living-foundation.md
printf 'run tools/m/moved_witness.rish already\n' > already.md
printf 'run tools/fixtures/stayed_scan.sh which never moved\n' > elsewhere.md
printf 'run tools/moved_witness.rish from a file nobody tracks\n' > untracked.md
printf 'run tools/moved_witness.rish as the instruments own stale citation\n' > tool_path_fixture.md
printf 'run otherproject/tools/moved_witness.rish in a tree that is not ours\n' > foreign.md
printf 'run $ROOT/tools/moved_witness.rish through a variable\n' > varprefix.md

git add -A -- . ':!untracked.md'
git commit -qm "seed the fixture" --no-verify

sh "$root/tools/fixtures/tool_path_repoint_scan.sh" apply > /dev/null 2>&1 || true

reading() { if grep -q "$2" "$1"; then echo 1; else echo 0; fi; }

echo "repointed_living=$(reading living.md '^run tools/m/moved_witness.rish for the proof$')"
echo "untouched_testimony=$(reading 20260102-000000_testimony.md '^run tools/moved_witness.rish for the proof$')"
echo "repointed_living_room=$(reading foundations/20260104-000000_a-living-foundation.md '^run tools/m/moved_witness.rish for the proof$')"
echo "untouched_already=$(reading already.md '^run tools/m/moved_witness.rish already$')"
echo "untouched_elsewhere=$(reading elsewhere.md '^run tools/fixtures/stayed_scan.sh which never moved$')"
echo "untouched_untracked=$(reading untracked.md '^run tools/moved_witness.rish from a file nobody tracks$')"
echo "untouched_instrument=$(reading tool_path_fixture.md '^run tools/moved_witness.rish as the instruments own stale citation$')"
echo "untouched_foreign=$(reading foreign.md '^run otherproject/tools/moved_witness.rish in a tree that is not ours$')"
echo "repointed_varprefix=$(reading varprefix.md 'tools/m/moved_witness.rish through a variable$')"

# Idempotence: a second apply must change nothing at all.
before=$(cat living.md 20260102-000000_testimony.md foundations/20260104-000000_a-living-foundation.md already.md elsewhere.md untracked.md tool_path_fixture.md foreign.md varprefix.md | cksum)
sh "$root/tools/fixtures/tool_path_repoint_scan.sh" apply > /dev/null 2>&1 || true
after=$(cat living.md 20260102-000000_testimony.md foundations/20260104-000000_a-living-foundation.md already.md elsewhere.md untracked.md tool_path_fixture.md foreign.md varprefix.md | cksum)
if [ "$before" = "$after" ]; then echo "idempotent=yes"; else echo "idempotent=no"; fi

ok=1
for pair in \
  "living.md:^run tools/m/moved_witness.rish for the proof$" \
  "20260102-000000_testimony.md:^run tools/moved_witness.rish for the proof$" \
  "foundations/20260104-000000_a-living-foundation.md:^run tools/m/moved_witness.rish for the proof$" \
  "already.md:^run tools/m/moved_witness.rish already$" \
  "elsewhere.md:^run tools/fixtures/stayed_scan.sh which never moved$" \
  "untracked.md:^run tools/moved_witness.rish from a file nobody tracks$" \
  "tool_path_fixture.md:^run tools/moved_witness.rish as the instruments own stale citation$" \
  "foreign.md:^run otherproject/tools/moved_witness.rish in a tree that is not ours$" \
  "varprefix.md:tools/m/moved_witness.rish through a variable$"
do
  f="${pair%%:*}"; want="${pair#*:}"
  grep -q "$want" "$f" || { echo "control: $f is not what it must be -- $(cat "$f")" >&2; ok=0; }
done
[ "$before" = "$after" ] || ok=0

if [ "$ok" = 1 ]; then echo "verdict=ok"; else echo "verdict=wrong"; exit 1; fi
