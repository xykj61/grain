#!/bin/sh
# fold_shelf_link_repoint_control.sh -- the repointer proven on a real fold in a throwaway repository.
#
# The plant is the fault as a hand actually makes it: a page is folded one directory down and its
# climbing links are carried across unchanged. Every refusal is shown from both sides.
#
#   sh tools/fixtures/f/fold_shelf_link_repoint_control.sh
#
# Prints `pass=N fail=N`. Bounded: 12 cases, one pen holding a real git repository.
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

# AN UNTRACKED SHELF IS NEVER OFFERED, which is a stronger fact than being skipped. The scan reads
# `git ls-files`, so an untracked file cannot enter its list at all -- the repointer's own tracked
# check therefore guards a case the scan already forecloses, and this asserts the REAL behaviour
# rather than the one the check was written for. The check stays as a second wall in case the scan's
# corpus ever widens; what is proven here is that today nothing untracked is even considered.
printf '# untracked\n[sibling](archive/sibling.md)\n' > construction/archive/untracked.md
out=$(run --apply)
check "an untracked shelf is never offered" yes "$(has "$out" 'verdict=nothing_to_do')"
check "and it is left byte-for-byte"        yes "$(has "$(cat construction/archive/untracked.md)" '](archive/sibling.md)')"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
