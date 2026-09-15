#!/bin/sh
# tools/fixtures/l/link_text_promise_control.sh -- proves the link-text reading from both sides.
#
# Every plant is counted while it stands and read back to zero once it is lifted, because a refusal
# shown only in the passing direction cannot be told from a bypass. Each pen is a real git
# repository in a throwaway directory: the scan reads `git ls-files`, so what the repository
# CARRIES is the question, and one case plants exactly the difference between that and what sits
# on disk.
#
# Two mutations are asserted to bite, each removing one line of the scan's own reading:
#   dropping the `text resolves` clause makes two honest files read as a broken promise;
#   dropping the `target resolves` clause pulls in the class `tracked_link` already owns.
#
# USAGE
#   sh tools/fixtures/l/link_text_promise_control.sh
#
# Driven by tools/l/link_text_promise_witness.rish. Run from the repository root.

set -u

SCAN=$(cd "$(dirname "$0")" && pwd)/link_text_promise_scan.sh
[ -f "$SCAN" ] || { echo "control_verdict=absent"; echo "control_failures=1"; exit 1; }

PEN=$(mktemp -d "${TMPDIR:-/tmp}/link-text-promise-control.XXXXXX")
trap 'rm -rf "$PEN"' EXIT INT TERM

fails=0
cases=0
note() { printf '%s=%s\n' "$1" "$2"; cases=$((cases + 1)); [ "$2" = yes ] || fails=$((fails + 1)); }
yn() { if [ "$1" -eq 0 ]; then echo yes; else echo no; fi; }
has() { echo "$1" | grep -q "$2" && echo yes || echo no; }

# A pen is its own tree root: a shipping shelf, a room outside it, and two real targets.
mkpen() {
  d="$PEN/$1"; rm -rf "$d"
  mkdir -p "$d/docs-geode/tutorials" "$d/context" "$d/tools/o" "$d/manual"
  ( cd "$d" \
    && git init -q . \
    && git config user.email pen@example.invalid \
    && git config user.name pen \
    && git config commit.gpgsign false ) >/dev/null 2>&1
  printf 'x\n' > "$d/context/GUIDE.md"
  printf 'x\n' > "$d/tools/o/one_witness.rish"
  printf 'x\n' > "$d/manual/README.md"
  echo "$d"
}
seal() { ( cd "$1" && git add -A >/dev/null 2>&1 && git commit -qm pen >/dev/null 2>&1 ); }
run()  { ( cd "$1" && sh "$SCAN" "${2:-report}" ) 2>&1; }

# --- a shelf whose link text and target agree --------------------------------------------------
d=$(mkpen clean)
printf '# a\n\nRead [`../../context/GUIDE.md`](../../context/GUIDE.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note clean_free "$(yn $rc)"
note clean_verdict_ok "$(has "$out" '^verdict=ok$')"
note clean_geode_zero "$(has "$out" '^promise_broken_geode=0$')"
note clean_other_zero "$(has "$out" '^promise_broken_other=0$')"
note clean_pages_counted "$(has "$out" '^pages_read=3$')"

# --- the same page with a wrong depth in its visible text only --------------------------------
printf '# a\n\nRead [`../context/GUIDE.md`](../../context/GUIDE.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note geode_refused "$(yn $((1 - (rc != 0))) )"
note geode_verdict "$(has "$out" '^verdict=geode_promise_broken$')"
note geode_counted "$(has "$out" '^promise_broken_geode=1$')"
note geode_named "$(has "$out" '^geode: docs-geode/tutorials/a.md text=../context/GUIDE.md')"

# --- lifted again, and the reading returns to zero --------------------------------------------
printf '# a\n\nRead [`../../context/GUIDE.md`](../../context/GUIDE.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note lift_free "$(yn $rc)"
note lift_geode_zero "$(has "$out" '^promise_broken_geode=0$')"

# --- a text naming a room and a target opening its door: two real paths, welcomed --------------
d=$(mkpen room)
printf '# a\n\nWoven with [`../../manual/`](../../manual/README.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note room_free "$(yn $rc)"
note room_geode_zero "$(has "$out" '^promise_broken_geode=0$')"

# --- a text whose room does not exist, target opening one that does ----------------------------
d=$(mkpen ghostroom)
printf '# a\n\nWoven with [`../../handbook/`](../../manual/README.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note ghostroom_refused "$(yn $((1 - (rc != 0))) )"
note ghostroom_counted "$(has "$out" '^promise_broken_geode=1$')"

# --- a broken TARGET is the class tracked_link owns, and passes here free ----------------------
d=$(mkpen broken_target)
printf '# a\n\nRead [`../../context/GHOST.md`](../../context/GHOST.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
printf '# b\n\nRead [`../context/GUIDE.md`](../../context/GHOST.md).\n' \
  > "$d/docs-geode/tutorials/b.md"
seal "$d"; out=$(run "$d"); rc=$?
note broken_target_free "$(yn $rc)"
note broken_target_zero "$(has "$out" '^promise_broken_geode=0$')"

