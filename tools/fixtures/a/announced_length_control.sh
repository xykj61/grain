#!/bin/sh
# Proves announced_length_scan.sh on real git repositories in a throwaway pen -- every refusal shown
# from BOTH sides, and every welcome asserted as hard as every refusal, since a meter that only ever
# cries wolf is one somebody turns off. Both of this scan's own false-positive paths are planted.
set -u
src=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)/announced_length_scan.sh
[ -f "$src" ] || { echo "control: REFUSED -- $src is absent" >&2; exit 2; }
pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT
pass=0; fail=0
ck() { if printf '%s' "$3" | grep -q -- "$2"; then pass=$((pass+1)); else
  fail=$((fail+1)); echo "  FAIL $1: wanted '$2'"; printf '%s\n' "$3" | sed 's/^/        /'; fi; }
export GIT_AUTHOR_NAME=pen GIT_AUTHOR_EMAIL=pen@pen GIT_COMMITTER_NAME=pen GIT_COMMITTER_EMAIL=pen@pen
g() { git -c commit.gpgsign=false -c core.hooksPath=/dev/null "$@"; }

mkdir -p "$pen/tree/tools/fixtures/a"
g init -q -b main "$pen/tree"
cp "$src" "$pen/tree/tools/fixtures/a/"
scan="$pen/tree/tools/fixtures/a/announced_length_scan.sh"
run() { ( cd "$pen/tree" && sh "$scan" 2>&1 ); }
commit() { ( cd "$pen/tree" && g add -A && g commit -qm x >/dev/null 2>&1 ); }

# 1-2. A ladder announcing 64 and reaching 3 is a forecast, and the reading names both numbers.
printf 'The WIDE ladder (WIDE0-WIDE63).\nWIDE1 landed. WIDE2 landed. WIDE3 landed.\n' > "$pen/tree/pin.md"
commit; out=$(run)
ck "short ladder bites"      "verdict=living_forecast" "$out"
ck "both numbers named"      "announces WIDE0-WIDE63 and the ladder reached WIDE3" "$out"

# 3-4. A ladder that FINISHED walks free. This is the half that keeps the meter honest: an elder
# draft dropped the top value from the reading, so every completed ladder read as one rung short.
printf 'The DONE ladder (DONE0-DONE3).\nDONE1 DONE2 DONE3 all landed.\n' > "$pen/tree/pin.md"
commit; out=$(run)
ck "finished ladder walks free" "verdict=no_living_forecast" "$out"
ck "and is reported as met"     "met:" "$out"

# 5-6. ONE ANNOUNCEMENT MUST NOT VOTE A REACH FOR ANOTHER. `SOON` read as reaching SOON63 because
# a second page wrote the same range with an ellipsis, which the hyphen filter walked past.
printf 'The ELLIP ladder (ELLIP0-ELLIP63).\nELLIP1 landed.\n' > "$pen/tree/pin.md"
printf 'the rungs count ELLIP0...ELLIP63 in this note.\n' > "$pen/tree/other.md"
commit; out=$(run)
ck "ellipsis range does not vote" "announces ELLIP0-ELLIP63 and the ladder reached ELLIP1" "$out"
ck "so it still bites"            "verdict=living_forecast" "$out"

# 7. A UNICODE ELLIPSIS RANGE, written as its octal bytes so this file stays ASCII by law. This is
# the exact spelling that voted SOON63 a reach on the real tree after the ASCII spellings were
# named one by one -- which is why the pattern requires punctuation rather than enumerating it.
printf 'the rungs count ELLIP0\342\200\246ELLIP63 in this note.\n' > "$pen/tree/other.md"
commit
ck "unicode ellipsis does not vote" "reached ELLIP1" "$(run)"

# 8. An en-dash range is dropped too -- any spelling, not a list of them.
printf 'the rungs count ELLIP0 - ELLIP63 here.\n' > "$pen/tree/other.md"
commit
ck "spaced-hyphen range does not vote" "reached ELLIP1" "$(run)"
rm -f "$pen/tree/other.md"

# 9-10. A LEDGER ROW IS A RECORD, NOT AN ANNOUNCEMENT. The foundation written to teach this law
# tabulates announced-against-reached, and was the first page this meter accused. A two-cell row
# whose second cell states the true reach is documentation; a bare announcement still bites.
printf 'The RECD ladder (RECD0-RECD63).\nRECD1 landed.\n' > "$pen/tree/pin.md"
printf '| Announced | Reached |\n|---|---|\n| RECD0-RECD63 | RECD1 |\n' > "$pen/tree/table.md"
commit; out=$(run)
ck "bare announcement still bites" "announces RECD0-RECD63 and the ladder reached RECD1" "$out"
ck "and the table row is counted once" "announcements_checked=1" "$out"
rm -f "$pen/tree/pin.md"
commit
ck "table alone reads clean" "verdict=no_living_forecast" "$(run)"
rm -f "$pen/tree/table.md"

# 11-12. DATED TESTIMONY KEEPS EVERY NUMBER IT WROTE. An announcement under a dated shelf is read
# past entirely -- accrete-never-break -- so a folded log can never red this meter.
printf 'A living page with no announcement at all.\n' > "$pen/tree/pin.md"
mkdir -p "$pen/tree/date/20260101"
printf 'The OLD ladder (OLDX0-OLDX63).\nOLDX1 landed.\n' > "$pen/tree/date/20260101/note.md"
commit; out=$(run)
ck "dated shelf read past"   "verdict=no_living_forecast" "$out"
ck "and counted nowhere"     "announcements_checked=0"    "$out"

# 13-14. A tree with nothing to read REFUSES rather than printing a clean zero (REDS %413).
( cd "$pen/tree" && g rm -q -r --cached . >/dev/null 2>&1 )
out=$(run); rc=$?
ck "empty listing refuses" "REFUSED" "$out"
[ "$rc" = 2 ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL empty listing exit: got $rc wanted 2"; }

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
