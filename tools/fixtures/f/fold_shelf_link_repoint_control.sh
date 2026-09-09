#!/bin/sh
# fold_shelf_link_repoint_control.sh -- the repointer proven on a real fold in a throwaway repository.
#
# The plant is the fault as a hand actually makes it: a page is folded one directory down and its
# climbing links are carried across unchanged. Every refusal is shown from both sides.
#
#   sh tools/fixtures/f/fold_shelf_link_repoint_control.sh
#
# Prints `pass=N fail=N`. Bounded: 25 cases, one pen holding a real git repository.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
tool="$root/tools/f/fold_shelf_link_repoint.sh"
scan="$root/tools/fixtures/f/fold_shelf_link_scan.sh"
pen=${TMPDIR:-/tmp}/fold-repoint-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

mkdir -p "$pen/construction/archive" "$pen/tools/fixtures/f" "$pen/tools/f" "$pen/.claude/rules"
cp "$tool" "$pen/tools/f/" ; cp "$scan" "$pen/tools/fixtures/f/"
cd "$pen"
git init -q .; git config user.email pen@example.invalid; git config user.name pen

# The targets a correct link must reach.
printf '# a rule\n' > .claude/rules/a-rule.md
printf '# a sibling shelf\n' > construction/archive/sibling.md
printf '# the pin\n[sibling](archive/sibling.md)\n' > construction/PIN.md
# THE PLANT: a shelf one level down, carrying the pin's own link depths unchanged.
printf '# a folded shelf\n[sibling](archive/sibling.md)\n[a rule](../.claude/rules/a-rule.md)\n' > construction/archive/folded.md
printf 'construction/archive/\n' > construction/archive/.keep 2>/dev/null || true
git add -A >/dev/null; git commit -qm plant

run() { FOLD_REPOINT_ROOT="$pen" sh tools/f/fold_shelf_link_repoint.sh "$@" 2>&1; }

out=$(run)
check "a dry run names the archive repair" yes "$(has "$out" 'would repoint construction/archive/folded.md: archive/sibling.md -> sibling.md')"
check "a dry run names the parent repair"  yes "$(has "$out" 'would repoint construction/archive/folded.md: ../.claude/rules/a-rule.md -> ../../.claude/rules/a-rule.md')"
check "and a dry run changes nothing"      yes "$(has "$(cat construction/archive/folded.md)" '](archive/sibling.md)')"

out=$(run --apply)
check "applying reports its verdict"       yes "$(has "$out" 'verdict=ok')"
body=$(cat construction/archive/folded.md)
check "the archive link is deepened"       yes "$(has "$body" '](sibling.md)')"
check "the parent link is deepened"        yes "$(has "$body" '](../../.claude/rules/a-rule.md)')"
check "and the elder spelling is gone"     no  "$(has "$body" '](archive/sibling.md)')"

# The PIN itself is not a shelf and must be left exactly as it was.
check "the pin is untouched"               yes "$(has "$(cat construction/PIN.md)" '](archive/sibling.md)')"

# IDEMPOTENT: a second run finds nothing, which is what makes it safe to run on any lap.
out=$(run --apply)
check "a second run finds nothing"         yes "$(has "$out" 'verdict=nothing_to_do')"

# A DEAD link -- broken with no computed repair -- is never rewritten, because it needs a reader.
printf '# dead\n[gone](archive/nowhere.md)\n' > construction/archive/dead.md
git add -A >/dev/null; git commit -qm dead
out=$(run --apply)
check "a dead link is not rewritten"       yes "$(has "$(cat construction/archive/dead.md)" '](archive/nowhere.md)')"

# AN UNTRACKED SHELF IS THE ONE THIS TOOL EXISTS TO REACH, and the day the elder comment forecast
# has come. It used to read "never offered": the scan drew its population from `git ls-files`, so
# nothing untracked could enter the list, and the repointer's tracked check guarded a case already
# foreclosed. That made the tree's own written remedy inert -- `20260908.044602` said run the
# repointer BEFORE staging, `20260908.063650` did exactly that, read `nothing_to_do`, and repaired
# nine links by hand, because one `git add` was the whole distance between the two answers.
#
# The scan now takes `FOLD_SHELF_CORPUS`, this tool asks it for `working`, and both directions are
# proven here: the shelf a hand has just written IS repaired, and `--tracked-only` restores the
# elder population on the same pen so the widening can be told from a tool that ignores the flag.
printf '# untracked\n[sibling](archive/sibling.md)\n' > construction/archive/untracked.md
out=$(run --tracked-only --apply)
check "--tracked-only leaves it alone"      yes "$(has "$out" 'verdict=nothing_to_do')"
check "and names the corpus it read"        yes "$(has "$out" 'corpus=tracked')"
check "and it is left byte-for-byte"        yes "$(has "$(cat construction/archive/untracked.md)" '](archive/sibling.md)')"

out=$(run --apply)
check "the working corpus repairs it"       yes "$(has "$out" 'verdict=ok')"
check "and names the corpus it read"        yes "$(has "$out" 'corpus=working')"
body=$(cat construction/archive/untracked.md)
check "the unstaged shelf is deepened"      yes "$(has "$body" '](sibling.md)')"
check "and the elder spelling is gone"      no  "$(has "$body" '](archive/sibling.md)')"

# AN IGNORED PATH IS REFUSED UNDER EITHER CORPUS. Widening to the working tree is what lets the
# repair reach a hand's own draft; the ignore rule is what keeps it out of a build artifact, a
# `session-output/` transcript, or a peer's scratch. Proven where it would otherwise bite: this
# shelf carries the identical fault the one above did.
printf 'construction/archive/ignored-*\n' > .gitignore
git add .gitignore >/dev/null; git commit -qm ignore
printf '# ignored\n[sibling](archive/sibling.md)\n' > construction/archive/ignored-build.md
out=$(run --apply)
check "an ignored shelf is never offered"   yes "$(has "$out" 'verdict=nothing_to_do')"
check "and it is left byte-for-byte"        yes "$(has "$(cat construction/archive/ignored-build.md)" '](archive/sibling.md)')"

# Repeated links produce one scan row per occurrence. A quoted spelling is
# outside the scan's subject even when the same target is a real link below it.
printf '# repeated\n`[example](archive/sibling.md)`\n[one](archive/sibling.md)\n[two](archive/sibling.md)\n[three](archive/sibling.md)\n' > construction/archive/repeated.md
printf '# repeated\n`[example](archive/sibling.md)`\n[one](sibling.md)\n[two](sibling.md)\n[three](sibling.md)\n' > "$pen/expected.md"
repair_status=0
out=$(run --apply) || repair_status=$?
check "repeated targets complete" 0 "$repair_status"
check "repeated targets report success" yes "$(has "$out" 'verdict=ok')"
check "each reported occurrence is repaired" yes "$(has "$out" 'repairs=3')"
if cmp -s construction/archive/repeated.md "$pen/expected.md"; then exact=yes; else exact=no; fi
check "real links change and the code span stays exact" yes "$exact"
out=$(run --apply)
check "repeated targets converge on the second run" yes "$(has "$out" 'verdict=nothing_to_do')"

# An unknown argument refuses rather than being read as one of the two it resembles.
out=$( set +e; run --sideways 2>&1; exit 0 )
check "an unknown argument refuses"         yes "$(has "$out" 'refused: unknown argument --sideways')"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
