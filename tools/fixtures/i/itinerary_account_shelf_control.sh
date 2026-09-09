#!/bin/sh
# itinerary_account_shelf_control.sh -- the account-shelf writer proven in a throwaway pen.
#
# The subject is a shelf written by a tool rather than by a hand. Every refusal is shown from both
# sides -- planted and then lifted -- because a refusal proven only in the passing direction cannot
# be told from a bypass.
#
#   sh tools/fixtures/i/itinerary_account_shelf_control.sh
#
# Prints `pass=N fail=N`. Bounded: one pen, the cases below.
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/../../.." && pwd)
tool="$root/tools/i/itinerary_account_shelf.sh"
reanchor="$root/tools/fixtures/r/reds_fold_reanchor.sh"
pen=${TMPDIR:-/tmp}/itinerary-shelf-pen-$$
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0; fail=0
check() { if [ "$3" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); printf 'FAIL %s -- wanted %s, got %s\n' "$1" "$2" "$3" >&2; fi; }
has() { case "$1" in *"$2"*) echo yes ;; *) echo no ;; esac; }

mkdir -p "$pen/construction/archive" "$pen/tools/i" "$pen/tools/fixtures/r" "$pen/external-research" "$pen/.claude/rules"
cp "$tool" "$pen/tools/i/"; cp "$reanchor" "$pen/tools/fixtures/r/"
cd "$pen"
printf '# the card\n' > construction/ITINERARY.md
printf '# the ledger\n' > construction/REDS.md
printf '# an elder shelf\n' > construction/archive/20260908-230804_itinerary-landed-accounts.md
printf '# a paper\n' > external-research/a-paper.md
printf '# a rule\n' > .claude/rules/reds-first.md

run() { ITINERARY_SHELF_ROOT="$pen" sh tools/i/itinerary_account_shelf.sh "$@" 2>&1; }

block='**DIFFUSER -- AN ACCOUNT.**
Elder [shelved](archive/20260908-230804_itinerary-landed-accounts.md);
[new](../external-research/a-paper.md) A/91.
Row [folded](../REDS.md), and see [rules](../.claude/rules/reds-first.md).'

# --- the four link forms, on a dry run that must touch nothing -------------------------------
out=$(printf '%s\n' "$block" | run --stamp 20260909.001122 --seat DIFFUSER --dry-run)
check "an archive link loses its directory"      yes "$(has "$out" '](20260908-230804_itinerary-landed-accounts.md)')"
check "a climbing link gains a level"            yes "$(has "$out" '](../../external-research/a-paper.md)')"
check "a dotted rule path gains a level too"     yes "$(has "$out" '](../../.claude/rules/reds-first.md)')"
check "the pin's own link is held as written"    yes "$(has "$out" '](../REDS.md)')"
check "a dry run names the shelf it would write" yes "$(has "$out" 'shelf=construction/archive/20260909-001122_itinerary-landed-accounts.md')"
check "a dry run hands over the card's link"     yes "$(has "$out" 'card_link=archive/20260909-001122_itinerary-landed-accounts.md')"
check "and a dry run writes no file"             no  "$(has "$(ls construction/archive)" '20260909-001122')"

# --- the header, generated rather than invented by a hand ------------------------------------
check "the header names the seat"                yes "$(has "$out" 'The DIFFUSER account the live card carried')"
check "the header names the stamp"              yes "$(has "$out" 'shelved `20260909.001122`')"
check "the header declares its room"             yes "$(has "$out" '**Room:** Checkable')"

# --- the write ------------------------------------------------------------------------------
out=$(printf '%s\n' "$block" | run --stamp 20260909.001122 --seat DIFFUSER)
check "a write reports its shelf"                yes "$(has "$out" 'shelf=construction/archive/20260909-001122_itinerary-landed-accounts.md')"
body=$(cat construction/archive/20260909-001122_itinerary-landed-accounts.md)
check "the written file carries the repair"      yes "$(has "$body" '](../../external-research/a-paper.md)')"
check "the written file holds the pin link"      yes "$(has "$body" '](../REDS.md)')"
check "the written file carries no stale depth"  no  "$(has "$body" '](archive/')"

# --- refusals, each planted and then lifted ---------------------------------------------------
out=$(printf '%s\n' "$block" | run --stamp 20260909.001122 --seat DIFFUSER || true)
check "a standing shelf is never overwritten"    yes "$(has "$out" 'refused: shelf_exists')"
out=$(printf '%s\n' "$block" | run --stamp 20260909.002200 --seat DIFFUSER)
check "and a free stamp writes freely"           yes "$(has "$out" 'shelf=construction/archive/20260909-002200')"

out=$(printf '%s\n' "$block" | run --stamp 20260909-001122 --seat DIFFUSER || true)
check "a hyphen stamp refuses"                   yes "$(has "$out" 'refused: stamp_shape')"
out=$(printf '%s\n' "$block" | run --stamp 20260909.003300 --seat diffuser || true)
check "a lowercase seat refuses"                 yes "$(has "$out" 'refused: seat_shape')"
out=$(printf '%s\n' "$block" | run --stamp 20260909.003300 --seat '' || true)
check "an absent seat refuses"                   yes "$(has "$out" 'refused: seat_shape')"
out=$(printf '' | run --stamp 20260909.003300 --seat DIFFUSER || true)
check "an empty block refuses"                   yes "$(has "$out" 'refused: block_empty')"
out=$(printf 'an em-dash \342\200\224 here\n' | run --stamp 20260909.003300 --seat DIFFUSER || true)
check "a non-ASCII byte refuses"                 yes "$(has "$out" 'refused: block_non_ascii')"
out=$(dd if=/dev/zero bs=1 count=9000 2>/dev/null | tr '\0' 'x' | run --stamp 20260909.003300 --seat DIFFUSER || true)
check "a block past the bound refuses"           yes "$(has "$out" 'refused: block_too_long')"
out=$(printf '%s\n' "$block" | run --stamp || true)
check "a flag given last refuses by name"        yes "$(has "$out" 'refused: value_absent')"
out=$(printf '%s\n' "$block" | run --seat || true)
check "and the other flag refuses the same way"  yes "$(has "$out" 'refused: value_absent')"
out=$(printf '%s\n' "$block" | run --stamp 20260909.003300 --seat DIFFUSER --wat || true)
check "an unknown argument refuses"              yes "$(has "$out" 'refused: unknown argument')"
check "and no refusal left a file behind"        no  "$(has "$(ls construction/archive)" '20260909-003300')"

mv tools/fixtures/r/reds_fold_reanchor.sh tools/fixtures/r/gone.sh
out=$(printf '%s\n' "$block" | run --stamp 20260909.004400 --seat DIFFUSER || true)
check "an absent filter refuses"                 yes "$(has "$out" 'refused: reanchor_absent')"
mv tools/fixtures/r/gone.sh tools/fixtures/r/reds_fold_reanchor.sh
out=$(printf '%s\n' "$block" | run --stamp 20260909.004400 --seat DIFFUSER)
check "and its return lifts the refusal"         yes "$(has "$out" 'shelf=construction/archive/20260909-004400')"

rm -f construction/ITINERARY.md
out=$(printf '%s\n' "$block" | run --stamp 20260909.005500 --seat DIFFUSER || true)
check "a tree without the card refuses"          yes "$(has "$out" 'refused: not_at_root')"

printf 'pass=%s fail=%s\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
