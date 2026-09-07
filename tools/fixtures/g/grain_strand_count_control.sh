#!/bin/sh
# grain_strand_count_control.sh -- the grain strand-count guard proven on a planted page in a pen.
#
# Every refusal is shown from BOTH sides: planted so the guard bites, then lifted so it walks free.
# A refusal proven only in the passing direction cannot be told from a bypass, and the grain's own
# fusion strand says it plainly -- a guard that cannot red guards nothing.
#
# The load-bearing leg seats one more strand on the pen's page and watches a pointer that was correct
# a moment ago go stale. That is what proves the count is DERIVED rather than spelled into the guard,
# which is the whole repair this family exists for.
#
#   sh tools/fixtures/g/grain_strand_count_control.sh
#
# Prints `pass=N fail=N`. Bounded: 20 cases, one pen holding a throwaway git repository.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
scan="$root/tools/fixtures/g/grain_strand_count_scan.sh"
pen=${TMPDIR:-/tmp}/grain-strand-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM
mkdir -p "$pen/foundations" "$pen/docs" "$pen/foundations/date/20260101" "$pen/session-logs/date/20260101"

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

page=foundations/pen-grain.md

write_page() {
  # $1 = how many fusion strands to seat; $2 = the count the page states, or `none`
  n=$1
  {
    echo '# The pen grain'
    echo
    echo '## The Grain, Defined'
    echo
    echo 'The grain is not a mood:'
    echo
    echo '- **The first strand** -- one.'
    echo '- **The second strand** -- two.'
    echo '- **The third strand** -- three.'
    echo
    echo 'A pattern fits our grain when it leans on these.'
    echo
    echo '## The Crossing, Defined'
    echo
    echo 'Two rooms and a doorway.'
    echo
    echo '## Strands Seated at the Fusion'
    echo
    echo 'Strands earned their place beside the elders.'
    echo
    echo '**The fourth strand.** Proven the hard way.'
    if [ "$n" -ge 2 ]; then echo '**The fifth strand.** Proven twice.'; fi
    if [ "$n" -ge 3 ]; then echo '**The sixth strand.** Seated today.'; fi
    echo
    echo '## The Test'
    echo
    echo 'One question closes every crossing.'
    if [ "$2" != none ]; then echo "The grain holds $2 strands today."; fi
  } > "$pen/$page"
}

cd "$pen"
git init -q .
git config user.email pen@example.invalid
git config user.name pen

write_page 2 none
printf 'The grain holds five strands and a crossing test.\n' > "$pen/docs/pointer.md"
git add -A >/dev/null; git commit -qm seed

# A refusal is an expected outcome here, so the reader never dies on one; the exit code is checked
# on its own leg below.
ask() { GRAIN_ROOT="$pen" GRAIN_PAGE="$page" sh "$scan" "${1:-count}" 2>&1 || true; }
rc_of() { GRAIN_ROOT="$pen" GRAIN_PAGE="$page" sh "$scan" >/dev/null 2>&1 && echo 0 || echo $?; }

out=$(ask)
check "the elder roster is derived"   yes "$(has "$out" 'strands_elder=3')"
check "the fusion strands are derived" yes "$(has "$out" 'strands_fusion=2')"
check "the total is their sum"        yes "$(has "$out" 'strands_total=5')"
check "a pointer that agrees is free" yes "$(has "$out" 'stale_counts=0')"
check "every reading is printed"      yes "$(has "$out" 'docs_read=')"
check "a page stating no count says so" yes "$(has "$out" 'page_states=no')"

# The page that holds the strands is the one place a count may stand, and the reading says whether
# it does. Without it the guard would pass a tree where nobody spells the number at all.
write_page 2 five
git add -A >/dev/null; git commit -qm state
check "and a stated count is seen"   yes "$(has "$(ask)" 'page_states=yes')"

# A pointer carrying a total that no longer matches is exactly the fault this family books.
printf 'The grain holds four strands and a crossing test.\n' > "$pen/docs/pointer.md"
git add -A >/dev/null; git commit -qm stale
out=$(ask)
check "a disagreeing count is caught" yes "$(has "$out" 'stale_counts=1')"
out=$(ask list)
check "and the sentence is named"     yes "$(has "$out" 'stale: docs/pointer.md:1 says 4 where the page holds 5')"

# THE LOAD-BEARING LEG. Seat one more strand and a pointer that was right becomes wrong, which is
# what proves the count is read off the page rather than spelled into the guard.
printf 'The grain holds five strands and a crossing test.\n' > "$pen/docs/pointer.md"
git add -A >/dev/null; git commit -qm repair
check "the repaired pointer is free"  yes "$(has "$(ask)" 'stale_counts=0')"
write_page 3 six
git add -A >/dev/null; git commit -qm grow
out=$(ask)
check "a new strand moves the total"  yes "$(has "$out" 'strands_total=6')"
check "and the elder pointer goes stale" yes "$(has "$out" 'stale_counts=1')"

# Ordinary prose stays out of the reading.
printf 'The grain holds six strands.\n' > "$pen/docs/pointer.md"
printf 'Each grain surface should hold one strand and say why.\n' > "$pen/docs/singular.md"
printf 'The grain has nine senses mapped, and every module named here reaches its own strands.\n' > "$pen/docs/far.md"
printf 'This page counts four strands of rope and never says the word.\n' > "$pen/docs/nograin.md"
git add -A >/dev/null; git commit -qm prose
out=$(ask)
check "a singular strand is not a count" yes "$(has "$out" 'stale_counts=0')"

# Dated testimony keeps every word it wrote, so a shelved page and a session log are read past.
printf 'The grain holds four strands, as it stood that day.\n' > "$pen/foundations/date/20260101/20260101-010000_elder.md"
printf 'The grain holds four strands.\n' > "$pen/session-logs/date/20260101/20260101-010000_log.md"
git add -A >/dev/null; git commit -qm testimony
check "testimony is read past"        yes "$(has "$(ask)" 'stale_counts=0')"

# Every refusal, shown by breaking the page and then mending it.
mv "$pen/$page" "$pen/foundations/moved.md"
check "an absent page refuses"        yes "$(has "$(ask)" 'refused: the canonical grain page is absent')"
check "and it refuses with code 2"    2   "$(rc_of)"
mv "$pen/foundations/moved.md" "$pen/$page"
check "and mending it walks free"     yes "$(has "$(ask)" 'strands_total=6')"

sed 's/^## The Grain, Defined/## Something Else/' "$pen/$page" > "$pen/t" && cat "$pen/t" > "$pen/$page"
check "a moved elder heading refuses" yes "$(has "$(ask)" 'no elder strand bullets found')"
write_page 2 five
check "and restoring it walks free"   yes "$(has "$(ask)" 'strands_total=5')"

sed 's/^## Strands Seated at the Fusion/## Nothing Seated/' "$pen/$page" > "$pen/t" && cat "$pen/t" > "$pen/$page"
check "a moved fusion heading refuses" yes "$(has "$(ask)" 'no bold-lead strands found')"

printf 'pass=%d fail=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