# --- a bare backticked path is no link, and carries no statement of what it is relative to -----
d=$(mkpen bare)
printf '# a\n\n    cd rye\n    ./bootstrap.sh\n\nThe `./bootstrap.sh` step builds it.\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note bare_free "$(yn $rc)"
note bare_zero "$(has "$out" '^promise_broken_geode=0$')"

# --- a URL target answers a different question -------------------------------------------------
d=$(mkpen url)
printf '# a\n\nRead [`../nowhere/x.md`](https://example.invalid/x).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note url_free "$(yn $rc)"
note url_zero "$(has "$out" '^promise_broken_geode=0$')"

# --- a page on disk the repository does not carry is read past ---------------------------------
d=$(mkpen untracked)
printf '# a\n\nRead [`../../context/GUIDE.md`](../../context/GUIDE.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"
printf '# b\n\nRead [`../context/GUIDE.md`](../../context/GUIDE.md).\n' \
  > "$d/docs-geode/tutorials/b.md"
out=$(run "$d"); rc=$?
note untracked_free "$(yn $rc)"
note untracked_zero "$(has "$out" '^promise_broken_geode=0$')"
note untracked_pages "$(has "$out" '^pages_read=3$')"

# --- a dated basename is testimony: counted apart, gating nothing ------------------------------
d=$(mkpen testimony)
printf '# a\n\nRead [`../context/GUIDE.md`](../../context/GUIDE.md).\n' \
  > "$d/docs-geode/tutorials/20260101-010101_a.md"
seal "$d"; out=$(run "$d"); rc=$?
note testimony_free "$(yn $rc)"
note testimony_geode_zero "$(has "$out" '^promise_broken_geode=0$')"
note testimony_counted "$(has "$out" '^promise_broken_testimony=1$')"

# --- a living page outside the shelf ratchets rather than gating -------------------------------
d=$(mkpen outside)
mkdir -p "$d/active-designing/date"
printf '# a\n\nRead [`../context/GUIDE.md`](../../../context/GUIDE.md).\n' \
  > "$d/active-designing/date/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note outside_free "$(yn $rc)"
note outside_geode_zero "$(has "$out" '^promise_broken_geode=0$')"
note outside_counted "$(has "$out" '^promise_broken_other=1$')"
note outside_pages "$(has "$out" '^promise_broken_other_pages=1$')"
note outside_listed "$(has "$(run "$d" --list)" '^living active-designing/date/a.md text=../context/GUIDE.md')"

# --- the ceiling refuses from the other side ---------------------------------------------------
pen_ceiling=$(mktemp -d "$PEN/ceiling.XXXXXX")
sed 's/^CEILING=.*$/CEILING=0/' "$SCAN" > "$pen_ceiling/scan.sh"
out=$( ( cd "$d" && sh "$pen_ceiling/scan.sh" ) 2>&1 ); rc=$?
note ceiling_refused "$(yn $((1 - (rc != 0))) )"
note ceiling_verdict "$(has "$out" '^verdict=over_ceiling$')"

# --- vendored rooms are other people's bytes ---------------------------------------------------
d=$(mkpen vendored)
mkdir -p "$d/vendor/x"
printf '# a\n\nRead [`../context/GUIDE.md`](../../context/GUIDE.md).\n' > "$d/vendor/x/a.md"
seal "$d"; out=$(run "$d"); rc=$?
note vendor_free "$(yn $rc)"
note vendor_zero "$(has "$out" '^promise_broken_other=0$')"

# --- MUTATION: drop the `text resolves` clause, and two honest files read as broken ------------
d=$(mkpen room)
printf '# a\n\nWoven with [`../../manual/`](../../manual/README.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"
pen_mut=$(mktemp -d "$PEN/mut1.XXXXXX")
sed '/if (tp in have) next/d' "$SCAN" > "$pen_mut/scan.sh"
out=$( ( cd "$d" && sh "$pen_mut/scan.sh" ) 2>&1 )
note mutation_text_resolves_bites "$(has "$out" '^promise_broken_geode=1$')"

# --- MUTATION: drop the `target resolves` clause, and the neighbor's class arrives -------------
d=$(mkpen broken_target)
printf '# a\n\nRead [`../context/GUIDE.md`](../../context/GHOST.md).\n' \
  > "$d/docs-geode/tutorials/a.md"
seal "$d"
pen_mut2=$(mktemp -d "$PEN/mut2.XXXXXX")
sed '/if (!(gp in have)) next/d' "$SCAN" > "$pen_mut2/scan.sh"
out=$( ( cd "$d" && sh "$pen_mut2/scan.sh" ) 2>&1 )
note mutation_target_resolves_bites "$(has "$out" '^promise_broken_geode=1$')"

echo "control_cases=$cases"
echo "control_failures=$fails"
if [ "$fails" -eq 0 ]; then echo "control_verdict=ok"; exit 0; fi
echo "control_verdict=failed"
exit 1
