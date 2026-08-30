#!/bin/sh
# tools/fixtures/b/borrowed_number_control.sh -- prove the borrowed-number reading on a planted
# tree, refusals and welcomes alike.
#
# WHAT THIS IS FOR. tools/fixtures/b/borrowed_number_scan.sh reads this tree and reports a number.
# A number is worth what its reading is worth, so this control builds real git repositories in a
# throwaway pen, plants each shape the reading claims to tell apart, and asserts what the scan
# says about it. Every welcome is asserted as hard as every refusal, because a refusal proven only
# in the passing direction cannot be told from a bypass -- and a guard that cannot red guards
# nothing.
#
#   sh tools/fixtures/b/borrowed_number_control.sh
#
# WHAT A PEN HOLDS. Six small files and an index. REDS %239 was a pen that filled the tmpfs and
# reddened four unrelated guards mid-run, so a pen here stays small and is removed on every exit
# path. No commit is made: `git ls-files` reads the index, so `git add` is the whole setup.
set -eu

root=$(git rev-parse --show-toplevel 2>/dev/null) || {
  echo "refused: not a git repository -- the control copies this tree's own scan into its pen" >&2
  exit 1
}
cd "$root"

SCAN="tools/fixtures/b/borrowed_number_scan.sh"
HELPER="tools/fixtures/s/shell_portable.sh"
[ -f "$SCAN" ] || { echo "refused: $SCAN is missing -- the control proves the scan, not a copy" >&2; exit 1; }
[ -f "$HELPER" ] || { echo "refused: $HELPER is missing" >&2; exit 1; }

pen=$(mktemp -d) || { echo "refused: no temporary directory" >&2; exit 1; }
trap 'rm -rf "$pen"' EXIT INT TERM

pass=0
fail=0

# check <name> <expected-exit> <expected-substring> -- run the pen's scan and judge one behaviour.
check() {
  _name=$1; _want_exit=$2; _want=$3; shift 3
  set +e
  _out=$( (cd "$pen/tree" && "$@") 2>&1 )
  _code=$?
  set -e
  if [ "$_code" -eq "$_want_exit" ] && printf '%s' "$_out" | grep -q "$_want"; then
    pass=$((pass + 1))
    echo "ok   $_name"
  else
    fail=$((fail + 1))
    echo "RED  $_name -- wanted exit $_want_exit and '$_want', got exit $_code"
    printf '%s\n' "$_out" | sed 's/^/       /'
  fi
}

mkdir -p "$pen/tree/tools/fixtures/b" "$pen/tree/tools/fixtures/s" "$pen/tree/docs" "$pen/tree/other"
cp "$SCAN" "$pen/tree/tools/fixtures/b/borrowed_number_scan.sh"
cp "$HELPER" "$pen/tree/tools/fixtures/s/shell_portable.sh"

# THE SUBJECTS. `subject.md` is the document a witness would want a fact about; `tiny.md` sits
# under the hundred-byte floor; `twin.md` exists twice so its bare basename identifies nothing.
awk 'BEGIN { for (i = 0; i < 20; i++) printf "the subject holds a line.\n" }' > "$pen/tree/docs/subject.md"
printf 'small\n' > "$pen/tree/docs/tiny.md"
printf 'twinned\n' > "$pen/tree/docs/twin.md"
printf 'twinned\n' > "$pen/tree/other/twin.md"

SUBJ_SIZE=$(wc -c < "$pen/tree/docs/subject.md" | tr -d ' ')
TINY_SIZE=$(wc -c < "$pen/tree/docs/tiny.md" | tr -d ' ')
if command -v sha256sum >/dev/null 2>&1; then
  SUBJ_SHA=$(sha256sum "$pen/tree/docs/subject.md" | cut -d' ' -f1)
else
  SUBJ_SHA=$(shasum -a 256 "$pen/tree/docs/subject.md" | cut -d' ' -f1)
fi

# ONE SOURCE PER BEHAVIOUR, so a red names the shape that broke rather than a file holding six.
printf 'assert out contains "docs/subject.md holds %s B" else "borrowed count"\n' "$SUBJ_SIZE" \
  > "$pen/tree/tools/borrow_count.rish"
printf '# the subject is docs/subject.md, named here and nowhere else\nassert out contains "digest %s" else "borrowed digest"\n' "$SUBJ_SHA" \
  > "$pen/tree/tools/borrow_digest_in_comment.rish"
printf 'let n = run ["sh" "-c" "wc -c < docs/subject.md"]\nassert out contains "docs/subject.md holds ${n.out} B" else "repaired"\n' \
  > "$pen/tree/tools/repaired.rish"
