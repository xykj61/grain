#!/bin/sh
# tools/fixtures/dated_spelling_control.sh -- proves tools/fixtures/dated_spelling_scan.sh from
# both sides, on real git repositories built in a throwaway pen.
#
# A guard proven only in the passing direction cannot be told apart from a guard that reads
# nothing at all, so every refusal below is planted and watched, and every honest spelling is
# planted beside it and watched to go free.
#
#   sh tools/fixtures/dated_spelling_control.sh
#
# Run from the repository root. Driven by tools/d/dated_spelling_witness.rish.

set -u

ROOT=$(pwd)
SCAN="$ROOT/tools/fixtures/dated_spelling_scan.sh"
pen=$(mktemp -d) || exit 1
trap 'rm -rf "$pen"' EXIT

fails=0
ok() { echo "case=$1 ok"; }
bad() { echo "case=$1 RED -- $2"; fails=$((fails + 1)); }

new_repo() {
  d="$pen/$1"
  mkdir -p "$d"
  git -C "$d" init -q 2>/dev/null
  git -C "$d" config user.email pen@example.invalid
  git -C "$d" config user.name pen
  echo "$d"
}

# The narrow spellings are assembled from pieces here on purpose: written whole, this control
# would plant them in its own source, and its own source is exempt by basename -- which would
# make the exemption, rather than the plant, the thing being proven.
D8='[0-9]{8}'
D6='[0-9]{6}'
E8='[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'
E6='[0-9][0-9][0-9][0-9][0-9][0-9]'
Y4='2026[0-9]{4}'
U='_'

run_scan() { ( cd "$1" && sh "$SCAN" 2>&1 ); }

# ---- 1. the interval form, refused -----------------------------------------------------------
d=$(new_repo interval)
printf "grep -E '%s-%s%s'\n" "$D8" "$D6" "$U" > "$d/t.sh"
git -C "$d" add -A >/dev/null 2>&1
out=$(run_scan "$d")
case "$out" in
  *a_dated_pattern_requires_the_sprig*) ok interval_form_bitten ;;
  *) bad interval_form_bitten "the interval spelling went free: $out" ;;
esac
case "$out" in
  *"t.sh"*) ok offender_named ;;
  *) bad offender_named "the refusal named no file: $out" ;;
esac

# ---- 2. the year-anchored form, refused -------------------------------------------------------
d=$(new_repo yearform)
printf "grep -E '%s-%s%s'\n" "$Y4" "$D6" "$U" > "$d/t.sh"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *a_dated_pattern_requires_the_sprig*) ok year_form_bitten ;;
  *) bad year_form_bitten "the year-anchored spelling went free" ;;
esac

# ---- 3. the eight-fold explicit form, refused -------------------------------------------------
d=$(new_repo explicit)
printf "awk '/^%s-%s%s/'\n" "$E8" "$E6" "$U" > "$d/t.awk"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *a_dated_pattern_requires_the_sprig*) ok explicit_form_bitten ;;
  *) bad explicit_form_bitten "the eight-fold spelling went free" ;;
esac

# ---- 4. the class spelling, free --------------------------------------------------------------
d=$(new_repo klass)
printf "grep -E '%s-%s[%s.]'\n" "$D8" "$D6" "$U" > "$d/t.sh"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *one_shape_everywhere*) ok class_spelling_free ;;
  *) bad class_spelling_free "the [_.] class was refused, and it is the repair" ;;
esac

# ---- 5. the alternation spelling, free --------------------------------------------------------
d=$(new_repo alternation)
printf "rg '%s-%s(%s|\\\\.)'\n" "$D8" "$D6" "$U" > "$d/t.sh"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *one_shape_everywhere*) ok alternation_spelling_free ;;
  *) bad alternation_spelling_free "the (_|\\.) alternation was refused, and it is the repair" ;;
esac

# ---- 6. the optional-sprig spelling, free -----------------------------------------------------
d=$(new_repo optional)
printf "grep -oE '%s-%s(%sa-z+)?\\\\.md'\n" "$D8" "$D6" "$U" > "$d/t.sh"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *one_shape_everywhere*) ok optional_sprig_free ;;
  *) bad optional_sprig_free "the (_sprig)? option was refused, and it is the repair" ;;
esac

# ---- 7. dated testimony carrying the narrow pattern, free -------------------------------------
d=$(new_repo testimony)
mkdir -p "$d/session-logs"
printf "grep -E '%s-%s%s'\n" "$D8" "$D6" "$U" > "$d/session-logs/20260101-000000_a-record.sh"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *one_shape_everywhere*) ok testimony_free ;;
  *) bad testimony_free "a dated basename was measured, and testimony keeps every word it wrote" ;;
esac

# ---- 8. a SPRIGLESS dated basename carrying the narrow pattern, free too ----------------------
# The exemption must read its own subject. A guard that recognised testimony only when it wore a
# sprig would carry the very error it exists to catch.
d=$(new_repo testimony_sprigless)
mkdir -p "$d/session-logs"
printf "grep -E '%s-%s%s'\n" "$D8" "$D6" "$U" > "$d/session-logs/20260101-000000.sh"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *one_shape_everywhere*) ok sprigless_testimony_free ;;
  *) bad sprigless_testimony_free "a sprigless dated basename was measured as living" ;;
esac

# ---- 9. a stamp with no underscore after it, free ---------------------------------------------
d=$(new_repo bare_stamp)
printf 'TZ=America/New_York date +%%Y%%m%%d-%%H%%M%%S\n' > "$d/t.sh"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *one_shape_everywhere*) ok bare_stamp_free ;;
  *) bad bare_stamp_free "a stamp that is not a classification test was measured" ;;
esac

# ---- 10. an untracked file carrying the narrow pattern, free ----------------------------------
d=$(new_repo untracked)
printf 'placeholder\n' > "$d/kept.sh"
git -C "$d" add -A >/dev/null 2>&1
printf "grep -E '%s-%s%s'\n" "$D8" "$D6" "$U" > "$d/loose.sh"
case "$(run_scan "$d")" in
  *one_shape_everywhere*) ok untracked_free ;;
  *) bad untracked_free "an untracked file was measured; the corpus is what the tree tracks" ;;
esac

# ---- 11. a file kind nothing runs, free -------------------------------------------------------
d=$(new_repo prose)
printf "the elder pattern was '%s-%s%s' and it is recorded here\n" "$D8" "$D6" "$U" > "$d/note.md"
git -C "$d" add -A >/dev/null 2>&1
case "$(run_scan "$d")" in
  *one_shape_everywhere*) ok prose_free ;;
  *) bad prose_free "prose was measured as a tool" ;;
esac

# ---- 12. no git tree at all, told apart from a clean read -------------------------------------
d="$pen/nogit"
mkdir -p "$d"
case "$(run_scan "$d")" in
  *not_a_git_tree*) ok no_tree_told_apart ;;
  *) bad no_tree_told_apart "a directory with no git tree did not read distinctly" ;;
esac

if [ "$fails" -eq 0 ]; then
  echo "control=ok"
  exit 0
fi
echo "control=red fails=$fails"
exit 1
