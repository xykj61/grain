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
# A refusal must be silent about the reading, so one leg asserts an ABSENCE. A scan that refuses
# and prints a verdict anyway has handed a reader both answers and let them pick.
ckn() { if printf '%s' "$3" | grep -q -- "$2"; then
  fail=$((fail+1)); echo "  FAIL $1: did not want '$2'"; printf '%s\n' "$3" | sed 's/^/        /'
  else pass=$((pass+1)); fi; }
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

# 13-14. THIS METER'S OWN OUTPUT IS A RECORD TOO. A page that runs the scan and quotes what it
# printed had its quotation read back as a fresh announcement BY THE QUOTING PAGE -- the meter
# reading its own output as input, found when docs-geode/demos/README.md began teaching this law by
# running it (`20260905`). Both output shapes state the true reach beside the announcement, so both
# earn exactly the pass the ledger row above earns.
printf 'A living page with no announcement at all.\n' > "$pen/tree/pin.md"
printf 'met: constel/LADDER.md announces QUOT0-QUOT31, reached QUOT31\nforecast: pin.md announces QUOT0-QUOT63 and the ladder reached QUOT1\n' > "$pen/tree/quote.md"
commit; out=$(run)
ck "quoted meter output is not an announcement" "announcements_checked=0"    "$out"
ck "so a quoting page reads clean"              "verdict=no_living_forecast" "$out"

# 15-16. AND THE EXCLUSION IS A RECORD RULE RATHER THAN A HOLE. The same prefix announced bare,
# beside the quotation that mentions it, still bites -- otherwise a page could hide a forecast by
# quoting the meter once.
printf 'The QUOT ladder (QUOT0-QUOT63).\nQUOT1 landed.\n' > "$pen/tree/pin.md"
commit; out=$(run)
ck "bare announcement beside a quote still bites" "announces QUOT0-QUOT63 and the ladder reached QUOT1" "$out"
ck "and is counted exactly once"                  "announcements_checked=1" "$out"
rm -f "$pen/tree/quote.md"

# 17-18. A tree with nothing to read REFUSES rather than printing a clean zero (REDS %413).
( cd "$pen/tree" && g rm -q -r --cached . >/dev/null 2>&1 )
out=$(run); rc=$?
ck "empty listing refuses" "REFUSED" "$out"
[ "$rc" = 2 ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL empty listing exit: got $rc wanted 2"; }

# 19-23. THE SCRATCH IS AN INSTRUMENT, AND A SILENT ONE READS EXACTLY LIKE A CLEAN TREE. The walk
# writes its findings to a scratch file and reads them back, so a scratch that never arrives yields
# an empty read: nothing counted, nothing short, `verdict=no_living_forecast` at exit 0. Proven on
# metal before the repair -- this same WIDE0-WIDE63 pen read `living_forecast` with a writable
# scratch and `no_living_forecast` with an unwritable one, the forecast standing untouched in both.
# Planted from BOTH sides, and the forecast is restored first so the pen has something to lose.
printf 'The WIDE ladder (WIDE0-WIDE63).\nWIDE1 landed.\n' > "$pen/tree/pin.md"
commit
out=$(run)
ck "the pen has a forecast to lose"   "verdict=living_forecast" "$out"

out=$( cd "$pen/tree" && TMPDIR=$pen/nowhere sh "$scan" 2>&1 ); rc=$?
ck "an unmakeable scratch refuses"    "REFUSED -- no scratch file could be made" "$out"
ckn "and prints no verdict at all"    "verdict=" "$out"
[ "$rc" = 2 ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL unmakeable scratch exit: got $rc wanted 2"; }

# A WRITE THAT FAILS PARTWAY IS THE SAME FAULT ONE STEP ON, and mktemp cannot see it: the file
# exists, and the listing inside it is short. The completion sentinel is written last, so its
# absence is what a truncated write leaves behind. Bitten by mutation -- drop the sentinel from a
# copy of the scan and the copy must refuse rather than report a clean tree.
sed 's/^  echo .#listing-complete.$//' "$scan" > "$pen/tree/tools/fixtures/a/truncated.sh"
out=$( cd "$pen/tree" && sh tools/fixtures/a/truncated.sh 2>&1 ); rc=$?
ck "a truncated listing refuses"      "REFUSED -- the scratch listing did not survive the write" "$out"
[ "$rc" = 2 ] && pass=$((pass+1)) || { fail=$((fail+1)); echo "  FAIL truncated listing exit: got $rc wanted 2"; }
rm -f "$pen/tree/tools/fixtures/a/truncated.sh"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ] || exit 1