printf 'assert out contains "docs/subject.md holds 999999 B" else "no subject has this size"\n' \
  > "$pen/tree/tools/wrong_number.rish"
printf 'assert out contains "some run wrote %s bytes" else "no path named here"\n' "$SUBJ_SIZE" \
  > "$pen/tree/tools/number_without_subject.rish"
printf 'assert out contains "docs/subject.md was read" else "the size is only in the message: %s"\n' "$SUBJ_SIZE" \
  > "$pen/tree/tools/size_in_else.rish"
printf 'assert out contains "docs/tiny.md holds %s B" else "under the floor"\n' "$TINY_SIZE" \
  > "$pen/tree/tools/under_floor.rish"
printf 'assert out contains "twin.md holds %s B" else "an ambiguous basename"\n' "$SUBJ_SIZE" \
  > "$pen/tree/tools/ambiguous_basename.rish"

( cd "$pen/tree" && git init -q . && git add -A ) >/dev/null 2>&1

# THE READING, once, so every behaviour below is judged against one measurement.
sites=$( (cd "$pen/tree" && BORROWED_NUMBER_CEILING=99 sh tools/fixtures/b/borrowed_number_scan.sh list) 2>&1 )
echo "$sites" | sed 's/^/pen  /'

say_site() { printf '%s' "$sites" | grep -q "site $1"; }

judge() {
  _name=$1; _want=$2; _pat=$3
  if [ "$_want" = found ]; then
    if say_site "$_pat"; then pass=$((pass + 1)); echo "ok   $_name"
    else fail=$((fail + 1)); echo "RED  $_name -- wanted a site at $_pat"; fi
  else
    if say_site "$_pat"; then fail=$((fail + 1)); echo "RED  $_name -- $_pat was counted and should not be"
    else pass=$((pass + 1)); echo "ok   $_name"; fi
  fi
}

judge "a borrowed byte count is found"                    found     "tools/borrow_count.rish"
judge "a borrowed digest named in a comment is found"     found     "tools/borrow_digest_in_comment.rish"
judge "the read-and-interpolate repair is not counted"    not-found "tools/repaired.rish"
judge "a number matching no subject is not counted"       not-found "tools/wrong_number.rish"
judge "a size with no path named beside it is free"       not-found "tools/number_without_subject.rish"
judge "a size only in the else message is free"           not-found "tools/size_in_else.rish"
judge "a subject under the hundred-byte floor is free"    not-found "tools/under_floor.rish"
judge "an ambiguous bare basename binds nothing"          not-found "tools/ambiguous_basename.rish"

# THE CEILING, from both sides on one pen, so the two readings differ only in the ceiling.
check "two planted sites refuse at a ceiling of one" 1 "verdict=over_ceiling" \
  env BORROWED_NUMBER_CEILING=1 sh tools/fixtures/b/borrowed_number_scan.sh
check "the same two pass at a ceiling of two"        0 "verdict=ok" \
  env BORROWED_NUMBER_CEILING=2 sh tools/fixtures/b/borrowed_number_scan.sh

# THE PLANT, which is how the witness proves the ceiling on the real tree.
check "prove-red plants a third site and refuses"    1 "verdict=over_ceiling" \
  env BORROWED_NUMBER_CEILING=2 sh tools/fixtures/b/borrowed_number_scan.sh prove-red
check "prove-red passes one ceiling higher"          0 "verdict=ok" \
  env BORROWED_NUMBER_CEILING=3 sh tools/fixtures/b/borrowed_number_scan.sh prove-red

# THE VACUUM. A reading that reaches no sources must refuse rather than print a green zero. This
# leg found a real defect the day it was written: `grep -c` prints 0 AND exits 1, so an `|| echo 0`
# beside it made the count two lines long and the guard answered verdict=ok on an empty list.
check "an empty source list refuses"                 1 "verdict=no_sources" \
  sh tools/fixtures/b/borrowed_number_scan.sh prove-vacuum

# THE FLOOR OF THE READING ITSELF: outside a repository there is no tracked set, so there is no
# honest answer and the scan says so rather than reading the filesystem.
check "outside a git repository the scan refuses"    1 "refused: not a git repository" \
  env GIT_CEILING_DIRECTORIES="$pen" sh -c 'cd "$(mktemp -d)" && sh '"$pen"'/tree/tools/fixtures/b/borrowed_number_scan.sh'

echo "borrowed_number_control: pass=$pass fail=$fail"
if [ "$fail" -gt 0 ]; then
  echo "verdict=control_red"
  exit 1
fi
echo "verdict=control_green"
